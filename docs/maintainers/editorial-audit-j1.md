# Editorial & beginner-experience audit — Labs 01-10 (PR J1)

This is the audit required by PR J1, closing the full-editorial-pass gap
PR H's audit disclosed as not completed. It covers the shared onboarding
path (Labs 01-04) and the first three-track act (Labs 05-10), in both
languages, read start to finish — not sampled, not grepped.

**Base commit audited:** `f7cd4f9` (`main`, immediately after PR I / #37
merged), on branch `quality/editorial-j1-labs-01-10`.

**Coverage: 20/20 required files read in full**, plus the three
`examples/restaurant-bill/{python,go,java}/` starters and all three
language tracks' `examples/works-on-my-machine/` starter (Python) read
for cross-reference:

| File | Read |
|---|---|
| `labs/01-workstation/README.md` | YES |
| `labs/01-workstation/README.pl.md` | YES |
| `labs/02-terminal/README.md` | YES |
| `labs/02-terminal/README.pl.md` | YES |
| `labs/03-inherited-repository/README.md` | YES |
| `labs/03-inherited-repository/README.pl.md` | YES |
| `labs/04-local-vs-remote/README.md` | YES |
| `labs/04-local-vs-remote/README.pl.md` | YES |
| `labs/05-works-on-my-machine/README.md` | YES |
| `labs/05-works-on-my-machine/README.pl.md` | YES |
| `labs/06-from-script-to-project/README.md` | YES |
| `labs/06-from-script-to-project/README.pl.md` | YES |
| `labs/07-automated-tests/README.md` | YES |
| `labs/07-automated-tests/README.pl.md` | YES |
| `labs/08-bug-report/README.md` | YES |
| `labs/08-bug-report/README.pl.md` | YES |
| `labs/09-automated-checks/README.md` | YES |
| `labs/09-automated-checks/README.pl.md` | YES |
| `labs/10-one-way-to-check/README.md` | YES |
| `labs/10-one-way-to-check/README.pl.md` | YES |

This is **full coverage, not PARTIAL** — no context or API limit was hit
during this pass.

## Per-lab assessment

| Lab | EN read | PL read | Technical | Beginner UX | Timebox | Status |
|---|---|---|---|---|---|---|
| 01 | YES | YES | Clean — Codespaces-first/python3 framing (flagged in the PR brief as a known bug) turned out to already be fixed in a prior PR H commit (`8c78b6d`); re-confirmed correct, no new issue | Good; `which git`/`which code` only, no toolchain needed | ~20-30 min | PASS |
| 02 | YES | YES | Clean — bare Bash ticker-loop experiment (also pre-fixed in `8c78b6d`); no `python3 -m http.server` found | Good; two-terminal `Ctrl+C` exercise reads clearly | ~30-45 min | PASS |
| 03 | YES | YES | **Gap found and fixed**: no guidance anywhere in the repo for a first-ever `git commit` failing with "Please tell me who you are" (`user.name`/`user.email` unset) — added | Good once fixed; recovery path is inline, not a separate lookup | ~20-30 min | PASS (fixed) |
| 04 | YES | YES | Clean — correctly delegates to `github-auth.md` and `already-have-a-fork.md` instead of duplicating onboarding | Good | ~30-60 min (first GitHub auth is the real variance) | PASS |
| 05 | YES | YES | **Bug found and fixed**: Python track's bare `python3 main.py` (step 1) assumes a `python3` command that doesn't exist on stock Windows (official installer provides `python`, not `python3`) — could be misread as the lesson's own missing-dependency error. Fixed with an inline OS note + explanation of the "command not found" case. `GOTOOLCHAIN`/`JavaLanguageVersion` experiments and the deliberately-kept `uv.lock` requirement verified intact and correct | Good; three tracks balanced, each with its own install step, experiment, and recovery | Python ~30-40 min; Go/Java ~40-70 min (toolchain install is the variable) | PASS (fixed) |
| 06 | YES | YES | **Two bugs found and fixed**: (1) stale "Lab 05 has an optional Go/Java preview... isn't required" language directly contradicting PR H's mandatory-three-track decision, plus a "this is the first lab with three tracks" claim that's no longer true since Lab 05 already is; (2) the same Windows `python3`/`python` naming issue as Lab 05, plus a dead verification line (`python3 -c "..." 2>&1 \|\| true`) that swallowed its own result and added nothing. All fixed, EN+PL. Verified end-to-end by actually implementing the lab (not a pre-existing private solution) for Python, Go, and Java from the published starters alone — byte-identical before/after diffs confirmed for all three | Good after fixes | Python ~45-70 min; Go ~45-75 min; Java ~50-80 min (Gradle's first-download ceremony is the long pole) | PASS (fixed) |
| 07 | YES | YES | Clean — verified by writing and running all six tests for all three languages against the Lab 06 output; math double-checked by hand ($38 order → $46.74 total) | Good; Arrange-Act-Assert explained, only the first test given, rest left for the student | ~30-50 min, all three tracks | PASS |
| 08 | YES | YES | Clean — verified by reproducing the exact red→green sequence for all three languages: added the failing test, confirmed it failed with the documented wrong value (4.80 vs 4.32), applied the one-line fix, confirmed green | Good; no implementation handed to the student | ~20-35 min, all three tracks | PASS |
| 09 | YES | YES | Clean — PMD is correctly never called a "formatter" (spec's specific concern); verified by actually triggering and observing every deliberate violation (ruff unused import, `go vet` format-verb mismatch, PMD unused variable, Spotless's 2-space reformat) for all three languages | Good; first-dependency-download explained, every experiment explicitly reversible | Python ~25-35 min; Go ~20-30 min; Java ~45-65 min (two extra Gradle plugins plus a hand-written ruleset) | PASS |
| 10 | YES | YES | Clean — verified by creating all four scripts for all three languages and invoking them with `bash scripts/<name>.sh` from `~`, confirming none depend on the caller's working directory; the Git-Bash executable-bit caveat is explicit and correct | Good; scripts shown in full, no hidden helper complexity | ~20-35 min, all three tracks | PASS |

## Findings, by severity

| # | Finding | Severity | Status |
|---|---|---|---|
| 1 | Lab 03's first `git commit` has no documented recovery for "Please tell me who you are" (missing `user.name`/`user.email`) | MAJOR (beginner blocker) | **Fixed** |
| 2 | Labs 05 and 06 assume a bare `python3` command exists; Windows' official Python installer provides `python`, not `python3` — a Windows student could read "command not found" as the lesson's intended dependency error | MAJOR (beginner blocker, Windows-specific) | **Fixed** |
| 3 | Lab 06 described Lab 05's Go/Java tracks as an "optional preview... not required," contradicting PR H's decision to make all three tracks mandatory, and claimed to be "the first lab with three tracks" when Lab 05 already is | MAJOR (factually wrong, contradicts a settled decision) | **Fixed** |
| 4 | Lab 06's Python verification block ran a `python3 -c "..."` check whose result was swallowed (`2>&1 \|\| true`), providing no real signal, and shared finding #2's Windows incompatibility | MINOR | **Fixed (removed)** |
| 5 | Two "known bugs" named in the PR brief (Lab 01 Codespaces-first framing, Lab 01/02 hidden `python3` requirement) were already fixed in a prior commit (`8c78b6d`, part of PR H) before this audit began | — | **Not a bug — confirmed via `git log` and direct reading, no action needed** |

No BLOCKER was found. Nothing in Labs 01-10 required changing a student
exercise's actual learning content, removing a deliberately-kept bug
(Lab 05's `uv.lock`, the tax-before-discount bug), or adding a complete
solution — every fix was a documentation or onboarding-path correction.

## What was deep-verified, hands-on, in this pass

- **Labs 06-10, all three languages, from the published starters alone**,
  in a disposable scratch copy, not a private reference solution:
  implemented the actual refactor, wrote the actual tests, reproduced
  and fixed the actual bug, ran the actual formatter/analyzer
  experiments, and wrote and ran the actual four scripts from a
  different working directory. Every documented command, every
  expected number, and every "what you should see" claim matched
  real output, for Python, Go, and Java independently.
- **Lab 05's Python track**, step by step, in a separate disposable
  copy: confirmed `python3 main.py` fails with `ModuleNotFoundError`
  before `uv sync` (on this macOS environment, where `python3` exists
  globally) and that `uv sync` / `uv run python main.py` / `uv run
  pytest` all succeed afterward. Lab 05's Go and Java toolchain-mismatch
  experiments (`GOTOOLCHAIN=local` vs `auto`, `JavaLanguageVersion`)
  were not re-executed in this pass — they were already executed fresh
  in PR H's audit (see `final-course-audit.md`) and nothing in their
  instructions changed here.
- **The Lab 01-04 → Lab 05 → Lab 06 transition**: confirmed file-level
  continuity at each handoff (`~/lab01-notes` → `~/lab02-notes` →
  `labs/03-.../notes/` → `labs/04-.../notes/` → the language-specific
  `examples/` starters) and that Lab 11's "Before you start" doesn't
  assume anything beyond what Lab 10 actually asks a student to
  produce.
- **EN/PL structural parity**: `scripts/check_course_structure.py`
  (lab structure, README pairs, broken links, no tracked `decisions/`,
  no AI-attribution strings, EN/PL executable code-block parity) run
  after every batch of edits — including catching and fixing a parity
  break this audit's own first fix introduced (the Lab 03 git-identity
  example used a translated placeholder name/email; code blocks must
  be byte-identical across languages, so it was changed back to the
  English placeholder in both files).

## Editorial read (EN/PL naturalness)

All 20 files were read in full with an eye for mechanical phrasing,
artificial EN/PL symmetry, and awkward literal translation, per the
PR brief's section 7. Finding: **the existing prose in Labs 01-10 is
already of high quality** — each lab's Story is lab-specific (no
reused generic framing), reflective questions are not interchangeable
between labs, and the Polish text reads as natural technical Polish
rather than a word-for-word calque (including correct, idiomatic use
of inflected forms like "w Części 5" rather than forcing nominative
case). No heavy editorial rewrite was warranted or performed beyond
the concrete fixes listed above — this was a targeted correction pass
on top of already-solid prose, not a line-by-line copyedit of
otherwise-fine sentences. Hint and reflection-question counts were
left exactly as they were; none were added or removed for symmetry.

## 90-minute realism assessment

This is a reasoned estimate based on reading each lab's actual steps
and this session's own hands-on walkthrough times, **not an empirical
measurement of real beginners** — none was performed, and none is
claimed.

- **Labs 01-04**: all comfortably under 90 minutes individually.
  Lab 04 has the widest variance, driven entirely by first-time GitHub
  authentication (browser OAuth or creating a personal access token),
  not by the Git commands themselves — already covered by a dedicated,
  linked guide (`github-auth.md`) rather than inline duplication.
- **Lab 05**: Python is the fastest of the three (no toolchain
  install beyond `uv`). Go and Java both carry a real first-time
  toolchain install (Go itself, or a JDK) on top of the lab's own
  steps — this is the most likely point in Labs 01-10 for a Go/Java
  student to approach the 90-minute mark, and it is driven by
  installation time, not the lab's pedagogical content. A reasonable
  checkpoint already exists naturally: confirming the toolchain
  version before starting the actual experiment.
- **Lab 06**: the heaviest lab in this act for all three languages,
  since it's the one that turns a script into a real project
  structure. Java is the longest of the three, driven by Gradle's
  first-time distribution download (the lab's own text already warns
  "that can take a minute or two") plus more required ceremony
  (two nested static types, a `build.gradle` dependency block) than
  Python or Go need. A natural mid-lab checkpoint: once the refactored
  entry point's output matches the baseline diff, before moving on to
  anything else.
- **Lab 09**: Java is again the longest, because it introduces two new
  Gradle plugins and a hand-written PMD ruleset file in the same lab,
  where Python and Go each only reach for tools already on their
  toolchain. Not a reason to cut Java's scope — PMD and Spotless are
  the real, idiomatic tools for this job in Java — but worth knowing
  if scheduling Lab 06 and Lab 09 back-to-back for the Java track in
  one sitting.
- **Labs 07, 08, 10**: comfortably under 90 minutes for all three
  languages; mechanically repetitive after the first worked example in
  each, which keeps cognitive load (not just typing) low.
- **Resuming after a week's break**: every lab under this act ends
  with an explicit "commit and push everything from this lab"
  instruction (Labs 06-10) or produces a committed notes file (Labs
  01-04), so a student resuming after a break has a real, inspectable
  checkpoint to re-orient from (`git log`, the last notes file, or the
  starter's current state) rather than having to remember where they
  left off from memory.

## Tests actually performed in this pass

- `./scripts/check-course.sh` — run twice after all fixes, both green,
  clean working tree before and after both runs.
- `python3 scripts/check_course_structure.py` — green after every
  batch of edits, including one self-caught parity regression (see
  above).
- Full, independent, from-the-published-starter-only implementation of
  Labs 06-10 for Python, Go, and Java in disposable scratch copies —
  not against any private reference solution.
- Lab 05's Python track executed step by step in a disposable scratch
  copy.
- Lab 02's Bash-only long-running-process experiment and the full
  Labs 01-04 command sequence (clone into a path containing a space,
  `mkdir`/`cp`/`mv`/`grep`/`find`, `git status`/`remote -v`/`branch`)
  were already exercised for real on a genuine Windows GitHub Actions
  runner in PR I (`windows-smoke-test` job) — not re-run here, since
  nothing in Labs 01-02's content changed in this pass.

## NOT INDEPENDENTLY VERIFIED

- **A real Windows 11 + Git Bash walkthrough of Labs 03-10** — the
  `python3`/`python` naming fix in Labs 05-06 is reasoned from Windows'
  documented Python installer behavior (it does not ship a `python3`
  alias), not executed on a real Windows machine. PR I's Windows CI
  smoke test covers Labs 01-04's shared command sequence, not Labs
  05-10's language-specific content.
- **Lab 05's Go and Java toolchain-mismatch experiments**, in this
  specific pass — not re-executed here; last executed fresh in PR H
  (see `final-course-audit.md`), and nothing in their instructions
  changed in this PR.
- **The 90-minute timebox assessment above** is a reasoned estimate
  from reading the lab content and this session's own walkthrough
  timings, not a measurement from real students; it should not be
  cited as pilot data.
- **This report is not a substitute for a real student pilot.** It
  reflects one maintainer's hands-on technical walkthrough and full
  read of all 20 required documents, not observed classroom behavior.

## Scope discipline confirmed

- No change to Labs 11-30 beyond confirming (not editing) that Lab
  11's "Before you start" doesn't assume anything Lab 10 doesn't
  actually produce.
- No change to Option D's architecture, no new Restaurant Bill
  features, no new frameworks, no `uv`/Go/Java/GitHub Actions version
  bumps, no Course Health rewrite, no FULLY SUPPORTED status change,
  no release.
- Every fix in this PR is a documentation correction (lab instructions,
  troubleshooting guidance) — no starter source file under `examples/`
  was modified, since no technical bug was found in any starter itself.
- No tracked `decisions/`, no AI attribution, no `Co-authored-by`,
  clean working tree confirmed by two green `check-course.sh` runs.
