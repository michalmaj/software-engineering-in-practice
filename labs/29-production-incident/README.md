# Lab 29 — Production incident

## Story

The restaurant manager calls, annoyed: "Last Saturday, two parties
showed up at 7pm both holding a confirmation for table 4. We had to
scramble. This cannot happen again."

## Learning objectives

After this lab you should be able to:

- Reproduce a reported incident as a concrete, failing test before
  touching implementation code.
- Fix a real defect without breaking any previously-passing behavior.
- Write a blameless postmortem that focuses on the system and process,
  not on who wrote which line.
- Handle an incident report honestly even when it turns out not to be
  reproducible against your own system, without pretending to fix
  something that was never actually broken.

## Before you start

- Lab 28 complete: combined-table support for large parties is merged.

## Your task

**The incident (give this to your team as-is):**

> On Saturday night, two separate reservations were both assigned table
> 4 at 7:00 PM. Both parties arrived expecting that table. Reproduce
> this, fix it, and make sure it can't happen again — silently or
> otherwise.

Before picking a path: check this against your *own* system, as it
actually behaves, not against the `19:00`/`7pm` framing of the
complaint above — that's how a customer describes a problem, not a
claim about your internal data model. Follow **Path A** if two
reservations for the same day and the same time slot (in whatever form
your team's time model from Lab 26 actually takes) can be assigned
overlapping tables today. Follow **Path B** if that exact case is
already prevented, but you haven't yet checked a subtler variant.
Follow **Path C** if you genuinely cannot reproduce any version of
this incident, including the subtler one. Don't force a fake bug into
any of these, and don't force a fix where none is needed.

1. Create a branch for this fix (for example `fix/double-booking`).
   An incident under pressure is exactly when it's tempting to commit
   straight to `main` and skip branch/PR/review — that's precisely the
   moment the workflow exists for. Nothing about "it's an incident"
   suspends it.

**Path A — the bug is real:**

2. Reproduce it: create two reservations for the same day and exact
   time slot, small enough that your assignment logic gives both the
   same table.
3. Write a failing test capturing the exact defect: two reservations
   for the same day/time slot must never be assigned an overlapping set
   of tables.
4. Fix the defect with the smallest change that makes the new test pass
   without breaking any existing test.
5. Continue to step 6 below.

**Path B — the exact case is already prevented:**

2. Write a test *proving* the protection exists (two reservations, same
   exact day/time slot, must get non-overlapping tables) — this should
   already pass, demonstrating the coverage, not creating it.
3. Now go one level deeper, using *your own team's* time model from
   Lab 26 — not a generic example that assumes a model you didn't
   actually build. Find a real, additional case your system's rules
   would allow to slip through, something like:
   - two reservations with overlapping occupancy windows that start at
     different clock times, if your model represents time as clock
     values with an assumed occupancy duration;
   - a reservation using a table that's already committed as half of a
     combined pair from Lab 28, if your model supports table-combining;
   - another case that follows honestly from the assumptions you
     actually wrote down in `PROJECT_PLAN.md` — not one invented purely
     to manufacture a failure.

   If your team's model only has a small number of named, disjoint
   slots (`"lunch"`/`"dinner"`) with no finer-grained overlap possible
   by construction, there may genuinely be no deeper gap at this
   level — if that's true for your system, say so explicitly and move
   to Path C instead of inventing a scenario your own design doesn't
   actually allow.
4. Reproduce the deeper case you identified against your own system.
5. Write a failing test capturing it: two reservations that your
   system's own rules say should conflict — by your team's actual
   definition of overlap from Lab 26, not a borrowed one — must not
   share a table, even though their stored values aren't identical.
6. Fix it. Continue to step 7 below.

**Path C — you cannot reproduce any version of this incident:**

Don't manufacture a failure to have something to fix. An incident that
doesn't reproduce is still real work, and still produces the same
learning outcomes — reproduction attempts, evidence, a regression test
if one was genuinely missing, and honest documentation — just with a
different, equally honest conclusion.

2. Treat the report as an incident that needs verification, not as a
   confirmed defect. Attempt to reproduce it using the same exact-slot
   case from Path A's step 2, and the deeper, model-specific case from
   Path B's step 3.
3. For each attempt, capture what you tried and what actually happened
   — a test that demonstrates the protection already holds counts as
   evidence, the same way it does in Path B.
4. If your existing test suite didn't already have a test proving this
   specific protection, add one now — not because you found a defect,
   but because "the protection exists" deserves a test the same way
   any other behavior worth relying on does.
5. Write down, plainly, what you could *not* confirm — a scenario you
   didn't have time to try, a concern about load or concurrency you
   can't easily reproduce in a test, or anything else honest about the
   limits of this investigation. This belongs in `POSTMORTEM.md`'s
   limitations, not silently omitted.
6. Continue to step 7 below.

**All paths:**

7. Write `POSTMORTEM.md`, blameless — no names, no blame — covering:
   what was reported, customer impact, what you actually found
   (whether that's a confirmed defect, a deeper gap, or a verified
   absence of one), root cause if one exists (a design gap, not a
   "someone made a mistake" narrative), how it was investigated (a
   customer complaint started this, not a monitoring alert — note that
   explicitly), the fix if there was one, the regression or confirming
   test added, any limitations of what you could verify (Path C
   especially), and one concrete system or process change that would
   reduce the chance of this class of problem going unnoticed in the
   future, regardless of which path you followed. If you followed
   Path B, also note that your team's original design already covered
   the simpler case, and describe the deeper gap you found instead. If
   you followed Path C, say so plainly — this was a verification, not
   a fix, and the postmortem should never claim a repair that didn't
   happen.
8. Run the full test suite, then commit the fix (if any), the
   regression or confirming test, and `POSTMORTEM.md` on this branch —
   together or as a couple of small commits, as long as all land before
   the PR.
9. Push the branch, open a PR, and get it reviewed — a review doesn't
   need to be long for an obvious hotfix or a verification writeup, but
   it still has to happen. Merge only once CI is green.

## Acceptance criteria

- **Path A:** a regression test exists, fails before the fix, and
  passes after, without breaking any earlier test.
- **Path B:** a test proves the existing same-slot protection, *and* a
  second test for a deeper case specific to your own time model fails
  before its fix and passes after, without breaking any earlier test.
- **Path C:** at least one test proves the relevant protection(s)
  already hold, and `POSTMORTEM.md` is explicit that this was a
  verification, not a fix, including what couldn't be confirmed.
- `POSTMORTEM.md` exists, is blameless, accurately reflects which path
  you followed, and ends with a concrete systemic recommendation — not
  just "be more careful."
- The fix (if any), its regression or confirming test, and
  `POSTMORTEM.md` were merged through a pull request with a green CI
  check, not committed directly to `main` — incident or not.
- After this lab, `main` contains whatever Path A/B/C actually
  produced plus `POSTMORTEM.md`, and the full suite still passes.

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

Expected: full suite green, including whatever regression or
confirming test your path produced.

## Think about it

- Lab 26's brief never required preventing double-booking. Was that
  omission a mistake in the brief, or a realistic reflection of how
  real specs leave gaps that only show up once something breaks?
- Your postmortem's "how it was investigated" section should be
  honest. If the honest answer is "a customer complained, not our
  tests or monitoring," what does that suggest about what Lab 24's
  observability habits should have covered in your own project?
- If you followed Path C, how is "we verified the protection already
  works, and here's the test that proves it" a genuinely useful
  outcome for whoever reads this postmortem later — not a
  disappointing non-event?

## If you get stuck

- **Hint 1:** If you're on Path B, don't reach for a specific clock
  format just because it's a common example — go back to what
  `PROJECT_PLAN.md` actually says your time slots mean, and find the
  deeper case *that* model allows. If your model genuinely represents
  time as clock values with an assumed occupancy duration, converting
  to a common unit (minutes-since-midnight, say) and checking whether
  two windows overlap at all — not just whether their raw values
  match — is the usual shape of the fix.
- **Hint 2:** A blameless postmortem describes what the *system*
  allowed (or correctly prevented), not what a *person* did wrong —
  "the assignment logic didn't check existing bookings," not "someone
  forgot to add a check."
- **Hint 3:** The regression or confirming test should fail (or
  demonstrate protection) for the same reason a real customer
  complaint would — assert on table overlap directly, not on some
  indirect symptom.
- **Hint 4:** If you're genuinely unsure whether you're on Path A, B,
  or C, write the Path A reproduction attempt first (step 2) — its
  outcome tells you which path you're actually on, rather than
  guessing from the incident description alone.

## What's next

Your project has survived a real requirement change and a real
incident report, with tests, review, and CI backing every step. Last
step: prove someone other than your own team can pick it up and keep
going.

Continue to [Lab 30 — Handover](../30-handover/README.md).
