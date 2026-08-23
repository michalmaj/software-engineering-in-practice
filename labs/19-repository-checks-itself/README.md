# Lab 19 — The repository should check itself

## Story

A change merged last week broke `uv run pytest` on `main` — the author
forgot to run the tests before merging, and the reviewer trusted the PR
description instead of actually running anything. Nobody noticed until
someone ran the script by hand and it crashed.

## Learning objectives

After this lab you should be able to:

- Write a minimal GitHub Actions workflow that runs on every push and
  pull request.
- Explain what each step of a CI workflow does, without treating YAML
  as magic.
- Use a red/green CI check as evidence, instead of trusting a
  description.

## Before you start

- Lab 18 complete: `main` has `reorder_report`, merged through a real
  pull request.
- Current directory: the repository root (the workflow file lives
  outside `examples/team-inventory/`, at `.github/workflows/`).
- If your repository is a fork, GitHub disables Actions workflows on it
  by default. Open your fork's **Actions** tab and click **"I understand
  my workflows, go ahead and enable them"** before this lab's workflow
  will run at all.

## Your task

1. Create branch `feature/ci-pipeline` from `main`.
2. Create `.github/workflows/team-inventory-ci.yml` (create
   `.github/workflows/` if it doesn't exist) that:
   - triggers `on: [push, pull_request]`
   - checks out the repository
   - sets up Python 3.13
   - installs `uv`, pinned to `0.11.21` (matching the devcontainer and
     your local setup) via the `astral-sh/setup-uv` action, rather than
     whatever the unpinned install script would resolve to that day
   - runs `uv sync --locked`, then `uv run pytest`, both with a working
     directory of `examples/team-inventory` (`--locked` fails the build
     instead of silently updating `uv.lock` if it's ever out of sync
     with `pyproject.toml` — exactly the kind of drift CI exists to
     catch)
3. Commit and push the branch, then open a pull request (as in
   Lab 18).
4. Open the PR's "Checks" tab and watch the workflow run. Confirm it
   goes green.
5. Deliberately break a test locally (change an assertion to something
   false), commit, and push. Watch the check go **red** on the PR.
   Then revert your deliberate breakage, push again, and watch it go
   green.
6. Merge the PR once it's green.

## Acceptance criteria

- `.github/workflows/team-inventory-ci.yml` exists, targets
  `examples/team-inventory`, and triggers on both push and pull
  request.
- You've personally observed the check both fail (red, for a real
  broken test) and pass (green) on an actual pull request.
- The final merged state on `main` is green.

## Verification

There's no local command that replaces "watch it run on GitHub" — that
observation *is* the point of this lab. Locally, you can only replicate
what the workflow will do:

```bash
cd examples/team-inventory
uv sync --locked
uv run pytest
cd -
```

If this passes locally and your workflow YAML runs the same two
commands in the same directory, the PR check will match.

## Think about it

- In Lab 18, a reviewer could have skipped actually running your tests
  and just trusted the PR description. What changed once the workflow
  existed — who, or what, is now actually responsible for catching an
  untested change?
- The workflow runs the exact same commands you've been running by
  hand for several labs. What did automating them actually buy you,
  if the commands themselves didn't change?

## If you get stuck

- **Hint 1:** A minimal workflow needs `on:`, a `jobs:` section with at
  least one job, and a `steps:` list — checkout, Python setup, `uv`
  install, `uv sync --locked`, `uv run pytest`. If you're stuck on the
  YAML itself rather than what the workflow needs to *do*, here's a
  skeleton — fill in the blanks, don't just copy it:
  ```yaml
  name: team-inventory CI

  on: [push, pull_request]

  jobs:
    test:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: actions/setup-python@v5
          with:
            python-version: "___"   # match .devcontainer/devcontainer.json
        - name: Install uv
          uses: astral-sh/setup-uv@v10.0.1
          with:
            version: "0.11.21"
        - name: ___
          working-directory: examples/team-inventory
          run: ___                   # the dependency-install command
        - name: ___
          working-directory: examples/team-inventory
          run: ___                   # the test command
  ```
- **Hint 2:** Use `working-directory: examples/team-inventory` on the
  steps that run `uv sync --locked`/`uv run pytest`, since the
  workflow's default working directory is the repository root.
- **Hint 3:** Check `.devcontainer/devcontainer.json` at the repository
  root for the Python version this repo targets, and match it in
  `setup-python`.

## What's next

You have tests, review, and CI. Given all of that, when exactly is a
change actually "done"?

Continue to [Lab 20 — What does "done" mean?](../20-definition-of-done/README.md).
