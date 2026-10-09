# Lab 23 — The outside world fails

## Story

Every new order should trigger a notification to the kitchen's
delivery-tracking service. That service is real, external, and — like
every external service — sometimes doesn't answer on the first try.

## Learning objectives

After this lab you should be able to:

- Wrap an unreliable call in a retry policy with a maximum attempt
  count and a fixed delay between attempts.
- Test retry logic without a real network, using a fake that fails on
  demand, and without a real wait, by controlling the delay from the
  test.
- Explain why the order is still created even when the notification
  ultimately fails.

This is **bounded retry with a fixed delay** — not exponential
backoff. The delay between attempts is always the same number; it
never grows. Exponential backoff is a real technique, but it's not
what this lab practices.

## Before you start

### Python

- Lab 22 complete: orders persist in SQLite, `notes` migration works.
- Current directory: `examples/order-api/python/`.

### Go

- Lab 22 complete: orders persist in SQLite, `notes` migration works.
- Current directory: `examples/order-api/go/`.

### Java

- Lab 22 complete: orders persist in SQLite, `notes` migration works.
- Current directory: `examples/order-api/java/`.

## Your task

Every track follows the same policy: at most 3 attempts by default; a
0.2-second (200ms) delay between attempts, but never after the last
one; success ends the retry immediately; once every attempt is
exhausted, the failure is returned to the caller; only a recognized
notification failure is retried — anything else isn't.

### Step 1 — define a recognizable notification failure

#### Python

Create `kitchen_client.py` with `class NotifierError(Exception): pass`.

#### Go

Create `notifier.go` with a sentinel error:
`var ErrNotification = errors.New("kitchen notification failed")`.
Only errors matching this one (checked with `errors.Is`) should be
retried — anything else is an unexpected bug, not a flaky dependency,
and should propagate immediately instead of being retried 3 times.

#### Java

Create `NotificationException.java` with a dedicated checked
exception:

```java
public class NotificationException extends Exception {
    public NotificationException(String message) {
        super(message);
    }

    public NotificationException(String message, Throwable cause) {
        super(message, cause);
    }
}
```

### Step 2 — write the bounded-retry function

#### Python

In `kitchen_client.py`, write
`call_with_retries(send_fn, max_attempts: int = 3, backoff_seconds:
float = 0.2) -> None`: call `send_fn()`; if it raises `NotifierError`,
wait `backoff_seconds` and try again, up to `max_attempts` total
attempts; if every attempt fails, re-raise the last error. The
production call site (Step 4) calls this with no `backoff_seconds`
override, so it actually waits `0.2` seconds between attempts — a
retry policy that never waits isn't teaching a delay, it's just
teaching "try three times instantly."

#### Go

First, define the minimal contract a notification call has to satisfy
— in Go, that's simply a function returning `error`, nothing more. In
`notifier.go`, write:

```go
func callWithRetries(send func() error, maxAttempts int, backoff time.Duration) error
```

Call `send()`; if it returns an error matching `ErrNotification`
(`errors.Is`), wait `backoff` and try again, up to `maxAttempts` total
attempts; if `send()` returns any other error, return it immediately
without retrying; if every attempt is exhausted, return the last
error. There's no exception mechanism to translate here —
`err := send()` **is** the natural Go way to report the failure this
lab is about; don't invent a parallel structure that imitates Python's
`try`/`except`.

Also add the production notifier itself as a package-level variable,
not a plain function — this is what lets Step 4's test replace it with
a fake, and what the production code calls through:

```go
var notifyKitchen = func(orderID string) error {
    return nil // no real delivery service to call yet
}
```

And the production defaults, as a `const` and a `var` (not two
`const`s — Step 4 needs to override the delay from a test, and only a
`var` can be reassigned):

```go
const defaultMaxAttempts = 3

var notificationBackoff = 200 * time.Millisecond
```

#### Java

The minimal contract a notification call has to satisfy, as a
functional interface in `KitchenNotifier.java`:

```java
@FunctionalInterface
public interface KitchenNotifier {
    void send(String orderId) throws NotificationException;
}
```

Then, in `RetryingNotifier.java`:

```java
public final class RetryingNotifier {
    public static void callWithRetries(
            KitchenNotifier notifier, String orderId, int maxAttempts, long backoffMillis)
            throws NotificationException {
        // ...
    }
}
```

Call `notifier.send(orderId)`; on a caught `NotificationException`,
wait `backoffMillis` (via `Thread.sleep`) and try again, up to
`maxAttempts` total attempts; if every attempt fails, throw the last
exception. If you use `Thread.sleep`, you must catch
`InterruptedException` explicitly and handle it — call
`Thread.currentThread().interrupt()` to restore the interrupt flag,
then stop retrying (for example by wrapping it in a
`NotificationException` and throwing that). An empty `catch
(InterruptedException e) {}` silently throws away a signal that the
JVM is trying to shut this thread down — never do that.

Don't reach for Spring Retry, Resilience4j, or a dependency-injection
framework. This is a small, focused class — not a reusable retry
library, and not a reason to build an abstraction hierarchy you don't
need yet.

### Step 3 — three tests for the retry policy itself

Write these as new tests, independent of the HTTP server. Each one
must assert the exact number of calls, not just the final outcome —
a retry policy that calls the wrong number of times but happens to
return the right answer is still broken.

**A. Immediate success** — the fake never fails; exactly one call
happens; no retry occurs.

**B. Recovery after a transient failure** — the fake fails on its
first two calls, then succeeds; exactly three calls happen; the
operation ends in success.

**C. Exhaustion** — the fake always fails; with `max_attempts=3`,
exactly three calls happen; the failure is returned (raised/thrown) to
the caller.

#### Python

In `tests/test_kitchen_client.py`, write a `FlakyClient` test helper —
a class with a `send(self)` method that raises `NotifierError` for its
first `fail_times` calls, then succeeds, tracking how many times it
was called:

```python
class FlakyClient:
    def __init__(self, fail_times: int) -> None:
        self.fail_times = fail_times
        self.calls = 0

    def send(self) -> None:
        self.calls += 1
        if self.calls <= self.fail_times:
            raise NotifierError("delivery service unavailable")
```

Write the three tests against it, using `backoff_seconds=0` so they
run instantly instead of actually waiting.

#### Go

In `notifier_test.go`, write a `flakyClient` test helper with the same
shape — a `calls int` field and a `send() error` method that returns
`ErrNotification` for its first `failTimes` calls, then `nil`. Write
the three tests against `callWithRetries`, passing `0` as the
`backoff` argument so they run instantly.

#### Java

In `RetryingNotifierTest.java`, write a `FlakyNotifier` test helper
implementing `KitchenNotifier`, with the same shape. Write the three
tests against `RetryingNotifier.callWithRetries`, passing `0` as
`backoffMillis` so they run instantly.

### Step 4 — wire the notification into order creation, and prove failure doesn't break it

The notification only happens **after** the order is already persisted
in SQLite — never before, and never instead of it:

```text
POST /orders
    ↓
validate request
    ↓
persist order in SQLite
    ↓
attempt kitchen notification
    ↓
notification succeeds OR retry exhausts
    ↓
HTTP 201
```

If persistence fails, don't pretend it succeeded, and don't attempt
the notification at all. If persistence succeeds but every
notification attempt fails: `POST` still returns `201`; the order
stays in the database; `GET /orders/{id}` still returns it; the number
of notification attempts is still bounded at `max_attempts`. The
response body and status codes from Lab 22 don't change — no new
`notification_status` field, no new status code. This is a real
trade-off, not a free win: the business operation (creating the order)
succeeded, but the notification may never have reached the kitchen.
That's not the same as a guaranteed-delivery system, and this lab
doesn't build one — it builds the boundary that keeps a secondary
failure from undoing a primary success.

#### Python

In `api.py`, add a `notify_kitchen(order_id: str) -> None` function
(for now, just `pass` — you don't have a real delivery service to call).
In `do_POST`, right after an order is successfully created, call it
through your retry wrapper:
`call_with_retries(lambda: notify_kitchen(order["order_id"]))`,
catching `NotifierError` so a failed notification doesn't fail the
whole request.

#### Go

In `api.go`'s `handleCreateOrder`, right after `createOrder` succeeds,
call your notifier through the retry wrapper:

```go
err = callWithRetries(func() error {
    return notifyKitchen(order.OrderID)
}, defaultMaxAttempts, notificationBackoff)
```

Its returned error only tells you every attempt failed — it's already
been through the retry loop, so there's nothing left to undo. Don't
fail the request because of it.

#### Java

Give `ApiServer` a `KitchenNotifier` field and two constructors: a
no-arg one used by `Main` (defaulting to a stub that does nothing,
`orderId -> { }`, using the default 200ms backoff), and one that
accepts a `KitchenNotifier` and a `backoffMillis` — this second one is
what Step 4's test below uses to inject a failing fake *and* skip the
real delay in the same step:

```java
public ApiServer() {
    this(orderId -> { /* no real delivery service to call yet */ });
}

public ApiServer(KitchenNotifier notifier) {
    this(notifier, 200L);
}

public ApiServer(KitchenNotifier notifier, long notificationBackoffMillis) {
    this.notifier = notifier;
    this.notificationBackoffMillis = notificationBackoffMillis;
}
```

In `handleCreateOrder`, right after `OrderDb.createOrder` succeeds,
call `RetryingNotifier.callWithRetries(notifier, order.orderId, 3,
notificationBackoffMillis)`, catching `NotificationException` so a
failed notification doesn't fail the whole request. Add a matching
`createServer(int port, ApiServer handler)` overload next to the
existing `createServer(int port)`, so a test can build a server around
a specific `ApiServer` instance instead of always getting the default
one.

Now add the fourth, mandatory test — this one drives the real HTTP
path, not just the retry function in isolation. None of Step 3's tests
would catch a wiring bug where a notification failure accidentally
aborted the whole request; only a real request through the real
handler, hitting the real (temporary, per-test) SQLite file, would.

#### Python

Add one more test in `tests/test_api.py`:

- Use `monkeypatch` to replace `api.notify_kitchen` with a fake that
  always raises `NotifierError`, and to replace `time.sleep` with a
  no-op so the test doesn't actually wait through the retries.
- `POST` an order through the real server. Assert the response is
  still `201`.
- `GET` that same order afterward and assert it's still there.
- Assert your fake was called exactly `max_attempts` times (3).

#### Go

Add one more test in `api_test.go`:

- Temporarily reassign the package-level `notifyKitchen` to a fake
  that always returns `ErrNotification` and counts its calls, and
  temporarily reassign `notificationBackoff` to `0` — both restored
  with `defer` at the end of the test. This is the Go equivalent of
  Python's `monkeypatch`: a plain variable reassignment, restored when
  the test ends.
- `POST` an order through the `httptest.Server`. Assert the response
  is still `201`.
- `GET` that same order afterward and assert it's still there.
- Assert your fake was called exactly `defaultMaxAttempts` times.

#### Java

Add one more test in `ApiServerTest.java`:

- Build a fake `KitchenNotifier` that always throws
  `NotificationException` and counts its calls.
- Stop the server your `@BeforeEach` started, and start a new one from
  `ApiServer.createServer(0, new ApiServer(fakeNotifier, 0))` — the
  `0` for `backoffMillis` is what keeps this test from actually
  waiting ~0.4 real seconds.
- `POST` an order through the real HTTP client. Assert the response is
  still `201`.
- `GET` that same order afterward and assert it's still there.
- Assert your fake was called exactly 3 times.

### Step 5 — branch, PR, review, merge

Do this lab's work on a branch (for example
`feature/outside-world-fails`), push it, and open a pull request.
Merge only once CI is green — same loop as Labs 21 and 22.

## Acceptance criteria

- A recognizable notification failure exists (`NotifierError` /
  `ErrNotification` / `NotificationException`), and a bounded-retry
  function built around it defaults to 3 attempts and a 0.2s
  (200ms) delay between attempts, never after the last one.
- All three retry-behavior tests pass, and each asserts the exact
  call count, not just the final outcome.
- Order creation still succeeds (`201`) even though the kitchen
  notification is only a stub.
- A real HTTP-level test proves an order is created and remains
  fetchable even when notification delivery fails on every attempt —
  this can't be satisfied by testing the retry function alone.
- That HTTP-level test runs instantly — no test in this lab actually
  waits through a real delay.
- This lab's changes were merged through a pull request with a green
  CI check, not committed directly to `main`.

## Verification

### Python

```bash
cd examples/order-api/python
uv run pytest -v
cd -
```

### Go

```bash
cd examples/order-api/go
go test ./... -v
cd -
```

### Java

```bash
cd examples/order-api/java
./gradlew test
cd -
```

Expected: all tests pass (9 total: 5 from Labs 21-22, 3 retry-behavior
tests, and the new failure-path integration test).

## Think about it

- Your tests never wait for real (`backoff_seconds=0` / `backoff: 0` /
  `backoffMillis: 0`), even though the real function supports a delay.
  Why is that the right trade-off for a test, and the wrong trade-off
  for production?
- The order is created in the database *before* the notification is
  attempted, and a notification failure doesn't undo it. What would go
  wrong if you'd built it the other way around — notify first, then
  create the order only if the notification succeeded?
- Go and Java both needed an explicit, overridable place to control
  the retry delay for tests (a reassignable `var`, or a constructor
  parameter). Python's test used `monkeypatch` to replace `time.sleep`
  itself instead. Why doesn't Go or Java have an equivalent to
  `monkeypatch`, and what does that tell you about the trade-offs of a
  dynamically-typed language with mutable module state versus a
  statically-typed, compiled one?

## If you get stuck

### Python

- **Hint 1:** `call_with_retries` needs a loop from `1` to
  `max_attempts` inclusive, a `try`/`except NotifierError`, and a
  `return` on success.
- **Hint 2:** `FlakyClient` needs to count its own calls
  (`self.calls += 1`) so your tests can assert on how many times
  `send_fn` actually ran.
- **Hint 3:** The lambda `lambda: notify_kitchen(order["order_id"])`
  lets `call_with_retries` call `notify_kitchen` with the right
  argument each retry, without `call_with_retries` needing to know
  anything about `notify_kitchen`'s signature.
- **Hint 4:** `monkeypatch.setattr(api, "notify_kitchen", your_fake)`
  replaces the function `do_POST` actually calls, the same way
  Lab 22's fixture used `monkeypatch.setattr(db, "DB_PATH", ...)` to
  redirect a module-level name. `monkeypatch.setattr(time, "sleep",
  lambda seconds: None)` (with `import time` at the top of the test
  file) does the same for the wait between attempts.

### Go

- **Hint 1:** `errors.Is(err, ErrNotification)` is `true` only when
  `err` is (or wraps) `ErrNotification` specifically — an unrelated
  error from a bug elsewhere won't match, and `callWithRetries` should
  return it immediately instead of retrying it.
- **Hint 2:** `flakyClient` needs a `calls int` field incremented at
  the top of `send()`, before deciding whether to fail.
- **Hint 3:** A closure captures `order.OrderID` for you —
  `func() error { return notifyKitchen(order.OrderID) }` is a value
  `callWithRetries` can call repeatedly without knowing anything about
  `notifyKitchen`'s signature.
- **Hint 4:** Reassigning `notifyKitchen` and `notificationBackoff` in
  a test only works because they're package-level `var`s, not
  `const`s or local to `main`. Always restore the original value with
  `defer` before the test ends, or you'll leak a fake notifier into
  whichever test happens to run next.

### Java

- **Hint 1:** A lambda like `orderId -> { throw new
  NotificationException("boom"); }` is a complete `KitchenNotifier` —
  Java's functional interfaces let a one-line lambda stand in for an
  entire fake implementation.
- **Hint 2:** `FlakyNotifier` needs an `int calls` field incremented
  at the top of `send(...)`, before deciding whether to throw.
- **Hint 3:** `Thread.currentThread().interrupt()` inside a `catch
  (InterruptedException e)` block restores the interrupt flag that
  `Thread.sleep` cleared when it was interrupted — skipping this means
  the rest of your program can never tell this thread was asked to
  stop.
- **Hint 4:** The three-argument `ApiServer(KitchenNotifier, long)`
  constructor exists specifically so a test can set `backoffMillis` to
  `0` — without it, the HTTP failure-path test would really wait
  roughly 2 × 200ms per run.

## What's next

Notifications can fail silently right now — nothing records that they
happened, or that they didn't. Next, you give the system a way to
explain itself after the fact.

Continue to [Lab 24 — Production says "it does not work"](../24-production-says-it-doesnt-work/README.md).
