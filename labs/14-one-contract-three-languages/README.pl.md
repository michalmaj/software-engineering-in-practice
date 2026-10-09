# Lab 14 — Jeden kontrakt, trzy języki

## Sytuacja

Kuchnia chce powiadomienia, gdy zamówienie jest gotowe — na razie
wydrukowanego na konsolę; później, może e-mail albo SMS. Trzy różne
zespoły zbudowały ten sam mały kontrakt do tego: jeden w Pythonie,
jeden w Go, jeden w Javie. Ta sama idea, trzy bardzo różne ilości
ceremonii — i musisz dotknąć tylko tego we własnym języku.

## Cele nauki

Po tym labie potrafisz:

- Wyjaśnić, co sprawia, że coś jest "kontraktem", niezależnie od
  składni jednego konkretnego języka do jego wyrażenia.
- Wyjaśnić, jak Twój własny język rozpoznaje, że coś spełnia kontrakt
  — i stwierdzić, na podstawie przeczytania (nie koniecznie
  uruchomienia) pozostałych dwóch, czym się różnią.
- Dodać nową implementację istniejącego kontraktu w swoim własnym
  języku, z przechodzącym testem.

## Zanim zaczniesz

- Laby 01-05 ukończone (ogólna znajomość środowiska). Laby 06-13 nie
  są wymagane specyficznie dla tego laba.
- Potrzebujesz tylko toolchainu **swojego własnego języka** dla tego
  laba — nic innego nie jest wymagane, żeby go ukończyć.

### Python

- `uv` zainstalowany, bieżący katalog `examples/notifier/python/`.

### Go

- Go 1.27.x zainstalowany, bieżący katalog `examples/notifier/go/`.

### Java

- JDK 21 zainstalowany, bieżący katalog `examples/notifier/java/`.

## Twoje zadanie

### Krok 1 — przeczytaj wszystkie trzy kontrakty (ta część nie wymaga toolchainu)

Otwórz i przeczytaj te trzy pliki, nawet jeśli masz zainstalowany tylko
toolchain swojego własnego języka — czytanie kodu źródłowego nie
wymaga jego uruchamiania:

- Python: `examples/notifier/python/notifier/notifier.py`
- Go: `examples/notifier/go/notifier.go`
- Java: `examples/notifier/java/Notifier.java`,
  `examples/notifier/java/ConsoleNotifier.java`,
  `examples/notifier/java/InMemoryNotifier.java`,
  `examples/notifier/java/ReceiptService.java`

Zauważ formę powtórzoną trzy razy: coś nazwane `Notifier` (interfejs,
`Protocol`, albo interfejs) opisujące jedną metodę, i co najmniej dwie
jej implementacje, które są przekazywane do funkcji wywołującej tę
metodę bez wiedzy, którą implementację otrzymała.

### Krok 2 — uruchom kontrole swojej ścieżki domowej

### Python

```bash
cd examples/notifier/python && uv run pytest -v && cd - > /dev/null
```

### Go

```bash
cd examples/notifier/go && go test ./... && cd - > /dev/null
```

### Java

```bash
cd examples/notifier/java && javac *.java -d out && java -cp out NotifierCheck && cd - > /dev/null
```

### Krok 3 — dodaj `SilentNotifier` w swojej ścieżce domowej

### Python

W `notifier/notifier.py` dodaj klasę `SilentNotifier` z metodą `send`,
która nic nie robi — żadne dziedziczenie `class
SilentNotifier(Notifier)` niepotrzebne, to duck typing. Dodaj test w
`tests/test_notifier.py` potwierdzający, że
`send_receipt_ready(SilentNotifier(), "A123")` działa bez podnoszenia
wyjątku.

### Go

W `notifier.go` dodaj `type SilentNotifier struct{}` z metodą
`Send(message string)` z pustym ciałem. Dodaj test w
`notifier_test.go` potwierdzający, że `SendReceiptReady(SilentNotifier{},
"A123")` działa bez panica.

### Java

Dodaj klasę `SilentNotifier implements Notifier` w nowym pliku
`SilentNotifier.java`, z pustym ciałem metody `send`. W
`NotifierCheck.java` dodaj drugi check, że
`ReceiptService.sendReceiptReady(new SilentNotifier(), "A123")` działa
bez wyjątku.

### Krok 4 — porównaj, jak każdy język rozpoznaje kontrakt

Przeczytałeś/aś już wszystkie trzy i zbudowałeś/aś jeden. Tutaj jest
to, co faktycznie się dzieje, zweryfikowane dla tego kursu, jeśli klasa
ma właściwą metodę, ale kontrakt nie jest spełniony poprawnie — użyj
tego, żeby porównać z zachowaniem swojego własnego języka, bez
potrzeby instalowania pozostałych dwóch toolchainów samemu:

**Java** — klasa z metodą `send(String message)`, która *nie* pisze
`implements Notifier`, nie kompiluje się w momencie, gdy próbujesz ją
przekazać, gdzie oczekiwany jest `Notifier`, nawet jeśli metoda
istnieje:

```text
TryBad.java:4: error: incompatible types: BadNotifier cannot be converted to Notifier
        ReceiptService.sendReceiptReady(n, "A123");
                                        ^
```

**Go** — struct z *błędnie napisaną* nazwą metody (`Sand` zamiast
`Send`) nie kompiluje się w momencie, gdy próbujesz ją przekazać,
gdzie oczekiwany jest interfejs `Notifier` — Go sprawdza strukturalne
dopasowanie, żadne słowo kluczowe `implements` niepotrzebne, ale wciąż
sprawdza:

```text
./notifier.go:20:19: cannot use BadNotifier{} (value of struct type BadNotifier) as Notifier value in argument to SendReceiptReady: BadNotifier does not implement Notifier (missing method Send)
```

**Python** — obiekt z *błędnie napisaną* nazwą metody (`sand` zamiast
`send`) kompiluje się (w sensie: parsuje) i działa bez żadnej skargi,
aż do dokładnej linii, która faktycznie wywołuje `.send(...)`:

```text
Traceback (most recent call last):
  File "notifier_check.py", line 18, in <module>
    send_receipt_ready(BadNotifier(), "A123")
  File "notifier_check.py", line 9, in send_receipt_ready
    notifier.send(f"Order {order_id} is ready.")
AttributeError: 'BadNotifier' object has no attribute 'send'. Did you mean: 'sand'?
```

Jeśli ta konkretna ścieżka kodu nigdy nie zostałaby wykonana — powiedzmy,
literówka była w implementacji notifiera, której nic aktualnie nie
wywołuje — Python nigdy by nie podniósł wyjątku. Nic to nie
sprawdzało, więc nic tego nie złapało.

### Krok 5 — odpowiedz, własnymi słowami

W pliku notatek `labs/14-one-contract-three-languages/my-notes.md`
odpowiedz:

1. Dla Twojego własnego języka konkretnie: jak rozpoznaje, że
   `SilentNotifier` spełnia `Notifier`? Wskaż dokładny mechanizm
   (klauzula `implements` sprawdzana przez kompilator, strukturalne
   dopasowanie sprawdzane przez kompilator, albo nic sprawdzane
   wcale).
2. Wśród wszystkich trzech języków (używając zweryfikowanego wyniku z
   Kroku 4, nie zgadywania): który złapałby literówkę w nazwie metody
   *najszybciej* — przed uruchomieniem programu, czy tylko gdy
   konkretna wadliwa ścieżka kodu się wykona?
3. Jeśli kolega z zespołu dałby Ci klasę z właściwą metodą, ale nie
   spełniającą kontraktu poprawnie (brak `implements` w Javie, błędnie
   napisana metoda w Go albo Pythonie), jaka jest konkretna,
   obserwowalna różnica w tym, jak narzędzia każdego języka Ci to
   ujawnią?

## Opcjonalnie: uruchom też pozostałe dwa języki

Jeśli masz już zainstalowane pozostałe dwa toolchainy, możesz
uruchomić wszystkie trzy komendy weryfikacyjne z Kroku 2 i zbudować
`SilentNotifier` we wszystkich trzech — nic w tym labie Ci tego nie
zabrania. Ale to nie jest wymagane, a kryteria akceptacji poniżej
sprawdzają tylko Twoją ścieżkę domową.

## Kryteria akceptacji

- Twój język domowy ma działający `SilentNotifier` i przechodzący
  check dla niego, obok istniejących checków `ConsoleNotifier` /
  `InMemoryNotifier`.
- `my-notes.md` odpowiada na wszystkie trzy pytania z Kroku 5, własnymi
  słowami, zakotwiczone w zweryfikowanym wyniku z Kroku 4 (nie
  wymyślonym zachowaniu).

## Weryfikacja

### Python

```bash
cd examples/notifier/python && uv run pytest -v && cd - > /dev/null
test -f labs/14-one-contract-three-languages/my-notes.md && echo "notes exist"
```

### Go

```bash
cd examples/notifier/go && go test ./... -v && cd - > /dev/null
test -f labs/14-one-contract-three-languages/my-notes.md && echo "notes exist"
```

### Java

```bash
cd examples/notifier/java && javac *.java -d out && java -cp out NotifierCheck && cd - > /dev/null
test -f labs/14-one-contract-three-languages/my-notes.md && echo "notes exist"
```

Oczekiwane: kontrole Twojej ścieżki domowej się udają, wliczając nowy
check `SilentNotifier`, i plik notatek istnieje.

## Zastanów się

- Interfejs Go i `Protocol` Pythona obie pozwalają spełnić kontrakt
  samym posiadaniem właściwej metody, bez jawnej deklaracji — ale
  kompilator Go faktycznie sprawdza to dopasowanie w momencie, gdy
  przekazujesz swój typ, gdzie oczekiwany jest interfejs, podczas gdy
  Python nie uruchamia żadnego takiego sprawdzenia w tym labie. Co by
  kosztowało zamknięcie tej różnicy dla Pythona (podpowiedź: istnieje
  do tego narzędzie — co musiałbyś/abyś uruchomić, czego ten lab nie
  uruchamia)?
- `Protocol` Pythona sam w sobie daje Ci *dokumentację* kontraktu, nie
  *wymuszenie*. Czy to jest wada Pythona, czy trade-off? Co, jak sobie
  wyobrażasz, programiści Pythona zyskują w zamian za ten brakujący
  check?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** Ciało metody `send` w `SilentNotifier` to po
  prostu `pass`.
- **Podpowiedź 2:** Nie potrzebujesz `class SilentNotifier(Notifier)`
  — nic w tym labie nie wymusza `Protocol`, więc zwykłe `class
  SilentNotifier:` z odpowiadającą metodą `send` wystarczy.
- **Podpowiedź 3:** Cały lab to jedna komenda plus kilka linii kodu:
  `uv run pytest -v`.

### Go

- **Podpowiedź 1:** Ciało metody `Send` w `SilentNotifier` to po
  prostu puste `{}`.
- **Podpowiedź 2:** Nie potrzebujesz pisać niczego deklarującego, że
  `SilentNotifier` implementuje `Notifier` — Go sprawdza to w
  momencie, gdy przekazujesz `SilentNotifier{}`, gdzie oczekiwany jest
  `Notifier`.
- **Podpowiedź 3:** Cały lab to jedna komenda plus kilka linii kodu:
  `go test ./...`.

### Java

- **Podpowiedź 1:** Ciało metody `send` w `SilentNotifier` to po
  prostu puste `{}`.
- **Podpowiedź 2:** Zapomnienie `implements Notifier` nie zatrzyma
  samodzielnej kompilacji `SilentNotifier` — ale *zatrzyma* Cię przed
  przekazaniem gołego `SilentNotifier` do `sendReceiptReady`, który
  oczekuje `Notifier`. To jest dokładnie przykład z Kroku 4,
  odtworzony z Twoją własną klasą, jeśli usuniesz klauzulę, żeby to
  wypróbować.
- **Podpowiedź 3:** Żaden build tool niepotrzebny —
  `javac *.java -d out && java -cp out NotifierCheck` to jedyna
  komenda, której potrzebujesz.

Przed przejściem dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (zaczynający się od Lab 16)
tak — przyzwyczajaj się już teraz.

## Co dalej

Kody rabatowe (Laby 12-13) i notifiery (ten lab) okazują się mieć
wspólną formę: wybierz jedno wymienne zachowanie z kilku, na podstawie
tego, co dostarczy wywołujący, zamiast łańcucha warunków zagrzebanego w
logice biznesowej. Dalej nazwiesz tę formę.

Przejdź do [Lab 15 — Wzorce bez bałwochwalstwa](../15-patterns-without-worship/README.pl.md).
