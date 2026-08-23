# Lab 19 — Repozytorium powinno sprawdzać się samo

## Sytuacja

Zmiana zmergowana w zeszłym tygodniu zepsuła `uv run pytest` na `main`
— autor zapomniał uruchomić testy przed mergem, a recenzent zaufał
opisowi PR-a zamiast faktycznie coś uruchomić. Nikt tego nie zauważył,
dopóki ktoś nie uruchomił skryptu ręcznie i się nie wywalił.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Napisać minimalny workflow GitHub Actions, który uruchamia się przy
  każdym push i pull request.
- Wyjaśnić, co robi każdy krok workflow CI, nie traktując YAML jak
  magii.
- Użyć czerwonego/zielonego sprawdzenia CI jako dowodu, zamiast ufać
  opisowi.

## Zanim zaczniesz

- Lab 18 ukończony: `main` ma `reorder_report`, zmergowane przez
  prawdziwy pull request.
- Bieżący katalog: katalog główny repozytorium (plik workflow mieszka
  poza `examples/team-inventory/`, w `.github/workflows/`).
- Jeśli Twoje repozytorium jest forkiem, GitHub domyślnie wyłącza w nim
  workflow Actions. Otwórz zakładkę **Actions** swojego forka i kliknij
  **"I understand my workflows, go ahead and enable them"**, zanim
  workflow z tego laba w ogóle zacznie działać.

## Twoje zadanie

1. Utwórz gałąź `feature/ci-pipeline` z `main`.
2. Utwórz `.github/workflows/team-inventory-ci.yml` (utwórz
   `.github/workflows/`, jeśli nie istnieje), który:
   - uruchamia się `on: [push, pull_request]`
   - wypina repozytorium
   - ustawia Pythona 3.13
   - instaluje `uv`
   - uruchamia `uv sync --locked`, potem `uv run pytest`, oba z
     katalogiem roboczym `examples/team-inventory` (`--locked`
     wywala build zamiast po cichu aktualizować `uv.lock`, jeśli
     kiedykolwiek rozjedzie się z `pyproject.toml` — dokładnie ten
     rodzaj rozjazdu, który CI ma wyłapywać)
3. Zacommituj i wypchnij gałąź, potem otwórz pull request (jak w
   Lab 18).
4. Otwórz zakładkę "Checks" PR-a i obserwuj uruchomienie workflow.
   Potwierdź, że jest zielony.
5. Celowo zepsuj test lokalnie (zmień asercję na coś fałszywego),
   zacommituj i wypchnij. Obserwuj, jak sprawdzenie robi się
   **czerwone** na PR-ze. Potem cofnij swoje celowe zepsucie, wypchnij
   ponownie i obserwuj, jak robi się zielone.
6. Zmerguj PR, gdy jest zielony.

## Kryteria akceptacji

- `.github/workflows/team-inventory-ci.yml` istnieje, celuje w
  `examples/team-inventory` i uruchamia się zarówno przy push, jak i
  pull request.
- Osobiście zaobserwowałeś/aś sprawdzenie zarówno nieudane (czerwone,
  dla faktycznie zepsutego testu), jak i udane (zielone) na
  prawdziwym pull requeście.
- Ostateczny zmergowany stan na `main` jest zielony.

## Weryfikacja

Nie ma lokalnego polecenia, które zastąpi "obejrzyj, jak to działa na
GitHubie" — ta obserwacja *jest* sensem tego laba. Lokalnie możesz
tylko odtworzyć to, co zrobi workflow:

```bash
cd examples/team-inventory
uv sync --locked
uv run pytest
cd -
```

Jeśli to przechodzi lokalnie, a Twój YAML workflow uruchamia te same
dwa polecenia w tym samym katalogu, sprawdzenie PR-a będzie się
zgadzać.

## Zastanów się

- W Lab 18 recenzent mógł pominąć faktyczne uruchomienie Twoich testów
  i po prostu zaufać opisowi PR-a. Co się zmieniło, gdy zaczął istnieć
  workflow — kto, albo co, jest teraz faktycznie odpowiedzialne za
  wyłapanie nieprzetestowanej zmiany?
- Workflow uruchamia dokładnie te same polecenia, które ręcznie
  uruchamiałeś/aś przez kilka labów. Co faktycznie dała Ci ich
  automatyzacja, skoro same polecenia się nie zmieniły?

## Jeśli utkniesz

- **Podpowiedź 1:** Minimalny workflow potrzebuje `on:`, sekcji
  `jobs:` z co najmniej jednym jobem i listy `steps:` — checkout,
  ustawienie Pythona, instalacja `uv`, `uv sync --locked`, `uv run
  pytest`. Jeśli utknąłeś/aś na samym YAML-u, a nie na tym, co workflow
  ma *robić*, oto szkielet — wypełnij luki, nie kopiuj go po prostu:
  ```yaml
  name: team-inventory CI

  on: [push, pull_request]

  jobs:
    test:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: actions/setup-python@v5
          with:
            python-version: "___"   # match .devcontainer/devcontainer.json
        - name: Install uv
          run: curl -LsSf https://astral.sh/uv/install.sh | sh
        - name: ___
          working-directory: examples/team-inventory
          run: ___                   # the dependency-install command
        - name: ___
          working-directory: examples/team-inventory
          run: ___                   # the test command
  ```
- **Podpowiedź 2:** Użyj `working-directory: examples/team-inventory`
  na krokach uruchamiających `uv sync --locked`/`uv run pytest`,
  ponieważ domyślnym katalogiem roboczym workflow jest katalog główny
  repozytorium.
- **Podpowiedź 3:** Sprawdź `.devcontainer/devcontainer.json` w
  katalogu głównym repozytorium, żeby zobaczyć, jaką wersję Pythona
  celuje to repozytorium, i dopasuj ją w `setup-python`.

## Co dalej

Masz testy, review i CI. Mając to wszystko, kiedy dokładnie zmiana
jest właściwie "zrobiona"?

Przejdź do [Lab 20 — Co oznacza "zrobione"?](../20-definition-of-done/README.pl.md).
