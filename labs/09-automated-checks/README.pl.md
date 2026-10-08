# Lab 09 — Maszyny mogą sprawdzać nudne rzeczy

## Sytuacja

Twój ostatni code review zajął dziesięć minut na dojście do zgody w
sprawie: tabów kontra spacji, nieużywanego importu, i czy string
powinien używać pojedynczych czy podwójnych cudzysłowów. Nic z tego nie
dotyczyło tego, czy kod robi właściwą rzecz — do tego służą testy, choć
(jak Lab 08 właśnie Ci pokazał) testy łapią tylko to, o czym ktoś
pomyślał, żeby napisać test. Spory o styl wciąż tracą czas review na
pytanie, na które maszyna może odpowiedzieć za Ciebie.

To jedyny lab, w którym trzy ścieżki faktycznie używają różnych
narzędzi, bo Python, Go i Java faktycznie różnią się w tym, gdzie
kończy się formatowanie a zaczyna analiza statyczna. Czytaj tylko
sekcję swojej ścieżki.

## Cele nauki

Po tym labie potrafisz:

- Odróżnić, co sprawdza formatter od tego, co sprawdza analizator
  statyczny, i obie te rzeczy od tego, co sprawdza test.
- Dodać i skonfigurować narzędzie tylko-dla-dev w manifeście własnego
  projektu.
- Uruchomić formatter i analizator swojej ścieżki, i przeczytać ich
  wynik.

## Zanim zaczniesz

- Lab 08 ukończony, w którejkolwiek ścieżce realizujesz: błąd podatku
  jest naprawiony, a pełny zestaw testów jest zielony.

### Python

- Bieżący katalog: `examples/restaurant-bill/python/`.

### Go

- Bieżący katalog: `examples/restaurant-bill/go/`. `gofmt` i `go vet`
  przychodzą z toolchainem Go, który już zainstalowałeś/aś w Lab 06 —
  nic nowego do instalowania.

### Java

- Bieżący katalog: `examples/restaurant-bill/java/`. Ten track dodaje
  dwa pluginy Gradle (formatter i analizator statyczny) — obie
  rozwiązują się z Maven Central przy pierwszym uruchomieniu, tak samo
  jak zależność JUnit 5 w Lab 06.

## Twoje zadanie

### Python

1. Dodaj `ruff` jako zależność dev w `pyproject.toml` (obok `pytest`),
   potem uruchom `uv sync`.
2. Dodaj sekcję `[tool.ruff]` do `pyproject.toml` z
   `target-version = "py313"` i `line-length = 100`.
3. Uruchom `uv run ruff format --check .` — to mówi Ci, czy Twoje pliki
   są już sformatowane tak, jak sformatowałby je Ruff, bez niczego
   zmieniania.
4. Uruchom `uv run ruff check .` — to szuka rzeczywistych problemów w
   kodzie (nieużywanych importów, nieużywanych zmiennych i podobnych),
   co jest innym pytaniem niż formatowanie.
5. Tymczasowo dodaj nieużywany import (na przykład `import math`) na
   górę `billing/calculator.py`. Uruchom `uv run ruff check .` jeszcze
   raz i przeczytaj konkretną regułę, którą raportuje. Usuń import, gdy
   już zobaczyłeś/aś komunikat.
6. Napraw wszystko realne, co którekolwiek polecenie zgłosiło o Twoim
   własnym kodzie z Labów 06-08 — na przykład, jeśli `ruff check .`
   flaguje nieposortowany blok importów w pliku testowym, to jest
   realne; przeporządkuj go.

### Go

1. Uruchom `gofmt -l .`. To *wylistowuje* pliki, które nie są
   sformatowane tak, jak sformatowałby je `gofmt` — ale zauważ, że jego
   kod wyjścia to `0`, nawet gdy coś znajdzie, więc samo `gofmt -l .` w
   skrypcie przeszłoby po cichu niezależnie od wyniku. Naprawisz to w
   Lab 10; na razie wiedz, że "jakikolwiek wynik" znaczy "coś wymaga
   formatowania."
2. Uruchom `go vet ./...` — to szuka rzeczywistych błędów, których
   `gofmt` nie widzi (podejrzane wywołania `Printf`, nieosiągalny kod i
   podobne), co jest innym pytaniem niż formatowanie.
3. Tymczasowo zmień jeden z verbów formatu `fmt.Printf` w
   `billing/cli.go`, żeby nie zgadzał się z typem swojego argumentu —
   na przykład zmień `"Total: $%.2f\n"` na `"Total: %d\n"`, gdzie
   argument wciąż jest `float64`. Uruchom `go vet ./...` jeszcze raz i
   przeczytaj, co raportuje. Zmień string formatu z powrotem, gdy już
   zobaczyłeś/aś komunikat.
4. Uruchom `go test ./...`, żeby potwierdzić, że zestaw testów wciąż
   jest zielony (vet i gofmt nie uruchamiają Twoich testów za Ciebie).

### Java

1. Dodaj dwa pluginy do bloku `plugins` w `build.gradle`:
   ```gradle
   id 'pmd'
   id 'com.diffplug.spotless' version '8.10.3'
   ```
2. Dodaj blok `spotless` konfigurujący formatter Google'a dla Javy:
   ```gradle
   spotless {
       java {
           googleJavaFormat()
       }
   }
   ```
3. Uruchom `./gradlew spotlessCheck`. Formatter Google'a używa wcięć
   2-spacjowych, co bardzo prawdopodobnie nie jest tym, co użyły Laby
   06-08 — oczekuj, że to zaraportuje naruszenia na Twoich własnych
   plikach pierwszy raz, nie tylko na celowo złamanym przykładzie. To
   jest normalne; to nie jest to samo co failujący test.
4. Uruchom `./gradlew spotlessApply`, żeby faktycznie przeformatować
   wszystko, potem `./gradlew spotlessCheck` jeszcze raz, żeby
   potwierdzić, że jest teraz czysto.
5. Utwórz `config/pmd/ruleset.xml`:
   ```xml
   <?xml version="1.0"?>
   <ruleset name="restaurant-bill"
       xmlns="http://pmd.sourceforge.net/ruleset/2.0.0"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://pmd.sourceforge.net/ruleset/2.0.0 https://pmd.sourceforge.io/ruleset_2_0_0.xsd">
       <description>Minimal ruleset for the restaurant-bill Java track: a couple of
       real-mistake checks, not a full default category (which flags
       System.out.println, the whole point of this CLI).</description>

       <rule ref="category/java/bestpractices.xml/UnusedLocalVariable"/>
       <rule ref="category/java/bestpractices.xml/UnusedPrivateField"/>
       <rule ref="category/java/errorprone.xml/EmptyCatchBlock"/>
   </ruleset>
   ```
   Ten projekt celowo **nie** używa pełnych domyślnych kategorii reguł
   PMD — jedna z nich (`SystemPrintln`) zaflagowałaby każde wywołanie
   `System.out.printf` w `Cli.java`, co jest całą pracą tego programu.
   Mały, ręcznie wybrany ruleset to uprawniona decyzja, nie skrót.
6. Dodaj blok `pmd` do `build.gradle`:
   ```gradle
   pmd {
       toolVersion = '7.28.0'
       ruleSetFiles = files('config/pmd/ruleset.xml')
       ruleSets = []
   }
   ```
7. Uruchom `./gradlew pmdMain`. Powinien przejść — Twój kod z Labów
   06-08 nie ma nieużywanych lokalnych zmiennych, nieużywanych pól, ani
   pustych bloków catch.
8. Tymczasowo dodaj naprawdę nieużywaną lokalną zmienną do `Cli.java`
   (nie nazwaną `unused...` albo `ignored...` — PMD celowo ignoruje
   zmienne nazwane w ten sposób, co samo w sobie warto zauważyć).
   Uruchom `./gradlew pmdMain` jeszcze raz i przeczytaj, co raportuje.
   Usuń zmienną, gdy już zobaczyłeś/aś komunikat.
9. Uruchom `./gradlew test`, żeby potwierdzić, że zestaw testów wciąż
   jest zielony (Spotless i PMD nie uruchamiają Twoich testów za
   Ciebie).

## Kryteria akceptacji

### Python

- `pyproject.toml` wylistowuje `ruff` jako zależność dev i ma sekcję
  `[tool.ruff]`.
- `uv run ruff format --check .` nie raportuje plików do zmiany.
- `uv run ruff check .` nie raportuje problemów.

### Go

- `gofmt -l .` nie produkuje wyniku.
- `go vet ./...` niczego nie raportuje.

### Java

- `build.gradle` konfiguruje oba bloki `spotless` i `pmd` pokazane
  powyżej, a `config/pmd/ruleset.xml` istnieje.
- `./gradlew spotlessCheck` i `./gradlew pmdMain` obie się udają.

Wszystkie ścieżki: zestaw testów z Labów 07-08 wciąż przechodzi — nic z
tego nie zmieniło zachowania.

## Weryfikacja

### Python

```bash
cd examples/restaurant-bill/python
uv run ruff format --check .
uv run ruff check .
uv run pytest
cd -
```

Oczekiwane: obie komendy Ruff nie raportują niczego do naprawienia, a
`pytest` wciąż przechodzi.

### Go

```bash
cd examples/restaurant-bill/go
gofmt -l .
go vet ./...
go test ./...
cd -
```

Oczekiwane: `gofmt -l .` nic nie wypisuje, `go vet` nic nie wypisuje, a
`go test` przechodzi.

### Java

```bash
cd examples/restaurant-bill/java
./gradlew spotlessCheck
./gradlew pmdMain
./gradlew test
cd -
```

Oczekiwane: wszystkie trzy się udają.

## Zastanów się

- Które z narzędzi, których teraz użyłeś/aś w tym projekcie, mogłoby w
  zasadzie powiedzieć Ci, że Twój kod jest "poprawny"? Które mogą tylko
  powiedzieć Ci, że jest "konsekwentny" albo "wolny od oczywistych
  błędów"?
- Czemu uruchamiać formatter i analizator statyczny jako dwa osobne
  kroki, a nie jeden?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** `uv add --dev ruff` dodaje zależność za Ciebie
  zamiast ręcznego edytowania `pyproject.toml`, jeśli nie chcesz
  edytować TOML ręcznie.
- **Podpowiedź 2:** `ruff format` przepisuje pliki, żeby odpowiadały
  jego stylowi; `ruff format --check` tylko raportuje, co *by* się
  zmieniło, bez niczego dotykania — użyj `--check` najpierw.
- **Podpowiedź 3:** Jeśli `ruff check .` nic nie raportuje na Twoim
  własnym kodzie, to jest poprawny wynik, nie znak, że coś zrobiłeś/aś
  źle — znaczy, że Twój kod z Labów 06-08 był już czysty.

### Go

- **Podpowiedź 1:** `gofmt -l .` tylko *wylistowuje* nazwy plików; nigdy
  nie failuje sam z siebie. Skrypt, który chce failować, musi sam
  sprawdzić, czy ten wynik jest niepusty — to jest właśnie to, co Lab
  10 ma Cię zbudować.
- **Podpowiedź 2:** `gofmt -w .` (zamiast `-l`) faktycznie przepisuje
  pliki, naprawiając formatowanie, tak samo jak `ruff format` (bez
  `--check`) robi dla Pythona.
- **Podpowiedź 3:** Jeśli `go vet ./...` nic nie raportuje na Twoim
  własnym kodzie, to jest poprawny wynik — znaczy, że Twój kod z Labów
  06-08 nie miał żadnych problemów na poziomie vet od samego początku.

### Java

- **Podpowiedź 1:** Jeśli `spotlessApply` wydaje się nic nie robić,
  sprawdź, czy zapisałeś/aś pliki, które zmienił — niektóre edytory
  cache'ują zawartość pliku, aż klikniesz z powrotem w niego.
- **Podpowiedź 2:** Ostrzeżenie PMD o "wrong java version" dla
  `auxClasspath` jest niegroźne dla tego projektu — to PMD będący
  ostrożny co do wykrywania classpath, nie realny problem z Twoim
  kodem.
- **Podpowiedź 3:** Jeśli `pmdMain` nic nie raportuje na Twoim własnym
  kodzie, to jest poprawny wynik — znaczy, że Twój kod z Labów 06-08
  nie miał żadnego z trzech problemów, których ten ruleset szuka.

Przed przejściem dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (zaczynający się od Lab 16)
tak — przyzwyczajaj się już teraz.

## Co dalej

Masz teraz trzy różne rodzaje zautomatyzowanej informacji: testy,
formatowanie i analizę statyczną. Teraz musisz pamiętać kilka różnych
poleceń, w odpowiedniej kolejności, każdy raz. Dalej dasz sobie — i
każdemu po Tobie — dokładnie jeden sposób na ich uruchomienie.

Przejdź do [Lab 10 — Jeden oczywisty sposób sprawdzania projektu](../10-one-way-to-check/README.pl.md).
