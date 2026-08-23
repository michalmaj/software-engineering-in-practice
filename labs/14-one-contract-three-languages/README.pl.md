# Lab 14 — Jeden kontrakt, trzy języki

## Sytuacja

Kuchnia chce powiadomienia, gdy zamówienie jest gotowe — na razie
wypisanego w konsoli; później może e-mailem albo SMS-em. Trzy różne
zespoły zbudowały ten sam mały kontrakt dla tego: jeden w Pythonie,
jeden w Go, jeden w Javie. Ten sam pomysł, trzy bardzo różne ilości
ceremonii.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Wyjaśnić, co czyni coś "kontraktem" niezależnie od składni
  konkretnego języka, która go wyraża.
- Porównać strukturalne typowanie Pythona (`Protocol`), niejawne
  spełnianie interfejsu w Go i jawne `implements` w Javie.
- Dodać nową implementację istniejącego kontraktu we wszystkich trzech
  językach.

## Zanim zaczniesz

- Laby 01-05 ukończone (ogólna biegłość w środowisku). Laby 06-13 nie
  są wymagane specyficznie dla tego laba.
- Dostępne `python3`, `go` oraz `javac`/`java` (patrz sekcja weryfikacji
  toolchainu w głównym [`README.pl.md`](../../README.pl.md)).
- Przeczytaj wszystkie trzy implementacje, zanim cokolwiek zmienisz:
  `examples/notifier/python/notifier/notifier.py`,
  `examples/notifier/go/notifier.go`,
  `examples/notifier/java/{Notifier,ConsoleNotifier,InMemoryNotifier,ReceiptService}.java`.

## Twoje zadanie

1. Uruchom sprawdzenia dla każdego języka i potwierdź, że przechodzą
   (patrz Weryfikacja).
2. W **Pythonie** dodaj klasę `SilentNotifier` w
   `notifier/notifier.py` z metodą `send`, która nic nie robi — żadne
   dziedziczenie `class SilentNotifier(Notifier)` nie jest potrzebne.
   Dodaj test potwierdzający, że
   `send_receipt_ready(SilentNotifier(), "A123")` działa bez rzucania
   wyjątku.
3. W **Go** dodaj `type SilentNotifier struct{}` w `notifier.go` z
   metodą `Send(message string)` z pustym ciałem. Dodaj test
   potwierdzający, że `SendReceiptReady(SilentNotifier{}, "A123")`
   działa bez panic.
4. W **Javie** dodaj klasę `SilentNotifier implements Notifier` w
   `SilentNotifier.java` z pustym ciałem metody `send`. W
   `NotifierCheck.java` dodaj drugie sprawdzenie, że
   `ReceiptService.sendReceiptReady(new SilentNotifier(), "A123")`
   działa bez rzucania wyjątku.
5. Dla każdego języka zanotuj: czy musiałeś/aś napisać cokolwiek
   deklarującego, że `SilentNotifier` implementuje kontrakt `Notifier`,
   czy język wywnioskował to sam z samej metody?

## Kryteria akceptacji

- Wszystkie trzy języki mają działający `SilentNotifier` i
  przechodzące sprawdzenie dla niego, obok istniejących sprawdzeń
  `ConsoleNotifier` / `InMemoryNotifier`.
- Potrafisz podać, dla każdego z trzech języków, czy zadeklarowanie "to
  implementuje ten kontrakt" było jawne (napisane przez Ciebie), czy
  niejawne (wywnioskowane przez kompilator/runtime).

## Weryfikacja

```bash
cd examples/notifier/python && uv run pytest -v && cd - > /dev/null
cd examples/notifier/go && go test ./... && cd - > /dev/null
cd examples/notifier/java && javac *.java -d out && java -cp out NotifierCheck && cd - > /dev/null
```

Oczekiwane: wszystkie trzy się udają, włącznie z Twoimi nowymi
sprawdzeniami `SilentNotifier`.

## Zastanów się

- `Protocol` w Pythonie i `interface` w Go pozwalają spełnić kontrakt
  po prostu przez posiadanie właściwej metody — bez jawnej deklaracji.
  Java wymaga `implements Notifier` w definicji klasy. Które podejście
  wyłapałoby literówkę w nazwie metody *wcześniej*: w momencie, gdy
  piszesz `SilentNotifier`, czy dopiero gdy coś próbuje użyć go jako
  `Notifier` i zawodzi?
- Gdyby kolega z zespołu dał Ci klasę z metodą `send(String message)`,
  ale *zapomniał* napisać na niej `implements Notifier`, czy Java
  pozwoliłaby Ci przekazać ją wszędzie tam, gdzie oczekiwany jest
  `Notifier`? Czy Python albo Go zatrzymałyby Cię w ten sam sposób?
- Sam `Protocol` w Pythonie daje Ci *dokumentację* kontraktu, nie jego
  *egzekwowanie* — nic nie powstrzymuje Cię przed przekazaniem obiektu
  bez metody `send` i odkryciem tego dopiero w runtime, gdy zostanie
  wywołana. Zarówno kompilator Go, jak i kompilator Javy wyłapują
  brakującą metodę, zanim program w ogóle się uruchomi. Co domknęłoby
  tę lukę dla Pythona, i ile by to kosztowało?

## Jeśli utkniesz

- **Podpowiedź 1:** Ciało metody `send` w `SilentNotifier` to po
  prostu `pass` w Pythonie, pusty blok `{}` w Go i pusty blok `{}` w
  Javie — we wszystkich trzech "nic nie robi" to cała implementacja.
- **Podpowiedź 2:** Konkretnie w Javie, zapomnienie `implements
  Notifier` nie powstrzyma `SilentNotifier` przed skompilowaniem — ale
  *powstrzyma* Cię przed przekazaniem gołego `SilentNotifier` do
  `sendReceiptReady`, które oczekuje `Notifier`. To jest konkretna
  różnica względem Pythona/Go, na którą warto uważać.
- **Podpowiedź 3:** Nic z tego nie wymaga narzędzia budowania — `uv
  run pytest` dla Pythona, `go test ./...` dla Go oraz `javac *.java -d
  out && java -cp out NotifierCheck` dla Javy to jedyne trzy potrzebne
  polecenia.

Zanim pójdziesz dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (od Lab 16) już tak — wyrób
sobie ten nawyk już teraz.

## Co dalej

Kody rabatowe (Laby 12-13) i notifiery (ten lab) okazują się mieć
wspólny kształt: wybierz jedno zamienne zachowanie spośród kilku, na
podstawie czegoś, co dostarcza wywołujący, zamiast łańcucha
warunków zakopanego w logice biznesowej. Dalej nazwiesz ten kształt.

Przejdź do [Lab 15 — Wzorce bez kultu wzorców](../15-patterns-without-worship/README.pl.md).
