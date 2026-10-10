# Lab 19 — Repozytorium powinno sprawdzać samo siebie

## Sytuacja

Zmiana zmergowana tydzień temu złamała zestaw testów na `main` — autor
zapomniał uruchomić testy przed mergem, a reviewer zaufał opisowi PR
zamiast faktycznie coś uruchomić. Nikt tego nie zauważył, aż ktoś
uruchomił program ręcznie i się wywalił.

## Cele nauki

Po tym labie potrafisz:

- Napisać minimalny workflow GitHub Actions, który uruchamia się przy
  każdym push i pull request.
- Wyjaśnić, co robi każdy krok workflow CI, nie traktując YAML jako
  magii.
- Użyć czerwonego/zielonego checka CI jako dowodu, zamiast ufać
  opisowi.

## Zanim zaczniesz

- Lab 18 ukończony: `main` ma funkcję reorder-report, zmergowaną przez
  prawdziwy pull request, w Twojej wybranej ścieżce.
- Bieżący katalog: katalog główny repozytorium — plik workflow mieszka
  poza `examples/team-inventory/`, w `.github/workflows/`.
- Jeśli Twoje repozytorium jest forkiem, GitHub domyślnie wyłącza na
  nim workflowy Actions. Otwórz zakładkę **Actions** swojego forka i
  kliknij **"I understand my workflows, go ahead and enable them"**,
  zanim workflow tego laba w ogóle się uruchomi.
- Kanoniczne repozytorium tego kursu ma własny workflow maintainera,
  `.github/workflows/course-health.yml`, który sprawdza cały kurs. Jest
  celowo zakresowany, żeby uruchamiać się tylko na kanonicznym
  repozytorium, nie na Twoim forku — jeśli na niego spojrzysz,
  zobaczysz warunek sprawdzający nazwę repozytorium, a na Twoim forku
  GitHub pokazuje tamten job jako **skipped** (pominięty), nie
  failed ani brakujący. To jest inna rzecz niż to, co budujesz tutaj:
  Twój nowy workflow jest Twój, działa na Twoim forku, i sprawdza
  tylko `examples/team-inventory/<twój-język>`.

## Twoje zadanie

1. Utwórz branch `feature/ci-pipeline` z `main`.
2. Utwórz `.github/workflows/team-inventory-ci.yml` (utwórz
   `.github/workflows/`, jeśli nie istnieje). Skopiuj **kompletny**
   workflow swojej ścieżki poniżej do tego jednego pliku, dokładnie
   tak, jak jest pokazany — nie wklejaj do niego niczego innego
   najpierw. Każda wersja poniżej to cały plik, z kluczem `on:` raz
   wliczonym; wszystkie trzy ścieżki akurat mają ten sam trigger `on:
   [push, pull_request]`, ale to nie jest osobny fragment do dodania
   na wierch tego, co już jest w przykładzie Twojej ścieżki.

### Python

```yaml
name: team-inventory CI

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
        working-directory: examples/team-inventory/python
        run: uv sync --locked

      - name: Run tests
        working-directory: examples/team-inventory/python
        run: uv run pytest
```

`uv sync --locked` failuje build, zamiast po cichu aktualizować
`uv.lock`, jeśli ten jest kiedyś niezgodny z `pyproject.toml` —
dokładnie taki dryf CI ma za zadanie łapać. `3.13` i `0.11.21`
odpowiadają własnemu baseline'owi tego kursu — zobacz tabelę
toolchainu w głównym [`README.pl.md`](../../README.pl.md), albo plik
`.python-version` w katalogu głównym repozytorium, a nie konfigurację
jakiegokolwiek edytora.

### Go

```yaml
name: team-inventory CI

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
        working-directory: examples/team-inventory/go
        run: go test ./...
```

`1.27` odpowiada własnemu baseline'owi Go tego kursu — zobacz tabelę
toolchainu w głównym [`README.pl.md`](../../README.pl.md).

### Java

```yaml
name: team-inventory CI

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
        working-directory: examples/team-inventory/java
        run: ./gradlew test
```

`gradle/actions/setup-gradle@v6` sprawdza sumę kontrolną Twojego
zacommitowanego Gradle Wrapper, zanim `./gradlew` się kiedykolwiek
uruchomi, i cache'uje własne pobrania Gradle między przebiegami — **nie**
instaluje globalnego Gradle; `./gradlew test` wciąż działa przez Twój
zacommitowany wrapper, tak samo jak na Twojej własnej maszynie.

## Wszystkie ścieżki

3. Zacommituj i wypchnij branch, potem otwórz pull request (jak w Lab
   18 — web UI najpierw, sprawdzając dwa razy base repository i
   branch).
4. Otwórz zakładkę "Checks" PR i obserwuj uruchomienie workflow.
   Potwierdź, że jest zielony.
5. Celowo złam test lokalnie (zmień asercję na coś fałszywego),
   zacommituj, i wypchnij. Obserwuj, jak check staje się
   **czerwony** na PR. Potem odwróć swoje celowe uszkodzenie, wypchnij
   jeszcze raz, i obserwuj, jak staje się zielony.
6. Zmergeuj PR, gdy jest zielony.

## Kryteria akceptacji

- `.github/workflows/team-inventory-ci.yml` istnieje, celuje w
  `examples/team-inventory/<twój-język>`, i uruchamia się przy push i
  pull request.
- Osobiście zaobserwowałeś/aś, jak check zarówno failuje (czerwony,
  dla prawdziwego złamanego testu), jak i przechodzi (zielony) na
  prawdziwym pull request.
- Finalny zmergowany stan na `main` jest zielony.

## Weryfikacja

Nie ma lokalnej komendy, która zastąpi "obserwuj, jak to się uruchamia
na GitHubie" — ta obserwacja *jest* sensem tego laba. Lokalnie możesz
tylko odtworzyć, co zrobi workflow:

### Python

```bash
cd examples/team-inventory/python
uv sync --locked
uv run pytest
cd -
```

### Go

```bash
cd examples/team-inventory/go
go test ./...
cd -
```

### Java

```bash
cd examples/team-inventory/java
./gradlew test
cd -
```

Jeśli to przechodzi lokalnie, a Twój YAML workflow uruchamia te same
komendy w tym samym katalogu, check PR będzie się zgadzał.

## Zastanów się

- W Lab 18, reviewer mógł pominąć uruchomienie Twoich testów i po
  prostu zaufać opisowi PR. Co się zmieniło, gdy workflow już istniał
  — kto, albo co, jest teraz odpowiedzialne za złapanie
  nieprzetestowanej zmiany?
- Workflow uruchamia te dokładne same komendy, które uruchamiałeś/aś
  ręcznie przez kilka labów. Co Ci dała ich automatyzacja, jeśli same
  komendy się nie zmieniły?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** Minimalny workflow potrzebuje `on:`, sekcji
  `jobs:` z co najmniej jednym jobem, i listy `steps:` — checkout,
  setup Pythona, instalacja `uv`, `uv sync --locked`, `uv run pytest`.
  Wersja pokazana powyżej jest tą faktycznie zweryfikowaną dla tego
  kursu.
- **Podpowiedź 2:** Użyj `working-directory:
  examples/team-inventory/python` na krokach, które uruchamiają `uv
  sync --locked`/`uv run pytest`, bo domyślny katalog roboczy workflow
  to katalog główny repozytorium.
- **Podpowiedź 3:** Jeśli `uv sync --locked` failuje w CI, a `uv sync`
  działa lokalnie, Twój `uv.lock` jest nieaktualny — uruchom `uv lock`
  lokalnie, zacommituj zaktualizowany plik locka, i wypchnij jeszcze
  raz.

### Go

- **Podpowiedź 1:** Minimalny workflow potrzebuje `on:`, sekcji
  `jobs:` z co najmniej jednym jobem, i listy `steps:` — checkout,
  setup Go, `go test ./...`. Nie ma kroku instalacji/synchronizacji
  tak, jak potrzebuje tego Python — system modułów Go rozwiązuje
  zależności jako część samego `go test`.
- **Podpowiedź 2:** Użyj `working-directory: examples/team-inventory/go`
  na kroku testowym, bo domyślny katalog roboczy workflow to katalog
  główny repozytorium.
- **Podpowiedź 3:** Jeśli workflow nie może znaleźć Twojego pakietu,
  sprawdź dwa razy, czy `go.mod` jest faktycznie zacommitowany —
  nieśledzony `go.mod` działa na Twojej maszynie, ale nie istnieje z
  punktu widzenia workflow.

### Java

- **Podpowiedź 1:** Minimalny workflow potrzebuje `on:`, sekcji
  `jobs:` z co najmniej jednym jobem, i listy `steps:` — checkout,
  setup JDK, `setup-gradle`, `./gradlew test`.
- **Podpowiedź 2:** Użyj `working-directory:
  examples/team-inventory/java` na kroku testowym, bo domyślny
  katalog roboczy workflow to katalog główny repozytorium.
- **Podpowiedź 3:** Jeśli workflow raportuje `gradlew: Permission
  denied`, Twój zacommitowany plik `gradlew` gdzieś zgubił swój bit
  wykonywalności — `chmod +x examples/team-inventory/java/gradlew`,
  zacommituj zmianę mode, i wypchnij jeszcze raz.

Przed przejściem dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (zaczynający się od Lab 16)
tak — przyzwyczajaj się już teraz.

## Co dalej

Masz testy, review, i CI. Mając to wszystko, kiedy zmiana jest
"zrobiona"?

Przejdź do [Lab 20 — Co znaczy "zrobione"?](../20-definition-of-done/README.pl.md).
