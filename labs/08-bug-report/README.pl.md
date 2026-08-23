# Lab 08 — Nadchodzi zgłoszenie błędu

## Sytuacja

Przychodzi e-mail: "Zamówiłem/am jedzenie za $60 i dostałem/am rabat
lojalnościowy, ale podatek na rachunku wygląda na za wysoki jak na
kwotę po rabacie." Twój zestaw testów jest zielony. Klient mimo to ma
rację.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Zamienić zgłoszenie błędu na konkretny, failing test, zanim dotkniesz
  jakiegokolwiek kodu implementacji.
- Wyjaśnić, dlaczego failing test jest lepszym dowodem zrozumienia błędu
  niż `print`.
- Naprawić defekt najmniejszą możliwą zmianą kodu, prowadzony przez to,
  że test staje się zielony.

## Zanim zaczniesz

- Lab 07 ukończony: `uv run pytest` przechodzi.
- Bieżący katalog: `examples/restaurant-bill/`.

## Twoje zadanie

1. Odtwórz, ręcznie albo w tymczasowej powłoce Pythona, co zwraca
   `calculate_bill` dla zamówienia o sumie częściowej $60 (np. dwa steki
   po $30.00) przy stawce napiwku 15%. Wylicz ręcznie, jaki podatek
   *powinien* wyjść, jeśli liczony jest od kwoty po rabacie
   ($60 - 10% = $54; 8% z $54 = $4.32), w porównaniu do tego, co
   faktycznie liczy obecny kod.
2. Dodaj nowy test do `tests/test_calculator.py`,
   `test_calculate_bill_applies_tax_after_discount_on_large_order`,
   sprawdzający, że dla tego zamówienia na $60 przy stawce napiwku 15%,
   `bill["tax"] == 4.32` i `bill["total"] == 66.42`.
3. Uruchom zestaw testów i potwierdź, że ten nowy test nie przechodzi
   (czerwony).
4. Przeczytaj komunikat błędu. Zlokalizuj dokładną linię w
   `calculate_bill` za to odpowiedzialną.
5. Napraw to — zmień, z czym wywoływane jest `calculate_tax`, tak żeby
   podatek był liczony od kwoty *po* rabacie, a nie przed nim.
6. Uruchom cały zestaw ponownie i potwierdź, że wszystko przechodzi
   (zielony), włącznie z testem małego zamówienia z Lab 07.

## Kryteria akceptacji

- `tests/test_calculator.py` zawiera test dla zamówienia z rabatem,
  nazwany tak, żeby jego intencja była jasna.
- `uv run pytest` przechodzi w całości, z liczbą testów nie mniejszą niż
  wcześniej.
- Poprawka to zmiana wyłącznie tego, jak liczony jest `tax` wewnątrz
  `calculate_bill` — żadna inna funkcja nie zmienia zachowania.

## Weryfikacja

```bash
cd examples/restaurant-bill
uv run pytest -v
uv run python -c "from billing.calculator import calculate_bill; print(calculate_bill([('Steak', 30.00, 2)], 0.15))"
cd -
```

Oczekiwane: wszystkie testy `PASSED`; wypisany słownik pokazuje
`'tax': 4.32, 'total': 66.42`.

## Zastanów się

- Twoje testy z Lab 07 były zielone *przed* tą poprawką, a błąd mimo to
  istniał. Co konkretnie sprawiło, że ten błąd był niewidoczny dla tego
  zestawu testów?
- Naprawiłeś/aś błąd w `calculate_bill`, a nie w samym `calculate_tax`.
  Dlaczego `calculate_tax` nie musiało się zmienić?

## Jeśli utkniesz

- **Podpowiedź 1:** Policz błędny podatek ręcznie najpierw — dla
  zamówienia na $60, co zwraca `calculate_tax(60.0)`, a co
  `calculate_tax(60.0 - 6.0)`?
- **Podpowiedź 2:** Komunikat nieudanego assercji z pytest pokazuje Ci
  faktyczną wartość, jaką zwrócił Twój kod. Porównaj ją z oczekiwaną —
  różnica wskaże dokładnie, które dane wejściowe były błędne.
- **Podpowiedź 3:** Poprawka to jeden zmieniony argument w jednej linii
  wewnątrz `calculate_bill` — oprzyj się pokusie przebudowywania
  czegokolwiek innego.

Zanim pójdziesz dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (od Lab 16) już tak — wyrób
sobie ten nawyk już teraz.

## Co dalej

Masz zielony zestaw testów i prawdziwą poprawkę za nim. Dalej: inny
rodzaj sprawdzenia — nie "czy to poprawne", tylko "czy to jest napisane
tak, jak zespół się umówił".

Przejdź do [Lab 09 — Maszyny mogą sprawdzać nudne rzeczy](../09-automated-checks/README.pl.md).
