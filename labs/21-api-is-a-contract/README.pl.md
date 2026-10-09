# Lab 21 — API to kontrakt

## Sytuacja

Inna część systemu kuchni musi tworzyć zamówienia i sprawdzać ich
status — nie przez importowanie Twojego kodu, ale przez sieć, z
programu, który może nawet nie być napisany w tym samym języku.
Potrzebujesz granicy, na którą obie strony mogą się zgodzić bez
czytania kodu źródłowego drugiej strony.

## Cele nauki

Po tym labie potrafisz:

- Opisać kontrakt endpointu HTTP: formę requestu, formę response,
  kody statusu, i format błędów.
- Wyjaśnić, czemu kontrakt musi określać zachowanie błędów, nie tylko
  happy path.
- Dodać nową regułę walidacji do istniejącego endpointu bez zmiany
  jego kontraktu dla klientów, którzy już go przestrzegali poprawnie.

## Zanim zaczniesz

- Laby 06-20 ukończone, w Twojej wybranej ścieżce.
- Jeśli już zacząłeś/aś ten projekt w jego starej lokalizacji
  (`examples/order-api/api.py`, bez podfolderu `python/`), nic nie
  jest stracone: przenieś to, co już stworzyłeś/aś, do
  `examples/order-api/python/` samodzielnie (na przykład
  `mkdir -p examples/order-api/python && git mv examples/order-api/api.py examples/order-api/python/`,
  dopasowując do plików, które sam/a dodałeś/aś), potem kontynuuj od
  tego miejsca. Nie uruchamiaj `git reset --hard` ani `git clean`,
  żeby "zacząć od nowa" — każda z nich wyrzuciłaby pracę, której
  nigdzie jeszcze nie wypchnąłeś/aś.

### Python

- Bieżący katalog: `examples/order-api/python/`.
- Potwierdź, że starter działa: `uv run pytest -v`.

### Go

- Bieżący katalog: `examples/order-api/go/`.
- Potwierdź, że starter działa: `go test ./...`.

### Java

- Bieżący katalog: `examples/order-api/java/`.
- Potwierdź, że starter działa: `./gradlew test`.

## Twoje zadanie

### Krok 1 — uruchom serwer i zbadaj go ręcznie

Będziesz potrzebować dwóch otwartych terminali naraz: jeden
uruchamiający serwer, jeden uruchamiający `curl` wobec niego. W VS
Code otwórz pierwszy terminal normalnie (**Terminal → New Terminal**),
potem kliknij ikonkę **split terminal** w tym panelu (albo uruchom
**Terminal → New Terminal** jeszcze raz), żeby dostać drugi — oba
zostają wewnątrz tego samego okna VS Code.

**Terminal A** — uruchom serwer, i zostaw go działającego:

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

Pierwsze uruchomienie pobiera dystrybucję Gradle i zależności, jeśli
nie są jeszcze w cache — to może zająć minutę lub dwie; każde kolejne
uruchomienie jest szybkie.

**Wszystkie trzy ścieżki** wypisują tę samą linię, gdy są gotowe:

```text
order-api listening on http://localhost:8000
```

Ta linia jest Twoim sygnałem, że serwer faktycznie działa — nie
przechodź do Terminala B, zanim jej nie zobaczysz.

**Terminal B** — z serwerem wciąż działającym w Terminalu A, zbadaj go
ręcznie. Te trzy polecenia są identyczne dla każdej ścieżki, bo mówią
tylko HTTP:

```bash
curl -i -X POST http://localhost:8000/orders \
  -H "Content-Type: application/json" \
  -d '{"items": ["Burger", "Fries"]}'
curl -i http://localhost:8000/orders/1
curl -i http://localhost:8000/orders/999
```

Przeczytaj linię statusu i body każdej odpowiedzi, zanim przejdziesz
do następnego polecenia.

**Jeśli `curl` mówi** `curl: (7) Failed to connect to localhost port
8000... Couldn't connect to server`: serwer w Terminalu A nie działa,
albo się wywalił, albo jesteś wskazany/a na niewłaściwy port. Sprawdź
Terminal A pod kątem błędu, i potwierdź, że widziałeś/aś linię
"listening", zanim spróbujesz `curl` jeszcze raz.

**Jeśli uruchomienie serwera w Terminalu A failuje błędem
address-already-in-use**: coś już słucha na porcie 8000 — najczęściej
serwer, który uruchomiłeś/aś wcześniej i zapomniałeś/aś zatrzymać.
Znajdź go:

- Poszukaj wcześniejszej karty/panelu terminala, który wciąż ma
  uruchomiony serwer.
- Albo uruchom `lsof -i :8000` (macOS/Linux) albo, w Git Bash na
  Windows, sprawdź Menedżera Zadań pod kątem pozostałego procesu
  `python`, `go` albo `java`, i zatrzymaj ten proces.
- Jako ostatnią opcję, serwer każdej ścieżki też honoruje zmienną
  środowiskową `PORT`, więc możesz całkowicie obejść konflikt bez
  szukania drugiego procesu: `PORT=8001 uv run python api.py` (albo
  odpowiadające polecenie `go run .` / `./gradlew run`), potem użyj
  `http://localhost:8001` w swoich poleceniach `curl` zamiast tego.

Gdy skończysz badanie, zatrzymaj serwer w Terminalu A przez `Ctrl+C`.

#### Python

Zobaczysz wypisany traceback `KeyboardInterrupt` w Terminalu A — to
jest oczekiwane i niegroźne; to normalny sposób Pythona na
zraportowanie, że `Ctrl+C` przerwał blokujące wywołanie. Serwer i tak
się zatrzymał.

#### Go

Proces po prostu się kończy, bez dalszego komunikatu — to normalne,
niewyróżniające się zachowanie Go na `Ctrl+C` dla programu bez
specjalnej obsługi zamykania.

#### Java

Proces się kończy; Gradle może wypisać linię odnotowującą, że build
został przerwany. Tak czy inaczej, serwer się zatrzymał.

### Krok 2 — zdokumentuj kontrakt

Napisz `examples/order-api/CONTRACT.md` dokumentujący, dla każdego
endpointu: metodę HTTP i path, formę body requestu (jeśli jakaś),
każdą odpowiedź, którą może wyprodukować (kod statusu + forma body), i
co powoduje każdą odpowiedź błędu. Ten plik opisuje kontrakt HTTP na
poziomie wire — jest wspólny dla wszystkich trzech ścieżek, bo sam
kontrakt nie zależy od tego, który język go implementuje.

Żeby zacząć, tutaj jest forma dla jednego endpointu — resztę wypełnij
sam/a na podstawie tego, co faktycznie zaobserwowałeś/aś w Kroku 1, nie
zgadując:

```markdown
### `POST /orders`

Creates a new order.

**Request body:** `{"items": [<string>, ...]}`

**Responses:**
- `201 Created` — order created. Body:
  `{"order_id": "<string>", "items": [...], "status": "received"}`
- `400 Bad Request` — `items` is missing, not a list, or an empty
  list. Body: `{"error": "items must be a non-empty list"}`
- `400 Bad Request` — the request body isn't valid JSON. Body:
  `{"error": "invalid JSON"}`
```

Zrób to samo dla `GET /orders/{id}` (oba przypadki: znaleziony i
nieznaleziony) i dla nieznanej ścieżki. Nie przepisuj po prostu tego
szablonu — potwierdź każdy przypadek wobec prawdziwej odpowiedzi
najpierw.

### Krok 3 — dodaj regułę walidacji

Właściciel ma nowy wymóg: **każdy element w `items` musi być
niepustym stringiem**. Liczba, pusty string, albo `null` na liście
powinny być odrzucone w ten sam sposób, co już odrzucana brakująca
lista `items`.

#### Python

W `do_POST` w `api.py`, zaraz po istniejącym checku "musi być
niepustą listą" i przed utworzeniem zamówienia, dodaj check, który
odrzuca request `400 {"error": "each item must be a non-empty
string"}`, jeśli jakikolwiek element w `items` nie jest niepustym
stringiem.

#### Go

W `handleCreateOrder` w `api.go`, zaraz po istniejącym checku "musi
być niepustą listą" (check `len(items) == 0`) i przed utworzeniem
zamówienia, dodaj pętlę, która odrzuca request `400 {"error": "each
item must be a non-empty string"}` w momencie znalezienia elementu,
który nie jest niepustym stringiem. Każdy element wychodzi ze
zdekodowanego JSON jako `any`, więc będziesz potrzebować type
assertion, żeby sprawdzić, że faktycznie jest `string`, zanim
sprawdzisz, że jest niepusty.

#### Java

W `handleCreateOrder` w `ApiServer.java`, zaraz po istniejącym checku
"musi być niepustą listą" (check `items.isEmpty()`) i przed
utworzeniem zamówienia, dodaj pętlę, która odrzuca request `400
{"error": "each item must be a non-empty string"}` w momencie
znalezienia elementu, który nie jest niepustym stringiem. Każdy
element wychodzi ze sparsowanego JSON jako `Object`, więc będziesz
potrzebować checka `instanceof`, zanim sprawdzisz, że jest niepusty.

### Krok 4 — dodaj test

#### Python

Dodaj test do `tests/test_api.py` potwierdzający, że `POST /orders` z
`{"items": ["Burger", ""]}` (albo jakimkolwiek innym elementem
nie-stringiem) zwraca `400`.

#### Go

Dodaj test do `api_test.go` potwierdzający, że `POST /orders` z
`{"items": ["Burger", ""]}` zwraca `400`. Podążaj za formą
`TestPostWithoutItemsReturns400`.

#### Java

Dodaj test do `ApiServerTest.java` potwierdzający, że `POST /orders`
z `{"items": ["Burger", ""]}` zwraca `400`. Podążaj za formą
`postWithoutItemsReturns400`.

### Krok 5 — zaktualizuj kontrakt

Dodaj nowy przypadek błędu do `CONTRACT.md`, pod listą odpowiedzi
`POST /orders`.

### Krok 6 — skonfiguruj CI

Utwórz `.github/workflows/order-api-ci.yml` (ten sam wzorzec co
`team-inventory-ci.yml` z Lab 19), wyzwalany przez `[push,
pull_request]`.

#### Python

```yaml
name: order-api CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7

      - uses: actions/setup-python@v7
        with:
          python-version: "3.13"

      - name: Install uv
        uses: astral-sh/setup-uv@v10.2.0
        with:
          version: "0.11.21"

      - name: Install dependencies
        working-directory: examples/order-api/python
        run: uv sync --locked

      - name: Run tests
        working-directory: examples/order-api/python
        run: uv run pytest
```

#### Go

```yaml
name: order-api CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7

      - uses: actions/setup-go@v7
        with:
          go-version: "1.27"

      - name: Run tests
        working-directory: examples/order-api/go
        run: go test ./...
```

#### Java

```yaml
name: order-api CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7

      - uses: actions/setup-java@v6
        with:
          distribution: temurin
          java-version: "21"

      - uses: gradle/actions/setup-gradle@v6

      - name: Run tests
        working-directory: examples/order-api/java
        run: ./gradlew test
```

Ten workflow uruchamia tylko Twoją własną ścieżkę — nie ma powodu,
żeby konfigurować Pythona, Go *i* Javę tylko, żeby przetestować jeden
projekt. To jest inna rzecz niż własny workflow maintainera tego
repozytorium (`.github/workflows/course-health.yml`), który konfiguruje
wszystkie trzy, bo sprawdza cały kurs, nie jeden projekt studenta.

### Krok 7 — branch, PR, review, merge

Zrób pracę tego laba na branchu (na przykład `feature/api-contract`),
wypchnij go, i otwórz pull request — ten sam proces co w Lab 18: web
UI GitHuba najpierw, sprawdzając dwa razy base repository i base
branch, zanim go utworzysz. Potwierdź, że nowy check CI jest zielony
na PR (otwórz zakładkę **Checks** na stronie PR, i potwierdź, że to
workflow `order-api CI`, który właśnie dodałeś/aś, się uruchomił, nie
tylko już istniejący `team-inventory CI` z Lab 19). Potem zmergeuj, i
pobierz zmergowaną zmianę do swojego lokalnego `main`.

## Kryteria akceptacji

- `examples/order-api/CONTRACT.md` istnieje i dokumentuje każdy
  endpoint, każdy kod statusu, który może zwrócić, i co wyzwala
  każdy — wliczając nowy przypadek błędu walidacji elementów.
- Nowa reguła walidacji elementów jest zaimplementowana i ma
  przechodzący test.
- Komenda testowa Twojej ścieżki przechodzi z oryginalnymi trzema
  testami plus Twoim nowym (4 łącznie).
- `.github/workflows/order-api-ci.yml` istnieje, wyzwala się przy
  push i pull request, i uruchamia testy Twojej ścieżki w
  `examples/order-api/<twój-język>`.
- Zmiany tego laba zostały zmergowane przez pull request z zielonym
  checkiem CI, nie zacommitowane bezpośrednio na `main`.

## Weryfikacja

### Python

```bash
cd examples/order-api/python
uv run pytest -v
cd -
test -f examples/order-api/CONTRACT.md && echo "contract documented"
test -f .github/workflows/order-api-ci.yml && echo "CI workflow exists"
```

### Go

```bash
cd examples/order-api/go
go test ./... -v
cd -
test -f examples/order-api/CONTRACT.md && echo "contract documented"
test -f .github/workflows/order-api-ci.yml && echo "CI workflow exists"
```

### Java

```bash
cd examples/order-api/java
./gradlew test
cd -
test -f examples/order-api/CONTRACT.md && echo "contract documented"
test -f .github/workflows/order-api-ci.yml && echo "CI workflow exists"
```

Oczekiwane: `4 passed` (albo odpowiednik Java/Gradle), `contract
documented`, i `CI workflow exists` — plus zielony check na pull
requeście, który zmergował pracę tego laba.

## Zastanów się

- Jeśli zmieniłbyś/abyś odpowiedź dla udanego `POST`, żeby zagnieździć
  `items` wewnątrz nowego klucza `"order"` zamiast na najwyższym
  poziomie, czy to złamałoby klienta napisanego wobec Twojego
  obecnego `CONTRACT.md`? Czy dodanie nowego, opcjonalnego pola do
  response by go złamało?
- Twoja reguła walidacji dla elementów `items` jest nowa. Czy klient,
  który już wysyłał poprawne dane (niepuste stringi), nawet
  zauważyłby, że ta zmiana się stała?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** `curl -i` pokazuje Ci linię statusu odpowiedzi i
  headery, nie tylko body — przydatne do potwierdzania kodów statusu
  ręcznie.
- **Podpowiedź 2:** Nowa walidacja idzie do `do_POST`, sprawdzana
  zaraz po istniejącym checku "musi być niepustą listą", przed
  utworzeniem zamówienia.
- **Podpowiedź 3:** `all(isinstance(item, str) and item.strip() for
  item in items)` to jeden sposób sprawdzenia, że każdy element jest
  niepustym stringiem.

### Go

- **Podpowiedź 1:** `curl -i` pokazuje Ci linię statusu odpowiedzi i
  headery, nie tylko body — przydatne do potwierdzania kodów statusu
  ręcznie.
- **Podpowiedź 2:** Nowa walidacja idzie do `handleCreateOrder`,
  sprawdzana zaraz po istniejącym checku `len(items) == 0`, przed
  utworzeniem zamówienia.
- **Podpowiedź 3:** `item.(string)` to type assertion — w parze z
  jego dwuwartościową formą (`s, ok := item.(string)`), mówi Ci i
  czy element jest stringiem, i, jeśli tak, daje Ci go do sprawdzenia
  przez `strings.TrimSpace(s) == ""`.

### Java

- **Podpowiedź 1:** `curl -i` pokazuje Ci linię statusu odpowiedzi i
  headery, nie tylko body — przydatne do potwierdzania kodów statusu
  ręcznie.
- **Podpowiedź 2:** Nowa walidacja idzie do `handleCreateOrder`,
  sprawdzana zaraz po istniejącym checku `items.isEmpty()`, przed
  utworzeniem zamówienia.
- **Podpowiedź 3:** Pattern-matching `instanceof` Javy (`if (item
  instanceof String s)`) jednocześnie sprawdza typ i daje Ci użytkowy
  `String` w jednym kroku — użyj go z `s.trim().isEmpty()`.

Przed przejściem dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Pętla Aktu IV
branch → PR → zielone CI → merge nie zatrzymuje się tylko, bo Akt V
zmienił, w którym projekcie pracujesz — od tego miejsca przez resztę
Aktu V, każda zmiana w labie przechodzi przez nią, teraz obejmując
`order-api`.

## Co dalej

Twoje API działa — dopóki go nie zrestartujesz i każde zamówienie,
które stworzyłeś/aś, zniknie. Dalej dane muszą przetrwać.

(Go i Java nie kontynuują dalej stąd jeszcze: Laby 22-25 są na razie
tylko w Pythonie, tak samo jak Laby 11-30 zostały tylko w Pythonie po
podglądach Aktu II i Aktu III. Jeśli realizowałeś/aś Go albo Javę, to
jest granica tego, co jest obecnie zbudowane dla Aktu V — wszystko,
czego właśnie poćwiczyłeś/aś o kontraktach, walidacji i CI, wciąż
dotyczy tego, co przyjdzie dalej, w jakimkolwiek języku.)

Przejdź do [Lab 22 — Kod się zmienił, stare dane zostały](../22-data-outlives-code/README.pl.md).
