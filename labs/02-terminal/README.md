# Lab 02 — The terminal is a development tool

## Story

Yesterday you learned to look around. Today you need to actually get work
done without touching a mouse: copy files, search inside them, chain
commands together, and run something that keeps running until you stop it.

## Learning objectives

After this lab you should be able to:

- Copy, move, and remove files and directories from the shell.
- Search file contents and find files by name.
- Redirect output to a file and pipe the output of one command into
  another.
- Start a long-running process, observe it, and stop it with `Ctrl+C`.

## Before you start

- Lab 01 complete (you can navigate and create files from the terminal).
- Current directory: your home directory or the repository checkout, either
  is fine for this lab.

## Your task

1. Inside `~/lab01-notes/`, copy `findings.txt` to `findings.bak.txt`.
2. Create a directory `~/lab02-notes/` and move `findings.bak.txt` into it.
3. Search `findings.txt` for the line containing `whoami` using `grep`, and
   redirect that single matching line into a new file
   `~/lab02-notes/whoami-line.txt`.
4. Use `find` to locate every file named `findings.txt` under your home
   directory (there should be exactly one, from Lab 01).
5. Start a simple long-running server:
   `python3 -m http.server 8000` from your home directory.
6. While it's running, in a **second terminal**, confirm it responds:
   `curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8000/`
   (expect `200`).
7. Stop the server in the first terminal with `Ctrl+C`. Confirm in the
   second terminal that the same `curl` command now fails to connect.

## Acceptance criteria

- `~/lab02-notes/findings.bak.txt` and `~/lab02-notes/whoami-line.txt` both
  exist, and the latter contains exactly one line, matching `whoami`.
- You can point to the exact command that stopped the server, and explain
  what signal `Ctrl+C` sends.
- You can explain the difference between `>` and `>>`.

## Verification

```bash
test -f ~/lab02-notes/findings.bak.txt && echo "backup exists"
test -f ~/lab02-notes/whoami-line.txt && echo "grep output exists"
wc -l < ~/lab02-notes/whoami-line.txt   # expect exactly 1
find ~ -name findings.txt               # expect exactly one path
```

## Think about it

- What is the practical difference between piping (`|`) one command into
  another and redirecting (`>`) into a file?
- The server kept running after you pressed Enter on the first command.
  Why didn't your terminal give you a new prompt right away?
- What would `>` (instead of `>>`) have done to `findings.txt` if you had
  used it in Lab 01 by mistake?

## If you get stuck

- **Hint 1:** You need `cp`, `mv`, `rm` for file manipulation; `grep` and
  `find` for searching; `>` and `>>` for redirection; `|` for piping.
- **Hint 2:** `grep "whoami" file > out.txt` writes matching lines from
  `file` into `out.txt`, overwriting it if it exists.
- **Hint 3:** To run a command and free up your terminal immediately, you
  can background it with `&`, but for this lab, use a second terminal tab
  or pane instead so you can watch both at once.

## What's next

You can run things and inspect their output — but you have no way yet to
tell what changed in this project since yesterday, or to undo a mistake.
That's what version control is for.

Continue to [Lab 03 — You inherited a repository](../03-inherited-repository/README.md).
