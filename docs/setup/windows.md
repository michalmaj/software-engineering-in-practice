# Windows setup

[W języku polskim →](windows.pl.md) · [← Back to Start here](../../START-HERE.md)

This page takes you from a brand-new Windows 11 laptop to your own
copy of this course, open in VS Code, with a working Git Bash
terminal inside it. Follow it from the top, in order. Don't skip
ahead — later steps assume the earlier ones actually worked, and each
one tells you exactly how to check that before moving on.

If you get stuck anywhere, don't guess — jump to
[Troubleshooting](#if-you-get-stuck) near the bottom of this page, or
the shared [`troubleshooting.md`](troubleshooting.md).

## Part 1 — Open PowerShell as Administrator

You only need administrator rights for the *installation* steps in
Parts 2–3. Nothing else in this course needs it.

1. Press the **Windows key** (or click the Start button, bottom-left
   of your screen).
2. Type `powershell`. Windows will show **Windows PowerShell** as a
   search result.
3. **Right-click** that search result.
4. Click **Run as administrator**.
5. A dialog box may appear asking "Do you want to allow this app to
   make changes to your device?" Click **Yes**.

**What you should see:** a blue-background terminal window with a
title bar that says **Administrator: Windows PowerShell**. The word
"Administrator" in the title bar is how you know it's elevated — a
normal PowerShell window does not say that.

**If you see something else:** if there's no "Administrator" in the
title bar, you opened a normal PowerShell window by mistake — close
it and repeat steps 1–4, making sure you right-click and choose **Run
as administrator**, not just press Enter.

**How you know you can continue:** the title bar says
**Administrator: Windows PowerShell**.

## Part 2 — Install Chocolatey (a package manager for Windows)

Chocolatey lets you install Git and VS Code with one command each,
instead of hunting for installers and clicking through setup wizards.

1. In the **administrator** PowerShell window from Part 1, check
   whether it's already installed:
   ```powershell
   choco --version
   ```
2. **What you should see:** a version number (something like
   `2.3.0`). If you see that, Chocolatey is already installed — skip
   to Part 3.
3. **If you see** `choco: The term 'choco' is not recognized...`,
   Chocolatey isn't installed yet. Run the official install command
   (this is the real command from
   [chocolatey.org/install](https://chocolatey.org/install) —
   paste it exactly as written):
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```
4. **What you should see:** several lines of installation output,
   ending with something like `Chocolatey (choco.exe) is now ready`.
5. Close this PowerShell window entirely and open a **new
   administrator** PowerShell window (repeat Part 1). Chocolatey
   only becomes available to new terminal windows, not the one it was
   installed from.
6. Confirm it worked:
   ```powershell
   choco --version
   ```
   **How you know you can continue:** a version number is printed,
   not an error.

**If you don't have administrator rights on this machine** (common on
university or shared lab computers): skip Chocolatey entirely and go
to [No administrator rights?](#no-administrator-rights) below, then
come back here once Git and VS Code are installed another way.

## Part 3 — Install Git for Windows and VS Code

Both of these need administrator rights to install through Chocolatey
— do them one after another, in the same window, before you drop back
to a normal (non-administrator) session for everything else. Still in
the **administrator** PowerShell window:

1. Install Git:
   ```powershell
   choco install git -y
   ```
   **What you should see:** download and install output, ending with
   something like `git v2.xx.x already installed` or a success
   message. This can take a minute or two.
2. Install VS Code, in the same window:
   ```powershell
   choco install vscode -y
   ```
   **What you should see:** install output ending in a success
   message.
3. Close this **administrator** PowerShell window entirely. You won't
   need administrator rights again for the rest of this course —
   everything from here on, including opening VS Code itself for the
   first time, happens in a normal window.
4. Open a **normal** (non-administrator) PowerShell window: press the
   Windows key, type `powershell`, press **Enter** this time (no
   right-click needed).
5. Confirm both installed:
   ```powershell
   git --version
   code --version
   ```
   **What you should see:** `git version 2.xx.x.windows.x`, followed
   by a few lines of version information from VS Code.

   **If either says "is not recognized"**: close *all* PowerShell and
   terminal windows, including VS Code if it's open, and try again
   from a freshly-opened window. Installing a new program sometimes
   doesn't take effect in windows that were already open. If it still
   isn't found, see [Troubleshooting](#if-you-get-stuck).
6. Open VS Code itself for the first time: press the Windows key,
   type `code`, click **Visual Studio Code**.

**What you should see:** the VS Code window opens, with a welcome tab
and an empty Explorer panel on the left (nothing to show yet — that's
expected, you haven't opened a project).

**How you know you can continue:** `git --version` and `code
--version` both print real version information, and VS Code opened.

## Part 4 — Find Git Bash

Installing Git for Windows also installs **Git Bash** — a separate
terminal program that understands the Unix-style commands this
course uses (`ls`, `pwd`, `cat`, and so on), unlike PowerShell.

1. Press the **Windows key**.
2. Type `git bash`.
3. Click **Git Bash** when it appears, to open it.

**What you should see:** a terminal window with a black or dark
background and a prompt that looks like
`you@YOURCOMPUTER MINGW64 ~`. That `MINGW64` is how you know this is
Git Bash and not PowerShell or the old Command Prompt.

You can close this window for now — you'll reach Git Bash again
through VS Code in Part 5. The point of this step was just confirming
it's actually there.

### PowerShell vs. Git Bash vs. the VS Code terminal — what's the difference?

- **PowerShell** is Windows' own terminal. You used it in Parts 1–3
  only to *install* things. This course's instructions (`ls`, `cat`,
  `grep`, and so on) do not work the same way in PowerShell — don't
  use it for the labs.
- **Git Bash** is a Unix-like terminal that comes with Git for
  Windows. This is what every instruction in this course assumes —
  when a lab says "run this in your terminal," it means Git Bash.
- **The VS Code terminal** is just a terminal panel *inside* the VS
  Code window. By default on Windows it opens PowerShell — Part 5
  below changes that default to Git Bash, once, so every terminal you
  open inside VS Code from then on is already the right one.

## Part 5 — Make Git Bash the default terminal in VS Code

Do this once, now, so you never have to think about it again.

1. In VS Code, open the menu **Terminal → New Terminal**.
2. **What you should see:** a terminal panel opens at the bottom of
   the window. On a fresh install, this is usually PowerShell —
   that's fine, you're about to change it.
3. Click the small **dropdown arrow** next to the `+` icon in the
   terminal panel's top-right corner. If you don't see a dropdown
   arrow there, open the Command Palette instead (**View → Command
   Palette…**, or `Ctrl+Shift+P`) and type:
   ```text
   Terminal: Select Default Profile
   ```
4. From the list that appears, click **Git Bash**.
5. Close the terminal panel that's currently open (click the trash-can
   icon, or click into it and press `Ctrl+D`).
6. Open a new one: **Terminal → New Terminal** again.
7. **What you should see:** a prompt that looks like
   `you@YOURCOMPUTER MINGW64 ~` — the same style you saw in Part 4,
   now inside VS Code.
8. Confirm it's really Bash, not PowerShell wearing a disguise:
   ```bash
   echo "$BASH_VERSION"
   ```
   **How you know you can continue:** this prints a real version
   number (something like `5.2.26(1)-release`). PowerShell doesn't
   understand `$BASH_VERSION` at all and would show nothing or an
   error — if that's what you see, the default profile change in
   step 4 didn't take effect; see the next section.

### I don't see Git Bash in VS Code

If **Git Bash** never appeared in the list in step 4, or the new
terminal is still PowerShell after following steps 1–7:

1. **Restart VS Code completely** — close every window, reopen it,
   and retry Part 5 from step 1. VS Code only scans for terminal
   profiles like Git Bash at startup, so it can miss an install that
   happened while it was already open.
2. If it's still missing, point VS Code at Git Bash manually:
   - Open the Command Palette (`Ctrl+Shift+P`) and run
     **Preferences: Open User Settings (JSON)**.
   - Add this (merge it into the existing `{ }` — ask in
     [Troubleshooting](#if-you-get-stuck) if you're not sure how to
     merge JSON, don't guess):
     ```json
     "terminal.integrated.profiles.windows": {
       "Git Bash": {
         "path": "C:\\Program Files\\Git\\bin\\bash.exe"
       }
     },
     "terminal.integrated.defaultProfile.windows": "Git Bash"
     ```
   - Save the file, then repeat steps 5–8 above.
   - If Git isn't at `C:\Program Files\Git`, find where it actually
     is. In a PowerShell window, run:
     ```powershell
     (Get-Command git).Source
     ```
     This prints `git.exe`'s own path — usually inside a `cmd\`
     folder, like `C:\Program Files\Git\cmd\git.exe`. Don't assume
     `bash.exe` is in that same folder; it isn't — it's in a sibling
     `bin\` folder instead, one level up. To get the exact path to use
     above, run:
     ```powershell
     Join-Path (Split-Path (Split-Path (Get-Command git).Source)) "bin\bash.exe"
     ```
     Before pasting that path into `settings.json`, confirm the file
     actually exists there — open that folder in Windows Explorer and
     check, or run `Test-Path` on the path PowerShell printed; it
     should say `True`.

## Part 6 — Fork, clone, and open this repository

This is the actual goal of this whole page. From here on, every step
happens either in your web browser or in the Git Bash terminal inside
VS Code from Part 5.

**Already have a fork, or a local copy, from an earlier attempt?**
Don't repeat these steps blindly — go to
[`already-have-a-fork.md`](already-have-a-fork.md) first.

### 6.1 — Fork the repository on GitHub

1. Make sure you're logged in to GitHub — open
   [github.com](https://github.com) in your browser and check the
   top-right corner shows your account avatar, not a "Sign in"
   button. If you don't have a GitHub account yet, create one first
   (it's free) before continuing.
2. Go to
   `https://github.com/michalmaj/software-engineering-in-practice`.
3. Click the **Fork** button, top-right of the page.
4. On the "Create a new fork" page, make sure **Owner** shows *your*
   account, not the instructor's — this dropdown defaults to whichever
   account you're logged in as, which should already be you.
5. Click **Create fork**.

**What you should see:** GitHub takes you to a new page whose URL is
`https://github.com/<your-username>/software-engineering-in-practice`
— your own username, not `michalmaj`, is now in the address bar and
in the page's title, just under the repository icon that shows it was
forked from `michalmaj/software-engineering-in-practice`.

**How you know you can continue:** the URL in your browser's address
bar contains *your* GitHub username, not `michalmaj`.

### 6.2 — Copy your fork's clone URL

1. On your fork's page (the one from the previous step), click the
   green **Code** button.
2. Make sure the **HTTPS** tab is selected (not SSH, not GitHub CLI —
   this course doesn't need SSH keys set up).
3. Click the small copy icon next to the URL to copy it. It looks
   like:
   ```text
   https://github.com/<your-username>/software-engineering-in-practice.git
   ```
   with your actual username in place of `<your-username>`.

### 6.3 — Clone it onto your computer

Back in the Git Bash terminal inside VS Code (Part 5):

1. Decide where your projects should live and create that folder if
   it doesn't exist yet. A reasonable, simple choice:
   ```bash
   mkdir -p ~/projects
   cd ~/projects
   ```
2. Clone your fork — paste the URL you copied in 6.2. **Replace
   `<your-username>` with your actual GitHub username**; don't paste
   the line below literally:
   ```bash
   git clone https://github.com/<your-username>/software-engineering-in-practice.git
   ```
3. **What you should see:** lines like `Cloning into
   'software-engineering-in-practice'...`, then `Receiving objects:
   100%`, ending without an error.
4. Move into the new folder:
   ```bash
   cd software-engineering-in-practice
   ```
5. Confirm where you are and what's here:
   ```bash
   pwd
   ls
   ```
   **What you should see:** `pwd` prints something ending in
   `/projects/software-engineering-in-practice`; `ls` lists folders
   including `labs`, `examples`, `scripts`, and files including
   `README.md` and `START-HERE.md`.
6. Confirm Git itself is happy, and that it points at *your* fork,
   not the instructor's:
   ```bash
   git status
   git remote -v
   ```
   **What you should see:** `git status` says `On branch main` and
   `nothing to commit, working tree clean`. `git remote -v` shows two
   lines (`origin` fetch and push) whose URL contains **your own
   GitHub username** — if you see `michalmaj` there instead of your
   username, you cloned the original repository by mistake, not your
   fork; see
   [I cloned the instructor's repository instead of my own fork](#i-cloned-the-instructors-repository-instead-of-my-own-fork)
   below.

**How you know you can continue:** `git remote -v` shows your own
username, and `ls` shows `labs/`, `examples/`, and `scripts/`.

### 6.4 — Open it in VS Code

1. In VS Code, open the menu **File → Open Folder…**
2. Navigate to the folder you cloned — if you followed 6.3 exactly,
   that's `projects` → `software-engineering-in-practice` inside your
   Windows user folder.
3. Click **Select Folder**.
4. VS Code may ask "Do you trust the authors of the files in this
   folder?" — click **Yes, I trust the authors**.

**What you should see:** the Explorer panel on the left now lists
`labs`, `examples`, `scripts`, `README.md`, and more — the same
listing `ls` showed you in 6.3.

5. Open a terminal inside this window (**Terminal → New Terminal**) —
   it should already default to Git Bash, since you set that in Part
   5. Confirm you're in the right place:
   ```bash
   pwd
   ```
   **How you know you can continue:** the path ends in
   `/software-engineering-in-practice`, and the Explorer panel shows
   the `labs/` folder.

### 6.5 — Find Lab 01

1. In the Explorer panel on the left, click to expand the `labs`
   folder.
2. Find and click `01-workstation`, then click `README.md` inside it.

**What you should see:** `Lab 01 — Welcome to your workstation` opens
as a readable document in the editor.

That's it — you've reached the end of this page's job. Go to
[Before you're done](#before-youre-done) to double-check everything,
then start the lab.

## First GitHub push

You won't push anything to GitHub until partway through Lab 03 or
Lab 04 — cloning and reading don't require being logged in to Git
itself, only your browser session from 6.1. When you get there and
`git push` asks you to authenticate, see
[`github-auth.md`](github-auth.md) — it's written for that exact
moment, so there's no need to read it now.

## Before you're done

Check every one of these before calling Lab 01 ready:

- [ ] `git --version` works in a plain terminal.
- [ ] A new terminal in VS Code opens Git Bash by default
      (`echo "$BASH_VERSION"` prints a version).
- [ ] `pwd` inside VS Code's terminal ends in
      `/software-engineering-in-practice`.
- [ ] `git status` works without an error.
- [ ] `git remote -v` shows **your own** GitHub username.
- [ ] The Explorer panel shows `labs/`, `examples/`, and `scripts/`.
- [ ] `labs/01-workstation/README.md` opens.

All checked? Open
[`labs/01-workstation/README.md`](../../labs/01-workstation/README.md)
and begin.

## No administrator rights?

If Part 1–2 aren't possible on this machine (common on university lab
computers), you can still get everything installed through the
official installers instead of Chocolatey — these don't require the
same elevated rights, and some let you install into your own user
folder specifically:

- **Git for Windows**: download the installer from
  [git-scm.com/download/win](https://git-scm.com/download/win). Run
  it; when the setup wizard asks where to install, you can usually
  point it at a folder inside your own user profile instead of
  `C:\Program Files` if you don't have write access there. Keep every
  other default option as-is.
- **VS Code**: download the **User Installer** (not "System
  Installer") from
  [code.visualstudio.com](https://code.visualstudio.com/) — the User
  Installer is specifically designed to install into your own user
  folder without needing administrator rights.

Once both are installed this way, resume at Part 4 above — everything
from there on works the same regardless of how Git and VS Code got
onto your machine.

If neither installer is allowed to run at all on this machine, you
don't need a local setup — see
[GitHub Codespaces](../../START-HERE.md#github-codespaces-the-no-install-option)
in Start here instead.

## If you get stuck

### `choco`, `git`, or `code` says "not recognized"

Close *every* terminal and VS Code window and open a fresh one — a
newly-installed program often doesn't appear in windows that were
already open before the install finished. If it's still missing
after that, double check the matching Part above actually completed
without an error partway through.

### I cloned the instructor's repository instead of my own fork

If `git remote -v` shows `michalmaj` instead of your username: the
folder you cloned points at a repository you don't have permission to
push to, which will block you later (Lab 03–04). Fix it without
losing anything:

```bash
cd ..
mv software-engineering-in-practice software-engineering-in-practice.instructor-copy
```

This renames the mis-cloned folder out of the way instead of deleting
it, then repeat 6.1–6.4 with your *own* fork's URL this time. Once
your real copy is working, you can delete the renamed folder if you
want, or just leave it — it isn't doing any harm sitting there.

### Everything else

See the shared [`troubleshooting.md`](troubleshooting.md) for
problems not specific to Windows (GitHub login issues, "repo already
exists on disk," wrong folder opened in VS Code, first-push problems,
and more).
