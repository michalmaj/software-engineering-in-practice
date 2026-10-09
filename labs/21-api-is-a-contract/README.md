# Lab 21 — An API is a contract

## Story

Another part of the kitchen system needs to create and check on orders
— not by importing your code, but over the network, from a program
that might not even be written in the same language. You need a
boundary both sides can agree on without reading each other's source.

## Learning objectives

After this lab you should be able to:

- Describe an HTTP endpoint's contract: request shape, response shape,
  status codes, and error format.
- Explain why a contract needs to specify error behavior, not just the
  success path.
- Add a new validation rule to an existing endpoint without changing
  its contract for callers who were already following it correctly.

## Before you start

- Labs 06-20 complete, in your chosen track.
- If you already started this project at its old location
  (`examples/order-api/api.py`, with no `python/` subfolder), nothing
  is lost: move whatever you'd already created into
  `examples/order-api/python/` yourself (for example
  `mkdir -p examples/order-api/python && git mv examples/order-api/api.py examples/order-api/python/`,
  adjusting for whatever files you personally added), then continue
  from here. Don't run `git reset --hard` or `git clean` to "start
  over" — either one would throw away work you haven't pushed anywhere
  else.

### Python

- Current directory: `examples/order-api/python/`.
- Confirm the starter works: `uv run pytest -v`.

### Go

- Current directory: `examples/order-api/go/`.
- Confirm the starter works: `go test ./...`.

### Java

- Current directory: `examples/order-api/java/`.
- Confirm the starter works: `./gradlew test`.

## Your task

### Step 1 — run the server and explore it by hand

You'll need two terminals open at once: one running the server, one
running `curl` against it. In VS Code, open the first terminal
normally (**Terminal → New Terminal**), then click the **split
terminal** icon in that panel (or run **Terminal → New Terminal**
again) to get a second one — both stay inside the same VS Code window.

**Terminal A** — start the server, and leave it running:

#### Python

```bash
uv run python api.py
```

#### Go

```bash
go run .
```

#### Java

```bash
./gradlew run --console=plain
```

The first run downloads the Gradle distribution and dependencies if
they aren't cached yet — that can take a minute or two; every run
after the first is fast.

**All three tracks** print the same line once ready:

```text
order-api listening on http://localhost:8000
```

That line is your signal the server is actually up — don't move to
Terminal B until you've seen it.

**Terminal B** — with the server still running in Terminal A, exercise
it by hand. These three commands are identical for every track, since
they're only talking HTTP:

```bash
curl -i -X POST http://localhost:8000/orders \
  -H "Content-Type: application/json" \
  -d '{"items": ["Burger", "Fries"]}'
curl -i http://localhost:8000/orders/1
curl -i http://localhost:8000/orders/999
```

Read each response's status line and body before moving to the next
command.

**If `curl` says** `curl: (7) Failed to connect to localhost port 8000...
Couldn't connect to server`: Terminal A's server isn't running, or it
crashed, or you're pointed at the wrong port. Check Terminal A for an
error, and confirm you saw the "listening" line before trying `curl`
again.

**If starting the server in Terminal A fails with an address-already-
in-use error**: something is already listening on port 8000 — most
likely a server you started earlier and forgot to stop. Find it:

- Look for an earlier terminal tab/pane that's still running a server.
- Or run `lsof -i :8000` (macOS/Linux) or, in Git Bash on Windows,
  check Task Manager for a lingering `python`, `go`, or `java`
  process, and stop that process.
- As a last resort, every track's server also honors a `PORT`
  environment variable, so you can sidestep the conflict entirely
  without hunting for the other process: `PORT=8001 uv run python
  api.py` (or the equivalent `go run .` / `./gradlew run` command),
  then use `http://localhost:8001` in your `curl` commands instead.

Once you're done exploring, stop the server in Terminal A with
`Ctrl+C`.

#### Python

You'll see a `KeyboardInterrupt` traceback print in Terminal A — that's
expected and harmless; it's Python's normal way of reporting that a
`Ctrl+C` interrupted a blocking call. The server has stopped either
way.

#### Go

The process just exits, with no further message — that's Go's normal,
unremarkable `Ctrl+C` behavior for a program with no special
shutdown handling.

#### Java

The process exits; Gradle may print a line noting the build was
cancelled. Either way, the server has stopped.

### Step 2 — document the contract

Write `examples/order-api/CONTRACT.md` documenting, for each endpoint:
the HTTP method and path, the request body shape (if any), every
response you can produce (status code + body shape), and what causes
each error response. This file describes the wire-level HTTP contract
— it's shared across all three tracks because the contract itself
doesn't depend on which language implements it.

To get started, here's the shape for one endpoint — fill in the rest
yourself from what you actually observed in Step 1, not from guessing:

```markdown
### `POST /orders`

Creates a new order.

**Request body:** `{"items": [<string>, ...]}`

**Responses:**
- `201 Created` — order created. Body:
  `{"order_id": "<string>", "items": [...], "status": "received"}`
- `400 Bad Request` — `items` is missing, not a list, or an empty
  list. Body: `{"error": "items must be a non-empty list"}`
- `400 Bad Request` — the request body isn't valid JSON. Body:
  `{"error": "invalid JSON"}`
```

Do the same for `GET /orders/{id}` (both the found and not-found
cases) and for an unknown path. Don't just transcribe this template —
confirm each case against a real response first.

### Step 3 — add a validation rule

The owner has a new requirement: **each entry in `items` must be a
non-empty string**. A number, an empty string, or `null` in the list
should be rejected the same way a missing `items` list already is.

#### Python

In `api.py`'s `do_POST`, right after the existing "must be a non-empty
list" check and before the order is created, add a check that rejects
the request with `400 {"error": "each item must be a non-empty
string"}` if any entry in `items` isn't a non-empty string.

#### Go

In `api.go`'s `handleCreateOrder`, right after the existing
"must be a non-empty list" check (the `len(items) == 0` check) and
before the order is created, add a loop that rejects the request with
`400 {"error": "each item must be a non-empty string"}` the moment it
finds an entry that isn't a non-empty string. Each entry comes out of
the decoded JSON as `any`, so you'll need a type assertion to check
it's actually a `string` before checking it's non-empty.

#### Java

In `ApiServer.java`'s `handleCreateOrder`, right after the existing
"must be a non-empty list" check (the `items.isEmpty()` check) and
before the order is created, add a loop that rejects the request with
`400 {"error": "each item must be a non-empty string"}` the moment it
finds an entry that isn't a non-empty string. Each entry comes out of
the parsed JSON as `Object`, so you'll need an `instanceof` check
before checking it's non-empty.

### Step 4 — add a test

#### Python

Add a test to `tests/test_api.py` confirming that
`POST /orders` with `{"items": ["Burger", ""]}` (or any other
non-string entry) returns `400`.

#### Go

Add a test to `api_test.go` confirming that `POST /orders` with
`{"items": ["Burger", ""]}` returns `400`. Follow the shape of
`TestPostWithoutItemsReturns400`.

#### Java

Add a test to `ApiServerTest.java` confirming that `POST /orders`
with `{"items": ["Burger", ""]}` returns `400`. Follow the shape of
`postWithoutItemsReturns400`.

### Step 5 — update the contract

Add the new error case to `CONTRACT.md`, under `POST /orders`'s list
of responses.

### Step 6 — set up CI

Create `.github/workflows/order-api-ci.yml` (same pattern as
Lab 19's `team-inventory-ci.yml`) triggering on `[push, pull_request]`.

#### Python

```yaml
name: order-api CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7

      - uses: actions/setup-python@v7
        with:
          python-version: "3.13"

      - name: Install uv
        uses: astral-sh/setup-uv@v10.2.0
        with:
          version: "0.11.21"

      - name: Install dependencies
        working-directory: examples/order-api/python
        run: uv sync --locked

      - name: Run tests
        working-directory: examples/order-api/python
        run: uv run pytest
```

#### Go

```yaml
name: order-api CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7

      - uses: actions/setup-go@v7
        with:
          go-version: "1.27"

      - name: Run tests
        working-directory: examples/order-api/go
        run: go test ./...
```

#### Java

```yaml
name: order-api CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7

      - uses: actions/setup-java@v6
        with:
          distribution: temurin
          java-version: "21"

      - uses: gradle/actions/setup-gradle@v6

      - name: Run tests
        working-directory: examples/order-api/java
        run: ./gradlew test
```

This workflow only runs your own track — it has no reason to set up
Python, Go, *and* Java just to test one project. That's a different
thing from this repository's own maintainer workflow
(`.github/workflows/course-health.yml`), which does set up all three,
because it's checking the whole course, not one student's project.

### Step 7 — branch, PR, review, merge

Do this lab's work on a branch (for example `feature/api-contract`),
push it, and open a pull request — same process as Lab 18: GitHub's
web UI first, double-checking the base repository and base branch
before you create it. Confirm the new CI check goes green on the PR
(open the **Checks** tab on the PR page, and confirm it's the
`order-api CI` workflow you just added that ran, not just the
pre-existing `team-inventory CI` from Lab 19). Then merge, and pull
the merged change into your local `main`.

## Acceptance criteria

- `examples/order-api/CONTRACT.md` exists and documents every
  endpoint, every status code it can return, and what triggers each
  one — including the new item-validation error case.
- The new item-validation rule is implemented and has a passing test.
- Your track's test command passes with the original three tests plus
  your new one (4 total).
- `.github/workflows/order-api-ci.yml` exists, triggers on push and
  pull request, and runs your track's tests in
  `examples/order-api/<your-language>`.
- This lab's changes were merged through a pull request with a green
  CI check, not committed directly to `main`.

## Verification

### Python

```bash
cd examples/order-api/python
uv run pytest -v
cd -
test -f examples/order-api/CONTRACT.md && echo "contract documented"
test -f .github/workflows/order-api-ci.yml && echo "CI workflow exists"
```

### Go

```bash
cd examples/order-api/go
go test ./... -v
cd -
test -f examples/order-api/CONTRACT.md && echo "contract documented"
test -f .github/workflows/order-api-ci.yml && echo "CI workflow exists"
```

### Java

```bash
cd examples/order-api/java
./gradlew test
cd -
test -f examples/order-api/CONTRACT.md && echo "contract documented"
test -f .github/workflows/order-api-ci.yml && echo "CI workflow exists"
```

Expected: `4 passed` (or the Java/Gradle equivalent), `contract
documented`, and `CI workflow exists` — plus a green check on the
pull request that merged this lab's work.

## Think about it

- If you changed the response for a successful `POST` to nest `items`
  inside a new `"order"` key instead of at the top level, would that
  break a client written against your current `CONTRACT.md`? Would
  adding a new, optional field to the response break it?
- Your validation rule for `items` entries is new. Could a client that
  was already sending valid data (non-empty strings) even notice this
  change happened?

## If you get stuck

### Python

- **Hint 1:** `curl -i` shows you the response status line and headers,
  not just the body — useful for confirming status codes by hand.
- **Hint 2:** The new validation goes in `do_POST`, checked right after
  the existing "must be a non-empty list" check, before the order is
  created.
- **Hint 3:** `all(isinstance(item, str) and item.strip() for item in
  items)` is one way to check every item is a non-empty string.

### Go

- **Hint 1:** `curl -i` shows you the response status line and headers,
  not just the body — useful for confirming status codes by hand.
- **Hint 2:** The new validation goes in `handleCreateOrder`, checked
  right after the existing `len(items) == 0` check, before the order
  is created.
- **Hint 3:** `item.(string)` is a type assertion — paired with its
  two-value form (`s, ok := item.(string)`), it tells you both whether
  an entry is a string and, if so, gives it to you to check with
  `strings.TrimSpace(s) == ""`.

### Java

- **Hint 1:** `curl -i` shows you the response status line and headers,
  not just the body — useful for confirming status codes by hand.
- **Hint 2:** The new validation goes in `handleCreateOrder`, checked
  right after the existing `items.isEmpty()` check, before the order
  is created.
- **Hint 3:** Java's pattern-matching `instanceof` (`if (item
  instanceof String s)`) both checks the type and gives you a usable
  `String` variable in one step — pair it with `s.trim().isEmpty()`.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Act IV's
branch → PR → green CI → merge loop doesn't stop just because Act V
changed which project you're working in — from here through the rest
of Act V, every lab's changes go through it, now covering `order-api`.

## What's next

Your API works — until you restart it and every order you created
disappears. Next, the data has to survive — in Python, Go, and Java
alike.

Continue to [Lab 22 — Code changed, old data remained](../22-data-outlives-code/README.md).
