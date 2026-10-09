# Lab 15 — Wzorce bez bałwochwalstwa

## Sytuacja

Spójrz z powrotem na plik kodów rabatowych Version B i implementacje
`Notifier` z Lab 14 — oba we własnej ścieżce domowej. Zbudowałeś/aś
oba, bez tego, żeby ktoś powiedział Ci ich "oficjalną" nazwę. Okazuje
się, że jedna istnieje.

## Cele nauki

Po tym labie potrafisz:

- Rozpoznać wzorzec Strategy w kodzie, który już napisałeś/aś, zanim
  ktoś powiedział Ci jego nazwę.
- Wyjaśnić Dependency Injection, używając funkcji, którą już
  napisałeś/aś (`send_receipt_ready` / `SendReceiptReady` /
  `sendReceiptReady`), a nie definicji.
- Wyjaśnić, w jednym zdaniu każdy, do czego służą Factory i Adapter.

## Zanim zaczniesz

- Laby 12-14 ukończone, w Twojej ścieżce domowej.
- Żaden nowy toolchain — ten lab odwiedza ponownie kod, który już
  napisałeś/aś.

## Twoje zadanie

1. Przeczytaj ponownie plik kodów rabatowych Version B swojej ścieżki
   domowej i jego funkcję w stylu `apply`, oraz implementacje
   `Notifier` plus funkcję w stylu `send_receipt_ready` z Lab 14. W
   pliku notatek `labs/15-patterns-without-worship/my-notes.md` napisz,
   własnymi słowami, co te dwa fragmenty kodu mają wspólnego —
   konkretnie, jak każdy z nich unika długiego łańcucha warunków, żeby
   wybrać zachowanie.

### Python

- `examples/discount-codes/version-b/python/billing/discount_codes.py`
- `examples/notifier/python/notifier/notifier.py`

### Go

- `examples/discount-codes/version-b/go/billing/discount_codes.go`
- `examples/notifier/go/notifier.go`

### Java

- `examples/discount-codes/version-b/java/src/main/java/billing/DiscountCodes.java`
- `examples/notifier/java/{Notifier,ConsoleNotifier,InMemoryNotifier,ReceiptService}.java`

2. Teraz nazwa: ta forma — kilka wymiennych implementacji tego samego
   małego kontraktu, wybieranych przez tego, kto wywołuje, zamiast
   zapiekanych w jednym wielkim warunku — nazywa się wzorcem
   **Strategy**. Każdy wpis w Twojej mapie/dict kodów rabatowych to
   strategia. `ConsoleNotifier` i `InMemoryNotifier` (i teraz Twój
   `SilentNotifier`) są każdy strategią dostarczania powiadomienia.
   Strategy nie wymaga hierarchii klas — w Go i Pythonie konkretnie,
   zwykła funkcja przechowana w mapie *jest* strategią; nie musisz
   owijać jej w typ, żeby stała się jedną.
3. `send_receipt_ready`/`SendReceiptReady`/`sendReceiptReady` otrzymuje
   swoją strategię jako *parametr*, zamiast konstruować jedną
   wewnętrznie — nigdy nie pisze `notifier = ConsoleNotifier()` (albo
   odpowiednika) sama. Przekazywanie zależności z zewnątrz w ten
   sposób nazywa się **Dependency Injection** — żaden framework
   niepotrzebny; to po prostu "wywołujący decyduje, którą implementację
   użyć, przekazując ją jako argument." Napisz jedno zdanie w swoich
   notatkach: co ta funkcja straciłaby zdolność robienia, gdyby
   konstruowała swój własny `ConsoleNotifier` wewnętrznie, zamiast go
   otrzymywać?
4. Dwie kolejne nazwy, krótko: **Factory** to kod, którego zadaniem
   jest scentralizowanie decyzji, *który* obiekt stworzyć albo
   dostarczyć, żeby wywołujący nie musieli każdy podejmować tej
   decyzji samemu. Ogólnie Factory może konstruować albo dostarczać
   dowolny rodzaj obiektu; w *tym* ćwiczeniu konkretnie, ta decyzja
   akurat polega na tym, którą implementację Strategy użyć (wyobraź
   sobie funkcję `build_notifier(config)`, która zwraca
   `ConsoleNotifier` albo `InMemoryNotifier`, zależnie od ustawienia —
   nie zbudowałeś/aś takiej, ale teraz rozpoznasz, jak by wyglądała).
   "Wybieranie Strategy" to po prostu zastosowanie Factory w tym
   ćwiczeniu, nie to, czym Factory jest z natury. **Adapter** owija
   coś z niekompatybilnym interfejsem, żeby dopasować go do tego, czego
   oczekuje Twój kod (wyobraź sobie bibliotekę SMS strony trzeciej,
   której metoda nazywa się `sendMessage(text)` zamiast `send(message)`
   — mały wrapper tłumaczący jedno wywołanie na drugie to Adapter).
   Napisz jedno zdanie na wzorzec w swoich notatkach, własnymi słowami.
5. Jako praktykę, dodaj jeszcze jeden kod rabatowy do Version B
   **swojej ścieżki domowej** — `"SAVE_FLAT2"`, warty płaskie $2 zniżki
   — z własnym testem. Potwierdź, w swoich notatkach, co to Cię
   kosztowało: ile nowych linii, i czy dotknąłeś/aś jakiejkolwiek
   istniejącej logiki.

### Python

Dodaj `"SAVE_FLAT2": lambda amount: 2.0` do `DISCOUNT_CODES` w
`examples/discount-codes/version-b/python/billing/discount_codes.py`.
Dodaj test do `tests/test_discount_codes.py` asercjonujący
`apply_discount_code(100.0, "SAVE_FLAT2") == 2.0`.

### Go

Dodaj `"SAVE_FLAT2": func(amount float64) float64 { return 2.0 }` do
mapy `discountCodes` w
`examples/discount-codes/version-b/go/billing/discount_codes.go`.
Dodaj test do `discount_codes_test.go` asercjonujący, że
`ApplyDiscountCode(100.0, "SAVE_FLAT2")` zwraca `2.0`. Uruchom
`gofmt -w .` potem — dodanie dłuższego klucza do mapy przesuwa, jak
`gofmt` wyrównuje kolumnę `:` dla każdego wpisu, i to jest oczekiwane,
nie znak, że coś zepsułeś/aś.

### Java

Dodaj `"SAVE_FLAT2", amount -> 2.0` do mapy `CODES` w
`examples/discount-codes/version-b/java/src/main/java/billing/DiscountCodes.java`.
Dodaj test do `DiscountCodesTest.java` asercjonujący
`DiscountCodes.apply(100.0, "SAVE_FLAT2") == 2.0`.

Nie dodawaj tego kodu do Version A, i nie dodawaj go do publicznego
startera — to praktyka tylko dla Twojej własnej kopii.

## Kryteria akceptacji

- `my-notes.md` odpowiada na punkty 1, 3 i 4 własnymi słowami (nie
  wklejone z tego README).
- Version B Twojej ścieżki domowej ma nowy kod rabatowy z
  przechodzącym testem, a Twoje notatki podają, ile linii/plików to
  kosztowało.

## Weryfikacja

### Python

```bash
test -f labs/15-patterns-without-worship/my-notes.md && echo "notes exist"
cd examples/discount-codes/version-b/python && uv run pytest -v && cd - > /dev/null
```

Oczekiwane: notatki istnieją, i zestaw testów przechodzi z jednym
testem więcej niż wcześniej (9 łącznie, biorąc wcześniejsze 8 Version
B — 7 dostarczone plus test `SAVE20`, który dodałeś/aś w Lab 12).

### Go

```bash
test -f labs/15-patterns-without-worship/my-notes.md && echo "notes exist"
cd examples/discount-codes/version-b/go && go test ./... -v && cd - > /dev/null
```

Oczekiwane: notatki istnieją, i zestaw testów przechodzi z jednym
testem więcej niż wcześniej (9 łącznie, biorąc wcześniejsze 8 Version
B — 7 dostarczone plus test `SAVE20`, który dodałeś/aś w Lab 12).

### Java

```bash
test -f labs/15-patterns-without-worship/my-notes.md && echo "notes exist"
cd examples/discount-codes/version-b/java && ./gradlew test && cd - > /dev/null
```

Oczekiwane: notatki istnieją, i zestaw testów przechodzi z jednym
testem więcej niż wcześniej (9 łącznie, biorąc wcześniejsze 8 Version
B — 7 dostarczone plus test `SAVE20`, który dodałeś/aś w Lab 12).

## Zastanów się

- Strategy, Factory, Adapter i Dependency Injection to cztery różne
  nazwy. Która z nich opisuje *czym kod jest* (formę), a która opisuje
  *jak kod coś otrzymuje* (relację)? Czy Twoja mapa/dict kodów
  rabatowych jest bliżej jednej czy drugiej?
- Teraz, gdy masz te nazwy, sięgnąłbyś/abyś po "Strategy" jako
  rozwiązanie pierwszego dnia Lab 12 — czy zobaczenie najpierw
  sprzężonej wersji (i poczucie jej kosztu) było potrzebne, żeby
  docenić, co wzorzec faktycznie daje?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** Jeśli nie jesteś pewien/pewna, czy coś "jest
  Strategy," zapytaj: mógłbym/abym wymienić tę konkretną część na
  inną implementację tego samego kontraktu bez zmiany kodu, który
  wywołuje? Jeśli tak, to jest ten wzorzec.
- **Podpowiedź 2:** Dependency Injection tutaj to nie framework — to
  po prostu "wywołujący decyduje, którą implementację użyć, przekazując
  ją jako argument."
- **Podpowiedź 3:** Dla nowego kodu rabatowego, podążaj za dokładnie tą
  samą formą co `"SAVE5"` w `DISCOUNT_CODES` — lambda, która ignoruje
  swój argument i zwraca płaską kwotę.

### Go

- **Podpowiedź 1:** Jeśli nie jesteś pewien/pewna, czy coś "jest
  Strategy," zapytaj: mógłbym/abym wymienić tę konkretną część na
  inną implementację tego samego kontraktu bez zmiany kodu, który
  wywołuje? Jeśli tak, to jest ten wzorzec.
- **Podpowiedź 2:** Dependency Injection tutaj to nie framework — to
  po prostu "wywołujący decyduje, którą implementację użyć, przekazując
  ją jako argument."
- **Podpowiedź 3:** Dla nowego kodu rabatowego, podążaj za dokładnie tą
  samą formą co `"SAVE5"` w mapie `discountCodes` — funkcja, która
  ignoruje swój argument i zwraca płaską kwotę.

### Java

- **Podpowiedź 1:** Jeśli nie jesteś pewien/pewna, czy coś "jest
  Strategy," zapytaj: mógłbym/abym wymienić tę konkretną część na
  inną implementację tego samego kontraktu bez zmiany kodu, który
  wywołuje? Jeśli tak, to jest ten wzorzec.
- **Podpowiedź 2:** Dependency Injection tutaj to nie framework — to
  po prostu "wywołujący decyduje, którą implementację użyć, przekazując
  ją jako argument."
- **Podpowiedź 3:** Dla nowego kodu rabatowego, podążaj za dokładnie tą
  samą formą co `"SAVE5"` w mapie `CODES` — lambda, która ignoruje
  swój argument i zwraca płaską kwotę.

## Zanim przejdziesz do Aktu IV

Akt IV (zaczynający się od Lab 16) zakłada, że Twój branch `main` jest
czysty, a wszystko z Labów 06-15 jest zacommitowane i wypchnięte.
Teraz:

```bash
git status
```

Jeśli to pokazuje coś niezacommitowanego, zacommituj i wypchnij to
teraz (`git add -A && git commit -m "..."; git push`). Jeśli pokazuje
czysto, jesteś gotowy/a.

## Co dalej

Zbudowałeś/aś małą funkcję, dałeś/aś jej nazwę, którą rozpozna
prawdziwy zespół inżynierski, i użyłeś/aś jej ponownie pod nowymi
wymogami bez strachu. Akt III jest zakończony. Dalej przestajesz
pracować samemu — i "u mnie działa" zmienia się w "działa, gdy ktoś
inny dotknie mojego kodu."

Przejdź do [Lab 16 — Branche istnieją, bo praca dzieje się równolegle](../16-parallel-branches/README.pl.md).
