# Lab 17 — The merge conflict

## Story

Both features are ready. Time to bring them into `main`, one at a
time.

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
  `feature/expiry-warning` both exist, each with a passing test suite,
  in your chosen track.

### Python

- Current directory: `examples/team-inventory/python/`, on branch
  `main`.

### Go

- Current directory: `examples/team-inventory/go/`, on branch `main`.

### Java

- Current directory: `examples/team-inventory/java/`, on branch
  `main`.

## Your task

1. Confirm you're on `main`: `git switch main`.
2. Merge the first feature: `git merge feature/low-stock-warning`. This
   should complete without any conflict — read the message Git prints
   (likely a fast-forward, since `main` hasn't moved since you
   branched).
3. Run your track's test command to confirm `main` now has the
   low-stock feature and still passes.
4. Merge the second feature: `git merge feature/expiry-warning`. This
   **will** conflict — in **two files**: your source file and your
   test file.
5. Open your source file (see your track's exact conflict shape
   below). Read both sides of each block before touching anything.
6. Resolve the conflict by keeping **both** changes. Delete every
   conflict marker.
7. Open your test file (see your track's exact conflict shape below).
   Resolve it by keeping **both** additions.
8. Run your track's test command. All tests — the original, the
   low-stock one, and the expiry one — must pass.
9. Stage both resolved files and complete the merge (Git pre-fills a
   merge commit message; you don't need `-m`).
10. Run `git log --oneline --graph -5` and confirm both features are
    now part of `main`'s history.

### Python — the exact conflict you'll see

Two blocks in `inventory.py`: one where each branch added its own new
function (the whole function body differs, since the two filters are
written differently), one inside `summarize` where each branch
appended its own two lines. Two blocks in `tests/test_inventory.py`:
the `import` line (each branch imported a different new name), and the
new test function each branch added (each named differently and
calling a different function — this is one conflict block because the
two test functions sit on directly adjacent lines).

### Go — the exact conflict you'll see

This is **not** the same shape as Python's, and that's expected, not a
mistake on your part: Go has no `import` line to conflict on (calling
another function in the same package needs no import), so
`inventory_test.go` conflicts in exactly **one** block — the two test
functions, adjacent, each named differently and calling a different
function. In `inventory.go`, the first conflict block covers four
lines on each side — the function signature, the `var names []string`
line, the `for` loop line, and the `if` condition — even though the
middle two of those four lines are textually identical between
branches; Git still includes them inside the markers. Only the
five-line tail after that (`names = append(names, item.Name)`, two
closing braces, `return names`, and the function's closing brace)
matches well enough for Git to merge it automatically, outside the
markers. The second conflict, inside `Summarize`, covers the two
inserted blocks in full, since neither side shares a matching tail
there.

### Java — the exact conflict you'll see

Same shape as Go, for the same reason: no import-line conflict (both
branches call a static method on the same class), so
`InventoryTest.java` conflicts in exactly **one** block — the two
`@Test` methods, adjacent (the `@Test` annotation line itself sits
just *before* the conflict and matches on both sides, so it's not
part of the marked block). In `Inventory.java`, like Go, the first
conflict block covers four lines on each side — the method signature,
the `List<String> names = new ArrayList<>();` line, the `for` loop
line, and the `if` condition — even though the middle two are
textually identical between branches. Only the five-line tail after
that (`names.add(item.name);`, two closing braces, `return names;`,
and the method's closing brace) merges automatically, outside the
markers. The second conflict, inside `summarize`, covers both full
inserted blocks.

## Acceptance criteria

- No conflict markers remain anywhere in your source file or test
  file.
- Both new functions/methods are defined and used inside
  `summarize`/`Summarize`.
- Your track's test command passes with every test from both branches
  present (3 tests total).
- A merge commit for `feature/expiry-warning` exists on `main`.

## Verification

### Python

```bash
cd examples/team-inventory/python
if grep -nE '^(<<<<<<<|=======|>>>>>>>)' inventory.py tests/test_inventory.py; then
    echo "Conflict markers remain."
    exit 1
else
    echo "No conflict markers remain."
fi
uv run pytest -v
git log --oneline -4
cd -
```

### Go

```bash
cd examples/team-inventory/go
if grep -nE '^(<<<<<<<|=======|>>>>>>>)' inventory.go inventory_test.go; then
    echo "Conflict markers remain."
    exit 1
else
    echo "No conflict markers remain."
fi
go test ./... -v
git log --oneline -4
cd -
```

### Java

```bash
cd examples/team-inventory/java
if grep -nE '^(<<<<<<<|=======|>>>>>>>)' src/main/java/Inventory.java src/test/java/InventoryTest.java; then
    echo "Conflict markers remain."
    exit 1
else
    echo "No conflict markers remain."
fi
./gradlew test
git log --oneline -4
cd -
```

Expected: `No conflict markers remain.`, every test passed, and the
merge commit visible in the log. Note the `exit 1` inside the `if` —
without it, this check would print "Conflict markers remain." and
still exit successfully, which defeats the point of a check. Try it
both ways on a file you know still has markers in it, and on one that
doesn't, to see the difference for yourself.

## Think about it

- Neither branch edited a line the other branch also edited — both only
  *added* new lines, at the same location, in the same two files. Why
  did Git still treat both files as conflicts instead of quietly
  keeping both additions?
- A teammate says "just take mine, delete theirs" without reading the
  other side of a conflict. What's the concrete risk in doing that here
  — in either file?

## If you get stuck

### Python

- **Hint 1:** `<<<<<<< HEAD` marks the start of *your current branch's*
  version; `=======` divides the two sides; `>>>>>>> feature/expiry-warning`
  marks the end of the *incoming* branch's version.
- **Hint 2:** `inventory.py` has two separate conflict blocks; the test
  file also has two — one on the import line, one spanning the new test
  function's name and body. Resolve every block you find — don't stop
  after the first file.
- **Hint 3:** After editing, both files should contain zero
  `<<<<<<<`, `=======`, or `>>>>>>>` lines — if `grep` finds any in
  either file, you're not done.

### Go

- **Hint 1:** `<<<<<<< HEAD` marks the start of *your current branch's*
  version; `=======` divides the two sides; `>>>>>>>
  feature/expiry-warning` marks the end of the *incoming* branch's
  version.
- **Hint 2:** `inventory.go` has two conflict blocks, but the first one
  is shorter than the whole function — it stops before the closing
  lines both functions share (`names = append(...)` through the final
  `}`), which aren't marked at all. Don't assume you need to rewrite
  the whole function from the markers; read what's actually between
  them.
- **Hint 3:** After editing, both files should contain zero
  `<<<<<<<`, `=======`, or `>>>>>>>` lines — if `grep` finds any in
  either file, you're not done.

### Java

- **Hint 1:** `<<<<<<< HEAD` marks the start of *your current branch's*
  version; `=======` divides the two sides; `>>>>>>>
  feature/expiry-warning` marks the end of the *incoming* branch's
  version.
- **Hint 2:** `Inventory.java` has two conflict blocks, but the first
  one is shorter than the whole method — it stops before the closing
  lines both methods share (`names.add(...)` through the final `}`),
  which aren't marked at all. Don't assume you need to rewrite the
  whole method from the markers; read what's actually between them.
- **Hint 3:** After editing, both files should contain zero
  `<<<<<<<`, `=======`, or `>>>>>>>` lines — if `grep` finds any in
  either file, you're not done.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Nothing later assumes
a clean tree yet, but Act IV (starting at Lab 16) does — get in the
habit now.

## What's next

You resolved this conflict locally, alone, then completed the merge
directly on `main`. In a real team, a change like this would go through
review before landing. Next, you'll do that properly.

Continue to [Lab 18 — Pull requests and code review](../18-pull-requests-and-review/README.md).
