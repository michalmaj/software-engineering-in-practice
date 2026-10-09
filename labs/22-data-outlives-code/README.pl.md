# Lab 22 — Kod się zmienił, stare dane zostały

## Sytuacja

Za każdym razem, gdy restartujesz `order-api`, wszystkie zamówienia
znikają — istniały tylko w pamięci. Co gorsza: kuchnia właśnie
poprosiła o pole `notes` przy zamówieniach ("extra chrupiące", "bez
cebuli"), a Ty zaraz zmienisz schemat danych, które już istnieją.

## Cele nauki

Po tym labie potrafisz:

- Zastąpić stan w pamięci trwałym magazynem opartym na SQLite, nie
  zmieniając zewnętrznego kontraktu API.
- Napisać migrację, która dodaje kolumnę, nie niszcząc ani nie
  wywalając się na wierszach utworzonych przed istnieniem tej kolumny.
- Testować trwałość danych z właściwą izolacją bazy testowej, żeby
  testy nigdy nie dotykały Twoich prawdziwych danych i nigdy nie
  przeciekały stanu między uruchomieniami.
- Wyjaśnić, dlaczego "kod nadal działa" to nie to samo co "dane nadal
  są poprawne".

## Zanim zaczniesz

### Python

- Lab 21 ukończony: `CONTRACT.md` istnieje, walidacja pozycji działa,
  `uv run pytest` przechodzi z 4 testami.
- Bieżący katalog: `examples/order-api/python/`.

### Go

- Lab 21 ukończony: `CONTRACT.md` istnieje, walidacja pozycji działa,
  `go test ./...` przechodzi z 4 testami.
- Bieżący katalog: `examples/order-api/go/`.

### Java

- Lab 21 ukończony: `CONTRACT.md` istnieje, walidacja pozycji działa,
  `./gradlew test` przechodzi z 4 testami.
- Bieżący katalog: `examples/order-api/java/`.

## Twoje zadanie

**Część 1 — trwałość danych (zachowująca zachowanie):**

### Krok 1 — dodaj warstwę przechowywania SQLite

Od teraz każdy track używa tego samego minimalnego schematu:

```sql
CREATE TABLE IF NOT EXISTS orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    items TEXT NOT NULL,
    status TEXT NOT NULL
)
```

`items` przechowywane jest jako string JSON — SQLite nie musi wiedzieć,
że to lista. Nie ma jeszcze kolumny `notes` — to Część 2.

#### Python

Utwórz `db.py` z:

- `DB_PATH = os.environ.get("ORDER_DB_PATH", "orders.db")` na poziomie
  modułu.
- `init_db()` — tworzy tabelę `orders` powyżej, jeśli nie istnieje,
  używając `sqlite3` z biblioteki standardowej.
- `create_order(items: list) -> dict` — wstawia wiersz i zwraca nowe
  zamówienie jako dict (`order_id` jako string, `status` jako
  `"received"`).
- `get_order(order_id: str) -> dict | None` — wyszukuje wiersz po id,
  zwracając `None`, jeśli nie istnieje.

#### Go

Dodaj sterownik SQLite. Z `examples/order-api/go/` uruchom:

```bash
go get modernc.org/sqlite@v1.60.1
```

To sterownik napisany w czystym Go — bez kompilatora C, bez
instalowania systemowego SQLite, bez CGO — więc zachowuje się
identycznie na Windows, Linuksie i macOS. Komenda aktualizuje `go.mod`
i tworzy/aktualizuje `go.sum`; zacommituj oba. Pierwsze uruchomienie
pobiera moduł i jego zależności, co może zająć od kilku sekund do
minuty, zależnie od Twojego połączenia.

Utwórz `db.go` z:

- Importem spod znaku podkreślenia, żeby sterownik się zarejestrował:
  `_ "modernc.org/sqlite"`.
- `dbPath() string` — zwraca `os.Getenv("ORDER_DB_PATH")`, jeśli jest
  ustawiona, inaczej `"orders.db"`.
- `openDB() (*sql.DB, error)` — wywołuje `sql.Open("sqlite", dbPath())`
  i zapisuje wynik w zmiennej `*sql.DB` na poziomie pakietu (`*sql.DB`
  jest własnym poolem połączeń — jest już bezpieczny do współbieżnego
  użycia, więc nie będziesz potrzebować `sync.Mutex`, tak jak mapa w
  pamięci).
- `initDB() error` — uruchamia powyższe `CREATE TABLE IF NOT EXISTS`
  przez `Exec`.
- `createOrder(items []any) (Order, error)` — serializuje `items` do
  JSON, wstawia wiersz i odczytuje wygenerowane id przez
  `result.LastInsertId()`.
- `getOrder(id string) (Order, bool, error)` — wyszukuje po id,
  zwracając `false` dla "nie znaleziono" (id nienumeryczne, takie jak
  `"does-not-exist"`, po prostu nie trafia w żaden wiersz — SQLite nie
  wywali się na niezgodności typu).

#### Java

Dodaj sterownik SQLite. Otwórz `build.gradle` i dodaj tę linię do
istniejącego bloku `dependencies { ... }`, zaraz po linii z Gson:

```groovy
implementation 'org.xerial:sqlite-jdbc:3.53.4.0'
```

Ten jar zawiera natywne biblioteki SQLite dla Windows, Linuksa i macOS
(włącznie z Apple Silicon) — nie trzeba niczego instalować osobno.
Następna komenda `./gradlew` pobiera go automatycznie, tak jak Gson i
JUnit zostały pobrane w wcześniejszych labach.

Utwórz `OrderDb.java` ze statycznymi metodami:

- `dbPath() -> String` — zwraca `System.getenv("ORDER_DB_PATH")`,
  jeśli jest ustawiona, inaczej `"orders.db"`.
- `connect() -> Connection` — `DriverManager.getConnection("jdbc:sqlite:" +
  dbPath())`.
- `initDb() throws SQLException` — uruchamia powyższe `CREATE TABLE IF
  NOT EXISTS`.
- `createOrder(List<Object> items, String notes) -> Order` — wstawia
  wiersz przez `PreparedStatement`, używając
  `Statement.RETURN_GENERATED_KEYS`, żeby odczytać nowe `order_id`.
  Zignoruj na razie parametr `notes` (nie przechowuj go) — tabela z
  Części 1 nie ma jeszcze kolumny `notes`; podłączysz to poprawnie w
  Części 2.
- `getOrder(String id) -> Order` (albo `null`, jeśli nie znaleziono) —
  wyszukuje po id przez `PreparedStatement`.

Używaj `try-with-resources` dla każdego otwartego `Connection`,
`PreparedStatement` i `ResultSet`.

### Krok 2 — podłącz handlery HTTP do nowego magazynu

#### Python

Przepisz `api.py`, żeby wywoływało `db.create_order`/`db.get_order`
zamiast używać słownika `ORDERS`. Wywołaj `db.init_db()` raz, przy
starcie serwera, w `run()`.

#### Go

Przepisz `handleCreateOrder`/`handleGetOrder` w `api.go`, żeby
wywoływały nowe `createOrder`/`getOrder` zamiast mapy `orders` — i
usuń całkowicie teraz-nieużywane zmienne pakietu `mu sync.Mutex`,
`orders map[string]Order` i `nextID`; `*sql.DB` zastępuje wszystkie
trzy. W `main()` wywołaj `openDB()`, a potem `initDB()`, przed
`http.ListenAndServe`, obsługując ewentualny błąd tak samo, jak
`main()` już obsługuje błąd własnego `ListenAndServe`.

#### Java

Przepisz `handleCreateOrder`/`handleGetOrder` w `ApiServer.java`, żeby
wywoływały `OrderDb.createOrder`/`OrderDb.getOrder` zamiast pól
`ConcurrentHashMap`/`AtomicInteger` — usuń te dwa pola. Przechwyć
`SQLException` wokół wywołań bazy i odpowiedz `500` w razie awarii. W
`Main.java` wywołaj `OrderDb.initDb()` przed `server.start()` i dodaj
`throws SQLException` do sygnatury `main`.

### Krok 3 — odizoluj testy od prawdziwej bazy danych

Testy nigdy nie mogą dotykać Twojego prawdziwego `orders.db` i nigdy
nie mogą przeciekać stanu między uruchomieniami testów. Każdy track
używa tej samej konwencji: ścieżka bazy danych jest normalnie
kontrolowana zmienną środowiskową `ORDER_DB_PATH` (domyślnie
`orders.db`, jeśli nieustawiona), a testy wskazują ją na świeży plik w
katalogu tymczasowym.

#### Python

W `tests/test_api.py` użyj fixture'ów `tmp_path` i `monkeypatch` z
pytest, żeby ustawić `db.DB_PATH` na plik wewnątrz `tmp_path` przed
wywołaniem `db.init_db()` i uruchomieniem testowanego serwera.

#### Go

W `api_test.go`, na początku `newTestServer`, wywołaj
`os.Setenv("ORDER_DB_PATH", filepath.Join(t.TempDir(), "test.db"))`
przed wywołaniem `openDB()` i `initDB()` — `dbPath()` odczytuje
zmienną środowiskową na nowo każdym razem, więc to wystarczy, żeby
wskazać test na jego własny jednorazowy plik. Zmień `newTestServer`,
żeby przyjmowało `t *testing.T` (potrzebne do `t.TempDir()`), i
zaktualizuj każde istniejące miejsce wywołania, żeby przekazywało `t`.

#### Java

JVM nie może odznaczyć zmiennej środowiskowej, którą już odczytała,
więc `ApiServerTest.java` używa property systemowej jako testowego
nadpisania, które ma priorytet nad `ORDER_DB_PATH`. Zmień
`OrderDb.dbPath()`, żeby sprawdzało najpierw
`System.getProperty("order.db.path")`, potem
`System.getenv("ORDER_DB_PATH")`, a na końcu wracało do
`"orders.db"`. W klasie testowej dodaj pole `@TempDir Path tempDir` i w
`@BeforeEach` (przed `startServer()`) wywołaj
`System.setProperty("order.db.path", tempDir.resolve("test.db").toString())`,
a potem `OrderDb.initDb()`. W `@AfterEach` (po `stopServer()`) wywołaj
`System.clearProperty("order.db.path")`.

### Krok 4 — uruchom cały zestaw testów

Wszystkie testy z Lab 21 muszą nadal przechodzić — ta część jest
zachowująca zachowanie, dokładnie jak refaktor z Lab 06.

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

Oczekiwane: 4 testy przechodzą, tak jak na koniec Lab 21.

**Teraz udowodnij, że problem "starych danych" jest prawdziwy, zanim go
rozwiążesz.**

Nigdy nie symuluj tej części ręcznie napisanym plikiem JSON udającym
stary wiersz — cały sens polega na zobaczeniu zmiany schematu
lądującej na wierszu, który naprawdę utworzyła wcześniejsza wersja
Twojego kodu. **Nie usuwaj pliku bazy danych w żadnym momencie między
tym miejscem a końcem Części 2.**

### Krok 5 — stwórz prawdziwe zamówienie, potem zatrzymaj serwer

Uruchom serwer naprawdę, w Terminalu A:

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

W Terminalu B utwórz jedno zamówienie:

```bash
curl -s -X POST http://localhost:8000/orders \
  -H "Content-Type: application/json" -d '{"items": ["Burger"]}'
```

Zapisz `order_id`, który zwróci — będziesz go potrzebować w dwóch
następnych krokach, a potem jeszcze raz w Części 2. Zatrzymaj serwer w
Terminalu A (`Ctrl+C`), ale zostaw plik bazy danych na miejscu.

### Krok 6 — zrestartuj i potwierdź, że zamówienie przetrwało

Uruchom serwer jeszcze raz, tak samo jak w Kroku 5 — ta sama komenda,
ten sam katalog, ten sam plik bazy danych. W Terminalu B pobierz
zamówienie, które właśnie utworzyłeś/aś. Poniższy przykład używa `1`;
zastąp go swoim rzeczywistym id zamówienia z Kroku 5, jeśli jest inne:

```bash
curl -s http://localhost:8000/orders/1
```

Musi wrócić z `status: "received"` i tymi samymi `items`, które
wysłałeś/aś — to ten restart, który dowodzi, że Część 1 naprawdę
działa, nie tylko że testy przechodzą. Zatrzymaj serwer jeszcze raz,
wciąż zachowując plik bazy danych.

### Krok 7 — zabezpiecz plik bazy danych w Git

Sprawdź `.gitignore` w katalogu głównym repozytorium: `*.db` (i pliki
pomocnicze SQLite: `*.db-journal`/`*.db-wal`/`*.db-shm`) powinny już
być ignorowane. Jeśli nie są — na przykład bo zforkowałeś/aś to
repozytorium przed dodaniem tej ochrony — dodaj te cztery linie
samodzielnie. W każdym przypadku potwierdź przez `git status`, że Twój
plik bazy danych nie pojawia się jako nieśledzony. To stan
uruchomieniowy, który generuje Twój serwer, nie kod źródłowy, i nigdy
nie powinien być commitowany.

**Część 2 — ewolucja schematu:**

### Krok 8 — napisz migrację

#### Python

Dodaj `migrate_add_notes_column()` do `db.py`: sprawdź `PRAGMA
table_info(orders)` pod kątem kolumny o nazwie `notes`, i jeśli jej
brakuje, uruchom `ALTER TABLE orders ADD COLUMN notes TEXT`. Jeśli już
istnieje, nic nie rób — uruchomienie tego dwa razy musi być bezpieczne.

#### Go

Dodaj `migrateAddNotesColumn() error` do `db.go`: uruchom `PRAGMA
table_info(orders)` przez `Query`, zeskanuj kolumnę `name` każdego
wiersza, żeby sprawdzić, czy `"notes"` już jest obecna, i jeśli nie,
uruchom `ALTER TABLE orders ADD COLUMN notes TEXT`. Jeśli już istnieje,
nic nie rób.

#### Java

Dodaj `migrateAddNotesColumn() throws SQLException` do
`OrderDb.java`: uruchom `PRAGMA table_info(orders)`, odczytaj kolumnę
`name` każdego wiersza przez `ResultSet.getString("name")`, żeby
sprawdzić, czy `"notes"` już jest obecna, i jeśli nie, uruchom `ALTER
TABLE orders ADD COLUMN notes TEXT`. Jeśli już istnieje, nic nie rób.

Żadnego ORM, żadnego Flyway, żadnego Liquibase, żadnego frameworka do
migracji — ten jeden `ALTER TABLE`, zabezpieczony sprawdzeniem, to cała
migracja.

### Krok 9 — uruchamiaj migrację przy starcie

#### Python

W `run()` wywołaj `db.migrate_add_notes_column()` zaraz po
`db.init_db()`, żeby każdy start serwera zapewniał istnienie kolumny.

#### Go

W `main()` wywołaj `migrateAddNotesColumn()` zaraz po `initDB()`,
obsługując błąd tak samo, jak obsłużyłeś/aś błąd `initDB()`.

#### Java

W `Main.java` wywołaj `OrderDb.migrateAddNotesColumn()` zaraz po
`OrderDb.initDb()`.

### Krok 10 — uruchamiaj migrację też w testach

Twoje testy startują serwer bezpośrednio — nigdy nie przechodzą przez
`main`/`run()` — więc jeśli to pominiesz, test `notes` dodawany w
Kroku 16 działa na bazie, która nigdy nie została zmigrowana, i albo
zawiedzie z mylącym błędem "no such column", albo przejdzie tylko
przypadkiem.

#### Python

W fixture `tests/test_api.py` wywołaj `db.migrate_add_notes_column()`
zaraz po `db.init_db()`.

#### Go

W `newTestServer` wywołaj `migrateAddNotesColumn()` zaraz po
`initDB()`.

#### Java

W `@BeforeEach` w `ApiServerTest.java` wywołaj
`OrderDb.migrateAddNotesColumn()` zaraz po `OrderDb.initDb()`.

### Krok 11 — nauczy swoją warstwę przechowywania o `notes`

#### Python

Zaktualizuj `create_order`, żeby przyjmowało opcjonalny parametr
`notes: str = ""`, przechowując go i zwracając. Zaktualizuj
`get_order`, żeby uwzględniało `notes` w wyniku, domyślnie `""`, jeśli
przechowana wartość to `NULL` (co będzie miało miejsce dla wiersza
utworzonego w Kroku 5).

#### Go

Daj `Order` pole `Notes string` (tag JSON `notes`). Zaktualizuj
`createOrder`, żeby przyjmowało parametr `notes string`, przechowując
go i zwracając. Zaktualizuj `getOrder`, żeby odczytywało kolumnę
`notes` przez `sql.NullString`, konwertując wartość `NULL`/nieprawidłową
na `""` (co będzie miało miejsce dla wiersza utworzonego w Kroku 5),
zanim trafi do zwracanego `Order`.

#### Java

Daj `Order` pole `final String notes` i zaktualizuj jego konstruktor,
żeby je przyjmował. Zaktualizuj `createOrder`, żeby przyjmowało
parametr `String notes`, przechowując go i zwracając. Zaktualizuj
`getOrder`, żeby odczytywało kolumnę `notes` przez
`ResultSet.getString`, domyślnie `""`, jeśli wartość to `null` (co
będzie miało miejsce dla wiersza utworzonego w Kroku 5 —
`ResultSet.getString` zwraca Javowe `null` dla SQL-owego `NULL`).

### Krok 12 — przyjmuj `notes` z ciała żądania

#### Python

Zaktualizuj `do_POST` w `api.py`, żeby odczytywało opcjonalne pole
`notes` z ciała żądania (domyślnie `""`) i przekazywało je dalej do
`db.create_order`.

#### Go

Zaktualizuj `handleCreateOrder`, żeby odczytywało opcjonalne pole
`notes` z zdekodowanego ciała (`body["notes"].(string)`, domyślnie
`""`, jeśli brakuje albo nie jest stringiem) i przekazywało je dalej do
`createOrder`.

#### Java

Zaktualizuj `handleCreateOrder`, żeby odczytywało opcjonalne pole
`notes` z sparsowanego ciała (`data.get("notes")`, domyślnie `""`,
jeśli brakuje albo nie jest `String`) i przekazywało je dalej do
`OrderDb.createOrder`.

### Krok 13 — zrestartuj i odczytaj historyczne zamówienie

Zrestartuj serwer — ten sam plik bazy danych, który używasz od Kroku
5. Pobierz zamówienie, które utworzyłeś/aś wtedy, po jego rzeczywistym
id (zastąp `1` poniżej, jeśli Twoje jest inne):

```bash
curl -s http://localhost:8000/orders/1
```

Musi nadal zwrócić się poprawnie, teraz z `notes` obecnym i równym
`""` — nie brakującym, nie awarią. To jest moment, w którym migracja
dowodzi swojej wartości na wierszu, którego nie utworzyła.

### Krok 14 — utwórz i pobierz nowe zamówienie z prawdziwymi notes

Przy wciąż działającym serwerze utwórz nowe zamówienie, które
rzeczywiście ustawia `notes`:

```bash
curl -s -X POST http://localhost:8000/orders \
  -H "Content-Type: application/json" \
  -d '{"items": ["Burger"], "notes": "no onions"}'
```

Zanotuj też id tego zamówienia, a potem je pobierz:

```bash
curl -s http://localhost:8000/orders/<new-order-id>
```

Potwierdź, że `notes` wraca jako `"no onions"`, niezmienione. Zatrzymaj
serwer.

### Krok 15 — zrestartuj jeszcze raz i potwierdź, że nic się nie zepsuło

Uruchom serwer ostatni raz — ten sam plik bazy danych. Pobierz oba
zamówienia jeszcze raz (historyczne z Kroku 5 i nowe z Kroku 14): oba
muszą wrócić poprawnie, z niezmienionymi wartościami `notes`. Ten
restart też ponownie uruchamia Twoją funkcję migracji na bazie, która
już jest zmigrowana — jeśli wywaliłaby się albo zduplikowała kolumnę,
zobaczyłbyś/zobaczyłabyś to tutaj. Zatrzymaj serwer.

### Krok 16 — dodaj test dla nowego pola

#### Python

Dodaj test do `tests/test_api.py` potwierdzający, że `POST /orders` z
wartością `notes`, a potem `GET` na zwróconym id, zwraca tę samą
wartość `notes`.

#### Go

Dodaj test do `api_test.go` potwierdzający to samo. Wzoruj się na
kształcie `TestPostThenGetOrder`.

#### Java

Dodaj test do `ApiServerTest.java` potwierdzający to samo. Wzoruj się
na kształcie `postThenGetOrder`.

### Krok 17 — zaktualizuj kontrakt

Zaktualizuj `CONTRACT.md` z Lab 21: ciało żądania `POST /orders` teraz
akceptuje opcjonalne pole `notes`, a każda odpowiedź zwracająca
zamówienie (sukces i, gdzie dotyczy, błąd) teraz zawiera `notes`. Na
przykład:

Żądanie: `{"items": ["Burger"], "notes": "no onions"}`

Odpowiedź: `{"order_id": "4", "items": ["Burger"], "status":
"received", "notes": "no onions"}` (Twoje własne `order_id` będzie
zależeć od tego, ile zamówień utworzyłeś/aś w tej sesji — nie zakładaj,
że to zawsze `"1"`). Jeśli `notes` jest pominięte w żądaniu, albo
zamówienie jest starsze od tej migracji, wraca jako `""` — nigdy
brakujące, nigdy `null`.

### Krok 18 — branch, PR, review, merge

Zrób pracę z tego labu na gałęzi (na przykład
`feature/data-outlives-code`), wypchnij ją i otwórz pull request.
Zmerguj dopiero, gdy check CI z Lab 21 jest zielony — pętla branch →
PR → zielone CI → merge nadal obowiązuje dla `order-api` przez resztę
Aktu V.

## Kryteria akceptacji

- Istnieje warstwa przechowywania oparta na SQLite (`db.py` dla
  Pythona, `db.go` dla Go, `OrderDb.java` dla Javy) z: tworzeniem
  schematu, migracją `notes`, tworzeniem zamówienia i wyszukiwaniem
  zamówienia.
- Wszystkie testy z Lab 21 nadal przechodzą, plus nowy test `notes` (5
  razem).
- Zamówienie utworzone przed uruchomieniem migracji `notes` jest
  nadal pobieralne po niej, z `notes == ""`.
- Świeżo utworzone zamówienie z prawdziwą wartością `notes` przechodzi
  niezmienione przez `POST` a potem `GET` i przetrwa restart serwera.
- Uruchomienie migracji na już zmigrowanej bazie nie wywala się i nie
  zmienia istniejących danych.
- `CONTRACT.md` odzwierciedla nowe opcjonalne pole `notes`.
- Zmiany z tego labu zostały zmergowane przez pull request z zielonym
  checkiem CI, nie zacommitowane bezpośrednio na `main`.

## Weryfikacja

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

Oczekiwane: 5 testów przechodzi (albo odpowiednik Gradle) — plus
wszystko, co potwierdziłeś/aś ręcznie w Krokach 5, 6, 13, 14 i 15,
czego żaden sam zestaw testów by nie wychwycił, gdybyś pominął/ęła
prawdziwe restarty.

## Zastanów się

- Twoja migracja użyła `ALTER TABLE ... ADD COLUMN` bez klauzuli
  domyślnej, więc istniejące wiersze dostają `NULL`. Dlaczego trzeba
  było obsłużyć ten `NULL` we własnym kodzie, zamiast po prostu
  naprawić to raz w bazie danych?
- Część 1 (SQLite zamiast stanu w pamięci) w ogóle nie zmieniła
  `CONTRACT.md`. Część 2 (`notes`) zmieniła. Jaka jest różnica między
  tymi dwoma rodzajami zmian, z punktu widzenia wywołującego?
- Sprawdzenie migracji uruchamiałeś/aś przy każdym starcie, a nie raz,
  ręcznie, pierwszego razu, kiedy było potrzebne. Co by się zepsuło,
  gdyby kolega/koleżanka z zespołu ściągnął/ęła Twoją zmianę i
  uruchomił/a serwer, nigdy nie wywołując osobnej komendy "migrate"?

## Jeśli utkniesz

### Python

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

### Go

- **Podpowiedź 1:** Zarejestruj sterownik importem spod znaku
  podkreślenia — `import _ "modernc.org/sqlite"` — potem
  `sql.Open("sqlite", path)`. `sql.Open` nie łączy się naprawdę; nic
  nie zawiedzie aż do pierwszego prawdziwego zapytania, więc wywołaj
  `db.Ping()` zaraz po otwarciu, jeśli chcesz szybko wykryć błędną
  ścieżkę.
- **Podpowiedź 2:** `result, err := conn.Exec(...)` a potem
  `result.LastInsertId()` dają Ci automatycznie wygenerowany
  `order_id` jako `int64` — skonwertuj go `strconv.FormatInt(id, 10)`.
- **Podpowiedź 3:** `rows, err := conn.Query("PRAGMA table_info(orders)")`
  zwraca po jednym wierszu na kolumnę; `rows.Scan` potrzebuje
  miejsca docelowego dla każdej kolumny, którą zwraca `PRAGMA
  table_info` (`cid`, `name`, `type`, `notnull`, `dflt_value`, `pk`),
  nawet jeśli interesuje Cię tylko `name`.
- **Podpowiedź 4:** `sql.NullString` ma pole `.Valid` — `false` znaczy,
  że wartość w bazie była `NULL`, czyli dokładnie ten przypadek, który
  musisz zamienić na `""`.

### Java

- **Podpowiedź 1:** `DriverManager.getConnection("jdbc:sqlite:" + path)`
  otwiera (i tworzy, jeśli brakuje) plik bazy danych. sqlite-jdbc
  rejestruje się automatycznie — nie potrzebujesz
  `Class.forName(...)`.
- **Podpowiedź 2:** `statement.executeUpdate(sql, Statement
  .RETURN_GENERATED_KEYS)` a potem `statement.getGeneratedKeys()` dają
  Ci `ResultSet` z automatycznie wygenerowanym `order_id` w pierwszej
  kolumnie.
- **Podpowiedź 3:** `ResultSet.getString("name")` na każdym wierszu
  `PRAGMA table_info(orders)` daje Ci nazwę kolumny — użyj pętli
  `while (rs.next())`, żeby sprawdzić, czy `"notes"` już istnieje.
- **Podpowiedź 4:** `ResultSet.getString("notes")` zwraca Javowe
  `null` dla SQL-owego `NULL` — bez wyjątku, bez wartości-sentinela,
  po prostu `null`. Sprawdź to, zanim przekażesz wartość do swojego
  serializatora JSON.

## Co dalej

Twoje dane przetrwają restarty i zmiany schematu, w którymkolwiek
tracku realizowałeś/aś. Dalej kuchnia chce wysłać powiadomienie do
zewnętrznego serwisu dostawy — a ten serwis nie zawsze odpowiada, w
Pythonie, Go i Javie tak samo.

Przejdź do [Lab 23 — Świat zewnętrzny zawodzi](../23-outside-world-fails/README.pl.md).
