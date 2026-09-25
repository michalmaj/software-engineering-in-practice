# Lab 16 — Gałęzie istnieją, bo praca dzieje się równolegle

## Sytuacja

Ty i kolega z zespołu musicie dodać funkcję ostrzegawczą do skryptu
inwentaryzacji kuchni, dziś, nie czekając na siebie nawzajem. Gałęzie
to sposób, żeby oboje zaczęli w tym samym miejscu i pracowali w tym
samym czasie, na razie nie dotykając nawzajem swojej pracy.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Utworzyć i przełączyć się na nową gałąź z konkretnego punktu startowego.
- Wylistować istniejące gałęzie i wyjaśnić, co zawiera każda z nich.
- Odczytać wynik `git log --all --graph` i zidentyfikować rozchodzącą
  się historię.

## Zanim zaczniesz

- Laby 06-15 ukończone.
- Bieżący katalog: `examples/team-inventory/`.
- Potwierdź, że starter działa: `uv run pytest -v` i `uv run python
  inventory.py`.

## Twoje zadanie

Zagrasz oboje "kolegów z zespołu" sam/a, jedna gałąź na raz.

1. Potwierdź, że zaczynasz od czystego `main`: `git switch main`, potem
   `git status --short`. Jeśli coś wypisze, zacommituj to albo zrób
   stash, zanim przejdziesz dalej — obie gałęzie poniżej muszą zaczynać
   się z tego samego, czystego punktu.

**Kolega A — ostrzeżenie o niskim stanie:**

2. Z `main` utwórz i przełącz się na nową gałąź:
   `git switch -c feature/low-stock-warning`.
3. W `inventory.py` dodaj
   `low_stock_items(inventory: list[dict], threshold: int = 5) -> list[str]`,
   zwracającą nazwy pozycji, których `quantity` jest poniżej `threshold`.
   Wstaw ją **bezpośrednio nad `summarize`**.
4. W `summarize`, zaraz po pętli `for` i przed linią `return`, dodaj:
   ```python
       low_stock = low_stock_items(inventory)
       if low_stock:
           lines.append(f"Low stock: {', '.join(low_stock)}")
   ```
5. W `tests/test_inventory.py` zmień import w pierwszej linii na
   `from inventory import low_stock_items, summarize`, potem dodaj test
   bezpośrednio po `test_summarize_lists_each_item_with_quantity`:
   ```python
   def test_low_stock_items_lists_items_below_threshold():
       inventory = [{"name": "Milk", "quantity": 2, "expires_in_days": 1}]

       result = low_stock_items(inventory)

       assert result == ["Milk"]
   ```
6. Uruchom testy, potem zacommituj wszystko na tej gałęzi.

**Kolega B — ostrzeżenie o terminie ważności:**

7. Wróć do `main` — **jeszcze nie scalaj `feature/low-stock-warning`.**
8. Z `main` utwórz i przełącz się na nową gałąź:
   `git switch -c feature/expiry-warning`.
9. W `inventory.py` dodaj
   `expiring_items(inventory: list[dict], days: int = 3) -> list[str]`,
   zwracającą nazwy pozycji, których `expires_in_days` jest `<=` `days`.
   Wstaw ją **bezpośrednio nad `summarize`** — to samo miejsce co w
   kroku 3, bo zaczynasz z tego samego `main`, co kolega A.
10. W `summarize`, w **tym samym miejscu** co w kroku 4 (zaraz po pętli
    `for`, przed `return`), dodaj:
    ```python
        expiring = expiring_items(inventory)
        if expiring:
            lines.append(f"Expiring soon: {', '.join(expiring)}")
    ```
11. W `tests/test_inventory.py` zmień import w pierwszej linii na
    `from inventory import expiring_items, summarize`, potem dodaj test
    bezpośrednio po `test_summarize_lists_each_item_with_quantity` — to
    samo miejsce co w kroku 5:
    ```python
    def test_expiring_items_lists_items_within_days():
        inventory = [{"name": "Milk", "quantity": 2, "expires_in_days": 1}]

        result = expiring_items(inventory)

        assert result == ["Milk"]
    ```
12. Uruchom testy, potem zacommituj wszystko na tej gałęzi.

13. Uruchom `git branch` i `git log --all --graph --oneline -5`.
    Potwierdź, że obie gałęzie istnieją, obie zaczynają się od tego
    samego commita, i żadna nie zawiera jeszcze pracy tej drugiej.

## Kryteria akceptacji

- Zarówno `feature/low-stock-warning`, jak i `feature/expiry-warning`
  istnieją jako gałęzie, każda z dokładnie jednym commitem feature na
  tym samym commicie `main`.
- Przełączenie się na każdą gałąź osobno i uruchomienie `uv run pytest`
  przechodzi na tej gałęzi samodzielnie.
- Żadna gałąź nie zawiera funkcji tej drugiej w `inventory.py`.

## Weryfikacja

```bash
cd examples/team-inventory
git branch
git log --all --graph --oneline -5
git switch feature/low-stock-warning && uv run pytest -v
git switch feature/expiry-warning && uv run pytest -v
git switch main
cd -
```

Oczekiwane: obie gałęzie wylistowane, oba przebiegi testów przechodzą,
a `main` nadal nie ma żadnej z funkcji (to zadanie Lab 17).

## Zastanów się

- Rozgałęziłeś/aś `feature/expiry-warning` z `main`, a nie z
  `feature/low-stock-warning`. Co byłoby inaczej w nadchodzącym mergu,
  gdybyś zamiast tego rozgałęził/a ją z `feature/low-stock-warning`?
- Obie gałęzie zmieniły `summarize` w tym samym miejscu. Czy na tym
  etapie Git widzi w tym problem? Dlaczego tak albo dlaczego nie?

## Jeśli utkniesz

- **Podpowiedź 1:** `git switch -c <nazwa>` tworzy i przełącza na
  gałąź w jednym kroku. Zwykłe `git switch <nazwa>` przełącza na
  gałąź, która już istnieje.
- **Podpowiedź 2:** Upewnij się, że jesteś na `main` (`git branch`
  pokazuje `*` przy Twojej bieżącej gałęzi), zanim utworzysz każdą
  nową gałąź funkcji — jeśli przez pomyłkę rozgałęzisz B z A, B będzie
  już zawierać pracę A.
- **Podpowiedź 3:** Zarówno nowa funkcja pomocnicza (bezpośrednio nad
  `summarize`), jak i oba wstawione bloki wewnątrz `summarize` (zaraz
  po pętli `for`) muszą trafić w dokładnie to samo miejsce w obu
  gałęziach, żeby kolejny lab zadziałał tak, jak opisano.

## Co dalej

Obie funkcje istnieją. Żadna nie wie o drugiej. Dalej połączysz je
razem — i odkryjesz, że nie scalają się po cichu.

Przejdź do [Lab 17 — Konflikt scalania](../17-merge-conflict/README.pl.md).
