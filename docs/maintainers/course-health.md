# Maintaining Course Health

This is maintainer-facing documentation for `./scripts/check-course.sh`
and the scripts it calls. Students never need to read this to complete
a lab — it's for whoever adds, removes, or restructures an example
project in this repository.

## How to add a new project to the registry

`scripts/check-course.sh` has a `PROJECT_REGISTRY` array near the top.
Add one line per language variant your new project ships, in the
format `"checktype|relative/path"`. The comment above the array
explains each `checktype` (`py`, `py-unlocked`, `go`, `java-test`,
`java-run`, `java-javac`, `sh-smoke`) and when to use it.

If you add a project and forget to register it, you won't get a silent
pass: the script still discovers and runs it (via the same
`pyproject.toml`/`go.mod`/`gradlew` discovery it always used), but
prints a `WARN` telling you to add it to the registry. If you instead
*delete* a registered project (or its manifest) without updating the
registry, the script `FAIL`s — that's the actual point of the
registry: a project that's supposed to exist and silently stops
existing must break Course Health, not just stop appearing in the
output.

## How to choose the right check type

Ask what the project actually has, not what would look uniform next to
the others:

- Has a real test suite (`pytest`/`go test`/JUnit)? Use `py`, `go`, or
  `java-test`.
- Deliberately has no committed lockfile yet, because the lab's point
  is having the student create one (Lab 05)? Use `py-unlocked` — it's
  still discovered and run, just exempted from the "must have a
  committed `uv.lock`" rule, and run from a throwaway copy so the lock
  file `uv run` generates never lands in the tracked tree.
- Deliberately has no test suite at all, because the lab's point is
  the student adding the *first* one (Act II's restaurant-bill)? Use
  `sh-smoke` (Python/Go) or `java-run` (Java) — these run the program
  directly and grep its output for an expected line, instead of
  running a test command that doesn't exist.
- Has no Gradle Wrapper at all (the notifier example, which teaches
  `javac` directly)? Use `java-javac`.

Never invent a test, a lockfile, or a Gradle Wrapper for a project just
to make its registry entry look like the others. A project that's
deliberately incomplete should look registered-and-deliberately-
incomplete, not retrofitted.

## How to add a new HTTP contract requirement

`scripts/contract-tests/order-api/starter/check_contract.py` is the
*baseline* black-box HTTP contract — what every track's `order-api`
starter does **before Lab 21**. Add a new baseline check inside
`run_checks()`, following the existing pattern: make a real request
over a real socket, assert on status code and JSON body, raise
`ContractError` with a specific message on mismatch. Never import any
of the three servers' own code — this harness exists specifically to
test them the way an external HTTP client would, in any language.

If what you actually want to verify is *post-Lab* behavior (per-item
validation from Lab 21, SQLite from Lab 22, the `notes`/`priority`
migrations, retry, logging — anything a student adds during a lab),
that does **not** belong in this file. See the next section.

## Why the starter baseline doesn't cover later labs

Two different things are being verified, and conflating them breaks
the lesson:

- **Starter baseline** (`check_contract.py`, wired into
  `check-course.sh`): must pass on the committed `main` branch,
  forever, regardless of which lab a student is working on. It
  documents what the starter already does before the student touches
  it.
- **Post-lab acceptance**: what a *specific student's own solution*
  should do after finishing Lab 21, 22, 23, 24, or 25. This is
  necessarily a superset of the baseline (it includes things like
  per-item validation, SQLite persistence, and the `notes`/`priority`
  migrations) that doesn't exist in the public starter and must never
  be added there — adding it would ship the student's own exercise
  solved for them.

If you're verifying post-lab behavior (as a maintainer, auditing a
lab's instructions), do it against a disposable reference solution you
build yourself in a scratch directory, never against
`examples/order-api/<language>/` and never by extending
`check_contract.py`'s `TRACKS`/`run_checks()` to assume Lab 21+ exists.
A new, separate script for this is fine if you need one; it must never
be invoked by `check-course.sh`'s default run.

## How to run everything locally

```bash
./scripts/check-course.sh
```

This is exactly what CI runs — see `.github/workflows/course-health.yml`,
which only sets up toolchains (Python/uv, Go, JDK, Gradle Wrapper
validation) before calling this one script.

## How to run just one project or check

There's no single `--only <project>` flag, since the script is a
sequence of independent sections, not a test runner with discovery. To
check one thing in isolation:

- Structural checks only: `python3 scripts/check_course_structure.py`.
- One Python project: `cd examples/<project>/python && uv run pytest -v`.
- One Go project: `cd examples/<project>/go && go test ./...`.
- One Java project: `cd examples/<project>/java && ./gradlew test`.
- The HTTP contract baseline, one track at a time:
  `python3 scripts/contract-tests/order-api/starter/check_contract.py --track go`
  (or `--track python` / `--track java`).

## What a skipped maintainer job on a fork means

`.github/workflows/course-health.yml`'s `course-health` job only runs
when `github.repository == 'michalmaj/software-engineering-in-practice'`
— on a student's personal fork, this job is skipped entirely (not
failed, not hidden — GitHub shows it as skipped). This is deliberate:
if a student's fork got a fully working, pre-built CI badge for free,
it would quietly undermine Lab 19, where building that CI workflow
*is* the lesson. A pull request opened **from** a fork **into** this
canonical repository still runs the job normally — `github.repository`
reflects the workflow's own repository, not the pull request's head
repository.

## How to diagnose a CI failure safely

- Read the `FAIL` lines in the job's log first — each one names the
  specific project/check and includes enough context (a file, a
  status-code mismatch, a syntax error location) to reproduce it
  locally with the single-project commands above, without re-reading
  this script.
- Reproduce locally before changing anything — CI and
  `./scripts/check-course.sh` run the identical logic, so a failure
  that doesn't reproduce locally is almost always an environment
  difference (toolchain version, a leftover local artifact), not a
  flaky check.
- Never respond to a red check by disabling the check, widening a
  timeout past what's needed to fix flakiness, or adding `--no-verify`/
  skip flags — fix the underlying project or script issue, or, if the
  check itself is wrong, fix the check and show your reasoning in the
  PR, the same standard this repository asks of students in Lab 19.
- Gradle-specific: this repository's scripts isolate their own
  `GRADLE_USER_HOME` from your personal one when run outside CI (see
  the comment above `run_gradle_wrapper` in `check-course.sh`), so a
  local run's `./gradlew --stop` never touches a Gradle daemon you have
  running for unrelated work. In CI, the default Gradle user home is
  used as-is, since `gradle/actions/setup-gradle@v6` already caches it
  in that fresh, disposable VM.
