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
- Reach a real review outcome before merging — an actionable comment
  addressed, or an approval backed by an actual checklist pass.

## Before you start

- Lab 17 complete: `main` has both the low-stock and expiry-warning
  features, merged, in your chosen track.
- Your `examples/team-inventory/` work lives in **your own** GitHub
  repository or fork — this lab's PR happens there, not against the
  shared course repository.
- If your instructor has paired you with a classmate for this lab, plan
  to swap pull requests with them in step 4.

### Python

- Current directory: `examples/team-inventory/python/`.

### Go

- Current directory: `examples/team-inventory/go/`.

### Java

- Current directory: `examples/team-inventory/java/`.

## Your task

1. Create branch `feature/reorder-report` from `main`.

### Python

2. Add a function `reorder_report(inventory: list[dict], threshold: int
   = 5) -> str` that reuses `low_stock_items` and returns a formatted
   string like `"Reorder needed: Tomatoes, Milk"` (or `"Nothing to
   reorder."` if the list is empty). Insert it immediately above
   `summarize`. Add a test. Commit.

### Go

2. Add a function `func ReorderReport(inventory []Item, threshold int)
   string` that reuses `LowStockItems` and returns a formatted string
   like `"Reorder needed: Tomatoes, Milk"` (or `"Nothing to reorder."`
   if the list is empty). Insert it immediately above `Summarize`. Add
   a test. Commit.

### Java

2. Add a method `public static String reorderReport(List<Item>
   inventory, int threshold)` that reuses `lowStockItems` and returns
   a formatted string like `"Reorder needed: Tomatoes, Milk"` (or
   `"Nothing to reorder."` if the list is empty). Insert it
   immediately above `summarize`. Add a test. Commit.

## All tracks

3. Push the branch and open a pull request. Figure out where it's
   actually going first — **don't assume**:
   - **GitHub's web UI** (the reliable path for a first PR): click
     **Compare & pull request** on your pushed branch, or go to your
     fork's **Pull requests** tab and click **New pull request**.
     Before clicking the final **Create pull request** button, read
     the **base repository** and **base branch** shown at the top of
     the page — they must be *your own* fork and *your own* `main`,
     not the course repository you originally forked from. GitHub
     sometimes defaults the base to the repository you forked *from*,
     which is exactly the wrong target here.
   - **`gh pr create`** (optional — only if you already have GitHub
     CLI installed; this course never requires installing it): it
     defaults to opening the PR against the repository you forked
     *from*, not your own fork — run `gh repo set-default
     <your-fork>` once so it defaults correctly, and double-check the
     base repository it prints before confirming, either way.

   Never direct this (or any future) PR at the shared course
   repository — it's always your own fork's `main`.

   Write a description covering: what changed, why, and how you
   verified it (which commands you ran).
4. Review it, using the checklist below:
   - **Paired:** ask your instructor-assigned partner to swap PRs —
     review theirs, they review yours.
   - **Solo:** review your own diff as if a stranger were seeing it for
     the first time, using the same checklist.

   Checklist:
   - Does the description explain *why*, not just *what*?
   - Does the test actually exercise the new behavior, not just call
     the function once?
   - Is there logic here duplicated from the low-stock function that
     should be reused instead of rewritten?
   - Would you understand this diff without asking the author a
     question?
5. Depending on what the review actually finds:
   - **It finds an actionable problem** — something a reader would
     genuinely want changed or clarified, not a rephrasing of the
     diff: leave at least one substantive comment (on GitHub if
     paired; in `labs/18-pull-requests-and-review/my-review-notes.md`
     if solo), then address it — fix the code, or reply explaining why
     not — and confirm the fix is actually there.
   - **It finds nothing actionable**: approve it (on GitHub if
     paired), or write one line in `my-review-notes.md` if solo
     confirming each checklist item was actually checked, not just
     "looks good." Don't invent a comment just to produce one.
6. Merge the PR using GitHub's merge button — not a local `git
   merge` — once the review has reached one of those two outcomes.
7. Pull the merged change into your local `main`.

## Acceptance criteria

- A pull request existed, targeting **your own fork's** `main` (never
  the course repository), with a description covering what/why/how
  verified.
- The review reached one of two legitimate outcomes: a substantive
  comment was left and addressed, or the PR was approved with a short
  record that the checklist was actually checked — never a comment
  manufactured just to satisfy this requirement.
- After pulling, local `main` contains the new function/method and its
  test, and your track's test command passes.

## Verification

### Python

```bash
cd examples/team-inventory/python
git log --oneline -3
uv run pytest -v
cd -
```

### Go

```bash
cd examples/team-inventory/go
git log --oneline -3
go test ./... -v
cd -
```

### Java

```bash
cd examples/team-inventory/java
git log --oneline -3
./gradlew test
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

- **Hint 1:** On the web UI, the base repository and base branch are
  shown as two dropdowns right at the top of the "Open a pull request"
  page — read them before you read anything else on that page.
- **Hint 2:** "Reuse the low-stock function" means calling it from
  your new function/method, not copying its filtering logic into a
  second place.
- **Hint 3:** If working solo, write whatever you record — a comment
  or the approval note — as if you won't remember any context six
  months from now. That constraint makes vague notes obviously
  useless, whichever outcome the review reached.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Nothing later assumes
a clean tree yet, but Act IV (starting at Lab 16) does — get in the
habit now.

## What's next

Reviewed, merged code is still only as good as what nobody remembered
to check. Next, the repository starts checking itself.

Continue to [Lab 19 — The repository should check itself](../19-repository-checks-itself/README.md).
