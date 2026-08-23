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

## Before you start

- Lab 28 complete: combined-table support for large parties is merged.

## Your task

**The incident (give this to your team as-is):**

> On Saturday night, two separate reservations were both assigned table
> 4 at 7:00 PM. Both parties arrived expecting that table. Reproduce
> this, fix it, and make sure it can't happen again — silently or
> otherwise.

Follow **Path A** if this is reproducible in your system today. Follow
**Path B** if your team already prevents exact same-day/same-time-slot
double-booking — don't force a fake bug either way.

**Path A — the bug is real:**

1. Reproduce it: create two reservations for the same day and exact
   time slot, small enough that your assignment logic gives both the
   same table.
2. Write a failing test capturing the exact defect: two reservations
   for the same day/time slot must never be assigned an overlapping set
   of tables.
3. Fix the defect with the smallest change that makes the new test pass
   without breaking any existing test.
4. Continue to step 5 below.

**Path B — you already prevent this:**

1. Write a test *proving* the protection exists (two reservations, same
   exact day/time slot, must get non-overlapping tables) — this should
   already pass, demonstrating the coverage, not creating it.
2. Now go one level deeper: two reservations at the *same table*, on
   the same day, at times that are different strings but would
   realistically overlap in a real dining room — for example `19:00`
   and `19:15`, if a table is occupied for roughly 90 minutes.
   Reproduce this against your own system.
3. Write a failing test capturing this: two reservations whose time
   slots are within your system's assumed occupancy window must not
   share a table, even if the time-slot strings aren't identical.
4. Fix it — this will likely require treating `time_slot` as a
   comparable time value with a duration, not just a string to compare
   for exact equality. Continue to step 5 below.

**Both paths:**

5. Write `POSTMORTEM.md`, blameless — no names, no blame — covering:
   what happened, customer impact, root cause (a design gap, not a
   "someone made a mistake" narrative), how it was detected (a customer
   complaint, not a monitoring alert — note that explicitly), the fix,
   the regression test added, and one concrete system or process change
   that would reduce the chance of this class of failure recurring. If
   you followed Path B, also note in the postmortem that your team's
   original design already covered the simpler case, and describe the
   deeper gap you found instead.

## Acceptance criteria

- **Path A:** a regression test exists, fails before the fix, and
  passes after, without breaking any earlier test.
- **Path B:** a test proves the existing same-slot protection, *and* a
  second test for the overlapping-but-different-slot case fails before
  its fix and passes after, without breaking any earlier test.
- `POSTMORTEM.md` exists, is blameless, and ends with a concrete
  systemic recommendation — not just "be more careful."

## Verification

```bash
# from your team's own repository
<your test command>
```

Expected: full suite green, including the new double-booking regression
test.

## Think about it

- Lab 26's brief never required preventing double-booking. Was that
  omission a mistake in the brief, or a realistic reflection of how
  real specs leave gaps that only show up once something breaks?
- Your postmortem's "how it was detected" section should be honest. If
  the honest answer is "a customer complained, not our tests or
  monitoring," what does that suggest about what Lab 24's observability
  habits should have covered in your own project?

## If you get stuck

- **Hint 1:** If you're on Path B, the overlapping-slot near-miss is
  concrete: pick a fixed occupancy duration (say, 90 minutes) for every
  reservation, convert `time_slot` strings to minutes-since-midnight for
  comparison, and treat two bookings on the same table as conflicting if
  their occupancy windows overlap at all — not just if their raw
  strings match.
- **Hint 2:** A blameless postmortem describes what the *system*
  allowed, not what a *person* did wrong — "the assignment logic didn't
  check existing bookings," not "someone forgot to add a check."
- **Hint 3:** The regression test should fail for the same reason a
  real customer would have complained — assert on table overlap
  directly, not on some indirect symptom.

## What's next

Your project has survived a real requirement change and a real
incident, with tests, review, and CI backing every step. Last step:
prove someone other than your own team can pick it up and keep going.

Continue to [Lab 30 — Handover](../30-handover/README.md).
