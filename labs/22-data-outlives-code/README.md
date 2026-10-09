# Lab 22 — Code changed, old data remained

## Story

Every time you restart `order-api`, all the orders vanish — they were
only ever living in memory. Worse: the kitchen just asked for a
`notes` field on orders ("extra crispy", "no onions"), and you're
about to change the schema of data that already exists.

## Learning objectives

After this lab you should be able to:

- Replace in-memory state with a persistent SQLite-backed store without
  changing the API's external contract.
- Write a migration that adds a column without destroying or crashing
  on rows created before that column existed.
- Test persistence with proper test-database isolation, so tests never
  touch your real data and never leak state between runs.
- Explain why "the code still runs" is not the same as "the data is
  still correct."

## Before you start

### Python

- Lab 21 complete: `CONTRACT.md` exists, item validation works, `uv
  run pytest` passes with 4 tests.
- Current directory: `examples/order-api/python/`.

### Go

- Lab 21 complete: `CONTRACT.md` exists, item validation works, `go
  test ./...` passes with 4 tests.
- Current directory: `examples/order-api/go/`.

### Java

- Lab 21 complete: `CONTRACT.md` exists, item validation works,
  `./gradlew test` passes with 4 tests.
- Current directory: `examples/order-api/java/`.

## Your task

**Part 1 — persistence (behavior-preserving):**

### Step 1 — add a SQLite storage layer

Every track uses the same minimal schema from here on:

```sql
CREATE TABLE IF NOT EXISTS orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    items TEXT NOT NULL,
    status TEXT NOT NULL
)
```

`items` is stored as a JSON string — nothing in SQLite needs to know
it's a list. There's no `notes` column yet; that's Part 2.

#### Python

Create `db.py` with:

- `DB_PATH = os.environ.get("ORDER_DB_PATH", "orders.db")` at module
  level.
- `init_db()` — creates the `orders` table above if it doesn't exist,
  using `sqlite3` from the standard library.
- `create_order(items: list) -> dict` — inserts a row and returns the
  new order as a dict (`order_id` as a string, `status` as
  `"received"`).
- `get_order(order_id: str) -> dict | None` — looks up a row by id,
  returning `None` if it doesn't exist.

#### Go

Add the SQLite driver. From `examples/order-api/go/`, run:

```bash
go get modernc.org/sqlite@v1.60.1
```

This is a pure-Go driver — no C compiler, no system SQLite install, no
CGO — so it behaves identically on Windows, Linux, and macOS. The
command updates `go.mod` and creates/updates `go.sum`; commit both.
The first run downloads the module and its dependencies, which can
take anywhere from a few seconds to a minute depending on your
connection.

Create `db.go` with:

- A blank import so the driver registers itself:
  `_ "modernc.org/sqlite"`.
- `dbPath() string` — returns `os.Getenv("ORDER_DB_PATH")` if set,
  otherwise `"orders.db"`.
- `openDB() (*sql.DB, error)` — calls `sql.Open("sqlite", dbPath())`
  and stores the result in a package-level `*sql.DB` variable (`*sql.DB`
  is its own connection pool — it's already safe for concurrent use,
  so you won't need a `sync.Mutex` the way the in-memory map did).
- `initDB() error` — runs the `CREATE TABLE IF NOT EXISTS` statement
  above via `Exec`.
- `createOrder(items []any) (Order, error)` — marshals `items` to JSON,
  inserts a row, and reads the generated id back with
  `result.LastInsertId()`.
- `getOrder(id string) (Order, bool, error)` — queries by id, returning
  `false` for "not found" (a non-numeric `id` like `"does-not-exist"`
  just fails to match any row — SQLite won't error on the type
  mismatch).

#### Java

Add the SQLite driver. Open `build.gradle` and add this line to the
existing `dependencies { ... }` block, right after the Gson line:

```groovy
implementation 'org.xerial:sqlite-jdbc:3.53.4.0'
```

This jar bundles native SQLite libraries for Windows, Linux, and macOS
(including Apple Silicon) — there's nothing extra to install. The next
`./gradlew` command downloads it automatically, the same way Gson and
JUnit were downloaded in earlier labs.

Create `OrderDb.java` with static methods:

- `dbPath() -> String` — returns `System.getenv("ORDER_DB_PATH")` if
  set, otherwise `"orders.db"`.
- `connect() -> Connection` — `DriverManager.getConnection("jdbc:sqlite:" +
  dbPath())`.
- `initDb() throws SQLException` — runs the `CREATE TABLE IF NOT
  EXISTS` statement above.
- `createOrder(List<Object> items, String notes) -> Order` — inserts a
  row with a `PreparedStatement`, using
  `Statement.RETURN_GENERATED_KEYS` to read back the new `order_id`.
  Ignore the `notes` parameter for now (don't store it) — Part 1's
  table has no `notes` column yet; you'll wire this up properly in
  Part 2.
- `getOrder(String id) -> Order` (or `null` if not found) — queries by
  id with a `PreparedStatement`.

Use `try-with-resources` for every `Connection`, `PreparedStatement`,
and `ResultSet` you open.

### Step 2 — wire the HTTP handlers to the new storage

#### Python

Rewrite `api.py` to call `db.create_order`/`db.get_order` instead of
using the `ORDERS` dict. Call `db.init_db()` once, at server startup,
in `run()`.

#### Go

Rewrite `api.go`'s `handleCreateOrder`/`handleGetOrder` to call your
new `createOrder`/`getOrder` instead of the `orders` map — and delete
the now-unused `mu sync.Mutex`, `orders map[string]Order`, and
`nextID` package variables entirely; `*sql.DB` replaces all three. In
`main()`, call `openDB()` then `initDB()` before `http.ListenAndServe`,
handling any error by printing it and exiting (same pattern `main()`
already uses for the server's own `ListenAndServe` error).

#### Java

Rewrite `ApiServer.java`'s `handleCreateOrder`/`handleGetOrder` to call
`OrderDb.createOrder`/`OrderDb.getOrder` instead of the
`ConcurrentHashMap`/`AtomicInteger` fields — delete those two fields.
Catch `SQLException` around the database calls and respond with `500`
on failure. In `Main.java`, call `OrderDb.initDb()` before
`server.start()`, and add `throws SQLException` to `main`'s signature.

### Step 3 — isolate your tests from your real database

Tests must never touch your real `orders.db`, and must never leak
state between test runs. Every track uses the same convention: the
database path is normally controlled by the `ORDER_DB_PATH`
environment variable (defaulting to `orders.db` when unset), and tests
point it at a fresh file in a temporary directory instead.

#### Python

In `tests/test_api.py`, use pytest's `tmp_path` and `monkeypatch`
fixtures to set `db.DB_PATH` to a file inside `tmp_path` before
calling `db.init_db()` and starting the server under test.

#### Go

In `api_test.go`, at the top of `newTestServer`, call
`os.Setenv("ORDER_DB_PATH", filepath.Join(t.TempDir(), "test.db"))`
before calling `openDB()` and `initDB()` — `dbPath()` reads the
environment variable fresh each time, so this is enough to point a
test at its own throwaway file. Change `newTestServer` to take
`t *testing.T` (it needs it for `t.TempDir()`), and update every
existing call site to pass `t`.

#### Java

A JVM can't un-set an environment variable it already read, so
`ApiServerTest.java` uses a system property as a test-only override
that takes priority over `ORDER_DB_PATH`. Change `OrderDb.dbPath()` to
check `System.getProperty("order.db.path")` first, then
`System.getenv("ORDER_DB_PATH")`, then fall back to `"orders.db"`. In
the test class, add a `@TempDir Path tempDir` field, and in
`@BeforeEach` (before `startServer()`), call
`System.setProperty("order.db.path", tempDir.resolve("test.db").toString())`
followed by `OrderDb.initDb()`. In `@AfterEach` (after `stopServer()`),
call `System.clearProperty("order.db.path")`.

### Step 4 — run the full suite

All of Lab 21's tests must still pass — this part is behavior-
preserving, exactly like Lab 06's refactor.

#### Python

```bash
uv run pytest -v
```

#### Go

```bash
go test ./... -v
```

#### Java

```bash
./gradlew test
```

Expected: 4 passed, same as at the end of Lab 21.

**Now prove the "old data" problem is real, before you solve it.**

Never fake this part with a hand-written JSON file pretending to be an
old record — the whole point is seeing a schema change land on a row
that a genuinely earlier version of your code created. **Don't delete
your database file at any point between here and the end of Part 2.**

### Step 5 — create a real order, then stop the server

Start the server for real, in Terminal A:

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

In Terminal B, create one order:

```bash
curl -s -X POST http://localhost:8000/orders \
  -H "Content-Type: application/json" -d '{"items": ["Burger"]}'
```

Write down the `order_id` it returns — you'll need it in the next two
steps, and again in Part 2. Stop the server in Terminal A (`Ctrl+C`),
but leave the database file in place.

### Step 6 — restart, and confirm the order survived

Start the server again, the same way you did in Step 5 — same command,
same directory, same database file. In Terminal B, fetch the order you
just created. The example below uses `1`; replace it with your own
order's actual id from Step 5 if it's different:

```bash
curl -s http://localhost:8000/orders/1
```

It must come back with `status: "received"` and the same `items` you
posted — this is the restart that proves Part 1 actually works, not
just that the tests pass. Stop the server again, still keeping the
database file.

### Step 7 — protect the database file in Git

Check the repository's root `.gitignore`: `*.db` (and SQLite's sidecar
files, `*.db-journal`/`*.db-wal`/`*.db-shm`) should already be ignored.
If it isn't — for example because you forked this repository before
this protection was added — add those four lines yourself. Either way,
confirm with `git status` that your database file doesn't show up as
untracked. It's runtime state your server generates, not source code,
and it should never be committed.

**Part 2 — schema evolution:**

### Step 8 — write the migration

#### Python

Add `migrate_add_notes_column()` to `db.py`: check `PRAGMA
table_info(orders)` for a column named `notes`, and if it's missing,
run `ALTER TABLE orders ADD COLUMN notes TEXT`. If it's already there,
do nothing — running this twice must be safe.

#### Go

Add `migrateAddNotesColumn() error` to `db.go`: run `PRAGMA
table_info(orders)` via `Query`, scan each row's `name` column to check
whether `"notes"` is already present, and if not, run `ALTER TABLE
orders ADD COLUMN notes TEXT`. If it's already there, do nothing.

#### Java

Add `migrateAddNotesColumn() throws SQLException` to `OrderDb.java`:
run `PRAGMA table_info(orders)`, read each row's `name` column via
`ResultSet.getString("name")` to check whether `"notes"` is already
present, and if not, run `ALTER TABLE orders ADD COLUMN notes TEXT`. If
it's already there, do nothing.

No ORM, no Flyway, no Liquibase, no migration framework — this one
`ALTER TABLE`, guarded by a check, is the entire migration.

### Step 9 — run the migration at startup

#### Python

In `run()`, call `db.migrate_add_notes_column()` right after
`db.init_db()`, so every server start ensures the column exists.

#### Go

In `main()`, call `migrateAddNotesColumn()` right after `initDB()`,
handling an error the same way you handled `initDB()`'s.

#### Java

In `Main.java`, call `OrderDb.migrateAddNotesColumn()` right after
`OrderDb.initDb()`.

### Step 10 — run the migration in your tests too

Your tests start the server directly — they never go through
`main`/`run()` — so if you skip this, the `notes` test you add in
Step 16 runs against a database that was never migrated, and either
fails with a confusing "no such column" error or only passes by
accident.

#### Python

In your `tests/test_api.py` fixture, call
`db.migrate_add_notes_column()` right after `db.init_db()`.

#### Go

In `newTestServer`, call `migrateAddNotesColumn()` right after
`initDB()`.

#### Java

In `ApiServerTest.java`'s `@BeforeEach`, call
`OrderDb.migrateAddNotesColumn()` right after `OrderDb.initDb()`.

### Step 11 — teach your storage layer about `notes`

#### Python

Update `create_order` to accept an optional `notes: str = ""`
parameter, storing and returning it. Update `get_order` to include
`notes` in its result, defaulting to `""` if the stored value is
`NULL` (which it will be for the row you created in Step 5).

#### Go

Give `Order` a `Notes string` field (JSON tag `notes`). Update
`createOrder` to take a `notes string` parameter, storing and
returning it. Update `getOrder` to read the `notes` column with
`sql.NullString`, converting a `NULL`/invalid value to `""` (which it
will be for the row you created in Step 5) before putting it on the
returned `Order`.

#### Java

Give `Order` a `final String notes` field and update its constructor
to take it. Update `createOrder` to take a `String notes` parameter,
storing and returning it. Update `getOrder` to read the `notes` column
with `ResultSet.getString`, defaulting to `""` when the value is `null`
(which it will be for the row you created in Step 5 — `ResultSet
.getString` returns Java `null` for a SQL `NULL`).

### Step 12 — accept `notes` from the request body

#### Python

Update `do_POST` in `api.py` to read an optional `notes` field from the
request body (defaulting to `""`) and pass it through to
`db.create_order`.

#### Go

Update `handleCreateOrder` to read an optional `notes` field from the
decoded body (`body["notes"].(string)`, defaulting to `""` if absent or
not a string) and pass it through to `createOrder`.

#### Java

Update `handleCreateOrder` to read an optional `notes` field from the
parsed body (`data.get("notes")`, defaulting to `""` if absent or not a
`String`) and pass it through to `OrderDb.createOrder`.

### Step 13 — restart, and read the historical order

Restart the server — same database file you've been using since
Step 5. Fetch the order you created back then, by its actual id
(replace `1` below if yours is different):

```bash
curl -s http://localhost:8000/orders/1
```

It must still return successfully, now with `notes` present and equal
to `""` — not missing, not a crash. This is the moment the migration
proves itself against a row it didn't create.

### Step 14 — create and fetch a new order with real notes

With the server still running, create a new order that actually sets
`notes`:

```bash
curl -s -X POST http://localhost:8000/orders \
  -H "Content-Type: application/json" \
  -d '{"items": ["Burger"], "notes": "no onions"}'
```

Note this order's id too, then fetch it:

```bash
curl -s http://localhost:8000/orders/<new-order-id>
```

Confirm `notes` comes back as `"no onions"`, unchanged. Stop the
server.

### Step 15 — restart once more, and confirm nothing broke

Start the server a final time — same database file. Fetch both orders
again (the historical one from Step 5 and the new one from Step 14):
both must return correctly, with their respective `notes` values
unchanged. This restart also re-runs your migration function against a
database that's already migrated — if it crashed or duplicated the
column, you'd see it here. Stop the server.

### Step 16 — add a test for the new field

#### Python

Add a test to `tests/test_api.py` confirming that `POST /orders` with
a `notes` value, followed by `GET` on the returned id, returns that
same `notes` value.

#### Go

Add a test to `api_test.go` confirming the same thing. Follow the
shape of `TestPostThenGetOrder`.

#### Java

Add a test to `ApiServerTest.java` confirming the same thing. Follow
the shape of `postThenGetOrder`.

### Step 17 — update the contract

Update `CONTRACT.md` from Lab 21: `POST /orders`'s request body now
accepts an optional `notes` field, and every response that returns an
order (success and, where applicable, error) now includes `notes`.
For example:

Request: `{"items": ["Burger"], "notes": "no onions"}`

Response: `{"order_id": "4", "items": ["Burger"], "status": "received",
"notes": "no onions"}` (your own `order_id` will depend on how many
orders you've created in this session — don't assume it's always
`"1"`). If `notes` is omitted from the request, or the order predates
this migration, it comes back as `""` — never missing, never `null`.

### Step 18 — branch, PR, review, merge

Do this lab's work on a branch (for example
`feature/data-outlives-code`), push it, and open a pull request. Merge
only once the CI check from Lab 21 is green — the branch → PR → green
CI → merge loop keeps applying to `order-api` for the rest of Act V.

## Acceptance criteria

- A SQLite-backed storage layer exists (`db.py` for Python, `db.go` for
  Go, `OrderDb.java` for Java) with: schema creation, `notes`
  migration, order creation, and order lookup.
- All of Lab 21's tests still pass, plus a new `notes` test (5 total).
- An order created before the `notes` migration ran is still fetchable
  afterward, with `notes == ""`.
- A freshly created order with a real `notes` value roundtrips through
  `POST` then `GET` unchanged, and survives a server restart.
- Running the migration against an already-migrated database doesn't
  crash and doesn't change existing data.
- `CONTRACT.md` reflects the new optional `notes` field.
- This lab's changes were merged through a pull request with a green
  CI check, not committed directly to `main`.

## Verification

### Python

```bash
cd examples/order-api/python
uv run pytest -v
cd -
```

### Go

```bash
cd examples/order-api/go
go test ./... -v
cd -
```

### Java

```bash
cd examples/order-api/java
./gradlew test
cd -
```

Expected: 5 passed (or the Gradle equivalent) — plus everything you
confirmed by hand in Steps 5, 6, 13, 14, and 15, which no test suite
alone would have caught if you'd skipped the real restarts.

## Think about it

- Your migration used `ALTER TABLE ... ADD COLUMN` with no default
  clause, so existing rows get `NULL`. Why did you have to handle that
  `NULL` in your own code, instead of just fixing it in the database
  once?
- Part 1 (SQLite instead of in-memory state) didn't change
  `CONTRACT.md` at all. Part 2 (`notes`) did. What's the difference
  between these two kinds of change, from a caller's point of view?
- You ran the migration check at every startup, instead of once, by
  hand, the first time you needed it. What would've gone wrong if a
  teammate pulled your change and started the server without ever
  running a separate "migrate" command?

## If you get stuck

### Python

- **Hint 1:** `sqlite3.connect(path)` opens (and creates, if missing) a
  database file. `conn.row_factory = sqlite3.Row` lets you access
  columns by name (`row["items"]`) instead of by index.
- **Hint 2:** `cur.lastrowid` after an `INSERT` gives you the
  auto-generated `order_id` for that row.
- **Hint 3:** `PRAGMA table_info(orders)` returns one row per column,
  each with a `name` field — loop over it to check whether `notes`
  already exists before trying to add it again.

### Go

- **Hint 1:** Register the driver with a blank import —
  `import _ "modernc.org/sqlite"` — then `sql.Open("sqlite", path)`.
  `sql.Open` doesn't actually connect; nothing fails until the first
  real query, so call `db.Ping()` right after opening if you want to
  fail fast on a bad path.
- **Hint 2:** `result, err := conn.Exec(...)` followed by
  `result.LastInsertId()` gives you the auto-generated `order_id` as an
  `int64` — convert it with `strconv.FormatInt(id, 10)`.
- **Hint 3:** `rows, err := conn.Query("PRAGMA table_info(orders)")`
  returns one row per column; `rows.Scan` needs a destination for
  every column `PRAGMA table_info` returns (`cid`, `name`, `type`,
  `notnull`, `dflt_value`, `pk`) even though you only care about
  `name`.
- **Hint 4:** `sql.NullString` has a `.Valid` field — `false` means the
  database value was `NULL`, which is exactly the case you need to
  turn into `""`.

### Java

- **Hint 1:** `DriverManager.getConnection("jdbc:sqlite:" + path)`
  opens (and creates, if missing) a database file. sqlite-jdbc
  registers itself automatically — you don't need `Class.forName(...)`.
- **Hint 2:** `statement.executeUpdate(sql, Statement
  .RETURN_GENERATED_KEYS)` followed by `statement.getGeneratedKeys()`
  gives you a `ResultSet` with the auto-generated `order_id` in its
  first column.
- **Hint 3:** `ResultSet.getString("name")` on each row of `PRAGMA
  table_info(orders)` gives you the column name — loop with
  `while (rs.next())` to check whether `"notes"` already exists.
- **Hint 4:** `ResultSet.getString("notes")` returns Java `null` for a
  SQL `NULL` — no exception, no sentinel value, just `null`. Check for
  it before handing the value to your JSON serializer.

## What's next

Your data survives restarts and schema changes, in whichever track you
followed. From here, Go and Java pause as a preview — Labs 23-25 are
Python-only for now, the same way Labs 11-30 stayed Python-only after
Act II and Act III's previews. Everything you just practiced about
persistence, migration, and test isolation still applies to whatever
comes next, in any language.

If you're continuing in Python: the kitchen wants a notification sent
to an external delivery service — and that service doesn't always
answer.

Continue to [Lab 23 — The outside world fails](../23-outside-world-fails/README.md).
