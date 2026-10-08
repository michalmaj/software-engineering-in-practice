# Troubleshooting

[Po polsku →](troubleshooting.pl.md) · [← Back to Start here](../../START-HERE.md)

This page collects problems that can come up anywhere during setup,
not just on one operating system. Find the heading that matches what
you're seeing.

## I don't have administrator rights on this computer

See the Windows guide's
[No administrator rights?](windows.md#no-administrator-rights) section
— it covers installing Git and VS Code without admin rights. If even
that's blocked on this machine, use
[GitHub Codespaces](../../START-HERE.md#github-codespaces-the-no-install-option)
instead, which needs no local installation at all.

## `choco`, `git`, `code`, or `brew` says "not recognized" / "command not found"

Close every terminal window (and VS Code, if it's open) and open a
fresh one. A program that just finished installing often doesn't show
up in a window that was already open beforehand. If it's still
missing after that, go back to the install step in your system's guide
and check it actually completed — scroll up in that terminal to look
for an error partway through.

## Git Bash isn't visible in VS Code's terminal (Windows)

See the Windows guide's dedicated
[I don't see Git Bash in VS Code](windows.md#i-dont-see-git-bash-in-vs-code)
section — it covers restarting VS Code and manually pointing it at
Git Bash.

## I'm having trouble logging into GitHub

- Double-check you're using the email or username (not a typo'd
  variant) tied to your GitHub account.
- If two-factor authentication is asking for a code and you don't have
  your phone, GitHub's login page has a "Use a recovery code" or
  similar fallback link — use the recovery codes you were given when
  you set up 2FA.
- If you've truly never made a GitHub account, go to
  [github.com/join](https://github.com/join) and create one — it's
  free.

## GitHub says I already have a fork of this repository

That's fine — you don't need to fork it again. Go to
[`already-have-a-fork.md`](already-have-a-fork.md) and follow "I
forked it on GitHub, but I don't know if I cloned it."

## I cloned the instructor's repository instead of my own fork

See the "I cloned the instructor's repository instead of my own fork"
section in your system's guide
([Windows](windows.md#i-cloned-the-instructors-repository-instead-of-my-own-fork),
[macOS](macos.md#i-cloned-the-instructors-repository-instead-of-my-own-fork),
[Linux](linux.md#i-cloned-the-instructors-repository-instead-of-my-own-fork))
— it shows a safe, non-destructive fix.

## The repository is already on my disk somewhere — I don't want to clone it again

Go to [`already-have-a-fork.md`](already-have-a-fork.md) and follow
"I have a local copy already" — it shows you how to find it and check
it's in a safe state without re-cloning.

## I don't know what directory I'm in

Run:
```bash
pwd
```
This always tells you exactly where you are. If it's not where you
expect, `cd ~` takes you back to your home directory, and you can
navigate from there.

## VS Code opened the wrong folder

**File → Open Folder…** again, and this time navigate carefully to
your cloned repository folder (the one `pwd` shows after `cd`-ing into
it in a terminal). The folder you want contains `labs`, `examples`,
and `scripts` as subfolders — if the Explorer panel doesn't show those
three after opening, you opened the wrong level (too high, like your
whole `projects` folder, or too low, like inside `labs` itself).

## "command not found" for something other than git/code/choco/brew

Check that you're in the terminal your system's guide set up (Git Bash
on Windows, the default terminal on macOS/Linux) — a command that
exists in one shell may not exist in another. If you're not sure which
terminal you're in, close it and open a fresh one via the exact steps
in your system's guide.

## `labs/`, `examples/`, or `scripts/` is missing from the project

This almost always means VS Code (or your terminal) is open to the
wrong folder, or the clone didn't finish. Run:
```bash
pwd
ls
```
If `ls` doesn't show `labs`, `examples`, and `scripts`, you're in the
wrong place — `cd` into the actual repository folder, or reopen it in
VS Code with **File → Open Folder…**.

## My first `git push` isn't working

See [`github-auth.md`](github-auth.md) — it's written specifically for
first-push authentication problems, including what to do if no browser
window appears.

## Git Bash says something about line endings, or a `.sh` script won't run (Windows)

If a script fails with something like `$'\r': command not found` or
similar, the file likely has Windows-style line endings. This course's
own scripts are already committed with the correct line endings, so
this is unlikely to affect anything in `labs/`, `examples/`, or
`scripts/` as cloned — if you see this on a file you didn't create or
edit yourself, report it rather than trying to fix the file (see
below). If it's a file you created yourself in a plain text editor
other than VS Code, reopen and save it from VS Code instead, which
uses the correct line endings by default for this repository.

## If you're still stuck

Report the problem to your instructor with these five things:

1. Your operating system (Windows 11, macOS, or which Linux
   distribution).
2. Which step number or section you were on.
3. The exact command you ran.
4. The exact error message you saw (copy the text, or a screenshot).
5. What you expected to happen instead.

**Never include a password, personal access token, or any other secret
in this report** — not in the text, not in a screenshot. If a
screenshot would show one, crop or redact it first.
