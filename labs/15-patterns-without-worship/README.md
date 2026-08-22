# Lab 15 — Patterns without pattern worship

## Story

Look back at `discount_codes.py`'s `DISCOUNT_CODES` dict and the three
`Notifier` implementations from Lab 14. You built both without anyone
telling you their "official" name. It turns out there is one.

## Learning objectives

After this lab you should be able to:

- Recognize the Strategy pattern in code you already wrote, before
  being told its name.
- Explain Dependency Injection using a function you already wrote
  (`send_receipt_ready`) rather than a definition.
- Explain, in one sentence each, what a Factory and an Adapter are for.

## Before you start

- Labs 12-14 complete.
- No new code directories — this lab revisits `discount_codes.py` and
  the `notifier` examples from the last three labs.

## Your task

1. Re-read `discount_codes.py`'s `DISCOUNT_CODES` dictionary and
   `apply_discount_code`. Re-read the three `Notifier` implementations
   and `send_receipt_ready`. In a notes file
   `labs/15-patterns-without-worship/my-notes.md`, write, in your own
   words, what these two pieces of code have in common — specifically,
   how each one avoids an `if/elif` chain to pick a behavior.
2. Now the name: this shape — several interchangeable implementations
   of the same small contract, selected by whoever's calling, instead
   of baked into one big conditional — is called the **Strategy**
   pattern. `DISCOUNT_CODES["SAVE10"]` is a strategy. `ConsoleNotifier`
   and `InMemoryNotifier` are each a strategy for delivering a
   notification.
3. `send_receipt_ready(notifier, order_id)` takes its strategy in as a
   *parameter* instead of constructing one internally
   (`send_receipt_ready` never writes `notifier = ConsoleNotifier()`
   itself). Passing a dependency in from outside like this is called
   **Dependency Injection**. Write one sentence in your notes: what
   would `send_receipt_ready` lose the ability to do if it constructed
   its own `ConsoleNotifier` internally instead of receiving one?
4. Two more names, briefly: a **Factory** is code whose entire job is
   choosing or constructing the right strategy (imagine a function
   `build_notifier(config)` that returns a `ConsoleNotifier` or an
   `InMemoryNotifier` depending on a setting — you haven't built one,
   but you can now recognize what one would look like). An **Adapter**
   wraps something with an incompatible interface so it matches the one
   your code expects (imagine a third-party SMS library whose method is
   called `sendMessage(text)` instead of `send(message)` — a tiny
   wrapper class translating one call into the other is an Adapter).
   Write one sentence per pattern in your notes, in your own words.
5. As practice, add one more discount code to Version B
   (`examples/discount-codes/version-b/`) — for example
   `"SAVE_FLAT2"` worth a flat $2 off — with its own test. Confirm, in
   your notes, that this cost you exactly one new dictionary entry and
   one new test, touching no existing logic.

## Acceptance criteria

- `my-notes.md` answers points 1, 3, and 4 in your own words (not
  copy-pasted from this README).
- Version B has a new discount code with a passing test, and your notes
  state how many lines/files it took.

## Verification

```bash
test -f labs/15-patterns-without-worship/my-notes.md && echo "notes exist"
cd examples/discount-codes/version-b && uv run pytest -v && cd - > /dev/null
```

Expected: notes exist, and the test suite passes with one more test
than before (8 total, given Version B's earlier 7).

## Think about it

- Strategy, Factory, Adapter, and Dependency Injection are four
  different names. Which of them describes *what a piece of code is*
  (a shape), and which describes *how a piece of code receives
  something* (a relationship)? Is `DISCOUNT_CODES` closer to one or the
  other?
- Now that you have these names, would you have reached for "Strategy"
  as a solution on day one of Lab 12 — or was seeing the coupled
  version first (and feeling its cost) necessary to appreciate what the
  pattern actually buys you?

## If you get stuck

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

## What's next

You've built a small feature, given it a name a real engineering team
would recognize, and reused it under new requirements without dread.
Act III is done. Next, you stop working alone — and "my code works on
my machine" turns into "my code works when someone else touches it."

Act IV (Lab 16) continues in the next milestone.
