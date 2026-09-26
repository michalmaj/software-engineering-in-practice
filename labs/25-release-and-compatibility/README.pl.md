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

1. Utwórz gałąź `feature/changelog-baseline` z `main`.
2. Napisz `CHANGELOG.md` w `examples/order-api/`, w prostym formacie w
   stylu "Keep a Changelog", z jednym wpisem `## [1.0.0]` wymieniającym
   wszystko, co robi API na koniec Lab 24: dwa endpointy, trwałość w
   SQLite, migrację `notes`, wrapper retry i strukturalne logowanie.
3. Zacommituj `CHANGELOG.md`, wypchnij gałąź, otwórz pull request i
   zmerguj, gdy CI jest zielone — ta sama pętla co w reszcie Aktu V.
4. Wróć do `main` i pobierz merge: `git switch main`, potem
   `git pull --ff-only`. Potwierdź, że zestaw testów nadal przechodzi
   (`uv run pytest`), a potem — dopiero teraz, na tym już zmergowanym
   commicie — otaguj wydanie:
   `git tag -a order-api-v1.0.0 -m "order-api v1.0.0"`, i wypchnij tag:
   `git push origin order-api-v1.0.0`.
5. Utwórz drugą gałąź, `feature/priority-field`, z już zaktualizowanego
   `main`.
6. Teraz wprowadź jedną prawdziwą, addytywną zmianę: dodaj opcjonalne
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
7. Zaktualizuj `CONTRACT.md` z Lab 21: udokumentuj nowe opcjonalne pole
   `priority` w ciele żądania `POST /orders` i jego obecność w każdej
   odpowiedzi zwracającej zamówienie, włącznie z `GET`. Dodaj też krótką
   sekcję `## Compatibility assumption` stwierdzającą, że wywołujący mają
   ignorować pola odpowiedzi, których nie rozpoznają — to dokładnie to
   założenie sprawia, że pole addytywne jak `priority` jest wstecznie
   kompatybilne w ogóle, a kolejny krok zależy od tego, że to jest
   zapisane, nie tylko domyślnie zrozumiane.
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
  pól odpowiedzi.
- Zarówno `order-api-v1.0.0`, jak i `order-api-v1.1.0` istnieją jako
  opisane (annotated) tagi Gita, wypchnięte na Twój remote — i każdy
  został utworzony dopiero *po* zmergowaniu odpowiadającej mu zmiany do
  `main`, nigdy wcześniej na gałęzi funkcji:
  `git merge-base --is-ancestor <tag> main` się udaje dla obu.
- Pole `priority` jest zaimplementowane i naprawdę przechowywane w
  SQLite (`GET` po `POST` je zwraca, nie tylko sama odpowiedź `POST`, i
  przetrwa restart serwera, bo to prawdziwa kolumna, nie wartość w
  pamięci), poprawnie domyślne, ma własne przechodzące testy (jawna
  wartość, pominięcie z domyślną, i round-trip POST-potem-GET), a każdy
  test napisany przed tym labem nadal przechodzi bez modyfikacji.
- Obie zmiany z tego labu zostały zmergowane przez pull requesty z
  zielonym checkiem CI, nie zacommitowane bezpośrednio na `main`.

## Weryfikacja

```bash
cd examples/order-api
uv run pytest -v
cat CHANGELOG.md
git tag
git ls-remote --tags origin
git merge-base --is-ancestor order-api-v1.0.0^{commit} main && echo "v1.0.0 is on main"
git merge-base --is-ancestor order-api-v1.1.0^{commit} main && echo "v1.1.0 is on main"
cd -
```

Oczekiwane: wszystkie testy przechodzą, `CHANGELOG.md` pokazuje oba
wpisy plus uwagi o kompatybilności, `git tag` wymienia zarówno
`order-api-v1.0.0`, jak i `order-api-v1.1.0`, `git ls-remote --tags
origin` pokazuje, że dotarły też na remote, a oba checki
`merge-base --is-ancestor` wypisują swoją linię potwierdzenia.

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
- **Podpowiedź 4:** Otagowanie gałęzi funkcji przed jej zmergowaniem
  jest ryzykowne właśnie z powodu squash i rebase merge'y — każdy z
  nich może dać commitowi, który trafia na `main`, zupełnie inny hash
  niż ten, który otagowałeś/aś, zostawiając Twój tag wskazujący na
  commit, którego `main` w rzeczywistości nie zawiera. Otagowanie
  dopiero po `git pull --ff-only` na `main` całkowicie to omija.

## Co dalej

Akt V jest zakończony — Twój system przechowuje dane, przetrwa zmianę
schematu, toleruje awarię zewnętrzną, tłumaczy się sam przez logi i
wydaje wersjonowane release'y z prawdziwą historią kompatybilności.
Dalej dołączasz do zespołu (albo go prowadzisz), budując coś od zera —
tu cały kurs się spina.

Przejdź do [Lab 26 — Kickoff projektu](../26-project-kickoff/README.pl.md).
