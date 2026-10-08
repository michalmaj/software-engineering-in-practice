# Lab 08 — Nadchodzi zgłoszenie błędu

## Sytuacja

Przychodzi e-mail: "Zamówiłem/am jedzenie za $60 i dostałem/am rabat
lojalnościowy, ale podatek na moim rachunku wygląda zbyt wysoko dla
kwoty po rabacie." Twój zestaw testów jest zielony. Klient wciąż ma
rację.

## Cele nauki

Po tym labie potrafisz:

- Zamienić zgłoszenie błędu w konkretny, failujący test, zanim
  dotkniesz jakiegokolwiek kodu implementacji.
- Wyjaśnić, czemu failujący test jest lepszym dowodem zrozumienia
  błędu niż instrukcja print.
- Naprawić defekt najmniejszą możliwą zmianą kodu, kierując się testem
  przechodzącym z red do green.

## Zanim zaczniesz

- Lab 07 ukończony, w którejkolwiek ścieżce realizujesz: Twoje sześć
  (albo więcej) testów przechodzi.

### Python

- Bieżący katalog: `examples/restaurant-bill/python/`.

### Go

- Bieżący katalog: `examples/restaurant-bill/go/`.

### Java

- Bieżący katalog: `examples/restaurant-bill/java/`.

## Twoje zadanie

Każda ścieżka odtwarza i naprawia dokładnie ten sam błąd z dokładnie
tymi samymi liczbami.

1. Odtwórz, ręcznie albo w zapasowej powłoce dla swojego języka, co
   zwraca obliczenie całego rachunku dla zamówienia, którego subtotal
   to $60 (na przykład dwa steki po $30.00) ze stawką napiwku 15%.
   Wylicz ręcznie, jaki podatek *powinien* być, jeśli jest liczony od
   kwoty po rabacie ($60 - 10% = $54; 8% z $54 = $4.32), w porównaniu z
   tym, co kod aktualnie liczy.
2. Dodaj nowy test, asercjonujący, że dla tego zamówienia $60 ze stawką
   napiwku 15%, `tax == 4.32` i `total == 66.42`.
3. Uruchom zestaw testów i potwierdź, że ten nowy test failuje (red).
4. Przeczytaj komunikat o porażce. Zlokalizuj dokładną linię
   odpowiedzialną za obliczenie podatku wewnątrz obliczenia całego
   rachunku.
5. Napraw to — zmień, co jest podawane jako wejście do obliczenia
   podatku, żeby podatek był liczony od kwoty *po* rabacie, nie przed
   nim.
6. Uruchom cały zestaw jeszcze raz i potwierdź, że wszystko przechodzi
   (green), wliczając każdy test z Lab 07.

### Python

Nazwij nowy test
`test_calculate_bill_applies_tax_after_discount_on_large_order`, w
`tests/test_calculator.py`.

### Go

Nazwij nowy test
`TestCalculateBillAppliesTaxAfterDiscountOnLargeOrder`, w
`billing/calculator_test.go`.

### Java

Nazwij nowy test
`calculateBillAppliesTaxAfterDiscountOnLargeOrder`, w
`src/test/java/billing/CalculatorTest.java`.

## Kryteria akceptacji

- Istnieje test dla zamówienia $60 po rabacie, nazwany tak, żeby jego
  intencja była jasna, asercjonujący i podatek, i total.
- Pełny zestaw testów przechodzi kompletnie, bez mniejszej liczby
  testów niż przed.
- Poprawka zmienia tylko to, jak podatek jest liczony wewnątrz
  obliczenia całego rachunku — zachowanie żadnej innej funkcji (albo
  metody) się nie zmienia.

## Weryfikacja

### Python

```bash
cd examples/restaurant-bill/python
uv run pytest -v
uv run python -c "from billing.calculator import calculate_bill; print(calculate_bill([('Steak', 30.00, 2)], 0.15))"
cd -
```

Oczekiwane: wszystkie testy `PASSED`; wypisany dict pokazuje `'tax':
4.32, 'total': 66.42`.

### Go

```bash
cd examples/restaurant-bill/go
go test ./... -v
cd -
```

Oczekiwane: wszystkie testy `--- PASS`, wliczając nowy.

### Java

```bash
cd examples/restaurant-bill/java
./gradlew test
cd -
```

Oczekiwane: `BUILD SUCCESSFUL`, wszystkie testy przechodzą, wliczając
nowy.

## Zastanów się

- Twoje testy z Lab 07 były wszystkie zielone *przed* tą poprawką, a
  błąd wciąż istniał. Co sprawiło, że ten błąd był niewidoczny właśnie
  dla tego zestawu testów?
- Naprawiłeś/aś błąd w obliczeniu całego rachunku, nie w samym
  obliczeniu podatku. Czemu obliczenie podatku nie musiało się zmienić?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** Policz buggy podatek ręcznie najpierw — dla
  zamówienia $60, co zwraca `calculate_tax(60.0)`, w porównaniu z
  `calculate_tax(60.0 - 6.0)`?
- **Podpowiedź 2:** Komunikat o failującej asercji z pytest pokazuje
  Ci rzeczywistą wartość, którą Twój kod wyprodukował. Porównaj ją z
  tym, czego oczekiwałeś/aś — różnica mówi Ci dokładnie, które wejście
  było błędne.
- **Podpowiedź 3:** Poprawka to jeden zmieniony argument na jednej
  linii wewnątrz `calculate_bill` — oprzyj się chęci restrukturyzowania
  czegokolwiek innego.

### Go

- **Podpowiedź 1:** Policz buggy podatek ręcznie najpierw — dla
  zamówienia $60, co zwraca `CalculateTax(60.0)`, w porównaniu z
  `CalculateTax(60.0 - 6.0)`?
- **Podpowiedź 2:** Wynik `t.Errorf` failującego testu pokazuje Ci
  rzeczywistą wartość, którą Twój kod wyprodukował. Porównaj ją z tym,
  czego oczekiwałeś/aś — różnica mówi Ci dokładnie, które wejście było
  błędne.
- **Podpowiedź 3:** Poprawka to jeden zmieniony argument na jednej
  linii wewnątrz `CalculateBill` — oprzyj się chęci restrukturyzowania
  czegokolwiek innego.

### Java

- **Podpowiedź 1:** Policz buggy podatek ręcznie najpierw — dla
  zamówienia $60, co zwraca `Calculator.calculateTax(60.0)`, w
  porównaniu z `Calculator.calculateTax(60.0 - 6.0)`?
- **Podpowiedź 2:** Wynik porażki JUnit 5 pokazuje Ci rzeczywistą
  wartość, którą Twój kod wyprodukował, obok oczekiwanej. Różnica mówi
  Ci dokładnie, które wejście było błędne.
- **Podpowiedź 3:** Poprawka to jeden zmieniony argument na jednej
  linii wewnątrz `calculateBill` — oprzyj się chęci restrukturyzowania
  czegokolwiek innego.

Przed przejściem dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (zaczynający się od Lab 16)
tak — przyzwyczajaj się już teraz.

## Co dalej

Masz zielony zestaw testów i prawdziwą poprawkę za nim. Dalej inny
rodzaj sprawdzenia: nie poprawność, ale czy kod jest napisany tak, jak
zespół się zgodził go pisać.

Przejdź do [Lab 09 — Maszyny mogą sprawdzać nudne rzeczy](../09-automated-checks/README.pl.md).
