# Lab 22 — Code changed, old data remained

## Story

Every time you restart `order-api`, all the orders vanish — they were
only ever living in a Python dict. Worse: the kitchen just asked for a
`notes` field on orders ("extra crispy", "no onions"), and you're about
to change the schema of data that already exists.

## Learning objectives

After this lab you should be able to:

- Replace in-memory state with a persistent SQLite-backed store without
  changing the API's external contract.
- Write a migration that adds a column without destroying or crashing
  on rows created before that column existed.
- Explain why "the code still runs" is not the same as "the data is
  still correct."

## Before you start

- Lab 21 complete: `CONTRACT.md` exists, item validation works, `uv
  run pytest` passes with 4 tests.
- Current directory: `examples/order-api/`.

## Your task

**Part 1 — persistence (behavior-preserving):**

1. Create `db.py` with `init_db()` (creates an `orders` table if it
   doesn't exist: `order_id INTEGER PRIMARY KEY AUTOINCREMENT, items
   TEXT NOT NULL, status TEXT NOT NULL`), `create_order(items: list) ->
   dict`, and `get_order(order_id: str) -> dict | None` — using
   `sqlite3` from the standard library, storing `items` as a JSON
   string. Neither function knows about `notes` yet — that's Part 2.
2. Rewrite `api.py` to call `db.create_order`/`db.get_order` instead of
   using the `ORDERS` dict. Call `db.init_db()` once, at server
   startup, in `run()`.
3. Update your test fixture in `tests/test_api.py` to point `db.DB_PATH`
   at a fresh temporary file per test (using pytest's `tmp_path` and
   `monkeypatch` fixtures) and call `db.init_db()` before starting the
   server — so tests never touch your real `orders.db`, and never leak
   state between tests.
4. Run the full suite. All 4 existing tests must still pass — this
   part is behavior-preserving, exactly like Lab 06's refactor.

**Now prove the "old data" problem is real, before you solve it:**

5. Start the server for real: `uv run python api.py`. In a second
   terminal, create one order:
   ```bash
   curl -s -X POST http://localhost:8000/orders \
     -H "Content-Type: application/json" -d '{"items": ["Burger"]}'
   ```
   Note the `order_id` it returns. This row now exists in `orders.db`,
   in the schema from Part 1 — with no `notes` column at all. Stop the
   server (`Ctrl+C`), but **do not delete `orders.db`**.
5a. Before going further, add `*.db` to the repository's `.gitignore`
    (create the file at the repo root if it doesn't exist, or add the
    line if it does). `orders.db` is runtime state your server
    generates — it isn't source code, and it shouldn't be committed.
    Confirm with `git status` that `orders.db` no longer shows up as an
    untracked file to add.

**Part 2 — schema evolution:**

6. Add `migrate_add_notes_column()` to `db.py`: check
   `PRAGMA table_info(orders)` for a column named `notes`, and if it's
   missing, run `ALTER TABLE orders ADD COLUMN notes TEXT`.
7. In `run()`, call `db.migrate_add_notes_column()` right after
   `db.init_db()`, so every server start ensures the column exists.
8. Update `create_order` to accept an optional `notes: str = ""`
   parameter, storing and returning it. Update `get_order` to include
   `notes` in its result, defaulting to `""` if the stored value is
   `NULL` (which it will be for the row you created in step 5).
9. Update `do_POST` in `api.py` to read an optional `notes` field from
   the request body (defaulting to `""`) and pass it through.
10. Restart the server (`uv run python api.py` — same `orders.db` file
    from step 5). `GET` the order you created in step 5, by its id:
    ```bash
    curl -s http://localhost:8000/orders/<the-id-from-step-5>
    ```
    It must still return successfully, with `notes` present and equal
    to `""` — not missing, not a crash. Stop the server.
11. Add a test for creating and fetching a *new* order with a real
    `notes` value.
12. Update `CONTRACT.md` from Lab 21: the `POST /orders` request body
    now accepts an optional `notes` field, and every response
    (success and error) that returns an order now includes `notes`.

## Acceptance criteria

- `db.py` exists with `init_db`, `create_order`, `get_order`, and
  `migrate_add_notes_column`.
- `uv run pytest` passes with all 4 original tests plus your new
  `notes` test (5 total).
- An order created before `migrate_add_notes_column()` ran is still
  fetchable afterward, with `notes == ""`.

## Verification

```bash
cd examples/order-api
uv run pytest -v
cd -
```

Expected: `5 passed`.

## Think about it

- Your migration used `ALTER TABLE ... ADD COLUMN` with no default
  clause, so existing rows get `NULL`. Why did you have to handle that
  `NULL` in `get_order`'s Python code, instead of just fixing it in the
  database once?
- Part 1 (SQLite instead of a dict) didn't change `CONTRACT.md` at all.
  Part 2 (`notes`) did. What's the difference between these two kinds
  of change, from a caller's point of view?

## If you get stuck

- **Hint 1:** `sqlite3.connect(path)` opens (and creates, if missing) a
  database file. `conn.row_factory = sqlite3.Row` lets you access
  columns by name (`row["items"]`) instead of by index.
- **Hint 2:** `cur.lastrowid` after an `INSERT` gives you the
  auto-generated `order_id` for that row.
- **Hint 3:** `PRAGMA table_info(orders)` returns one row per column,
  each with a `name` field — loop over it to check whether `notes`
  already exists before trying to add it again.

## What's next

Your data survives restarts and schema changes. Next, the kitchen
wants a notification sent to an external delivery service — and that
service doesn't always answer.

Continue to [Lab 23 — The outside world fails](../23-outside-world-fails/README.md).
