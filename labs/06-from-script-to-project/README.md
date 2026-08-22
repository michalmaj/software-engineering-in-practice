# Lab 06 — From script to project

## Story

`examples/restaurant-bill/bill.py` calculates a restaurant bill: subtotal,
loyalty discount, tax, tip, total. It works. It is also one function that
does five different jobs at once, with no way to change one part without
rereading the whole thing.

## Learning objectives

After this lab you should be able to:

- Split a script's distinct responsibilities into separate modules.
- Explain the difference between a pure calculation function and an
  entry point that handles I/O (printing, in this case).
- Create a minimal `pyproject.toml` describing a project as project
  metadata, not just a folder of files.
- Explain what an empty `tests/` directory signals about a project's
  intentions.

## Before you start

- Labs 01-05 complete.
- Current directory: `examples/restaurant-bill/`.
- Read `bill.py` fully before changing anything.

## Your task

1. Run `python3 bill.py` and save its output — you'll need it to prove
   your refactor didn't change behavior.
2. Identify the distinct responsibilities mixed together in `main()`:
   computing a subtotal, applying a discount, computing tax, computing a
   tip, and printing a receipt.
3. Create `pyproject.toml` for this project: name `restaurant-bill`,
   `requires-python = ">=3.13"`, a `pytest` dev dependency, and
   `[tool.pytest.ini_options]` with `pythonpath = ["."]` (same pattern as
   Lab 05).
4. Create a `billing/` package (`billing/__init__.py`, empty) with a
   module `billing/calculator.py` containing exactly these four pure
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
   *once* and prints the same five-line receipt format as the original
   script, using only the values from the dict it got back (don't
   recompute anything separately — one source of truth).
6. Create `main.py` at the project root that imports `main` from
   `billing.cli` and calls it under `if __name__ == "__main__":`.
7. Create an empty `tests/` directory (just the directory — Lab 07 fills
   it in).
8. Run your new entry point and diff it against the output you saved in
   step 1.
9. Once the diff is clean, delete `bill.py` — it's fully replaced.

## Acceptance criteria

- `examples/restaurant-bill/bill.py` no longer exists.
- `uv run python main.py` produces output *identical* to the original
  script's output.
- `billing/calculator.py` defines all five functions with the exact names
  and signatures listed above.
- `tests/` exists as a directory (even though it's empty for now).

## Verification

```bash
cd examples/restaurant-bill
python3 -c "import billing.calculator as c; print(c.calculate_bill([('Burger',12.50,2),('Fries',4.00,2),('Soda',2.50,2)], 0.15))" 2>&1 || true
uv run python main.py | tee /tmp/bill-after.txt
diff /tmp/bill-before.txt /tmp/bill-after.txt && echo "IDENTICAL"
test -d tests && echo "tests/ directory exists"
test -f bill.py && echo "bill.py still exists — delete it" || echo "bill.py correctly removed"
cd -
```

Expected: `IDENTICAL`, `tests/ directory exists`, and `bill.py correctly
removed`.

## Think about it

- You just proved your refactor didn't change behavior using a manual
  `diff`. What would you have to redo, by hand, every single time you
  changed one more line, without an automated test?
- `calculate_tax` only needs one number to do its job. Why is that a
  useful property for a function to have?

## If you get stuck

- **Hint 1:** Five functions in `calculator.py`, one function in
  `cli.py`, one two-line `main.py`. That's the whole structure.
- **Hint 2:** `calculate_bill` should call the other four functions —
  don't reimplement their logic inline.
- **Hint 3:** If your diff isn't empty, print both files with `cat -A`
  or compare a single line at a time — floating-point formatting (`.2f`)
  is a common source of tiny mismatches.

## What's next

Your refactor preserved behavior — but "preserved" isn't the same as
"correct," and right now the only way to check either one is to read the
code by eye. Next, you'll teach the computer to check for you.

Continue to [Lab 07 — How do we know it works?](../07-automated-tests/README.md).
