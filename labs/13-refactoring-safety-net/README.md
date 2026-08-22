# Lab 13 — Refactoring with a safety net

## Story

Version A works. It has tests. It also has a growing `elif` chain
inside `calculate_bill` that has nothing to do with subtotals, tax, or
tips. You're going to fix the *shape* of the code without changing what
it does — and you'll know you succeeded because the tests never go red.

## Learning objectives

After this lab you should be able to:

- Make a structural change in small steps, each one verified by tests.
- Explain what "behavior-preserving" means for a refactor.
- Use a passing test suite as evidence that a refactor didn't break
  anything, instead of re-reading the whole function by eye.

## Before you start

- Lab 12 complete: your own copy of
  `examples/discount-codes/version-a/` has `SAVE10`, `SAVE5`, and
  `SAVE20` all passing their tests.
- Current directory: `examples/discount-codes/version-a/`.

## Your task

Refactor Version A so that its discount-code handling looks like
Version B's — without ever letting the test suite go red for longer
than the single step you're mid-way through.

1. Create `billing/discount_codes.py` with a `DISCOUNT_CODES` dict
   mapping `"SAVE10"`, `"SAVE5"`, and `"SAVE20"` to functions of the
   amount they apply to (percentages as lambdas, the flat `$5` as a
   lambda that ignores its argument), and an `apply_discount_code(amount,
   code)` function that looks up the code and raises `ValueError` for
   anything unrecognized — matching Version B exactly.
2. Run the full test suite. It should still pass — you've only *added*
   a file so far, nothing in `calculator.py` calls it yet.
3. In `calculator.py`, replace the `if/elif/else` chain inside
   `calculate_bill` with a single call to `apply_discount_code`, only
   when `discount_code is not None`.
4. Run the test suite again immediately. It must still pass — if it
   doesn't, you changed behavior, not just structure. Fix it before
   doing anything else.
5. Delete the now-unused inline logic, if any remains. Run the tests
   one final time.

## Acceptance criteria

- `billing/discount_codes.py` exists with the same three codes as
  Version B.
- `calculate_bill` no longer contains an `if/elif` chain checking
  discount code strings directly.
- `uv run pytest` passes at every step described above, not just at the
  end.

## Verification

```bash
cd examples/discount-codes/version-a
uv run pytest -v
grep -n "elif discount_code" billing/calculator.py && echo "still coupled — not done" || echo "decoupled"
cd -
```

Expected: all tests pass, and `decoupled` is printed (no `elif
discount_code` line remains in `calculator.py`).

## Think about it

- At which single step, if you'd made a typo, would the test suite have
  told you immediately — versus which step could have introduced a
  silent behavior change that no test currently catches?
- You just turned Version A into something structurally identical to
  Version B. What was the actual *evidence*, at each step, that you
  hadn't changed what the program does?

## If you get stuck

- **Hint 1:** Steps 1-2 are pure addition — nothing existing changes,
  so nothing can break yet. That's deliberate: get the new code in
  place and proven correct in isolation before wiring it up.
- **Hint 2:** Step 3 is a one-line replacement of the whole `if
  discount_code == "SAVE10": ... elif ...: ... else: raise ...` block
  with `code_discount = apply_discount_code(after_loyalty,
  discount_code)`.
- **Hint 3:** If a test fails after step 3, compare what
  `apply_discount_code` does for that specific code against what the
  old inline branch did — the discrepancy is usually in exactly one of
  the three codes.

## What's next

Discount codes and (from the last two labs) a family of things that all
"pick one behavior out of several, based on a key." Next, you'll look at
one more example of that same shape from a completely different part of
the system — and only then learn what it's usually called.

Continue to [Lab 14 — One contract, three languages](../14-one-contract-three-languages/README.md).
