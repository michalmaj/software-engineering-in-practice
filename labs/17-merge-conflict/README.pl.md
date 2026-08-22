# Lab 17 — Konflikt scalania

## Sytuacja

Obie funkcje są gotowe. Czas wprowadzić je do `main`, jedna po drugiej.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Zmergować gałąź bez konfliktów i rozpoznać, jak wygląda czysty merge.
- Odczytać znaczniki konfliktu Gita i zidentyfikować dokładnie, co
  zmieniła każda strona.
- Rozwiązać konflikt, łącząc obie zmiany, a nie ślepo wybierając jedną
  stronę.

## Zanim zaczniesz

- Lab 16 ukończony: `feature/low-stock-warning` i
  `feature/expiry-warning` obie istnieją, każda z przechodzącym
  zestawem testów.
- Bieżący katalog: `examples/team-inventory/`, na gałęzi `main`.

## Twoje zadanie

1. Potwierdź, że jesteś na `main`: `git switch main`.
2. Zmerguj pierwszą funkcję: `git merge feature/low-stock-warning`. To
   powinno zakończyć się bez żadnego konfliktu — przeczytaj komunikat,
   który wypisuje Git (prawdopodobnie fast-forward, bo `main` nie
   ruszył się, odkąd się rozgałęziłeś/aś).
3. Uruchom `uv run pytest -v`, żeby potwierdzić, że `main` ma teraz
   funkcję niskiego stanu i nadal przechodzi.
4. Zmerguj drugą funkcję: `git merge feature/expiry-warning`. To
   **spowoduje** konflikt — w **dwóch plikach**: `inventory.py` i
   `tests/test_inventory.py`.
5. Otwórz najpierw `inventory.py`. Znajdziesz dwa osobne bloki
   konfliktu oznaczone `<<<<<<< HEAD`, `=======` i `>>>>>>>
   feature/expiry-warning`: jeden, gdzie każda gałąź dodała własną
   nową funkcję, jeden wewnątrz `summarize`, gdzie każda gałąź dopisała
   własną linię. Przeczytaj obie strony każdego bloku, zanim czegokolwiek
   dotkniesz.
6. Rozwiąż oba bloki, zachowując **obie** zmiany — obie definicje
   nowych funkcji i obie linie dopisane wewnątrz `summarize` (w
   dowolnej kolejności). Usuń każdy znacznik konfliktu.
7. Otwórz `tests/test_inventory.py`. Też konfliktuje — na linii
   `import` (każda gałąź zaimportowała inną nową nazwę) i wewnątrz
   nowej funkcji testowej (każda gałąź nazwała ją inaczej i sprawdzała
   inną funkcję). Rozwiąż to, zachowując **oba** importy i **obie**
   funkcje testowe, każdą testującą własną funkcję.
8. Uruchom `uv run pytest -v`. Wszystkie trzy testy — oryginalny, ten
   od niskiego stanu i ten od terminu ważności — muszą przejść.
9. Dodaj oba rozwiązane pliki do stagingu i dokończ merge:
   `git add inventory.py tests/test_inventory.py`, potem `git commit`
   (Git wstępnie wypełnia komunikat merge'a; nie potrzebujesz `-m`).
10. Uruchom `git log --oneline --graph -5` i potwierdź, że obie
    funkcje są teraz częścią historii `main`.

## Kryteria akceptacji

- Żadne znaczniki konfliktu nie pozostają nigdzie w `inventory.py` ani
  w `tests/test_inventory.py`.
- Zarówno `low_stock_items`, jak i `expiring_items` są zdefiniowane i
  używane wewnątrz `summarize`.
- `uv run pytest` przechodzi z każdym testem z obu gałęzi obecnym
  (3 testy razem).
- Commit merge'a dla `feature/expiry-warning` istnieje na `main`.

## Weryfikacja

```bash
cd examples/team-inventory
grep -c '<<<<<<<\|=======\|>>>>>>>' inventory.py tests/test_inventory.py
uv run pytest -v
git log --oneline -4
cd -
```

Oczekiwane: `0` dla obu plików (brak wyniku dla pliku liczy się tu jako
błąd — to samo potwierdza, że nie pozostały w nim żadne znaczniki),
3 zaliczone testy i commit merge'a widoczny w logu.

## Zastanów się

- Żadna gałąź nie edytowała linii, którą edytowała też druga gałąź —
  obie tylko *dodały* nowe linie, w tym samym miejscu, w dwóch różnych
  plikach. Dlaczego Git mimo to potraktował oba pliki jako konflikt,
  zamiast po cichu zachować oba dodatki?
- Kolega z zespołu mówi "po prostu weź moje, usuń ich", nie czytając
  drugiej strony konfliktu. Jakie jest konkretne ryzyko takiego
  postępowania w tym przypadku — w każdym z plików?

## Jeśli utkniesz

- **Podpowiedź 1:** `<<<<<<< HEAD` oznacza początek wersji *Twojej
  bieżącej gałęzi*; `=======` dzieli obie strony; `>>>>>>>
  feature/expiry-warning` oznacza koniec wersji *nadchodzącej* gałęzi.
- **Podpowiedź 2:** `inventory.py` ma dwa osobne bloki konfliktu; plik
  testowy ma ich więcej, mniejszych (linia importu, nazwa funkcji,
  linia asercji), bo obie gałęzie edytowały te same kilka linii tej
  samej funkcji testowej. Rozwiąż każdy znaleziony blok — nie
  zatrzymuj się po pierwszym pliku.
- **Podpowiedź 3:** Po edycji oba pliki powinny zawierać zero linii
  `<<<<<<<`, `=======` ani `>>>>>>>` — jeśli `grep` cokolwiek znajdzie
  w którymkolwiek z nich, nie skończyłeś/aś.

## Co dalej

Rozwiązałeś/aś ten konflikt lokalnie, sam/a, potem dokończyłeś/aś merge
bezpośrednio na `main`. W prawdziwym zespole taka zmiana przeszłaby
przez review, zanim wylądowałaby na głównej gałęzi. Dalej zrobisz to
poprawnie.

Przejdź do [Lab 18 — Pull requesty i code review](../18-pull-requests-and-review/README.pl.md).
