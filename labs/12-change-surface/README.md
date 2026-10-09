# Lab 12 — Where should this change go?

## Story

Two developers independently built the discount-code feature from
Lab 11's spec. Both versions behave identically today. You're about to
find out they are not equally expensive to extend.

This lab (and the next three) works the same way regardless of which
language you picked back in Act II: read only your track's
instructions wherever this page splits.

## Learning objectives

After this lab you should be able to:

- Identify which files a new requirement forces you to touch in a given
  design.
- Explain "coupling" and "cohesion" using a concrete example rather than
  a definition.
- Judge a design by its cost of change, not just by whether it currently
  works.

## Before you start

- Labs 06-11 complete, in your chosen track.
- Read both `version-a/<your-language>/` and `version-b/<your-language>/`
  before doing anything else — see below for the exact files. Confirm
  for yourself that both pass their tests and produce the same totals.

### Python

- `examples/discount-codes/version-a/python/billing/calculator.py` and
  `examples/discount-codes/version-b/python/billing/calculator.py`
  (and version B's `billing/discount_codes.py`).

### Go

- `examples/discount-codes/version-a/go/billing/calculator.go` and
  `examples/discount-codes/version-b/go/billing/calculator.go` (and
  version B's `billing/discount_codes.go`).

### Java

- `examples/discount-codes/version-a/java/src/main/java/billing/Calculator.java`
  and
  `examples/discount-codes/version-b/java/src/main/java/billing/Calculator.java`
  (and version B's `billing/DiscountCodes.java`).

## Your task

The owner has added a third code: `SAVE20`, worth 20% off the amount
remaining after the loyalty discount (same rule as `SAVE10`, different
percentage). Add it to **both** versions, in your language.

Control numbers for the large order (two $30.00 steaks, 15% tip):
subtotal `$60.00`, loyalty discount `$6.00`, `SAVE20` discount `$10.80`,
total discount `$16.80`, expected total `$53.14`.

### Python

1. Add support for `SAVE20` to **Version A**
   (`examples/discount-codes/version-a/python/`). Add a test in
   `tests/test_calculator.py` asserting that for the large order,
   `bill["discount"] == 16.8` and `bill["total"] == 53.14`.
2. Add support for `SAVE20` to **Version B**
   (`examples/discount-codes/version-b/python/`). Add the equivalent
   test there too.

### Go

1. Add a `case "SAVE20":` branch to the `switch` inside
   `CalculateBill` in **Version A**
   (`examples/discount-codes/version-a/go/`), computing 20% of the
   amount after the loyalty discount. Add
   `TestSave20AppliesAfterLoyaltyDiscount` to `calculator_test.go`,
   asserting `bill.Discount == 16.8` and `bill.Total == 53.14` for the
   large order.
2. Add a `"SAVE20"` entry to the `discountCodes` map in
   `discount_codes.go` in **Version B**
   (`examples/discount-codes/version-b/go/`). Add the equivalent test
   to `calculator_test.go` there too.

### Java

1. Add a `case "SAVE20":` branch to the `switch` inside
   `calculateBill` in **Version A**
   (`examples/discount-codes/version-a/java/`), computing 20% of the
   amount after the loyalty discount. Add `save20AppliesAfterLoyaltyDiscount`
   to `CalculatorTest.java`, asserting `bill.discount == 16.8` and
   `bill.total == 53.14` for the large order.
2. Add a `"SAVE20"` entry to the `CODES` map in `DiscountCodes.java` in
   **Version B** (`examples/discount-codes/version-b/java/`). Add the
   equivalent test to `CalculatorTest.java` there too.

## All tracks

3. For each version, write down: which file(s) did you have to change?
   In that file, what *other* code sits right next to your
   change — code responsible for something unrelated to discount
   codes?
4. Answer, in a notes file
   `examples/discount-codes/COMPARISON.md`: if a bug in tax
   calculation showed up right after this change, which version makes
   it easier to convince yourself the discount-code change couldn't
   possibly be the cause — just by looking at *where* the change was
   made? This file is shared across every language — write it once, in
   terms of your own track.

## Acceptance criteria

- Both versions' test suites pass, including your new `SAVE20` tests.
- `COMPARISON.md` names the specific file changed in each version and
  answers the question in step 4.

### Python

- Version A: 5 tests. Version B: 8 tests.

### Go

- Version A: 5 tests (4 existing `Test...` functions plus your new
  one). Version B: 8 (7 existing plus your new one).

### Java

- Version A: 5 tests. Version B: 8 tests.

## Verification

### Python

```bash
cd examples/discount-codes/version-a/python && uv run pytest -v && cd - > /dev/null
cd examples/discount-codes/version-b/python && uv run pytest -v && cd - > /dev/null
test -f examples/discount-codes/COMPARISON.md && echo "comparison notes exist"
```

Expected: both suites green (5 tests in Version A, 8 in Version B), and
the comparison notes exist.

### Go

```bash
cd examples/discount-codes/version-a/go && go test ./... -v && cd - > /dev/null
cd examples/discount-codes/version-b/go && go test ./... -v && cd - > /dev/null
test -f examples/discount-codes/COMPARISON.md && echo "comparison notes exist"
```

Expected: both suites green (5 tests in Version A, 8 in Version B), and
the comparison notes exist.

### Java

```bash
cd examples/discount-codes/version-a/java && ./gradlew test && cd - > /dev/null
cd examples/discount-codes/version-b/java && ./gradlew test && cd - > /dev/null
test -f examples/discount-codes/COMPARISON.md && echo "comparison notes exist"
```

Expected: both builds green (5 tests in Version A, 8 in Version B), and
the comparison notes exist.

## Think about it

- Both versions required you to change exactly one file. Does "same
  number of files changed" mean "same cost of change"? What's actually
  different between the two files you touched?
- In Version B, could you add a fourth discount code without reading a
  single line of the calculator file? What does that tell you about
  how coupled the discount-code file is to the rest of the billing
  logic?

## If you get stuck

### Python

- **Hint 1:** In Version A, your change is a new `elif` branch inside
  `calculate_bill`. In Version B, it's a new entry in the
  `DISCOUNT_CODES` dictionary in `discount_codes.py`.
- **Hint 2:** "20% off the amount remaining after the loyalty discount"
  is the same shape as `SAVE10`, just a different rate.
- **Hint 3:** For the large order ($60 subtotal, $6 loyalty discount,
  15% tip): after-loyalty amount is $54; `SAVE20` off that is $10.80;
  total discount is $16.80.

### Go

- **Hint 1:** In Version A, your change is a new `case` inside the
  `switch` in `CalculateBill`. In Version B, it's a new entry in the
  `discountCodes` map in `discount_codes.go`.
- **Hint 2:** "20% off the amount remaining after the loyalty discount"
  is the same shape as `SAVE10`, just a different rate — the existing
  `SAVE10` branch or map entry is a direct template.
- **Hint 3:** For the large order ($60 subtotal, $6 loyalty discount,
  15% tip): after-loyalty amount is $54; `SAVE20` off that is $10.80;
  total discount is $16.80.

### Java

- **Hint 1:** In Version A, your change is a new `case` inside the
  `switch` in `calculateBill`. In Version B, it's a new entry in the
  `CODES` map in `DiscountCodes.java`.
- **Hint 2:** "20% off the amount remaining after the loyalty discount"
  is the same shape as `SAVE10`, just a different rate — the existing
  `SAVE10` branch or map entry is a direct template.
- **Hint 3:** For the large order ($60 subtotal, $6 loyalty discount,
  15% tip): after-loyalty amount is $54; `SAVE20` off that is $10.80;
  total discount is $16.80.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Nothing later assumes
a clean tree yet, but Act IV (starting at Lab 16) does — get in the
habit now.

## What's next

You've felt the difference between a design that makes a new
requirement cheap and one that makes it merely possible. Version A
still has the coupled shape, and it still has tests. Next, you'll turn
Version A into something closer to Version B, without breaking
anything along the way.

Continue to [Lab 13 — Refactoring with a safety net](../13-refactoring-safety-net/README.md).
