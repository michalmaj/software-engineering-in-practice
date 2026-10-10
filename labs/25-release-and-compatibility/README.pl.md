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
  Labów 21-24, `CHANGELOG.md` ma wpis `[1.0.0]`, a `order-api-v1.0.0`
  istnieje jako opisany (annotated) tag na `main`, wypchnięty na Twój
  remote.
- Bieżący katalog: `examples/order-api/python/`.

### Go

- Lab 24 ukończony: `go test ./...` przechodzi ze wszystkimi testami z
  Labów 21-24, `CHANGELOG.md` ma wpis `[1.0.0]`, a `order-api-v1.0.0`
  istnieje jako opisany (annotated) tag na `main`, wypchnięty na Twój
  remote.
- Bieżący katalog: `examples/order-api/go/`.

### Java

- Lab 24 ukończony: `./gradlew test` przechodzi ze wszystkimi testami z
  Labów 21-24, `CHANGELOG.md` ma wpis `[1.0.0]`, a `order-api-v1.0.0`
  istnieje jako opisany (annotated) tag na `main`, wypchnięty na Twój
  remote.
- Bieżący katalog: `examples/order-api/java/`.

Przypomnienie, zanim zaczniesz coś tagować w tym labie: pracujesz we
własnym forku repozytorium tego kursu, nie w osobnym repozytorium dla
samego `order-api`. `examples/order-api/<język>/` to folder, nie
własne repozytorium Git — jest dokładnie jeden katalog `.git`, w
katalogu głównym Twojego forka, i każdy tag, który tworzysz, wskazuje
commit *całego repozytorium kursu*, którego częścią jest Twoja praca
nad `order-api`. Nigdy nie uruchamiaj `git init` wewnątrz
`examples/order-api/<język>/`. I sprawdź dwukrotnie, że `origin`
wskazuje na Twój własny fork, zanim coś wypchniesz (`git remote -v`) —
nie na oryginalne repozytorium kursu, do którego i tak nie masz
dostępu do pushowania.

### Jeśli Twój stan `v1.0.0` nie zgadza się z powyższym

Sprawdź, w którym z tych stanów faktycznie jesteś, zanim napiszesz
jakikolwiek kod — każdy ma konkretną, nie-destrukcyjną naprawę:

- **`order-api-v1.0.0` istnieje, wskazuje na commit na `main`, a Twoje
  testy przechodzą**: jesteś gotowy/a, także jeśli doszedłeś/aś do
  tego stanu przez wcześniejszą wersję Lab 24 albo Lab 25, która
  kazała Ci stworzyć tag samodzielnie — liczy się sam tag, nie to,
  instrukcje którego laba go wyprodukowały. Przejdź do "Twojego
  zadania" poniżej.
- **Tag nie istnieje, bo Lab 24 nie jest dokończony**: wróć i dokończ
  go, wliczając merge jego PR-a i tag — ten lab zakłada, że ten stan
  istnieje, nie że możesz przeskoczyć i otagować to tutaj jako
  dogrywkę.
- **Tag istnieje, ale `git merge-base --is-ancestor
  order-api-v1.0.0^{commit} main` nic nie wypisuje**: wskazuje na
  commit, którego `main` w rzeczywistości nie zawiera — prawie
  zawsze bo został utworzony na gałęzi funkcji przed merge'em. Nie
  usuwaj go ani nie przenoś siłowo jeszcze. Ustal, na co faktycznie
  wskazuje (`git show order-api-v1.0.0`) i czy ta praca kiedykolwiek
  się zmergowała. Jeśli bazowa zmiana jest już na `main` pod innym
  commitem (na przykład squash merge), usuń nieaktualny tag i
  stwórz go na nowo na właściwym commicie `main`. Jeśli zmiana nigdy
  się nie zmergowała, najpierw dokończ ten PR.
- **PR z Lab 24 jest otwarty, ale jeszcze nie zmergowany**: dokończ to
  najpierw — punkt startowy tego laba to zmergowane, otagowane
  `v1.0.0`, nie takie w trakcie. Nie buduj pracy na `v1.1.0` na
  niezmergowanej bazie — budowałbyś/abyś na gałęzi, która może się
  jeszcze zmienić.
- **Masz lokalne niezacommitowane zmiany z Lab 24**: zacommituj albo
  zastaszuj je (`git stash -u`, jeśli są jakieś nieśledzone), zanim
  zrobisz cokolwiek innego w tym labie — nie wyrzucaj ich, i nie
  pozwól im jechać niezacommitowanym na nowej gałęzi, gdzie łatwo je
  zgubić.

Nigdy nie używaj `git tag -f`, `git push --force` ani
`git reset --hard`, żeby wyjść z którejkolwiek z tych sytuacji — każda
ma wolniejszą, bezpieczną naprawę powyżej.

## Twoje zadanie

1. Utwórz gałąź `feature/priority-field` z `main`.
2. Wprowadź jedną prawdziwą, addytywną zmianę: dodaj opcjonalne pole
   `priority` do `POST /orders`, domyślnie `"normal"`, gdy wywołujący
   je pominie. To musi być prawdziwe, przechowywane pole, nie tylko
   wartość doklejona do odpowiedzi `POST` — `GET` później też musi je
   zobaczyć, i musi przetrwać restart.

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
  kolumnę tak samo, jak już robi to `migrateAddNotesColumn` z Lab 22
  — skopiuj tę samą formę skanowania `PRAGMA table_info` do nowej
  funkcji; druga kopia sześciolinijkowej pętli to zupełnie dobry
  sposób, żeby zmieścić się w 90 minutach tego labu, i nic tu nie
  ocenia Cię za posiadanie tylko jednej kopii. Wywołaj
  `migrateAddPriorityColumn()` w `main()`, zaraz po
  `migrateAddNotesColumn()`.
  **Opcjonalnie, poza podstawową ścieżką:** jeśli skończysz z
  realnym czasem w zapasie, wyciągnięcie wspólnej logiki skanowania
  do `hasColumn(name string) (bool, error)` i wywołanie go z obu
  funkcji migracji to rozsądny refactoring — istniejące testy
  `migrateAddNotesColumn` z Lab 22 przechodzą tak samo, bo jej
  zachowanie się nie zmienia — ale traktuj to jako cel rozszerzający,
  nie część wymaganej ścieżki tego labu.
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
  `migrateAddNotesColumn` z Lab 22 — skopiuj tę samą formę skanowania
  `PRAGMA table_info` do nowej metody; druga kopia krótkiej pętli to
  zupełnie dobry sposób, żeby zmieścić się w 90 minutach tego labu, i
  nic tu nie ocenia Cię za posiadanie tylko jednej kopii. Wywołaj
  `migrateAddPriorityColumn()` w `Main`, zaraz po
  `migrateAddNotesColumn()`.
  **Opcjonalnie, poza podstawową ścieżką:** jeśli skończysz z
  realnym czasem w zapasie, wyciągnięcie wspólnej logiki skanowania
  do prywatnego helpera `hasColumn(String name) throws SQLException` i
  wywołanie go z obu metod migracji to rozsądny refactoring —
  istniejące testy `migrateAddNotesColumn` z Lab 22 przechodzą tak
  samo — ale traktuj to jako cel rozszerzający, nie część wymaganej
  ścieżki tego labu.
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

3. Zaktualizuj `CONTRACT.md` z Lab 21: udokumentuj nowe opcjonalne pole
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
4. Dodaj wpis `## [1.1.0]` do `CHANGELOG.md` opisujący nowe pole, oraz
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
5. Zacommituj, wypchnij gałąź, otwórz pull request i zmerguj, gdy CI
   jest zielone.
6. Wróć do `main` i pobierz merge, potwierdź, że zestaw testów nadal
   przechodzi, a potem otaguj:
    `git tag -a order-api-v1.1.0 -m "order-api v1.1.0"`, i wypchnij tag:
    `git push origin order-api-v1.1.0`.

## Realistyczne 90 minut

Ten lab jest teraz jednym cyklem wydania, nie dwoma — `v1.0.0` zostało
otagowane na koniec Lab 24, więc wszystko tutaj budowane jest na już
zmergowanym, już otagowanym punkcie startowym. Praca, która została:
prawdziwa migracja schematu, trzy proste testy plus subtelniejszy
historyczny test `NULL`, aktualizacja `CONTRACT.md`, wpis
`CHANGELOG.md` rozważający SemVer, i jedna pełna pętla PR/CI/merge/tag.
To prawdziwa sesja pracy, nie krótka, ale już nie konkuruje z drugim
cyklem wydania o te same 90 minut.

Czwarty test — historyczny wiersz z naprawdę `NULL` kolumną
`priority` — to ten, który najprawdopodobniej zje nieplanowany czas,
właśnie dlatego, że to ten, który autorzy tego labu sami popełnili
błąd przy pierwszym podejściu (zobacz notatkę powyżej o błędzie, który
by wychwycił). Dajcie mu potrzebny czas, zamiast go przyspieszać, żeby
dopasować do trzech pozostałych, które są mechanicznie podobne do
testów, które już napisaliście w Labach 21-23.

Jeśli to wciąż nie zmieści się w jednym posiedzeniu w Twoim tempie, to
realistyczny wynik, nie znak, że robisz coś źle — zatrzymaj się w
miejscu, gdzie zestaw testów jest zielony i nic nie jest w połowie
zrobione (na przykład tuż po tym, jak cztery testy przejdą, przed
dotknięciem `CONTRACT.md` czy `CHANGELOG.md`), i dokończ resztę na
następnej sesji. Nie ma tu tagu do podziału w połowie labu —
`v1.1.0` istnieje tylko wtedy, gdy wszystko tutaj jest zmergowane —
więc naturalnym punktem zatrzymania jest "testy zielone, nic nie jest
w połowie zrobione", tak jak w każdym innym labie.

## Kryteria akceptacji

- `CHANGELOG.md` ma wpis `[1.1.0]` (na wierch wpisu `[1.0.0]`, który
  dodał już Lab 24), plus sekcję `## Compatibility notes` rozważającą
  major kontra minor.
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
- Zmiana z tego labu została zmergowana przez pull request z zielonym
  checkiem CI, nie zacommitowana bezpośrednio na `main`.

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
