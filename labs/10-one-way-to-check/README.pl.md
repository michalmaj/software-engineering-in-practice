# Lab 10 — Jeden oczywisty sposób sprawdzania projektu

## Sytuacja

Nowy współtwórca pyta: "jak jeszcze raz uruchomić testy? I czy to był
formatter czy analizator pierwszy?" Wpisałeś/aś te polecenia tyle razy,
że już o nich nie myślisz — co jest właśnie powodem, czemu nowy
człowiek nie powinien musieć pytać.

## Cele nauki

Po tym labie potrafisz:

- Opakować sekwencję poleceń w mały, czytelny skrypt shellowy.
- Wyjaśnić, czemu skrypt na poziomie projektu jest lepszy niż
  instrukcja w README, którą czytelnik musi skopiować ręcznie.
- Wyjaśnić, co znaczy "brak ukrytej magii" dla automatyzacji, którą
  sam/a piszesz.

## Zanim zaczniesz

- Lab 09 ukończony, w którejkolwiek ścieżce realizujesz: Twój
  formatter, Twój analizator i Twoje testy wszystkie się udają
  pojedynczo.
- **Uwaga dla Windows:** ten kurs działa na Git Bash na Windowsie, nie
  WSL i nie Docker. Git nie przechowuje bitu wykonywalności Unix tak
  samo jak Linux i macOS, więc skrypt, który działa, gdy wpisujesz
  `./scripts/check.sh` na swojej maszynie, może nie być bezpośrednio
  wykonywalny na maszynie kolegi z zespołu. Przenośny sposób
  wywoływania każdego z tych skryptów, na każdym systemie, który ten
  kurs wspiera, to:
  ```bash
  bash scripts/check.sh
  ```
  To zawsze działa, bo nigdy nie zależy od własnego bitu wykonywalności
  pliku — po prostu mówisz `bash`, żeby uruchomił plik, tak samo jak
  powiedziałbyś/abyś mu uruchomić jakikolwiek inny skrypt. Wciąż
  oznacz skrypty jako wykonywalne (`chmod +x scripts/*.sh`) poniżej —
  gdzie bezpośrednie wykonanie działa na Twoim systemie, to wygodny
  skrót, nie jedyny wspierany sposób.

### Python

- Bieżący katalog: `examples/restaurant-bill/python/`.

### Go

- Bieżący katalog: `examples/restaurant-bill/go/`.

### Java

- Bieżący katalog: `examples/restaurant-bill/java/`. Twoje skrypty
  opakowują zacommitowany `./gradlew`, nigdy globalnie zainstalowany
  `gradle` — ten projekt nie zakłada, że taki istnieje.

## Twoje zadanie

Utwórz katalog `scripts/` z czterema skryptami, każdym uruchamianym z
dowolnego miejsca (same `cd` do katalogu głównego projektu, więc Twój
bieżący katalog w momencie wywołania nie ma znaczenia):

1. `scripts/test.sh` — uruchamia zestaw testów.
2. `scripts/check.sh` — uruchamia kontrolę formattera i analizator
   statyczny (w tej kolejności), potem zestaw testów.
3. `scripts/format.sh` — faktycznie przeformatowuje kod (nie tylko
   kontrola).
4. `scripts/run.sh` — uruchamia aplikację.

Zrób wszystkie cztery wykonywalne (`chmod +x scripts/*.sh`). Każdy
skrypt powinien być wystarczająco krótki, żeby czytanie go od góry do
dołu mówiło Ci dokładnie, co robi — żadna osobna dokumentacja nie
powinna być potrzebna, żeby go zrozumieć.

### Python

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

uv run pytest
```

To jest `scripts/test.sh` w całości. `scripts/check.sh` uruchamia
`uv run ruff format --check .`, potem `uv run ruff check .`, potem
`uv run pytest`. `scripts/format.sh` uruchamia `uv run ruff format .`.
`scripts/run.sh` uruchamia `uv run python main.py`.

### Go

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

go test ./...
```

To jest `scripts/test.sh` w całości. `scripts/format.sh` uruchamia
`gofmt -w .`. `scripts/run.sh` uruchamia `go run main.go`.
`scripts/check.sh` jest jedynym skryptem, który potrzebuje więcej niż
jednej komendy, z powodu dziwactwa `gofmt -l` z Lab 09 (wylistowuje
problemy, ale sam nigdy nie failuje):

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== gofmt =="
unformatted="$(gofmt -l .)"
if [ -n "$unformatted" ]; then
  echo "Not formatted:"
  echo "$unformatted"
  exit 1
fi

echo "== go vet =="
go vet ./...

echo "== go test =="
go test ./...
```

### Java

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

./gradlew test --console=plain
```

To jest `scripts/test.sh` w całości. `scripts/format.sh` uruchamia
`./gradlew spotlessApply --console=plain`. `scripts/run.sh` uruchamia
`./gradlew run --console=plain`. `scripts/check.sh` uruchamia wszystkie
trzy kontrole Gradle po kolei:

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
export PMD_JAVA_DISABLE_AUX_CLASSPATH_WARNINGS=true

echo "== spotless (formatter) =="
./gradlew spotlessCheck --console=plain

echo "== pmd (static analysis) =="
./gradlew pmdMain --console=plain

echo "== tests =="
./gradlew test --console=plain
```

(Eksportowana zmienna tylko wygasza niegroźne ostrzeżenie PMD z Lab 09
— nie zmienia tego, co jest sprawdzane.)

## Kryteria akceptacji

- Wszystkie cztery skrypty istnieją, są wykonywalne, i działają, gdy
  wywołane przez `bash scripts/<name>.sh` z innego katalogu startowego
  (np. Twojego katalogu domowego).
- `scripts/check.sh` kończy się statusem niezerowym, jeśli
  formatowanie, analiza statyczna albo testy failują — nowy człowiek
  powinien zobaczyć jedną jasną porażkę, nie ciche kontynuowanie.
- Przeczytanie jednego skryptu zajmuje mniej niż trzydzieści sekund.

## Weryfikacja

### Python

```bash
cd ~
bash /path/to/examples/restaurant-bill/python/scripts/test.sh
bash /path/to/examples/restaurant-bill/python/scripts/check.sh
bash /path/to/examples/restaurant-bill/python/scripts/run.sh
cd -
```

### Go

```bash
cd ~
bash /path/to/examples/restaurant-bill/go/scripts/test.sh
bash /path/to/examples/restaurant-bill/go/scripts/check.sh
bash /path/to/examples/restaurant-bill/go/scripts/run.sh
cd -
```

### Java

```bash
cd ~
bash /path/to/examples/restaurant-bill/java/scripts/test.sh
bash /path/to/examples/restaurant-bill/java/scripts/check.sh
bash /path/to/examples/restaurant-bill/java/scripts/run.sh
cd -
```

(Zastąp `/path/to/` swoją rzeczywistą ścieżką repozytorium.) Oczekiwane:
wszystkie trzy kończą się sukcesem, bez ręcznego `cd` z Twojej strony.

## Zastanów się

- Co by się stało ze `scripts/check.sh`, gdyby jedna z jego komend
  failowała w połowie, a skrypt nie zatrzymał się natychmiast? Która
  linia w Twoim skrypcie temu zapobiega?
- Czy jest coś w tym, co te skrypty robią, co nie jest widoczne po
  samym ich przeczytaniu? Jeśli kolega z zespołu zapytałby "co
  faktycznie robi `check.sh`", czy mógłbyś/mogłabyś po prostu pokazać
  mu plik?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** Zacznij każdy skrypt od `#!/usr/bin/env bash` i
  `set -euo pipefail` — druga linia zatrzymuje skrypt natychmiast przy
  pierwszej failującej komendzie.
- **Podpowiedź 2:** Żeby skrypt działał niezależnie od bieżącego
  katalogu wywołującego, umieść `cd "$(dirname "$0")/.."` blisko góry,
  zaraz po `set -euo pipefail`.
- **Podpowiedź 3:** `chmod +x scripts/*.sh` robi wszystkie cztery
  wykonywalne naraz.

### Go

- **Podpowiedź 1:** Ten sam zwyczaj `set -euo pipefail` dotyczy tutaj
  — bez niego, `scripts/check.sh` wciąż uruchomiłby `go vet`, nawet
  jeśli `gofmt` coś znalazł, co psuje cały sens.
- **Podpowiedź 2:** `unformatted="$(gofmt -l .)"` przechwytuje wynik
  komendy do zmiennej, zamiast go natychmiast wypisywać — `[ -n
  "$unformatted" ]` potem sprawdza, czy ta zmienna jest niepusta.
- **Podpowiedź 3:** Jeśli `scripts/run.sh` nie może znaleźć `main.go`,
  gdy wywołany z innego katalogu, sprawdź dwa razy, czy linia
  `cd "$(dirname "$0")/.."` jest naprawdę pierwszą rzeczą po
  `set -euo pipefail`.

### Java

- **Podpowiedź 1:** `--console=plain` utrzymuje wynik Gradle prosty i
  przyjazny dla skryptów — bez tego, bardziej wyszukany wynik
  terminalowy Gradle może wyglądać dziwnie, gdy jest przekierowany
  albo logowany.
- **Podpowiedź 2:** Jeśli `scripts/run.sh` wydaje się wisieć pierwszy
  raz od świeżego checkoutu, to Gradle pobiera swoją dystrybucję
  jeszcze raz — tak samo jak pierwsze uruchomienie w Lab 06.
- **Podpowiedź 3:** Wszystkie cztery skrypty wywołują `./gradlew`,
  nigdy goły `gradle` — jeśli wpisałeś/aś `gradle` przez pomyłkę w
  jednym z nich, to jest prawie na pewno bug.

Przed przejściem dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Akt IV (zaczynający
się od Lab 16) zakłada czyste drzewo od teraz.

## Co dalej

Zmieniłeś/aś jednoplikowy monolit w mały, dobrze przetestowany,
konsekwentnie sprawdzany projekt, w swoim wybranym języku. Akt II jest
zakończony — dla wszystkich trzech ścieżek, tak samo jak wszystko aż do
Aktu VI: Go i Java kontynuują teraz aż do capstone, w tym samym języku,
którego używasz od tego aktu.

Przejdź do [Lab 11 — Klient zmienił zdanie](../11-changed-requirements/README.pl.md).
