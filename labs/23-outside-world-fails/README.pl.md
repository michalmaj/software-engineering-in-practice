# Lab 23 — Świat zewnętrzny zawodzi

## Sytuacja

Każde nowe zamówienie powinno wywołać powiadomienie do serwisu
śledzenia dostaw kuchni. Ten serwis jest prawdziwy, zewnętrzny i — jak
każdy serwis zewnętrzny — czasami nie odpowiada za pierwszym razem.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Opakować zawodne wywołanie w politykę ponawiania z maksymalną liczbą
  prób.
- Przetestować logikę ponawiania bez prawdziwej sieci, używając
  fake'a, który zawodzi na żądanie.
- Wyjaśnić, dlaczego zamówienie jest nadal tworzone, nawet gdy
  powiadomienie ostatecznie zawodzi.

## Zanim zaczniesz

- Lab 22 ukończony: zamówienia są trwałe w SQLite, migracja `notes`
  działa.
- Bieżący katalog: `examples/order-api/`.

## Twoje zadanie

1. Utwórz `kitchen_client.py` z `class NotifierError(Exception):
   pass`.
2. W tym samym pliku napisz
   `call_with_retries(send_fn, max_attempts: int = 3, backoff_seconds:
   float = 0.0) -> None`: wywołaj `send_fn()`; jeśli rzuci
   `NotifierError`, odczekaj `backoff_seconds` i spróbuj ponownie, aż
   do `max_attempts` prób razem; jeśli każda próba zawiedzie, rzuć
   ponownie ostatni błąd.
3. W `tests/test_kitchen_client.py` napisz pomocniczą klasę testową
   `FlakyClient` — klasę z metodą `send(self)`, która rzuca
   `NotifierError` dla swoich pierwszych `fail_times` wywołań, potem
   się udaje, śledząc, ile razy została wywołana.
4. Napisz trzy testy: udaje się za pierwszym razem (`fail_times=0`);
   udaje się po dwóch niepowodzeniach (`fail_times=2`,
   `max_attempts=3`, potwierdź, że doszło dokładnie do 3 wywołań); oraz
   wyczerpuje wszystkie próby i rzuca błąd (`fail_times=5`,
   `max_attempts=3`, potwierdź dokładnie 3 wywołania przed
   propagacją błędu). Użyj `backoff_seconds=0`, żeby testy działały
   natychmiast.
5. W `api.py` dodaj funkcję `notify_kitchen(order_id: str) -> None`
   (na razie po prostu `pass` — nie masz prawdziwego serwisu dostaw do
   wywołania). W `do_POST`, zaraz po pomyślnym utworzeniu zamówienia,
   wywołaj ją przez swój wrapper retry:
   `call_with_retries(lambda: notify_kitchen(order["order_id"]))`,
   łapiąc `NotifierError`, żeby nieudane powiadomienie nie psuło całego
   żądania — zamówienie i tak jest tworzone.
6. Zrób pracę z tego labu na gałęzi (na przykład
   `feature/outside-world-fails`), wypchnij ją i otwórz pull request.
   Zmerguj dopiero, gdy CI jest zielone — ta sama pętla co w Lab 21 i
   22.

## Kryteria akceptacji

- `kitchen_client.py` definiuje `NotifierError` i `call_with_retries`.
- Wszystkie trzy testy zachowania ponawiania przechodzą, a każdy
  sprawdza dokładną liczbę wywołań, nie tylko końcowy wynik.
- `do_POST` nadal zwraca `201` dla poprawnego zamówienia, mimo że
  `notify_kitchen` jest tylko namiastką.
- Zmiany z tego labu zostały zmergowane przez pull request z zielonym
  checkiem CI, nie zacommitowane bezpośrednio na `main`.

## Weryfikacja

```bash
cd examples/order-api
uv run pytest -v
cd -
```

Oczekiwane: wszystkie testy przechodzą (8 razem: 5 z wcześniejszych
labów, 3 nowe).

## Zastanów się

- Twoje testy nigdy naprawdę nie śpią (`backoff_seconds=0`), mimo że
  prawdziwa funkcja wspiera odczekiwanie. Dlaczego to jest właściwy
  kompromis dla testu, a niewłaściwy dla produkcji?
- Zamówienie jest tworzone w bazie danych *przed* próbą powiadomienia,
  a niepowodzenie powiadomienia go nie cofa. Co poszłoby źle, gdybyś
  zbudował/a to w drugą stronę — najpierw powiadom, potem utwórz
  zamówienie tylko jeśli powiadomienie się powiodło?

## Jeśli utkniesz

- **Podpowiedź 1:** `call_with_retries` potrzebuje pętli od `1` do
  `max_attempts` włącznie, `try`/`except NotifierError` i `return` przy
  sukcesie.
- **Podpowiedź 2:** `FlakyClient` musi liczyć własne wywołania
  (`self.calls += 1`), żeby Twoje testy mogły sprawdzić, ile razy
  `send_fn` faktycznie zadziałało.
- **Podpowiedź 3:** Lambda `lambda: notify_kitchen(order["order_id"])`
  pozwala `call_with_retries` wywołać `notify_kitchen` z właściwym
  argumentem przy każdej próbie, bez konieczności, żeby
  `call_with_retries` cokolwiek wiedziało o sygnaturze
  `notify_kitchen`.

## Co dalej

Powiadomienia mogą teraz zawodzić po cichu — nic nie zapisuje, że się
wydarzyły albo że nie. Dalej dajesz systemowi sposób, żeby wyjaśnił
się sam po fakcie.

Przejdź do [Lab 24 — Produkcja mówi "to nie działa"](../24-production-says-it-doesnt-work/README.pl.md).
