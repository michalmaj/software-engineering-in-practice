# Lab 15 — Patterns without pattern worship

## Story

Look back at Version B's discount-code file and the `Notifier`
implementations from Lab 14 — both in your own home track. You built
both without anyone telling you their "official" name. It turns out
there is one.

## Learning objectives

After this lab you should be able to:

- Recognize the Strategy pattern in code you already wrote, before
  being told its name.
- Explain Dependency Injection using a function you already wrote
  (`send_receipt_ready` / `SendReceiptReady` / `sendReceiptReady`)
  rather than a definition.
- Explain, in one sentence each, what a Factory and an Adapter are for.

## Before you start

- Labs 12-14 complete, in your home track.
- No new toolchain — this lab revisits code you already wrote.

## Your task

1. Re-read your home track's Version B discount-code file and its
   `apply`-style function, and the `Notifier` implementations plus the
   `send_receipt_ready`-style function from Lab 14. In a notes file
   `labs/15-patterns-without-worship/my-notes.md`, write, in your own
   words, what these two pieces of code have in common — specifically,
   how each one avoids a long conditional chain to pick a behavior.

### Python

- `examples/discount-codes/version-b/python/billing/discount_codes.py`
- `examples/notifier/python/notifier/notifier.py`

### Go

- `examples/discount-codes/version-b/go/billing/discount_codes.go`
- `examples/notifier/go/notifier.go`

### Java

- `examples/discount-codes/version-b/java/src/main/java/billing/DiscountCodes.java`
- `examples/notifier/java/{Notifier,ConsoleNotifier,InMemoryNotifier,ReceiptService}.java`

2. Now the name: this shape — several interchangeable implementations
   of the same small contract, selected by whoever's calling, instead
   of baked into one big conditional — is called the **Strategy**
   pattern. Each entry in your discount-codes map/dict is a strategy.
   `ConsoleNotifier` and `InMemoryNotifier` (and now your
   `SilentNotifier`) are each a strategy for delivering a notification.
   Strategy doesn't require a class hierarchy — in Go and Python
   specifically, a plain function stored in a map *is* a strategy; you
   don't need to wrap it in a type to make it one.
3. `send_receipt_ready`/`SendReceiptReady`/`sendReceiptReady` takes its
   strategy in as a *parameter* instead of constructing one internally
   — it never writes `notifier = ConsoleNotifier()` (or the
   equivalent) itself. Passing a dependency in from outside like this
   is called **Dependency Injection** — no framework required; it's
   just "the caller decides which implementation to use, by passing it
   in as an argument." Write one sentence in your notes: what would
   this function lose the ability to do if it constructed its own
   `ConsoleNotifier` internally instead of receiving one?
4. Two more names, briefly: a **Factory** is code whose job is to
   centralize the decision of *which* object to create or return, so
   callers don't each have to make that decision themselves. In
   general, a Factory can construct or supply any kind of object; in
   *this* exercise specifically, that decision happens to be which
   Strategy implementation to use (imagine a function
   `build_notifier(config)` that returns a `ConsoleNotifier` or an
   `InMemoryNotifier` depending on a setting — you haven't built one,
   but you can now recognize what one would look like). "Picking a
   Strategy" is simply this exercise's use of a Factory, not what a
   Factory inherently is. An **Adapter** wraps something with an
   incompatible interface so it matches the one your code expects
   (imagine a third-party SMS library whose method is called
   `sendMessage(text)` instead of `send(message)` — a tiny wrapper
   translating one call into the other is an Adapter). Write one
   sentence per pattern in your notes, in your own words.
5. As practice, add one more discount code to **your home track's**
   Version B — `"SAVE_FLAT2"`, worth a flat $2 off — with its own test.
   Confirm, in your notes, what this cost you: how many new lines, and
   whether you touched any existing logic.

### Python

Add `"SAVE_FLAT2": lambda amount: 2.0` to `DISCOUNT_CODES` in
`examples/discount-codes/version-b/python/billing/discount_codes.py`.
Add a test to `tests/test_discount_codes.py` asserting
`apply_discount_code(100.0, "SAVE_FLAT2") == 2.0`.

### Go

Add `"SAVE_FLAT2": func(amount float64) float64 { return 2.0 }` to the
`discountCodes` map in
`examples/discount-codes/version-b/go/billing/discount_codes.go`. Add
a test to `discount_codes_test.go` asserting `ApplyDiscountCode(100.0,
"SAVE_FLAT2")` returns `2.0`. Run `gofmt -w .` afterward — adding a
longer key to the map shifts how `gofmt` aligns the `:` column for
every entry, and that's expected, not a sign you broke something.

### Java

Add `"SAVE_FLAT2", amount -> 2.0` to the `CODES` map in
`examples/discount-codes/version-b/java/src/main/java/billing/DiscountCodes.java`.
Add a test to `DiscountCodesTest.java` asserting
`DiscountCodes.apply(100.0, "SAVE_FLAT2") == 2.0`.

Don't add this code to Version A, and don't add it to the public
starter — it's practice for your own copy only.

## Acceptance criteria

- `my-notes.md` answers points 1, 3, and 4 in your own words (not
  copy-pasted from this README).
- Your home track's Version B has a new discount code with a passing
  test, and your notes state how many lines/files it took.

## Verification

### Python

```bash
test -f labs/15-patterns-without-worship/my-notes.md && echo "notes exist"
cd examples/discount-codes/version-b/python && uv run pytest -v && cd - > /dev/null
```

Expected: notes exist, and the test suite passes with one more test
than before (9 total, given Version B's earlier 8 — 7 shipped plus the
`SAVE20` test you added in Lab 12).

### Go

```bash
test -f labs/15-patterns-without-worship/my-notes.md && echo "notes exist"
cd examples/discount-codes/version-b/go && go test ./... -v && cd - > /dev/null
```

Expected: notes exist, and the test suite passes with one more test
than before (9 total, given Version B's earlier 8 — 7 shipped plus the
`SAVE20` test you added in Lab 12).

### Java

```bash
test -f labs/15-patterns-without-worship/my-notes.md && echo "notes exist"
cd examples/discount-codes/version-b/java && ./gradlew test && cd - > /dev/null
```

Expected: notes exist, and the test suite passes with one more test
than before (9 total, given Version B's earlier 8 — 7 shipped plus the
`SAVE20` test you added in Lab 12).

## Think about it

- Strategy, Factory, Adapter, and Dependency Injection are four
  different names. Which of them describes *what a piece of code is*
  (a shape), and which describes *how a piece of code receives
  something* (a relationship)? Is your discount-codes map/dict closer
  to one or the other?
- Now that you have these names, would you have reached for "Strategy"
  as a solution on day one of Lab 12 — or was seeing the coupled
  version first (and feeling its cost) necessary to appreciate what the
  pattern actually buys you?

## If you get stuck

### Python

- **Hint 1:** If you're not sure whether something "is a Strategy," ask:
  could I swap this specific piece out for a different implementation
  of the same contract without changing the code that calls it? If
  yes, that's the pattern.
- **Hint 2:** Dependency Injection here is not a framework — it's just
  "the caller decides which implementation to use, by passing it in as
  an argument."
- **Hint 3:** For the new discount code, follow the exact same shape as
  `"SAVE5"` in `DISCOUNT_CODES` — a lambda that ignores its argument
  and returns a flat amount.

### Go

- **Hint 1:** If you're not sure whether something "is a Strategy," ask:
  could I swap this specific piece out for a different implementation
  of the same contract without changing the code that calls it? If
  yes, that's the pattern.
- **Hint 2:** Dependency Injection here is not a framework — it's just
  "the caller decides which implementation to use, by passing it in as
  an argument."
- **Hint 3:** For the new discount code, follow the exact same shape as
  `"SAVE5"` in the `discountCodes` map — a function that ignores its
  argument and returns a flat amount.

### Java

- **Hint 1:** If you're not sure whether something "is a Strategy," ask:
  could I swap this specific piece out for a different implementation
  of the same contract without changing the code that calls it? If
  yes, that's the pattern.
- **Hint 2:** Dependency Injection here is not a framework — it's just
  "the caller decides which implementation to use, by passing it in as
  an argument."
- **Hint 3:** For the new discount code, follow the exact same shape as
  `"SAVE5"` in the `CODES` map — a lambda that ignores its argument and
  returns a flat amount.

## Before you move on to Act IV

Act IV (starting at Lab 16) assumes your `main` branch is clean and
everything from Labs 06-15 is committed and pushed. Right now:

```bash
git status
```

If this shows anything uncommitted, commit and push it now
(`git add -A && git commit -m "..."; git push`). If it shows clean,
you're ready.

## What's next

You've built a small feature, given it a name a real engineering team
would recognize, and reused it under new requirements without dread.
Act III is done. Next, you stop working alone — and "my code works on
my machine" turns into "my code works when someone else touches it."

Continue to [Lab 16 — Branches exist because work happens in parallel](../16-parallel-branches/README.md).
