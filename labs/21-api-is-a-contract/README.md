# Lab 21 — An API is a contract

## Story

Another part of the kitchen system needs to create and check on orders
— not by importing your Python code, but over the network, from a
program that might not even be written in Python. You need a boundary
both sides can agree on without reading each other's source.

## Learning objectives

After this lab you should be able to:

- Describe an HTTP endpoint's contract: request shape, response shape,
  status codes, and error format.
- Explain why a contract needs to specify error behavior, not just the
  success path.
- Add a new validation rule to an existing endpoint without changing
  its contract for callers who were already following it correctly.

## Before you start

- Labs 06-20 complete.
- Current directory: `examples/order-api/`.
- Confirm the starter works: `uv run pytest -v`.

## Your task

1. Start the server: `uv run python api.py` (leave it running). In a
   second terminal, exercise it by hand:
   ```bash
   curl -i -X POST http://localhost:8000/orders \
     -H "Content-Type: application/json" \
     -d '{"items": ["Burger", "Fries"]}'
   curl -i http://localhost:8000/orders/1
   curl -i http://localhost:8000/orders/999
   ```
2. Stop the server (`Ctrl+C`) once you've seen all three responses.
3. Write `CONTRACT.md` in `examples/order-api/` documenting, for each
   endpoint: the HTTP method and path, the request body shape (if any),
   every response you can produce (status code + body shape), and what
   causes each error response.
4. Add one more validation rule to `do_POST`: each entry in `items`
   must be a non-empty string. If any entry isn't (a number, an empty
   string, `null`, etc.), respond `400 {"error": "each item must be a
   non-empty string"}` instead of creating the order.
5. Add a test for the new validation rule in `tests/test_api.py`.
6. Update `CONTRACT.md` to describe this new error case too.
7. Set up CI for `order-api`: create
   `.github/workflows/order-api-ci.yml` (same pattern as Lab 19's
   `team-inventory-ci.yml`) triggering on `[push, pull_request]`, that
   checks out the repo, sets up Python 3.13, installs `uv` pinned to
   `0.11.21` via the `astral-sh/setup-uv` action, then runs
   `uv sync --locked` and `uv run pytest` with `working-directory:
   examples/order-api`.
8. Do this lab's work on a branch (for example `feature/api-contract`),
   push it, and open a pull request. Confirm the new CI check goes
   green, then merge. Act IV's branch → PR → green CI → merge loop
   doesn't stop just because Act V changed which project you're working
   in — from here through the rest of Act V, every lab's changes go
   through it, now covering `order-api`.

## Acceptance criteria

- `CONTRACT.md` exists and documents every endpoint, every status code
  it can return, and what triggers each one.
- The new item-validation rule is implemented and has a passing test.
- `uv run pytest` passes with the original three tests plus your new
  one (4 total).
- `.github/workflows/order-api-ci.yml` exists, triggers on push and
  pull request, and runs `uv run pytest` in `examples/order-api`.
- This lab's changes were merged through a pull request with a green
  CI check, not committed directly to `main`.

## Verification

```bash
cd examples/order-api
uv run pytest -v
test -f CONTRACT.md && echo "contract documented"
cd -
test -f .github/workflows/order-api-ci.yml && echo "CI workflow exists"
```

Expected: `4 passed`, `contract documented`, and `CI workflow exists` —
plus a green check on the pull request that merged this lab's work.

## Think about it

- If you changed the response for a successful `POST` to nest `items`
  inside a new `"order"` key instead of at the top level, would that
  break a client written against your current `CONTRACT.md`? Would
  adding a new, optional field to the response break it?
- Your validation rule for `items` entries is new. Could a client that
  was already sending valid data (non-empty strings) even notice this
  change happened?

## If you get stuck

- **Hint 1:** `curl -i` shows you the response status line and headers,
  not just the body — useful for confirming status codes by hand.
- **Hint 2:** The new validation goes in `do_POST`, checked right after
  the existing "must be a non-empty list" check, before the order is
  created.
- **Hint 3:** `all(isinstance(item, str) and item.strip() for item in
  items)` is one way to check every item is a non-empty string.

## What's next

Your API works — until you restart it and every order you created
disappears. Next, the data has to actually survive.

Continue to [Lab 22 — Code changed, old data remained](../22-data-outlives-code/README.md).
