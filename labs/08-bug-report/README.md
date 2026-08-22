# Lab 08 — A bug report arrives

## Story

An email arrives: "I ordered $60 of food and got the loyalty discount,
but the tax on my receipt looks too high for the discounted amount."
Your test suite is green. The customer is still right.

## Learning objectives

After this lab you should be able to:

- Turn a bug report into a concrete, failing test before touching any
  implementation code.
- Explain why a failing test is better evidence of understanding a bug
  than a print statement.
- Fix a defect with the smallest possible code change, guided by the
  test going green.

## Before you start

- Lab 07 complete: `uv run pytest` passes.
- Current directory: `examples/restaurant-bill/`.

## Your task

1. Reproduce, by hand or in a scratch Python shell, what
   `calculate_bill` returns for an order whose subtotal is $60 (for
   example, two $30.00 steaks) with a 15% tip rate. Work out by hand
   what the tax *should* be if it's computed on the discounted amount
   ($60 - 10% = $54; 8% of $54 = $4.32) versus what the code currently
   computes.
2. Add a new test to `tests/test_calculator.py`,
   `test_calculate_bill_applies_tax_after_discount_on_large_order`,
   asserting that for that $60 order at a 15% tip rate,
   `bill["tax"] == 4.32` and `bill["total"] == 66.42`.
3. Run the test suite and confirm this new test fails (red).
4. Read the failure message. Locate the exact line in
   `calculate_bill` responsible.
5. Fix it — change what `calculate_tax` is called with, so tax is
   computed on the amount *after* the discount, not before.
6. Run the whole suite again and confirm everything passes (green),
   including the small-order test from Lab 07.

## Acceptance criteria

- `tests/test_calculator.py` contains a test for a discounted order,
  named so its intent is clear.
- `uv run pytest` passes completely, with no fewer tests than before.
- The fix is a change to how `tax` is computed inside `calculate_bill`
  only — no other function's behavior changes.

## Verification

```bash
cd examples/restaurant-bill
uv run pytest -v
uv run python -c "from billing.calculator import calculate_bill; print(calculate_bill([('Steak', 30.00, 2)], 0.15))"
cd -
```

Expected: all tests `PASSED`; the printed dict shows `'tax': 4.32,
'total': 66.42`.

## Think about it

- Your Lab 07 tests were all green *before* this fix, and the bug still
  existed. What made this bug invisible to that test suite specifically?
- You fixed the bug in `calculate_bill`, not in `calculate_tax` itself.
  Why didn't `calculate_tax` need to change?

## If you get stuck

- **Hint 1:** Compute the buggy tax by hand first — for the $60 order,
  what does `calculate_tax(60.0)` return, versus
  `calculate_tax(60.0 - 6.0)`?
- **Hint 2:** The failing assertion message from pytest shows you the
  actual value your code produced. Compare it to what you expected — the
  gap tells you exactly which input was wrong.
- **Hint 3:** The fix is one changed argument on one line inside
  `calculate_bill` — resist the urge to restructure anything else.

## What's next

You have a green suite and a real fix behind it. Next, a different kind
of check: not "is this correct," but "is this written the way the team
agreed to write things."

Continue to [Lab 09 — Machines can check boring things](../09-automated-checks/README.md).
