# Lab 25 — Wydanie i kompatybilność

## Sytuacja

Inny zespół chce zacząć wywoływać `order-api` z własnego serwisu.
Muszą wiedzieć: z jaką wersją integrują się, co jest gwarantowane, że
będzie nadal działać, i jak dowiedzą się, kiedy coś się zmieni.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Napisać wpis changeloga, który dokumentuje, co się zmieniło i
  dlaczego ma to znaczenie dla wywołującego.
- Otagować konkretny commit jako wydanie za pomocą Gita.
- Odróżnić zmianę addytywną (wstecznie kompatybilną) od łamiącej i
  wyjaśnić, którą pozycję SemVer podnosi każda z nich.

## Zanim zaczniesz

- Lab 24 ukończony: `uv run pytest` przechodzi ze wszystkimi testami z
  Labów 21-24.
- Bieżący katalog: `examples/order-api/`.

## Twoje zadanie

1. Napisz `CHANGELOG.md` w `examples/order-api/`, w prostym formacie w
   stylu "Keep a Changelog", z jednym wpisem `## [1.0.0]` wymieniającym
   wszystko, co robi API na koniec Lab 24: dwa endpointy, trwałość w
   SQLite, migrację `notes`, wrapper retry i strukturalne logowanie.
2. Zacommituj `CHANGELOG.md`, potem otaguj bieżący commit:
   `git tag -a order-api-v1.0.0 -m "order-api v1.0.0"`.
3. Teraz wprowadź jedną prawdziwą, addytywną zmianę: dodaj opcjonalne
   pole `priority` do `POST /orders`, domyślnie `"normal"`, gdy
   wywołujący je pominie. To musi być prawdziwe, przechowywane pole, nie
   tylko wartość doklejona do odpowiedzi POST:
   - W `db.py` dodaj `migrate_add_priority_column()` (dokładnie taki
     sam kształt jak `migrate_add_notes_column()` z Lab 22: sprawdź
     `PRAGMA table_info(orders)`, `ALTER TABLE orders ADD COLUMN
     priority TEXT`, jeśli jej brakuje) i wywołaj ją w `run()`, zaraz po
     `migrate_add_notes_column()`. Zaktualizuj swój fixture testowy w
     ten sam sposób, w jaki zrobiłeś/aś to w Lab 22.
   - Zaktualizuj `create_order`, żeby przyjmowało i przechowywało
     opcjonalny parametr `priority: str = "normal"`. Zaktualizuj
     `get_order`, żeby uwzględniało `priority` w wyniku, domyślnie
     `"normal"`, jeśli przechowana wartość to `NULL`.
   - Zaktualizuj `do_POST` w `api.py`, żeby odczytywało opcjonalne pole
     `priority` z ciała żądania (domyślnie `"normal"`) i przekazywało
     je do `db.create_order` — nie doklejaj go do słownika odpowiedzi
     po fakcie.
   - Dodaj trzy testy: jeden sprawdzający, że `POST`, który *wysyła*
     `priority`, dostaje z powrotem dokładnie tę wartość; jeden
     sprawdzający, że `POST`, który je *pomija*, dostaje `"normal"`; i
     jeden, który wysyła `POST` z jawnym `priority`, a potem wykonuje
     `GET` tego samego zamówienia po id i sprawdza, że `priority`
     pobranego zamówienia się zgadza — dowodząc, że jest naprawdę
     przechowywane, nie tylko odbite w odpowiedzi tworzącej.
   - Uruchom też pełny istniejący zestaw testów, żeby potwierdzić, że
     żaden z nich nie musiał się zmienić, żeby to było prawdą.
4. Zaktualizuj `CONTRACT.md` z Lab 21: udokumentuj nowe opcjonalne pole
   `priority` w ciele żądania `POST /orders` i jego obecność w każdej
   odpowiedzi zwracającej zamówienie, włącznie z `GET`.
5. Dodaj wpis `## [1.1.0]` do `CHANGELOG.md` opisujący nowe pole, oraz
   sekcję `## Compatibility notes` na dole pliku, opisującą (bez
   implementowania tego), jak wyglądałaby *łamiąca* wersja tego samego
   pomysłu zamiast tego — na przykład zmiana nazwy `items` na
   `line_items` w żądaniu/odpowiedzi — podając, którą pozycję SemVer
   (major/minor/patch) podniosłaby każda z dwóch zmian (ta prawdziwa
   addytywna i ta hipotetyczna łamiąca), i dlaczego. Napisz obie te
   rzeczy, zanim zacommitujesz i otagujesz, żeby changelog w otagowanym
   commicie był kompletny, a nie dopisany później.
6. Zacommituj, potem otaguj: `git tag -a order-api-v1.1.0 -m "order-api v1.1.0"`.
7. Wypchnij oba tagi — wydanie, które istnieje tylko na Twojej maszynie,
   nie jest wydaniem: `git push origin order-api-v1.0.0 order-api-v1.1.0`
   (albo `git push --tags`, żeby wypchnąć wszystkie tagi naraz).
8. Zrób pracę z tego labu na gałęzi (na przykład
   `feature/release-and-compatibility`), wypchnij ją i otwórz pull
   request. Zmerguj dopiero, gdy CI jest zielone — ta sama pętla co w
   reszcie Aktu V.

## Kryteria akceptacji

- `CHANGELOG.md` ma zarówno wpis `[1.0.0]`, jak i `[1.1.0]`, plus
  sekcję `## Compatibility notes` rozważającą major kontra minor — i
  oba były częścią tego samego commita, który został otagowany jako
  `order-api-v1.1.0`.
- `CONTRACT.md` dokumentuje nowe pole `priority`, także w odpowiedziach
  `GET`.
- Zarówno `order-api-v1.0.0`, jak i `order-api-v1.1.0` istnieją jako
  opisane (annotated) tagi Gita, wypchnięte na Twój remote.
- Pole `priority` jest zaimplementowane i naprawdę przechowywane w
  SQLite (`GET` po `POST` je zwraca, nie tylko sama odpowiedź `POST`),
  poprawnie domyślne, ma własne przechodzące testy (jawna wartość,
  pominięcie z domyślną, i round-trip POST-potem-GET), a każdy test
  napisany przed tym labem nadal przechodzi bez modyfikacji.
- Zmiany z tego labu zostały zmergowane przez pull request z zielonym
  checkiem CI, nie zacommitowane bezpośrednio na `main`.

## Weryfikacja

```bash
cd examples/order-api
uv run pytest -v
cat CHANGELOG.md
git tag
git ls-remote --tags origin
cd -
```

Oczekiwane: wszystkie testy przechodzą, `CHANGELOG.md` pokazuje oba
wpisy plus uwagi o kompatybilności, `git tag` wymienia zarówno
`order-api-v1.0.0`, jak i `order-api-v1.1.0`, a `git ls-remote --tags
origin` pokazuje, że dotarły też na remote.

## Zastanów się

- Nie musiałeś/aś zmienić ani jednego istniejącego testu, żeby dodać
  `priority`. Co konkretnie w tym, *jak* to dodałeś/aś (jako
  opcjonalne pole z wartością domyślną), sprawiło, że to prawda?
- Gdybyś zamiast tego zmienił/a nazwę `items` na `line_items`, każdy
  test budujący ciało żądania musiałby się zmienić. Czy to samo w
  sobie jest dobrym sygnałem, że "ta zmiana jest łamiąca", jeszcze
  zanim pomyślisz o zasadach SemVer?

## Jeśli utkniesz

- **Podpowiedź 1:** `data.get("priority", "normal")` to strona
  odczytu wstecznej kompatybilności — wywołujący, który nigdy nie
  słyszał o `priority`, wysyła żądanie wyglądające dokładnie jak
  wcześniej. Stroną zapisu jest przekazanie tej wartości do
  `db.create_order`, żeby stała się prawdziwą kolumną: wywołujący, który
  później pobierze zamówienie przez `GET`, też musi zobaczyć
  `priority`, nie tylko ten, kto zrobił oryginalny `POST`.
- **Podpowiedź 2:** Opisany tag (`git tag -a <nazwa> -m "<wiadomość>"`)
  niesie wiadomość i informacje o autorze, w przeciwieństwie do
  lekkiego tagu (`git tag <nazwa>`) — preferuj opisane tagi dla wydań.
- **Podpowiedź 3:** Podniesienie MAJOR oznacza "być może musisz
  zmienić swój kod wywołujący"; MINOR oznacza "nowa możliwość, nic
  innego się dla Ciebie nie zmienia"; PATCH oznacza "to samo
  zachowanie, naprawiono błąd".

## Co dalej

Akt V jest zakończony — Twój system przechowuje dane, przetrwa zmianę
schematu, toleruje awarię zewnętrzną, tłumaczy się sam przez logi i
wydaje wersjonowane release'y z prawdziwą historią kompatybilności.
Dalej dołączasz do zespołu (albo go prowadzisz), budując coś od zera —
tu cały kurs się spina.

Przejdź do [Lab 26 — Kickoff projektu](../26-project-kickoff/README.pl.md).
