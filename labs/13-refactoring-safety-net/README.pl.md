# Lab 13 — Refaktoryzacja z siatką bezpieczeństwa

## Sytuacja

Wersja A działa. Ma testy. Ma też rosnący łańcuch `elif` wewnątrz
`calculate_bill`, który nie ma nic wspólnego z sumą częściową,
podatkiem ani napiwkiem. Zaraz naprawisz *kształt* kodu, nie zmieniając
tego, co robi — i będziesz wiedzieć, że się udało, bo testy ani razu
nie zrobią się czerwone.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Wykonać zmianę strukturalną małymi krokami, z których każdy jest
  zweryfikowany testami.
- Wyjaśnić, co oznacza "zachowujący zachowanie" (behavior-preserving)
  dla refaktoryzacji.
- Użyć przechodzącego zestawu testów jako dowodu, że refaktoryzacja
  niczego nie zepsuła, zamiast ponownie czytać całą funkcję na oko.

## Zanim zaczniesz

- Lab 12 ukończony: Twoja własna kopia
  `examples/discount-codes/version-a/` ma `SAVE10`, `SAVE5` i `SAVE20`,
  wszystkie z przechodzącymi testami.
- Bieżący katalog: `examples/discount-codes/version-a/`.

## Twoje zadanie

Zrefaktoryzuj Wersję A tak, żeby obsługa kodów rabatowych wyglądała jak
w Wersji B — nigdy nie pozwalając zestawowi testów być czerwonym dłużej
niż przez pojedynczy krok, w trakcie którego akurat jesteś.

1. Utwórz `billing/discount_codes.py` ze słownikiem `DISCOUNT_CODES`
   mapującym `"SAVE10"`, `"SAVE5"` i `"SAVE20"` na funkcje kwoty, do
   której się stosują (procenty jako lambdy, płaskie `$5` jako lambda
   ignorująca swój argument), oraz funkcją `apply_discount_code(amount,
   code)`, która wyszukuje kod i rzuca `ValueError` dla czegokolwiek
   nierozpoznanego — dokładnie jak w Wersji B.
2. Uruchom pełny zestaw testów. Nadal powinien przechodzić — na razie
   tylko *dodałeś/aś* plik, nic w `calculator.py` jeszcze go nie
   wywołuje.
3. W `calculator.py` zastąp łańcuch `if/elif/else` wewnątrz
   `calculate_bill` pojedynczym wywołaniem `apply_discount_code`, tylko
   gdy `discount_code is not None`.
4. Uruchom zestaw testów natychmiast ponownie. Musi nadal przechodzić —
   jeśli nie przechodzi, zmieniłeś/aś zachowanie, a nie tylko strukturę.
   Napraw to, zanim zrobisz cokolwiek innego.
5. Usuń teraz nieużywaną logikę wbudowaną, jeśli coś z niej zostało.
   Uruchom testy jeszcze raz na koniec.

## Kryteria akceptacji

- `billing/discount_codes.py` istnieje z tymi samymi trzema kodami co
  Wersja B.
- `calculate_bill` nie zawiera już łańcucha `if/elif` sprawdzającego
  bezpośrednio stringi kodów rabatowych.
- `uv run pytest` przechodzi na każdym z opisanych powyżej kroków, nie
  tylko na końcu.

## Weryfikacja

```bash
cd examples/discount-codes/version-a
uv run pytest -v
grep -n "elif discount_code" billing/calculator.py && echo "still coupled — not done" || echo "decoupled"
cd -
```

Oczekiwane: wszystkie testy przechodzą, a wypisuje się `decoupled`
(żadna linia `elif discount_code` nie pozostaje w `calculator.py`).

## Zastanów się

- Na którym pojedynczym kroku, gdybyś zrobił/a literówkę, zestaw
  testów powiedziałby Ci o tym natychmiast — a na którym kroku mogłaby
  wkraść się cicha zmiana zachowania, której żaden obecny test nie
  wyłapuje?
- Właśnie zamieniłeś/aś Wersję A w coś strukturalnie identycznego z
  Wersją B. Jaki był faktyczny *dowód*, na każdym kroku, że nie
  zmieniłeś/aś tego, co robi program?

## Jeśli utkniesz

- **Podpowiedź 1:** Kroki 1-2 to czyste dodawanie — nic istniejącego
  się nie zmienia, więc nic jeszcze nie może się zepsuć. To celowe:
  umieść nowy kod na miejscu i udowodnij, że jest poprawny w izolacji,
  zanim go podłączysz.
- **Podpowiedź 2:** Krok 3 to jednolinijkowe zastąpienie całego bloku
  `if discount_code == "SAVE10": ... elif ...: ... else: raise ...`
  przez `code_discount = apply_discount_code(after_loyalty,
  discount_code)`.
- **Podpowiedź 3:** Jeśli test nie przechodzi po kroku 3, porównaj, co
  robi `apply_discount_code` dla tego konkretnego kodu, z tym, co
  robiła stara gałąź wbudowana — rozbieżność zwykle dotyczy dokładnie
  jednego z trzech kodów.

## Co dalej

Kody rabatowe i (z ostatnich dwóch labów) rodzina rzeczy, które
wszystkie "wybierają jedno zachowanie spośród kilku, na podstawie
klucza". Dalej spojrzysz na jeszcze jeden przykład tego samego kształtu
z zupełnie innej części systemu — i dopiero wtedy poznasz, jak się to
zwykle nazywa.

Przejdź do [Lab 14 — Jeden kontrakt, trzy języki](../14-one-contract-three-languages/README.pl.md).
