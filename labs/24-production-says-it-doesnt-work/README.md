# Lab 24 — Production says "it does not work"

## Story

A user reports: "I tried to check my order and got nothing." The
process is still running. There's no error on your screen. You have no
idea which order, or what actually happened, because nothing was ever
written down.

## Learning objectives

After this lab you should be able to:

- Add leveled log messages (`INFO`/`WARNING`/`ERROR` — or your
  language's closest equivalents) at the moments that matter in a
  request's lifecycle.
- Include enough context (an order id, an attempt number) in a log
  record to trace one specific request's story.
- Test that a log record was actually produced, by capturing it
  programmatically instead of eyeballing terminal output.
- Keep logging *configuration* (done once, at startup) separate from
  logging *use* (scattered through the code wherever something worth
  recording happens).

Java's standard logging API spells its most severe level `SEVERE`, not
`ERROR` — that's the accepted equivalent in this lab, not a deviation
from it. Go's `log/slog` renders its warning level as `WARN` in
output, not `WARNING` — same situation.

## Before you start

### Python

- Lab 23 complete: `call_with_retries` and `notify_kitchen` exist and
  are wired into `do_POST`.
- Current directory: `examples/order-api/python/`.

### Go

- Lab 23 complete: `callWithRetries` and `notifyKitchen` exist and are
  wired into `handleCreateOrder`.
- Current directory: `examples/order-api/go/`.

### Java

- Lab 23 complete: `RetryingNotifier` and `KitchenNotifier` exist and
  are wired into `handleCreateOrder`.
- Current directory: `examples/order-api/java/`.

## Your task

The events every track must log, and at what level:

| Event | Level |
|---|---|
| Order created | INFO |
| Request for a nonexistent order | WARNING |
| One failed notification attempt | WARNING |
| All notification attempts exhausted | ERROR (`SEVERE` in Java) |

Never log the full contents of `items` or `notes` — a count of items
is enough for this lab. Don't log secrets, tokens, or anything else a
real production system wouldn't want sitting in a log file. A log
record should let you answer: what happened, when, at what level, and
— whenever an id is available — which order it was about.

### Step 1 — configure logging once, at startup

#### Python

Add `import logging` and `logger = logging.getLogger("order_api")`
near the top of `api.py`. In `run()`, configure logging once with
`logging.basicConfig`, including the timestamp, level, and logger name
in the format — never inside a request handler, and never at import
time, or every request (or every test import) would reconfigure it
again.

#### Go

`log/slog`'s default logger already works without any setup, but this
lab wants you to configure it explicitly, once, in `main()` — not
scattered across every file that happens to log something:

```go
slog.SetDefault(slog.New(slog.NewTextHandler(os.Stdout, nil)))
```

#### Java

Create `LoggingConfig.java` with a single `configure()` method, called
once from `Main`, before anything else happens. Remove whatever
handlers the root logger already has (so you don't end up with every
line printed twice — once by your handler, once by `java.util.logging`'s
own default), then attach exactly one `ConsoleHandler` with a
`SimpleFormatter`:

```java
public static void configure() {
    Logger root = Logger.getLogger("");
    for (Handler handler : root.getHandlers()) {
        root.removeHandler(handler);
    }
    ConsoleHandler handler = new ConsoleHandler();
    handler.setFormatter(new SimpleFormatter());
    handler.setLevel(Level.ALL);
    root.addHandler(handler);
    root.setLevel(Level.INFO);
}
```

No SLF4J, no Log4j, no extra dependency — `java.util.logging` is
already part of the JDK.

### Step 2 — log order creation at INFO

#### Python

In `do_POST`, right after an order is created, log at `INFO`: include
the order id and how many items it has.

#### Go

In `handleCreateOrder`, right after `createOrder` succeeds, log at
`Info`, with the order id and item count as named attributes (not
baked into the message string):

```go
slog.Info("order created", "order_id", order.OrderID, "item_count", len(items))
```

#### Java

Add `private static final Logger LOGGER =
Logger.getLogger("order_api");` to `ApiServer`. Right after
`OrderDb.createOrder` succeeds, log at `INFO`, with the order id and
item count as parameters:

```java
LOGGER.log(Level.INFO, "order {0} created with {1} items",
        new Object[] {order.orderId, items.size()});
```

### Step 3 — log a missing order at WARNING

#### Python

In `do_GET`, when an order isn't found, log at `WARNING`: include the
order id that was requested.

#### Go

In `handleGetOrder`, when `getOrder` reports "not found", log at
`Warn` with the requested id as a named attribute:
`slog.Warn("order not found", "order_id", id)`.

#### Java

In `ApiServer`'s `handleGetOrder`, when `OrderDb.getOrder` returns
`null`, log at `WARNING` with the requested id:
`LOGGER.log(Level.WARNING, "order {0} not found", id)`.

### Step 4 — log retry diagnostics

This goes inside the retry function you already built in Lab 23 — you
aren't writing new retry logic here, just adding visibility into logic
that already exists.

#### Python

In `kitchen_client.py`, add `logger = logging.getLogger
("kitchen_client")`. In `call_with_retries`, log a `WARNING` on each
failed attempt (include the attempt number and the error), and an
`ERROR` if every attempt is exhausted.

#### Go

In `notifier.go`, inside `callWithRetries`, log a `Warn` on each
retried failure (include the attempt number and the error as named
attributes), and an `Error` once, only after every attempt is
exhausted:

```go
slog.Warn("notification attempt failed", "attempt", attempt, "error", err)
// ... and, once, after the loop:
slog.Error("notification failed after attempts", "attempts", maxAttempts)
```

#### Java

Add `private static final Logger LOGGER =
Logger.getLogger("kitchen_notifier");` to `RetryingNotifier`. Inside
`callWithRetries`, log a `WARNING` on each retried failure (include
the attempt number and the exception message), and a `SEVERE` once,
only after every attempt is exhausted:

```java
LOGGER.log(Level.WARNING, "notification attempt {0} failed: {1}",
        new Object[] {attempt, e.getMessage()});
// ... and, once, after the loop:
LOGGER.log(Level.SEVERE, "notification failed after {0} attempts", maxAttempts);
```

### Step 5 — route the startup announcement through your logger

Now that logging is configured, the line announcing the server is
ready is exactly the kind of operational detail this lab is about —
not user-facing output someone's meant to read from a CLI tool.

#### Python

Replace the `print(...)` that announces the server is listening with
`logger.info(...)`.

#### Go

Replace the line that announces the server is listening with
`slog.Info("order-api listening on http://" + addr)`. Its exact
on-screen shape changes (it now has the handler's timestamp/level
prefix in front of it), but the text itself — including the full
`http://host:port`, the part Lab 21 told you to watch for — is still
right there in the line.

#### Java

Replace the line that announces the server is listening with
`LOGGER.info("order-api listening on http://localhost:" + port)`
(using the same `"order_api"` logger from Step 2). Same trade-off as
Go: the surrounding format changes, the message itself doesn't.

### Step 6 — write two tests that capture log records

Capture the record programmatically and assert on its level and
content — never assert on the exact rendered line (timestamps make
that unreliable), and never just eyeball terminal output as your only
check.

#### Python

Using pytest's `caplog` fixture, write two tests: one confirming that
creating an order produces an `INFO` log record; one confirming that
requesting a missing order produces a `WARNING` record.

#### Go

Point `slog`'s default logger at a `bytes.Buffer` using a JSON handler
for the duration of the test (restoring the original default
afterward), make the request, then check the buffer's content:

```go
var buf bytes.Buffer
original := slog.Default()
slog.SetDefault(slog.New(slog.NewJSONHandler(&buf, nil)))
defer slog.SetDefault(original)
```

Write two tests: one confirming a `POST` produces a record with
`"level":"INFO"` and an `order_id` field; one confirming a `GET` for a
missing order produces a record with `"level":"WARN"` and the
requested id in it.

#### Java

Using the small `ListLogHandler` you write for this (a `Handler`
subclass that appends every `LogRecord` it receives to a list instead
of printing it), attach it to `Logger.getLogger("order_api")` before
the request and remove it afterward:

```java
class ListLogHandler extends Handler {
    final List<LogRecord> records = new ArrayList<>();

    @Override public void publish(LogRecord record) { records.add(record); }
    @Override public void flush() { }
    @Override public void close() { }
}
```

Write two tests: one confirming a `POST` produces a record at
`Level.INFO`; one confirming a `GET` for a missing order produces a
record at `Level.WARNING` whose parameters include the requested id
(`record.getParameters()`).

### Step 7 — read your own logs by hand

Run the server by hand, make a couple of requests (including one for a
missing order), and read the log output in your terminal. Confirm you
can tell what happened without opening your source file.

### Step 8 — branch, PR, review, merge

Do this lab's work on a branch (for example
`feature/production-logging`), push it, and open a pull request. Merge
only once CI is green — same loop as the rest of Act V.

## Acceptance criteria

- Logging is configured exactly once, at startup — not per request,
  not at import/class-load time.
- Order creation logs at INFO with the order id; a missing order logs
  at WARNING with the requested id; a retry failure logs at WARNING,
  and exhausting all retries logs once at ERROR/SEVERE.
- Two log-capturing tests pass, confirming the INFO and WARNING cases
  from Step 6.
- No `print`/`fmt.Println`/`System.out.println` stands in for an
  operational log in this lab's code.
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

Expected: all tests pass (11 total: 9 from Labs 21-23, plus the two
new logging tests).

## Think about it

- You could have used `print()`/`fmt.Println`/`System.out.println`
  everywhere instead of a logging library. What do you lose by doing
  that — specifically, what could your log-capturing test check about
  a leveled log call that it couldn't check about plain console
  output?
- Why does a retry failure log at WARNING on *every* attempt, but
  ERROR/SEVERE only *once*, at the end, instead of on every failed
  attempt?
- `java.util.logging` calls its most severe built-in level `SEVERE`;
  Go's `slog` renders its warning level as `WARN`. Neither matches the
  table at the top of this lab character-for-character. Why is that
  fine here, and what would you actually look for in a language's
  logging API to decide whether a level name is "close enough"?

## If you get stuck

### Python

- **Hint 1:** `logging.getLogger(name)` returns the same logger object
  every time it's called with the same `name` — that's how `api.py`
  and its tests can both refer to `"order_api"` and see the same
  configuration.
- **Hint 2:** `caplog.at_level(logging.INFO, logger="order_api")` as a
  context manager captures only records at `INFO` or above, from that
  specific logger, for the code inside the `with` block.
- **Hint 3:** `logger.info("order %s created with %d items", order_id,
  count)` — pass values as separate arguments, not with an f-string;
  this lets `logging` skip the formatting work entirely when the log
  level is disabled.

### Go

- **Hint 1:** `slog.Info`/`slog.Warn`/`slog.Error` take a message
  string followed by alternating key/value pairs —
  `slog.Warn("notification attempt failed", "attempt", attempt,
  "error", err)` produces one structured record, not a hand-formatted
  string.
- **Hint 2:** `slog.NewJSONHandler(&buf, nil)` writes one JSON object
  per line to whatever `io.Writer` you give it — a `*bytes.Buffer`
  works, and `strings.Contains(buf.String(), ...)` is enough to check
  for a field without a full JSON parse.
- **Hint 3:** `slog.SetDefault` is global, process-wide state — a test
  that changes it and forgets to restore it will leak into whichever
  test runs next. Always pair the `SetDefault` call with a `defer` that
  restores the previous default.

### Java

- **Hint 1:** `Logger.getLogger(name)` returns the same logger
  instance every time it's called with the same name — the same
  identity-by-name behavior as Python's `logging.getLogger`.
- **Hint 2:** A `Handler` only needs `publish`, `flush`, and `close`
  implemented — `publish` is called once per log record that reaches
  it, so appending to a `List<LogRecord>` there is enough to capture
  everything for a test.
- **Hint 3:** `LogRecord.getParameters()` returns the `Object[]` you
  passed as the second argument to `LOGGER.log(Level, String,
  Object[])` — that's how a test can check the *id itself* was logged,
  not just that some `WARNING` happened.
- **Hint 4:** Remove the handler you added in `@BeforeEach`/the test
  itself when you're done with it (`logger.removeHandler(handler)`) —
  otherwise it keeps accumulating records from every later test that
  touches the same logger.

## What's next

You have tests, review, CI, and now logs, in whichever track you
followed — Python, Go, and Java all keep going from here, the same way
they have since Lab 21. Next, you have to decide what "this version"
even means when you hand it to someone else.

Continue to [Lab 25 — Release and compatibility](../25-release-and-compatibility/README.md).
