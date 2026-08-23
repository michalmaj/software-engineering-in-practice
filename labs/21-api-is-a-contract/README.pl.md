# Lab 21 — API to kontrakt

## Sytuacja

Inna część systemu kuchni musi tworzyć zamówienia i sprawdzać ich stan
— nie importując Twojego kodu w Pythonie, tylko przez sieć, z
programu, który może nawet nie być napisany w Pythonie. Potrzebujesz
granicy, na którą obie strony mogą się zgodzić, nie czytając nawzajem
swojego kodu źródłowego.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Opisać kontrakt endpointu HTTP: kształt żądania, kształt odpowiedzi,
  kody statusu i format błędu.
- Wyjaśnić, dlaczego kontrakt musi określać zachowanie przy błędzie, a
  nie tylko ścieżkę sukcesu.
- Dodać nową regułę walidacji do istniejącego endpointu, nie zmieniając
  jego kontraktu dla wywołujących, którzy już wcześniej postępowali
  poprawnie.

## Zanim zaczniesz

- Laby 06-20 ukończone.
- Bieżący katalog: `examples/order-api/`.
- Potwierdź, że starter działa: `uv run pytest -v`.

## Twoje zadanie

1. Uruchom serwer: `uv run python api.py` (zostaw go działającego). W
   drugim terminalu przetestuj go ręcznie:
   ```bash
   curl -i -X POST http://localhost:8000/orders \
     -H "Content-Type: application/json" \
     -d '{"items": ["Burger", "Fries"]}'
   curl -i http://localhost:8000/orders/1
   curl -i http://localhost:8000/orders/999
   ```
2. Zatrzymaj serwer (`Ctrl+C`), gdy zobaczysz wszystkie trzy odpowiedzi.
3. Napisz `CONTRACT.md` w `examples/order-api/` dokumentujący, dla
   każdego endpointu: metodę HTTP i ścieżkę, kształt ciała żądania
   (jeśli jest), każdą odpowiedź, jaką może wyprodukować (kod statusu +
   kształt ciała), i co powoduje każdą odpowiedź błędu.
4. Dodaj jeszcze jedną regułę walidacji do `do_POST`: każdy wpis w
   `items` musi być niepustym stringiem. Jeśli którykolwiek nie jest
   (liczba, pusty string, `null` itd.), odpowiedz `400 {"error": "each
   item must be a non-empty string"}` zamiast tworzyć zamówienie.
5. Dodaj test dla nowej reguły walidacji w `tests/test_api.py`.
6. Zaktualizuj `CONTRACT.md`, żeby opisać też ten nowy przypadek błędu.
7. Skonfiguruj CI dla `order-api`: utwórz
   `.github/workflows/order-api-ci.yml` (ten sam wzorzec co
   `team-inventory-ci.yml` z Lab 19), wyzwalany przez `[push,
   pull_request]`, który checkoutuje repo, ustawia Pythona 3.13,
   instaluje `uv` przypięte do `0.11.21` przez akcję
   `astral-sh/setup-uv`, a potem uruchamia `uv sync --locked` i
   `uv run pytest` z `working-directory: examples/order-api`.
8. Zrób pracę z tego labu na gałęzi (na przykład
   `feature/api-contract`), wypchnij ją i otwórz pull request.
   Potwierdź, że nowy check CI staje się zielony, potem zmerguj. Pętla
   branch → PR → zielone CI → merge z Aktu IV nie znika tylko dlatego,
   że Akt V zmienił projekt, nad którym pracujesz — od teraz przez
   resztę Aktu V każda zmiana w labie przechodzi przez nią, teraz
   obejmując też `order-api`.

## Kryteria akceptacji

- `CONTRACT.md` istnieje i dokumentuje każdy endpoint, każdy kod
  statusu, jaki może zwrócić, i co wywołuje każdy z nich.
- Nowa reguła walidacji pozycji jest zaimplementowana i ma przechodzący
  test.
- `uv run pytest` przechodzi z oryginalnymi trzema testami plus Twoim
  nowym (4 razem).
- `.github/workflows/order-api-ci.yml` istnieje, wyzwala się na push i
  pull request, i uruchamia `uv run pytest` w `examples/order-api`.
- Zmiany z tego labu zostały zmergowane przez pull request z zielonym
  checkiem CI, nie zacommitowane bezpośrednio na `main`.

## Weryfikacja

```bash
cd examples/order-api
uv run pytest -v
test -f CONTRACT.md && echo "contract documented"
cd -
test -f .github/workflows/order-api-ci.yml && echo "CI workflow exists"
```

Oczekiwane: `4 passed`, `contract documented` i `CI workflow exists` —
plus zielony check na pull requeście, który zmergował ten lab.

## Zastanów się

- Gdybyś zmienił/a odpowiedź udanego `POST`, zagnieżdżając `items`
  wewnątrz nowego klucza `"order"` zamiast na najwyższym poziomie, czy
  to złamałoby klienta napisanego względem Twojego obecnego
  `CONTRACT.md`? Czy dodanie nowego, opcjonalnego pola do odpowiedzi by
  to złamało?
- Twoja reguła walidacji dla pozycji `items` jest nowa. Czy klient,
  który już wcześniej wysyłał poprawne dane (niepuste stringi),
  w ogóle zauważyłby, że ta zmiana nastąpiła?

## Jeśli utkniesz

- **Podpowiedź 1:** `curl -i` pokazuje linię statusu odpowiedzi i
  nagłówki, nie tylko treść — przydatne do potwierdzania kodów
  statusu ręcznie.
- **Podpowiedź 2:** Nowa walidacja trafia do `do_POST`, sprawdzana
  zaraz po istniejącym sprawdzeniu "musi być niepustą listą", przed
  utworzeniem zamówienia.
- **Podpowiedź 3:** `all(isinstance(item, str) and item.strip() for
  item in items)` to jeden ze sposobów sprawdzenia, że każda pozycja
  jest niepustym stringiem.

## Co dalej

Twoje API działa — dopóki go nie zrestartujesz, a wtedy każde
zamówienie, które utworzyłeś/aś, znika. Dalej dane będą musiały
faktycznie przetrwać.

Przejdź do [Lab 22 — Kod się zmienił, stare dane zostały](../22-data-outlives-code/README.pl.md).
