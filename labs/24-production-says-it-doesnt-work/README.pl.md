# Lab 24 — Produkcja mówi "to nie działa"

## Sytuacja

Użytkownik zgłasza: "próbowałem sprawdzić moje zamówienie i nic nie
dostałem." Proces nadal działa. Na ekranie nie ma żadnego błędu. Nie
masz pojęcia, które zamówienie, ani co faktycznie się stało, bo nic
nigdy nie zostało zapisane.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Dodać komunikaty logowania z poziomami (`INFO`, `WARNING`, `ERROR`) w
  momentach, które mają znaczenie w cyklu życia żądania.
- Uwzględnić wystarczający kontekst (id zamówienia) w linii logu, żeby
  prześledzić historię jednego konkretnego żądania.
- Przetestować, że komunikat logu faktycznie powstał, używając
  fixture'a `caplog` z pytest.

## Zanim zaczniesz

- Lab 23 ukończony: `call_with_retries` i `notify_kitchen` istnieją i
  są podłączone do `do_POST`.
- Bieżący katalog: `examples/order-api/`.

## Twoje zadanie

1. Dodaj `import logging` i `logger = logging.getLogger("order_api")`
   blisko góry `api.py`.
2. W `do_POST`, zaraz po utworzeniu zamówienia, zaloguj na poziomie
   `INFO`: uwzględnij id zamówienia i ile ma pozycji.
3. W `do_GET`, gdy zamówienie nie zostanie znalezione, zaloguj na
   poziomie `WARNING`: uwzględnij żądane id zamówienia.
4. W `kitchen_client.py` dodaj `logger = logging.getLogger
   ("kitchen_client")`. W `call_with_retries` zaloguj `WARNING` przy
   każdej nieudanej próbie (uwzględnij numer próby i błąd) oraz
   `ERROR`, jeśli wszystkie próby się wyczerpią.
5. W `run()` skonfiguruj logowanie raz, przez `logging.basicConfig`,
   uwzględniając znacznik czasu, poziom i nazwę loggera w formacie.
6. Napisz dwa testy używające fixture'a `caplog` z pytest: jeden
   potwierdzający, że utworzenie zamówienia produkuje rekord logu
   `INFO`; jeden potwierdzający, że zapytanie o brakujące zamówienie
   produkuje rekord `WARNING`.
7. Uruchom serwer ręcznie, wykonaj kilka żądań (w tym jedno o brakujące
   zamówienie), i przeczytaj wyjście logów w swoim terminalu. Potwierdź,
   że możesz stwierdzić, co się stało, nie otwierając `api.py`.

## Kryteria akceptacji

- Zarówno `api.py`, jak i `kitchen_client.py` konfigurują i używają
  nazwanego loggera (nie gołego `print`).
- Utworzenie zamówienia loguje na `INFO` z id zamówienia; brakujące
  zamówienie loguje na `WARNING` z żądanym id; nieudana próba
  ponowienia loguje na `WARNING`, a wyczerpanie wszystkich prób loguje
  na `ERROR`.
- Dwa testy oparte na `caplog` przechodzą, potwierdzając przypadki
  `INFO` i `WARNING`.

## Weryfikacja

```bash
cd examples/order-api
uv run pytest -v
cd -
```

Oczekiwane: wszystkie testy przechodzą, włącznie z dwoma nowymi testami
logowania.

## Zastanów się

- Mógłbyś/mogłabyś użyć `print()` wszędzie zamiast `logging`. Co
  tracisz, robiąc tak — konkretnie, co mógł sprawdzić `caplog` w
  wywołaniach `logging`, czego nie mógłby sprawdzić w wywołaniach
  `print`?
- Dlaczego nieudana próba ponowienia `notify_kitchen` loguje na
  `WARNING` przy każdej próbie, ale `ERROR` tylko raz, na końcu, zamiast
  `ERROR` przy każdej nieudanej próbie?

## Jeśli utkniesz

- **Podpowiedź 1:** `logging.getLogger(nazwa)` zwraca ten sam obiekt
  loggera za każdym razem, gdy wywołane z tą samą `nazwą` — tak
  `api.py` i jego testy mogą oba odnosić się do `"order_api"` i widzieć
  tę samą konfigurację.
- **Podpowiedź 2:** `caplog.at_level(logging.INFO, logger="order_api")`
  jako menedżer kontekstu przechwytuje tylko rekordy na poziomie `INFO`
  lub wyższym, z tego konkretnego loggera, dla kodu wewnątrz bloku
  `with`.
- **Podpowiedź 3:** `logger.info("order %s created with %d items",
  order_id, count)` — przekaż wartości jako osobne argumenty, nie
  przez f-string; to pozwala `logging` całkowicie pominąć formatowanie,
  gdy poziom logu jest wyłączony.

## Co dalej

Masz testy, review, CI, a teraz logi — system potrafi sam się
wytłumaczyć. Dalej musisz zdecydować, co właściwie oznacza "ta wersja",
gdy przekazujesz ją komuś innemu.

Przejdź do [Lab 25 — Wydanie i kompatybilność](../25-release-and-compatibility/README.pl.md).
