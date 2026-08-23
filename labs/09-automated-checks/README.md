# Lab 09 — Machines can check boring things

## Story

Your last code review took ten minutes to converge on: tabs versus
spaces, an unused import, and whether a string should use single or
double quotes. None of that was about whether the code was *correct* —
your tests already answer that question. It's still wasting review time.

## Learning objectives

After this lab you should be able to:

- Distinguish what a formatter checks from what a linter checks, and
  both from what a test checks.
- Add and configure a dev-only tool dependency in `pyproject.toml`.
- Run Ruff to format and lint a project, and read its output.

## Before you start

- Lab 08 complete: `uv run pytest` passes with the tax bug fixed.
- Current directory: `examples/restaurant-bill/`.

## Your task

1. Add `ruff` as a dev dependency in `pyproject.toml` (alongside
   `pytest`), then run `uv sync`.
2. Add a `[tool.ruff]` section to `pyproject.toml` with
   `target-version = "py313"` and `line-length = 100`.
3. Run `uv run ruff format --check .` — this tells you whether your
   files are already formatted the way Ruff would format them, without
   changing anything.
4. Run `uv run ruff check .` — this looks for actual code issues
   (unused imports, unused variables, and similar), which is a different
   question from formatting.
5. Temporarily add an unused import (for example, `import math`) to the
   top of `billing/calculator.py`. Run `uv run ruff check .` again and
   read the specific rule it reports. Remove the import once you've seen
   the message.
6. Fix anything real that either command reported about your own code
   from Labs 06-08.

## Acceptance criteria

- `pyproject.toml` lists `ruff` as a dev dependency and has a
  `[tool.ruff]` section.
- `uv run ruff format --check .` reports no files needing changes.
- `uv run ruff check .` reports no issues.

## Verification

```bash
cd examples/restaurant-bill
uv run ruff format --check .
uv run ruff check .
uv run pytest
cd -
```

Expected: both Ruff commands report nothing to fix, and `pytest` still
passes — none of this changed behavior.

## Think about it

- Which of the three tools you've now used on this project (`pytest`,
  `ruff format`, `ruff check`) could, in principle, tell you your code
  is "correct"? Which ones can only tell you it's "consistent" or
  "free of obvious mistakes"?
- Why run the formatter and the linter as two separate commands instead
  of one?

## If you get stuck

- **Hint 1:** `uv add --dev ruff` adds the dependency for you instead of
  hand-editing `pyproject.toml`, if you'd rather not edit TOML by hand.
- **Hint 2:** `ruff format` rewrites files to match its style; `ruff
  format --check` only reports what *would* change, without touching
  anything — use `--check` first.
- **Hint 3:** If `ruff check .` reports nothing at all on your own code,
  that's a valid outcome, not a sign you did something wrong — it means
  your Lab 06-08 code was already clean.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Nothing later assumes
a clean tree yet, but Act IV (starting at Lab 16) does — get in the
habit now.

## What's next

You now have three different kinds of automated feedback: tests,
formatting, and linting. Right now you have to remember three different
commands, in the right order, every single time. Next, you'll give
yourself — and everyone after you — exactly one way to run them.

Continue to [Lab 10 — One obvious way to check the project](../10-one-way-to-check/README.md).
