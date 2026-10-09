# Lab 12 — Gdzie powinna trafić ta zmiana?

## Sytuacja

Dwóch developerów niezależnie zbudowało funkcję kodów rabatowych ze
specyfikacji z Lab 11. Obie wersje zachowują się dziś identycznie.
Właśnie masz się przekonać, że nie są jednakowo kosztowne w
rozszerzaniu.

Ten lab (i następne trzy) działa tak samo niezależnie od tego, który
język wybrałeś/aś w Akcie II: czytaj tylko instrukcje swojej ścieżki,
gdziekolwiek ta strona się rozdziela.

## Cele nauki

Po tym labie potrafisz:

- Zidentyfikować, które pliki musi dotknąć nowy wymóg w danym designie.
- Wyjaśnić "sprzężenie" (coupling) i "spójność" (cohesion), używając
  konkretnego przykładu, a nie definicji.
- Oceniać design po koszcie zmiany, a nie tylko po tym, czy aktualnie
  działa.

## Zanim zaczniesz

- Laby 06-11 ukończone, w Twojej wybranej ścieżce.
- Przeczytaj oba `version-a/<twój-język>/` i `version-b/<twój-język>/`,
  zanim zrobisz cokolwiek innego — zobacz poniżej dokładne pliki.
  Potwierdź sam/a, że obie wersje przechodzą swoje testy i produkują te
  same sumy.

### Python

- `examples/discount-codes/version-a/python/billing/calculator.py` i
  `examples/discount-codes/version-b/python/billing/calculator.py`
  (oraz `billing/discount_codes.py` wersji B).

### Go

- `examples/discount-codes/version-a/go/billing/calculator.go` i
  `examples/discount-codes/version-b/go/billing/calculator.go` (oraz
  `billing/discount_codes.go` wersji B).

### Java

- `examples/discount-codes/version-a/java/src/main/java/billing/Calculator.java`
  i
  `examples/discount-codes/version-b/java/src/main/java/billing/Calculator.java`
  (oraz `billing/DiscountCodes.java` wersji B).

## Twoje zadanie

Właściciel dodał trzeci kod: `SAVE20`, warty 20% zniżki od kwoty
pozostałej po rabacie lojalnościowym (ta sama zasada co `SAVE10`, inny
procent). Dodaj go do **obu** wersji, w swoim języku.

Dane kontrolne dla dużego zamówienia (dwa steki po $30.00, napiwek
15%): subtotal `$60.00`, rabat lojalnościowy `$6.00`, rabat `SAVE20`
`$10.80`, całkowity rabat `$16.80`, oczekiwany total `$53.14`.

### Python

1. Dodaj obsługę `SAVE20` do **Version A**
   (`examples/discount-codes/version-a/python/`). Dodaj test w
   `tests/test_calculator.py` asercjonujący, że dla dużego zamówienia,
   `bill["discount"] == 16.8` i `bill["total"] == 53.14`.
2. Dodaj obsługę `SAVE20` do **Version B**
   (`examples/discount-codes/version-b/python/`). Dodaj tam też
   odpowiadający test.

### Go

1. Dodaj branch `case "SAVE20":` do `switch` wewnątrz `CalculateBill`
   w **Version A** (`examples/discount-codes/version-a/go/`), liczący
   20% kwoty po rabacie lojalnościowym. Dodaj
   `TestSave20AppliesAfterLoyaltyDiscount` do `calculator_test.go`,
   asercjonujący `bill.Discount == 16.8` i `bill.Total == 53.14` dla
   dużego zamówienia.
2. Dodaj wpis `"SAVE20"` do mapy `discountCodes` w
   `discount_codes.go` w **Version B**
   (`examples/discount-codes/version-b/go/`). Dodaj tam też
   odpowiadający test do `calculator_test.go`.

### Java

1. Dodaj branch `case "SAVE20":` do `switch` wewnątrz `calculateBill`
   w **Version A** (`examples/discount-codes/version-a/java/`),
   liczący 20% kwoty po rabacie lojalnościowym. Dodaj
   `save20AppliesAfterLoyaltyDiscount` do `CalculatorTest.java`,
   asercjonujący `bill.discount == 16.8` i `bill.total == 53.14` dla
   dużego zamówienia.
2. Dodaj wpis `"SAVE20"` do mapy `CODES` w `DiscountCodes.java` w
   **Version B** (`examples/discount-codes/version-b/java/`). Dodaj
   tam też odpowiadający test do `CalculatorTest.java`.

## Wszystkie ścieżki

3. Dla każdej wersji zapisz: który plik(i) musiałeś/aś zmienić? W tym
   pliku, jaki *inny* kod siedzi bezpośrednio obok Twojej zmiany — kod
   odpowiedzialny za coś niezwiązanego z kodami rabatowymi?
4. Odpowiedz, w pliku notatek
   `examples/discount-codes/COMPARISON.md`: jeśli błąd w obliczeniu
   podatku pojawiłby się tuż po tej zmianie, która wersja łatwiej
   pozwala przekonać się, że zmiana kodu rabatowego nie mogła być
   przyczyną — po samym spojrzeniu na *gdzie* zmiana została
   wprowadzona? Ten plik jest wspólny dla każdego języka — napisz go
   raz, w kategoriach swojej własnej ścieżki.

## Kryteria akceptacji

- Zestawy testów obu wersji przechodzą, wliczając Twoje nowe testy
  `SAVE20`.
- `COMPARISON.md` nazywa konkretny plik zmieniony w każdej wersji i
  odpowiada na pytanie z kroku 4.

### Python

- Version A: 5 testów. Version B: 8 testów.

### Go

- Version A: 5 testów (4 istniejące funkcje `Test...` plus Twoja nowa).
  Version B: 8 (7 istniejących plus Twoja nowa).

### Java

- Version A: 5 testów. Version B: 8 testów.

## Weryfikacja

### Python

```bash
cd examples/discount-codes/version-a/python && uv run pytest -v && cd - > /dev/null
cd examples/discount-codes/version-b/python && uv run pytest -v && cd - > /dev/null
test -f examples/discount-codes/COMPARISON.md && echo "comparison notes exist"
```

Oczekiwane: obie wersje zielone (5 testów w Version A, 8 w Version B),
i notatki porównawcze istnieją.

### Go

```bash
cd examples/discount-codes/version-a/go && go test ./... -v && cd - > /dev/null
cd examples/discount-codes/version-b/go && go test ./... -v && cd - > /dev/null
test -f examples/discount-codes/COMPARISON.md && echo "comparison notes exist"
```

Oczekiwane: obie wersje zielone (5 testów w Version A, 8 w Version B),
i notatki porównawcze istnieją.

### Java

```bash
cd examples/discount-codes/version-a/java && ./gradlew test && cd - > /dev/null
cd examples/discount-codes/version-b/java && ./gradlew test && cd - > /dev/null
test -f examples/discount-codes/COMPARISON.md && echo "comparison notes exist"
```

Oczekiwane: obie wersje zielone (5 testów w Version A, 8 w Version B),
i notatki porównawcze istnieją.

## Zastanów się

- Obie wersje wymagały od Ciebie zmiany dokładnie jednego pliku. Czy
  "ta sama liczba zmienionych plików" znaczy "ten sam koszt zmiany"?
  Co jest faktycznie inne między dwoma plikami, które dotknąłeś/aś?
- W Version B, mógłbyś/mogłabyś dodać czwarty kod rabatowy bez
  przeczytania ani jednej linii pliku kalkulatora? Co to mówi Ci o tym,
  jak sprzężony jest plik kodów rabatowych z resztą logiki rachunku?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** W Version A, Twoja zmiana to nowy branch `elif`
  wewnątrz `calculate_bill`. W Version B, to nowy wpis w dict
  `DISCOUNT_CODES` w `discount_codes.py`.
- **Podpowiedź 2:** "20% zniżki od kwoty pozostałej po rabacie
  lojalnościowym" ma tę samą formę co `SAVE10`, tylko inną stawkę.
- **Podpowiedź 3:** Dla dużego zamówienia ($60 subtotal, $6 rabat
  lojalnościowy, napiwek 15%): kwota po rabacie lojalnościowym to $54;
  `SAVE20` od tego to $10.80; całkowity rabat to $16.80.

### Go

- **Podpowiedź 1:** W Version A, Twoja zmiana to nowy `case` wewnątrz
  `switch` w `CalculateBill`. W Version B, to nowy wpis w mapie
  `discountCodes` w `discount_codes.go`.
- **Podpowiedź 2:** "20% zniżki od kwoty pozostałej po rabacie
  lojalnościowym" ma tę samą formę co `SAVE10`, tylko inną stawkę —
  istniejący branch albo wpis mapy `SAVE10` jest bezpośrednim
  szablonem.
- **Podpowiedź 3:** Dla dużego zamówienia ($60 subtotal, $6 rabat
  lojalnościowy, napiwek 15%): kwota po rabacie lojalnościowym to $54;
  `SAVE20` od tego to $10.80; całkowity rabat to $16.80.

### Java

- **Podpowiedź 1:** W Version A, Twoja zmiana to nowy `case` wewnątrz
  `switch` w `calculateBill`. W Version B, to nowy wpis w mapie
  `CODES` w `DiscountCodes.java`.
- **Podpowiedź 2:** "20% zniżki od kwoty pozostałej po rabacie
  lojalnościowym" ma tę samą formę co `SAVE10`, tylko inną stawkę —
  istniejący branch albo wpis mapy `SAVE10` jest bezpośrednim
  szablonem.
- **Podpowiedź 3:** Dla dużego zamówienia ($60 subtotal, $6 rabat
  lojalnościowy, napiwek 15%): kwota po rabacie lojalnościowym to $54;
  `SAVE20` od tego to $10.80; całkowity rabat to $16.80.

Przed przejściem dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (zaczynający się od Lab 16)
tak — przyzwyczajaj się już teraz.

## Co dalej

Poczułeś/aś różnicę między designem, który sprawia, że nowy wymóg jest
tani, a tym, który sprawia tylko, że jest możliwy. Version A wciąż ma
sprzężoną formę, i wciąż ma testy. Dalej zmienisz Version A w coś
bliższego Version B, bez psucia czegokolwiek po drodze.

Przejdź do [Lab 13 — Refaktoryzacja z siatką bezpieczeństwa](../13-refactoring-safety-net/README.pl.md).
