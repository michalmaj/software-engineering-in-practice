# Lab 06 — Od skryptu do projektu

## Sytuacja

`examples/restaurant-bill/` liczy rachunek w restauracji: sumę,
rabat lojalnościowy, podatek, napiwek, sumę całkowitą. Działa. To też
jedna funkcja (albo jedno `main`, w Go i Javie), która robi pięć różnych
rzeczy naraz, bez możliwości zmiany jednej części bez ponownego
przeczytania całości.

To pierwszy lab z trzema ścieżkami: Python, Go i Java. Wybierz tę, którą
realizujesz, i czytaj tylko tę sekcję, gdziekolwiek ta strona się
rozdziela — trzy startery rozwiązują dokładnie ten sam problem z tymi
samymi liczbami, więc niezależnie od tego, którą wybrałeś/aś wcześniej,
cel jest tym samym rodzajem projektu, zbudowanym tak, jak Twój język
faktycznie buduje projekty.

## Cele nauki

Po tym labie potrafisz:

- Rozdzielić odrębne odpowiedzialności skryptu na osobne moduły
  (Python), pakiety (Go) albo klasy (Java).
- Wyjaśnić różnicę między czystą funkcją obliczającą a punktem wejścia,
  który obsługuje I/O (w tym przypadku drukowanie).
- Opisać projekt jego własnemu toolchainowi za pomocą prawdziwego
  manifestu (`pyproject.toml`, `go.mod` albo `build.gradle`), a nie
  jako gołego folderu z plikami.

## Zanim zaczniesz

- Laby 01-04 ukończone.
- Wybierz swój track, jeśli jeszcze tego nie zrobiłeś/aś: Python, Go
  albo Java. Wszystkie trzy są prawdziwymi, kompletnymi ścieżkami przez
  Laby 06-10 — żadna z nich nie jest podglądem.
- Jeśli już zacząłeś/aś ten projekt w jego starej lokalizacji
  (`examples/restaurant-bill/bill.py`, bez podfolderu `python/`), nic
  nie jest stracone: przenieś to, co już stworzyłeś/aś, do
  `examples/restaurant-bill/python/` samodzielnie (na przykład
  `mkdir -p examples/restaurant-bill/python && git mv examples/restaurant-bill/bill.py examples/restaurant-bill/python/`,
  dopasowując do plików, które sam/a dodałeś/aś), potem kontynuuj od
  tego miejsca. Nie uruchamiaj `git reset --hard` ani `git clean`, żeby
  "zacząć od nowa" — każda z nich wyrzuciłaby pracę, której nigdzie
  jeszcze nie wypchnąłeś/aś.

### Python

- Bieżący katalog: `examples/restaurant-bill/python/` dla wszystkich
  poleceń poniżej.
- `uv` zainstalowany (Lab 05 to obejmuje).
- Przeczytaj `bill.py` w całości, zanim coś zmienisz.

### Go

- Bieżący katalog: `examples/restaurant-bill/go/` dla wszystkich poleceń
  poniżej.
- Go 1.27.x zainstalowany. Sprawdź przez `go version`. Jeśli go nie ma,
  zainstaluj go z oficjalnych instrukcji na
  [go.dev/doc/install](https://go.dev/doc/install) — ten kurs nie używa
  menedżera wersji Go. (Lab 05 ma opcjonalny podgląd Go, obejmujący tę
  samą ideę odtwarzalności toolchainu, na której buduje ten track, ale
  nie jest wymagany, żeby zacząć tutaj.)
- Przeczytaj `main.go` w całości, zanim coś zmienisz.

### Java

- Bieżący katalog: `examples/restaurant-bill/java/` dla wszystkich
  poleceń poniżej.
- JDK 21 zainstalowany. Sprawdź przez `java -version` (oczekuj `21`
  gdzieś w wyniku). Jeśli go nie ma, zainstaluj build Temurin 21 od
  Adoptium z [adoptium.net](https://adoptium.net/temurin/releases/?version=21).
  Globalny Gradle niepotrzebny — ten projekt ma własny, zacommitowany
  Gradle Wrapper (`./gradlew`). (Lab 05 ma opcjonalny podgląd Java,
  obejmujący tę samą ideę toolchainu, na której buduje ten track, ale
  nie jest wymagany, żeby zacząć tutaj.)
- Przeczytaj `src/main/java/Main.java` w całości, zanim coś zmienisz.

## Twoje zadanie

### Python

1. Uruchom `python3 bill.py`, zapisując jego wynik jako bazę do
   późniejszego porównania: `python3 bill.py | tee /tmp/bill-before.txt`.
2. Zidentyfikuj odrębne odpowiedzialności zmieszane razem w `main()`:
   obliczenie subtotal, zastosowanie rabatu, obliczenie podatku,
   obliczenie napiwku i wydrukowanie rachunku.
3. Utwórz `pyproject.toml` dla tego projektu: nazwa `restaurant-bill`,
   `requires-python = ">=3.13"`, zależność dev `pytest`, oraz
   `[tool.pytest.ini_options]` z `pythonpath = ["."]` (ten sam wzorzec
   co w Lab 05).
4. Utwórz pakiet `billing/` (`billing/__init__.py`, pusty) z modułem
   `billing/calculator.py` zawierającym dokładnie te pięć czystych
   funkcji, z tymi dokładnymi nazwami i sygnaturami (następne dwa laby
   zależą od tych dokładnych nazw):
   - `calculate_subtotal(items: list[tuple[str, float, int]]) -> float`
     — suma `price * quantity` dla każdej pozycji.
   - `calculate_discount(subtotal: float) -> float` — 10% `subtotal`,
     jeśli `subtotal >= 50`, inaczej `0`.
   - `calculate_tax(amount: float) -> float` — płaski 8% `amount`.
   - `calculate_tip(amount: float, tip_rate: float) -> float` —
     `amount * tip_rate`.
   - `calculate_bill(items: list[tuple[str, float, int]], tip_rate: float)
     -> dict[str, float]` — łączy cztery powyższe funkcje w dict z
     kluczami `subtotal`, `discount`, `tax`, `tip`, `total`. **Na razie
     policz `tax` z całego `subtotal`, zupełnie jak oryginalny skrypt**
     — ten refactoring musi odtworzyć istniejące zachowanie dokładnie,
     wliczając bugi. Niczego jeszcze nie naprawiasz.
5. Utwórz `billing/cli.py` z `main()`, które wywołuje `calculate_bill`
   *raz* i drukuje rachunek, którego wynik jest bajt-po-bajcie identyczny
   z wynikiem oryginalnego skryptu, używając tylko wartości ze
   zwróconego dict (nie przeliczaj niczego osobno — jedno źródło
   prawdy).
6. Utwórz `main.py` w katalogu głównym projektu, który importuje `main`
   z `billing.cli` i wywołuje je pod `if __name__ == "__main__":`.
7. Uruchom swój nowy punkt wejścia tą samą metodą, zapisując też jego
   wynik: `uv run python main.py | tee /tmp/bill-after.txt`. Porównaj
   oba pliki: `diff /tmp/bill-before.txt /tmp/bill-after.txt`.
8. Gdy diff jest czysty, usuń `bill.py` — został w pełni zastąpiony.

### Go

1. Uruchom `go run main.go`, zapisując jego wynik jako bazę:
   `go run main.go | tee /tmp/bill-before.txt`. Zauważ, że to działa bez
   żadnego `go.mod` jeszcze — `go run` na jawnym argumencie-pliku nie
   potrzebuje modułu, tak samo jak `python3 bill.py` też niczego nie
   potrzebował.
2. Zidentyfikuj odrębne odpowiedzialności zmieszane razem w `main()`:
   obliczenie subtotal, zastosowanie rabatu, obliczenie podatku,
   obliczenie napiwku i wydrukowanie rachunku.
3. Zmień ten katalog w prawdziwy moduł: `go mod init restaurant-bill`.
   To tworzy `go.mod` — odpowiednik `pyproject.toml` w Go, opisujący
   ten folder jako projekt z nazwą, a nie tylko folder z plikami.
4. Utwórz pakiet `billing` w nowym podkatalogu `billing/`, z plikiem
   `billing/calculator.go` (`package billing`) zawierającym dokładnie
   te pięć eksportowanych funkcji i dwa typy (następne dwa laby zależą
   od tych dokładnych nazw):
   - `type Item struct { Name string; Price float64; Qty int }`
   - `type Bill struct { Subtotal, Discount, Tax, Tip, Total float64 }`
   - `func CalculateSubtotal(items []Item) float64` — suma
     `Price * float64(Qty)` dla każdej pozycji.
   - `func CalculateDiscount(subtotal float64) float64` — 10%
     `subtotal`, jeśli `subtotal >= 50`, inaczej `0`.
   - `func CalculateTax(amount float64) float64` — płaski 8% `amount`.
   - `func CalculateTip(amount, tipRate float64) float64` —
     `amount * tipRate`.
   - `func CalculateBill(items []Item, tipRate float64) Bill` — łączy
     cztery powyższe funkcje w `Bill`. **Na razie policz `Tax` z całego
     `subtotal`, zupełnie jak oryginalny program** — wliczając bugi,
     niczego jeszcze nie naprawiasz.
5. Utwórz `billing/cli.go` (ten sam pakiet) z funkcją
   `func Run(items []Item, tipRate float64)`, która wywołuje
   `CalculateBill` *raz* i drukuje rachunek bajt-po-bajcie identyczny z
   wynikiem oryginalnego programu, używając tylko pól zwróconego
   `Bill`.
6. Przepisz `main.go` w katalogu głównym tak, żeby cała jego `func
   main()` była tylko: zbuduj slice `items`, potem wywołaj
   `billing.Run(items, 0.15)`. Będziesz potrzebować zaimportować
   własny pakiet `billing` tego modułu przez jego ścieżkę modułu:
   `import "restaurant-bill/billing"`.
7. Uruchom swój zrefaktoryzowany punkt wejścia tą samą metodą,
   zapisując też jego wynik: `go run main.go | tee /tmp/bill-after.txt`.
   Porównaj oba pliki: `diff /tmp/bill-before.txt /tmp/bill-after.txt`.
8. Gdy diff jest czysty, potwierdź, że `go run .` (bez argumentu-pliku,
   forma świadoma modułu) też produkuje ten sam wynik — to działa
   teraz, dopiero gdy istnieje `go.mod`.

### Java

1. Uruchom starter, zapisując jego wynik jako bazę:
   `./gradlew run --console=plain | tee /tmp/bill-before.txt`. Pierwsze
   uruchomienie pobiera dystrybucję Gradle i zależności, jeśli nie są
   jeszcze w cache — to może zająć minutę lub dwie; to nie jest
   zawieszenie, a każde kolejne uruchomienie jest szybkie.
2. Zidentyfikuj odrębne odpowiedzialności zmieszane razem w `main()`:
   obliczenie subtotal, zastosowanie rabatu, obliczenie podatku,
   obliczenie napiwku i wydrukowanie rachunku.
3. Utwórz pakiet `billing`: nowy plik
   `src/main/java/billing/Calculator.java` (`package billing;`)
   zawierający dokładnie te dwa zagnieżdżone typy i pięć statycznych
   metod (następne dwa laby zależą od tych dokładnych nazw):
   - `public static class Item` z publicznymi polami `name` (`String`),
     `price` (`double`), `qty` (`int`), i odpowiadającym konstruktorem.
   - `public static class Bill` z publicznymi polami `subtotal`,
     `discount`, `tax`, `tip`, `total` (wszystkie `double`), i
     odpowiadającym konstruktorem.
   - `public static double calculateSubtotal(List<Item> items)` — suma
     `price * qty` dla każdej pozycji.
   - `public static double calculateDiscount(double subtotal)` — 10%
     `subtotal`, jeśli `subtotal >= 50`, inaczej `0`.
   - `public static double calculateTax(double amount)` — płaski 8%
     `amount`.
   - `public static double calculateTip(double amount, double tipRate)`
     — `amount * tipRate`.
   - `public static Bill calculateBill(List<Item> items, double tipRate)`
     — łączy cztery powyższe metody w `Bill`. **Na razie policz `tax` z
     całego `subtotal`, zupełnie jak oryginalny program** — wliczając
     bugi, niczego jeszcze nie naprawiasz.
4. Utwórz `src/main/java/billing/Cli.java` (ten sam pakiet) z metodą
   `public static void run(List<Calculator.Item> items, double tipRate)`,
   która wywołuje `Calculator.calculateBill` *raz* i drukuje rachunek
   bajt-po-bajcie identyczny z wynikiem oryginalnego programu, używając
   tylko pól zwróconego `Bill`.
5. Przepisz `src/main/java/Main.java` tak, żeby cała jego metoda `main`
   była tylko: zbuduj listę `items`, potem wywołaj
   `Cli.run(items, 0.15)`. Będziesz potrzebować `import
   billing.Calculator;` i `import billing.Cli;`.
6. Dodaj JUnit 5 do `build.gradle`, żeby Lab 07 miał czym pisać testy —
   dodaj blok `repositories { mavenCentral() }`, te zależności:
   ```gradle
   dependencies {
       testImplementation platform('org.junit:junit-bom:5.11.0')
       testImplementation 'org.junit.jupiter:junit-jupiter'
       testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
   }
   ```
   i blok `test { useJUnitPlatform() }`. Żaden plik testowy jeszcze nie
   istnieje — to jest w porządku, `./gradlew test` kończy się sukcesem
   przy zero znalezionych testów.
7. Uruchom swój zrefaktoryzowany punkt wejścia tą samą metodą, zapisując
   też jego wynik: `./gradlew run --console=plain | tee /tmp/bill-after.txt`.
   Porównaj oba pliki (będziesz musiał/a odrzucić własne linie banera
   Gradle z porównania, bo nie są częścią wyniku programu) —
   najprościej: porównaj tylko blok od `Receipt` w każdym pliku, albo
   porównaj wynik `./gradlew run --console=plain --quiet` bezpośrednio.

## Kryteria akceptacji

### Python

- `examples/restaurant-bill/python/bill.py` już nie istnieje.
- `uv run python main.py` produkuje wynik *identyczny* z wynikiem
  oryginalnego skryptu.
- `billing/calculator.py` definiuje wszystkie pięć funkcji z dokładnymi
  nazwami i sygnaturami wymienionymi powyżej.

### Go

- `examples/restaurant-bill/go/go.mod` istnieje, deklarując moduł
  `restaurant-bill`.
- `go run .` produkuje wynik *identyczny* z wynikiem oryginalnego
  programu.
- `billing/calculator.go` definiuje typy `Item`/`Bill` i wszystkie pięć
  funkcji z dokładnymi nazwami i sygnaturami wymienionymi powyżej.

### Java

- `examples/restaurant-bill/java/build.gradle` deklaruje zależności
  JUnit 5 i `useJUnitPlatform()`.
- `./gradlew run` produkuje wynik *identyczny* z wynikiem oryginalnego
  programu.
- `billing/Calculator.java` definiuje typy `Item`/`Bill` i wszystkie
  pięć metod z dokładnymi nazwami i sygnaturami wymienionymi powyżej.

## Weryfikacja

### Python

```bash
cd examples/restaurant-bill/python
python3 -c "import billing.calculator as c; print(c.calculate_bill([('Burger',12.50,2),('Fries',4.00,2),('Soda',2.50,2)], 0.15))" 2>&1 || true
uv run python main.py | tee /tmp/bill-after.txt
diff /tmp/bill-before.txt /tmp/bill-after.txt && echo "IDENTICAL"
test -f bill.py && echo "bill.py still exists — delete it" || echo "bill.py correctly removed"
cd -
```

Oczekiwane: `IDENTICAL` i `bill.py correctly removed`.

### Go

```bash
cd examples/restaurant-bill/go
go run . | tee /tmp/bill-after.txt
diff /tmp/bill-before.txt /tmp/bill-after.txt && echo "IDENTICAL"
test -f go.mod && echo "go.mod exists" || echo "go.mod missing — run go mod init"
cd -
```

Oczekiwane: `IDENTICAL` i `go.mod exists`.

### Java

```bash
cd examples/restaurant-bill/java
./gradlew run --console=plain --quiet | tee /tmp/bill-after.txt
diff /tmp/bill-before.txt /tmp/bill-after.txt && echo "IDENTICAL"
./gradlew test
cd -
```

Oczekiwane: `IDENTICAL`, i `./gradlew test` zakończone sukcesem (nawet
z zero testami — tego należy oczekiwać do Lab 07).

## Zastanów się

- Właśnie udowodniłeś/aś, że Twój refactoring nie zmienił zachowania,
  używając ręcznego `diff`. Co musiałbyś/abyś robić od nowa, ręcznie,
  każdy raz, gdy zmienisz jeszcze jedną linię, bez zautomatyzowanego
  testu?
- Krok obliczający potrzebuje tylko jednej liczby, żeby wykonać swoją
  pracę. Czym ta właściwość jest przydatna dla funkcji (albo metody)?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** Pięć funkcji w `calculator.py`, jedna funkcja w
  `cli.py`, jeden dwuliniowy `main.py`. To cała struktura.
- **Podpowiedź 2:** `calculate_bill` powinno wywoływać cztery inne
  funkcje — nie reimplementuj ich logiki inline.
- **Podpowiedź 3:** Jeśli Twój diff nie jest pusty, wypisz oba pliki
  przez `cat -A` albo porównaj linię po linii — formatowanie
  zmiennoprzecinkowe (`.2f`) to częste źródło drobnych niezgodności.

### Go

- **Podpowiedź 1:** Pięć funkcji plus dwa typy w `calculator.go`, jedna
  funkcja w `cli.go`, dwuliniowe `main()`. To cała struktura.
- **Podpowiedź 2:** `CalculateBill` powinno wywoływać cztery inne
  funkcje — nie reimplementuj ich logiki inline.
- **Podpowiedź 3:** Ścieżka importu dla Twojego własnego pakietu to
  `"<nazwa modułu z go.mod>/billing"` — jeśli `go run .` nie może go
  znaleźć, sprawdź dwa razy, czy pierwsza linia `go.mod` odpowiada
  temu, co importujesz.

### Java

- **Podpowiedź 1:** Dwa zagnieżdżone typy plus pięć statycznych metod w
  `Calculator.java`, jedna statyczna metoda w `Cli.java`, dwuliniowe
  `main`. To cała struktura.
- **Podpowiedź 2:** `calculateBill` powinno wywoływać cztery inne
  metody — nie reimplementuj ich logiki inline.
- **Podpowiedź 3:** Jeśli `./gradlew run` wydaje się wisieć pierwszy
  raz, pobiera dystrybucję Gradle i zależności — poczekaj, aż się raz
  skończy; każde kolejne uruchomienie jest szybkie.

Przed przejściem dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (zaczynający się od Lab 16)
tak — przyzwyczajaj się już teraz.

## Co dalej

Twój refactoring zachował zachowanie. Ale "zachowane" nie jest tym
samym co "poprawne", i teraz jedynym sposobem sprawdzenia jednego albo
drugiego jest czytanie kodu na oko. Dalej nauczysz komputer sprawdzać
za Ciebie.

Przejdź do [Lab 07 — Skąd wiemy, że to działa?](../07-automated-tests/README.pl.md).
