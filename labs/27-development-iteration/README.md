# Lab 27 — Development iteration

## Story

The plan is written. The ADR is accepted. Now it's just building —
except "just building" is where every habit from Act IV either holds
up under real, sustained use, or quietly gets skipped the first time
someone's in a hurry.

## Learning objectives

After this lab you should be able to:

- Run the full issue → branch → commits → tests → PR → review → CI →
  merge loop repeatedly, without a lab README telling you the next
  step each time.
- Keep a running project honest under time pressure — small PRs,
  actually-run tests, actually-read reviews.
- Recognize the moment a shortcut you're tempted to take is exactly the
  kind of thing Act IV existed to prevent.

## Before you start

- Lab 26 complete: `PROJECT_PLAN.md` and `docs/adr/adr-001-language-choice.md`
  exist in your team's own repository.
- Your team's repository has, at minimum, whatever project skeleton
  your chosen language needs to run a "hello world" and a test suite.

## Your task

This lab has no fixed list of features to build — that's the point.
Working from your own `PROJECT_PLAN.md`'s MVP scope:

1. Set up CI for your repository now, reusing the pattern from Lab 19:
   a workflow that installs dependencies and runs your test suite on
   every push and pull request. Do this *before* building features, not
   after — you want it catching mistakes from your very first real PR.
2. For each MVP capability in your plan (create a reservation, list
   reservations for a day, cancel a reservation, and whatever else your
   team scoped in), repeat the full loop: open an issue or task
   describing it, branch, write a failing test, implement, commit in
   reviewable steps, push, open a PR with a real description, get it
   reviewed (a real teammate if you have one; the Lab 18 solo checklist
   if you don't), address feedback, merge only once CI is green.
3. Keep every PR small enough that its reviewer can actually hold the
   whole change in their head — if a PR is doing three unrelated
   things, split it.
4. By the end of this lab, your MVP acceptance criteria from
   `PROJECT_PLAN.md` should all be satisfied and merged to your main
   branch, with CI green.

## Acceptance criteria

- CI is configured and green on your main branch.
- Every MVP capability from `PROJECT_PLAN.md` is implemented, tested,
  and merged through a reviewed PR (or a solo-reviewed PR, per Lab 18).
- You can point to your repository's commit history and PR list as
  evidence of the loop, not just a description of intending to follow
  it.

## Verification

```bash
# run from your team's own repository, with whatever command runs your tests
<your test command>
```

Expected: your full test suite passes, and your CI provider shows green
on the latest commit to your main branch.

## Think about it

- Which part of the Act IV loop were you most tempted to skip once
  nobody was watching lab-by-lab — writing the failing test first,
  writing a real PR description, or actually reading a teammate's diff
  before approving it?
- If a teammate (or your solo-reviewer self) had rubber-stamped a PR
  without really reading it, what's the earliest point later in this
  capstone where that would have become visible?

## If you get stuck

- **Hint 1:** If you don't know what to build next, re-read your own
  `PROJECT_PLAN.md` scope section — the answer is already written down.
- **Hint 2:** A CI workflow that only needs to install dependencies and
  run tests is a direct adaptation of Lab 19's — same shape, different
  project.
- **Hint 3:** If reviews are starting to feel like a formality, revisit
  Lab 18's checklist and hold yourself (or your teammate) to it
  explicitly, out loud.

## What's next

Your MVP works, is tested, and is reviewed. Now the requirement changes
— and you find out what your design actually cost you.

Continue to [Lab 28 — Change request](../28-change-request/README.md).
