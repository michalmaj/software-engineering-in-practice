# Editorial & beginner-experience audit — Labs 21-30 (PR J3)

Final of three planned editorial passes. This one covers Act V ("The
system lives in a larger world" — Labs 21-25) and Act VI ("You are the
engineering team" — Labs 26-30), read start to finish in both
languages — not sampled, not grepped.

**Base commit audited:** `187f1a4` (`main`, immediately after PR J2 /
#39 merged), on branch `quality/editorial-j3-labs-21-30`.

**Coverage: 20/20 required files read in full.** This is complete
coverage, not PARTIAL — no API or context limit was hit during this
pass.

| File | Read |
|---|---|
| `labs/21-api-is-a-contract/README.md` | YES |
| `labs/21-api-is-a-contract/README.pl.md` | YES |
| `labs/22-data-outlives-code/README.md` | YES |
| `labs/22-data-outlives-code/README.pl.md` | YES |
| `labs/23-outside-world-fails/README.md` | YES |
| `labs/23-outside-world-fails/README.pl.md` | YES |
| `labs/24-production-says-it-doesnt-work/README.md` | YES |
| `labs/24-production-says-it-doesnt-work/README.pl.md` | YES |
| `labs/25-release-and-compatibility/README.md` | YES |
| `labs/25-release-and-compatibility/README.pl.md` | YES |
| `labs/26-project-kickoff/README.md` | YES |
| `labs/26-project-kickoff/README.pl.md` | YES |
| `labs/27-development-iteration/README.md` | YES |
| `labs/27-development-iteration/README.pl.md` | YES |
| `labs/28-change-request/README.md` | YES |
| `labs/28-change-request/README.pl.md` | YES |
| `labs/29-production-incident/README.md` | YES |
| `labs/29-production-incident/README.pl.md` | YES |
| `labs/30-handover/README.md` | YES |
| `labs/30-handover/README.pl.md` | YES |

## Per-lab assessment

| Lab | EN read | PL read | Technical | Beginner UX | Timebox | Status |
|---|---|---|---|---|---|---|
| 21 | YES | YES | Clean — real server start, real `curl` POST/GET/GET-missing confirmed byte-for-byte against the CONTRACT.md template; 4-test count verified by actually implementing the validation rule | Good — port-in-use and connection-refused recovery paths both explicit, per-language `Ctrl+C` behavior explained | ~30-45 min, all three languages | PASS |
| 22 | YES | YES | **One bug found and fixed** (the exact bug named in the brief — see Findings). Otherwise fully verified for real: three real server restarts, a genuinely `NULL` historical row inserted by raw SQL bypassing `create_order`, migration proven idempotent across a third restart | Good after fix — the fix makes an already-unsafe-to-copy-paste command safe | **Heaviest lab in Act V** — two large tasks (persistence, migration) in one lab; realistic 45-70 min for Python, more for Go/Java's extra driver setup | PASS (fixed) |
| 23 | YES | YES | Clean — all three retry-policy tests and the mandatory HTTP-level integration test verified for real, confirming exactly 3 notification attempts, instant test execution (no real delay), and that persistence/fetchability survive total notification failure | Good — explicitly says "don't invent a parallel structure imitating Python's try/except" for Go, respecting each language's real idiom rather than forcing uniformity | ~30-45 min, all three languages | PASS |
| 24 | YES | YES | **One MAJOR bug found and fixed** (see Findings) — otherwise clean; real terminal log output confirmed readable, leveled, and still containing the Lab-21-relevant "listening on" text despite the new timestamp prefix | Good after fix | ~25-40 min, all three languages | PASS (fixed) |
| 25 | YES | YES | **One gap found and fixed** (missing timebox guidance — see Findings). Technical content fully verified for real: the full two-tag release workflow, including deliberately reproducing the exact "tag before merge" failure mode and confirming `merge-base --is-ancestor` prints nothing for it, and deliberately reintroducing the historical-NULL bug this lab's own text references to confirm the fourth test actually catches it | Good after fix | **Second-heaviest lab in the course** — two full release cycles; now has an explicit checkpoint at `v1.0.0`, matching Lab 27's standard | PASS (fixed) |
| 26 | YES | YES | Clean — capstone starters confirmed minimal (no pre-built reservation logic, no incident spoiler), dotfile-copy and nested-`.git` warnings both present and correct, Go/Java renaming instructions verified safe to follow or skip | Good — explicit three-way equal language choice, not Python-first; explicitly leaves the overlap question open without hinting at the Lab 29 incident | ~45-70 min (planning-heavy, no code pressure) | PASS |
| 27 | YES | YES | Clean — already has an exemplary, explicit "A realistic 90 minutes" section (checkpoint structure, per-language honesty, solo-vs-team scope guidance) that Lab 25 was missing and now mirrors | Good | **Heaviest lab in Act VI** — explicitly and correctly flagged as such by the lab's own text; real checkpoint after repo/CI setup and after each MVP capability | PASS |
| 28 | YES | YES | Clean — verified for real: the prediction-before-code commit discipline, the field-rename-vs-behavior-change distinction (confirmed by actually renaming a field and fixing the assertion, not the logic), and the same-PR reality-update requirement (`git status --short` clean after merge) | Good — explicitly says change surface is a signal to analyze, not a score to minimize | ~40-60 min | PASS |
| 29 | YES | YES | Clean — all three paths read with the extra care the brief asked for. Path A verified for real against an intentionally-unprotected MVP: reproduced the double-booking, wrote the failing test, fixed it, confirmed no regression | Good — explicit "don't manufacture a failure," explicit blameless-language example, explicit handling of "customer complaint, not monitoring" as an honest observability admission | ~40-60 min for whichever path applies; Path B's "go one level deeper" step is the most open-ended, since it depends entirely on each team's own Lab 26 time model | PASS |
| 30 | YES | YES | Clean — the fork→clone→branch→push→PR flow verified for real with local git remotes acting as the fork/origin pair; `HANDOVER_NOTES.md` requirement and the fork-not-branch acceptance criterion both confirmed enforceable | Good — same-language pairing preference explicit, documentation-only fallback explicitly required to be reported as such, not disguised as a full code handover | ~30-45 min receiving side, plus the fixed 30-minute change timebox the lab itself sets | PASS |

## Findings, by severity

| # | Finding | Severity | Status |
|---|---|---|---|
| 1 | Lab 22 Step 14's `curl -s http://localhost:8000/orders/<new-order-id>` used a literal `<...>` placeholder — `<` and `>` are Bash redirection operators, making this unsafe to copy-paste (this is the exact bug named in the PR brief) | MAJOR | **Fixed** |
| 2 | Lab 24's "What's next" claimed "Go and Java's preview pauses again — Lab 25 stays Python-first for now, the same way it did after Lab 22" — but Lab 22 never paused (confirmed by direct reading: it has full Python/Go/Java sections throughout), and Lab 25 itself has full Python/Go/Java sections throughout, directly contradicting this claim. This is stale leftover framing from before Go/Java became mandatory equal tracks, structurally identical to a bug already found and fixed for Labs 05-06 in PR J1 | MAJOR | **Fixed** |
| 3 | Lab 25 asks for two complete release cycles (branch, implement, test, PR, merge, tag — twice, including a historical-NULL migration test) with no "realistic 90 minutes" section, unlike Lab 27's exemplary treatment of the same concern for an even larger task. The PR brief specifically flagged this as the most important timing risk in Labs 21-30 | MAJOR (disclosed timing risk, not a technical defect) | **Fixed** — added a section modeled directly on Lab 27's, with an explicit checkpoint at the `v1.0.0` tag |

No BLOCKER was found. No technical bug was found in Labs 21, 23, 26,
27, 28, 29, or 30 — every specific, falsifiable claim in those labs
(exact HTTP responses, exact retry counts, exact git-tag ancestry
behavior, exact test outcomes) was checked against a real execution,
and held up exactly as written.

## What was deep-verified, hands-on, in this pass

### Act V — full real walkthrough, Python; Go/Java verified by reading + shared-SQL confirmation

A complete, real Python implementation of `order-api` was built in a
disposable copy, carried through Labs 21-25 in sequence, matching the
published instructions exactly (not a private reference solution):

- **Lab 21**: implemented the item-validation rule, confirmed 4 tests
  pass, started the real server and ran the three documented `curl`
  commands against it, confirming byte-for-byte matching responses.
- **Lab 22**: implemented `db.py`, rewired `api.py` to use it, then
  performed the actual restart sequence the lab requires: created a
  real order, stopped the server, inserted a second row via raw SQL
  with no `notes` value at all (genuinely `NULL`, bypassing
  `create_order` entirely — the same technique Lab 25 later asks for),
  restarted, confirmed both orders survive and the historical `NULL`
  row maps to `""` rather than crashing or returning `null`, restarted
  a third time to confirm the migration is idempotent.
- **Lab 23**: implemented bounded retry with the three isolated
  policy tests plus the mandatory HTTP-level integration test — 9
  tests total, matching the lab's stated count, running in 3.1
  seconds (confirming no test actually waits through a real delay).
- **Lab 24**: wired logging through every required event, confirmed
  11 tests total (matching the lab's stated count), and read the real
  terminal output after a real POST and a real 404 GET — confirmed
  human-readable, leveled, and timestamped.
- **Lab 25**: implemented the `priority` field and all four required
  tests (15 total), then **deliberately reintroduced the exact bug
  the lab's text references** (mapping SQL `NULL` straight to JSON
  `null`) and confirmed the fourth test catches it — proving the test
  is genuinely meaningful, not a tautology — then restored the fix.
  Performed the actual two-tag release workflow in an isolated git
  repository: committed, merged, and tagged `v1.0.0`; then
  **deliberately tagged a feature branch before merging it** to
  reproduce the exact mistake the lab warns against, confirming
  `git merge-base --is-ancestor` prints no confirmation line for that
  tag (exactly as the lab describes); then performed the correct
  sequence for `v1.1.0` and confirmed both tags pass the ancestor
  check.

Go and Java were not independently re-implemented end-to-end in this
pass. Their technical claims were verified by: (a) reading every
code-shaped instruction and hint against each language's real,
current API surface (Go's `database/sql`/`errors.Is`, Java's JDBC/
`java.util.logging`), finding nothing inconsistent with real behavior;
(b) confirming the `PRAGMA table_info`/`ALTER TABLE` migration SQL
both languages' instructions specify is the same SQL already proven
correct via the Python run, since all three languages talk to the
same SQLite engine; (c) confirming the actual starter files
(`api.go`, `ApiServer.java`, etc.) match what Lab 21's instructions
describe. This is a real limitation of this pass, disclosed here
rather than implied away.

### Act VI — full real capstone walkthrough, Python; Go/Java verified structurally only

A complete, condensed TableTime capstone was built solo, end to end,
in disposable git repositories (a bare "team origin," a working
clone, and — for Lab 30 — a second bare "fork" and a separate
"receiving" clone, simulating the GitHub fork/PR flow with local git
remotes rather than a second real GitHub account):

- **Lab 26**: created the team repository structure, `PROJECT_PLAN.md`
  with a named-slot time model, `ADR-001`, copied the Python capstone
  starter with its dotfiles intact, confirmed 1 passing test.
- **Lab 27**: implemented create/list/cancel reservation with
  smallest-fitting-table assignment, through a real
  branch→test→commit→push→merge loop. Found, while designing the
  exercise, a real subtlety worth noting: a party size that happens
  to fit a single table will never reach the combined-table logic —
  an authentic design lesson, not a course bug.
- **Lab 28**: committed a prediction (own commit, before any
  implementation code), implemented combined-table support, and
  discovered mid-implementation that the first choice of combinable
  pair was unreachable (a bigger single table already covered every
  party size the pair would) — documented this honestly in the
  "reality" section as an unanticipated design subtlety, exactly the
  kind of finding this lab is designed to surface. One existing
  test's assertion needed updating for a field rename
  (`table_id`→`table_ids`); fixed the assertion, not the logic, per
  the lab's own guidance.
- **Lab 29**: checked the incident against the actual system first
  (per the lab's explicit instruction) and confirmed Path A applies —
  the double-booking bug is genuinely reproducible, since the Lab 27
  MVP never checked existing bookings. Wrote the failing test,
  confirmed it fails with both reservations assigned the same table,
  fixed it with the smallest change, confirmed no regression (8/8
  passing), wrote a blameless `POSTMORTEM.md` naming the customer
  complaint (not monitoring) as the actual detection method.
- **Lab 30**: added `ARCHITECTURE.md`, then — as the receiving
  side — forked, cloned fresh, and **found a real, authentic gap**:
  this session's own `README.md` was never finished past its Lab 26
  placeholder, so the receiving side had no written setup/run
  instructions and had to guess from prior Act V experience. This
  is exactly the scenario Lab 30's own "Hint 1" anticipates ("if the
  receiving side gets stuck on step 6, that's data, not failure") —
  it demonstrates the lab's evaluation criteria work as designed,
  not a flaw in the lab. Added the small `find_reservation_by_id`
  change with its own test (10/10 passing), wrote honest
  `HANDOVER_NOTES.md` naming the README gap specifically, and opened
  the fork→origin PR equivalent carrying both the code change and the
  notes in one branch.

Go and Java's capstone starters were verified structurally only
(confirmed minimal — no pre-built reservation logic, correct
dotfiles, safe-to-skip renaming instructions) — not independently
built into a full TableTime implementation in this pass. This is a
real limitation of this pass, disclosed here rather than implied
away.

## Local git simulation vs. real GitHub — reported separately, as required

- **Real GitHub Actions evidence**: none generated in this pass (Labs
  21-30 do not introduce a new maintainer-facing CI workflow the way
  Lab 19 did — their CI instructions are student-repository-only, and
  PR J2 already produced real GitHub Actions evidence for that exact
  pattern).
- **Local-only git simulation**: all of this pass's hands-on
  verification (Act V's SQLite/retry/release work, Act VI's full
  capstone loop) ran in disposable local git repositories, including
  a local bare-repo fork/origin pair for Lab 30 — real Git mechanics,
  but not GitHub, and not a second real GitHub account. Nowhere in
  this report is a local simulation described as a real GitHub PR or
  a real GitHub Actions run.

## 90-minute realism assessment

Reasoned estimate from reading each lab's steps and this session's
own walkthrough timings — not an empirical measurement of real
beginners, and not claimed as pilot data.

- **Lab 21**: comfortably under 90 minutes for all three languages.
- **Lab 22**: the heaviest lab in Act V — persistence and migration
  are two substantial tasks in one lab, each requiring real restarts
  to verify. Realistic 45-70 minutes for Python; Go and Java add real
  time for driver setup (`go get`, the Gradle dependency download)
  without changing the core logic's difficulty.
- **Lab 23**: comfortably under 90 minutes for all three languages —
  the retry logic is small, and the test suite (by design) never
  waits through a real delay.
- **Lab 24**: comfortably under 90 minutes — logging statements are
  additive to code that already exists; no new control flow.
- **Lab 25 — the most important timing risk in Labs 21-30, as the
  brief specifically flagged**: two full release cycles do not
  reliably fit in one 90-minute session, especially for Go and Java,
  where extracting the shared `hasColumn` helper and wiring a second
  migration point through `main` and test setup is genuine additional
  ceremony beyond Python's. **Fixed by adding an explicit checkpoint**
  at the `v1.0.0` tag — a real, safe stopping point, not a vague
  "finish later" — mirroring Lab 27's already-correct treatment of
  the same concern. The historical-NULL test is specifically flagged
  as the step most likely to need unhurried attention.
- **Lab 26**: comfortably under 90 minutes — no code pressure, though
  a team genuinely debating scope and the time model could run long;
  nothing about the lab's structure makes that a problem to fix.
- **Lab 27 — already correctly flagged by its own text as the
  heaviest lab in Act VI**: building four real capabilities through
  the full Act IV loop is realistically more than 90 minutes for a
  team new to their language's ceremony (confirmed directly in this
  pass: even a solo, trimmed capstone MVP's three capabilities took
  real, nontrivial design iteration). The lab's own explicit
  checkpoint structure and per-language honesty are the right answer
  here; no further gap found.
- **Lab 28**: comfortably within 90 minutes for a focused, scoped
  change — the prediction/reality discipline adds writing time but
  not implementation complexity.
- **Lab 29**: comfortably within 90 minutes for Path A or C; Path B's
  "go one level deeper" step has no fixed time cost, since it depends
  on how subtle each team's own time model turns out to be — this is
  inherent to the exercise, not a gap.
- **Lab 30**: the receiving side's work (clone, follow README, make a
  small change, open a PR) fits comfortably within 90 minutes when
  the handover documentation is actually complete; this pass's own
  authentic "stuck" finding (Lab 30's write-up above) shows what
  happens to that budget when it isn't — which is precisely the
  lesson this lab teaches, not a flaw in it.

### Special assessment: Labs 22, 25, 27, 29, and 30 (per the PR brief's explicit request)

- **Lab 22**: realistic, but the heaviest single-topic lab in Act V;
  no change needed beyond what was already found (the `curl` fix).
- **Lab 25**: the most significant timing risk found in this entire
  pass; fixed with an explicit checkpoint, matching the course's
  existing standard for heavy labs rather than inventing a new one.
- **Lab 27**: correctly self-identifies as the heaviest lab in Act VI
  and already has the right scaffolding (explicit checkpoints,
  per-language honesty, solo-vs-team scope guidance); no change
  needed.
- **Lab 29**: realistic for all three paths; the open-endedness of
  Path B's "deeper case" is inherent to teaching real incident
  investigation, not a defect to fix.
- **Lab 30**: realistic when the preceding labs' documentation
  obligations were actually met; this pass's own experience is live
  evidence that the lab correctly surfaces it when they weren't.

## Scope discipline confirmed

- No change to Option D's architecture, no tooling migrations, no
  global `uv`/Go/Java/GitHub Actions version bumps, no new frameworks.
- No complete, ready-to-ship TableTime committed to any public
  starter — all Act VI hands-on work happened in disposable,
  git-ignored scratch repositories outside the project tree, deleted
  after verification.
- No change to Course Health without a concrete reason, no mass edits
  to Labs 01-20, no release automation, no release published.
- Go/Java status remains unchanged — not switched to FULLY SUPPORTED.
- No tracked `decisions/`, no AI attribution, no `Co-authored-by`.

## NOT INDEPENDENTLY VERIFIED

- **Go and Java's full Act V implementation** (SQLite persistence,
  migration, retry, logging, release) was not independently
  re-implemented end-to-end in this pass — verified by code reading
  and shared-SQL-mechanics confirmation only, as detailed above.
- **Go and Java's full Act VI capstone** was not independently built
  in this pass — only the starters' structure was checked.
- **A genuine second GitHub account** for Lab 30's fork/PR flow, or
  for any paired-team scenario across Act VI — simulated with local
  git remotes, which exercises the real Git mechanics but not
  GitHub's actual UI, permissions model, or a second real account.
- **A real Windows 11 + Git Bash walkthrough of Labs 21-30** — no
  Windows-specific risk was newly found in this pass, but none of
  this pass's verification happened on an actual Windows machine.
- **The 90-minute timebox assessments above** are reasoned estimates
  from reading the lab content and this session's own walkthrough
  timings, not measurements from real students; they should not be
  cited as pilot data.
- **This report is not a substitute for a real student or team
  pilot** — it reflects one maintainer's hands-on technical
  walkthrough and full read of all 20 required documents.

## Examples of concrete EN/PL improvements made in this pass

- Lab 22: replaced an uncopyable `curl ... /orders/<new-order-id>`
  placeholder with a real numeric example and an explicit note about
  `<`/`>` being Bash redirection operators — in both languages.
- Lab 24: removed a stale, factually incorrect claim that Go/Java
  "pause" before Lab 25, replacing it with language-neutral text that
  matches what Lab 25 (and Lab 22, which the stale text falsely
  pointed to as precedent) actually contain — in both languages.
- Lab 25: added a new "realistic 90 minutes" section in both
  languages, written to match Lab 27's existing tone and structure
  exactly, rather than inventing a new style for the same concern.

## Tests actually performed in this pass

- `./scripts/check-course.sh` — run twice after all fixes, both
  green, clean working tree before and after both runs.
- `python3 scripts/check_course_structure.py` — green after every
  batch of edits.
- A full, independent, from-the-published-instructions-only
  implementation of `order-api` through Labs 21-25 in Python, in a
  disposable copy, including three real server restarts for Lab 22
  and a real two-tag release workflow (with both the correct sequence
  and the exact incorrect one the lab warns against) for Lab 25.
- A full, independent, from-the-published-instructions-only
  TableTime capstone walkthrough through Labs 26-30 in Python, in
  disposable local git repositories including a simulated fork/PR
  pair, surfacing one authentic documentation gap exactly where
  Lab 30 is designed to catch it.
