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
   wywołujący je pominie. Dodaj dwa nowe testy: jeden sprawdzający, że
   żądanie, które *wysyła* `priority`, dostaje z powrotem dokładnie tę
   wartość, jeden sprawdzający, że żądanie, które je *pomija*, dostaje
   `"normal"`. Uruchom też pełny istniejący zestaw testów, żeby
   potwierdzić, że żaden z nich nie musiał się zmienić, żeby to było
   prawdą.
4. Zaktualizuj `CONTRACT.md` z Lab 21: udokumentuj nowe opcjonalne pole
   `priority` w ciele żądania `POST /orders` i jego obecność w
   odpowiedzi.
5. Dodaj wpis `## [1.1.0]` do `CHANGELOG.md` opisujący nowe pole,
   zacommituj i otaguj: `git tag -a order-api-v1.1.0 -m "order-api v1.1.0"`.
6. Wypchnij oba tagi — wydanie, które istnieje tylko na Twojej maszynie,
   nie jest wydaniem: `git push origin order-api-v1.0.0 order-api-v1.1.0`
   (albo `git push --tags`, żeby wypchnąć wszystkie tagi naraz).
7. W nowej sekcji na dole `CHANGELOG.md`, `## Compatibility notes`,
   opisz (bez implementowania tego), jak wyglądałaby *łamiąca* wersja
   tego samego pomysłu zamiast tego — na przykład zmiana nazwy `items`
   na `line_items` w żądaniu/odpowiedzi — i podaj, którą pozycję SemVer
   (major/minor/patch) podniosłaby każda z dwóch zmian (ta prawdziwa
   addytywna i ta hipotetyczna łamiąca), i dlaczego.

## Kryteria akceptacji

- `CHANGELOG.md` ma zarówno wpis `[1.0.0]`, jak i `[1.1.0]`, plus
  sekcję `## Compatibility notes` rozważającą major kontra minor.
- `CONTRACT.md` dokumentuje nowe pole `priority`.
- Zarówno `order-api-v1.0.0`, jak i `order-api-v1.1.0` istnieją jako
  opisane (annotated) tagi Gita, wypchnięte na Twój remote.
- Pole `priority` jest zaimplementowane, poprawnie domyślne, ma własne
  przechodzące testy (jawna wartość i pominięcie z domyślną), a każdy
  test napisany przed tym labem nadal przechodzi bez modyfikacji.

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

- **Podpowiedź 1:** `data.get("priority", "normal")` to cała sztuczka
  wstecznej kompatybilności — wywołujący, który nigdy nie słyszał o
  `priority`, wysyła żądanie wyglądające dokładnie jak wcześniej i
  dostaje to samo domyślne zachowanie co wcześniej.
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
