# Lab 22 — Kod się zmienił, stare dane zostały

## Sytuacja

Za każdym razem, gdy restartujesz `order-api`, wszystkie zamówienia
znikają — istniały tylko w słowniku Pythona. Co gorsza: kuchnia właśnie
poprosiła o pole `notes` przy zamówieniach ("extra chrupiące", "bez
cebuli"), a Ty zaraz zmienisz schemat danych, które już istnieją.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Zastąpić stan w pamięci trwałym magazynem opartym na SQLite, nie
  zmieniając zewnętrznego kontraktu API.
- Napisać migrację, która dodaje kolumnę, nie niszcząc ani nie
  wywalając się na wierszach utworzonych przed istnieniem tej kolumny.
- Wyjaśnić, dlaczego "kod nadal działa" to nie to samo co "dane nadal
  są poprawne".

## Zanim zaczniesz

- Lab 21 ukończony: `CONTRACT.md` istnieje, walidacja pozycji działa,
  `uv run pytest` przechodzi z 4 testami.
- Bieżący katalog: `examples/order-api/`.

## Twoje zadanie

**Część 1 — trwałość danych (zachowująca zachowanie):**

1. Utwórz `db.py` z `init_db()` (tworzy tabelę `orders`, jeśli nie
   istnieje: `order_id INTEGER PRIMARY KEY AUTOINCREMENT, items TEXT
   NOT NULL, status TEXT NOT NULL`), `create_order(items: list) ->
   dict` oraz `get_order(order_id: str) -> dict | None` — używając
   `sqlite3` z biblioteki standardowej, przechowując `items` jako
   string JSON. Żadna z funkcji nie wie jeszcze o `notes` — to Część 2.
2. Przepisz `api.py`, żeby wywoływało `db.create_order`/`db.get_order`
   zamiast używać słownika `ORDERS`. Wywołaj `db.init_db()` raz, przy
   starcie serwera, w `run()`.
3. Zaktualizuj swój fixture testowy w `tests/test_api.py`, żeby
   wskazywał `db.DB_PATH` na świeży plik tymczasowy dla każdego testu
   (używając fixture'ów `tmp_path` i `monkeypatch` z pytest) i wywoływał
   `db.init_db()` przed uruchomieniem serwera — żeby testy nigdy nie
   dotykały Twojego prawdziwego `orders.db` ani nie przeciekały stanu
   między testami.
4. Uruchom cały zestaw testów. Wszystkie 4 istniejące testy muszą nadal
   przechodzić — ta część jest zachowująca zachowanie, dokładnie jak
   refaktor z Lab 06.

**Teraz udowodnij, że problem "starych danych" jest prawdziwy, zanim go rozwiążesz:**

5. Uruchom serwer naprawdę: `uv run python api.py`. W drugim terminalu
   utwórz jedno zamówienie:
   ```bash
   curl -s -X POST http://localhost:8000/orders \
     -H "Content-Type: application/json" -d '{"items": ["Burger"]}'
   ```
   Zanotuj `order_id`, który zwróci. Ten wiersz istnieje teraz w
   `orders.db`, w schemacie z Części 1 — bez żadnej kolumny `notes`.
   Zatrzymaj serwer (`Ctrl+C`), ale **nie usuwaj `orders.db`**.
5a. Zanim pójdziesz dalej, dodaj `*.db` do `.gitignore` repozytorium
    (utwórz plik w katalogu głównym, jeśli nie istnieje, albo dodaj
    linię, jeśli istnieje). `orders.db` to stan uruchomieniowy, który
    generuje Twój serwer — to nie jest kod źródłowy i nie powinien być
    commitowany. Potwierdź przez `git status`, że `orders.db` nie
    pojawia się już jako nieśledzony plik do dodania.

**Część 2 — ewolucja schematu:**

6. Dodaj `migrate_add_notes_column()` do `db.py`: sprawdź `PRAGMA
   table_info(orders)` pod kątem kolumny o nazwie `notes`, i jeśli jej
   brakuje, uruchom `ALTER TABLE orders ADD COLUMN notes TEXT`.
7. W `run()` wywołaj `db.migrate_add_notes_column()` zaraz po
   `db.init_db()`, żeby każdy start serwera zapewniał istnienie
   kolumny.
8. Zaktualizuj swój fixture testowy w `tests/test_api.py`, żeby też
   wywoływał `db.migrate_add_notes_column()` zaraz po `db.init_db()`,
   dokładnie tak jak przed chwilą zrobiłeś/aś w `run()`. Testy startują
   serwer bezpośrednio — nigdy nie przechodzą przez `run()` — więc jeśli
   to pominiesz, test `notes` dodawany w kroku 12 poniżej działa na
   bazie, która nigdy nie została zmigrowana, i tylko przypadkiem
   przejdzie (albo zawiedzie z mylącym błędem "no such column").
9. Zaktualizuj `create_order`, żeby przyjmowało opcjonalny parametr
   `notes: str = ""`, przechowując go i zwracając. Zaktualizuj
   `get_order`, żeby uwzględniało `notes` w wyniku, domyślnie `""`,
   jeśli przechowana wartość to `NULL` (co będzie miało miejsce dla
   wiersza utworzonego w kroku 5).
10. Zaktualizuj `do_POST` w `api.py`, żeby odczytywało opcjonalne pole
    `notes` z ciała żądania (domyślnie `""`) i przekazywało je dalej.
11. Zrestartuj serwer (`uv run python api.py` — ten sam plik
    `orders.db` z kroku 5). Wykonaj `GET` zamówienia utworzonego w
    kroku 5, po jego id:
    ```bash
    curl -s http://localhost:8000/orders/<the-id-from-step-5>
    ```
    Musi nadal zwrócić się poprawnie, z `notes` obecnym i równym
    `""` — nie brakującym, nie awarią. Zatrzymaj serwer.
12. Dodaj test tworzenia i pobierania *nowego* zamówienia z prawdziwą
    wartością `notes`.
13. Zaktualizuj `CONTRACT.md` z Lab 21: ciało żądania `POST /orders`
    teraz akceptuje opcjonalne pole `notes`, a każda odpowiedź (sukces
    i błąd) zwracająca zamówienie teraz zawiera `notes`.
14. Zrób pracę z tego labu na gałęzi (na przykład
    `feature/data-outlives-code`), wypchnij ją i otwórz pull request.
    Zmerguj dopiero, gdy check CI z Lab 21 jest zielony — pętla branch
    → PR → zielone CI → merge nadal obowiązuje dla `order-api` przez
    resztę Aktu V.

## Kryteria akceptacji

- `db.py` istnieje z `init_db`, `create_order`, `get_order` i
  `migrate_add_notes_column`.
- `uv run pytest` przechodzi ze wszystkimi 4 oryginalnymi testami plus
  Twoim nowym testem `notes` (5 razem).
- Zamówienie utworzone przed uruchomieniem
  `migrate_add_notes_column()` jest nadal pobieralne po niej, z
  `notes == ""`.
- Zmiany z tego labu zostały zmergowane przez pull request z zielonym
  checkiem CI, nie zacommitowane bezpośrednio na `main`.

## Weryfikacja

```bash
cd examples/order-api
uv run pytest -v
cd -
```

Oczekiwane: `5 passed`.

## Zastanów się

- Twoja migracja użyła `ALTER TABLE ... ADD COLUMN` bez klauzuli
  domyślnej, więc istniejące wiersze dostają `NULL`. Dlaczego
  musiałeś/aś obsłużyć ten `NULL` w kodzie Pythona `get_order`, zamiast
  po prostu naprawić to raz w bazie danych?
- Część 1 (SQLite zamiast słownika) w ogóle nie zmieniła
  `CONTRACT.md`. Część 2 (`notes`) zmieniła. Jaka jest różnica między
  tymi dwoma rodzajami zmian, z punktu widzenia wywołującego?

## Jeśli utkniesz

- **Podpowiedź 1:** `sqlite3.connect(path)` otwiera (i tworzy, jeśli
  brakuje) plik bazy danych. `conn.row_factory = sqlite3.Row` pozwala
  Ci uzyskać dostęp do kolumn po nazwie (`row["items"]`) zamiast po
  indeksie.
- **Podpowiedź 2:** `cur.lastrowid` po `INSERT` daje Ci automatycznie
  wygenerowany `order_id` dla tego wiersza.
- **Podpowiedź 3:** `PRAGMA table_info(orders)` zwraca po jednym
  wierszu na kolumnę, każdy z polem `name` — przejdź po nich pętlą,
  żeby sprawdzić, czy `notes` już istnieje, zanim spróbujesz dodać ją
  ponownie.

## Co dalej

Twoje dane przetrwają restarty i zmiany schematu. Dalej kuchnia chce
wysłać powiadomienie do zewnętrznego serwisu dostawy — a ten serwis nie
zawsze odpowiada.

Przejdź do [Lab 23 — Świat zewnętrzny zawodzi](../23-outside-world-fails/README.pl.md).
