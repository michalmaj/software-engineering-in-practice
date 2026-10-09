# Lab 28 — Change request

## Story

The restaurant owner calls: "We keep turning away large groups — birthday
parties, work dinners, ten or twelve people. Can the system handle that
by pushing two tables together?" Your MVP was built around one
reservation, one table.

## Learning objectives

After this lab you should be able to:

- Implement a real requirement change against your own existing design,
  not a toy example.
- Identify exactly which files and data shapes the change forces you to
  touch — and which ones it doesn't.
- Judge, honestly, whether your Lab 26-27 design made this change
  cheap or expensive, and explain why.

## Before you start

- Lab 27 complete: your MVP is implemented, tested, reviewed, and
  merged, with CI green.

## Your task

**The change (give this to your team as-is):**

> Some parties are larger than any single table. The restaurant wants
> TableTime to support combining two specific, physically-adjacent
> tables into one reservation when a party is too large for any single
> table, but small enough to fit the combined capacity. Which specific
> tables can be combined is a fixed, known set (you decide which, and
> how many combinable pairs exist, as part of your design) — this is
> not "combine any two tables," it's "these two tables happen to be
> pushed-together-able in the dining room."

1. Create a branch for this change (for example
   `feature/combined-tables`).
2. Before writing any code, write down a prediction in
   `docs/change-request-impact.md` (in your team's own repository —
   create `docs/` if it doesn't exist yet): which files or components
   do you expect to touch, and does your current data model already
   have a natural place to represent "this reservation uses more than
   one table"? Commit this prediction by itself, as its own commit,
   before any implementation code exists — for example
   `docs: predict impact of combined-table change`. This is the
   "before" record you'll compare against later; writing it after the
   fact would make it a retrospective pretending to be a prediction.
3. Implement the change, updating and adding tests as needed. If an
   existing test needed to change just because of a data shape rename
   (not because its actual behavior assertion was wrong), note that
   specifically in `docs/change-request-impact.md` — that's exactly
   the kind of change-surface cost Lab 12 asked you to watch for.
4. Before opening the PR for review — not after merging — update the
   same `docs/change-request-impact.md` with what actually happened:
   which files or components actually changed, how that compares to
   your prediction, any coupling you didn't expect, and what turned
   out easier or harder than expected. Change surface is a signal to
   analyze, not a score to minimize — several sensibly-related files
   changing for a good reason can be a better outcome than a hack that
   only touched one. This update has to land in the same PR as the
   implementation, not a follow-up commit after merge.
5. Open the PR, get it reviewed, and merge only once CI is green —
   same loop as Lab 27.

## Acceptance criteria

- The combined-table behavior is implemented, tested, reviewed, and
  merged through the same PR workflow as Lab 27.
- `docs/change-request-impact.md` contains both the *before* prediction
  and the *after* reality, and is honest about any mismatch.
- The prediction exists as its own commit in Git history, before any
  commit that implements the change — not written after the fact.
- The actual-impact update was part of the same pull request that
  implemented the change: `git status --short` is clean after merge,
  with no separate documentation commit added afterward.
- Your full test suite (MVP + this change) passes with CI green.

## Verification

Run from your team's own repository root, whichever matches your
Lab 26 ADR:

### Python

```bash
uv run pytest -v
```

### Go

```bash
go test ./...
```

### Java

```bash
./gradlew test
```

Expected: full suite green, including new tests for the combined-table
behavior and for a party too large for any combination being rejected.

## Think about it

- If your data model already stored a small collection of table ids
  instead of a single one, this change would have been much smaller. Was that
  because your team predicted this requirement, or because of an
  unrelated decision that happened to leave room for it?
- Compare this change's actual cost to how confident your `PROJECT_PLAN.md`
  felt about your design in Lab 26. Would you write your Lab 26
  assumptions differently now?

## If you get stuck

- **Hint 1:** If your MVP stored a single table id per reservation,
  the smallest correct change is usually to store a small collection
  of table ids everywhere that field is read or written — whatever
  your language makes idiomatic (a Python `list`, a Go slice, a Java
  `List<String>`, and so on) — resist the urge to add a second,
  parallel field just for the combined case.
- **Hint 2:** Decide your combinable pairs as static, known data (a
  fixed list), not as "any two tables that happen to add up" — the
  brief specifically says these are physically fixed pairs.
- **Hint 3:** If tests fail only because a field was renamed, and the
  actual behavior they check didn't change, that's a sign the failure
  is about the shape of your data, not a real regression — fix the
  assertion, not the logic.

## What's next

You've felt what a real requirement change costs. Next, something goes
wrong in production that nobody asked for — and you find out whether
your tests would have caught it before a customer did.

Continue to [Lab 29 — Production incident](../29-production-incident/README.md).
