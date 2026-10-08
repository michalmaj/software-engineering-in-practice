# Lab 07 — How do we know it works?

## Story

Your refactored `billing` code behaves the same as the original
monolith — you checked once, by hand, with `diff`. That doesn't scale:
you can't re-run a manual diff every time you touch a line. You need
tests that run themselves.

## Learning objectives

After this lab you should be able to:

- Write a unit test using Arrange-Act-Assert.
- Explain what a "unit" is in "unit test", in the context of this
  project.
- Choose test cases that cover a function's (or method's) distinct
  behaviors, not just one happy path.
- Run a test suite and read a pass/fail report, in your language's own
  test runner.

## Before you start

- Lab 06 complete, in whichever track you're following.

### Python

- Current directory: `examples/restaurant-bill/python/`.
- `billing/calculator.py` exists with the five functions from Lab 06.

### Go

- Current directory: `examples/restaurant-bill/go/`.
- `billing/calculator.go` exists with the `Item`/`Bill` types and five
  functions from Lab 06.

### Java

- Current directory: `examples/restaurant-bill/java/`.
- `billing/Calculator.java` exists with the `Item`/`Bill` types and five
  methods from Lab 06, and `build.gradle` has the JUnit 5 dependencies.

## Your task

Every track writes the same six cases. Structure every test as Arrange
(set up inputs), Act (call the function), Assert (check the result) —
even if each part is only one line.

1. Computing a subtotal sums `price * quantity` across multiple items.
2. Computing a discount returns `0` for a subtotal below `50`.
3. Computing a discount returns 10% of the subtotal when it is at or
   above `50`.
4. Computing tax returns 8% of whatever amount it's given.
5. Computing a tip returns the given percentage of whatever amount it's
   given.
6. Computing the whole bill, for a **small order that does not trigger
   the discount** (the same three items as the receipt example: burger,
   fries, soda — subtotal $38), returns a total of `46.74`.

### Python

Create `tests/test_calculator.py`. Here's enough to get the first case
started — write the other five yourself, following the same shape:

```python
from billing.calculator import calculate_subtotal


def test_calculate_subtotal_sums_multiple_items():
    items = [("Burger", 12.50, 2), ("Fries", 4.00, 2)]

    result = calculate_subtotal(items)

    assert result == 33.00
```

### Go

Create `billing/calculator_test.go` (same package as `calculator.go` —
this gives your tests direct access to everything in it). Here's enough
to get the first case started — write the other five yourself,
following the same shape. For the discount cases (case 2 and case 3),
consider a table-driven test — one `[]struct{...}` of
input/expected pairs, looped with `t.Run` — since they're the same
check repeated with different numbers:

```go
package billing

import "testing"

func TestCalculateSubtotalSumsMultipleItems(t *testing.T) {
	items := []Item{
		{Name: "Burger", Price: 12.50, Qty: 2},
		{Name: "Fries", Price: 4.00, Qty: 2},
	}

	got := CalculateSubtotal(items)

	want := 33.00
	if got != want {
		t.Errorf("got %.2f, want %.2f", got, want)
	}
}
```

### Java

Create `src/test/java/billing/CalculatorTest.java` (package `billing`,
matching `Calculator.java`). Here's enough to get the first case
started — write the other five yourself, following the same shape:

```java
package billing;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;
import org.junit.jupiter.api.Test;

class CalculatorTest {

    @Test
    void calculateSubtotalSumsMultipleItems() {
        List<Calculator.Item> items = List.of(
                new Calculator.Item("Burger", 12.50, 2),
                new Calculator.Item("Fries", 4.00, 2));

        double subtotal = Calculator.calculateSubtotal(items);

        assertEquals(33.00, subtotal);
    }
}
```

## Acceptance criteria

- At least six tests exist, one per case listed above (more is fine —
  for example, splitting the discount case into two is encouraged).
- Every test follows Arrange-Act-Assert, even if informally — no
  test-framework ceremony beyond what your language's standard tool
  already gives you.

### Python

- `uv run pytest -v` passes, with at least one test per function listed
  above.

### Go

- `go test ./...` passes, with at least one test (or subtest, if you
  used table-driven tests) per case listed above.

### Java

- `./gradlew test` passes, with at least one test per case listed
  above.

## Verification

### Python

```bash
cd examples/restaurant-bill/python
uv run pytest -v
cd -
```

Expected: every test shown as `PASSED`, none `FAILED`, none skipped.

### Go

```bash
cd examples/restaurant-bill/go
go test ./... -v
cd -
```

Expected: every test shown as `--- PASS`, none `--- FAIL`.

### Java

```bash
cd examples/restaurant-bill/java
./gradlew test
cd -
```

Expected: `BUILD SUCCESSFUL`. Open
`build/reports/tests/test/index.html` in a browser if you want to see
each test listed individually.

## Think about it

- All six of your tests pass. Does that prove the whole-bill
  calculation is correct for *every* order, or only for the specific
  inputs you tried?
- You tested a small order and a large-enough-to-discount value for the
  discount calculation alone — but did you test the whole-bill
  calculation itself with an order large enough to trigger the
  discount? What might that reveal that your current tests can't?

## If you get stuck

### Python

- **Hint 1:** Import what you're testing at the top of the file:
  `from billing.calculator import calculate_subtotal, calculate_discount,
  calculate_tax, calculate_tip, calculate_bill`.
- **Hint 2:** A test is just a function starting with `test_` that
  contains `assert` statements — pytest finds and runs it automatically.
- **Hint 3:** For floating-point results, comparing with `==` after
  rounding to 2 decimal places (as `calculate_bill` already does) is
  reliable enough for this project; you don't need `pytest.approx` here.

### Go

- **Hint 1:** Putting the test file in `package billing` (not
  `package billing_test`) is what lets it call unexported details
  directly if you ever need to — though for this lab, the five
  exported functions are all you need.
- **Hint 2:** A test is a function named `TestXxx(t *testing.T)` in a
  file ending `_test.go` — `go test` finds and runs it automatically.
- **Hint 3:** For a table-driven test, a slice of small structs (name,
  input, expected) looped with `for _, c := range cases { t.Run(c.name,
  func(t *testing.T) { ... }) }` keeps repeated cases short without
  copy-pasting the assertion logic.

### Java

- **Hint 1:** `@Test` on a method with no arguments and a `void` return
  type is what JUnit 5 looks for — `./gradlew test` finds and runs it
  automatically.
- **Hint 2:** `assertEquals(expected, actual)` — expected comes first;
  getting the order backwards doesn't break the test, but makes failure
  messages read confusingly.
- **Hint 3:** For floating-point results, `assertEquals(double, double)`
  compares exactly; that's fine here because every value in this
  project (prices, rates, totals) is already an exact two-decimal
  number by the time it's computed.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Nothing later assumes
a clean tree yet, but Act IV (starting at Lab 16) does — get in the
habit now.

## What's next

Your tests are green. Then a customer complains about their bill. Time
to find out whether "all tests pass" and "the code is correct" are
actually the same thing.

Continue to [Lab 08 — A bug report arrives](../08-bug-report/README.md).
