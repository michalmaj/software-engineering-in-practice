# Your first push to GitHub

[Po polsku →](github-auth.pl.md) · [← Back to Start here](../../START-HERE.md)

Cloning and reading this repository needed no login at all. The first
time you run `git push`, though, Git needs to prove to GitHub that
you're actually you. This page is written for that exact moment — read
it when a lab tells you to push, not before.

## What NOT to do

- **Never type your GitHub account password** when Git asks for a
  password over HTTPS. GitHub stopped accepting account passwords for
  Git operations years ago — if something is prompting you for one and
  accepting it, you're not talking to GitHub. If anything you see asks
  for your account password specifically, stop and see
  [If you get stuck](#if-you-get-stuck) below rather than typing it in.
- **Never paste a token** (anything starting with `ghp_` or similar)
  into this repository's README, into a GitHub issue, into a commit
  message, or into a chat message to your instructor. A token pasted
  anywhere public or semi-public should be treated as compromised —
  revoke it on GitHub (**Settings → Developer settings → Personal
  access tokens**) and generate a new one.

## What to do instead

### The easy path: let VS Code or Git handle it

Most of the time, you don't need to do anything special — when you run
`git push` for the first time, either VS Code or Git itself will open a
browser window asking you to log into GitHub and authorize access. Log
in normally (your usual GitHub password, and two-factor if you have it
set up), click **Authorize**, and return to your terminal — the push
continues on its own.

This works because of **Git Credential Manager**, which ships bundled
with Git for Windows and is commonly already present on macOS and
Linux Git installs. It securely stores the result of that one-time
browser login so you won't be asked again on this computer.

### If no browser window appears

1. Try the push again:
   ```bash
   git push
   ```
2. If Git prints a prompt like `Username for
   'https://github.com':`, type your GitHub username and press Enter.
3. If it then prints `Password for
   'https://<username>@github.com':`, this is **not** asking for your
   account password — it's asking for a **personal access token**,
   which looks like a password but is a separate, revocable credential.
   Create one:
   - In your browser, go to **GitHub → Settings → Developer settings →
     Personal access tokens → Tokens (classic) → Generate new token**.
   - Give it a name you'll recognize (e.g. `software-engineering-in-practice`),
     an expiration (30-90 days is plenty for a course), and check the
     **repo** scope.
   - Click **Generate token**, then copy it immediately — GitHub shows
     it to you exactly once.
4. Paste that token into the terminal's password prompt (it won't show
   as you paste it — that's normal) and press Enter.

**How you know it worked:** the terminal shows upload progress ending
in something like `main -> main`, and no error.

## If you get stuck

- **"It's asking me for a password and token didn't work either."**
  Double-check you copied the entire token with no extra spaces, and
  that it hasn't expired. Generate a fresh one if unsure.
- **"I don't see a browser window and no prompt is appearing at all —
  the terminal just hangs."** Press `Ctrl+C` to cancel, then try
  `git push` again from a freshly opened terminal.
- **Still stuck?** See the shared
  [`troubleshooting.md`](troubleshooting.md) for how to report the
  problem — and remember: never include a password, token, or other
  secret in that report.
