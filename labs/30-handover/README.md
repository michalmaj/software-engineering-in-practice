# Lab 30 — Handover

## Story

Your team's engagement with TableTime is ending. Another team is taking
it over — new people, no access to your memory of why anything was
built the way it was. Everything they need has to already be in the
repository.

## Learning objectives

After this lab you should be able to:

- Prepare a project so a stranger can set it up and run its checks
  using only what's written down.
- Evaluate, from the receiving side, whether a handover actually
  succeeded.
- Make a small, real change to an unfamiliar codebase within a time
  box, without asking the original authors.

## Before you start

- Lab 29 complete: your MVP, the change request, and the incident fix
  are all merged, tested, and documented.
- If you're in a classroom: your instructor pairs your team with
  another team for a swap. If solo: you'll evaluate your own project as
  the "receiving team," pretending you've never seen it.

## Your task

**If you are handing over (the originating team):**

1. Make sure your root `README.md` alone is enough for someone to: know
   what TableTime is, clone the repo, install whatever it needs, run
   the test suite, and run the application once.
2. Add a short `ARCHITECTURE.md` (a few paragraphs, not a full design
   doc) pointing a newcomer at where the core logic lives, and linking
   to `docs/adr/adr-001-language-choice.md` for the reasoning behind
   your language choice.
3. Confirm CI is green on your main branch at the moment of handover.
4. Do not brief the receiving team verbally beyond a two-minute
   introduction — the repository has to carry the rest.

**If you are receiving (or evaluating your own project solo):**

5. Clone the repository into a fresh location you haven't touched
   before.
6. Follow only the written `README.md` to set up the project and run
   its checks. Do not ask the original team a clarifying question yet
   — note anywhere you got stuck or had to guess.
7. Skim `ARCHITECTURE.md` and the codebase enough to locate where you'd
   make a small change.
8. Make one small, real change within a fixed time box (30 minutes is
   reasonable): add a new read-only capability (for example, "find a
   reservation by its id") with its own test, and get it passing
   against the existing test suite.
9. Write `HANDOVER_NOTES.md` (from the receiving side) answering: what
   worked from the documentation alone, what didn't, and what one
   change to the original team's README or docs would have saved you
   the most time.

## Acceptance criteria

- The originating team's `README.md` and `ARCHITECTURE.md` exist and
  are sufficient on their own (verified by the receiving side actually
  using only them).
- The receiving side successfully set up the project, ran its checks
  green, and merged one small tested change without direct help from
  the original authors.
- `HANDOVER_NOTES.md` exists with specific, honest feedback — not "it
  went fine."

## Verification

```bash
# from the receiving side, in a completely fresh clone
<the setup commands from the originating team's README>
<the test command from the originating team's README>
```

Expected: both succeed using nothing but what's written in the
repository.

## Think about it

- Which piece of context did you personally carry in your head, that
  never made it into the README, `ARCHITECTURE.md`, or an ADR? Why did
  it feel unnecessary to write down at the time?
- The original team is evaluated partly by how well another team could
  work with their project (spec's own framing for this lab). Is that a
  fair way to measure engineering quality? What does it capture that
  "did the tests pass" doesn't?

## If you get stuck

- **Hint 1:** If the receiving side gets stuck on step 6, that's data,
  not failure — write down exactly where, and that becomes the most
  valuable line in `HANDOVER_NOTES.md`.
- **Hint 2:** A good `ARCHITECTURE.md` answers "where do I even start
  reading" in a few sentences — it is not a substitute for readable
  code, and it shouldn't try to explain every file.
- **Hint 3:** Keep the assigned small change genuinely small and
  read-mostly (a lookup, a filter, a formatting helper) — this lab is
  about handover quality, not about testing the receiving team's
  raw implementation speed.

## What's next

This is the last lab. You've gone from finding your way around a
terminal to handing off a tested, reviewed, incident-hardened project
that someone else can pick up and keep going. That last sentence is the
actual definition of software engineering this course has been arguing
for since Lab 01.
