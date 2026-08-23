# Lab 15 — Wzorce bez kultu wzorców

## Sytuacja

Spójrz jeszcze raz na słownik `DISCOUNT_CODES` w `discount_codes.py`
oraz na trzy implementacje `Notifier` z Lab 14. Zbudowałeś/aś oba, zanim
ktokolwiek powiedział Ci ich "oficjalną" nazwę. Okazuje się, że jedna
istnieje.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Rozpoznać wzorzec Strategy w kodzie, który już napisałeś/aś, zanim
  poznasz jego nazwę.
- Wyjaśnić Dependency Injection na przykładzie funkcji, którą już
  napisałeś/aś (`send_receipt_ready`), a nie przez definicję.
- Wyjaśnić, po jednym zdaniu, do czego służą Factory i Adapter.

## Zanim zaczniesz

- Laby 12-14 ukończone.
- Żadnych nowych katalogów kodu — ten lab powraca do
  `discount_codes.py` i przykładów `notifier` z ostatnich trzech
  labów.

## Twoje zadanie

1. Przeczytaj ponownie słownik `DISCOUNT_CODES` i
   `apply_discount_code` z `discount_codes.py`. Przeczytaj ponownie
   trzy implementacje `Notifier` i `send_receipt_ready`. W pliku
   notatek `labs/15-patterns-without-worship/my-notes.md` zapisz
   własnymi słowami, co te dwa fragmenty kodu mają wspólnego —
   konkretnie, jak każdy z nich unika łańcucha `if/elif` przy wyborze
   zachowania.
2. Teraz nazwa: ten kształt — kilka zamiennych implementacji tego
   samego małego kontraktu, wybieranych przez wywołującego, zamiast
   wypieczonych w jednym wielkim warunku — nazywa się wzorcem
   **Strategy**. `DISCOUNT_CODES["SAVE10"]` to strategia.
   `ConsoleNotifier` i `InMemoryNotifier` to każda strategia dostarczania
   powiadomienia.
3. `send_receipt_ready(notifier, order_id)` przyjmuje swoją strategię
   jako *parametr*, zamiast konstruować ją wewnętrznie
   (`send_receipt_ready` nigdy samo nie pisze `notifier =
   ConsoleNotifier()`). Przekazywanie zależności z zewnątrz w ten
   sposób nazywa się **Dependency Injection**. Napisz jedno zdanie w
   swoich notatkach: co straciłoby `send_receipt_ready`, gdyby zamiast
   otrzymywać notifier, konstruowało własny `ConsoleNotifier`
   wewnętrznie?
4. Dwie kolejne nazwy, krótko: **Factory** to kod, którego całym
   zadaniem jest wybór albo konstrukcja właściwej strategii (wyobraź
   sobie funkcję `build_notifier(config)`, która zwraca
   `ConsoleNotifier` albo `InMemoryNotifier` w zależności od ustawienia
   — nie zbudowałeś/aś takiej, ale teraz rozpoznasz, jak by wyglądała).
   **Adapter** owija coś o niekompatybilnym interfejsie, żeby pasowało
   do tego, którego oczekuje Twój kod (wyobraź sobie zewnętrzną
   bibliotekę SMS, której metoda nazywa się `sendMessage(text)` zamiast
   `send(message)` — mała klasa opakowująca, tłumacząca jedno wywołanie
   na drugie, to Adapter). Napisz jedno zdanie na wzorzec w swoich
   notatkach, własnymi słowami.
5. Jako ćwiczenie, dodaj jeszcze jeden kod rabatowy do Wersji B
   (`examples/discount-codes/version-b/`) — na przykład
   `"SAVE_FLAT2"`, wart płaskie $2 zniżki — z własnym testem. Potwierdź
   w notatkach, że kosztowało Cię to dokładnie jeden nowy wpis w
   słowniku i jeden nowy test, nie dotykając żadnej istniejącej logiki.

## Kryteria akceptacji

- `my-notes.md` odpowiada na punkty 1, 3 i 4 własnymi słowami (nie
  wklejone z tego README).
- Wersja B ma nowy kod rabatowy z przechodzącym testem, a Twoje notatki
  podają, ile linii/plików to kosztowało.

## Weryfikacja

```bash
test -f labs/15-patterns-without-worship/my-notes.md && echo "notes exist"
cd examples/discount-codes/version-b && uv run pytest -v && cd - > /dev/null
```

Oczekiwane: notatki istnieją, a zestaw testów przechodzi z jednym
testem więcej niż wcześniej (9 razem, licząc od wcześniejszych 8 w
Wersji B — 7 ship'owanych plus test `SAVE20`, który dodałeś/aś w Lab 12).

## Zastanów się

- Strategy, Factory, Adapter i Dependency Injection to cztery różne
  nazwy. Która z nich opisuje *czym jest fragment kodu* (kształt), a
  która opisuje *jak fragment kodu coś otrzymuje* (relację)? Czy
  `DISCOUNT_CODES` jest bliżej jednego czy drugiego?
- Teraz, gdy znasz te nazwy, czy sięgnąłbyś/sięgnęłabyś po "Strategy"
  jako rozwiązanie pierwszego dnia Lab 12 — czy zobaczenie najpierw
  sprzężonej wersji (i odczucie jej kosztu) było konieczne, żeby docenić,
  co ten wzorzec faktycznie daje?

## Jeśli utkniesz

- **Podpowiedź 1:** Jeśli nie jesteś pewien/pewna, czy coś "jest
  Strategy", zapytaj: czy mógłbym/mogłabym wymienić ten konkretny
  fragment na inną implementację tego samego kontraktu, nie zmieniając
  kodu, który go wywołuje? Jeśli tak, to jest ten wzorzec.
- **Podpowiedź 2:** Dependency Injection tutaj to nie framework — to po
  prostu "wywołujący decyduje, której implementacji użyć, przekazując
  ją jako argument".
- **Podpowiedź 3:** Dla nowego kodu rabatowego podążaj dokładnie za tym
  samym kształtem co `"SAVE5"` w `DISCOUNT_CODES` — lambda, która
  ignoruje swój argument i zwraca płaską kwotę.

## Zanim przejdziesz do Aktu IV

Akt IV (od Lab 16) zakłada, że Twoja gałąź `main` jest czysta, a
wszystko z Labów 06-15 jest zacommitowane i wypchnięte. Teraz:

```bash
git status
```

Jeśli to pokazuje cokolwiek niezacommitowanego, zacommituj i wypchnij to
teraz (`git add -A && git commit -m "..."; git push`). Jeśli pokazuje
czysto, jesteś gotów/gotowa.

## Co dalej

Zbudowałeś/aś małą funkcję, nadałeś/aś jej nazwę, którą rozpoznałby
prawdziwy zespół inżynierski, i użyłeś/aś jej ponownie przy nowych
wymaganiach bez obaw. Akt III jest zakończony. Dalej przestajesz
pracować sam/sama — a "u mnie na komputerze działa" zamienia się w
"działa, gdy ktoś inny dotknie mojego kodu".

Przejdź do [Lab 16 — Gałęzie istnieją, bo praca dzieje się równolegle](../16-parallel-branches/README.pl.md).
