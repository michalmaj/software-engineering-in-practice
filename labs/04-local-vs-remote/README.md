# Lab 04 — Local is not remote

## Story

Your commit from Lab 03 is sitting safely in your local repository. A
teammate asks you: "did you push that?" You realize you're not actually
sure what that question means yet.

## Learning objectives

After this lab you should be able to:

- Explain the difference between your working tree, your local repository,
  and a remote repository.
- Inspect which remote(s) your local repository is configured with.
- Publish a local commit to a remote with `git push`, and fetch others'
  work with `git pull`.
- Explain that Git (the tool) and GitHub (a hosting service for Git
  repositories) are not the same thing.

## Before you start

- Lab 03 complete — you have at least one local commit.
- Your repository has a configured remote (Codespaces and a normal `git
  clone` both set this up automatically).
- Current directory: the repository root.
- If `git remote -v` shows a URL that is *not* your own fork (it points
  to the original course repository instead), stop here — go back to
  the root [`README.md`](../../README.md)'s fork instructions before
  continuing. Pushing to a repository you don't own will fail with a
  permissions error.

## Your task

1. Run `git remote -v` and note the URL(s) shown for `origin`.
2. Extend `labs/04-local-vs-remote/notes/my-observations.txt` with one
   sentence explaining, in your own words, what `origin` refers to.
3. Add and commit that file (`docs: add lab 04 observations`).
4. Run `git push`. If it succeeds, your commits (from this lab and Lab 03,
   if not already pushed) now exist on the remote too.
5. Run `git log` locally, then compare it with the commit history shown on
   the remote's web interface (e.g. the GitHub "Commits" view) for the same
   branch.
6. Run `git pull`. Even with no new remote changes, confirm it completes
   without error — this is the command you'll rely on to fetch teammates'
   work later in the course.

## Acceptance criteria

- `git remote -v` output is recorded (in your own words) in
  `my-observations.txt`.
- Your Lab 03 and Lab 04 commits are visible both in `git log` locally and
  in the remote's web history for your branch.
- You can state, out loud, one sentence distinguishing "local repository"
  from "remote repository", and one sentence distinguishing Git from
  GitHub.

## Verification

```bash
git remote -v
git log --oneline -3
git status   # should show "up to date" / "nothing to commit"
```

Then open the repository on GitHub (or your Git host) and confirm your
latest commit message appears there too.

## Think about it

- If you never run `git push`, does your work exist anywhere other than
  your own machine?
- `git pull` is really two operations glued together (fetch + merge). Why
  might it matter to know that, once you're working with teammates?

## If you get stuck

- **Hint 1:** You need three new commands beyond Lab 03: `git remote -v`,
  `git push`, `git pull`.
- **Hint 2:** If `git push` is rejected, it usually means the remote has
  commits you don't have locally yet — `git pull` first, then push again.
- **Hint 3:** `origin` is just a name (a local alias) for a remote URL —
  it's not a special Git keyword, it's simply the conventional default
  name.

## What's next

You can now describe where your code physically exists. But so far, every
project you've touched was small enough to run from memory. Next, you'll
see what happens when a project only works "on your machine" and nowhere
else.

Continue to [Lab 05 — "It works on my machine"](../05-works-on-my-machine/README.md).
