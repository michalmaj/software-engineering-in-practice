# Lab 07 — How do we know it works?

## Story

Your refactored `billing` package behaves the same as the old script —
you checked once, by hand, with `diff`. That doesn't scale: you can't
re-run a manual diff every time you touch a line. You need tests that
run themselves.

## Learning objectives

After this lab you should be able to:

- Write a unit test using Arrange-Act-Assert.
- Explain what a "unit" is in "unit test", in the context of this project.
- Choose test cases that cover a function's distinct behaviors (not just
  one happy path).
- Run a test suite and read a pass/fail report.

## Before you start

- Lab 06 complete: `billing/calculator.py` exists with the five
  functions, `main.py` reproduces `bill.py`'s exact output, and
  `tests/` exists as an empty directory.
- Current directory: `examples/restaurant-bill/`.

## Your task

Create `tests/test_calculator.py` with tests for every function in
`billing/calculator.py`. At minimum, include:

1. `calculate_subtotal` returns the sum of `price * quantity` across
   multiple items.
2. `calculate_discount` returns `0` for a subtotal below `50`.
3. `calculate_discount` returns 10% of the subtotal when it is at or
   above `50`.
4. `calculate_tax` returns 8% of whatever amount it's given.
5. `calculate_tip` returns the given percentage of whatever amount it's
   given.
6. `calculate_bill`, for a **small order that does not trigger the
   discount** (for example, the same three items as the receipt example:
   burger, fries, soda — subtotal $38), returns `total == 46.74`.

Structure every test as Arrange (set up inputs), Act (call the function),
Assert (check the result) — even if each part is only one line.

## Acceptance criteria

- `uv run pytest -v` passes, with at least one test per function listed
  above (6 tests minimum).
- Every test follows Arrange-Act-Assert, even if informally (no test
  frameworks-within-frameworks needed — plain `assert` is enough).

## Verification

```bash
cd examples/restaurant-bill
uv run pytest -v
cd -
```

Expected: every test shown as `PASSED`, none `FAILED`, none skipped.

## Think about it

- All six of your tests pass. Does that prove `calculate_bill` is
  correct for *every* order, or only for the specific inputs you tried?
- You tested a small order and a large-enough-to-discount value in
  `calculate_discount` alone — but did you test `calculate_bill` itself
  with an order large enough to trigger the discount? What might that
  reveal that your current tests can't?

## If you get stuck

- **Hint 1:** Import what you're testing at the top of the file:
  `from billing.calculator import calculate_subtotal, calculate_discount,
  calculate_tax, calculate_tip, calculate_bill`.
- **Hint 2:** A test is just a function starting with `test_` that
  contains `assert` statements — pytest finds and runs it automatically.
- **Hint 3:** For floating-point results, comparing with `==` after
  rounding to 2 decimal places (as `calculate_bill` already does) is
  reliable enough for this project; you don't need `pytest.approx` here.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Nothing later assumes
a clean tree yet, but Act IV (starting at Lab 16) does — get in the
habit now.

## What's next

Your tests are green. Then a customer complains about their bill. Time
to find out whether "all tests pass" and "the code is correct" are
actually the same thing.

Continue to [Lab 08 — A bug report arrives](../08-bug-report/README.md).
