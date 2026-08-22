# Lab 14 — One contract, three languages

## Story

The kitchen wants a notification when an order is ready — for now,
printed to the console; later, maybe email or SMS. Three different
teams built the same tiny contract for this: one in Python, one in Go,
one in Java. Same idea, three very different amounts of ceremony.

## Learning objectives

After this lab you should be able to:

- Explain what makes something a "contract" independent of any one
  language's syntax for expressing it.
- Compare Python's structural typing (`Protocol`), Go's implicit
  interface satisfaction, and Java's explicit `implements`.
- Add a new implementation of an existing contract in all three
  languages.

## Before you start

- Labs 01-05 complete (general environment literacy). Labs 06-13 are
  not required for this lab specifically.
- `python3`, `go`, and `javac`/`java` all available (see the root
  [`README.md`](../../README.md) toolchain verification section).
- Read all three implementations before changing anything:
  `examples/notifier/python/notifier/notifier.py`,
  `examples/notifier/go/notifier.go`,
  `examples/notifier/java/{Notifier,ConsoleNotifier,InMemoryNotifier,ReceiptService}.java`.

## Your task

1. Run each language's checks and confirm they pass (see Verification).
2. In **Python**, add a class `SilentNotifier` in `notifier/notifier.py`
   with a `send` method that does nothing at all — no `class
   SilentNotifier(Notifier)` inheritance needed. Add a test confirming
   `send_receipt_ready(SilentNotifier(), "A123")` runs without raising
   an exception.
3. In **Go**, add a `type SilentNotifier struct{}` in `notifier.go` with
   a `Send(message string)` method with an empty body. Add a test
   confirming `SendReceiptReady(SilentNotifier{}, "A123")` runs without
   panicking.
4. In **Java**, add a class `SilentNotifier implements Notifier` in
   `SilentNotifier.java` with an empty `send` method body. In
   `NotifierCheck.java`, add a second check that
   `ReceiptService.sendReceiptReady(new SilentNotifier(), "A123")` runs
   without throwing.
5. For each language, note: did you have to write anything declaring
   that `SilentNotifier` implements the `Notifier` contract, or did the
   language figure that out from the method alone?

## Acceptance criteria

- All three languages have a working `SilentNotifier` and a passing
  check for it, alongside the existing `ConsoleNotifier` /
  `InMemoryNotifier` checks.
- You can state, for each of the three languages, whether declaring
  "this implements that contract" was explicit (written by you) or
  implicit (inferred by the compiler/runtime).

## Verification

```bash
cd examples/notifier/python && uv run pytest -v && cd - > /dev/null
cd examples/notifier/go && go test ./... && cd - > /dev/null
cd examples/notifier/java && javac *.java -d out && java -cp out NotifierCheck && cd - > /dev/null
```

Expected: all three succeed, including your new `SilentNotifier` checks.

## Think about it

- Python's `Protocol` and Go's `interface` both let you satisfy a
  contract just by having the right method — no explicit declaration.
  Java requires `implements Notifier` in the class definition. Which
  approach would catch a typo in the method name *earlier*: at the
  moment you write `SilentNotifier`, or only when something tries to
  use it as a `Notifier` and fails?
- If a teammate handed you a class with a `send(String message)`
  method but *forgot* to write `implements Notifier` on it, would Java
  let you pass it anywhere a `Notifier` is expected? Would Python or Go
  stop you the same way?

## If you get stuck

- **Hint 1:** `SilentNotifier`'s `send` method body is just `pass` in
  Python, an empty `{}` block in Go, and an empty `{}` block in Java —
  in all three, "does nothing" is the entire implementation.
- **Hint 2:** In Java specifically, forgetting `implements Notifier`
  will not stop `SilentNotifier` from compiling — but it *will* stop
  you from passing a bare `SilentNotifier` to `sendReceiptReady`,
  which expects a `Notifier`. That's the concrete difference from
  Python/Go to watch for.
- **Hint 3:** None of this requires a build tool — `uv run pytest` for
  Python, `go test ./...` for Go, and `javac *.java -d out && java -cp
  out NotifierCheck` for Java are the only three commands you need.

## What's next

Discount codes (Labs 12-13) and notifiers (this lab) turn out to share
a shape: pick one interchangeable behavior out of several, based on
something the caller provides, instead of a chain of conditionals
buried in business logic. Next, you'll name that shape.

Continue to [Lab 15 — Patterns without pattern worship](../15-patterns-without-worship/README.md).
