# Lab 19 — The repository should check itself

## Story

A change merged last week broke the test suite on `main` — the author
forgot to run the tests before merging, and the reviewer trusted the PR
description instead of actually running anything. Nobody noticed until
someone ran the program by hand and it crashed.

## Learning objectives

After this lab you should be able to:

- Write a minimal GitHub Actions workflow that runs on every push and
  pull request.
- Explain what each step of a CI workflow does, without treating YAML
  as magic.
- Use a red/green CI check as evidence, instead of trusting a
  description.

## Before you start

- Lab 18 complete: `main` has the reorder-report feature, merged
  through a real pull request, in your chosen track.
- Current directory: the repository root — the workflow file lives
  outside `examples/team-inventory/`, at `.github/workflows/`.
- If your repository is a fork, GitHub disables Actions workflows on it
  by default. Open your fork's **Actions** tab and click **"I understand
  my workflows, go ahead and enable them"** before this lab's workflow
  will run at all.
- This course's own canonical repository has a maintainer workflow,
  `.github/workflows/course-health.yml`, that checks the whole course.
  It's deliberately scoped to run only on the canonical repository, not
  on your fork — if you look at it, you'll see a condition checking the
  repository name, and on your fork, GitHub shows that job as
  **skipped**, not failed or missing. That's a different thing from
  what you're building here: your new workflow is yours, runs on your
  fork, and checks only `examples/team-inventory/<your-language>`.

## Your task

1. Create branch `feature/ci-pipeline` from `main`.
2. Create `.github/workflows/team-inventory-ci.yml` (create
   `.github/workflows/` if it doesn't exist) with the shared trigger
   below, plus your track's steps.

All three tracks share this trigger — put it at the top of the file:

```yaml
on: [push, pull_request]
```

### Python

```yaml
name: team-inventory CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7

      - uses: actions/setup-python@v7
        with:
          python-version: "3.13"

      - name: Install uv
        uses: astral-sh/setup-uv@v10.2.0
        with:
          version: "0.11.21"

      - name: Install dependencies
        working-directory: examples/team-inventory/python
        run: uv sync --locked

      - name: Run tests
        working-directory: examples/team-inventory/python
        run: uv run pytest
```

`uv sync --locked` fails the build instead of silently updating
`uv.lock` if it's ever out of sync with `pyproject.toml` — exactly the
kind of drift CI exists to catch. `3.13` and `0.11.21` match this
course's own baseline — see the root [`README.md`](../../README.md)'s
toolchain table, or the `.python-version` file at the repository root,
rather than any one editor's configuration.

### Go

```yaml
name: team-inventory CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7

      - uses: actions/setup-go@v7
        with:
          go-version: "1.27"

      - name: Run tests
        working-directory: examples/team-inventory/go
        run: go test ./...
```

`1.27` matches this course's own Go baseline — see the root
[`README.md`](../../README.md)'s toolchain table.

### Java

```yaml
name: team-inventory CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7

      - uses: actions/setup-java@v6
        with:
          distribution: temurin
          java-version: "21"

      - uses: gradle/actions/setup-gradle@v6

      - name: Run tests
        working-directory: examples/team-inventory/java
        run: ./gradlew test
```

`gradle/actions/setup-gradle@v6` validates your committed Gradle
Wrapper's checksum before `./gradlew` ever runs, and caches Gradle's
own downloads between runs — it does **not** install a global Gradle;
`./gradlew test` still runs through your committed wrapper, the same
as it does on your own machine.

## All tracks

3. Commit and push the branch, then open a pull request (as in
   Lab 18 — web UI first, double-checking the base repository and
   branch).
4. Open the PR's "Checks" tab and watch the workflow run. Confirm it
   goes green.
5. Deliberately break a test locally (change an assertion to something
   false), commit, and push. Watch the check go **red** on the PR.
   Then revert your deliberate breakage, push again, and watch it go
   green.
6. Merge the PR once it's green.

## Acceptance criteria

- `.github/workflows/team-inventory-ci.yml` exists, targets
  `examples/team-inventory/<your-language>`, and triggers on both push
  and pull request.
- You've personally observed the check both fail (red, for a real
  broken test) and pass (green) on an actual pull request.
- The final merged state on `main` is green.

## Verification

There's no local command that replaces "watch it run on GitHub" — that
observation *is* the point of this lab. Locally, you can only replicate
what the workflow will do:

### Python

```bash
cd examples/team-inventory/python
uv sync --locked
uv run pytest
cd -
```

### Go

```bash
cd examples/team-inventory/go
go test ./...
cd -
```

### Java

```bash
cd examples/team-inventory/java
./gradlew test
cd -
```

If this passes locally and your workflow YAML runs the same commands
in the same directory, the PR check will match.

## Think about it

- In Lab 18, a reviewer could have skipped running your tests and just
  trusted the PR description. What changed once the workflow existed —
  who, or what, is now responsible for catching an untested change?
- The workflow runs the exact same commands you've been running by
  hand for several labs. What did automating them buy you, if the
  commands themselves didn't change?

## If you get stuck

### Python

- **Hint 1:** A minimal workflow needs `on:`, a `jobs:` section with at
  least one job, and a `steps:` list — checkout, Python setup, `uv`
  install, `uv sync --locked`, `uv run pytest`. The version shown above
  is the one actually verified for this course.
- **Hint 2:** Use `working-directory: examples/team-inventory/python`
  on the steps that run `uv sync --locked`/`uv run pytest`, since the
  workflow's default working directory is the repository root.
- **Hint 3:** If `uv sync --locked` fails in CI but `uv sync` works
  locally, your `uv.lock` is out of date — run `uv lock` locally,
  commit the updated lock file, and push again.

### Go

- **Hint 1:** A minimal workflow needs `on:`, a `jobs:` section with at
  least one job, and a `steps:` list — checkout, Go setup, `go test
  ./...`. There's no install/sync step the way Python needs one — Go's
  module system resolves dependencies as part of `go test` itself.
- **Hint 2:** Use `working-directory: examples/team-inventory/go` on
  the test step, since the workflow's default working directory is the
  repository root.
- **Hint 3:** If the workflow can't find your package, double-check
  `go.mod` is actually committed — an untracked `go.mod` works on your
  machine but doesn't exist from the workflow's point of view.

### Java

- **Hint 1:** A minimal workflow needs `on:`, a `jobs:` section with at
  least one job, and a `steps:` list — checkout, JDK setup,
  `setup-gradle`, `./gradlew test`.
- **Hint 2:** Use `working-directory: examples/team-inventory/java` on
  the test step, since the workflow's default working directory is the
  repository root.
- **Hint 3:** If the workflow reports `gradlew: Permission denied`,
  your committed `gradlew` file lost its executable bit somewhere —
  `chmod +x examples/team-inventory/java/gradlew`, commit the mode
  change, and push again.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Nothing later assumes
a clean tree yet, but Act IV (starting at Lab 16) does — get in the
habit now.

## What's next

You have tests, review, and CI. Given all of that, when is a change
"done"?

Continue to [Lab 20 — What does "done" mean?](../20-definition-of-done/README.md).
