# Lab 09 — Maszyny mogą sprawdzać nudne rzeczy

## Sytuacja

Twój ostatni code review zajął dziesięć minut, żeby dojść do zgody w
sprawie: tabulacji kontra spacji, nieużywanego importu i tego, czy
string powinien używać pojedynczych czy podwójnych cudzysłowów. Nic z
tego nie dotyczyło tego, czy kod jest *poprawny* — na to pytanie
odpowiadają już Twoje testy. A mimo to zmarnowało czas przeglądu.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Odróżnić to, co sprawdza formatter, od tego, co sprawdza linter, a oba
  od tego, co sprawdza test.
- Dodać i skonfigurować zależność narzędziową tylko-deweloperską w
  `pyproject.toml`.
- Uruchomić Ruff, żeby sformatować i zlintować projekt, i odczytać jego
  wynik.

## Zanim zaczniesz

- Lab 08 ukończony: `uv run pytest` przechodzi z naprawionym błędem
  podatku.
- Bieżący katalog: `examples/restaurant-bill/`.

## Twoje zadanie

1. Dodaj `ruff` jako zależność deweloperską w `pyproject.toml` (obok
   `pytest`), potem uruchom `uv sync`.
2. Dodaj sekcję `[tool.ruff]` do `pyproject.toml` z
   `target-version = "py313"` i `line-length = 100`.
3. Uruchom `uv run ruff format --check .` — to mówi Ci, czy Twoje pliki
   są już sformatowane tak, jak sformatowałby je Ruff, bez zmieniania
   czegokolwiek.
4. Uruchom `uv run ruff check .` — to szuka faktycznych problemów w
   kodzie (nieużywane importy, nieużywane zmienne i podobne), co jest
   innym pytaniem niż formatowanie.
5. Tymczasowo dodaj nieużywany import (np. `import math`) na górze
   `billing/calculator.py`. Uruchom `uv run ruff check .` ponownie i
   przeczytaj konkretną regułę, którą zgłasza. Usuń import, gdy już
   zobaczysz komunikat.
6. Napraw wszystko, co faktycznie zgłosiło któreś z poleceń w Twoim
   własnym kodzie z Labów 06-08.

## Kryteria akceptacji

- `pyproject.toml` wymienia `ruff` jako zależność deweloperską i ma
  sekcję `[tool.ruff]`.
- `uv run ruff format --check .` nie zgłasza żadnych plików do zmiany.
- `uv run ruff check .` nie zgłasza żadnych problemów.

## Weryfikacja

```bash
cd examples/restaurant-bill
uv run ruff format --check .
uv run ruff check .
uv run pytest
cd -
```

Oczekiwane: oba polecenia Ruff nie zgłaszają niczego do poprawy, a
`pytest` nadal przechodzi — nic z tego nie zmieniło zachowania.

## Zastanów się

- Które z trzech narzędzi, których teraz użyłeś/aś na tym projekcie
  (`pytest`, `ruff format`, `ruff check`), mogłoby w zasadzie powiedzieć
  Ci, że Twój kod jest "poprawny"? Które mogą powiedzieć jedynie, że
  jest "spójny" albo "wolny od oczywistych pomyłek"?
- Dlaczego uruchamiać formatter i linter jako dwa osobne polecenia
  zamiast jednego?

## Jeśli utkniesz

- **Podpowiedź 1:** `uv add --dev ruff` doda zależność za Ciebie zamiast
  ręcznej edycji `pyproject.toml`, jeśli wolisz nie edytować TOML-a
  ręcznie.
- **Podpowiedź 2:** `ruff format` nadpisuje pliki zgodnie ze swoim
  stylem; `ruff format --check` tylko zgłasza, co *by* się zmieniło, bez
  dotykania czegokolwiek — użyj najpierw `--check`.
- **Podpowiedź 3:** Jeśli `ruff check .` nie zgłasza zupełnie niczego w
  Twoim własnym kodzie, to prawidłowy wynik, a nie znak, że coś
  zrobiłeś/aś źle — oznacza, że Twój kod z Labów 06-08 był już czysty.

## Co dalej

Masz teraz trzy różne rodzaje automatycznej informacji zwrotnej: testy,
formatowanie i linting. W tej chwili musisz pamiętać o trzech różnych
poleceniach, we właściwej kolejności, za każdym razem. Dalej dasz sobie —
i każdemu po Tobie — dokładnie jeden sposób, żeby je uruchomić.

Przejdź do [Lab 10 — Jeden oczywisty sposób sprawdzania projektu](../10-one-way-to-check/README.pl.md).
