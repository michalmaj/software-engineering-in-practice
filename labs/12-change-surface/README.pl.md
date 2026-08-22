# Lab 12 — Gdzie powinna trafić ta zmiana?

## Sytuacja

Dwoje programistów niezależnie zbudowało funkcję kodów rabatowych na
podstawie specyfikacji z Lab 11. Obie wersje zachowują się dziś
identycznie. Zaraz odkryjesz, że nie są jednakowo drogie w rozbudowie.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Zidentyfikować, które pliki nowe wymaganie zmusza Cię dotknąć w danym
  projekcie.
- Wyjaśnić "coupling" (sprzężenie) i "cohesion" (spójność) na
  konkretnym przykładzie, a nie przez definicję.
- Oceniać projekt po koszcie zmiany, a nie tylko po tym, czy obecnie
  działa.

## Zanim zaczniesz

- Laby 06-11 ukończone.
- Przeczytaj zarówno
  `examples/discount-codes/version-a/billing/calculator.py`, jak i
  `examples/discount-codes/version-b/billing/calculator.py` (oraz
  `billing/discount_codes.py` wersji B), zanim zrobisz cokolwiek
  innego. Potwierdź sobie, że obie przechodzą swoje testy i dają te
  same sumy.

## Twoje zadanie

Właściciel dodał trzeci kod: `SAVE20`, wart 20% zniżki od kwoty
pozostałej po rabacie lojalnościowym (ta sama zasada co `SAVE10`, inny
procent).

1. Dodaj obsługę `SAVE20` do **Wersji A**
   (`examples/discount-codes/version-a/`). Dodaj test w
   `tests/test_calculator.py` sprawdzający, że dla dużego zamówienia
   (dwa steki po $30.00, napiwek 15%), `bill["discount"] == 16.8` i
   `bill["total"] == 53.14`.
2. Dodaj obsługę `SAVE20` do **Wersji B**
   (`examples/discount-codes/version-b/`). Dodaj tam odpowiedni test.
3. Dla każdej wersji zapisz: który plik(i) faktycznie musiałeś/aś
   zmienić? Jaki *inny* kod znajduje się w tym pliku obok Twojej
   zmiany — kod odpowiedzialny za coś niezwiązanego z kodami
   rabatowymi?
4. Odpowiedz, w pliku notatek
   `examples/discount-codes/COMPARISON.md`: gdyby zaraz po tej zmianie
   pojawił się błąd w liczeniu podatku, w której wersji łatwiej
   przekonać samego siebie, że zmiana kodu rabatowego na pewno nie
   mogła być przyczyną — tylko patrząc na to, *gdzie* zmiana została
   wprowadzona?

## Kryteria akceptacji

- Zestawy testów obu wersji przechodzą, włącznie z Twoimi nowymi
  testami `SAVE20`.
- `COMPARISON.md` wymienia konkretny plik zmieniony w każdej wersji i
  odpowiada na pytanie z kroku 4.

## Weryfikacja

```bash
cd examples/discount-codes/version-a && uv run pytest -v && cd - > /dev/null
cd examples/discount-codes/version-b && uv run pytest -v && cd - > /dev/null
test -f examples/discount-codes/COMPARISON.md && echo "comparison notes exist"
```

Oczekiwane: oba zestawy zielone (5 testów w Wersji A, 8 w Wersji B), a
notatki porównawcze istnieją.

## Zastanów się

- Obie wersje wymagały zmiany dokładnie jednego pliku. Czy "ta sama
  liczba zmienionych plików" oznacza "ten sam koszt zmiany"? Co
  faktycznie różni oba pliki, które zmieniłeś/aś?
- Czy w Wersji B mógłbyś/mogłabyś dodać czwarty kod rabatowy, nie
  czytając ani jednej linii `calculator.py`? Co to mówi o tym, jak
  sprzężony jest `discount_codes.py` z resztą logiki rachunku?

## Jeśli utkniesz

- **Podpowiedź 1:** W Wersji A Twoja zmiana to nowa gałąź `elif`
  wewnątrz `calculate_bill`. W Wersji B to nowy wpis w słowniku
  `DISCOUNT_CODES` w `discount_codes.py`.
- **Podpowiedź 2:** "20% zniżki od kwoty pozostałej po rabacie
  lojalnościowym" ma ten sam kształt co `SAVE10`, tylko inny procent.
- **Podpowiedź 3:** Dla dużego zamówienia (suma częściowa $60, rabat
  lojalnościowy $6, napiwek 15%): kwota po rabacie lojalnościowym to
  $54; `SAVE20` od tego to $10.80; łączny rabat to $16.80.

## Co dalej

Poczułeś/aś różnicę między projektem, który czyni nowe wymaganie
tanim, a takim, który czyni je jedynie możliwym. Wersja A wciąż ma
sprzężony kształt — i wciąż ma prawdziwe testy. Dalej zamienisz Wersję
A w coś bliższego Wersji B, nie psując niczego po drodze.

Przejdź do [Lab 13 — Refaktoryzacja z siatką bezpieczeństwa](../13-refactoring-safety-net/README.pl.md).
