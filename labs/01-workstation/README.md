# Lab 01 — Welcome to your workstation

## Story

You just joined a software project. Someone handed you a laptop, or in this
case, a fresh GitHub Codespace. Before you can change a single line of code,
you need to know where you are, what's around you, and how to move.

## Learning objectives

After this lab you should be able to:

- Determine your current location in the filesystem and move between
  directories.
- List files, including hidden ones, and read a basic long-listing output.
- Create and inspect files and directories from the command line.
- Explain what `$HOME`, `$PATH`, and the current shell are, in your own
  words.

## Before you start

- You have an environment open (Codespaces or local — see the root
  [`README.md`](../../README.md)).
- You have an integrated terminal open.
- No previous lab is required — this is the first one.

## Your task

Working only in the terminal:

1. Find out your current directory, then move to your home directory and
   confirm you're there.
2. List the contents of your home directory, including hidden files.
3. Create a directory called `lab01-notes` inside your home directory.
4. Inside it, create a file called `findings.txt`.
5. Using `cat`, write into `findings.txt` the output of these four
   commands, one per line, labeled: `whoami`, `uname -a`, `echo "$HOME"`,
   `echo "$PATH"`.
6. Use `which` to find out where the `python3` and `git` executables
   actually live on disk.
7. Open `findings.txt` with `less` and confirm its contents.

## Acceptance criteria

- `~/lab01-notes/findings.txt` exists and contains four labeled lines with
  real output from your machine (not made up).
- You can state, without looking it up again, what your home directory path
  is and what your current shell is.
- You can explain what `$PATH` is used for, in one or two sentences.

## Verification

```bash
test -f ~/lab01-notes/findings.txt && echo "file exists"
wc -l < ~/lab01-notes/findings.txt   # expect at least 4
which python3
which git
```

If both `which` commands print a path (not an error), your tools are
reachable from your shell.

## Think about it

- What would happen if `$PATH` did not include the directory containing
  `git`?
- Two different accounts on the same machine can have different `$HOME`.
  Why does that matter for a script that assumes a fixed file location?

## If you get stuck

- **Hint 1:** Every one of these tasks corresponds to exactly one short
  command. You don't need any flags you haven't seen before except `-la`
  for listing hidden files and `-a` for `uname`.
- **Hint 2:** The commands you need are: `pwd`, `cd`, `ls -la`, `mkdir`,
  `touch`, `cat`, `whoami`, `uname -a`, `echo`, `which`, `less`.
- **Hint 3:** To write labeled output into a file without an editor, you
  can append line by line, e.g.
  `echo "whoami: $(whoami)" >> ~/lab01-notes/findings.txt`.

## What's next

You can now move around and inspect your environment. Next, the terminal
stops being just a place to run one command at a time — you'll start
combining commands and managing running processes.

Continue to [Lab 02 — The terminal is a development tool](../02-terminal/README.md).
