# Lab 07 — Skąd wiemy, że to działa?

## Sytuacja

Twój przerobiony pakiet `billing` zachowuje się tak samo jak stary
skrypt — sprawdziłeś/aś to raz, ręcznie, przez `diff`. To się nie
skaluje: nie możesz ponownie uruchamiać ręcznego diffa za każdym razem,
gdy dotkniesz jednej linijki. Potrzebujesz testów, które uruchamiają się
same.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Napisać test jednostkowy metodą Arrange-Act-Assert.
- Wyjaśnić, czym jest "jednostka" w "teście jednostkowym", w kontekście
  tego projektu.
- Dobrać przypadki testowe pokrywające odrębne zachowania funkcji (a nie
  tylko jedną ścieżkę "happy path").
- Uruchomić zestaw testów i odczytać raport pass/fail.

## Zanim zaczniesz

- Lab 06 ukończony: `billing/calculator.py` istnieje z pięcioma
  funkcjami, `main.py` odtwarza dokładny wynik `bill.py`, a `tests/`
  istnieje jako pusty katalog.
- Bieżący katalog: `examples/restaurant-bill/`.

## Twoje zadanie

Utwórz `tests/test_calculator.py` z testami dla każdej funkcji w
`billing/calculator.py`. Minimalnie uwzględnij:

1. `calculate_subtotal` zwraca sumę `price * quantity` po wielu
   elementach.
2. `calculate_discount` zwraca `0` dla sumy częściowej poniżej `50`.
3. `calculate_discount` zwraca 10% sumy częściowej, gdy jest ona równa
   lub większa niż `50`.
4. `calculate_tax` zwraca 8% dowolnej podanej kwoty.
5. `calculate_tip` zwraca podany procent dowolnej podanej kwoty.
6. `calculate_bill`, dla **małego zamówienia, które nie uruchamia
   rabatu** (np. te same trzy pozycje co w przykładzie z rachunku:
   burger, frytki, napój — suma częściowa $38), zwraca `total == 46.74`.

Skonstruuj każdy test jako Arrange (przygotuj dane wejściowe), Act
(wywołaj funkcję), Assert (sprawdź wynik) — nawet jeśli każda część to
tylko jedna linijka.

## Kryteria akceptacji

- `uv run pytest -v` przechodzi, z co najmniej jednym testem na funkcję
  z listy powyżej (minimum 6 testów).
- Każdy test stosuje Arrange-Act-Assert, nawet nieformalnie (nie
  potrzebujesz frameworków-w-frameworkach — zwykły `assert` wystarczy).

## Weryfikacja

```bash
cd examples/restaurant-bill
uv run pytest -v
cd -
```

Oczekiwane: każdy test pokazany jako `PASSED`, żaden `FAILED`, żaden
pominięty.

## Zastanów się

- Wszystkie sześć Twoich testów przechodzi. Czy to dowodzi, że
  `calculate_bill` jest poprawne dla *każdego* zamówienia, czy tylko dla
  konkretnych danych, których użyłeś/aś?
- Przetestowałeś/aś mały zamówienie i wartość wystarczająco dużą, by
  uruchomić rabat, osobno w `calculate_discount` — ale czy przetestowałeś
  samo `calculate_bill` z zamówieniem na tyle dużym, żeby uruchomić
  rabat? Co mogłoby to ujawnić, czego Twoje obecne testy nie wyłapią?

## Jeśli utkniesz

- **Podpowiedź 1:** Zaimportuj to, co testujesz, na górze pliku:
  `from billing.calculator import calculate_subtotal, calculate_discount,
  calculate_tax, calculate_tip, calculate_bill`.
- **Podpowiedź 2:** Test to po prostu funkcja zaczynająca się od `test_`,
  zawierająca instrukcje `assert` — pytest sam ją znajdzie i uruchomi.
- **Podpowiedź 3:** Dla wyników zmiennoprzecinkowych porównanie przez
  `==` po zaokrągleniu do 2 miejsc (tak jak już robi `calculate_bill`)
  jest wystarczająco niezawodne w tym projekcie; nie potrzebujesz tu
  `pytest.approx`.

Zanim pójdziesz dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (od Lab 16) już tak — wyrób
sobie ten nawyk już teraz.

## Co dalej

Twoje testy są zielone. Potem klient zgłasza reklamację dotyczącą swojego
rachunku. Czas sprawdzić, czy "wszystkie testy przechodzą" i "kod jest
poprawny" to naprawdę to samo.

Przejdź do [Lab 08 — Nadchodzi zgłoszenie błędu](../08-bug-report/README.pl.md).
