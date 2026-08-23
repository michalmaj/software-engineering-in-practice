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
5. Run `echo "$SHELL"` and read what it prints — that's your current
   shell.
6. Write into `findings.txt` the output of these five commands, one per
   line, labeled: `whoami`, `uname -a`, `echo "$HOME"`, `echo "$PATH"`,
   `echo "$SHELL"`. You haven't learned a text editor yet, so use this
   one small trick: `>>` appends a line of command output to a file
   without opening anything —
   `echo "whoami: $(whoami)" >> ~/lab01-notes/findings.txt` adds one
   labeled line. Repeat for each of the five commands. (You'll learn
   `>>` properly, alongside `>` and `|`, in Lab 02 — this is the one
   piece you need early to finish this lab.)
7. Use `which` to find out where the `python3` and `git` executables
   actually live on disk.
8. Open `findings.txt` with `less` and confirm its contents.

## Acceptance criteria

- `~/lab01-notes/findings.txt` exists and contains five labeled lines with
  real output from your machine (not made up).
- You can state, without looking it up again, what your home directory path
  is and what your current shell is.
- You can explain what `$PATH` is used for, in one or two sentences.

## Verification

```bash
test -f ~/lab01-notes/findings.txt && echo "file exists"
wc -l < ~/lab01-notes/findings.txt   # expect at least 5
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
- **Hint 3:** If you're unsure the `>>` trick worked, run `cat
  ~/lab01-notes/findings.txt` afterward and confirm all five lines are
  there — each append should add exactly one new line.

## What's next

You can now move around and inspect your environment. Next, the terminal
stops being just a place to run one command at a time — you'll start
combining commands and managing running processes.

Continue to [Lab 02 — The terminal is a development tool](../02-terminal/README.md).
