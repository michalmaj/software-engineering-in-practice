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

---

## Final maintainer decision after PR L (added by PR M)

This document still contains, unedited, the history of how its own
verdict changed: Section 2 recorded Lab 25's two-release-cycle load as
an **OPEN MAJOR**; Section 7 recommended **NO-GO** on both FULLY
SUPPORTED and the next release on that basis; Section 8 (added by PR
L) then resolved that MAJOR and called Labs 24-25 a **GO** in all
three languages. Reading Section 7 alone, without this note or
Section 8, would give a reader a verdict that is no longer current.
This section is the single place that states what is actually true
now:

- Section 7's NO-GO is preserved here as an accurate historical
  record of what PR K concluded at the time — it is **not** edited or
  retroactively softened.
- The condition that NO-GO was contingent on — Lab 25 reliably
  exceeding 90 minutes because it carried two full release cycles —
  was resolved by PR L: `v1.0.0` now ships at the end of Lab 24, on
  the same branch/PR as that lab's logging work, and Lab 25 does
  exactly one release cycle (the `priority` field, ending in `v1.1.0`).
- **Labs 24-25 have a GO in all three languages** (Python, Go, Java),
  per PR L's real, independent, hands-on verification in all three —
  not a text review.
- **Java's Lab 24 still carries a disclosed, tight timing margin**
  (roughly 60-90 minutes for a beginner) — this is not a new problem
  invented by PR L; it is Java's pre-existing, heaviest-of-three
  logging ceremony (a `LoggingConfig` class, a hand-written
  `ListLogHandler` subclass) with the newly-mandatory release loop now
  stacked on top. It is disclosed, not hidden, and is not treated as a
  reason to withhold the GO above.
- **Lab 27 remains a GO with a tight, disclosed margin**, exactly as
  Section 3 already concluded — nothing in PR L or this PR revisits
  that verdict.
- With Lab 25's MAJOR resolved, **the status of all three language
  tracks may move from PREVIEW to FULLY SUPPORTED** — this is a
  maintainer decision made in PR M (see
  [`final-course-audit.md`](final-course-audit.md) and the root
  `README.md`/`README.pl.md` for where that decision is reflected
  student-facing), not something this document decides on its own.
- With that status change made, **`v2.0.0` may be prepared for
  publication** once this PR is reviewed and merged — publishing the
  tag and the GitHub Release itself remains a separate, later step,
  not part of this PR.

Nothing above changes any of this document's own time estimates to
make them look better than the real walkthroughs found — the Java
Lab 24 margin stays exactly as tight as Section 8 measured it.

---

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

## 8. PR L — Lab 25's MAJOR resolved by moving `v1.0.0` into Lab 24

**Base commit:** immediately after PR K / #41 merged, on branch
`quality/lab24-25-release-workflow`.

Section 2's open MAJOR — two full release cycles not reliably fitting
Lab 25's single 90-minute session — is resolved here by a structural
move, not by cutting scope: the `v1.0.0` release (branch, `CHANGELOG.md`
`[1.0.0]`, PR, merge, tag, tag-reachability check) now happens inside
Lab 24, on the same branch and PR as that lab's own logging work. Lab
25 starts from an already-tagged `v1.0.0` and does exactly one release
cycle: the `priority` field, its migration, four tests (including the
historical-`NULL` one), `CONTRACT.md`, a `[1.1.0]` changelog entry with
real SemVer reasoning, and one PR/CI/merge/tag loop ending in
`v1.1.0`. No lab was added, no learning outcome was removed, and the
historical-`NULL` test — the one this course's own authors got wrong
on a first pass — is unchanged in all three tracks.

### Before / after

| | Before (PR K) | After (PR L) |
|---|---|---|
| Lab 24 | Logging only; Step 8 optional changelog *draft* in a scratch file, explicitly skippable | Logging **and** a mandatory, integrated `v1.0.0` release: `CHANGELOG.md` `[1.0.0]`, one branch/PR with logging, merge, tag, tag-reachability check (Steps 8-12) |
| Lab 25 | Two release cycles: baseline `v1.0.0` (steps 1-4) then `priority`/`v1.1.0` (steps 5-10) | One release cycle: starts from Lab 24's already-tagged `v1.0.0`; only `priority`/`v1.1.0` remains |
| Recovery guidance | None — assumed the happy path | New "If your `v1.0.0` state doesn't match the above" section: 5 explicit recovery scenarios (tag correct; Lab 24 unfinished; tag unreachable; Lab 24's PR unmerged; local uncommitted changes), all non-destructive, and explicit that a tag from an earlier version of these labs is still accepted |
| Go/Java `hasColumn` ceremony | Framed as "if you'd rather not duplicate" | Reframed as an explicit stretch goal, stated as outside the core 90-minute path, so it can't be mistaken for required scope |
| Maintainer-facing verdict | Lab 25: OPEN, MAJOR (unresolved) | Lab 25: resolved structurally; new risk disclosed on Lab 24 specifically, see below |

### Real evidence this time: three independent hands-on walkthroughs

Unlike PR K's Lab 25 analysis (a direct read of the lab's own steps,
not independently re-implemented end to end for Go/Java), this PR
built and ran the **entire restructured Lab 24 → Lab 25 sequence for
real, independently, in all three languages**, in disposable local git
repositories with real commits, branches, merges, and tags (not a real
GitHub PR/CI run — that distinction is kept explicit throughout):

- **Python, Go, Java** — each bootstrapped from that language's actual
  `examples/order-api/<language>/` starter to the real "Lab 21-23
  complete" state (persistence, `notes` migration, bounded retry),
  confirmed green, then carried through the *actual* restructured Lab
  24 text (logging, `CHANGELOG.md` `[1.0.0]`, branch, merge, tag,
  `merge-base --is-ancestor` check — confirmed to print the success
  line) and the *actual* restructured Lab 25 text (`priority` field,
  migration, four tests, `CONTRACT.md`, `[1.1.0]` changelog with
  SemVer reasoning, second branch, merge, tag).
- **Both `order-api-v1.0.0` and `order-api-v1.1.0` confirmed as real
  ancestors of `main`** via `git merge-base --is-ancestor` in all
  three languages, with a clean two-merge-commit history in each.
- **The historical-`NULL` `priority` test was proven real, not a
  tautology, in all three languages**: the exact fix (defaulting a
  `NULL`/empty stored `priority` to `"normal"`) was deliberately
  reverted, the test was re-run and failed with precisely the
  predicted wrong value (empty string in Python/Go, `null` in Java),
  then the fix was restored and the full suite re-confirmed green.

### Honest timebox, per lab, per language (the load-bearing evidence)

Based on what the walkthroughs above actually required to implement,
scaled to a beginner student (not this session's own execution speed)
reading the lab text for the first time, including first-time
dependency resolution, debugging typos, and GitHub PR/review/CI/merge
turnaround:

| | Lab 24 (logging + `v1.0.0`) | Lab 25 (`priority` + `v1.1.0`) |
|---|---|---|
| Python | ~50-75 min: logging (`caplog`, 2 tests) ~25-35 min + changelog/PR/merge/tag loop ~25-40 min | ~45-65 min: migration + 4 tests (mechanically similar to Lab 22-23) + `CONTRACT.md`/`CHANGELOG.md` SemVer writing + PR/merge/tag loop |
| Go | ~50-75 min: `slog` setup is terser than Python's but the buffer-swap test pattern is a new idiom to copy correctly; same changelog/PR/merge/tag loop | ~55-80 min: same shape as Python, plus `sql.NullString` handling and a 6-column `PRAGMA table_info` `Scan` — a real, if small, source of beginner mistakes neither Python nor the changelog loop has |
| Java | ~60-90 min: this lab's **pre-existing** heaviest-of-three logging ceremony (a new `LoggingConfig` class removing default handlers, a hand-written `ListLogHandler extends Handler` subclass for the two tests) plus the **newly mandatory** release loop on top of it | ~60-85 min: same shape as Go, plus JDBC's three-deep try-with-resources boilerplate on every query and a `ResultSet.getString` that returns Java `null` for SQL `NULL` directly (the exact bug this course's authors hit) |

None of these ranges assume the dependency-download step is new
inside Lab 24 — `sqlite-jdbc`/`modernc.org/sqlite` were already pulled
in Lab 22, so that cost isn't paid twice.

**The one real risk this PR did not have before writing it down:**
Java's Lab 24 upper bound (~90 min) sits right at the limit, not
comfortably under it. This is not a problem invented by this PR —
Java's logging ceremony (the `LoggingConfig` class, the `ListLogHandler`
subclass) already existed and was already the heaviest of the three
languages before this PR touched anything; what this PR adds on top is
the newly-mandatory release loop, which is identical git/GitHub
mechanics across all three languages and isn't itself language-heavy.
This is disclosed here rather than smoothed over.

### GO/NO-GO for this PR's own scope

**GO for Lab 24 and Lab 25, in all three languages, with one disclosed
tight margin (Java's Lab 24).** The structural fix works: no language
is carrying two release cycles in one session anymore, and the
previously-MAJOR problem (a near-certain overrun from stacking two full
release cycles) is gone. What remains is a narrower, disclosed risk —
Java's Lab 24 landing close to 90 minutes for a slower beginner, a paced
CI queue, or a first encounter with `java.util.logging`'s handler
model — the same shape of risk this report already called a GO for Lab
27 in Section 3, not the kind of near-certain overrun that justified
Section 2's original MAJOR. If a maintainer wants more margin
specifically for Java's Lab 24, the concrete, scoped option is moving
Step 7 ("read your own logs by hand") to be explicitly optional/time-permitting
in Java only, since it's the one step in that lab with no
acceptance-criteria consequence if skipped — not revisiting the
`v1.0.0`/`v1.1.0` split this PR just made.

### Relationship to Section 7's verdicts

Section 7's "Next major release: NO-GO until Lab 25's open MAJOR is
resolved" was conditioned specifically on the two-release-cycle
problem this PR resolves — that condition is now satisfied for Labs
24-25 specifically. This PR does **not** itself recommend GO for a
release or change the Go/Java FULLY SUPPORTED status; both remain
exactly as Section 7 left them, since flipping either is explicitly
out of scope for this PR and is a separate maintainer decision.

## Validation performed for PR K

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

## Validation performed for PR L

- Real, independent hands-on walkthroughs of the restructured Lab
  24 → Lab 25 sequence in Python, Go, and Java, each in a disposable
  local git repository: real commits, branches, merges, and tags —
  not a real GitHub PR/CI run, a distinction kept explicit throughout
  this section.
- Both `order-api-v1.0.0` and `order-api-v1.1.0` confirmed as real
  ancestors of `main` via `git merge-base --is-ancestor`, in all three
  languages.
- The historical-`NULL` `priority` test confirmed non-tautological in
  all three languages, by deliberately reverting its fix, watching the
  test fail with the exact predicted wrong value, then restoring the
  fix and reconfirming the full suite green.
- `./scripts/check-course.sh` — green, run twice, clean tree before
  and after both runs.
- `scripts/check_course_structure.py` — green: lab structure, README
  pairs, broken links, no tracked `decisions/`, no AI-attribution
  strings, EN/PL executable code-block parity.
- Heading-level EN/PL parity confirmed by direct diff for both files
  touched (Labs 24, 25) — same heading-level sequence, same order, in
  both languages.
- No starter solutions added or changed (`examples/order-api/` was not
  touched — all work happened in disposable scratch copies outside the
  repository, deleted after verification); no tracked `decisions/`; no
  AI attribution; no `Co-authored-by`.
- FULLY SUPPORTED status for Go/Java and the next-release recommendation
  are unchanged by this PR, per explicit instruction.
