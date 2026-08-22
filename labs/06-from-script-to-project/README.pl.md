# Lab 06 — Od skryptu do projektu

## Sytuacja

`examples/restaurant-bill/bill.py` liczy rachunek w restauracji: sumę
częściową, rabat lojalnościowy, podatek, napiwek, sumę końcową. Działa.
Jest też jedną funkcją, która robi pięć różnych rzeczy naraz, bez
możliwości zmiany jednej części bez ponownego czytania całości.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Rozdzielić odrębne odpowiedzialności skryptu na osobne moduły.
- Wyjaśnić różnicę między czystą funkcją obliczeniową a punktem wejścia
  obsługującym I/O (w tym przypadku: wypisywanie na ekran).
- Utworzyć minimalny `pyproject.toml` opisujący projekt jako metadane
  projektu, a nie tylko folder z plikami.
- Wyjaśnić, co sygnalizuje pusty katalog `tests/` o intencjach projektu.

## Zanim zaczniesz

- Laby 01-05 ukończone.
- Bieżący katalog: `examples/restaurant-bill/`.
- Przeczytaj całe `bill.py`, zanim cokolwiek zmienisz.

## Twoje zadanie

1. Uruchom `python3 bill.py` i zapisz jego wynik — będzie Ci potrzebny,
   żeby udowodnić, że refaktor nie zmienił zachowania.
2. Zidentyfikuj odrębne odpowiedzialności wymieszane w `main()`:
   liczenie sumy częściowej, naliczanie rabatu, liczenie podatku, liczenie
   napiwku i wypisywanie rachunku.
3. Utwórz `pyproject.toml` dla tego projektu: nazwa `restaurant-bill`,
   `requires-python = ">=3.13"`, zależność deweloperska `pytest` oraz
   `[tool.pytest.ini_options]` z `pythonpath = ["."]` (ten sam wzorzec co
   w Lab 05).
4. Utwórz pakiet `billing/` (`billing/__init__.py`, pusty) z modułem
   `billing/calculator.py` zawierającym dokładnie te cztery czyste
   funkcje, z dokładnie tymi nazwami i sygnaturami (kolejne dwa
   laboratoria zależą od tych dokładnych nazw):
   - `calculate_subtotal(items: list[tuple[str, float, int]]) -> float`
     — suma `price * quantity` dla każdego elementu.
   - `calculate_discount(subtotal: float) -> float` — 10% od `subtotal`,
     jeśli `subtotal >= 50`, w przeciwnym razie `0`.
   - `calculate_tax(amount: float) -> float` — płaskie 8% od `amount`.
   - `calculate_tip(amount: float, tip_rate: float) -> float` —
     `amount * tip_rate`.
   - `calculate_bill(items: list[tuple[str, float, int]], tip_rate: float)
     -> dict[str, float]` — składa powyższe cztery funkcje w słownik z
     kluczami `subtotal`, `discount`, `tax`, `tip`, `total`. **Na razie
     licz `tax` od pełnego `subtotal`, dokładnie jak oryginalny skrypt**
     — ten refaktor ma odtworzyć istniejące zachowanie dokładnie, razem
     z błędami. Niczego jeszcze nie naprawiasz.
5. Utwórz `billing/cli.py` z `main()`, które wywołuje `calculate_bill`
   *raz* i wypisuje ten sam pięciolinijkowy rachunek co oryginalny
   skrypt, używając wyłącznie wartości ze zwróconego słownika (nie licz
   niczego osobno — jedno źródło prawdy).
6. Utwórz `main.py` w katalogu głównym projektu, które importuje `main` z
   `billing.cli` i wywołuje je pod `if __name__ == "__main__":`.
7. Utwórz pusty katalog `tests/` (sam katalog — Lab 07 go wypełni).
8. Uruchom swój nowy punkt wejścia i porównaj (`diff`) z wynikiem
   zapisanym w kroku 1.
9. Gdy diff jest czysty, usuń `bill.py` — jest już w pełni zastąpiony.

## Kryteria akceptacji

- `examples/restaurant-bill/bill.py` już nie istnieje.
- `uv run python main.py` daje wynik *identyczny* z wynikiem
  oryginalnego skryptu.
- `billing/calculator.py` definiuje wszystkie pięć funkcji z dokładnie
  takimi nazwami i sygnaturami jak wyżej.
- `tests/` istnieje jako katalog (nawet jeśli na razie pusty).

## Weryfikacja

```bash
cd examples/restaurant-bill
python3 -c "import billing.calculator as c; print(c.calculate_bill([('Burger',12.50,2),('Fries',4.00,2),('Soda',2.50,2)], 0.15))" 2>&1 || true
uv run python main.py | tee /tmp/bill-after.txt
diff /tmp/bill-before.txt /tmp/bill-after.txt && echo "IDENTICAL"
test -d tests && echo "tests/ directory exists"
test -f bill.py && echo "bill.py still exists — delete it" || echo "bill.py correctly removed"
cd -
```

Oczekiwane: `IDENTICAL`, `tests/ directory exists` i `bill.py correctly
removed`.

## Zastanów się

- Właśnie udowodniłeś/aś, że refaktor nie zmienił zachowania, ręcznym
  `diff`. Co musiałbyś/abyś powtarzać ręcznie za każdym razem, gdy
  zmienisz jeszcze jedną linijkę, bez zautomatyzowanego testu?
- `calculate_tax` potrzebuje tylko jednej liczby, żeby wykonać swoje
  zadanie. Dlaczego to jest użyteczna właściwość funkcji?

## Jeśli utkniesz

- **Podpowiedź 1:** Pięć funkcji w `calculator.py`, jedna funkcja w
  `cli.py`, jeden dwulinijkowy `main.py`. To cała struktura.
- **Podpowiedź 2:** `calculate_bill` powinno wywoływać pozostałe cztery
  funkcje — nie powielaj ich logiki wewnątrz.
- **Podpowiedź 3:** Jeśli Twój diff nie jest pusty, wypisz oba pliki
  poleceniem `cat -A` albo porównaj linia po linii — formatowanie
  zmiennoprzecinkowe (`.2f`) to częste źródło drobnych niezgodności.

## Co dalej

Twój refaktor zachował zachowanie — ale "zachowane" to nie to samo co
"poprawne", a jedynym sposobem sprawdzenia jednego i drugiego jest teraz
czytanie kodu na oko. Dalej nauczysz komputer, żeby sprawdzał to za
Ciebie.

Przejdź do [Lab 07 — Skąd wiemy, że to działa?](../07-automated-tests/README.pl.md).
