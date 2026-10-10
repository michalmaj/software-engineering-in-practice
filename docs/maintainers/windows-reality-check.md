# Windows reality check (PR I)

This is a follow-up to [`final-course-audit.md`](final-course-audit.md)'s
disclosed gap: the Windows Chocolatey-ordering and `bash.exe`-location
fixes from PR H were reasoned from Git for Windows' and Chocolatey's own
documented behavior, but never executed on a real Windows machine. This
pass closes part of that gap with a real, automated run on a real Windows
GitHub Actions runner — and is explicit about the part it still cannot
close, because no GitHub-hosted runner has a desktop session.

## What "GitHub Actions Windows" can and can't prove

`windows-latest` is a Windows Server VM with no interactive desktop
session. It can genuinely execute PowerShell and Git Bash commands and
check their real output — that's not a simulation — but it cannot click
"Run as administrator," show a UAC prompt, open VS Code's actual window,
or confirm an item appears in a GUI menu. Those stay **NOT INDEPENDENTLY
VERIFIED** below until a person does them on a real Windows 11 machine.

## Results matrix

| Scenario | GitHub Actions Windows | Real Windows 11 |
|---|---|---|
| `git --version` / `git.exe` path resolution | PASS (`windows-smoke-test` job, run [38022918619](https://github.com/michalmaj/software-engineering-in-practice/actions/runs/38022918619)) | not independently verified |
| `bash.exe` location via the `Join-Path`/`Split-Path` formula in `docs/setup/windows.md` | PASS — resolved to a real file on the runner | not independently verified |
| Git Bash actually starts (`$BASH_VERSION` is set) | PASS | not independently verified |
| Labs 01-04 command sequence (`mkdir`/`cp`/`mv`/`grep`/`find`/`wc -l`) under Git Bash | PASS | not independently verified |
| Clone into a path containing a space; `git status` / `git remote -v` / `git branch` | PASS | not independently verified |
| `check-environment.sh` under Git Bash | ran; reported `MISMATCH`/`MISSING` for Python/Go/Java as expected, since this runner only has Git preinstalled — exit 1 tolerated via `continue-on-error`, informational only | not independently verified |
| Chocolatey install ordering (Part 2-3: Git + VS Code from the same admin window) | not performed — this job does not install any toolchain, by design (narrow smoke test, not a fresh-machine install) | not independently verified |
| Chocolatey behavior when already installed | not performed | not independently verified |
| Official (non-Chocolatey) installers for a no-admin-rights student | not performed — no admin-restricted account exists on this runner to test against | not independently verified |
| "Run as administrator" / UAC prompt appearance | not performable on any GitHub-hosted runner — no desktop session | not independently verified |
| Git Bash appearing in VS Code's terminal-profile dropdown | not performable — no GUI on this runner | not independently verified |
| `Terminal: Select Default Profile` / `settings.json` GUI flow | not performable — no GUI on this runner | not independently verified |
| Fork/clone (GitHub web UI → local clone) | partially exercised: cloning itself is PASS (above); the Fork-button/GitHub-UI step needs a real account and browser, not performed here or on any runner | not independently verified |
| Labs 01-05 present, bilingual, and reachable from a fresh clone | PASS — verified via a disposable local clone (see below); all five labs' `README.md`/`README.pl.md` exist and the shared Labs 01-04 command sequence succeeds | not independently verified |

**Never read a "not independently verified" row as a failure** — it
means exactly that: nobody has yet performed that specific step on a
real Windows 11 machine with a GUI. The GitHub Actions column is real,
executed evidence; it is just narrower in scope than the full page.

## What this pass additionally did (outside CI)

- **Numbering/cross-reference audit** of `docs/setup/windows.md` and
  `windows.pl.md`: PR H's Part 7→6 renumbering had left the nested
  `### 7.1`–`7.5` subsection headings and five inline cross-references
  in each file still at the old numbers, plus one cross-reference that
  pointed at the wrong part entirely ("set that in Part 6" should have
  said "Part 5" — the Git-Bash-default-terminal step). All fixed in
  both languages; the Polish file's own equivalent references were
  checked and were already correct (Polish's inflected "Części 5" etc.
  never had the English file's bug).
- Two stale anchors in `already-have-a-fork.md`/`.pl.md` still pointed
  at `windows.md`'s old `#7.3` anchor after the renumbering; fixed to
  `#6.3`.
- Full read of `START-HERE.md`/`.pl.md`, `troubleshooting.md`/`.pl.md`,
  `already-have-a-fork.md`/`.pl.md`, and `github-auth.md`/`.pl.md` —
  no further command, privilege-ordering, or cross-reference bugs
  found beyond the two Polish typos below.
- Two unrelated Polish typos in `START-HERE.pl.md`: "Coś pójło nie tak"
  → "Coś poszło nie tak", and a stray parenthesis in "Woli(sz)" →
  "Wolisz".
- Re-read `docs/setup/windows.md`'s Chocolatey-already-installed
  handling (Part 2, step 2: checks `choco --version` first and skips
  ahead if already present), the no-admin-rights fallback (official
  installers, VS Code's User Installer specifically called out as not
  needing admin rights), and the Git-Bash-in-VS-Code manual
  configuration instructions (the `settings.json` snippet, and the
  `Join-Path`/`Split-Path` command for locating `bash.exe`) against
  Git for Windows' and VS Code's actual, current behavior. No further
  bugs found — these were already correct as of PR H's fixes.
- Replayed the clone-into-a-space-path step and the Labs 01-04 command
  sequence locally in a disposable scratch directory (not a real fork,
  no destructive Git commands) as a second, independent check of the
  same logic the CI job exercises — matched.

## Still NOT INDEPENDENTLY VERIFIED after this pass

- A real "Run as administrator" click and the UAC prompt's actual
  appearance on a real Windows 11 machine.
- A genuinely fresh Chocolatey install (`choco` not already present)
  on a locked-down or standard-privilege account, including the
  official non-Chocolatey installer fallback path.
- Git Bash actually appearing in VS Code's terminal-profile dropdown,
  and the `Terminal: Select Default Profile` menu flow, in a real GUI.
- The Fork button / GitHub web UI step of forking this repository,
  under a real student GitHub account.
- A human following `docs/setup/windows.md` cold, start to finish,
  without prior knowledge of what the page says.

These require a real Windows 11 machine with a GUI and should be
spot-checked by someone before the next cohort starts, the same
recommendation PR H's audit made — this pass narrows but does not
close that gap.
