# Lab 12 — Where should this change go?

## Story

Two developers independently built the discount-code feature from
Lab 11's spec. Both versions behave identically today. You're about to
find out they are not equally expensive to extend.

## Learning objectives

After this lab you should be able to:

- Identify which files a new requirement forces you to touch in a given
  design.
- Explain "coupling" and "cohesion" using a concrete example rather than
  a definition.
- Judge a design by its cost of change, not just by whether it currently
  works.

## Before you start

- Labs 06-11 complete.
- Read both `examples/discount-codes/version-a/billing/calculator.py`
  and `examples/discount-codes/version-b/billing/calculator.py` (and
  version B's `billing/discount_codes.py`) before doing anything else.
  Confirm for yourself that both pass their tests and produce the same
  totals.

## Your task

The owner has added a third code: `SAVE20`, worth 20% off the amount
remaining after the loyalty discount (same rule as `SAVE10`, different
percentage).

1. Add support for `SAVE20` to **Version A**
   (`examples/discount-codes/version-a/`). Add a test in
   `tests/test_calculator.py` asserting that for the large order (two
   $30.00 steaks, 15% tip), `bill["discount"] == 16.8` and
   `bill["total"] == 53.14`.
2. Add support for `SAVE20` to **Version B**
   (`examples/discount-codes/version-b/`). Add the equivalent test
   there too.
3. For each version, write down: which file(s) did you actually have to
   change? In that file, what *other* code sits right next to your
   change — code responsible for something unrelated to discount
   codes?
4. Answer, in a notes file
   `examples/discount-codes/COMPARISON.md`: if a bug in tax
   calculation showed up right after this change, which version makes
   it easier to convince yourself the discount-code change couldn't
   possibly be the cause — just by looking at *where* the change was
   made?

## Acceptance criteria

- Both versions' test suites pass, including your new `SAVE20` tests.
- `COMPARISON.md` names the specific file changed in each version and
  answers the question in step 4.

## Verification

```bash
cd examples/discount-codes/version-a && uv run pytest -v && cd - > /dev/null
cd examples/discount-codes/version-b && uv run pytest -v && cd - > /dev/null
test -f examples/discount-codes/COMPARISON.md && echo "comparison notes exist"
```

Expected: both suites green (5 tests in Version A, 8 in Version B), and
the comparison notes exist.

## Think about it

- Both versions required you to change exactly one file. Does "same
  number of files changed" mean "same cost of change"? What's actually
  different between the two files you touched?
- In Version B, could you add a fourth discount code without reading a
  single line of `calculator.py`? What does that tell you about how
  coupled `discount_codes.py` is to the rest of the billing logic?

## If you get stuck

- **Hint 1:** In Version A, your change is a new `elif` branch inside
  `calculate_bill`. In Version B, it's a new entry in the
  `DISCOUNT_CODES` dictionary in `discount_codes.py`.
- **Hint 2:** "20% off the amount remaining after the loyalty discount"
  is the same shape as `SAVE10`, just a different rate.
- **Hint 3:** For the large order ($60 subtotal, $6 loyalty discount,
  15% tip): after-loyalty amount is $54; `SAVE20` off that is $10.80;
  total discount is $16.80.

## What's next

You've felt the difference between a design that makes a new
requirement cheap and one that makes it merely possible. Version A
still has the coupled shape — and it still has real tests. Next,
you'll turn Version A into something closer to Version B, without
breaking anything along the way.

Continue to [Lab 13 — Refactoring with a safety net](../13-refactoring-safety-net/README.md).
