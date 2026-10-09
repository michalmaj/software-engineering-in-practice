# Lab 16 — Branches exist because work happens in parallel

## Story

You and a teammate both need to add a warning feature to the kitchen
inventory script, today, without waiting for each other. Branches are
how you both start from the same place and work at the same time
without touching each other's work yet.

This is the first lab in Act IV, and like Act II and Act III, Python,
Go, and Java are all real, complete tracks here — read only your own.

## Learning objectives

After this lab you should be able to:

- Create and switch to a new branch from a specific starting point.
- List existing branches and explain what each one contains.
- Read `git log --all --graph` output and identify diverging history.

## Before you start

- Labs 06-15 complete, in your chosen track.
- Git commands in this lab (`git switch`, `git branch`, `git merge`,
  `git commit`) operate on the **whole course repository's** history,
  not on a separate repository inside your language's folder — a
  branch you create is a branch of the whole repo, even though you'll
  only touch files under your own track's directory.

### Python

- Current directory: `examples/team-inventory/python/`.
- Confirm the starter works: `uv run pytest -v` and `uv run python
  inventory.py`.

### Go

- Current directory: `examples/team-inventory/go/`.
- Confirm the starter works: `go test ./...` and `go run .`.

### Java

- Current directory: `examples/team-inventory/java/`.
- Confirm the starter works: `./gradlew test` and `./gradlew run
  --console=plain`.

## Your task

You'll play both "teammates" yourself, one branch at a time. The
starting point, the branch names, and the order are the same for every
track — only the file contents differ.

1. Confirm you're starting from a clean `main`: `git switch main` then
   `git status --short`. If that prints anything, commit or stash it
   first — both branches below need to start from the same clean
   point.

**Teammate A — low stock warning:**

2. From `main`, create and switch to a new branch:
   `git switch -c feature/low-stock-warning`.

### Python

3. In `inventory.py`, add
   `low_stock_items(inventory: list[dict], threshold: int = 5) -> list[str]`,
   returning the names of items whose `quantity` is below `threshold`.
   Insert it **immediately above `summarize`**.
4. In `summarize`, right after the `for` loop and before the `return`
   line, add:
   ```python
       low_stock = low_stock_items(inventory)
       if low_stock:
           lines.append(f"Low stock: {', '.join(low_stock)}")
   ```
5. In `tests/test_inventory.py`, change the import on the first line to
   `from inventory import low_stock_items, summarize`, then add a test
   directly after `test_summarize_lists_each_item_with_quantity`:
   ```python
   def test_low_stock_items_lists_items_below_threshold():
       inventory = [{"name": "Milk", "quantity": 2, "expires_in_days": 1}]

       result = low_stock_items(inventory)

       assert result == ["Milk"]
   ```
6. Run `uv run pytest -v`, then commit everything on this branch.

### Go

3. In `inventory.go`, add
   `func LowStockItems(inventory []Item, threshold int) []string`,
   returning the names of items whose `Quantity` is below `threshold`
   (there's no default-argument syntax in Go, so `threshold` is always
   passed explicitly — you'll pass `5` from `Summarize`). Insert it
   **immediately above `Summarize`**.
4. In `Summarize`, right after the `for` loop and before the `return`
   line, add:
   ```go
   	lowStock := LowStockItems(inventory, 5)
   	if len(lowStock) > 0 {
   		lines = append(lines, fmt.Sprintf("Low stock: %s", strings.Join(lowStock, ", ")))
   	}
   ```
5. In `inventory_test.go`, add a test directly after
   `TestSummarizeListsEachItemWithQuantity`:
   ```go
   func TestLowStockItemsListsItemsBelowThreshold(t *testing.T) {
   	inventory := []Item{{Name: "Milk", Quantity: 2, ExpiresInDays: 1}}

   	result := LowStockItems(inventory, 5)

   	if len(result) != 1 || result[0] != "Milk" {
   		t.Errorf("got %v, want [Milk]", result)
   	}
   }
   ```
6. Run `gofmt -l .` (expect no output) and `go test ./... -v`, then
   commit everything on this branch.

### Java

3. In `Inventory.java`, add
   `public static List<String> lowStockItems(List<Item> inventory, int threshold)`,
   returning the names of items whose `quantity` is below `threshold`.
   Insert it **immediately above `summarize`**.
4. In `summarize`, right after the `for` loop and before the `return`
   line, add:
   ```java
           List<String> lowStock = lowStockItems(inventory, 5);
           if (!lowStock.isEmpty()) {
               lines.add("Low stock: " + String.join(", ", lowStock));
           }
   ```
5. In `InventoryTest.java`, add a test directly after
   `summarizeListsEachItemWithQuantity`, and add
   `import static org.junit.jupiter.api.Assertions.assertEquals;`
   alongside the existing `assertTrue` import:
   ```java
       @Test
       void lowStockItemsListsItemsBelowThreshold() {
           List<Inventory.Item> inventory = List.of(new Inventory.Item("Milk", 2, 1));

           List<String> result = Inventory.lowStockItems(inventory, 5);

           assertEquals(List.of("Milk"), result);
       }
   ```
6. Run `./gradlew test`, then commit everything on this branch.

**Teammate B — expiry warning:**

7. Switch back to `main` — **do not merge `feature/low-stock-warning`
   yet.**
8. From `main`, create and switch to a new branch:
   `git switch -c feature/expiry-warning`.

### Python

9. In `inventory.py`, add
   `expiring_items(inventory: list[dict], days: int = 3) -> list[str]`,
   returning the names of items whose `expires_in_days` is `<=` `days`.
   Insert it **immediately above `summarize`** — the same location as
   step 3, since you're starting from the same `main` teammate A did.
10. In `summarize`, at the **same location** as step 4 (right after the
    `for` loop, before `return`), add:
    ```python
        expiring = expiring_items(inventory)
        if expiring:
            lines.append(f"Expiring soon: {', '.join(expiring)}")
    ```
11. In `tests/test_inventory.py`, change the import on the first line to
    `from inventory import expiring_items, summarize`, then add a test
    directly after `test_summarize_lists_each_item_with_quantity` —
    the same location as step 5:
    ```python
    def test_expiring_items_lists_items_within_days():
        inventory = [{"name": "Milk", "quantity": 2, "expires_in_days": 1}]

        result = expiring_items(inventory)

        assert result == ["Milk"]
    ```
12. Run `uv run pytest -v`, then commit everything on this branch.

### Go

9. In `inventory.go`, add
   `func ExpiringItems(inventory []Item, days int) []string`, returning
   the names of items whose `ExpiresInDays` is `<=` `days`. Insert it
   **immediately above `Summarize`** — the same location as step 3.
10. In `Summarize`, at the **same location** as step 4 (right after the
    `for` loop, before `return`), add:
    ```go
    	expiring := ExpiringItems(inventory, 3)
    	if len(expiring) > 0 {
    		lines = append(lines, fmt.Sprintf("Expiring soon: %s", strings.Join(expiring, ", ")))
    	}
    ```
11. In `inventory_test.go`, add a test directly after
    `TestSummarizeListsEachItemWithQuantity` — the same location as
    step 5:
    ```go
    func TestExpiringItemsListsItemsWithinDays(t *testing.T) {
    	inventory := []Item{{Name: "Milk", Quantity: 2, ExpiresInDays: 1}}

    	result := ExpiringItems(inventory, 3)

    	if len(result) != 1 || result[0] != "Milk" {
    		t.Errorf("got %v, want [Milk]", result)
    	}
    }
    ```
12. Run `gofmt -l .` and `go test ./... -v`, then commit everything on
    this branch.

### Java

9. In `Inventory.java`, add
   `public static List<String> expiringItems(List<Item> inventory, int days)`,
   returning the names of items whose `expiresInDays` is `<=` `days`.
   Insert it **immediately above `summarize`** — the same location as
   step 3.
10. In `summarize`, at the **same location** as step 4 (right after the
    `for` loop, before `return`), add:
    ```java
            List<String> expiring = expiringItems(inventory, 3);
            if (!expiring.isEmpty()) {
                lines.add("Expiring soon: " + String.join(", ", expiring));
            }
    ```
11. In `InventoryTest.java`, add a test directly after
    `summarizeListsEachItemWithQuantity` — the same location as step 5
    (the `assertEquals` import from teammate A's branch doesn't exist
    here, since you branched from `main`; add it the same way):
    ```java
        @Test
        void expiringItemsListsItemsWithinDays() {
            List<Inventory.Item> inventory = List.of(new Inventory.Item("Milk", 2, 1));

            List<String> result = Inventory.expiringItems(inventory, 3);

            assertEquals(List.of("Milk"), result);
        }
    ```
12. Run `./gradlew test`, then commit everything on this branch.

**Both tracks:**

13. Run `git branch` and `git log --all --graph --oneline -5`. Confirm
    both branches exist, both start from the same commit, and neither
    contains the other's work yet.

## Acceptance criteria

- Both `feature/low-stock-warning` and `feature/expiry-warning` exist
  as branches, each with exactly one feature commit on top of the same
  `main` commit.
- Checking out either branch individually and running your track's
  test command passes on that branch alone.
- Neither branch's source file contains the other branch's
  function/method.

## Verification

### Python

```bash
cd examples/team-inventory/python
git branch
git log --all --graph --oneline -5
git switch feature/low-stock-warning && uv run pytest -v
git switch feature/expiry-warning && uv run pytest -v
git switch main
cd -
```

### Go

```bash
cd examples/team-inventory/go
git branch
git log --all --graph --oneline -5
git switch feature/low-stock-warning && go test ./... -v
git switch feature/expiry-warning && go test ./... -v
git switch main
cd -
```

### Java

```bash
cd examples/team-inventory/java
git branch
git log --all --graph --oneline -5
git switch feature/low-stock-warning && ./gradlew test
git switch feature/expiry-warning && ./gradlew test
git switch main
cd -
```

Expected: both branches listed, both test runs pass, and `main` itself
still has neither feature (that's Lab 17's job).

## Think about it

- You branched `feature/expiry-warning` from `main`, not from
  `feature/low-stock-warning`. What would be different about the
  upcoming merge if you'd branched it from `feature/low-stock-warning`
  instead?
- Both branches changed the same function at the same spot. Right now,
  does Git see that as a problem? Why or why not, at this stage?

## If you get stuck

### Python

- **Hint 1:** `git switch -c <name>` creates and switches to a branch
  in one step. Plain `git switch <name>` switches to a branch that
  already exists.
- **Hint 2:** Make sure you're on `main` (`git branch` shows a `*` next
  to your current branch) before creating each new feature branch —
  if you branch B from A by mistake, B will already contain A's work.
- **Hint 3:** Both the new helper function (immediately above
  `summarize`) and the two inserted blocks inside `summarize` (right
  after the `for` loop) must go in the exact same place in both
  branches for the next lab to work as described.

### Go

- **Hint 1:** `git switch -c <name>` creates and switches to a branch
  in one step. Plain `git switch <name>` switches to a branch that
  already exists.
- **Hint 2:** Make sure you're on `main` (`git branch` shows a `*` next
  to your current branch) before creating each new feature branch —
  if you branch B from A by mistake, B will already contain A's work.
- **Hint 3:** Both the new helper function (immediately above
  `Summarize`) and the two inserted lines inside `Summarize` (right
  after the `for` loop) must go in the exact same place in both
  branches for the next lab to work as described.

### Java

- **Hint 1:** `git switch -c <name>` creates and switches to a branch
  in one step. Plain `git switch <name>` switches to a branch that
  already exists.
- **Hint 2:** Make sure you're on `main` (`git branch` shows a `*` next
  to your current branch) before creating each new feature branch —
  if you branch B from A by mistake, B will already contain A's work.
- **Hint 3:** Both the new helper method (immediately above
  `summarize`) and the two inserted lines inside `summarize` (right
  after the `for` loop) must go in the exact same place in both
  branches for the next lab to work as described.

## What's next

Both features exist. Neither knows about the other. Next, you bring
them together — and discover they don't just merge quietly.

Continue to [Lab 17 — The merge conflict](../17-merge-conflict/README.md).
