# Lab 06 — From script to project

## Story

`examples/restaurant-bill/` calculates a restaurant bill: subtotal, loyalty
discount, tax, tip, total. It works. It is also one function (or one
`main`, in Go and Java) that does five different jobs at once, with no
way to change one part without rereading the whole thing.

You picked your track in Lab 05 — Python, Go, or Java. Read only that
section wherever this page splits — the three starters solve the exact
same problem with the same numbers, so whichever one you picked, the
destination is the same kind of project, built the way your language
actually builds projects.

## Learning objectives

After this lab you should be able to:

- Split a script's distinct responsibilities into separate modules
  (Python), packages (Go), or classes (Java).
- Explain the difference between a pure calculation function and an
  entry point that handles I/O (printing, in this case).
- Describe a project to its own toolchain with a real manifest
  (`pyproject.toml`, `go.mod`, or `build.gradle`) instead of a bare folder
  of files.

## Before you start

- Labs 01-04 complete.
- Continue with the track you picked in Lab 05 — Python, Go, or Java.
  All three are real, complete paths through Labs 06-10 — none of them
  is a preview. You shouldn't need to pick again here.
- If you already started this project at its old location
  (`examples/restaurant-bill/bill.py`, with no `python/` subfolder),
  nothing is lost: move whatever you'd already created into
  `examples/restaurant-bill/python/` yourself (for example
  `mkdir -p examples/restaurant-bill/python && git mv examples/restaurant-bill/bill.py examples/restaurant-bill/python/`,
  adjusting for whatever files you personally added), then continue
  from here. Don't run `git reset --hard` or `git clean` to "start
  over" — either one would throw away work you haven't pushed anywhere
  else.

### Python

- Current directory: `examples/restaurant-bill/python/` for all
  commands below.
- `uv` installed (Lab 05 covers this).
- Read `bill.py` fully before changing anything.

### Go

- Current directory: `examples/restaurant-bill/go/` for all commands
  below.
- Go 1.27.x installed. Check with `go version`. If it's missing, install
  it from the official instructions at
  [go.dev/doc/install](https://go.dev/doc/install) — this course doesn't
  use a Go version manager. (Lab 05's Go track already walked you
  through installing this and the `GOTOOLCHAIN` experiment — if you're
  continuing on the same machine, it's already set up.)
- Read `main.go` fully before changing anything.

### Java

- Current directory: `examples/restaurant-bill/java/` for all commands
  below.
- JDK 21 installed. Check with `java -version` (expect `21` somewhere in
  the output). If it's missing, install Adoptium's Temurin 21 build from
  [adoptium.net](https://adoptium.net/temurin/releases/?version=21). No
  global Gradle install needed — this project ships its own committed
  Gradle Wrapper (`./gradlew`). (Lab 05's Java track already walked you
  through installing this and the `JavaLanguageVersion` experiment — if
  you're continuing on the same machine, it's already set up.)
- Read `src/main/java/Main.java` fully before changing anything.

## Your task

### Python

1. Run `python3 bill.py` (Windows Git Bash: `python bill.py` — Windows'
   official Python installer provides `python`, not `python3`), saving
   its output as a baseline you'll compare against later:
   `python3 bill.py | tee /tmp/bill-before.txt` (`python bill.py | tee
   /tmp/bill-before.txt` on Windows).
2. Identify the distinct responsibilities mixed together in `main()`:
   computing a subtotal, applying a discount, computing tax, computing a
   tip, and printing a receipt.
3. Create `pyproject.toml` for this project: name `restaurant-bill`,
   `requires-python = ">=3.13"`, a `pytest` dev dependency, and
   `[tool.pytest.ini_options]` with `pythonpath = ["."]` (same pattern as
   Lab 05).
4. Create a `billing/` package (`billing/__init__.py`, empty) with a
   module `billing/calculator.py` containing exactly these five pure
   functions, with these exact names and signatures (the next two labs
   depend on these exact names):
   - `calculate_subtotal(items: list[tuple[str, float, int]]) -> float`
     — sum of `price * quantity` for every item.
   - `calculate_discount(subtotal: float) -> float` — 10% of `subtotal`
     if `subtotal >= 50`, otherwise `0`.
   - `calculate_tax(amount: float) -> float` — a flat 8% of `amount`.
   - `calculate_tip(amount: float, tip_rate: float) -> float` —
     `amount * tip_rate`.
   - `calculate_bill(items: list[tuple[str, float, int]], tip_rate: float)
     -> dict[str, float]` — composes the four functions above into a
     dict with keys `subtotal`, `discount`, `tax`, `tip`, `total`. **For
     now, compute `tax` from the full `subtotal`, exactly like the
     original script does** — this refactor must reproduce the existing
     behavior exactly, bugs included. You are not fixing anything yet.
5. Create `billing/cli.py` with a `main()` that calls `calculate_bill`
   *once* and prints a receipt whose output is byte-for-byte identical
   to the original script's, using only the values from the dict it got
   back (don't recompute anything separately — one source of truth).
6. Create `main.py` at the project root that imports `main` from
   `billing.cli` and calls it under `if __name__ == "__main__":`.
7. Run your new entry point the same way, saving its output too:
   `uv run python main.py | tee /tmp/bill-after.txt`. Diff the two
   files: `diff /tmp/bill-before.txt /tmp/bill-after.txt`.
8. Once the diff is clean, delete `bill.py` — it's fully replaced.

### Go

1. Run `go run main.go`, saving its output as a baseline:
   `go run main.go | tee /tmp/bill-before.txt`. Notice this works with
   no `go.mod` at all yet — `go run` on an explicit file argument
   doesn't need a module, the same way `python3 bill.py` didn't need
   anything either.
2. Identify the distinct responsibilities mixed together in `main()`:
   computing a subtotal, applying a discount, computing tax, computing a
   tip, and printing a receipt.
3. Turn this directory into a real module: `go mod init restaurant-bill`.
   This creates `go.mod` — Go's equivalent of `pyproject.toml`, describing
   this folder as a project with a name, not just a folder of files.
4. Create a `billing` package in a new `billing/` subdirectory, with a
   file `billing/calculator.go` (`package billing`) containing exactly
   these five exported functions and two types (the next two labs
   depend on these exact names):
   - `type Item struct { Name string; Price float64; Qty int }`
   - `type Bill struct { Subtotal, Discount, Tax, Tip, Total float64 }`
   - `func CalculateSubtotal(items []Item) float64` — sum of
     `Price * float64(Qty)` for every item.
   - `func CalculateDiscount(subtotal float64) float64` — 10% of
     `subtotal` if `subtotal >= 50`, otherwise `0`.
   - `func CalculateTax(amount float64) float64` — a flat 8% of `amount`.
   - `func CalculateTip(amount, tipRate float64) float64` —
     `amount * tipRate`.
   - `func CalculateBill(items []Item, tipRate float64) Bill` — composes
     the four functions above into a `Bill`. **For now, compute `Tax`
     from the full `subtotal`, exactly like the original program does**
     — bugs included, you are not fixing anything yet.
5. Create `billing/cli.go` (same package) with a function
   `func Run(items []Item, tipRate float64)` that calls `CalculateBill`
   *once* and prints a receipt byte-for-byte identical to the original
   program's, using only the fields on the `Bill` it got back.
6. Rewrite `main.go` at the project root so its entire `func main()` is
   just: build the `items` slice, then call `billing.Run(items, 0.15)`.
   You'll need to import this module's own `billing` package by its
   module path: `import "restaurant-bill/billing"`.
7. Run your new entry point the same way, saving its output too:
   `go run main.go | tee /tmp/bill-after.txt`. Diff the two files:
   `diff /tmp/bill-before.txt /tmp/bill-after.txt`.
8. Once the diff is clean, confirm `go run .` (no file argument, the
   module-aware form) produces the same output too — this only works
   now that `go.mod` exists.

### Java

1. Run the starter, saving its output as a baseline:
   `./gradlew run --console=plain | tee /tmp/bill-before.txt`. The first
   run downloads the Gradle distribution and dependencies if they
   aren't cached yet — that can take a minute or two; it's not stuck,
   and every run after the first is fast.
2. Identify the distinct responsibilities mixed together in `main()`:
   computing a subtotal, applying a discount, computing tax, computing a
   tip, and printing a receipt.
3. Create a `billing` package: a new file
   `src/main/java/billing/Calculator.java` (`package billing;`)
   containing exactly these two nested types and five static methods
   (the next two labs depend on these exact names):
   - `public static class Item` with public fields `name` (`String`),
     `price` (`double`), `qty` (`int`), and a matching constructor.
   - `public static class Bill` with public fields `subtotal`,
     `discount`, `tax`, `tip`, `total` (all `double`), and a matching
     constructor.
   - `public static double calculateSubtotal(List<Item> items)` — sum of
     `price * qty` for every item.
   - `public static double calculateDiscount(double subtotal)` — 10% of
     `subtotal` if `subtotal >= 50`, otherwise `0`.
   - `public static double calculateTax(double amount)` — a flat 8% of
     `amount`.
   - `public static double calculateTip(double amount, double tipRate)`
     — `amount * tipRate`.
   - `public static Bill calculateBill(List<Item> items, double tipRate)`
     — composes the four methods above into a `Bill`. **For now, compute
     `tax` from the full `subtotal`, exactly like the original program
     does** — bugs included, you are not fixing anything yet.
4. Create `src/main/java/billing/Cli.java` (same package) with a method
   `public static void run(List<Calculator.Item> items, double tipRate)`
   that calls `Calculator.calculateBill` *once* and prints a receipt
   byte-for-byte identical to the original program's, using only the
   fields on the `Bill` it got back.
5. Rewrite `src/main/java/Main.java` so its entire `main` method is
   just: build the `items` list, then call `Cli.run(items, 0.15)`.
   You'll need `import billing.Calculator;` and `import billing.Cli;`.
6. Add JUnit 5 to `build.gradle` so Lab 07 has something to write tests
   with — add a `repositories { mavenCentral() }` block, these
   dependencies:
   ```gradle
   dependencies {
       testImplementation platform('org.junit:junit-bom:5.11.0')
       testImplementation 'org.junit.jupiter:junit-jupiter'
       testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
   }
   ```
   and a `test { useJUnitPlatform() }` block. No test file exists yet —
   that's fine, `./gradlew test` succeeds with zero tests found.
7. Run your refactored entry point the same way, saving its output too:
   `./gradlew run --console=plain | tee /tmp/bill-after.txt`. Diff the
   two files (you'll need to drop Gradle's own banner lines from the
   comparison, since those aren't part of the program's output) —
   easiest: compare just the `Receipt` block onward in each file, or
   diff `./gradlew run --console=plain --quiet` output directly.

## Acceptance criteria

### Python

- `examples/restaurant-bill/python/bill.py` no longer exists.
- `uv run python main.py` produces output *identical* to the original
  script's output.
- `billing/calculator.py` defines all five functions with the exact names
  and signatures listed above.

### Go

- `examples/restaurant-bill/go/go.mod` exists, declaring module
  `restaurant-bill`.
- `go run .` produces output *identical* to the original program's
  output.
- `billing/calculator.go` defines the `Item`/`Bill` types and all five
  functions with the exact names and signatures listed above.

### Java

- `examples/restaurant-bill/java/build.gradle` declares the JUnit 5
  dependencies and `useJUnitPlatform()`.
- `./gradlew run` produces output *identical* to the original program's
  output.
- `billing/Calculator.java` defines the `Item`/`Bill` types and all five
  methods with the exact names and signatures listed above.

## Verification

### Python

```bash
cd examples/restaurant-bill/python
uv run python main.py | tee /tmp/bill-after.txt
diff /tmp/bill-before.txt /tmp/bill-after.txt && echo "IDENTICAL"
test -f bill.py && echo "bill.py still exists — delete it" || echo "bill.py correctly removed"
cd -
```

Expected: `IDENTICAL` and `bill.py correctly removed`.

### Go

```bash
cd examples/restaurant-bill/go
go run . | tee /tmp/bill-after.txt
diff /tmp/bill-before.txt /tmp/bill-after.txt && echo "IDENTICAL"
test -f go.mod && echo "go.mod exists" || echo "go.mod missing — run go mod init"
cd -
```

Expected: `IDENTICAL` and `go.mod exists`.

### Java

```bash
cd examples/restaurant-bill/java
./gradlew run --console=plain --quiet | tee /tmp/bill-after.txt
diff /tmp/bill-before.txt /tmp/bill-after.txt && echo "IDENTICAL"
./gradlew test
cd -
```

Expected: `IDENTICAL`, and `./gradlew test` succeeds (even with zero
tests — that's expected until Lab 07).

## Think about it

- You just proved your refactor didn't change behavior using a manual
  `diff`. What would you have to redo, by hand, every single time you
  changed one more line, without an automated test?
- The calculation step that figures out tax only needs one number to do
  its job. Why is that a useful property for a function (or method) to
  have?

## If you get stuck

### Python

- **Hint 1:** Five functions in `calculator.py`, one function in
  `cli.py`, one two-line `main.py`. That's the whole structure.
- **Hint 2:** `calculate_bill` should call the other four functions —
  don't reimplement their logic inline.
- **Hint 3:** If your diff isn't empty, print both files with `cat -A`
  or compare a single line at a time — floating-point formatting (`.2f`)
  is a common source of tiny mismatches.

### Go

- **Hint 1:** Five functions plus two types in `calculator.go`, one
  function in `cli.go`, a two-line `main()`. That's the whole structure.
- **Hint 2:** `CalculateBill` should call the other four functions —
  don't reimplement their logic inline.
- **Hint 3:** The import path for your own package is
  `"<module name from go.mod>/billing"` — if `go run .` can't find it,
  double-check `go.mod`'s first line matches what you're importing.

### Java

- **Hint 1:** Two nested types plus five static methods in
  `Calculator.java`, one static method in `Cli.java`, a two-line `main`.
  That's the whole structure.
- **Hint 2:** `calculateBill` should call the other four methods — don't
  reimplement their logic inline.
- **Hint 3:** If `./gradlew run` seems to hang the first time, it's
  downloading the Gradle distribution and dependencies — let it finish
  once; every run after that is fast.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Nothing later assumes
a clean tree yet, but Act IV (starting at Lab 16) does — get in the
habit now.

## What's next

Your refactor preserved behavior. But "preserved" isn't the same as
"correct," and right now the only way to check either one is to read the
code by eye. Next, you'll teach the computer to check for you.

Continue to [Lab 07 — How do we know it works?](../07-automated-tests/README.md).
