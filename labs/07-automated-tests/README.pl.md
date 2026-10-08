# Lab 07 — Skąd wiemy, że to działa?

## Sytuacja

Twój zrefaktoryzowany kod `billing` zachowuje się tak samo, jak
oryginalny monolit — sprawdziłeś/aś to raz, ręcznie, przez `diff`. To
się nie skaluje: nie możesz ponownie uruchamiać ręcznego diffa każdy
raz, gdy dotkniesz jednej linii. Potrzebujesz testów, które sam się
uruchamiają.

## Cele nauki

Po tym labie potrafisz:

- Napisać test jednostkowy, używając Arrange-Act-Assert.
- Wyjaśnić, czym jest "jednostka" w "teście jednostkowym", w kontekście
  tego projektu.
- Wybrać przypadki testowe pokrywające odrębne zachowania funkcji
  (albo metody), nie tylko jedną happy path.
- Uruchomić zestaw testów i przeczytać raport pass/fail, we własnym
  test runnerze Twojego języka.

## Zanim zaczniesz

- Lab 06 ukończony, w którejkolwiek ścieżce realizujesz.

### Python

- Bieżący katalog: `examples/restaurant-bill/python/`.
- `billing/calculator.py` istnieje z pięcioma funkcjami z Lab 06.

### Go

- Bieżący katalog: `examples/restaurant-bill/go/`.
- `billing/calculator.go` istnieje z typami `Item`/`Bill` i pięcioma
  funkcjami z Lab 06.

### Java

- Bieżący katalog: `examples/restaurant-bill/java/`.
- `billing/Calculator.java` istnieje z typami `Item`/`Bill` i pięcioma
  metodami z Lab 06, a `build.gradle` ma zależności JUnit 5.

## Twoje zadanie

Każda ścieżka pisze te same sześć przypadków. Strukturyzuj każdy test
jako Arrange (przygotuj dane wejściowe), Act (wywołaj funkcję), Assert
(sprawdź wynik) — nawet jeśli każda część to tylko jedna linia.

1. Obliczenie subtotal sumuje `price * quantity` dla wielu pozycji.
2. Obliczenie rabatu zwraca `0` dla subtotal poniżej `50`.
3. Obliczenie rabatu zwraca 10% subtotal, gdy jest na poziomie `50` lub
   wyżej.
4. Obliczenie podatku zwraca 8% dowolnej podanej kwoty.
5. Obliczenie napiwku zwraca podany procent dowolnej podanej kwoty.
6. Obliczenie całego rachunku, dla **małego zamówienia, które nie
   uruchamia rabatu** (te same trzy pozycje co w przykładzie rachunku:
   burger, frytki, soda — subtotal $38), zwraca total `46.74`.

### Python

Utwórz `tests/test_calculator.py`. Tutaj masz wystarczająco, żeby
zacząć pierwszy przypadek — napisz pozostałe pięć sam/a, w tej samej
formie:

```python
from billing.calculator import calculate_subtotal


def test_calculate_subtotal_sums_multiple_items():
    items = [("Burger", 12.50, 2), ("Fries", 4.00, 2)]

    result = calculate_subtotal(items)

    assert result == 33.00
```

### Go

Utwórz `billing/calculator_test.go` (ten sam pakiet co `calculator.go`
— to daje Twoim testom bezpośredni dostęp do wszystkiego w nim, gdyby
go potrzebowały). Tutaj masz wystarczająco, żeby zacząć pierwszy
przypadek — napisz pozostałe pięć sam/a, w tej samej formie. Dla
przypadków rabatu (2 i 3), rozważ test table-driven — jeden
`[]struct{...}` par wejście/oczekiwane, w pętli z `t.Run` — bo to ten
sam check powtórzony z różnymi liczbami:

```go
package billing

import "testing"

func TestCalculateSubtotalSumsMultipleItems(t *testing.T) {
	items := []Item{
		{Name: "Burger", Price: 12.50, Qty: 2},
		{Name: "Fries", Price: 4.00, Qty: 2},
	}

	got := CalculateSubtotal(items)

	want := 33.00
	if got != want {
		t.Errorf("got %.2f, want %.2f", got, want)
	}
}
```

### Java

Utwórz `src/test/java/billing/CalculatorTest.java` (pakiet `billing`,
odpowiadający `Calculator.java`). Tutaj masz wystarczająco, żeby zacząć
pierwszy przypadek — napisz pozostałe pięć sam/a, w tej samej formie:

```java
package billing;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;
import org.junit.jupiter.api.Test;

class CalculatorTest {

    @Test
    void calculateSubtotalSumsMultipleItems() {
        List<Calculator.Item> items = List.of(
                new Calculator.Item("Burger", 12.50, 2),
                new Calculator.Item("Fries", 4.00, 2));

        double subtotal = Calculator.calculateSubtotal(items);

        assertEquals(33.00, subtotal);
    }
}
```

## Kryteria akceptacji

- Istnieje co najmniej sześć testów, jeden na każdy przypadek
  wymieniony powyżej (więcej jest w porządku — na przykład podzielenie
  przypadku rabatu na dwa jest zachęcane).
- Każdy test podąża za Arrange-Act-Assert, nawet nieformalnie — żadnej
  ceremonii frameworka testowego poza tym, co już daje standardowe
  narzędzie Twojego języka.

### Python

- `uv run pytest -v` przechodzi, z co najmniej jednym testem na każdą
  funkcję wymienioną powyżej.

### Go

- `go test ./...` przechodzi, z co najmniej jednym testem (albo
  subtestem, jeśli użyłeś/aś testów table-driven) na każdy przypadek
  wymieniony powyżej.

### Java

- `./gradlew test` przechodzi, z co najmniej jednym testem na każdy
  przypadek wymieniony powyżej.

## Weryfikacja

### Python

```bash
cd examples/restaurant-bill/python
uv run pytest -v
cd -
```

Oczekiwane: każdy test pokazany jako `PASSED`, żaden `FAILED`, żaden
skipped.

### Go

```bash
cd examples/restaurant-bill/go
go test ./... -v
cd -
```

Oczekiwane: każdy test pokazany jako `--- PASS`, żaden `--- FAIL`.

### Java

```bash
cd examples/restaurant-bill/java
./gradlew test
cd -
```

Oczekiwane: `BUILD SUCCESSFUL`. Otwórz
`build/reports/tests/test/index.html` w przeglądarce, jeśli chcesz
zobaczyć każdy test wylistowany osobno.

## Zastanów się

- Wszystkie sześć Twoich testów przechodzi. Czy to dowodzi, że
  obliczenie całego rachunku jest poprawne dla *każdego* zamówienia,
  czy tylko dla konkretnych wejść, które wypróbowałeś/aś?
- Przetestowałeś/aś małe zamówienie i wartość wystarczająco dużą, żeby
  uruchomić rabat, dla samego obliczenia rabatu — ale czy przetestowałeś/aś
  obliczenie całego rachunku z zamówieniem wystarczająco dużym, żeby
  uruchomić rabat? Co to mogłoby ujawnić, czego Twoje obecne testy nie
  mogą?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** Zaimportuj to, co testujesz, na górze pliku:
  `from billing.calculator import calculate_subtotal, calculate_discount,
  calculate_tax, calculate_tip, calculate_bill`.
- **Podpowiedź 2:** Test to po prostu funkcja zaczynająca się od
  `test_`, zawierająca instrukcje `assert` — pytest znajduje ją i
  uruchamia automatycznie.
- **Podpowiedź 3:** Dla wyników zmiennoprzecinkowych, porównywanie przez
  `==` po zaokrągleniu do 2 miejsc po przecinku (co `calculate_bill`
  już robi) jest wystarczająco wiarygodne dla tego projektu; nie
  potrzebujesz tu `pytest.approx`.

### Go

- **Podpowiedź 1:** Umieszczenie pliku testowego w `package billing`
  (nie `package billing_test`) daje Twoim testom bezpośredni dostęp do
  nieeksportowanych detali, gdybyś ich kiedyś potrzebował/a — choć w
  tym labie wystarczy pięć eksportowanych funkcji.
- **Podpowiedź 2:** Test to funkcja nazwana `TestXxx(t *testing.T)` w
  pliku kończącym się na `_test.go` — `go test` znajduje ją i uruchamia
  automatycznie.
- **Podpowiedź 3:** Dla testu table-driven, slice małych structów
  (nazwa, wejście, oczekiwane) w pętli z `for _, c := range cases {
  t.Run(c.name, func(t *testing.T) { ... }) }` utrzymuje powtarzane
  przypadki krótkimi, bez kopiowania logiki asercji.

### Java

- **Podpowiedź 1:** `@Test` na metodzie bez argumentów i zwracanym
  typem `void` to jest to, czego szuka JUnit 5 — `./gradlew test`
  znajduje ją i uruchamia automatycznie.
- **Podpowiedź 2:** `assertEquals(expected, actual)` — expected jest
  pierwszy; odwrócenie kolejności nie psuje testu, ale sprawia, że
  komunikaty o porażce czyta się myląco.
- **Podpowiedź 3:** Dla wyników zmiennoprzecinkowych, `assertEquals(double,
  double)` porównuje dokładnie; to jest tu w porządku, bo każda wartość
  w tym projekcie (ceny, stawki, sumy) jest już dokładną liczbą
  dwumiejscową w momencie, gdy jest obliczana.

Przed przejściem dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (zaczynający się od Lab 16)
tak — przyzwyczajaj się już teraz.

## Co dalej

Twoje testy są zielone. Potem klient narzeka na swój rachunek. Czas
sprawdzić, czy "wszystkie testy przechodzą" i "kod jest poprawny" to
faktycznie to samo.

Przejdź do [Lab 08 — Nadchodzi zgłoszenie błędu](../08-bug-report/README.pl.md).
