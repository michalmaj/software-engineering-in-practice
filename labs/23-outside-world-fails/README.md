# Lab 23 — The outside world fails

## Story

Every new order should trigger a notification to the kitchen's
delivery-tracking service. That service is real, external, and — like
every external service — sometimes doesn't answer on the first try.

## Learning objectives

After this lab you should be able to:

- Wrap an unreliable call in a retry policy with a maximum attempt
  count.
- Test retry logic without a real network, using a fake that fails on
  demand.
- Explain why the order is still created even when the notification
  ultimately fails.

## Before you start

- Lab 22 complete: orders persist in SQLite, `notes` migration works.
- Current directory: `examples/order-api/`.

## Your task

1. Create `kitchen_client.py` with `class NotifierError(Exception):
   pass`.
2. In the same file, write
   `call_with_retries(send_fn, max_attempts: int = 3, backoff_seconds:
   float = 0.2) -> None`: call `send_fn()`; if it raises
   `NotifierError`, wait `backoff_seconds` and try again, up to
   `max_attempts` total attempts; if every attempt fails, re-raise the
   last error. The production call site (step 5) calls this with no
   `backoff_seconds` override, so it actually waits `0.2` seconds
   between attempts — a retry policy that never waits isn't teaching
   backoff, it's just teaching "try three times instantly."
3. In `tests/test_kitchen_client.py`, write a `FlakyClient` test helper
   — a class with a `send(self)` method that raises `NotifierError` for
   its first `fail_times` calls, then succeeds, tracking how many times
   it was called.
4. Write three tests: succeeds on the first try (`fail_times=0`);
   succeeds after two failures (`fail_times=2`, `max_attempts=3`,
   confirm exactly 3 calls happened); and exhausts all attempts and
   raises (`fail_times=5`, `max_attempts=3`, confirm exactly 3 calls
   happened before the error propagates). Use `backoff_seconds=0` so
   tests run instantly.
5. In `api.py`, add a `notify_kitchen(order_id: str) -> None` function
   (for now, just `pass` — you don't have a real delivery service to
   call). In `do_POST`, right after an order is successfully created,
   call it through your retry wrapper:
   `call_with_retries(lambda: notify_kitchen(order["order_id"]))`,
   catching `NotifierError` so a failed notification doesn't fail the
   whole request — the order is still created either way. Creating the
   order is the business operation this endpoint exists for; sending
   the kitchen notification is a secondary side effect of that
   operation succeeding. A failure in the side effect must never undo
   the business operation that already happened — that's the trade-off
   this lab is teaching.
6. Add one more test in `tests/test_api.py`: prove that a real
   `POST /orders` request still succeeds even when notification
   delivery fails on *every* attempt — not just that
   `call_with_retries` handles this in isolation. Lab 23's other tests
   only exercise the retry helper directly; none of them would catch a
   wiring bug where a notification failure accidentally aborted the
   whole request.
   - Use `monkeypatch` to replace `api.notify_kitchen` with a fake that
     always raises `NotifierError`, and to replace `time.sleep` with a
     no-op so the test doesn't actually wait through the retries — the
     same "tests override the delay, production doesn't" trade-off
     from step 2, applied at the API level this time.
   - `POST` an order through the real server. Assert the response is
     still `201`.
   - `GET` that same order afterward and assert it's still there.
   - Assert your fake was called exactly `max_attempts` times (3),
     confirming the retry loop actually ran to completion before
     giving up, instead of aborting early.
7. Do this lab's work on a branch (for example
   `feature/outside-world-fails`), push it, and open a pull request.
   Merge only once CI is green — same loop as Lab 21 and 22.

## Acceptance criteria

- `kitchen_client.py` defines `NotifierError` and `call_with_retries`,
  with a nonzero default `backoff_seconds`.
- All three retry-behavior tests pass, and each asserts the exact call
  count, not just the final outcome.
- `do_POST` still returns `201` for a valid order even though
  `notify_kitchen` is only a stub.
- A real HTTP-level test proves an order is created and remains
  fetchable even when notification delivery fails on every attempt —
  this can't be satisfied by testing `call_with_retries` alone.
- This lab's changes were merged through a pull request with a green
  CI check, not committed directly to `main`.

## Verification

```bash
cd examples/order-api
uv run pytest -v
cd -
```

Expected: all tests pass (9 total: 5 from earlier labs, 3
retry-behavior tests, and the new failure-path integration test).

## Think about it

- Your tests never sleep for real (`backoff_seconds=0`), even though
  the real function supports backoff. Why is that the right trade-off
  for a test, and the wrong trade-off for production?
- The order is created in the database *before* the notification is
  attempted, and a notification failure doesn't undo it. What would go
  wrong if you'd built it the other way around — notify first, then
  create the order only if the notification succeeded?

## If you get stuck

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
  replaces the function `do_POST` actually calls, the same way Lab 22's
  fixture used `monkeypatch.setattr(db, "DB_PATH", ...)` to redirect a
  module-level name. `monkeypatch.setattr(time, "sleep", lambda
  seconds: None)` (with `import time` at the top of the test file)
  does the same for the wait between attempts.

## What's next

Notifications can fail silently right now — nothing records that they
happened, or that they didn't. Next, you give the system a way to
explain itself after the fact.

Continue to [Lab 24 — Production says "it does not work"](../24-production-says-it-doesnt-work/README.md).
