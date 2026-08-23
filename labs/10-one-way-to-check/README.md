# Lab 10 — One obvious way to check the project

## Story

A new contributor asks: "how do I run the tests again? And was it
`ruff check` or `ruff format` first?" You've typed these commands so
many times you don't think about them anymore — which is exactly why a
newcomer shouldn't have to ask.

## Learning objectives

After this lab you should be able to:

- Wrap a sequence of commands in a small, readable shell script.
- Explain why a project-level script is preferable to a README
  instruction the reader has to copy by hand.
- Explain what "no hidden magic" means for automation you write
  yourself.

## Before you start

- Lab 09 complete: `uv run pytest`, `uv run ruff format --check .`, and
  `uv run ruff check .` all succeed.
- Current directory: `examples/restaurant-bill/`.

## Your task

Create a `scripts/` directory with four executable shell scripts, each
runnable from anywhere (they should `cd` to the project root themselves):

1. `scripts/test.sh` — runs the test suite.
2. `scripts/check.sh` — runs the formatter check and the linter (in that
   order), then the test suite.
3. `scripts/format.sh` — actually reformats the code (not just
   `--check`).
4. `scripts/run.sh` — runs the application.

Make all four executable (`chmod +x`). Each script should be short
enough that reading it, top to bottom, tells you exactly what it does —
no separate documentation should be required to understand one.

## Acceptance criteria

- All four scripts exist, are executable, and work when invoked from a
  different starting directory (e.g. your home directory).
- `scripts/check.sh` fails (non-zero exit code) if formatting, linting,
  or tests fail — a newcomer should see one clear failure, not silently
  continue.
- Reading any one script takes less than thirty seconds to understand.

## Verification

```bash
cd ~
/path/to/examples/restaurant-bill/scripts/test.sh
/path/to/examples/restaurant-bill/scripts/check.sh
/path/to/examples/restaurant-bill/scripts/run.sh
cd -
```

(Replace `/path/to/` with your actual repository path.) Expected: all
three complete successfully with no manual `cd` on your part.

## Think about it

- What would happen to `scripts/check.sh` if one of its three commands
  failed partway through, and the script didn't stop immediately? What
  line in your script prevents that?
- Is there anything about what these scripts do that isn't visible just
  by reading them? If a teammate asked "what does `check.sh` actually
  run," could you just show them the file?

## If you get stuck

- **Hint 1:** Start every script with `#!/usr/bin/env bash` and `set
  -euo pipefail` — the second line stops the script immediately on the
  first failing command.
- **Hint 2:** To make a script work regardless of the caller's current
  directory, put `cd "$(dirname "$0")/.."` near the top, right after
  `set -euo pipefail`.
- **Hint 3:** `chmod +x scripts/*.sh` makes all four executable at once.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Nothing later assumes
a clean tree yet, but Act IV (starting at Lab 16) does — get in the
habit now.

## What's next

You've taken one script and turned it into a small, well-tested,
consistently-checked project. Act II is done. Next, the project itself
will have to survive an actual change in requirements — which is where
design starts to matter.

Continue to [Lab 11 — The client changed their mind](../11-changed-requirements/README.md).
