# Lab 05 — "It works on my machine"

## Story

A teammate sends you `main.py` from this folder and says "just run it, it
prints a nice message." You try `python3 main.py`. It crashes. Their
machine and yours are apparently not the same machine.

## Learning objectives

After this lab you should be able to:

- Explain why "it runs for me" is not evidence that a program is correctly
  packaged.
- Use `uv` to create a reproducible Python environment from a project
  manifest.
- Explain what `pyproject.toml` and `uv.lock` are each responsible for.
- Explain, at a high level, what the devcontainer configuration in this
  repository is for.

## Before you start

- Lab 04 complete.
- Current directory: `labs/05-works-on-my-machine/` for all commands
  below, unless stated otherwise.
- `uv` installed. If you're in this repository's Codespace/devcontainer,
  it's already set up (see the root [`README.md`](../../README.md)). If
  you don't have it yet, install it with:
  `curl -LsSf https://astral.sh/uv/install.sh | sh`

## Your task

1. Without installing anything, try: `python3 main.py`. Read the error.
2. Open `pyproject.toml` and identify which package the project actually
   depends on.
3. Run `uv sync`. Look at what appeared in this directory afterward.
4. Run `uv run python main.py`. Compare this result with step 1.
5. Run `uv run pytest` and confirm the test suite passes.
6. In a new file `labs/05-works-on-my-machine/notes/my-observations.txt`,
   write, in your own words: (a) why step 1 failed, (b) what `uv sync`
   created and why, (c) what would happen to a teammate who only ran
   `python3 main.py` on their own machine without ever running `uv sync`.
7. Open `.devcontainer/devcontainer.json` at the repository root and find
   the line that provisions Python. Add one more sentence to your notes
   file: what tool provisions Go and Java in this same file?

## Acceptance criteria

- `uv run pytest` passes inside `labs/05-works-on-my-machine/`.
- `.venv/` and `uv.lock` exist in that directory (uv created them; do not
  hand-write either).
- `uv.lock`, created by `uv sync` (not shipped with the starter), is
  committed to the repository — a lock file is only useful to a
  teammate if it's actually checked in.
- `notes/my-observations.txt` answers all three points from step 6, plus
  the devcontainer question from step 7.

## Verification

```bash
cd labs/05-works-on-my-machine
uv run pytest
test -f uv.lock && echo "lock file exists"
test -d .venv && echo "virtualenv exists"
test -f notes/my-observations.txt && echo "notes exist"
cd -
```

## Think about it

- `uv.lock` pins exact versions; `pyproject.toml` states a version range.
  Why do you need both instead of just one?
- If two teammates run `uv sync` on the same `pyproject.toml` +
  `uv.lock` on different operating systems, should they end up with the
  same dependency versions? Why?
- The devcontainer configuration provisions Python, Go, and Java
  system-wide, but this lab still uses `uv` for Python dependencies
  specifically. What's the difference between "the language runtime is
  available" and "this project's dependencies are reproducible"?

## If you get stuck

- **Hint 1:** The whole lab is three commands: `uv sync`, `uv run python
  main.py`, `uv run pytest`. Everything else is reading and writing notes.
- **Hint 2:** If `python3 main.py` "just works" for you without `uv sync`,
  it's because `cowsay` happens to already be installed globally on your
  machine — that's exactly the trap this lab is about. Try it in a
  completely fresh Codespace to see the failure for real.
- **Hint 3:** `uv run <command>` runs `<command>` inside the project's own
  managed environment, without you needing to manually activate anything.

Before moving on: commit and push everything from this lab, `uv.lock`
included (`git add -A && git commit -m "..."; git push`). Nothing later
assumes a clean tree yet, but Act IV (starting at Lab 16) does — get in
the habit now.

## What's next

You now have one small, reproducible project. Real projects, though, don't
stay in a single file for long. Next, you'll deal with a script that has
grown past the point where "just one file" still works.

Continue to [Lab 06 — From script to project](../06-from-script-to-project/README.md).
