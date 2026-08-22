# Lab 03 — You inherited a repository

## Story

You've been handed access to this very repository. Before you change
anything, you need to know how to see what state it's in, and how to
record a change of your own without losing anything.

## Learning objectives

After this lab you should be able to:

- Explain the difference between the working directory, the staging area,
  and the local repository.
- Inspect the current state of a repository with `git status`, `git log`,
  and `git diff`.
- Stage and commit a change with a clear message.

## Before you start

- Lab 02 complete.
- You are inside a clone of this repository (Codespaces already gives you
  one; locally, use the `git clone` command from the root
  [`README.md`](../../README.md)).
- Current directory: the repository root.

## Your task

1. Run `git status` and `git log` in the repository root. Read the output
   before doing anything else.
2. Create a new file `labs/03-inherited-repository/notes/my-observations.txt`
   containing at least two sentences: one describing what `git status`
   showed you, one describing what `git log` showed you.
3. Run `git status` again and explain, in your own words (write it in the
   same file, as a third line), why the new file shows up the way it does.
4. Stage only that file with `git add`.
5. Run `git diff --staged` and observe what it shows compared to plain
   `git diff`.
6. Commit the staged change with a clear, English, present-tense message,
   e.g. `docs: add lab 03 observations`.
7. Run `git log` once more and confirm your commit appears at the top.

## Acceptance criteria

- `labs/03-inherited-repository/notes/my-observations.txt` exists, is
  committed, and contains at least three lines as described above.
- `git log` shows your commit with a clear message, in English.
- You can explain, without re-reading Git docs, what "staged" means.

## Verification

```bash
git log --oneline -1                      # your commit should be at HEAD
git status                                 # should be clean (nothing to commit)
test -f labs/03-inherited-repository/notes/my-observations.txt && echo "notes exist"
wc -l < labs/03-inherited-repository/notes/my-observations.txt  # expect >= 3
```

## Think about it

- `git diff` and `git diff --staged` showed different things. Why does Git
  distinguish between these two states at all?
- If you had run `git commit` without `git add` first, what would have
  happened to your new file?

## If you get stuck

- **Hint 1:** You need exactly five Git commands here: `status`, `log`,
  `diff`, `add`, `commit`.
- **Hint 2:** `git diff` (no arguments) shows unstaged changes; `git diff
  --staged` shows what will actually go into the next commit.
- **Hint 3:** A commit needs a message. Use `git commit -m "your message
  here"` rather than opening an editor, unless you're comfortable with one.

## What's next

Your commit exists — but only on this machine, in this local repository.
Nobody else can see it yet. Next you'll find out what "remote" actually
means.

Continue to [Lab 04 — Local is not remote](../04-local-vs-remote/README.md).
