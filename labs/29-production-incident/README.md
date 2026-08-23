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

1. Reproduce the incident against your own system: create two
   reservations for the same day and time slot, small enough that your
   MVP's table-assignment logic would give both the same table (this
   depends on your own design from Labs 26-28 — if your team already
   guarded against this, say so explicitly and explain why, rather than
   forcing a bug that doesn't exist).
2. Write a failing test that captures the exact defect: two
   reservations for the same day/time slot must never be assigned an
   overlapping set of tables.
3. Fix the defect with the smallest change that makes the new test pass
   without breaking any existing test.
4. Write `POSTMORTEM.md`, blameless (spec §29 — no names, no blame),
   covering: what happened, customer impact, root cause (a design gap
   from the MVP, not a "someone made a mistake" narrative), how it was
   detected (a customer complaint, not a monitoring alert — note that
   explicitly), the fix, the regression test added, and one concrete
   system or process change that would reduce the chance of this class
   of failure recurring.

## Acceptance criteria

- A regression test exists, specifically named around preventing
  overlapping table assignment, and it fails before the fix and passes
  after.
- The fix does not break any test written in Labs 26-28.
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

- **Hint 1:** If your team already prevented this in Lab 26-28 (by
  design or by accident), don't force a fake bug — instead, write a
  test proving the protection exists, and use your postmortem to
  describe a *related* near-miss your design still doesn't cover
  (for example, what happens with combined tables when only one of the
  pair is already in use?).
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
