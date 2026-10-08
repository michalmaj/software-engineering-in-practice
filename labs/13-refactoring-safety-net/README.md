# Lab 13 — Refactoring with a safety net

## Story

Version A works. It has tests. It also has a growing chain of
conditionals inside its bill calculation that have nothing to do with
subtotals, tax, or tips. You're going to fix the *shape* of the code
without changing what it does — and you'll know you succeeded because
the tests never go red.

## Learning objectives

After this lab you should be able to:

- Make a structural change in small steps, each one verified by tests.
- Explain what "behavior-preserving" means for a refactor.
- Use a passing test suite as evidence that a refactor didn't break
  anything, instead of re-reading the whole function by eye.

## Before you start

- Lab 12 complete: your own copy of Version A in your language has
  `SAVE10`, `SAVE5`, and `SAVE20` all passing their tests.

### Python

- Current directory: `examples/discount-codes/version-a/python/`.

### Go

- Current directory: `examples/discount-codes/version-a/go/`.

### Java

- Current directory: `examples/discount-codes/version-a/java/`.

## Your task

Refactor Version A so that its discount-code handling looks like
Version B's — without ever letting the test suite go red for longer
than the single step you're mid-way through. Every track follows the
same sequence:

```text
tests green
→ add new discount-code component
→ existing tests green
→ route behavior through new component
→ tests green
→ remove old conditional logic
→ tests green
```

### Python

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

### Go

1. Create `billing/discount_codes.go` with a `discountCodes` map
   mapping `"SAVE10"`, `"SAVE5"`, and `"SAVE20"` to functions of the
   amount they apply to, and an `ApplyDiscountCode(amount, code)
   (float64, error)` function that looks up the code and returns an
   error for anything unrecognized — matching Version B exactly.
2. Run the full test suite (`go test ./...`). It should still pass —
   an unused package-level map or function doesn't stop Go from
   building; you've only *added* something so far, nothing in
   `calculator.go` calls it yet.
3. In `calculator.go`, replace the `switch` inside `CalculateBill`
   with a single call to `ApplyDiscountCode`, only when
   `discountCode != ""`.
4. Run the test suite again immediately. It must still pass — if it
   doesn't, you changed behavior, not just structure. Fix it before
   doing anything else.
5. Delete the now-unused inline logic, if any remains. Check whether
   `calculator.go` still needs its `"fmt"` import — once the `switch`
   that built an error message with `fmt.Errorf` is gone, that import
   becomes unused, and Go refuses to build with an unused import. Run
   `go build ./...` to catch this before you run the tests again.

### Java

1. Create `src/main/java/billing/DiscountCodes.java` with a `CODES` map
   (`Map<String, DoubleUnaryOperator>`) mapping `"SAVE10"`, `"SAVE5"`,
   and `"SAVE20"` to the amount they apply to, and an
   `apply(double amount, String code)` method that looks up the code
   and throws `IllegalArgumentException` for anything unrecognized —
   matching Version B exactly.
2. Run the full test suite (`./gradlew test`). It should still pass —
   an unused class doesn't stop Java from compiling; you've only
   *added* a file so far, nothing in `Calculator.java` calls it yet.
3. In `Calculator.java`, replace the `switch` inside `calculateBill`
   with a single call to `DiscountCodes.apply`, only when
   `discountCode != null`.
4. Run the test suite again immediately. It must still pass — if it
   doesn't, you changed behavior, not just structure. Fix it before
   doing anything else.
5. Delete the now-unused inline logic, if any remains. Run the tests
   one final time.

## Acceptance criteria

- The discount-code file (`discount_codes.py` / `discount_codes.go` /
  `DiscountCodes.java`) exists with the same three codes as Version B.
- The bill calculation no longer contains a conditional chain checking
  discount-code strings directly.
- The test suite passes at every step described above, not just at the
  end.

## Verification

### Python

```bash
cd examples/discount-codes/version-a/python
uv run pytest -v
grep -n "elif discount_code" billing/calculator.py && echo "still coupled — not done" || echo "decoupled"
cd -
```

Expected: all tests pass, and `decoupled` is printed.

### Go

```bash
cd examples/discount-codes/version-a/go
go build ./...
go test ./... -v
grep -n 'case "SAVE' billing/calculator.go && echo "still coupled — not done" || echo "decoupled"
cd -
```

Expected: the build succeeds, all tests pass, and `decoupled` is
printed.

### Java

```bash
cd examples/discount-codes/version-a/java
./gradlew test
grep -n "switch (discountCode)" src/main/java/billing/Calculator.java && echo "still coupled — not done" || echo "decoupled"
cd -
```

Expected: the build succeeds, all tests pass, and `decoupled` is
printed.

## Think about it

- At which single step, if you'd made a typo, would the test suite have
  told you immediately — versus which step could have introduced a
  silent behavior change that no test currently catches?
- You just turned Version A into something structurally identical to
  Version B. What was the actual *evidence*, at each step, that you
  hadn't changed what the program does?

## If you get stuck

### Python

- **Hint 1:** Steps 1-2 are pure addition — nothing existing changes,
  so nothing can break yet. That's deliberate: at this point, the
  existing behavior is still protected by the regression suite; the
  next step is to route it through the new structure.
- **Hint 2:** Step 3 is a one-line replacement of the whole `if
  discount_code == "SAVE10": ... elif ...: ... else: raise ...` block
  with `code_discount = apply_discount_code(after_loyalty,
  discount_code)`.
- **Hint 3:** If a test fails after step 3, compare what
  `apply_discount_code` does for that specific code against what the
  old inline branch did — the discrepancy is usually in exactly one of
  the three codes.

### Go

- **Hint 1:** Steps 1-2 are pure addition — nothing existing changes,
  so nothing can break yet. Unlike an unused *local* variable, an
  unused package-level function or map is not a compile error in Go.
- **Hint 2:** Step 3 is a one-line replacement of the whole `switch
  discountCode { case "SAVE10": ... default: return Bill{},
  fmt.Errorf(...) }` block with `codeDiscount, err =
  ApplyDiscountCode(afterLoyalty, discountCode)` (plus the `if err !=
  nil` check).
- **Hint 3:** If `go build ./...` complains about `"fmt" imported and
  not used` after step 3, that's expected — the only thing that used
  to use `fmt` was the error message inside the old `switch`. Remove
  the import, or replace it with just `import "math"` if that's the
  only other thing the file still needs.

### Java

- **Hint 1:** Steps 1-2 are pure addition — nothing existing changes,
  so nothing can break yet.
- **Hint 2:** Step 3 is a one-line replacement of the whole `switch
  (discountCode) { case "SAVE10": ... default: throw ... }` block with
  `codeDiscount = DiscountCodes.apply(afterLoyalty, discountCode);`.
- **Hint 3:** If a test fails after step 3, compare what
  `DiscountCodes.apply` does for that specific code against what the
  old inline `case` did — the discrepancy is usually in exactly one of
  the three codes.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Nothing later assumes
a clean tree yet, but Act IV (starting at Lab 16) does — get in the
habit now.

## What's next

Discount codes are (from the last two labs) a family of things that all
"pick one behavior out of several, based on a key." Next, you'll look at
one more example of that same shape from a completely different part of
the system — and only then learn what it's usually called.

Continue to [Lab 14 — One contract, three languages](../14-one-contract-three-languages/README.md).
