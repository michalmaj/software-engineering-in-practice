# Release readiness — classroom fit and GO/NO-GO (PR K)

This is not another full audit. It resolves the two specific
pedagogical timing problems J1-J3 disclosed but didn't fix — Lab 25's
two-release-cycle load and Lab 27's four-capability team MVP — and
gives an explicit recommendation on FULLY SUPPORTED and the next
release, based on the accumulated evidence from PR H and PR J1-J3,
not a new pass over material those audits already covered.

**Base commit:** `cb26f83` (`main`, immediately after PR J3 / #40
merged), on branch `quality/classroom-fit-release-readiness`.

**Course constraint driving this PR:** exactly 30 sessions, 90
minutes each, one session per lab, no assumed homework or extra
sessions. Both open problems are evaluated against that constraint
specifically — not "is this a lot of work" in the abstract, but "does
this fit in the one session this course's structure gives it."

## 1. Summary of J1-J3

Three prior PRs read all 60 Lab 01-30 README files (`.md` + `.pl.md`)
in full, found and fixed real bugs in each batch (a Windows
Python-naming issue in Labs 05-06; a stale "Go/Java preview" claim in
Lab 06; an unsafe `curl` placeholder in Lab 22; a stale "Go/Java
pause" claim in Lab 24; a missing timebox section in Lab 25 — since
substantially reworked in this PR), and performed extensive hands-on
verification across Python, Go, and Java, including a full real
`order-api` build through Labs 21-25 and a full real TableTime
capstone walkthrough through Labs 26-30 (Python in both cases; Go and
Java verified by code reading and starter-structure checks, not
independently re-implemented end to end — disclosed in
`editorial-audit-j3.md`). Full findings are in
`editorial-audit-j1.md`, `editorial-audit-j2.md`, and
`editorial-audit-j3.md`; this report does not repeat that evidence,
only builds on it.

## 2. Lab 25 — resolution

### What was done

- **Lab 24 now carries a genuinely optional step** (new Step 8,
  "a head start on next lab's changelog") asking students to draft
  `CHANGELOG.md`'s `[1.0.0]` entry in a scratch file if this session
  has time left — explicitly skippable if it doesn't. This is real
  slack Lab 24 has: its own work (configure logging once, add four
  log statements to code that already exists, two log-capturing
  tests, a manual read) is lighter than Lab 25's two-release-cycle
  load, and the draft itself is pure writing with no code, no tests,
  and no CI wait — the cheapest kind of work to move.
- **Lab 25's own text now says, explicitly, that this narrows the gap
  and does not close it.** With the draft already written, the
  `v1.0.0` cycle (branch, paste, confirm, commit, PR, merge, tag) is
  realistically 15-20 minutes instead of 25-35. The `v1.1.0` cycle —
  a real schema migration, four tests including the historical-`NULL`
  one, a `CONTRACT.md` update, a `CHANGELOG.md` entry reasoning about
  SemVer, and a second full PR/CI/merge/tag loop — is untouched by
  this change and is, on its own, close to or at 90 minutes for
  Python.

### Honest verdict: still OPEN, MAJOR

Even with the Lab 24 prep, **two complete release cycles do not
reliably fit in one 90-minute session**, and this is most pronounced
for Go and Java, where extracting the shared `hasColumn` helper and
wiring a second migration point through `main` and test setup is
real, additional ceremony Python doesn't carry. No change made in
this PR invents extra session capacity that doesn't exist, and no
change here removes either release, the historical-`NULL` test, or
any other required learning outcome — the brief for this PR was
explicit that doing so is not an acceptable fix.

What Lab 25's text now says, plainly, is that `v1.0.0` is the expected
stopping point for most students — not a fallback for when things go
slowly, but the normal shape of this lab — with `v1.1.0` starting a
session of its own. **That statement only becomes true for the whole
class if the course calendar actually has a slack session to absorb
it.** This PR cannot create that slack session; only whoever plans
the 30-session calendar can decide whether to split Lab 25 into two
numbered sessions in a future restructuring (explicitly out of scope
here — "nie przebudowuj... struktury trzech języków"), accept that
some students will carry `v1.1.0` into the start of Lab 26's session,
or decide the timing risk is acceptable as disclosed. This is
reported here as an explicit, open MAJOR finding requiring a
maintainer decision, not quietly resolved.

## 3. Lab 27 — resolution

### What was done

- **Lab 26 now has a genuinely optional Step 5**: set up CI now (the
  same Lab 19 recipe Lab 27's step 1 already describes) if the team
  finished repository setup, `PROJECT_PLAN.md`, and the ADR with real
  time left. This is conditional, not a blanket move — Lab 26's own
  budget for a team (repository setup with collaborator invites,
  real planning discussion, starter copy and verification) already
  runs 65-85 minutes by a direct read of its own steps, leaving too
  little slack for some teams to add CI safely. The lab text says so
  explicitly and tells a team that's already full to skip it; Lab
  27's step 1 is written to work correctly whether or not Lab 26's
  Step 5 happened.
- **Lab 27 now has a concrete, named team-coordination plan**, not
  just a general warning that parallelism has overhead. The addition
  specifies: one person/pair takes "create a reservation" first,
  since it's the one capability that decides the reservation's actual
  shape and every other capability depends on that shape existing;
  the remaining people split "list" and "cancel" in parallel only
  once that shape is pushed; a fourth person reviews rather than
  implementing a fourth capability, since Lab 18's real-review
  checklist is itself real work; and integration (merge conflicts
  where "list"/"cancel" touch the same file "create" introduced) is
  named as expected work to budget for, not a surprise.

### Honest verdict: GO, with a disclosed, tight margin

Working through the concrete sequence this PR added — CI (0-15 min
depending on whether Lab 26 absorbed it), the "create" vertical slice
(20-30 min), "list"/"cancel" in parallel (15-25 min wall-clock, not
30-50, because they run simultaneously once "create"'s shape exists),
a real review pass, and integration (10-15 min) — lands at roughly
80-90 minutes for a well-coordinated team that already has Act IV's
loop fluent from Labs 21-24, with CI done in Lab 26. That is a real
plan, not a hopeful one, but it is also a tight margin, not a
comfortable one: a team new to Go's or Java's ceremony, or one that
didn't use Lab 26's optional CI slack, should expect to run over,
exactly as Lab 27's own "Be honest about the risk" paragraph (already
in the lab before this PR, left unchanged) says. This PR's addition
gives that team an actual plan for who does what and in which order,
rather than only a warning that coordination costs time — that is the
concrete difference this PR makes, and it is enough to call this a
GO rather than a MAJOR, unlike Lab 25.

## 4. Python / Go / Java, assessed separately

### Lab 25

| | Required | Prepped earlier | Optional | Verification point | Outside student's control |
|---|---|---|---|---|---|
| Python | Two release cycles, `priority` migration, 4 tests, `CONTRACT.md`+`CHANGELOG.md` updates | `CHANGELOG.md` `[1.0.0]` draft (Lab 24, optional) | — | `merge-base --is-ancestor` on both tags; full suite green | GitHub Actions run time per push (seconds to low minutes in this session's own testing — see `editorial-audit-j3.md`) |
| Go | Same, plus extracting `hasColumn` to avoid a third copy of the `PRAGMA table_info` scan | Same draft option | The `hasColumn` extraction itself — Lab 25 offers it as "if you'd rather not duplicate," not mandatory | Same, plus `go build ./...` | Same |
| Java | Same, plus the equivalent private `hasColumn` helper | Same draft option | Same extraction choice | Same, plus `./gradlew test` | Same |

Go and Java carry genuinely more ceremony here than Python (the
helper extraction, plus JDBC/`database/sql` boilerplate already noted
in `editorial-audit-j3.md`), which is exactly why this report calls
the `v1.1.0` margin tighter for them specifically, not just as a
blanket "Go and Java are slower" assumption.

### Lab 27

| | Required | Prepped earlier | Optional | Verification point | Outside student's control |
|---|---|---|---|---|---|
| Python | CI, create/list/cancel + table assignment, tests, branch/PR/review/merge per capability | CI setup (Lab 26, optional) | — | Full suite green; CI green on `main` | CI run time; a paired reviewer's own schedule |
| Go | Same, plus Go's own project/module ceremony (already noted as real added time in `editorial-audit-j3.md`) | Same | Same | Same, `go test ./...` | Same |
| Java | Same, plus Gradle project ceremony and JSON handling without a framework | Same | Same | Same, `./gradlew test` | Same |

No change in this PR assumes identical implementations or identical
time splits across the three languages — only that all three reach
the same required MVP capabilities, which was already true before
this PR and remains true after it.

## 5. Windows GUI and real paired-GitHub limitations (carried forward, not re-verified)

Unchanged from `final-course-audit.md`, `windows-reality-check.md`,
and `editorial-audit-j1.md`/`j2.md`/`j3.md`, and not re-tested in this
PR since nothing in this PR touches Windows-specific or GitHub-UI
content:

- No real Windows 11 + Git Bash GUI walkthrough of any lab exists —
  UAC prompts, a fresh Chocolatey install, and Git Bash appearing in
  VS Code's actual terminal-profile dropdown remain NOT
  INDEPENDENTLY VERIFIED. The Windows CI smoke test (PR I) verifies
  Labs 01-04's shared command sequence for real on `windows-latest`,
  which is real evidence but not a GUI walkthrough.
- No genuine second GitHub account was used for Lab 18's or Lab 30's
  paired-review/fork-PR flows — both were verified with local git
  remotes simulating the mechanics, not GitHub's actual UI or a
  second real account.

## 6. Technical and CI evidence for this PR specifically

- `./scripts/check-course.sh` — run twice after all edits, both
  green, clean working tree before and after both runs (see Section
  7).
- `scripts/check_course_structure.py` — green after every batch of
  edits in this PR, including heading-count parity checks confirming
  every new EN section has a matching PL section in the same
  position.
- No starter source file under `examples/` was touched by this PR —
  every change is to lab instructions (Labs 24, 25, 26, 27), not to
  `examples/order-api/` or `examples/capstone-starters/`.
- This PR adds no new workflow and does not touch
  `.github/workflows/course-health.yml` — `course-health` and
  `windows-smoke-test` are expected to stay green because nothing
  they check was touched; this is confirmed on the PR's own CI run
  (see the PR description for the run link).

## 7. GO/NO-GO recommendations

### FULLY SUPPORTED (Go, Java)

**NO-GO, unchanged from `final-course-audit.md`'s own framing.**
That audit already said flipping Go/Java to FULLY SUPPORTED was a
separate decision from its own GO on the narrow "is a BLOCKER open"
question, and this PR doesn't revisit that framing — it was out of
scope for this PR by explicit instruction. The specific thing this PR
adds to that decision: Lab 25 remains an open MAJOR classroom-fit
problem for all three tracks, most acute for Go and Java specifically,
and that should be resolved (or explicitly accepted) before FULLY
SUPPORTED is declared, since it's a disclosed gap in the actual
day-to-day teachability of the Go and Java tracks through this part
of the course, not a cosmetic one.

### Next major release

**NO-GO until Lab 25's open MAJOR is resolved by a maintainer
decision.** This PR does not recommend blocking a release forever —
it recommends not publishing one that still describes Lab 25 as a
normal single-session lab without the calendar actually having
somewhere for the `v1.1.0` half to go. Lab 27 is a GO with a
disclosed, tight margin; it does not block a release on its own. The
concrete decision needed before a GO: either accept Lab 25 spanning
two sessions (meaning the 30-lab-to-30-session mapping has one
planned exception) and state that plainly in the course's own
student-facing materials, or restructure Lab 25 (splitting it, or
trimming its scope while keeping both releases and the historical-
`NULL` test) in a dedicated follow-up PR — not as a half-measure
inside this one.

## Validation performed for this PR

- `./scripts/check-course.sh` — green, run twice, clean tree before
  and after both runs.
- `scripts/check_course_structure.py` — green: lab structure,
  README pairs, broken links, no tracked `decisions/`, no
  AI-attribution strings, EN/PL executable code-block parity.
- Heading-level EN/PL parity confirmed by direct diff for every file
  touched (Labs 24, 25, 26, 27) — every new section appears in both
  languages, in the same position.
- No starter solutions added or changed; no tracked `decisions/`; no
  AI attribution; no `Co-authored-by`.
