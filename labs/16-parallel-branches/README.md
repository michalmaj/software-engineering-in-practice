# Lab 16 — Branches exist because work happens in parallel

## Story

You and a teammate both need to add a warning feature to the kitchen
inventory script, today, without waiting for each other. Branches are
how you both start from the same place and work at the same time
without touching each other's work yet.

## Learning objectives

After this lab you should be able to:

- Create and switch to a new branch from a specific starting point.
- List existing branches and explain what each one contains.
- Read `git log --all --graph` output and identify diverging history.

## Before you start

- Labs 06-15 complete.
- Current directory: `examples/team-inventory/`.
- Confirm the starter works: `uv run pytest -v` and `uv run python
  inventory.py`.

## Your task

You'll play both "teammates" yourself, one branch at a time.

**Teammate A — low stock warning:**

1. From `main`, create and switch to a new branch:
   `git switch -c feature/low-stock-warning`.
2. In `inventory.py`, add:
   `low_stock_items(inventory: list[dict], threshold: int = 5) -> list[str]`
   returning the names of items whose `quantity` is below `threshold`.
3. In `summarize`, right after the `for` loop and before the `return`
   line, add:
   ```python
       low_stock = low_stock_items(inventory)
       if low_stock:
           lines.append(f"Low stock: {', '.join(low_stock)}")
   ```
4. Add a test for `low_stock_items` in `tests/test_inventory.py`.
5. Run the tests, then commit everything on this branch.

**Teammate B — expiry warning:**

6. Switch back to `main` — **do not merge `feature/low-stock-warning`
   yet.**
7. From `main`, create and switch to a new branch:
   `git switch -c feature/expiry-warning`.
8. In `inventory.py`, add:
   `expiring_items(inventory: list[dict], days: int = 3) -> list[str]`
   returning the names of items whose `expires_in_days` is `<=` `days`.
9. In `summarize`, at the **same location** as step 3 (right after the
   `for` loop, before `return`), add:
   ```python
       expiring = expiring_items(inventory)
       if expiring:
           lines.append(f"Expiring soon: {', '.join(expiring)}")
   ```
10. Add a test for `expiring_items`. Run the tests, then commit
    everything on this branch.

11. Run `git branch` and `git log --all --graph --oneline -5`. Confirm
    both branches exist, both start from the same commit, and neither
    contains the other's work yet.

## Acceptance criteria

- Both `feature/low-stock-warning` and `feature/expiry-warning` exist
  as branches, each with one commit on top of the same `main` commit.
- Checking out either branch individually and running `uv run pytest`
  passes on that branch alone.
- Neither branch's `inventory.py` contains the other branch's function.

## Verification

```bash
cd examples/team-inventory
git branch
git log --all --graph --oneline -5
git switch feature/low-stock-warning && uv run pytest -v
git switch feature/expiry-warning && uv run pytest -v
git switch main
cd -
```

Expected: both branches listed, both test runs pass, and `main` itself
still has neither feature (that's Lab 17's job).

## Think about it

- You branched `feature/expiry-warning` from `main`, not from
  `feature/low-stock-warning`. What would be different about the
  upcoming merge if you'd branched it from `feature/low-stock-warning`
  instead?
- Both branches changed `summarize` at the same spot. Right now, does
  Git see that as a problem? Why or why not, at this stage?

## If you get stuck

- **Hint 1:** `git switch -c <name>` creates and switches to a branch
  in one step. Plain `git switch <name>` switches to a branch that
  already exists.
- **Hint 2:** Make sure you're on `main` (`git branch` shows a `*` next
  to your current branch) before creating each new feature branch —
  if you branch B from A by mistake, B will already contain A's work.
- **Hint 3:** The two inserted blocks in `summarize` must go in the
  exact same place (right after the `for` loop) in both branches for
  the next lab to work as described.

## What's next

Both features exist. Neither knows about the other. Next, you bring
them together — and discover they don't just merge quietly.

Continue to [Lab 17 — The merge conflict](../17-merge-conflict/README.md).
