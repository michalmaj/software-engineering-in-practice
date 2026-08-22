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

**Kolega A — ostrzeżenie o niskim stanie:**

1. Z `main` utwórz i przełącz się na nową gałąź:
   `git switch -c feature/low-stock-warning`.
2. W `inventory.py` dodaj:
   `low_stock_items(inventory: list[dict], threshold: int = 5) -> list[str]`
   zwracającą nazwy pozycji, których `quantity` jest poniżej `threshold`.
3. W `summarize`, zaraz po pętli `for` i przed linią `return`, dodaj:
   ```python
       low_stock = low_stock_items(inventory)
       if low_stock:
           lines.append(f"Low stock: {', '.join(low_stock)}")
   ```
4. Dodaj test dla `low_stock_items` w `tests/test_inventory.py`.
5. Uruchom testy, potem zacommituj wszystko na tej gałęzi.

**Kolega B — ostrzeżenie o terminie ważności:**

6. Wróć do `main` — **jeszcze nie mergúj `feature/low-stock-warning`.**
7. Z `main` utwórz i przełącz się na nową gałąź:
   `git switch -c feature/expiry-warning`.
8. W `inventory.py` dodaj:
   `expiring_items(inventory: list[dict], days: int = 3) -> list[str]`
   zwracającą nazwy pozycji, których `expires_in_days` jest `<=` `days`.
9. W `summarize`, w **tym samym miejscu** co w kroku 3 (zaraz po pętli
   `for`, przed `return`), dodaj:
   ```python
       expiring = expiring_items(inventory)
       if expiring:
           lines.append(f"Expiring soon: {', '.join(expiring)}")
   ```
10. Dodaj test dla `expiring_items`. Uruchom testy, potem zacommituj
    wszystko na tej gałęzi.

11. Uruchom `git branch` i `git log --all --graph --oneline -5`.
    Potwierdź, że obie gałęzie istnieją, obie zaczynają się od tego
    samego commita, i żadna nie zawiera jeszcze pracy tej drugiej.

## Kryteria akceptacji

- Zarówno `feature/low-stock-warning`, jak i `feature/expiry-warning`
  istnieją jako gałęzie, każda z jednym commitem na tym samym commicie
  `main`.
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
- **Podpowiedź 3:** Oba wstawione bloki w `summarize` muszą trafić w
  dokładnie to samo miejsce (zaraz po pętli `for`) w obu gałęziach,
  żeby kolejny lab zadziałał tak, jak opisano.

## Co dalej

Obie funkcje istnieją. Żadna nie wie o drugiej. Dalej połączysz je
razem — i odkryjesz, że nie scalają się po cichu.

Przejdź do [Lab 17 — Konflikt scalania](../17-merge-conflict/README.pl.md).
