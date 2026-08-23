# Lab 10 — Jeden oczywisty sposób sprawdzania projektu

## Sytuacja

Nowa osoba w projekcie pyta: "jak jeszcze raz uruchomić testy? I czy
najpierw było `ruff check`, czy `ruff format`?" Wpisywałeś/aś te
polecenia tyle razy, że już o nich nie myślisz — dokładnie dlatego nowa
osoba nie powinna musieć pytać.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Opakować sekwencję poleceń w mały, czytelny skrypt powłoki.
- Wyjaśnić, dlaczego skrypt na poziomie projektu jest lepszy niż
  instrukcja w README, którą czytelnik musi ręcznie przepisać.
- Wyjaśnić, co oznacza "brak ukrytej magii" dla automatyzacji, którą
  sam/a piszesz.

## Zanim zaczniesz

- Lab 09 ukończony: `uv run pytest`, `uv run ruff format --check .` i
  `uv run ruff check .` wszystkie się udają.
- Bieżący katalog: `examples/restaurant-bill/`.

## Twoje zadanie

Utwórz katalog `scripts/` z czterema wykonywalnymi skryptami powłoki,
każdy uruchamialny z dowolnego miejsca (same powinny wejść do katalogu
głównego projektu przez `cd`):

1. `scripts/test.sh` — uruchamia zestaw testów.
2. `scripts/check.sh` — uruchamia sprawdzenie formatowania i linter
   (w tej kolejności), potem zestaw testów.
3. `scripts/format.sh` — faktycznie przeformatowuje kod (nie tylko
   `--check`).
4. `scripts/run.sh` — uruchamia aplikację.

Uczyń wszystkie cztery wykonywalnymi (`chmod +x`). Każdy skrypt powinien
być na tyle krótki, żeby jego przeczytanie od góry do dołu mówiło
dokładnie, co robi — żadna osobna dokumentacja nie powinna być
potrzebna, żeby go zrozumieć.

## Kryteria akceptacji

- Wszystkie cztery skrypty istnieją, są wykonywalne i działają przy
  wywołaniu z innego katalogu startowego (np. Twojego katalogu
  domowego).
- `scripts/check.sh` kończy się niepowodzeniem (niezerowy kod wyjścia),
  jeśli formatowanie, linting albo testy zawiodą — nowa osoba powinna
  zobaczyć jedno jasne niepowodzenie, a nie ciche kontynuowanie.
- Przeczytanie dowolnego skryptu zajmuje mniej niż trzydzieści sekund.

## Weryfikacja

```bash
cd ~
/sciezka/do/examples/restaurant-bill/scripts/test.sh
/sciezka/do/examples/restaurant-bill/scripts/check.sh
/sciezka/do/examples/restaurant-bill/scripts/run.sh
cd -
```

(Zamień `/sciezka/do/` na rzeczywistą ścieżkę Twojego repozytorium).
Oczekiwane: wszystkie trzy kończą się powodzeniem, bez ręcznego `cd` z
Twojej strony.

## Zastanów się

- Co stałoby się z `scripts/check.sh`, gdyby jedno z trzech poleceń
  zawiodło w połowie, a skrypt by się nie zatrzymał od razu? Która
  linia w Twoim skrypcie temu zapobiega?
- Czy jest coś w tym, co robią te skrypty, co nie jest widoczne po
  prostu przez ich przeczytanie? Gdyby kolega z zespołu zapytał, "co
  właściwie uruchamia `check.sh`", czy mógłbyś/mogłabyś po prostu
  pokazać mu ten plik?

## Jeśli utkniesz

- **Podpowiedź 1:** Zacznij każdy skrypt od `#!/usr/bin/env bash` i
  `set -euo pipefail` — druga linia zatrzymuje skrypt natychmiast po
  pierwszym nieudanym poleceniu.
- **Podpowiedź 2:** Żeby skrypt działał niezależnie od bieżącego
  katalogu wywołującego, umieść `cd "$(dirname "$0")/.."` blisko góry,
  zaraz po `set -euo pipefail`.
- **Podpowiedź 3:** `chmod +x scripts/*.sh` uczyni wszystkie cztery
  wykonywalnymi naraz.

Zanim pójdziesz dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (od Lab 16) już tak — wyrób
sobie ten nawyk już teraz.

## Co dalej

Wziąłeś/aś jeden skrypt i zamieniłeś/aś go w mały, dobrze przetestowany,
spójnie sprawdzany projekt. Akt II jest zakończony. Dalej sam projekt
będzie musiał przetrwać rzeczywistą zmianę wymagań — a to jest miejsce,
w którym zaczyna liczyć się projektowanie (design).

Przejdź do [Lab 11 — Klient zmienił zdanie](../11-changed-requirements/README.pl.md).
