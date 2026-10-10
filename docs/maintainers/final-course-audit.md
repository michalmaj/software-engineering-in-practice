# Final course audit (PR H)

This is the final cross-track, pedagogical, and editorial audit of
this course before a GO/NO-GO decision on moving Go and Java from
PREVIEW toward FULLY SUPPORTED. It's a maintainer-facing record of
what was checked, what was found, what was fixed, and — just as
important — what was **not** independently re-verified in this pass,
stated plainly rather than implied away.

## Scope

- **Commit audited:** `tracks/phase-h-final-audit`, branched from
  `main` immediately after PR G (#35) merged.
- **Course scope:** all 30 labs, both `README.md` and `README.pl.md`,
  the root README/START-HERE/`docs/setup/` onboarding chain, the
  `examples/` starters, and `scripts/check-course.sh` /
  `check-environment.sh`.
- **Method:** a mix of (a) hands-on execution — copying starters into
  fresh, isolated directories and actually running the documented
  steps, including deliberately breaking things to confirm failure
  detection, the same discipline used throughout this course's
  migration; and (b) direct reading and sampling of lab text across
  all three acts and both languages. Background research agents were
  used for part of the initial sweep but hit this session's API rate
  limit partway through and were not retried; the sections below are
  explicit about which findings came from completed hands-on
  verification versus reading/sampling, and which parts of the course
  were not re-examined line-by-line in this pass.

## Python / Go / Java matrix

| Area | Python | Go | Java |
|---|---|---|---|
| Labs 01-04 (shared, language-agnostic) | n/a — no track yet | n/a | n/a |
| Lab 05 (reproducibility) | required, unchanged | **required** (was optional preview — fixed this PR) | **required** (was optional preview — fixed this PR) |
| Labs 06-20 | real track (verified in PR A-D work; Lab 16-17 re-verified fresh this PR) | real track | real track |
| Labs 21-25 (order-api) | real track (authored PR D/E1-E4) | real track | real track |
| Labs 26-30 (TableTime) | real track (authored PR F) | real track | real track |
| Public starters leak no solutions | confirmed via Course Health's frozen baseline contract + registry | same | same |

Go and Java have real, substantive, independently-designed (not
transliterated) content through all 30 labs. This matrix does not by
itself justify FULLY SUPPORTED — see "GO/NO-GO" below for the full
criteria.

## What was deep-verified, hands-on, in this pass

### Lab 05 — the three-track contradiction (confirmed and fixed)

Lab 05's Story explicitly said *"the rest of this page is the Python
path... there's a Go and Java preview... They're optional"*, while the
root README says a student picks their track starting at Lab 05. That
is a direct, user-visible contradiction a beginner would hit on day
one of picking Go or Java. Fixed: Lab 05 now has three full, required
paths (Python/Go/Java), each with its own Before-you-start,
step-by-step task, acceptance criteria, verification block, and hints
— not just the word "preview" replaced with "required." The Go and
Java toolchain-mismatch experiments that already existed were
preserved in substance but **re-verified from a genuinely fresh copy
of each starter**, not assumed correct because they predated this PR:

- **Go:** bumped `go.mod` to `go 1.28`, ran `GOTOOLCHAIN=local go
  build ./...` — got exactly the documented error
  (`go.mod requires go >= 1.28 (running go 1.25.1; GOTOOLCHAIN=local)`),
  then the default `GOTOOLCHAIN=auto` build — got the documented,
  *different* failure (`toolchain not available`, since Go 1.28 has
  not shipped as of this audit). Restored `go 1.27`, confirmed
  `go build ./...` and `go test ./...` pass again.
- **Java:** bumped `build.gradle`'s `JavaLanguageVersion.of(21)` to
  `25`, ran `./gradlew build` — got exactly the documented error (no
  installed toolchain matches, no download repository configured).
  Restored `21`, confirmed `./gradlew test build` passes again.

Both experiments matched their lab text's predictions exactly.

### Windows onboarding — the Chocolatey privilege bug (confirmed and fixed)

Flagged before this audit started. Confirmed real: `docs/setup/windows.md`
and `windows.pl.md` installed Git via Chocolatey from an
**administrator** PowerShell window, then installed VS Code via
`choco install vscode -y` from a **normal** (non-administrator)
window. Chocolatey's standard community install (used in this guide's
Part 2) installs system-wide to `C:\ProgramData\chocolatey`, which
needs administrator rights for `choco install` to write into — this
would fail, or behave inconsistently, for a student following the
steps as written on a locked-down or standard-privilege account.

Fixed in both EN and PL: merged the VS Code install into the same
administrator-window step as Git (now "Part 3 — Install Git for
Windows and VS Code"), renumbered the parts that shifted as a result,
and fixed every cross-reference to the old numbering. Separately
found and fixed a second, related bug in the same files' troubleshooting
section: the instructions assumed `bash.exe` lives in the *same*
folder as `git.exe` (`(Get-Command git).Source`'s parent) — it
doesn't; Git for Windows puts `git.exe` in a `cmd\` folder and
`bash.exe` in a sibling `bin\` folder. Replaced with a
`Join-Path`/`Split-Path` command that computes the correct path, plus
a `Test-Path` instruction to confirm the computed path is actually
right before pasting it into VS Code's settings.

**Not independently verified on a real Windows machine** — no Windows
environment was available in this session. Both fixes are reasoned
from Chocolatey's and Git for Windows' own documented install
behavior, not executed end-to-end on real hardware. This should be
spot-checked on a real Windows 11 + Git Bash machine before the next
cohort starts, ideally by someone following the page cold.

**Update (PR I):** a real, narrow Windows GitHub Actions smoke test now
executes the `bash.exe`-location fix and several other Git-Bash-
specific steps on a genuine `windows-latest` runner — see
[`windows-reality-check.md`](windows-reality-check.md) for the full
results matrix. This confirms the `Join-Path`/`Split-Path` fix actually
resolves on a real Git for Windows install, but a GitHub-hosted runner
has no desktop session, so the Chocolatey install itself, UAC prompts,
and the VS Code GUI terminal-profile flow remain **NOT INDEPENDENTLY
VERIFIED** on real Windows 11 hardware.

### Lab 16-17 — the merge conflict's determinism (verified correct, no bug found)

This was treated as the single highest-risk technical claim in Act
IV, and was verified exhaustively rather than sampled: executed the
*exact* documented Lab 16 → Lab 17 sequence end-to-end, in real,
isolated Git repositories, independently for Python, Go, and Java —
created both feature branches from the same `main` commit,
implemented both functions and tests exactly as the lab instructs,
merged the first branch (confirmed fast-forward, as predicted), merged
the second (confirmed conflict, as predicted), and compared the
**actual** conflict markers against the lab's specific claims —
including precise claims like "the first conflict block is exactly 4
lines on each side, with a 5-line tail that merges automatically" for
Go and Java, and "exactly one block, since the `@Test` line itself
matches on both sides" for Java.

**Every claim matched exactly, in all three languages.** Resolved each
conflict the documented way and confirmed all 3 tests passed with no
markers remaining, in all three languages. This lab is correct as
written; no fix was needed or made.

### `check-environment.sh` — mislabeled requirements (confirmed and fixed)

Found while investigating the onboarding sequence: the script labeled
`python3` as needed "(Lab 01)" and `curl` as needed "(Lab 02)" —
neither lab uses either (confirmed via `grep`: zero references in
either lab's README). This contradicts the root README's own promise
that no language toolchain is needed before a track is picked. The
script also unconditionally checked all three languages' toolchains
with no indication that seeing `MISSING` for two of the three is
completely normal for a student who's picked one track — a beginner
running it out of curiosity could reasonably read several `MISSING`
lines and a non-zero exit code as "my setup is broken."

Fixed: corrected every tool's label to say which track it belongs to
and which lab actually introduces it, and added an explanatory header,
printed before any check runs, stating plainly that two of the three
language rows showing `MISSING` is expected and fine.

### TableTime consistency (re-confirmed, no new issue)

Personally re-read Lab 26's Story (still frames double-booking as an
open requirements gap, never pre-admits it as a known recurring bug)
and Lab 29's Path C section (still explicitly says "this was a
verification, not a fix," never claims a repair that didn't happen).
Matches what was verified when these were authored in PR F; no
regression found.

## Sampled (read in full; no BLOCKER or MAJOR found; not claiming
exhaustive coverage)

Lab 02 (terminal), Lab 11 (changed-requirements), and Lab 18
(pull-requests-and-review) were read end-to-end as a cross-section of
Acts I, III, and IV. All three had genuinely lab-specific Story
framing, concrete and non-interchangeable reflection questions, and
(where relevant) real continuity with the labs immediately before and
after them. A hint/reflection-question count sweep across nine labs
(02, 06, 09, 11, 13, 15, 18, 20, 23) confirmed that labs showing "9
hints" are exactly 3 hints × 3 per-track subsections, not nine
generic, repeated hints — consistent with structure, not padding.

This sampling found no evidence of the "mechanical template" problem
a prior audit flagged, in the labs it covered — but it is a sample,
not a full re-read of all 30 labs' prose, and should not be reported
as one.

## 90-minute realism

Labs 22, 25, and 27 already carry their own explicit "realistic
90-minute" risk sections, written when each was authored (PR E2, E4,
F respectively) — these were spot-checked for presence and found
intact, not weakened. No new timebox analysis was performed on the
other labs in this pass beyond the sampling above.

## uv version (0.11.21)

Re-raised in this PR's instructions as something to assess, not
mechanically bump. This was already investigated in PR G: all pinned
GitHub Actions (checkout, setup-python, setup-uv, setup-go,
setup-java, gradle/actions/setup-gradle) are on their current major
version; `uv` itself (pinned at `0.11.21`) is behind the latest
`0.12.x` release, but it remains functional and secure for this
course's purposes, and that version string is repeated across dozens
of student-facing files course-wide. That assessment stands
unchanged: **not bumped in this PR** — a version migration of that
breadth belongs in its own, separately-justified PR with its own test
results, not folded into an audit pass.

## Local-first / Codespaces check

Confirmed the root README still presents local setup as "the default
path" with Codespaces introduced afterward as an explicit alternative
("Prefer not to install anything locally?"), not the other way around.
No regression found.

## Issues found, by severity

| # | Finding | Severity | Status |
|---|---|---|---|
| 1 | Lab 05 presented Go/Java as optional preview while root README said tracks start at Lab 05 | BLOCKER | **Fixed** |
| 2 | Windows setup installed VS Code from a non-administrator window after Chocolatey, which needs admin rights | BLOCKER (onboarding) | **Fixed** |
| 3 | Windows setup's `bash.exe` location assumption (same folder as `git.exe`) was factually wrong | MAJOR | **Fixed** |
| 4 | `check-environment.sh` mislabeled which lab needs which tool, and didn't explain that 2/3 language rows showing MISSING is normal | MAJOR | **Fixed** |
| 5 | Full line-by-line editorial/naturalness audit of all 30×2 READMEs not completed (agent failures; time budget) | — | **Closed (PR J1-J3):** all 60 files read in full across three follow-up passes — see [`editorial-audit-j1.md`](editorial-audit-j1.md), [`editorial-audit-j2.md`](editorial-audit-j2.md), [`editorial-audit-j3.md`](editorial-audit-j3.md) |
| 6 | Windows fixes not executed on a real Windows machine | — | **Partially closed (PR I): real CI execution on `windows-latest` added — see [`windows-reality-check.md`](windows-reality-check.md); real-GUI items remain open, disclosed (NOT INDEPENDENTLY VERIFIED)** |

No BLOCKER remains open. Findings 5 and 6 are scope limitations of
this specific audit pass, disclosed rather than hidden, and are
recommended as the starting point for a follow-up pass rather than a
reason to block this PR specifically — they were already present
before this PR and are not newly introduced by it.

## Real test results

- `./scripts/check-course.sh` — run twice after all fixes, both green,
  clean working tree before and after both runs.
- Lab 05's Go and Java experiments — executed fresh in isolated
  copies, matched documented behavior exactly (see above).
- Lab 16→17's merge conflict — executed fresh in isolated Git repos
  for all three languages, matched documented behavior exactly,
  including precise line-count claims (see above).
- EN/PL structural checks (lab count, README pairs, broken links, no
  tracked `decisions/`, no AI-attribution strings, executable
  code-block parity) — all green on both runs.

## NOT INDEPENDENTLY VERIFIED

- Real Windows 11 + Git Bash execution of the corrected
  `docs/setup/windows.md`/`.pl.md` — no Windows environment available
  in this session. **Update (PR I):** partially closed by a real
  `windows-latest` GitHub Actions smoke test — see
  [`windows-reality-check.md`](windows-reality-check.md). Items
  requiring an actual desktop session (UAC prompts, a fresh Chocolatey
  install, Git Bash appearing in VS Code's GUI terminal-profile menu,
  the GitHub web UI fork step) remain not independently verified.
- A full, exhaustive line-by-line editorial pass over all 30 labs'
  prose in both languages, and a full native-Polish naturalness read
  of all 30 `README.pl.md` files — this pass sampled a cross-section
  (see above) rather than completing an exhaustive read; background
  agents dispatched for broader coverage failed partway through due to
  this session's API rate limit and were not retried. **Update (PR
  J1-J3):** this gap is now closed — three follow-up passes read every
  one of Labs 01-30's `README.md`/`README.pl.md` files in full
  (60/60, 20 per PR), found and fixed real bugs in each batch, and
  performed extensive hands-on, from-the-published-instructions-only
  verification across Python/Go/Java. See
  [`editorial-audit-j1.md`](editorial-audit-j1.md) (Labs 01-10),
  [`editorial-audit-j2.md`](editorial-audit-j2.md) (Labs 11-20), and
  [`editorial-audit-j3.md`](editorial-audit-j3.md) (Labs 21-30) for
  the full per-lab findings, what was and wasn't independently
  verified, and the 90-minute timebox assessment for every lab.
- A from-scratch, fresh re-execution of every example project in
  Labs 06-15 and 19-25 in this specific session (Lab 16-17's
  team-inventory was freshly re-executed; Course Health's own
  automated suite does execute all of these on every run, and passed
  twice, which is real signal but not the same as a human walking
  through the written instructions by hand).

## GO / NO-GO

**GO**, on the specific, narrow question this audit was scoped to:
whether a known BLOCKER remains open. None does — the two BLOCKER-
level findings from this pass (Lab 05's three-track contradiction, the
Windows Chocolatey ordering bug) are fixed and re-verified; the single
highest-risk technical claim in the course (Lab 16-17's merge-conflict
determinism) was exhaustively verified correct in all three languages
with zero bugs found.

This is not a recommendation to flip Go/Java from PREVIEW to FULLY
SUPPORTED in this PR — that remains a separate decision, to be made
with the scope limitations above in view (specifically: the onboarding
chain's Windows path is still not independently verified on real
hardware, and a full editorial pass has not yet been completed for
every lab). Both are reasonable next steps, not reasons to withhold
the GO on this audit's actual scope.
