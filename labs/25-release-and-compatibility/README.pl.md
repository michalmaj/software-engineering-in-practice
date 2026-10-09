# Lab 25 — Wydanie i kompatybilność

## Sytuacja

Inny zespół chce zacząć wywoływać `order-api` z własnego serwisu.
Muszą wiedzieć: z jaką wersją integrują się, co jest gwarantowane, że
będzie nadal działać, i jak dowiedzą się, kiedy coś się zmieni.

## Cele nauki

Po tym labie potrafisz:

- Napisać wpis changeloga, który dokumentuje, co się zmieniło i
  dlaczego ma to znaczenie dla wywołującego.
- Otagować konkretny commit jako wydanie za pomocą Gita.
- Odróżnić zmianę addytywną (wstecznie kompatybilną) od łamiącej i
  wyjaśnić, którą pozycję SemVer podnosi każda z nich.

## Zanim zaczniesz

### Python

- Lab 24 ukończony: `uv run pytest` przechodzi ze wszystkimi testami z
  Labów 21-24.
- Bieżący katalog: `examples/order-api/python/`.

### Go

- Lab 24 ukończony: `go test ./...` przechodzi ze wszystkimi testami z
  Labów 21-24.
- Bieżący katalog: `examples/order-api/go/`.

### Java

- Lab 24 ukończony: `./gradlew test` przechodzi ze wszystkimi testami z
  Labów 21-24.
- Bieżący katalog: `examples/order-api/java/`.

Przypomnienie, zanim zaczniesz coś tagować: pracujesz we własnym forku
repozytorium tego kursu, nie w osobnym repozytorium dla samego
`order-api`. `examples/order-api/<język>/` to folder, nie własne
repozytorium Git — jest dokładnie jeden katalog `.git`, w katalogu
głównym Twojego forka, i każdy tag, który tworzysz, wskazuje commit
*całego repozytorium kursu*, którego częścią jest Twoja praca nad
`order-api`. Nigdy nie uruchamiaj `git init` wewnątrz
`examples/order-api/<język>/`. I sprawdź dwukrotnie, że `origin`
wskazuje na Twój własny fork, zanim coś wypchniesz (`git remote -v`) —
nie na oryginalne repozytorium kursu, do którego i tak nie masz
dostępu do pushowania.

## Twoje zadanie

**Wydanie 1.0.0 — baseline:**

1. Utwórz gałąź `feature/changelog-baseline` z `main`.
2. Napisz `CHANGELOG.md` w `examples/order-api/<język>/`, w prostym
   formacie w stylu "Keep a Changelog", z jednym wpisem `## [1.0.0]`
   wymieniającym wszystko, co robi API na koniec Lab 24, z punktu
   widzenia wywołującego: dwa endpointy, walidację żądań, trwałość w
   SQLite, migrację `notes`, bounded retry wokół powiadomienia kuchni
   i logowanie operacyjne. Nie musi wspominać szczegółów
   implementacyjnych specyficznych dla Twojego języka, chyba że mają
   znaczenie operacyjne albo kompatybilnościowe (na przykład: "dane są
   przechowywane w SQLite" to warta linijka; "żądania obsługuje
   `com.sun.net.httpserver.HttpServer`" nie jest).
3. Uruchom pełny zestaw testów swojego tracku, żeby potwierdzić, że
   nic nie jest zepsute, potem zacommituj `CHANGELOG.md`, wypchnij
   gałąź, otwórz pull request i zmerguj, gdy CI jest zielone — ta sama
   pętla co w reszcie Aktu V.
4. Wróć do `main` i pobierz merge: `git switch main`, potem
   `git pull --ff-only`. Potwierdź, że zestaw testów nadal przechodzi,
   a potem — dopiero teraz, na tym już zmergowanym commicie — otaguj
   wydanie:
   `git tag -a order-api-v1.0.0 -m "order-api v1.0.0"`, i wypchnij tag:
   `git push origin order-api-v1.0.0`.

**Nigdy nie tagguj gałęzi funkcji przed jej zmergowaniem.** Squash i
rebase merge'y mogą obie dać commitowi, który trafia na `main`,
zupełnie inny hash niż ten na Twojej gałęzi — tag utworzony za wcześnie
zostaje wskazujący na commit, którego `main` w rzeczywistości nie
zawiera. Otagowanie dopiero po `git pull --ff-only` na `main`
całkowicie to omija.

"Wydanie" w tym labie to tag Gita, nic więcej — nie twórz GitHub
Release i nie buduj ani nie publikuj żadnego binarium czy paczki.

**Wydanie 1.1.0 — kompatybilna zmiana:**

5. Utwórz drugą gałąź, `feature/priority-field`, z już zaktualizowanego
   `main`.
6. Teraz wprowadź jedną prawdziwą, addytywną zmianę: dodaj opcjonalne
   pole `priority` do `POST /orders`, domyślnie `"normal"`, gdy
   wywołujący je pominie. To musi być prawdziwe, przechowywane pole,
   nie tylko wartość doklejona do odpowiedzi `POST` — `GET` później
   też musi je zobaczyć, i musi przetrwać restart.

#### Python

- W `db.py` dodaj `migrate_add_priority_column()` (dokładnie taki sam
  kształt jak `migrate_add_notes_column()` z Lab 22: sprawdź `PRAGMA
  table_info(orders)`, `ALTER TABLE orders ADD COLUMN priority TEXT`,
  jeśli jej brakuje) i wywołaj ją w `run()`, zaraz po
  `migrate_add_notes_column()`. Zaktualizuj swój fixture testowy w ten
  sam sposób, w jaki to zrobiono w Lab 22.
- Zaktualizuj `create_order`, żeby przyjmowało i przechowywało
  opcjonalny parametr `priority: str = "normal"`. Zaktualizuj
  `get_order`, żeby uwzględniało `priority` w wyniku, domyślnie
  `"normal"`, jeśli przechowana wartość to `NULL`.
- Zaktualizuj `do_POST` w `api.py`, żeby odczytywało opcjonalne pole
  `priority` z ciała żądania (domyślnie `"normal"`) i przekazywało je
  do `db.create_order` — nie doklejaj go do słownika odpowiedzi po
  fakcie; to przeszłoby każdy test sprawdzający tylko odpowiedź
  `POST`, w ogóle po cichu nie dotykając SQLite.

#### Go

- W `db.go` dodaj `migrateAddPriorityColumn() error`, sprawdzając
  kolumnę tak samo, jak już robi to `migrateAddNotesColumn` z Lab 22.
  Jeśli nie chcesz duplikować tej pętli skanującej `PRAGMA
  table_info` trzeci raz, wyciągnij ją raz do wspólnego helpera —
  `hasColumn(name string) (bool, error)` — i niech obie funkcje
  migracji go wywołują; istniejące testy `migrateAddNotesColumn` z
  Lab 22 przechodzą tak samo, bo jej zachowanie się nie zmienia.
  Wywołaj `migrateAddPriorityColumn()` w `main()`, zaraz po
  `migrateAddNotesColumn()`.
- Daj `Order` pole `Priority string` (tag JSON `priority`).
  Zaktualizuj `createOrder`, żeby przyjmowało parametr `priority
  string`, przechowując go i zwracając. Zaktualizuj `getOrder`, żeby
  odczytywało kolumnę `priority` przez `sql.NullString`, domyślnie
  `"normal"`, gdy jest `NULL` albo pusta (co będzie miało miejsce dla
  każdego wiersza utworzonego przed tą migracją).
- Zaktualizuj `handleCreateOrder`, żeby odczytywało opcjonalne pole
  `priority` z zdekodowanego ciała (`body["priority"].(string)`,
  domyślnie `"normal"`, jeśli brakuje, nie jest stringiem, albo jest
  pusty) i przekazywało je do `createOrder` *przed* utrwaleniem
  zamówienia — nie doklejone do wartości `Order` potem. Zaktualizuj
  wywołujących `newTestServer` (albo gdziekolwiek Twoje testy budują
  serwer), żeby też wywoływały `migrateAddPriorityColumn()`, tak samo
  jak już wywołują `migrateAddNotesColumn()`.

#### Java

- W `OrderDb.java` dodaj `migrateAddPriorityColumn() throws
  SQLException`, sprawdzając kolumnę tak samo, jak już robi to
  `migrateAddNotesColumn` z Lab 22. Jeśli nie chcesz duplikować tej
  pętli skanującej `PRAGMA table_info` trzeci raz, wyciągnij ją raz do
  wspólnego prywatnego helpera — `hasColumn(String name) throws
  SQLException` — i niech obie metody migracji go wywołują; istniejące
  testy `migrateAddNotesColumn` z Lab 22 przechodzą tak samo. Wywołaj
  `migrateAddPriorityColumn()` w `Main`, zaraz po
  `migrateAddNotesColumn()`.
- Daj `Order` pole `final String priority` i zaktualizuj jego
  konstruktor, żeby je przyjmował. Zaktualizuj `createOrder`, żeby
  przyjmowało parametr `String priority`, przechowując go i zwracając.
  Zaktualizuj `getOrder`, żeby odczytywało kolumnę `priority` przez
  `ResultSet.getString`, domyślnie `"normal"`, gdy jest `null` albo
  pusta (co będzie miało miejsce dla każdego wiersza utworzonego przed
  tą migracją).
- Zaktualizuj `handleCreateOrder`, żeby odczytywało opcjonalne pole
  `priority` z sparsowanego ciała (`data.get("priority")`, domyślnie
  `"normal"`, jeśli brakuje, nie jest `String`, albo jest puste) i
  przekazywało je do `OrderDb.createOrder` *przed* utrwaleniem
  zamówienia — nie doklejone do obiektu `Order` potem. Zaktualizuj
  `@BeforeEach` w `ApiServerTest`, żeby też wywoływał
  `OrderDb.migrateAddPriorityColumn()`, tak samo jak już wywołuje
  `OrderDb.migrateAddNotesColumn()`.

Dodaj trzy testy (w każdym tracku): jeden sprawdzający, że `POST`,
który *wysyła* `priority`, dostaje z powrotem dokładnie tę wartość;
jeden sprawdzający, że `POST`, który je *pomija*, dostaje `"normal"`;
i jeden, który wysyła `POST` z jawnym `priority`, a potem wykonuje
`GET` tego samego zamówienia po id i sprawdza, że `priority`
pobranego zamówienia się zgadza — dowodząc, że jest naprawdę
przechowywane, nie tylko odbite w odpowiedzi tworzącej.

Żaden z tych trzech testów nie dotyka przypadku, który ma największe
znaczenie przy migracji: wiersza, który był już w bazie danych
*zanim* `migrate_add_priority_column()` w ogóle się uruchomiło, i
którego kolumna `priority` jest naprawdę `NULL` — nie domyślna, nie
pominięta w żądaniu, naprawdę `NULL` na poziomie SQL. Każdy z
powyższych trzech testów tworzy wyłącznie *nowe* wiersze, przez
`create_order`/`createOrder`, które zawsze zapisują prawdziwą wartość.
Dodaj czwarty test, który dowodzi historycznego przypadku wprost:

```text
Old database row without priority
→ upgrade schema
→ GET historical order
→ priority == "normal"
```

Napisz go, wstawiając wiersz surową instrukcją `INSERT`, która w ogóle
nie wspomina `priority` — z pominięciem `create_order`/`createOrder`
całkowicie — *przed* wywołaniem `migrate_add_priority_column()` w tym
teście, żeby kolumna była naprawdę nieobecna (a potem naprawdę `NULL`
po dodaniu jej przez migrację) dla tego jednego wiersza, dokładnie tak,
jak byłby prawdziwy wiersz sprzed Lab 25. Potem uruchom migrację,
potem pobierz ten wiersz przez swoją zwykłą ścieżkę
`get_order`/`getOrder`, i sprawdź, że jego `priority` wraca jako
`"normal"` — nie `null`, nie brakujące. To inny, mocniejszy test niż
powyższe trzy: wychwyciłby prawdziwy błąd, który autorzy tego kursu
znaleźli podczas weryfikacji tego labu — endpoint GET mapujący SQL-owy
`NULL` wprost na `null` w odpowiedzi JSON, co każdy z pierwszych trzech
testów nadal przechodzi, bo żaden z nich nigdy nie odczytuje z powrotem
wiersza, którego kolumna `priority` jest faktycznie `NULL`.

Potem uruchom też pełny istniejący zestaw testów, żeby potwierdzić, że
żaden wcześniejszy test nie musiał się zmienić z powodu tych czterech
nowych.

7. Zaktualizuj `CONTRACT.md` z Lab 21: udokumentuj nowe opcjonalne pole
   `priority` w ciele żądania `POST /orders` i jego obecność w każdej
   odpowiedzi zwracającej zamówienie, włącznie z `GET`. Dodaj też
   krótką sekcję `## Compatibility assumption` stwierdzającą, że
   wywołujący mają ignorować pola odpowiedzi, których nie rozpoznają —
   i bądź precyzyjny/a co do tego, co to założenie faktycznie
   obejmuje: to *nie* jest ogólna zasada, że każda zmiana JSON jest
   wstecznie kompatybilna. Klient napisany ze ścisłą walidacją schematu
   (odrzucający nieznane pola) i tak by się zepsuł na tej zmianie, i
   nic w SemVer ani w "pola addytywne są bezpieczne" przed tym nie
   chroni — to założenie jest stwierdzeniem o tym, czego Twoje API
   oczekuje od swoich wywołujących, nie gwarancją, która działa
   niezależnie od tego, jak napisany jest wywołujący.
8. Dodaj wpis `## [1.1.0]` do `CHANGELOG.md` opisujący nowe pole, oraz
   sekcję `## Compatibility notes` na dole pliku, opisującą (bez
   implementowania tego), jak wyglądałaby *łamiąca* wersja tego samego
   pomysłu zamiast tego — na przykład zmiana nazwy `items` na
   `line_items` w żądaniu/odpowiedzi — podając, którą pozycję SemVer
   (major/minor/patch) podniosłaby każda z dwóch zmian (ta prawdziwa
   addytywna i ta hipotetyczna łamiąca), i dlaczego, odwołując się do
   założenia kompatybilności z `CONTRACT.md` jako faktycznego powodu,
   dla którego zmiana addytywna kwalifikuje się jako wstecznie
   kompatybilna. Napisz to wszystko, zanim zacommitujesz, żeby commit,
   który w końcu zostanie otagowany, miał kompletny changelog, a nie
   dopisany później.
9. Zacommituj, wypchnij gałąź, otwórz pull request i zmerguj, gdy CI
   jest zielone.
10. Wróć do `main` i pobierz merge, potwierdź, że zestaw testów nadal
    przechodzi, a potem otaguj:
    `git tag -a order-api-v1.1.0 -m "order-api v1.1.0"`, i wypchnij tag:
    `git push origin order-api-v1.1.0`.

## Kryteria akceptacji

- `CHANGELOG.md` ma zarówno wpis `[1.0.0]`, jak i `[1.1.0]`, plus
  sekcję `## Compatibility notes` rozważającą major kontra minor.
- `CONTRACT.md` dokumentuje nowe pole `priority` (także w odpowiedziach
  `GET`) i podaje założenie kompatybilności o ignorowaniu nieznanych
  pól odpowiedzi — bez przedstawiania go jako uniwersalnej gwarancji.
- Zarówno `order-api-v1.0.0`, jak i `order-api-v1.1.0` istnieją jako
  opisane (annotated) tagi Gita, wypchnięte na Twój remote — i każdy
  został utworzony dopiero *po* zmergowaniu odpowiadającej mu zmiany do
  `main`, nigdy wcześniej na gałęzi funkcji:
  `git merge-base --is-ancestor <tag> main` się udaje dla obu.
- Pole `priority` jest zaimplementowane i naprawdę przechowywane w
  SQLite (`GET` po `POST` je zwraca, nie tylko sama odpowiedź `POST`, i
  przetrwa restart serwera, bo to prawdziwa kolumna, nie wartość w
  pamięci albo tylko odbita), poprawnie domyślne, ma własne
  przechodzące testy (jawna wartość, pominięcie z domyślną, round-trip
  POST-potem-GET, i historyczny wiersz, którego kolumna `priority`
  jest naprawdę `NULL`, mapujący się na `"normal"`, nie `null`), a
  każdy test napisany przed tym labem nadal przechodzi bez
  modyfikacji.
- Obie zmiany z tego labu zostały zmergowane przez pull requesty z
  zielonym checkiem CI, nie zacommitowane bezpośrednio na `main`.

## Weryfikacja

### Python

```bash
cd examples/order-api/python
uv run pytest -v
cat CHANGELOG.md
git tag --list "order-api-v*"
git ls-remote --tags origin
git merge-base --is-ancestor order-api-v1.0.0^{commit} main && echo "v1.0.0 is on main"
git merge-base --is-ancestor order-api-v1.1.0^{commit} main && echo "v1.1.0 is on main"
cd -
```

### Go

```bash
cd examples/order-api/go
go test ./... -v
cat CHANGELOG.md
git tag --list "order-api-v*"
git ls-remote --tags origin
git merge-base --is-ancestor order-api-v1.0.0^{commit} main && echo "v1.0.0 is on main"
git merge-base --is-ancestor order-api-v1.1.0^{commit} main && echo "v1.1.0 is on main"
cd -
```

### Java

```bash
cd examples/order-api/java
./gradlew test
cat CHANGELOG.md
git tag --list "order-api-v*"
git ls-remote --tags origin
git merge-base --is-ancestor order-api-v1.0.0^{commit} main && echo "v1.0.0 is on main"
git merge-base --is-ancestor order-api-v1.1.0^{commit} main && echo "v1.1.0 is on main"
cd -
```

Oczekiwane: wszystkie testy przechodzą, `CHANGELOG.md` pokazuje oba
wpisy plus uwagi o kompatybilności, `git tag --list "order-api-v*"`
wymienia zarówno `order-api-v1.0.0`, jak i `order-api-v1.1.0`,
`git ls-remote --tags origin` pokazuje, że dotarły też na remote, a
oba checki `merge-base --is-ancestor` wypisują swoją linię
potwierdzenia.

**Jeśli check `merge-base --is-ancestor` nic nie wypisze** (brak linii
potwierdzenia, komenda po prostu się kończy): commit tego tagu w
rzeczywistości jeszcze nie jest na `main`. Nie naprawiaj tego siłowo
przez ponowne otagowanie `git tag -f` albo force-push — najpierw
ustal, *dlaczego*, przez `git show order-api-v1.0.0` (na jaki commit
tag faktycznie wskazuje?) i `git log main` (czy ten commit jest w
historii `main` w ogóle?). Zwykłą przyczyną jest otagowanie przed
merge'em, albo otagowanie lokalnej gałęzi, która nigdy faktycznie nie
została wypchnięta/zmergowana. Napraw prawdziwy problem — najpierw
zmerguj, potem otaguj wynikowy commit `main` — zamiast nadpisywać tag,
co do którego nie jesteś pewny/a.

## Zastanów się

- Nie trzeba było zmienić ani jednego istniejącego testu, żeby dodać
  `priority`. Co konkretnie w tym, *jak* to dodano (jako opcjonalne
  pole z wartością domyślną), sprawiło, że to prawda?
- Gdyby zamiast tego zmieniono nazwę `items` na `line_items`, każdy
  test budujący ciało żądania musiałby się zmienić. Czy to samo w
  sobie jest dobrym sygnałem, że "ta zmiana jest łamiąca", jeszcze
  zanim pomyślisz o zasadach SemVer?
- Założenie kompatybilności z `CONTRACT.md` mówi, że wywołujący
  powinni ignorować nieznane pola — ale to stwierdzenie o tym, czego
  oczekuje Twoje API, nie coś, co możesz wymusić na każdym
  wywołującym. Jaki jeden prawdziwy rodzaj klienta zepsułby się na tej
  zmianie i tak, mimo że jest "addytywna"?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** `data.get("priority", "normal")` to strona odczytu
  wstecznej kompatybilności — wywołujący, który nigdy nie słyszał o
  `priority`, wysyła żądanie wyglądające dokładnie jak wcześniej.
  Stroną zapisu jest przekazanie tej wartości do `db.create_order`,
  żeby stała się prawdziwą kolumną: wywołujący, który później pobierze
  zamówienie przez `GET`, też musi zobaczyć `priority`, nie tylko ten,
  kto zrobił oryginalny `POST`.
- **Podpowiedź 2:** Opisany tag (`git tag -a <nazwa> -m "<wiadomość>"`)
  niesie wiadomość i informacje o autorze, w przeciwieństwie do
  lekkiego tagu (`git tag <nazwa>`) — preferuj opisane tagi dla wydań.
- **Podpowiedź 3:** Podniesienie MAJOR oznacza "być może musisz
  zmienić swój kod wywołujący"; MINOR oznacza "nowa możliwość, nic
  innego się dla Ciebie nie zmienia"; PATCH oznacza "to samo
  zachowanie, naprawiono błąd".
- **Podpowiedź 4:** Do testu historycznego wiersza otwórz surowe
  połączenie `sqlite3.connect(db.DB_PATH)` wprost w teście i wykonaj
  `INSERT INTO orders (items, status, notes) VALUES (...)` — bez
  wspominania kolumny `priority` w ogóle — *przed* wywołaniem
  `db.migrate_add_priority_column()`. To właśnie czyni ten wiersz
  naprawdę sprzed migracji, nie tylko pominiętym z wartością, którą
  mogłeś/aś przekazać.

### Go

- **Podpowiedź 1:** Dwuwartościowa forma `body["priority"].(string)`
  (`priority, ok := body["priority"].(string)`) mówi Ci i czy pole
  było obecne i stringiem, i, jeśli tak, daje Ci wartość — traktuj
  `!ok` i pusty string tak samo, oba znaczą "wróć do `normal`".
- **Podpowiedź 2:** Pole `.Valid` w `sql.NullString` jest `false` dla
  wartości kolumny `NULL` — dokładnie ten przypadek, w którym będzie
  każdy wiersz z przed tej migracji. Sprawdzenie `!priority.Valid ||
  priority.String == ""` w jednym miejscu, wewnątrz `getOrder`,
  pozwala każdemu wywołującemu `getOrder` nie wiedzieć, że SQLite
  reprezentuje "jeszcze brak priority" jako `NULL`.
- **Podpowiedź 3:** `git tag --list "order-api-v*"` wymienia tylko
  tagi zgodne z tym wzorcem — przydatne, gdy tagujesz też coś
  niezwiązanego z `order-api` w tym samym repozytorium.
- **Podpowiedź 4:** Do testu historycznego wiersza otwórz własne
  `sql.Open` + `Exec` wprost w teście, wstawiając do `orders` tylko
  `items` i `status` — bez `priority` — *przed* wywołaniem
  `migrateAddPriorityColumn()`. To właśnie czyni ten wiersz naprawdę
  sprzed migracji, nie tylko pominiętym z wartością, którą mogłeś/aś
  przekazać do `createOrder`.

### Java

- **Podpowiedź 1:** Wynik `data.get("priority")` to `Object`, nie
  `String` — sprawdzenie pattern-matching `instanceof` (`if
  (priorityRaw instanceof String s && !s.isEmpty())`) jednocześnie
  zwęża typ i daje Ci niepustą wartość do użycia, w przeciwnym razie
  spadając do `"normal"`.
- **Podpowiedź 2:** `ResultSet.getString("priority")` zwraca Javowe
  `null` dla SQL-owego `NULL` — dokładnie ten przypadek, w którym
  będzie każdy wiersz z przed tej migracji. Sprawdzenie `null` *i*
  pustego stringa w jednym miejscu, wewnątrz `getOrder`, pozwala
  każdemu wywołującemu `getOrder` nie wiedzieć o historycznej dziurze
  w SQLite.
- **Podpowiedź 3:** `git tag --list "order-api-v*"` wymienia tylko
  tagi zgodne z tym wzorcem — przydatne, gdy tagujesz też coś
  niezwiązanego z `order-api` w tym samym repozytorium.
- **Podpowiedź 4:** Do testu historycznego wiersza otwórz własne
  `DriverManager.getConnection(...)` wprost w teście i wstaw do
  `orders` tylko `items` i `status` — bez `priority` — *przed*
  wywołaniem `OrderDb.migrateAddPriorityColumn()`. To właśnie czyni ten
  wiersz naprawdę sprzed migracji, nie tylko pominiętym z wartością,
  którą mogłeś/aś przekazać do `createOrder`.

## Co dalej

Akt V jest zakończony, w którymkolwiek tracku realizowałeś/aś — Twój
system przechowuje dane, przetrwa zmianę schematu, toleruje awarię
zewnętrzną, tłumaczy się sam przez logi i wydaje wersjonowane release'y
z prawdziwą historią kompatybilności. Dalej dołączasz do zespołu
(albo go prowadzisz), budując coś od zera — tu cały kurs się spina.

Przejdź do [Lab 26 — Kickoff projektu](../26-project-kickoff/README.pl.md).
