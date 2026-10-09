# Lab 13 — Refaktoryzacja z siatką bezpieczeństwa

## Sytuacja

Version A działa. Ma testy. Ma też rosnący łańcuch warunków wewnątrz
obliczenia rachunku, które nie mają nic do czynienia z subtotal,
podatkiem czy napiwkiem. Zaraz naprawisz *formę* kodu, bez zmiany tego,
co robi — i będziesz wiedział/a, że się udało, bo testy nigdy nie będą
czerwone.

## Cele nauki

Po tym labie potrafisz:

- Wprowadzić zmianę strukturalną w małych krokach, każdy zweryfikowany
  testami.
- Wyjaśnić, co znaczy "zachowujący zachowanie" (behavior-preserving)
  dla refaktoryzacji.
- Użyć przechodzącego zestawu testów jako dowodu, że refaktoryzacja
  niczego nie złamała, zamiast ponownego czytania całej funkcji na
  oko.

## Zanim zaczniesz

- Lab 12 ukończony: Twoja własna kopia Version A w Twoim języku ma
  `SAVE10`, `SAVE5` i `SAVE20`, wszystkie przechodzące swoje testy.

### Python

- Bieżący katalog: `examples/discount-codes/version-a/python/`.

### Go

- Bieżący katalog: `examples/discount-codes/version-a/go/`.

### Java

- Bieżący katalog: `examples/discount-codes/version-a/java/`.

## Twoje zadanie

Zrefaktoryzuj Version A tak, żeby jej obsługa kodów rabatowych
wyglądała jak w Version B — bez puszczania zestawu testów na czerwono
na dłużej niż jeden krok, w połowie którego właśnie jesteś. Każda
ścieżka podąża za tą samą sekwencją:

```text
tests green
→ add new discount-code component
→ existing tests green
→ route behavior through new component
→ tests green
→ remove old conditional logic
→ tests green
```

### Python

1. Utwórz `billing/discount_codes.py` z dict `DISCOUNT_CODES`
   mapującym `"SAVE10"`, `"SAVE5"` i `"SAVE20"` na funkcje kwoty, do
   której się stosują (procenty jako lambdy, płaskie `$5` jako lambda
   ignorująca swój argument), i funkcję `apply_discount_code(amount,
   code)`, która wyszukuje kod i podnosi `ValueError` dla czegokolwiek
   nierozpoznanego — dokładnie jak w Version B.
2. Uruchom pełny zestaw testów. Powinien wciąż przechodzić — tylko
   *dodałeś* plik na razie, nic w `calculator.py` go jeszcze nie
   wywołuje.
3. W `calculator.py` zamień łańcuch `if/elif/else` wewnątrz
   `calculate_bill` na jedno wywołanie `apply_discount_code`, tylko
   gdy `discount_code is not None`.
4. Uruchom zestaw testów jeszcze raz, natychmiast. Musi wciąż
   przechodzić — jeśli nie, zmieniłeś/aś zachowanie, nie tylko
   strukturę. Napraw to, zanim zrobisz cokolwiek innego.
5. Usuń teraz-nieużywaną logikę inline, jeśli jakaś została. Uruchom
   testy jeszcze raz, na końcu.

### Go

1. Utwórz `billing/discount_codes.go` z mapą `discountCodes`
   mapującą `"SAVE10"`, `"SAVE5"` i `"SAVE20"` na funkcje kwoty, do
   której się stosują, i funkcję `ApplyDiscountCode(amount, code)
   (float64, error)`, która wyszukuje kod i zwraca błąd dla
   czegokolwiek nierozpoznanego — dokładnie jak w Version B.
2. Uruchom pełny zestaw testów (`go test ./...`). Powinien wciąż
   przechodzić — nieużywana mapa albo funkcja na poziomie pakietu nie
   zatrzymuje budowania Go; tylko *dodałeś* coś na razie, nic w
   `calculator.go` go jeszcze nie wywołuje.
3. W `calculator.go` zamień `switch` wewnątrz `CalculateBill` na jedno
   wywołanie `ApplyDiscountCode`, tylko gdy `discountCode != ""`.
4. Uruchom zestaw testów jeszcze raz, natychmiast. Musi wciąż
   przechodzić — jeśli nie, zmieniłeś/aś zachowanie, nie tylko
   strukturę. Napraw to, zanim zrobisz cokolwiek innego.
5. Usuń teraz-nieużywaną logikę inline, jeśli jakaś została. Sprawdź,
   czy `calculator.go` wciąż potrzebuje importu `"fmt"` — gdy `switch`,
   który budował komunikat błędu przez `fmt.Errorf`, już nie istnieje,
   ten import staje się nieużywany, a Go odmawia zbudowania z
   nieużywanym importem. Uruchom `go build ./...`, żeby to złapać,
   zanim uruchomisz testy jeszcze raz.

### Java

1. Utwórz `src/main/java/billing/DiscountCodes.java` z mapą `CODES`
   (`Map<String, DoubleUnaryOperator>`) mapującą `"SAVE10"`, `"SAVE5"`
   i `"SAVE20"` na kwotę, do której się stosują, i metodę
   `apply(double amount, String code)`, która wyszukuje kod i podnosi
   `IllegalArgumentException` dla czegokolwiek nierozpoznanego —
   dokładnie jak w Version B.
2. Uruchom pełny zestaw testów (`./gradlew test`). Powinien wciąż
   przechodzić — nieużywana klasa nie zatrzymuje kompilacji Javy;
   tylko *dodałeś* plik na razie, nic w `Calculator.java` go jeszcze
   nie wywołuje.
3. W `Calculator.java` zamień `switch` wewnątrz `calculateBill` na
   jedno wywołanie `DiscountCodes.apply`, tylko gdy `discountCode !=
   null`.
4. Uruchom zestaw testów jeszcze raz, natychmiast. Musi wciąż
   przechodzić — jeśli nie, zmieniłeś/aś zachowanie, nie tylko
   strukturę. Napraw to, zanim zrobisz cokolwiek innego.
5. Usuń teraz-nieużywaną logikę inline, jeśli jakaś została. Uruchom
   testy jeszcze raz, na końcu.

## Kryteria akceptacji

- Plik kodów rabatowych (`discount_codes.py` / `discount_codes.go` /
  `DiscountCodes.java`) istnieje z tymi samymi trzema kodami co
  Version B.
- Obliczenie rachunku nie zawiera już łańcucha warunków sprawdzającego
  stringi kodów rabatowych bezpośrednio.
- Zestaw testów przechodzi na każdym opisanym powyżej etapie, nie
  tylko na końcu.

## Weryfikacja

### Python

```bash
cd examples/discount-codes/version-a/python
uv run pytest -v
grep -n "elif discount_code" billing/calculator.py && echo "still coupled — not done" || echo "decoupled"
cd -
```

Oczekiwane: wszystkie testy przechodzą, i wypisuje się `decoupled`.

### Go

```bash
cd examples/discount-codes/version-a/go
go build ./...
go test ./... -v
grep -n 'case "SAVE' billing/calculator.go && echo "still coupled — not done" || echo "decoupled"
cd -
```

Oczekiwane: budowanie się udaje, wszystkie testy przechodzą, i
wypisuje się `decoupled`.

### Java

```bash
cd examples/discount-codes/version-a/java
./gradlew test
grep -n "switch (discountCode)" src/main/java/billing/Calculator.java && echo "still coupled — not done" || echo "decoupled"
cd -
```

Oczekiwane: budowanie się udaje, wszystkie testy przechodzą, i
wypisuje się `decoupled`.

## Zastanów się

- Na którym pojedynczym kroku, gdybyś zrobił/a literówkę, zestaw
  testów powiedziałby Ci o tym natychmiast — a który krok mógłby
  wprowadzić cichą zmianę zachowania, której żaden obecny test nie
  łapie?
- Właśnie zmieniłeś/aś Version A w coś strukturalnie identycznego z
  Version B. Jaki był faktyczny *dowód*, na każdym kroku, że nie
  zmieniłeś/aś tego, co program robi?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** Kroki 1-2 to czyste dodawanie — nic istniejącego
  się nie zmienia, więc nic jeszcze nie może się złamać. To celowe: w
  tym momencie istniejące zachowanie jest wciąż chronione przez zestaw
  regresyjny; następny krok to przepuszczenie go przez nową strukturę.
- **Podpowiedź 2:** Krok 3 to jednoliniowe zastąpienie całego bloku
  `if discount_code == "SAVE10": ... elif ...: ... else: raise ...`
  przez `code_discount = apply_discount_code(after_loyalty,
  discount_code)`.
- **Podpowiedź 3:** Jeśli test failuje po kroku 3, porównaj, co
  `apply_discount_code` robi dla tego konkretnego kodu, z tym, co
  robił stary branch inline — niezgodność jest zwykle w dokładnie
  jednym z trzech kodów.

### Go

- **Podpowiedź 1:** Kroki 1-2 to czyste dodawanie — nic istniejącego
  się nie zmienia, więc nic jeszcze nie może się złamać. W
  przeciwieństwie do nieużywanej zmiennej *lokalnej*, nieużywana
  funkcja albo mapa na poziomie pakietu nie jest błędem kompilacji w
  Go.
- **Podpowiedź 2:** Krok 3 to jednoliniowe zastąpienie całego bloku
  `switch discountCode { case "SAVE10": ... default: return Bill{},
  fmt.Errorf(...) }` przez `codeDiscount, err =
  ApplyDiscountCode(afterLoyalty, discountCode)` (plus check `if err
  != nil`).
- **Podpowiedź 3:** Jeśli `go build ./...` narzeka na `"fmt" imported
  and not used` po kroku 3, to jest oczekiwane — jedyną rzeczą, która
  używała `fmt`, był komunikat błędu wewnątrz starego `switch`. Usuń
  import, albo zastąp go po prostu `import "math"`, jeśli to jedyna
  inna rzecz, którą plik wciąż potrzebuje.

### Java

- **Podpowiedź 1:** Kroki 1-2 to czyste dodawanie — nic istniejącego
  się nie zmienia, więc nic jeszcze nie może się złamać.
- **Podpowiedź 2:** Krok 3 to jednoliniowe zastąpienie całego bloku
  `switch (discountCode) { case "SAVE10": ... default: throw ... }`
  przez `codeDiscount = DiscountCodes.apply(afterLoyalty,
  discountCode);`.
- **Podpowiedź 3:** Jeśli test failuje po kroku 3, porównaj, co
  `DiscountCodes.apply` robi dla tego konkretnego kodu, z tym, co
  robił stary `case` inline — niezgodność jest zwykle w dokładnie
  jednym z trzech kodów.

Przed przejściem dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (zaczynający się od Lab 16)
tak — przyzwyczajaj się już teraz.

## Co dalej

Kody rabatowe to (z ostatnich dwóch labów) rodzina rzeczy, które
wszystkie "wybierają jedno zachowanie z kilku, na podstawie klucza".
Dalej zobaczysz jeszcze jeden przykład tej samej formy z zupełnie
innej części systemu — i tylko wtedy poznasz, jak się to zwykle
nazywa.

Przejdź do [Lab 14 — Jeden kontrakt, trzy języki](../14-one-contract-three-languages/README.pl.md).
