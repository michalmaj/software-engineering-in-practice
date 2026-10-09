# Lab 05 — "Działa na moim komputerze"

## Sytuacja

Kolega z zespołu przysyła Ci mały projekt i mówi "po prostu to
uruchom". Na jego maszynie działa. Na Twojej czegoś brakuje, albo
czegoś jest o wersję za stara, albo za nowa — a sam projekt nigdy nie
zapisał, czego faktycznie potrzebuje, więc żadne z Was nie potrafi
powiedzieć, dlaczego, bez zgadywania.

Starter tego laba mieszka w `examples/works-on-my-machine/<Twój
język>/` — `examples/` to miejsce, w którym żyje każdy trwały projekt
tego kursu, zaczynając od tego laba. Od teraz, przez resztę kursu,
pracujesz w jednym z trzech tracków — Python, Go albo Java — i to jest
pierwszy lab, w którym ten wybór faktycznie ma znaczenie: wybierz ten,
którego Twój zespół (albo Ty, jeśli solo) będzie używać, i podążaj za
tamtą sekcją poniżej.

## Cele nauki

Po tym labie potrafisz:

- Wyjaśnić, dlaczego "u mnie działa" nie jest dowodem na to, że program
  jest poprawnie zapakowany albo odtwarzalny.
- Użyć toolchaina własnego tracku, żeby zrobić zależności projektu —
  albo wymaganą wersję narzędzia — jawnymi i wymuszanymi, nie tylko
  "czymkolwiek, co akurat jest na tej maszynie".
- Wyjaśnić, za co odpowiada manifest Twojego tracku, i co się dzieje,
  gdy projekt żąda czegoś, czego maszyna, która go uruchamia, nie ma.
- Wyjaśnić na wysokim poziomie, co konfiguracja devcontainer w tym
  repozytorium dostarcza dla wszystkich trzech języków, nie tylko
  Twojego.

## Zanim zaczniesz

### Python

- Lab 04 ukończony.
- Bieżący katalog: `examples/works-on-my-machine/python/` dla
  wszystkich poleceń poniżej, chyba że zaznaczono inaczej.
- Zainstalowane `uv`. Jeśli jesteś w Codespace/devcontainerze tego
  repozytorium, jest już gotowe (patrz główny
  [`README.pl.md`](../../README.pl.md)). Jeśli jeszcze go nie masz,
  zainstaluj poleceniem:
  `curl -LsSf https://astral.sh/uv/0.11.21/install.sh | sh` (przypięte
  do tej samej wersji co devcontainer, żeby każdy w tym kursie miał
  to samo `uv`).

### Go

- Lab 04 ukończony.
- Bieżący katalog: `examples/works-on-my-machine/go/` dla wszystkich
  poleceń poniżej, chyba że zaznaczono inaczej.
- Zainstalowane Go 1.27.x (patrz tabela toolchainu w głównym README) —
  jeśli jesteś w Codespace/devcontainerze tego repozytorium, już tam
  jest.

### Java

- Lab 04 ukończony.
- Bieżący katalog: `examples/works-on-my-machine/java/` dla wszystkich
  poleceń poniżej, chyba że zaznaczono inaczej.
- Zainstalowany JDK 21 (patrz tabela toolchainu w głównym README).
  Bez globalnej instalacji Gradle — ten starter przynosi swój własny
  zacommitowany Gradle Wrapper, i to wystarczy.

## Twoje zadanie

### Python

1. Bez instalowania czegokolwiek, spróbuj: `python3 main.py`.
   Przeczytaj błąd.
2. Otwórz `pyproject.toml` i zidentyfikuj, od jakiego pakietu
   faktycznie zależy projekt.
3. Uruchom `uv sync`. Zobacz, co pojawiło się w tym katalogu.
4. Uruchom `uv run python main.py`. Porównaj ten wynik z krokiem 1.
5. Uruchom `uv run pytest` i potwierdź, że testy przechodzą.
6. Z powrotem w katalogu głównym repozytorium, w nowym pliku
   `labs/05-works-on-my-machine/notes/my-observations.txt` zapisz
   własnymi słowami: (a) dlaczego krok 1 się nie powiódł, (b) co
   utworzył `uv sync` i po co, (c) co stałoby się z kolegą z zespołu,
   który uruchomiłby tylko `python3 main.py` na swojej maszynie, nigdy
   nie wykonawszy `uv sync`.
7. Otwórz `.devcontainer/devcontainer.json` w katalogu głównym
   repozytorium i znajdź linię, która dostarcza Pythona. Dopisz do
   swojego pliku notatek jeszcze jedno zdanie: co dostarcza Go i Javę
   w tym samym pliku?

### Go

1. Potwierdź, że starter działa dokładnie tak, jak jest zacommitowany:
   ```bash
   go test ./...
   go run .
   ```
   Oczekiwane: `ok` i `It works on my machine!`.
2. W swojej własnej kopii roboczej — nie w zacommitowanym pliku —
   otwórz `go.mod` i podnieś linię `go` o jedną wersję minor ponad
   obecny baseline kursu (`go 1.27` staje się `go 1.28`), żeby
   zasymulować projekt, który teraz wymaga nowszego Go, niż ma ściśle
   skonfigurowana maszyna kolegi z zespołu.
3. Uruchom `GOTOOLCHAIN=local go build ./...`. Przeczytaj błąd. Jest
   prawdziwy: `GOTOOLCHAIN=local` mówi Go "nigdy nie pobieraj innego
   toolchaina, używaj wyłącznie tego, co już jest na tej maszynie" —
   ten sam kompromis, na który może świadomie zdecydować się ściśle
   offline'owa albo zablokowana maszyna CI.
4. Uruchom ten sam build jeszcze raz, *bez* `GOTOOLCHAIN=local`, czyli
   z rzeczywistym domyślnym ustawieniem Go (`auto`): `go build ./...`.
   Zobaczysz jedną z dwóch rzeczy, zależnie od tego, czy Go 1.28 było
   już wydane w momencie, gdy to robisz: albo się pobierze i build
   przejdzie, albo zawiedzie z `toolchain not available`. Tak czy
   inaczej, zauważ, że to *inna* awaria niż w kroku 3 — `auto`
   faktycznie próbował pomóc; po prostu nie może wymyślić wydania,
   które jeszcze nie istnieje. `local` nawet nie spróbował.
5. Zmień `go.mod` z powrotem na `go 1.27` — prawdziwą, zacommitowaną
   wartość. Uruchom `go build ./...` jeszcze raz (wciąż domyślne
   `auto`, bez zmiennej środowiskowej). Udaje się, za każdym razem,
   bo `1.27` to prawdziwa, wydana wersja, którą Go zawsze potrafi
   rozwiązać, niezależnie od tego, czy akurat już była na tej
   konkretnej maszynie. To jest właściwa lekcja: `auto` po cichu robi
   to, czego potrzebuje prawdziwy, zacommitowany `go.mod`; `local` nie
   robi nic i głośno narzeka.
6. Potwierdź, że `go test ./...` znowu przechodzi na przywróconym,
   zacommitowanym stanie — to właśnie sprawdza Course Health.
7. Z powrotem w katalogu głównym repozytorium, w nowym pliku
   `labs/05-works-on-my-machine/notes/my-observations.txt` zapisz
   własnymi słowami: (a) czego dokładnie odmówił `GOTOOLCHAIN=local` w
   kroku 3, (b) dlaczego awaria z kroku 4 jest innym *rodzajem* awarii
   niż ta z kroku 3, mimo że obie są awariami, (c) co stałoby się z
   kolegą z zespołu, którego maszyna ma tylko Go 1.27, gdyby ten
   projekt faktycznie, w zacommitowanym stanie, wymagał 1.28.
8. Otwórz `.devcontainer/devcontainer.json` w katalogu głównym
   repozytorium i znajdź linię, która dostarcza Go. Dopisz do swojego
   pliku notatek jeszcze jedno zdanie: co dostarcza Pythona i Javę w
   tym samym pliku?

### Java

1. Potwierdź, że starter działa dokładnie tak, jak jest zacommitowany:
   ```bash
   ./gradlew test build
   ```
   Oczekiwane: `BUILD SUCCESSFUL`.
2. W swojej własnej kopii roboczej otwórz `build.gradle` i znajdź
   `JavaLanguageVersion.of(21)`. Zmień `21` na `25`.
3. Uruchom `./gradlew build` jeszcze raz. Przeczytaj błąd — Gradle
   mówi wprost, że żaden zainstalowany JDK nie spełnia tego, czego
   teraz żąda projekt, i że nie jest skonfigurowany, żeby którykolwiek
   pobrać.
4. Zmień `25` z powrotem na `21`. Uruchom `./gradlew build` jeszcze raz
   i potwierdź, że jest znowu zielone.
5. Z powrotem w katalogu głównym repozytorium, w nowym pliku
   `labs/05-works-on-my-machine/notes/my-observations.txt` zapisz
   własnymi słowami: (a) czego dokładnie odmówił Gradle w kroku 3 i
   dlaczego, (b) gdzie faktycznie mieszka wymagana wersja Javy w tym
   projekcie (to nie jest komentarz i nikt nie musi pamiętać jej na
   pamięć), (c) co stałoby się z kolegą z zespołu, który próbowałby
   zbudować ten projekt z JDK 17 zamiast 21.
6. Otwórz `.devcontainer/devcontainer.json` w katalogu głównym
   repozytorium i znajdź linię, która dostarcza Javę. Dopisz do
   swojego pliku notatek jeszcze jedno zdanie: co dostarcza Pythona i
   Go w tym samym pliku?

## Kryteria akceptacji

### Python

- `uv run pytest` przechodzi wewnątrz
  `examples/works-on-my-machine/python/`.
- `.venv/` i `uv.lock` istnieją w tym katalogu (uv je utworzył; nie
  pisz żadnego z nich ręcznie).
- `uv.lock`, utworzony przez `uv sync` (nie dostarczany razem ze
  starterem), jest zacommitowany do repozytorium — lock file jest
  przydatny koledze z zespołu tylko wtedy, gdy faktycznie jest wpięty
  do repo.
- `labs/05-works-on-my-machine/notes/my-observations.txt` odpowiada na
  wszystkie trzy punkty z kroku 6, plus na pytanie o devcontainer z
  kroku 7.

### Go

- `go test ./...` i `go run .` oba przechodzą na finalnym,
  przywróconym stanie (`go.mod` z powrotem na `go 1.27`) — dokładnie
  to sprawdza Course Health.
- `go.mod` jest zacommitowany bez zmian względem startera (`go 1.27`);
  podniesienie do `1.28` istniało tylko w Twojej własnej kopii
  roboczej na czas eksperymentu, nigdy niezacommitowane.
- `labs/05-works-on-my-machine/notes/my-observations.txt` odpowiada na
  wszystkie trzy punkty z kroku 7, plus na pytanie o devcontainer z
  kroku 8.

### Java

- `./gradlew test build` przechodzi na finalnym, przywróconym stanie
  (`JavaLanguageVersion.of(21)`) — dokładnie to sprawdza Course Health.
- `build.gradle` jest zacommitowany bez zmian względem startera
  (`JavaLanguageVersion.of(21)`); zmiana na `25` istniała tylko w
  Twojej własnej kopii roboczej na czas eksperymentu, nigdy
  niezacommitowana.
- `labs/05-works-on-my-machine/notes/my-observations.txt` odpowiada na
  wszystkie trzy punkty z kroku 5, plus na pytanie o devcontainer z
  kroku 6.

## Weryfikacja

### Python

```bash
cd examples/works-on-my-machine/python
uv run pytest
test -f uv.lock && echo "lock file exists"
test -d .venv && echo "virtualenv exists"
cd -
test -f labs/05-works-on-my-machine/notes/my-observations.txt && echo "notes exist"
```

### Go

```bash
cd examples/works-on-my-machine/go
cat go.mod
go test ./...
go run .
cd -
test -f labs/05-works-on-my-machine/notes/my-observations.txt && echo "notes exist"
```

Oczekiwane: `go.mod` pokazuje `go 1.27` (nie `1.28` — jeśli pokazuje
`1.28`, zapomniałeś/aś go przywrócić przed zakończeniem); `go test
./...` wypisuje `ok`; `go run .` wypisuje `It works on my machine!`.

### Java

```bash
cd examples/works-on-my-machine/java
grep JavaLanguageVersion build.gradle
./gradlew test build
cd -
test -f labs/05-works-on-my-machine/notes/my-observations.txt && echo "notes exist"
```

Oczekiwane: linia z `grep` pokazuje `JavaLanguageVersion.of(21)` (nie
`25` — jeśli pokazuje `25`, zapomniałeś/aś go przywrócić przed
zakończeniem); `./gradlew test build` kończy się `BUILD SUCCESSFUL`.

## Zastanów się

- Manifest Twojego tracku podaje, czego projekt potrzebuje; lock file
  (albo przypięta wersja toolchaina) podaje dokładnie, która wersja to
  spełnia, co do ostatniej cyfry. Dlaczego potrzebujesz obu, a nie
  tylko jednego?
- Jeśli dwoje kolegów z zespołu na różnych systemach operacyjnych
  zbuduje ten sam projekt z tego samego zacommitowanego manifestu, czy
  powinni skończyć ze zgodnymi wynikami? Dlaczego?
- Konfiguracja devcontainer dostarcza wszystkie trzy języki systemowo,
  ale faktyczne ćwiczenie tego laba dotyczy wymagania na poziomie
  projektu (zależności Pythona, wersji toolchaina Go, wersji języka
  Javy) nałożonego na to. Jaka jest różnica między "runtime języka jest
  dostępny na tej maszynie" a "wymagania tego konkretnego projektu są
  odtwarzalne"?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** Całe laboratorium to trzy polecenia: `uv sync`, `uv
  run python main.py`, `uv run pytest`. Reszta to czytanie i pisanie
  notatek.
- **Podpowiedź 2:** Jeśli `python3 main.py` "po prostu działa" u Ciebie
  bez `uv sync`, to dlatego, że `cowsay` jest przypadkiem już
  zainstalowany globalnie na Twojej maszynie — to dokładnie ta
  pułapka, o której jest to laboratorium. Spróbuj w zupełnie świeżym
  Codespace, żeby zobaczyć prawdziwą porażkę.
- **Podpowiedź 3:** `uv run <command>` uruchamia `<command>` wewnątrz
  środowiska zarządzanego przez sam projekt, bez potrzeby ręcznej
  aktywacji czegokolwiek.

### Go

- **Podpowiedź 1:** Jeśli błąd z kroku 3 w ogóle nie wspomina `1.28`,
  potwierdź, że faktycznie zapisałeś/aś `go.mod` po edycji — `go
  build` czyta plik na nowo za każdym razem, nie pamięta starego
  wymagania.
- **Podpowiedź 2:** `GOTOOLCHAIN` to prawdziwa zmienna środowiskowa,
  którą sam Go odczytuje, nie coś wymyślonego na potrzeby tego laba —
  `go env GOTOOLCHAIN` pokazuje rzeczywiste domyślne ustawienie Twojej
  maszyny (normalnie `auto`), gdy go nie nadpisujesz w linii poleceń.
- **Podpowiedź 3:** Jeśli nie pamiętasz, czy przywróciłeś/aś `go.mod`,
  `cat go.mod` od razu Ci powie — powinno pokazać `go 1.27`, zgodnie z
  tym, co `git diff go.mod` pokazałby jako całkowity brak zmian.

### Java

- **Podpowiedź 1:** Jeśli `./gradlew build` wydaje się wisieć albo nic
  nie robić po zmianie wersji Javy, daj mu kilka sekund — Gradle
  właśnie sprawdza Twoje zainstalowane JDK, zanim będzie mógł
  powiedzieć, że żaden nie pasuje.
- **Podpowiedź 2:** Błąd podaje dokładne wymaganie, którego nie udało
  się spełnić (`languageVersion=25`) — to linia
  `JavaLanguageVersion.of(...)` z `build.gradle` odzywa się do Ciebie,
  nie generyczny błąd Gradle.
- **Podpowiedź 3:** Jeśli nie pamiętasz, czy przywróciłeś/aś
  `build.gradle`, `git diff build.gradle` od razu Ci powie — powinno
  pokazać całkowity brak zmian.

Zanim pójdziesz dalej: zacommituj i wypchnij wszystko z tego laba,
włącznie z tym, co wygenerował Twój track (Pythonowy `uv.lock`
włącznie; manifesty Go i Javy zostają zacommitowane bez zmian, bez
żadnego wygenerowanego artefaktu lock do dodania)
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (od Lab 16) już tak — wyrób
sobie ten nawyk już teraz.

## Co dalej

Masz już jeden mały, odtwarzalny projekt, w którymkolwiek języku
wybrałeś/aś. Prawdziwe projekty jednak nie zostają w jednym pliku na
długo. Dalej zajmiesz się skryptem, który urósł ponad punkt, w którym
"po prostu jeden plik" wciąż działa.

Przejdź do [Lab 06 — Od skryptu do projektu](../06-from-script-to-project/README.pl.md).
