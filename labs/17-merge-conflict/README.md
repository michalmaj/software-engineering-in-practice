# Lab 17 — The merge conflict

## Story

Both features are ready. Time to bring them into `main`, one at a time.

## Learning objectives

After this lab you should be able to:

- Merge a branch that has no conflicts and recognize what a clean merge
  looks like.
- Read Git conflict markers and identify exactly what each side
  changed.
- Resolve a conflict by combining both changes, not by blindly picking
  one side.

## Before you start

- Lab 16 complete: `feature/low-stock-warning` and
  `feature/expiry-warning` both exist, each with a passing test suite.
- Current directory: `examples/team-inventory/`, on branch `main`.

## Your task

1. Confirm you're on `main`: `git switch main`.
2. Merge the first feature: `git merge feature/low-stock-warning`. This
   should complete without any conflict — read the message Git prints
   (likely a fast-forward, since `main` hasn't moved since you branched).
3. Run `uv run pytest -v` to confirm `main` now has the low-stock
   feature and still passes.
4. Merge the second feature: `git merge feature/expiry-warning`. This
   **will** conflict — in **two files**: `inventory.py` and
   `tests/test_inventory.py`.
5. Open `inventory.py` first. You'll find two separate conflict blocks
   marked with `<<<<<<< HEAD`, `=======`, and `>>>>>>>
   feature/expiry-warning`: one where each branch added its own new
   function, one inside `summarize` where each branch appended its own
   line. Read both sides of each block before touching anything.
6. Resolve both blocks by keeping **both** changes — both new function
   definitions, and both lines appended inside `summarize` (in either
   order). Delete every conflict marker.
7. Open `tests/test_inventory.py`. It conflicts too — on the `import`
   line (each branch imported a different new name) and inside the new
   test function (each branch named it differently and asserted a
   different function). Resolve it by keeping **both** imports and
   **both** test functions, each testing its own feature.
8. Run `uv run pytest -v`. All three tests — the original, the
   low-stock one, and the expiry one — must pass.
9. Stage both resolved files and complete the merge:
   `git add inventory.py tests/test_inventory.py` then `git commit`
   (Git pre-fills a merge commit message; you don't need `-m`).
10. Run `git log --oneline --graph -5` and confirm both features are
    now part of `main`'s history.

## Acceptance criteria

- No conflict markers remain anywhere in `inventory.py` or
  `tests/test_inventory.py`.
- Both `low_stock_items` and `expiring_items` are defined and used
  inside `summarize`.
- `uv run pytest` passes with every test from both branches present
  (3 tests total).
- A merge commit for `feature/expiry-warning` exists on `main`.

## Verification

```bash
cd examples/team-inventory
grep -c '<<<<<<<\|=======\|>>>>>>>' inventory.py tests/test_inventory.py
uv run pytest -v
git log --oneline -4
cd -
```

Expected: `0` for both files (no output for a file counts as an error
here — that itself confirms no markers remain in it), 3 tests passed,
and the merge commit visible in the log.

## Think about it

- Neither branch edited a line the other branch also edited — both only
  *added* new lines, at the same location, in two different files. Why
  did Git still treat both files as conflicts instead of quietly
  keeping both additions?
- A teammate says "just take mine, delete theirs" without reading the
  other side of a conflict. What's the concrete risk in doing that here
  — in either file?

## If you get stuck

- **Hint 1:** `<<<<<<< HEAD` marks the start of *your current branch's*
  version; `=======` divides the two sides; `>>>>>>> feature/expiry-warning`
  marks the end of the *incoming* branch's version.
- **Hint 2:** `inventory.py` has two separate conflict blocks; the test
  file has more, smaller ones (import line, function name, assertion
  line) because both branches edited the same few lines of the same
  test function. Resolve every block you find — don't stop after the
  first file.
- **Hint 3:** After editing, both files should contain zero
  `<<<<<<<`, `=======`, or `>>>>>>>` lines — if `grep` finds any in
  either file, you're not done.

## What's next

You resolved this conflict locally, alone, then completed the merge
directly on `main`. In a real team, a change like this would go through
review before landing. Next, you'll do that properly.

Continue to [Lab 18 — Pull requests and code review](../18-pull-requests-and-review/README.md).
