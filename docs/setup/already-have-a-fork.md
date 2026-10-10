# Already have a fork or a local copy?

[Po polsku →](already-have-a-fork.pl.md) · [← Back to Start here](../../START-HERE.md)

If you already forked this repository, already cloned it, or started
this setup once before and aren't sure what state you're in, this page
helps you figure that out safely. Nothing here deletes anything —
if a step would require deleting or overwriting your own work, it
tells you to stop and ask instead.

## "I forked it on GitHub, but I don't know if I cloned it"

1. Open [github.com](https://github.com) in your browser, click your
   avatar (top right), click **Your repositories**.
2. Look for `software-engineering-in-practice` in the list. If it's
   there, you already forked it — don't fork it again.
3. On your computer, check whether you also already cloned it: open a
   terminal and run
   ```bash
   find ~ -maxdepth 4 -iname "software-engineering-in-practice" -type d 2>/dev/null
   ```
   If this prints a path, you have a local copy already — go to
   "I have a local copy already" below. If it prints nothing, you
   haven't cloned it yet — go to the "Clone your fork" step in your
   system's guide ([Windows](windows.md#63--clone-it-onto-your-computer),
   [macOS](macos.md#63--clone-it-onto-your-computer),
   [Linux](linux.md#63--clone-it-onto-your-computer)).

## "I have a local copy already"

1. Open a terminal (or the one inside VS Code) and go to the folder the
   `find` command above printed, for example:
   ```bash
   cd ~/projects/software-engineering-in-practice
   ```
2. Check that it's actually a Git repository pointing at your own fork:
   ```bash
   git remote -v
   ```
   **If this shows your own GitHub username:** good, this is your
   working copy — go to "Opening it again" below.

   **If this shows `michalmaj` instead of your username:** this is a
   clone of the instructor's original repository, not your fork. Don't
   delete it — rename it out of the way instead, then clone your actual
   fork fresh:
   ```bash
   cd ..
   mv software-engineering-in-practice software-engineering-in-practice.instructor-copy
   ```
   Then follow the "Clone your fork" step in your system's guide.

3. Check whether you have unsaved changes sitting in this copy:
   ```bash
   git status
   ```
   - `nothing to commit, working tree clean` — nothing unsaved, safe to
     continue.
   - Any other output (modified files, untracked files) — **don't
     discard these**. If you don't remember making the change on
     purpose and you're unsure whether it matters, that's fine — leave
     it as-is for now and keep going; you can ask your instructor about
     it later. Never run a command that discards changes (see
     [What never to do here](#what-never-to-do-here) below) just to
     make this message go away.

## Opening it again

1. Open VS Code.
2. **File → Open Folder…**, navigate to the folder from the step above.
3. Open a terminal inside VS Code (**Terminal → New Terminal**) and
   confirm:
   ```bash
   pwd
   git status
   ```
   **How you know you're in the right place:** `pwd` ends in
   `/software-engineering-in-practice`, and `git status` runs without
   an error.

## "My fork looks out of date compared to the course repository"

This can happen if the instructor has pushed updates since you forked.
You don't need this to start Lab 01 — it only matters once a specific
lab tells you to sync. When a lab does ask you to sync your fork, use
GitHub's own safe sync feature rather than any manual Git surgery:

1. On your fork's page on GitHub, look for a **Sync fork** button
   (GitHub shows this automatically when your fork is behind).
2. Click it, then **Update branch**.
3. Back in your terminal, update your local copy to match:
   ```bash
   git pull
   ```

If `git pull` reports a conflict, stop and ask your instructor rather
than guessing — don't resolve it with any of the commands listed below.

## What never to do here

None of these commands should ever be run as part of "fixing" a setup
problem in this course, because every one of them can permanently
destroy work you haven't pushed anywhere else:

- `git reset --hard`
- `git clean -fd` (or `-fdx`)
- `rm -rf` on your repository folder
- `git push --force` / `git push -f`

If a situation seems to call for one of these, it doesn't — stop and
ask your instructor instead, describing what you see (see the shared
[`troubleshooting.md`](troubleshooting.md) for how to report a
problem).

## Still not sure what state you're in?

See the shared [`troubleshooting.md`](troubleshooting.md), or go back
to [Start here](../../START-HERE.md) and follow your system's guide
from the top — re-reading it costs you a few minutes; guessing at a
fix risks your work.
