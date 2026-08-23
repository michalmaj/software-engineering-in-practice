# Lab 18 — Pull requests and code review

## Story

So far, every change landed on `main` because you merged it yourself,
alone. A teammate should see a change before it lands — even when that
teammate is a real classmate today, or just careful-future-you on a
different day.

## Learning objectives

After this lab you should be able to:

- Open a pull request with a description that explains why a change
  exists, not just what changed.
- Review a diff against a concrete checklist instead of a vague
  impression.
- Leave actionable review comments and respond to them before merging.

## Before you start

- Lab 17 complete: `main` has both the low-stock and expiry-warning
  features, merged.
- Your `examples/team-inventory/` work lives in **your own** GitHub
  repository or fork — this lab's PR happens there, not against the
  shared course repository.
- If your instructor has paired you with a classmate for this lab, plan
  to swap pull requests with them in step 4.

## Your task

1. Create branch `feature/reorder-report` from `main`.
2. Add a function `reorder_report(inventory: list[dict], threshold: int
   = 5) -> str` that reuses `low_stock_items` and returns a formatted
   string like `"Reorder needed: Tomatoes, Milk"` (or `"Nothing to
   reorder."` if the list is empty). Add a test. Commit.
3. Push the branch and open a pull request. **If you're working from a
   fork**, `gh pr create` defaults to opening the PR against the
   *original* repository's default branch, not your own fork's `main`
   — for this exercise (and every PR in this course from now on), you
   want the PR to target your own fork. Either use the GitHub web UI
   (which shows you the base repository before you confirm), or run
   `gh repo set-default <your-fork>` once so `gh pr create` defaults to
   your fork, and double-check the base repository shown before
   submitting either way. Write a description covering: what changed,
   why, and how you verified it (which commands you ran).
4. Review it, using the checklist below:
   - **Paired:** ask your instructor-assigned partner to swap PRs —
     review theirs, they review yours.
   - **Solo:** review your own diff as if a stranger were seeing it for
     the first time, using the same checklist.

   Checklist:
   - Does the description explain *why*, not just *what*?
   - Does the test actually exercise the new behavior, not just call
     the function once?
   - Is there logic here duplicated from `low_stock_items` that should
     be reused instead of rewritten?
   - Would you understand this diff without asking the author a
     question?
5. Leave at least two concrete review comments — on GitHub if paired;
   in `labs/18-pull-requests-and-review/my-review-notes.md` if solo.
   One comment must be about behavior, one about clarity.
6. Address each comment (fix the code, or write a one-line reply
   explaining why not), then merge the PR using GitHub's merge button —
   not a local `git merge`.
7. Pull the merged change into your local `main`.

## Acceptance criteria

- A pull request existed with a description covering what/why/how
  verified.
- At least two review comments exist (on GitHub, or in
  `my-review-notes.md` if solo), one about behavior and one about
  clarity.
- After pulling, local `main` contains `reorder_report` and its test,
  and `uv run pytest` passes.

## Verification

```bash
cd examples/team-inventory
git log --oneline -3
uv run pytest -v
cd -
```

Expected: a merge commit (or squash commit, depending on your repo's
merge settings) for `feature/reorder-report`, and all tests passing.

## Think about it

- What's the difference between a reviewer checking "does this run" and
  a reviewer checking "will the next person who reads this understand
  it"? Which one did the checklist push you toward?
- If you reviewed solo, what did you notice about your own code that
  you might have skipped if you'd only run the tests and called it
  done?

## If you get stuck

- **Hint 1:** `gh pr create --fill` uses your branch's commit messages
  to pre-fill the PR title and body — faster than typing both by hand,
  though you should still improve the description afterward.
- **Hint 2:** "Reuse `low_stock_items`" means calling it from
  `reorder_report`, not copying its filtering logic into a second
  place.
- **Hint 3:** If working solo, write your review comments as if you
  won't remember any context six months from now — that constraint
  makes vague comments obviously useless.

## What's next

Reviewed, merged code is still only as good as what nobody remembered
to actually check. Next, the repository starts checking itself.

Continue to [Lab 19 — The repository should check itself](../19-repository-checks-itself/README.md).
