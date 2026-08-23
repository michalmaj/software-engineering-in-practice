# Lab 24 — Production says "it does not work"

## Story

A user reports: "I tried to check my order and got nothing." The
process is still running. There's no error on your screen. You have no
idea which order, or what actually happened, because nothing was ever
written down.

## Learning objectives

After this lab you should be able to:

- Add leveled log messages (`INFO`, `WARNING`, `ERROR`) at the moments
  that matter in a request's lifecycle.
- Include enough context (an order id) in a log line to trace one
  specific request's story.
- Test that a log message was actually produced, using pytest's
  `caplog` fixture.

## Before you start

- Lab 23 complete: `call_with_retries` and `notify_kitchen` exist and
  are wired into `do_POST`.
- Current directory: `examples/order-api/`.

## Your task

1. Add `import logging` and `logger = logging.getLogger("order_api")`
   near the top of `api.py`.
2. In `do_POST`, right after an order is created, log at `INFO`:
   include the order id and how many items it has.
3. In `do_GET`, when an order isn't found, log at `WARNING`: include
   the order id that was requested.
4. In `kitchen_client.py`, add `logger = logging.getLogger
   ("kitchen_client")`. In `call_with_retries`, log a `WARNING` on each
   failed attempt (include the attempt number and the error), and an
   `ERROR` if every attempt is exhausted.
5. In `run()`, configure logging once with `logging.basicConfig`,
   including the timestamp, level, and logger name in the format.
6. Write two tests using pytest's `caplog` fixture: one confirming that
   creating an order produces an `INFO` log record; one confirming that
   requesting a missing order produces a `WARNING` record.
7. Run the server by hand, make a couple of requests (including one for
   a missing order), and read the log output in your terminal. Confirm
   you can tell what happened without opening `api.py`.

## Acceptance criteria

- `api.py` and `kitchen_client.py` both configure and use a named
  logger (not bare `print`).
- Order creation logs at `INFO` with the order id; a missing order logs
  at `WARNING` with the requested id; a retry failure logs at
  `WARNING`, and exhausting all retries logs at `ERROR`.
- Two `caplog`-based tests pass, confirming the `INFO` and `WARNING`
  cases.

## Verification

```bash
cd examples/order-api
uv run pytest -v
cd -
```

Expected: all tests pass, including the two new logging tests.

## Think about it

- You could have used `print()` everywhere instead of `logging`. What
  do you lose by doing that — specifically, what could `caplog` check
  about `logging` calls that it couldn't check about `print` calls?
- Why does the `notify_kitchen` retry failure log at `WARNING` per
  attempt but `ERROR` only once, at the end, instead of `ERROR` on
  every failed attempt?

## If you get stuck

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

## What's next

You have tests, review, CI, and now logs — the system can explain
itself. Next, you have to decide what "this version" even means when
you hand it to someone else.

Continue to [Lab 25 — Release and compatibility](../25-release-and-compatibility/README.md).
