# Lab 14 — One contract, three languages

## Story

The kitchen wants a notification when an order is ready — for now,
printed to the console; later, maybe email or SMS. Three different
teams built the same tiny contract for this: one in Python, one in Go,
one in Java. Same idea, three very different amounts of ceremony — and
you only need to touch the one in your own language.

## Learning objectives

After this lab you should be able to:

- Explain what makes something a "contract" independent of any one
  language's syntax for expressing it.
- Explain how your own language recognizes that something satisfies a
  contract — and state, from reading (not necessarily running) the
  other two, how they differ.
- Add a new implementation of an existing contract in your own
  language, with a passing test.

## Before you start

- Labs 01-05 complete (general environment literacy). Labs 06-13 are
  not required for this lab specifically.
- You only need **your own language's** toolchain for this lab —
  nothing else is required to complete it.

### Python

- `uv` installed, current directory `examples/notifier/python/`.

### Go

- Go 1.27.x installed, current directory `examples/notifier/go/`.

### Java

- JDK 21 installed, current directory `examples/notifier/java/`.

## Your task

### Step 1 — read all three contracts (no toolchain needed for this part)

Open and read these three files, even if you only have your own
language's toolchain installed — reading source code doesn't require
running it:

- Python: `examples/notifier/python/notifier/notifier.py`
- Go: `examples/notifier/go/notifier.go`
- Java: `examples/notifier/java/Notifier.java`,
  `examples/notifier/java/ConsoleNotifier.java`,
  `examples/notifier/java/InMemoryNotifier.java`,
  `examples/notifier/java/ReceiptService.java`

Notice the shape repeated three times: something named `Notifier` (an
interface, a `Protocol`, or an interface) describing one method, and
at least two implementations of it that get passed to a function that
calls that method without knowing which implementation it got.

### Step 2 — run your home track's checks

### Python

```bash
cd examples/notifier/python && uv run pytest -v && cd - > /dev/null
```

### Go

```bash
cd examples/notifier/go && go test ./... && cd - > /dev/null
```

### Java

```bash
cd examples/notifier/java && javac *.java -d out && java -cp out NotifierCheck && cd - > /dev/null
```

### Step 3 — add `SilentNotifier` in your home track

### Python

In `notifier/notifier.py`, add a class `SilentNotifier` with a `send`
method that does nothing at all — no `class
SilentNotifier(Notifier)` inheritance needed, this is duck typing. Add
a test in `tests/test_notifier.py` confirming
`send_receipt_ready(SilentNotifier(), "A123")` runs without raising an
exception.

### Go

In `notifier.go`, add a `type SilentNotifier struct{}` with a
`Send(message string)` method with an empty body. Add a test in
`notifier_test.go` confirming `SendReceiptReady(SilentNotifier{},
"A123")` runs without panicking.

### Java

Add a class `SilentNotifier implements Notifier` in a new file
`SilentNotifier.java`, with an empty `send` method body. In
`NotifierCheck.java`, add a second check that
`ReceiptService.sendReceiptReady(new SilentNotifier(), "A123")` runs
without throwing.

### Step 4 — compare how each language recognizes the contract

You've now read all three and built one. Here's what actually happens,
verified for this course, if a class has the right method but the
contract isn't satisfied correctly — use this to compare against your
own language's behavior, without needing to install the other two
toolchains yourself:

**Java** — a class with a `send(String message)` method that does
*not* write `implements Notifier` fails to compile the moment you try
to pass it where a `Notifier` is expected, even though the method
exists:

```text
TryBad.java:4: error: incompatible types: BadNotifier cannot be converted to Notifier
        ReceiptService.sendReceiptReady(n, "A123");
                                        ^
```

**Go** — a struct with a *misspelled* method name (`Sand` instead of
`Send`) fails to compile the moment you try to pass it where the
`Notifier` interface is expected — Go checks the structural match, no
`implements` keyword needed, but it still checks:

```text
./notifier.go:20:19: cannot use BadNotifier{} (value of struct type BadNotifier) as Notifier value in argument to SendReceiptReady: BadNotifier does not implement Notifier (missing method Send)
```

**Python** — an object with a *misspelled* method name (`sand` instead
of `send`) compiles and runs with no complaint at all, right up until
the exact line that calls `.send(...)` actually executes:

```text
Traceback (most recent call last):
  File "notifier_check.py", line 18, in <module>
    send_receipt_ready(BadNotifier(), "A123")
  File "notifier_check.py", line 9, in send_receipt_ready
    notifier.send(f"Order {order_id} is ready.")
AttributeError: 'BadNotifier' object has no attribute 'send'. Did you mean: 'sand'?
```

If that specific code path were never exercised — say, the typo was in
a notifier implementation nothing currently calls — Python would never
raise at all. Nothing checked it, so nothing caught it.

### Step 5 — answer, in your own words

In a notes file `labs/14-one-contract-three-languages/my-notes.md`,
answer:

1. For your home language specifically: how does it recognize that
   `SilentNotifier` satisfies `Notifier`? Point to the exact mechanism
   (an `implements` clause checked by the compiler, a structural match
   checked by the compiler, or nothing checked at all).
2. Across all three languages (using Step 4's verified output, not
   guesses): which would catch a typo'd method name *earliest* — before
   the program runs, or only once the exact buggy code path executes?
3. If a teammate handed you a class with the right method but it
   doesn't satisfy the contract correctly (missing `implements` in
   Java, a misspelled method in Go or Python), what's the concrete,
   observable difference between how each language's tooling would
   surface that to you?

## Optional: run the other two languages too

If you happen to already have the other two toolchains installed, you
can run all three verification commands from Step 2 and build
`SilentNotifier` in all three — nothing in this lab stops you. But
it's not required, and the acceptance criteria below only check your
home track.

## Acceptance criteria

- Your home language has a working `SilentNotifier` and a passing
  check for it, alongside the existing `ConsoleNotifier` /
  `InMemoryNotifier` checks.
- `my-notes.md` answers all three questions from Step 5, in your own
  words, grounded in Step 4's verified output (not invented behavior).

## Verification

### Python

```bash
cd examples/notifier/python && uv run pytest -v && cd - > /dev/null
test -f labs/14-one-contract-three-languages/my-notes.md && echo "notes exist"
```

### Go

```bash
cd examples/notifier/go && go test ./... -v && cd - > /dev/null
test -f labs/14-one-contract-three-languages/my-notes.md && echo "notes exist"
```

### Java

```bash
cd examples/notifier/java && javac *.java -d out && java -cp out NotifierCheck && cd - > /dev/null
test -f labs/14-one-contract-three-languages/my-notes.md && echo "notes exist"
```

Expected: your home track's checks succeed, including your new
`SilentNotifier` check, and the notes file exists.

## Think about it

- Go's `interface` and Python's `Protocol` both let you satisfy a
  contract just by having the right method, with no explicit
  declaration — but Go's compiler actually checks that match the
  moment you pass your type where the interface is expected, while
  Python runs no such check at all in this lab. What would it cost to
  close that gap for Python (hint: a tool exists for this — what would
  you need to run, that this lab doesn't)?
- Python's `Protocol` alone gives you *documentation* of a contract,
  not *enforcement*. Is that a flaw in Python, or a trade-off? What do
  you imagine Python programmers gain in exchange for that missing
  check?

## If you get stuck

### Python

- **Hint 1:** `SilentNotifier`'s `send` method body is just `pass`.
- **Hint 2:** You don't need `class SilentNotifier(Notifier)` — nothing
  in this lab enforces the `Protocol`, so a plain `class
  SilentNotifier:` with a matching `send` method is enough.
- **Hint 3:** The whole lab is one command plus a few lines of code:
  `uv run pytest -v`.

### Go

- **Hint 1:** `SilentNotifier`'s `Send` method body is just an empty
  `{}`.
- **Hint 2:** You don't need to write anything declaring that
  `SilentNotifier` implements `Notifier` — Go checks that the moment
  you pass a `SilentNotifier{}` where a `Notifier` is expected.
- **Hint 3:** The whole lab is one command plus a few lines of code:
  `go test ./...`.

### Java

- **Hint 1:** `SilentNotifier`'s `send` method body is just an empty
  `{}`.
- **Hint 2:** Forgetting `implements Notifier` will not stop
  `SilentNotifier` from compiling on its own — but it *will* stop you
  from passing a bare `SilentNotifier` to `sendReceiptReady`, which
  expects a `Notifier`. That's exactly the Step 4 example, reproduced
  with your own class if you remove the clause to try it.
- **Hint 3:** No build tool needed —
  `javac *.java -d out && java -cp out NotifierCheck` is the only
  command you need.

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
