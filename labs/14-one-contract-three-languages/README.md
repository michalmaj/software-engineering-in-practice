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
- Compare how each language recognizes that something satisfies a
  contract: Java's explicit, compiler-checked `implements`; Go's
  implicit but still compiler-checked structural match; and Python's
  runtime duck typing, where `Protocol` only documents the shape for a
  static type checker — a checker this lab never runs.
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
5. For each language, note how satisfying the contract gets
   recognized: did you have to write anything declaring that
   `SilentNotifier` implements the `Notifier` contract, did the
   compiler work it out from the method alone, or did nothing check it
   at all?

## Acceptance criteria

- All three languages have a working `SilentNotifier` and a passing
  check for it, alongside the existing `ConsoleNotifier` /
  `InMemoryNotifier` checks.
- You can state, for each of the three languages, how satisfying the
  contract gets recognized: Java's explicit `implements`, checked by
  the compiler; Go's implicit structural match, also checked by the
  compiler; or Python's runtime duck typing, where nothing checks it
  at all — `send` just has to exist by the time it's called.

## Verification

```bash
cd examples/notifier/python && uv run pytest -v && cd - > /dev/null
cd examples/notifier/go && go test ./... && cd - > /dev/null
cd examples/notifier/java && javac *.java -d out && java -cp out NotifierCheck && cd - > /dev/null
```

Expected: all three succeed, including your new `SilentNotifier` checks.

## Think about it

- Go's `interface` and Python's `Protocol` both let you satisfy a
  contract just by having the right method, with no explicit
  declaration — but Go's compiler actually checks that match the
  moment you pass your type where the interface is expected, while
  Python runs no such check at all in this lab. Which of the three
  languages would catch a typo in the method name *earliest*: Java and
  Go at compile time, or Python only when something actually calls the
  missing method at runtime?
- If a teammate handed you a class with a `send(String message)`
  method but *forgot* to write `implements Notifier` on it, would Java
  let you pass it anywhere a `Notifier` is expected? Would Python or Go
  stop you the same way?
- Python's `Protocol` alone gives you *documentation* of a contract, not
  *enforcement* — nothing stops you from passing an object missing
  `send` and only finding out at runtime, when it's called. Go's
  compiler and Java's compiler both catch a missing method before the
  program ever runs. What would close that gap for Python, and what
  would it cost to add?

## If you get stuck

- **Hint 1:** `SilentNotifier`'s `send` method body is just `pass` in
  Python, an empty `{}` block in Go, and an empty `{}` block in Java —
  in all three, "does nothing" is the entire implementation.
- **Hint 2:** In Java specifically, forgetting `implements Notifier`
  will not stop `SilentNotifier` from compiling — but it *will* stop
  you from passing a bare `SilentNotifier` to `sendReceiptReady`,
  which expects a `Notifier`. Watch that against Go, where the same
  structural check happens implicitly at compile time, and against
  Python, where no such check happens at all.
- **Hint 3:** None of this requires a build tool — `uv run pytest` for
  Python, `go test ./...` for Go, and `javac *.java -d out && java -cp
  out NotifierCheck` for Java are the only three commands you need.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Nothing later assumes
a clean tree yet, but Act IV (starting at Lab 16) does — get in the
habit now.

## What's next

Discount codes (Labs 12-13) and notifiers (this lab) turn out to share
a shape: pick one interchangeable behavior out of several, based on
something the caller provides, instead of a chain of conditionals
buried in business logic. Next, you'll name that shape.

Continue to [Lab 15 — Patterns without pattern worship](../15-patterns-without-worship/README.md).
