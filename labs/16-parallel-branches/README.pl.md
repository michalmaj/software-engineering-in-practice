# Lab 16 — Branche istnieją, bo praca dzieje się równolegle

## Sytuacja

Ty i kolega z zespołu musicie dodać funkcję ostrzeżenia do skryptu
magazynu kuchennego, dziś, bez czekania na siebie nawzajem. Branche to
sposób, żebyście oboje zaczęli z tego samego miejsca i pracowali w tym
samym czasie, bez dotykania pracy drugiej osoby jeszcze.

To pierwszy lab w Akcie IV, i tak jak w Akcie II i Akcie III, Python,
Go i Java są tutaj wszystkie prawdziwymi, kompletnymi ścieżkami —
czytaj tylko swoją.

## Cele nauki

Po tym labie potrafisz:

- Utworzyć i przełączyć się na nowy branch z konkretnego punktu
  startowego.
- Wylistować istniejące branche i wyjaśnić, co każdy z nich zawiera.
- Przeczytać wynik `git log --all --graph` i zidentyfikować
  rozbieżną historię.

## Zanim zaczniesz

- Laby 06-15 ukończone, w Twojej wybranej ścieżce.
- Polecenia Gita w tym labie (`git switch`, `git branch`, `git merge`,
  `git commit`) operują na historii **całego repozytorium kursu**, nie
  na osobnym repozytorium wewnątrz folderu Twojego języka — branch,
  który tworzysz, jest branchem całego repo, nawet jeśli dotkniesz
  tylko plików pod katalogiem swojej własnej ścieżki.

### Python

- Bieżący katalog: `examples/team-inventory/python/`.
- Potwierdź, że starter działa: `uv run pytest -v` i `uv run python
  inventory.py`.

### Go

- Bieżący katalog: `examples/team-inventory/go/`.
- Potwierdź, że starter działa: `go test ./...` i `go run .`.

### Java

- Bieżący katalog: `examples/team-inventory/java/`.
- Potwierdź, że starter działa: `./gradlew test` i `./gradlew run
  --console=plain`.

## Twoje zadanie

Zagrasz obu "kolegów z zespołu" sam/a, jeden branch na raz. Punkt
startowy, nazwy branchy i kolejność są te same dla każdej ścieżki —
różni się tylko zawartość plików.

1. Potwierdź, że zaczynasz z czystego `main`: `git switch main` potem
   `git status --short`. Jeśli to coś wypisuje, zacommituj albo
   stashuj to najpierw — obie branche poniżej muszą zacząć z tego
   samego czystego punktu.

**Kolega A — ostrzeżenie o niskim stanie:**

2. Z `main`, utwórz i przełącz się na nowy branch:
   `git switch -c feature/low-stock-warning`.

### Python

3. W `inventory.py` dodaj
   `low_stock_items(inventory: list[dict], threshold: int = 5) -> list[str]`,
   zwracającą nazwy pozycji, których `quantity` jest poniżej
   `threshold`. Wstaw ją **bezpośrednio powyżej `summarize`**.
4. W `summarize`, zaraz po pętli `for` i przed linią `return`, dodaj:
   ```python
       low_stock = low_stock_items(inventory)
       if low_stock:
           lines.append(f"Low stock: {', '.join(low_stock)}")
   ```
5. W `tests/test_inventory.py` zmień import w pierwszej linii na
   `from inventory import low_stock_items, summarize`, potem dodaj
   test bezpośrednio po `test_summarize_lists_each_item_with_quantity`:
   ```python
   def test_low_stock_items_lists_items_below_threshold():
       inventory = [{"name": "Milk", "quantity": 2, "expires_in_days": 1}]

       result = low_stock_items(inventory)

       assert result == ["Milk"]
   ```
6. Uruchom `uv run pytest -v`, potem zacommituj wszystko na tym
   branchu.

### Go

3. W `inventory.go` dodaj
   `func LowStockItems(inventory []Item, threshold int) []string`,
   zwracającą nazwy pozycji, których `Quantity` jest poniżej
   `threshold` (w Go nie ma składni domyślnych argumentów, więc
   `threshold` jest zawsze podawany jawnie — przekażesz `5` z
   `Summarize`). Wstaw ją **bezpośrednio powyżej `Summarize`**.
4. W `Summarize`, zaraz po pętli `for` i przed linią `return`, dodaj:
   ```go
   	lowStock := LowStockItems(inventory, 5)
   	if len(lowStock) > 0 {
   		lines = append(lines, fmt.Sprintf("Low stock: %s", strings.Join(lowStock, ", ")))
   	}
   ```
5. W `inventory_test.go` dodaj test bezpośrednio po
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
6. Uruchom `gofmt -l .` (oczekiwane: brak wyniku) i `go test ./... -v`,
   potem zacommituj wszystko na tym branchu.

### Java

3. W `Inventory.java` dodaj
   `public static List<String> lowStockItems(List<Item> inventory, int threshold)`,
   zwracającą nazwy pozycji, których `quantity` jest poniżej
   `threshold`. Wstaw ją **bezpośrednio powyżej `summarize`**.
4. W `summarize`, zaraz po pętli `for` i przed linią `return`, dodaj:
   ```java
           List<String> lowStock = lowStockItems(inventory, 5);
           if (!lowStock.isEmpty()) {
               lines.add("Low stock: " + String.join(", ", lowStock));
           }
   ```
5. W `InventoryTest.java` dodaj test bezpośrednio po
   `summarizeListsEachItemWithQuantity`, i dodaj
   `import static org.junit.jupiter.api.Assertions.assertEquals;`
   obok istniejącego importu `assertTrue`:
   ```java
       @Test
       void lowStockItemsListsItemsBelowThreshold() {
           List<Inventory.Item> inventory = List.of(new Inventory.Item("Milk", 2, 1));

           List<String> result = Inventory.lowStockItems(inventory, 5);

           assertEquals(List.of("Milk"), result);
       }
   ```
6. Uruchom `./gradlew test`, potem zacommituj wszystko na tym branchu.

**Kolega B — ostrzeżenie o terminie ważności:**

7. Przełącz się z powrotem na `main` — **nie mergeuj jeszcze
   `feature/low-stock-warning`.**
8. Z `main`, utwórz i przełącz się na nowy branch:
   `git switch -c feature/expiry-warning`.

### Python

9. W `inventory.py` dodaj
   `expiring_items(inventory: list[dict], days: int = 3) -> list[str]`,
   zwracającą nazwy pozycji, których `expires_in_days` jest `<=`
   `days`. Wstaw ją **bezpośrednio powyżej `summarize`** — to samo
   miejsce co krok 3, bo zaczynasz z tego samego `main`, co kolega A.
10. W `summarize`, w **tym samym miejscu** co krok 4 (zaraz po pętli
    `for`, przed `return`), dodaj:
    ```python
        expiring = expiring_items(inventory)
        if expiring:
            lines.append(f"Expiring soon: {', '.join(expiring)}")
    ```
11. W `tests/test_inventory.py` zmień import w pierwszej linii na
    `from inventory import expiring_items, summarize`, potem dodaj
    test bezpośrednio po
    `test_summarize_lists_each_item_with_quantity` — to samo miejsce
    co krok 5:
    ```python
    def test_expiring_items_lists_items_within_days():
        inventory = [{"name": "Milk", "quantity": 2, "expires_in_days": 1}]

        result = expiring_items(inventory)

        assert result == ["Milk"]
    ```
12. Uruchom `uv run pytest -v`, potem zacommituj wszystko na tym
    branchu.

### Go

9. W `inventory.go` dodaj
   `func ExpiringItems(inventory []Item, days int) []string`, zwracającą
   nazwy pozycji, których `ExpiresInDays` jest `<=` `days`. Wstaw ją
   **bezpośrednio powyżej `Summarize`** — to samo miejsce co krok 3.
10. W `Summarize`, w **tym samym miejscu** co krok 4 (zaraz po pętli
    `for`, przed `return`), dodaj:
    ```go
    	expiring := ExpiringItems(inventory, 3)
    	if len(expiring) > 0 {
    		lines = append(lines, fmt.Sprintf("Expiring soon: %s", strings.Join(expiring, ", ")))
    	}
    ```
11. W `inventory_test.go` dodaj test bezpośrednio po
    `TestSummarizeListsEachItemWithQuantity` — to samo miejsce co krok
    5:
    ```go
    func TestExpiringItemsListsItemsWithinDays(t *testing.T) {
    	inventory := []Item{{Name: "Milk", Quantity: 2, ExpiresInDays: 1}}

    	result := ExpiringItems(inventory, 3)

    	if len(result) != 1 || result[0] != "Milk" {
    		t.Errorf("got %v, want [Milk]", result)
    	}
    }
    ```
12. Uruchom `gofmt -l .` i `go test ./... -v`, potem zacommituj
    wszystko na tym branchu.

### Java

9. W `Inventory.java` dodaj
   `public static List<String> expiringItems(List<Item> inventory, int days)`,
   zwracającą nazwy pozycji, których `expiresInDays` jest `<=` `days`.
   Wstaw ją **bezpośrednio powyżej `summarize`** — to samo miejsce co
   krok 3.
10. W `summarize`, w **tym samym miejscu** co krok 4 (zaraz po pętli
    `for`, przed `return`), dodaj:
    ```java
            List<String> expiring = expiringItems(inventory, 3);
            if (!expiring.isEmpty()) {
                lines.add("Expiring soon: " + String.join(", ", expiring));
            }
    ```
11. W `InventoryTest.java` dodaj test bezpośrednio po
    `summarizeListsEachItemWithQuantity` — to samo miejsce co krok 5
    (import `assertEquals` z brancha kolegi A tutaj nie istnieje, bo
    rozpocząłeś/aś od `main`; dodaj go w ten sam sposób):
    ```java
        @Test
        void expiringItemsListsItemsWithinDays() {
            List<Inventory.Item> inventory = List.of(new Inventory.Item("Milk", 2, 1));

            List<String> result = Inventory.expiringItems(inventory, 3);

            assertEquals(List.of("Milk"), result);
        }
    ```
12. Uruchom `./gradlew test`, potem zacommituj wszystko na tym
    branchu.

**Obie ścieżki:**

13. Uruchom `git branch` i `git log --all --graph --oneline -5`.
    Potwierdź, że obie branche istnieją, obie zaczynają od tego samego
    commita, i żadna nie zawiera jeszcze pracy drugiej.

## Kryteria akceptacji

- Obie branche `feature/low-stock-warning` i `feature/expiry-warning`
  istnieją, każda z dokładnie jednym commitem feature na tym samym
  commicie `main`.
- Przełączenie się na każdy branch osobno i uruchomienie komendy
  testowej Twojej ścieżki przechodzi na tym branchu samodzielnie.
- Plik źródłowy żadnego brancha nie zawiera funkcji/metody drugiego
  brancha.

## Weryfikacja

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

Oczekiwane: obie branche wylistowane, oba przebiegi testów przechodzą,
a `main` sam wciąż nie ma żadnej funkcji (to zadanie Lab 17).

## Zastanów się

- Rozgałęziłeś/aś `feature/expiry-warning` z `main`, nie z
  `feature/low-stock-warning`. Co byłoby inne w nadchodzącym merge,
  gdybyś rozgałęził/a go z `feature/low-stock-warning` zamiast tego?
- Obie branche zmieniły tę samą funkcję w tym samym miejscu. Czy Git
  widzi to teraz jako problem? Czemu tak albo czemu nie, na tym
  etapie?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** `git switch -c <name>` tworzy i przełącza się na
  branch w jednym kroku. Samo `git switch <name>` przełącza się na
  branch, który już istnieje.
- **Podpowiedź 2:** Upewnij się, że jesteś na `main` (`git branch`
  pokazuje `*` przy Twoim bieżącym branchu) przed utworzeniem każdego
  nowego brancha feature — jeśli rozgałęzisz B z A przez pomyłkę, B
  będzie już zawierać pracę A.
- **Podpowiedź 3:** I nowa funkcja pomocnicza (bezpośrednio powyżej
  `summarize`), i dwa wstawione bloki wewnątrz `summarize` (zaraz po
  pętli `for`) muszą trafić w dokładnie to samo miejsce w obu
  branchach, żeby następny lab zadziałał tak, jak opisano.

### Go

- **Podpowiedź 1:** `git switch -c <name>` tworzy i przełącza się na
  branch w jednym kroku. Samo `git switch <name>` przełącza się na
  branch, który już istnieje.
- **Podpowiedź 2:** Upewnij się, że jesteś na `main` (`git branch`
  pokazuje `*` przy Twoim bieżącym branchu) przed utworzeniem każdego
  nowego brancha feature — jeśli rozgałęzisz B z A przez pomyłkę, B
  będzie już zawierać pracę A.
- **Podpowiedź 3:** I nowa funkcja pomocnicza (bezpośrednio powyżej
  `Summarize`), i dwie wstawione linie wewnątrz `Summarize` (zaraz po
  pętli `for`) muszą trafić w dokładnie to samo miejsce w obu
  branchach, żeby następny lab zadziałał tak, jak opisano.

### Java

- **Podpowiedź 1:** `git switch -c <name>` tworzy i przełącza się na
  branch w jednym kroku. Samo `git switch <name>` przełącza się na
  branch, który już istnieje.
- **Podpowiedź 2:** Upewnij się, że jesteś na `main` (`git branch`
  pokazuje `*` przy Twoim bieżącym branchu) przed utworzeniem każdego
  nowego brancha feature — jeśli rozgałęzisz B z A przez pomyłkę, B
  będzie już zawierać pracę A.
- **Podpowiedź 3:** I nowa metoda pomocnicza (bezpośrednio powyżej
  `summarize`), i dwie wstawione linie wewnątrz `summarize` (zaraz po
  pętli `for`) muszą trafić w dokładnie to samo miejsce w obu
  branchach, żeby następny lab zadziałał tak, jak opisano.

## Co dalej

Obie funkcje istnieją. Żadna nie wie o drugiej. Dalej je połączysz — i
odkryjesz, że nie scalają się po cichu.

Przejdź do [Lab 17 — Konflikt merge'a](../17-merge-conflict/README.pl.md).
