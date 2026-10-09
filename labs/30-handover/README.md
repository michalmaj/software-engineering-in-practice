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

### A note for instructors pairing teams

Pair teams that used the **same language track** whenever you can —
Python with Python, Go with Go, Java with Java. The receiving team
should already have the toolchain installed and the test command
memorized from their own Act V and Act VI work; that's what lets this
lab test documentation and handover quality specifically, not whether
someone can install an unfamiliar language's tooling under time
pressure. If your class's team-language mix genuinely doesn't divide
evenly into same-language pairs, don't ask a team to install a
toolchain they've never used just to force a pairing — pair across
languages only when the receiving team already has that toolchain
available for another reason (for example, from their own Lab 14
experience), and be explicit that the actual code handover (steps 6-9
below) is optional if the toolchain truly isn't available: a thorough
documentation-only review is a real, honest fallback, but it must be
reported as that in `HANDOVER_NOTES.md`, not described as if a full
code handover happened when it didn't. Don't require Codespaces to
work around this — the local-first model from the rest of the course
still applies here.

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

You don't have write access to the originating team's repository, and
shouldn't need it — this whole path works through a fork and a pull
request, the same way an outside contributor would work with any
project they don't own.

5. Fork the originating team's repository on GitHub, then clone *your
   own fork* into a fresh location you haven't touched before.
6. Follow only the written `README.md` to set up the project and run
   its checks. Do not ask the original team a clarifying question yet
   — note anywhere you got stuck or had to guess.
7. Skim `ARCHITECTURE.md` and the codebase enough to locate where you'd
   make a small change.
8. Create a branch in your own fork, and make one small, real change
   within a fixed time box (30 minutes is reasonable): add a new
   read-only capability (for example, "find a reservation by its id")
   with its own test, get it passing against the existing test suite,
   then push the branch to your own fork.
9. Open a pull request from your fork back to the originating team's
   repository. Whether they merge it is their call, not a requirement
   of this lab — opening a correct, reviewable PR against a repo you
   don't own is the actual skill being tested.
10. Write `HANDOVER_NOTES.md` (from the receiving side) answering: what
    worked from the documentation alone, what didn't, and what one
    change to the original team's README or docs would have saved you
    the most time. Include it in the same pull request (or link it from
    the PR description) so the feedback actually reaches the
    originating team, not just your own fork.

## Acceptance criteria

- The originating team's `README.md` and `ARCHITECTURE.md` exist and
  are sufficient on their own (verified by the receiving side actually
  using only them).
- The receiving side successfully set up the project, ran its checks
  green, and opened a pull request — from their own fork, not a branch
  on the originating repository — with one small, tested change, without
  direct help from the original authors.
- `HANDOVER_NOTES.md` exists with specific, honest feedback — not "it
  went fine" — and reaches the originating team through the PR.

## Verification

There's no single command here — the whole point is that the
originating team's own `README.md` is what defines the setup and test
commands, and that varies by which language they chose. From the
receiving side, in a completely fresh clone: follow the setup steps
written in the originating team's `README.md` exactly as written, then
run the test command it specifies (`uv run pytest`, `go test ./...`,
or `./gradlew test`, depending on their track).

Expected: both succeed using nothing but what's written in the
repository.

## Think about it

- Which piece of context did you personally carry in your head, that
  never made it into the README, `ARCHITECTURE.md`, or an ADR? Why did
  it feel unnecessary to write down at the time?
- The original team is evaluated partly by how well another team could
  work with their project, not by how confident the original team felt.
  Is that a fair way to measure engineering quality? What does it capture that
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
- **Hint 4:** If the originating team's repository is private and
  forking isn't straightforward for your organization, being added as
  a collaborator is a reasonable substitute — but fork-and-PR is the
  path this lab actually walks through, since it's the one that works
  without anyone having to manage repository permissions by hand.

## What's next

This is the last lab. You started by learning to find your way around
a terminal. You're finishing by handing off a tested, reviewed,
incident-hardened project that someone else can pick up and keep
going.
