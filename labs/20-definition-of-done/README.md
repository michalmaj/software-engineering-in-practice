# Lab 20 — What does "done" mean?

## Story

Two teammates disagree: one says a task is done once the tests pass;
the other says it's not done until it's actually merged and the CI
check is green. Both have a point, and both are incomplete.

## Learning objectives

After this lab you should be able to:

- Write a concrete, checkable Definition of Done for a specific kind of
  project.
- Distinguish a checkable criterion ("CI is green") from a vague one
  ("the code is good").
- Evaluate a completed piece of work against a written standard, not a
  feeling.

## Before you start

- Labs 06-19 complete.
- No code for this lab — skim (don't re-derive) the "Acceptance
  criteria" sections of Labs 11 through 19 before starting.

## Your task

1. Write `labs/20-definition-of-done/definition-of-done.md` containing
   a single Definition of Done checklist, 5-8 items, using markdown
   checkboxes (`- [ ] item`), that would apply to *any* future change
   to `examples/team-inventory`. Base it on what you've actually used
   in Labs 06-19 — tests, review, CI, documentation — not on a generic
   list you haven't earned yet.
2. Each item must be checkable: answerable with yes or no by looking at
   something concrete (a command's exit code, a file's existence, a
   PR's state) — not "the code is clean" or "it works well."
3. Pick one specific past lab (11 through 19) and, in the same file,
   check its actual outcome against your own checklist item by item.
   Where it doesn't fully satisfy an item, say so honestly.

## Acceptance criteria

- `definition-of-done.md` has between 5 and 8 checklist items, each
  independently checkable.
- The retrospective check against one named past lab is included, with
  an honest answer for each item (not all "yes" by default).

## Verification

```bash
test -f labs/20-definition-of-done/definition-of-done.md && echo "DoD exists"
grep -c '^- \[' labs/20-definition-of-done/definition-of-done.md
```

Expected: file exists, and the count is between 5 and 8.

## Think about it

- Is a Definition of Done a technical concept or a team-agreement
  concept? Could two different teams, working on similarly-sized
  projects, reasonably arrive at two different, both-valid Definitions
  of Done?
- Which item on your list would have been impossible to write before
  Lab 19 existed? What does that tell you about how a Definition of
  Done evolves alongside a project's own tooling?

## If you get stuck

- **Hint 1:** Reasonable candidate items: tests pass locally, tests
  pass in CI, the PR has a description explaining why, at least one
  review comment was addressed, no conflict markers remain anywhere,
  the change is merged (not just opened as a PR).
- **Hint 2:** If an item can't be checked by running a command or
  looking at a specific piece of state, rewrite it until it can.
- **Hint 3:** For the style of a good checklist/notes file, look back
  at Lab 12's `COMPARISON.md` or Lab 15's `my-notes.md`.

## What's next

Act IV is done — you can work with a team safely: branch, resolve
conflict, review, and let CI catch what review misses. Next, the
software has to survive contact with the outside world: other systems,
stored data, and failures that are nobody's fault.

Continue to [Lab 21 — An API is a contract](../21-api-is-a-contract/README.md).
