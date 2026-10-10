# Editorial & beginner-experience audit — Labs 11-20 (PR J2)

Second of three planned editorial passes. This one covers Act III
("Software must survive change" — Labs 11-15) and Act IV ("You do not
work alone" — Labs 16-20), read start to finish in both languages — not
sampled, not grepped.

**Base commit audited:** `c760573` (`main`, immediately after PR J1 /
#38 merged), on branch `quality/editorial-j2-labs-11-20`.

**Coverage: 20/20 required files read in full** — this is complete
coverage, not PARTIAL. No API or context limit was hit during this
pass.

| File | Read |
|---|---|
| `labs/11-changed-requirements/README.md` | YES |
| `labs/11-changed-requirements/README.pl.md` | YES |
| `labs/12-change-surface/README.md` | YES |
| `labs/12-change-surface/README.pl.md` | YES |
| `labs/13-refactoring-safety-net/README.md` | YES |
| `labs/13-refactoring-safety-net/README.pl.md` | YES |
| `labs/14-one-contract-three-languages/README.md` | YES |
| `labs/14-one-contract-three-languages/README.pl.md` | YES |
| `labs/15-patterns-without-worship/README.md` | YES |
| `labs/15-patterns-without-worship/README.pl.md` | YES |
| `labs/16-parallel-branches/README.md` | YES |
| `labs/16-parallel-branches/README.pl.md` | YES |
| `labs/17-merge-conflict/README.md` | YES |
| `labs/17-merge-conflict/README.pl.md` | YES |
| `labs/18-pull-requests-and-review/README.md` | YES |
| `labs/18-pull-requests-and-review/README.pl.md` | YES |
| `labs/19-repository-checks-itself/README.md` | YES |
| `labs/19-repository-checks-itself/README.pl.md` | YES |
| `labs/20-definition-of-done/README.md` | YES |
| `labs/20-definition-of-done/README.pl.md` | YES |

## Per-lab assessment

| Lab | EN read | PL read | Technical | Beginner UX | Timebox | Status |
|---|---|---|---|---|---|---|
| 11 | YES | YES | Clean — grep regex (`[[:space:]]`, `[-*]` bracket expression) tested directly and confirmed portable across BSD/GNU grep conventions. No code/toolchain required, matching its own "no code" framing | Good — student writes five questions before seeing the resolved spec; doesn't solve the analysis for them | ~20-30 min | PASS |
| 12 | YES | YES | Clean — every file path, map/dict name, and test count (4/7 existing per language, matching the lab's "5/8 after SAVE20") verified against the real `examples/discount-codes/` starters. `SAVE20` math ($60 subtotal → $53.14 total) verified by hand and confirms the starters' actual `tip`-on-after-loyalty-amount behavior | Good — doesn't reduce the comparison to a file count; asks what sits next to the change | ~30-45 min, all three languages | PASS |
| 13 | YES | YES | Clean — executed the full `tests green → add component → tests green → route behavior → tests green → remove old logic → tests green` sequence for real in Python (disposable copy), confirming every intermediate state and the final `grep`-based decoupling check. Go's "unused `fmt` import" and the grep-based verification's false-positive risk were checked against the actual starter source — no false positives possible, the coupled string patterns appear nowhere else in any file | Good — explicitly says green tests are evidence of no regression in covered cases, not proof of absolute equivalence | ~25-40 min, all three languages | PASS |
| 14 | YES | YES | **All three cross-language compiler/interpreter error messages reproduced for real** (Java `incompatible types`, Go `does not implement Notifier (missing method Send)`, Python `AttributeError: ... Did you mean: 'sand'?`) — byte-identical to the lab's quoted text. No second/third toolchain required by any mandatory instruction (confirmed by reading — Step 4's comparison is presented as pre-verified reading material, not something the student must run) | Good — doesn't force Python students to install Go/Java to compare behavior | ~20-35 min, home track only | PASS |
| 15 | YES | YES | Clean — Strategy/Factory/DI/Adapter kept distinct exactly as required ("picking a Strategy is this exercise's use of a Factory, not what a Factory inherently is"; DI explicitly "no framework required"). `SAVE_FLAT2` scoped to Version B only, not Version A, not the public starter, per instruction. Final "Before you move on to Act IV" section explicitly checks `git status` before Lab 16, addressing the Act III→IV safety concern | Good — four pattern names kept conceptually separate, not treated as synonyms | ~20-30 min, all three languages | PASS |
| 16 | YES | YES | Clean — `Summarize`/`summarize` confirmed as the only function in all three starters (besides `main`), so "insert immediately above" is unambiguous. Both branches' insertion points verified identical via direct code reading. Full real execution (see below) confirms both branches build/test cleanly and independently, from the same `main` commit, with neither containing the other's work | Good — explicit warning that branch commands operate on the whole repo, not a sub-repository inside the language folder | ~25-40 min, all three languages | PASS |
| 17 | YES | YES | **Every specific conflict-shape claim verified experimentally, for real, in all three languages** — see "What was deep-verified" below. Go and Java's precise 4-line-head/5-line-tail claims (down to which exact lines are inside vs. outside the markers) matched exactly. The `grep -nE '^(<<<<<<<\|=======\|>>>>>>>)' ... \|\| exit 1` verification pattern was tested both ways (markers present → fails; absent → succeeds) | Good — distinguishes Git conflicts from semantic conflicts; doesn't ship a resolved solution | ~30-50 min, all three languages (first real conflict resolution is the long pole here) | PASS |
| 18 | YES | YES | **One MINOR wording gap found and fixed**: the acceptance-criteria bullet said "the PR was approved... with a short record," which read as conflating GitHub-approval with the solo written-note path, even though step 5's actual instruction already correctly scopes "approve it" to the paired case only. Tightened to spell out the GitHub self-approval restriction explicitly (confirmed real: GitHub does not let a PR author formally approve their own pull request). The local, reusable part (`reorder_report` calling `low_stock_items`, not reimplementing its filter) was executed for real in Python | Good — solo workflow is a first-class path, not a lesser substitute; checklist pushes toward "why," not just "does it run" | ~20-40 min solo; longer and more variable if paired, since it depends on a partner's schedule | PASS (fixed) |
| 19 | YES | YES | **The exact bug named in the PR brief, confirmed and fixed**: step 2 told students to paste a shared `on: [push, pull_request]` fragment "at the top of the file," then immediately showed a complete per-language example that *also* started with that same `on:` line — a beginner reading linearly would paste both and end up with a duplicate key. Fixed by removing the separate fragment and stating plainly that each language's block is the complete file to copy as-is. **Verified with a real GitHub Actions run** (see below): the corrected Python workflow was pushed to a disposable branch on the real repository and went green, then red after a deliberate test break, then green again after reverting — a genuine red/green cycle, not a YAML-syntax check. Action version pins (`actions/checkout@v7`, `actions/setup-python@v7`, `astral-sh/setup-uv@v10.2.0`, `actions/setup-go@v7`, `actions/setup-java@v6`, `gradle/actions/setup-gradle@v6`) confirmed identical to the maintainer's own `course-health.yml` | Good — explicitly distinguishes the maintainer-only upstream-gated workflow from the student's own, and explains why a fork shows it as "skipped," not failed | ~25-40 min active work, plus real wait time for GitHub Actions runs and (if paired) scheduling | PASS (fixed) |
| 20 | YES | YES | Clean — verification only checks structure (file exists, 5-8 checkbox lines), never claims to assess the checklist's actual content quality, matching the instruction that technical verification isn't a content-quality judgment. Doesn't hand the student a ready-made DoD; "candidate items" appear only in the hint section, not the main instructions. Transition to Lab 21 confirmed clean — Lab 21 only requires "Labs 06-20 complete," no file-state coupling to Lab 20's specific deliverable | Good — explicitly requires an honest "doesn't fully satisfy" answer, not a default "all yes" | ~20-30 min | PASS |

## Findings, by severity

| # | Finding | Severity | Status |
|---|---|---|---|
| 1 | Lab 19 told students to paste a shared `on:` trigger fragment, then immediately showed a complete per-language example repeating the same `on:` key — a beginner following both instructions literally would duplicate the key | MAJOR (the one bug explicitly named in the PR brief) | **Fixed** |
| 2 | Lab 18's acceptance-criteria wording ("the PR was approved... with a short record") read as conflating GitHub's own approval mechanism with the solo written-note alternative, even though the detailed step 5 instruction was already correctly scoped | MINOR | **Fixed (wording tightened)** |

No BLOCKER was found. No technical bug was found in Labs 11-17 or 20 —
every specific, falsifiable claim in those labs (exact dollar amounts,
exact conflict-block line counts, exact compiler error text, exact
test counts) was checked against either the real starter code or a
real, independent execution, and held up exactly as written.

## What was deep-verified, hands-on, in this pass

### Act III

- **Lab 12**: confirmed file paths, map/dict names, and pre-`SAVE20`
  test counts (4 in Version A, 7 in Version B, for all three
  languages) against the real `examples/discount-codes/` starters —
  not assumed from the README text.
- **Lab 13**: executed the full add-component → route → remove-old-logic
  sequence for real in a disposable Python copy, confirming the test
  suite stays green at every intermediate step (not just at the end),
  and that the `grep`-based "decoupled" check correctly flips from
  "still coupled" to "decoupled" only once the refactor is actually
  done.
- **Lab 14**: reproduced all three cross-language error scenarios for
  real, in disposable copies — the exact Java `incompatible types`
  compiler error, the exact Go "missing method Send" compiler error,
  and the exact Python `AttributeError: ... Did you mean: 'sand'?` —
  confirming none of the lab's quoted error text was invented.
- **Lab 15**: verified by direct reading that the `SAVE_FLAT2` addition
  instructions match the `SAVE5` shape exactly in all three languages,
  and that Version A and the public starter are explicitly excluded.

### Act IV

- **Labs 16-17, all three languages, in three separate isolated git
  repositories** (not the shared course repository, per the PR brief's
  explicit instruction): ran the real sequence — clean `main` → create
  `feature/low-stock-warning` → implement, test, commit → back to
  `main` → create `feature/expiry-warning` → implement, test, commit →
  merge the first (fast-forward) → merge the second (conflict) →
  resolve → test → commit the merge. Every specific claim in Lab 17's
  per-language "exact conflict you'll see" sections was checked against
  the actual `<<<<<<<`/`=======`/`>>>>>>>` output, not assumed:
  - Python: two conflict blocks in the source file, two in the test
    file (import line, adjacent test functions) — matched exactly.
  - Go: **exactly four lines inside the first marker on each side**
    (signature, `var names []string`, the `for` line, the `if` line)
    and **exactly five lines of shared tail merged automatically**
    (`names = append(...)`, two closing braces, `return names`, the
    function's closing brace) — matched exactly, line for line.
  - Java: the identical shape as Go, for the identical reason, down to
    the `@Test` annotation line sitting just outside the marked block
    — matched exactly, line for line.
  - All three languages: zero conflict markers after resolution, all
    tests passing (3 total) after the merge, a real merge commit in
    `git log --graph`.
- **Lab 18's reusable local part**: implemented `reorder_report` in
  Python, confirmed it calls `low_stock_items` rather than
  reimplementing its filter, and that both example outputs ("Reorder
  needed: ...", "Nothing to reorder.") are reachable.
- **Lab 19, with a real GitHub Actions run** — not a local simulation
  and not a YAML-syntax check: pushed the corrected Python workflow to
  a disposable branch on the real repository (cleaned up afterward,
  never merged) and observed a genuine green → red → green cycle:
  green on the first push, red after a deliberate test break
  (`assert "Flour: 999 units" in result`), green again after reverting.
  Confirmed the action version pins match `course-health.yml` exactly.

## GitHub CI vs. local simulation — reported separately, as required

- **Real GitHub Actions evidence**: Lab 19's corrected Python workflow,
  on a real disposable branch of the canonical repository, green → red
  → green (see above). This is genuine platform evidence, not a local
  stand-in.
- **Local-only simulation**: Labs 16-18's branch/merge/conflict/PR-local
  mechanics were run in disposable, local-only git repositories — real
  Git operations, but not on GitHub, and not through a second GitHub
  account or a genuine second fork. Lab 18's actual GitHub web UI flow
  (the "Compare & pull request" button, the base-repository dropdown
  defaulting to the upstream fork, a paired reviewer's experience) was
  **not** independently exercised this way — see below.

## 90-minute realism assessment

Reasoned estimate from reading each lab's steps and this session's own
walkthrough timings — not an empirical measurement of real beginners,
and not claimed as pilot data.

- **Lab 11**: comfortably under 90 minutes — pure requirements writing,
  no code.
- **Lab 12**: the two-implementation-plus-notes structure means real
  time roughly doubles the single-implementation cost of Labs 06-09;
  still comfortably under 90 minutes for all three languages, since
  each individual change is a one-line addition.
- **Lab 13**: the "tests green at every step" discipline adds real
  verification time (several test runs instead of one), but each run
  is fast; under 90 minutes for all three languages. Go's extra
  "check whether `fmt` is now unused" step is a small, bounded addition
  to the Go track specifically, not a risk to the budget.
- **Lab 14**: comfortably under 90 minutes — only the home track's
  toolchain is needed, and the cross-language comparison is reading,
  not running.
- **Lab 16-17 together**: the highest real-time cost in this act,
  because it's the first time a student plays two roles sequentially,
  hits a real conflict, and has to read markers they've never seen
  before. A first-time conflict resolution plausibly runs long for a
  true beginner even though the lab's own content is compact — the
  natural checkpoint is exactly where Lab 16 ends and Lab 17 begins
  (both branches exist, tests pass independently), since nothing is
  lost by resuming there after a break.
- **Lab 18**: solo, comfortably under 90 minutes. Paired, the real
  wall-clock time depends on a partner's schedule, not on the
  student's own pace — this is disclosed as a scheduling risk, not a
  content risk, and the lab's solo path is explicitly a complete
  alternative, not a fallback for those who couldn't find a partner.
- **Lab 19**: the one lab in this act where real elapsed time includes
  GitHub Actions queue/run time outside the student's control (seconds
  to low minutes per run in this session's testing, but CI queues can
  be slower under load) — doesn't change the amount of work, but can
  make the lab feel longer than the actual hands-on time.
- **Lab 20**: comfortably under 90 minutes — no code, and the lab
  explicitly tells the student to skim rather than re-derive the
  previous labs' acceptance criteria.

No lab in this act is recommended for scope reduction; Lab 16-17's
real-time risk is inherent to it being a genuinely new skill
(first conflict resolution), not padding to cut.

## Scope discipline confirmed

- No change to the Option D architecture, no new Restaurant
  Bill/Discount Codes/Notifier/Team Inventory features beyond what
  each lab's own exercise already specifies, no new frameworks.
- No toolchain version changes (`uv`, Go, Java, GitHub Actions action
  versions all left exactly as they were, and confirmed consistent
  with `course-health.yml`).
- No change to Labs 01-10 or 21-30 — Lab 21's "Before you start" was
  read to confirm the Lab 20→21 transition needs no fix, not edited.
- No change to Course Health, no PREVIEW/FULLY SUPPORTED status
  change, no capstone model change, no license policy change, no
  release.
- Every fix in this PR is a documentation correction to Labs 18-19 —
  no starter source file under `examples/` was modified in the
  committed result (Lab 13's and Lab 16-17's real executions happened
  in disposable, git-ignored scratch copies outside the repository,
  and were deleted after verification; nothing from them was copied
  into any public starter).
- No tracked `decisions/`, no AI attribution, no `Co-authored-by`.

## NOT INDEPENDENTLY VERIFIED

- **A genuine second GitHub account or fork for Lab 18's paired-review
  and base-repository-dropdown flow.** The web UI's actual behavior —
  "Compare & pull request," the base-repository dropdown defaulting to
  the upstream fork, what a paired partner's review screen looks like
  — is described from documented, current GitHub product behavior, not
  exercised end-to-end with two real accounts in this pass.
- **Lab 19's fork-specific onboarding** — a brand-new fork's Actions
  tab showing the "workflows disabled" banner, and the click needed to
  enable them — was not independently reproduced with a fresh fork in
  this pass; it's stated from documented, current GitHub behavior.
  (The workflow's actual execution and the red/green cycle *were*
  independently verified for real, on the canonical repository — see
  above. Only the "this is a newly-created fork" first-run experience
  specifically was not.)
- **A real Windows 11 + Git Bash walkthrough of Labs 11-20** — none of
  this pass's fixes were Windows-specific, and no new Windows-only risk
  was found, but this pass did not re-run PR I's Windows CI smoke test
  (nothing in Labs 01-04 changed here) and did not newly test Labs
  11-20 on a real Windows machine.
- **The 90-minute timebox assessment above** is a reasoned estimate
  from reading the lab content and this session's own walkthrough
  timings, not a measurement from real students; it should not be
  cited as pilot data.
- **This report is not a substitute for a real student or paired-review
  pilot** — it reflects one maintainer's hands-on technical walkthrough
  and full read of all 20 required documents.

## Tests actually performed in this pass

- `./scripts/check-course.sh` — run twice after all fixes, both green,
  clean working tree before and after both runs.
- `python3 scripts/check_course_structure.py` — green after every
  batch of edits.
- Full, independent, from-the-published-starter-only execution of
  Lab 13's refactor sequence (Python) and Labs 16-17's branch/conflict
  sequence (Python, Go, Java), each in disposable, isolated git
  repositories outside the project tree.
- A real GitHub Actions run of Lab 19's corrected workflow, on a
  disposable branch of the canonical repository, exercising a genuine
  green → red → green cycle (not a YAML-syntax check).
- All three of Lab 14's cross-language error messages reproduced for
  real and compared byte-for-byte against the lab's quoted text.
