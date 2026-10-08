# Lab 05 — "Działa na moim komputerze"

## Sytuacja

Kolega z zespołu przysyła Ci `main.py` i mówi "po prostu to uruchom,
wypisuje ładny komunikat". Próbujesz `python3 main.py`. Program się
wywala. Jego maszyna i Twoja najwyraźniej nie są tą samą maszyną.

Kod tego laba mieszka w `examples/works-on-my-machine/python/` —
`examples/` to miejsce, w którym żyje każdy trwały projekt tego kursu,
zaczynając od tego laba. Reszta tej strony to ścieżka Pythona; na
samym końcu jest podglądowa (preview) wersja tej samej lekcji w Go i
Javie, ale kurs na razie kontynuuje się po tym labie wyłącznie w
Pythonie.

## Cele nauki

Po tym labie potrafisz:

- Wyjaśnić, dlaczego "u mnie działa" nie jest dowodem na to, że program
  jest poprawnie zapakowany.
- Użyć `uv`, żeby utworzyć odtwarzalne środowisko Pythona na podstawie
  manifestu projektu.
- Wyjaśnić, za co odpowiadają `pyproject.toml` i `uv.lock`.
- Wyjaśnić na wysokim poziomie, do czego służy konfiguracja devcontainer w
  tym repozytorium.

## Zanim zaczniesz

- Lab 04 ukończony.
- Bieżący katalog: `examples/works-on-my-machine/python/` dla
  wszystkich poleceń poniżej, chyba że zaznaczono inaczej.
- Zainstalowane `uv`. Jeśli jesteś w Codespace/devcontainerze tego
  repozytorium, jest już gotowe (patrz główny
  [`README.pl.md`](../../README.pl.md)). Jeśli jeszcze go nie masz,
  zainstaluj poleceniem:
  `curl -LsSf https://astral.sh/uv/0.11.21/install.sh | sh` (przypięte
  do tej samej wersji co devcontainer, żeby każdy w tym kursie miał
  to samo `uv`)

## Twoje zadanie

1. Bez instalowania czegokolwiek, spróbuj: `python3 main.py`. Przeczytaj
   błąd.
2. Otwórz `pyproject.toml` i zidentyfikuj, od jakiego pakietu faktycznie
   zależy projekt.
3. Uruchom `uv sync`. Zobacz, co pojawiło się w tym katalogu.
4. Uruchom `uv run python main.py`. Porównaj ten wynik z krokiem 1.
5. Uruchom `uv run pytest` i potwierdź, że testy przechodzą.
6. Z powrotem w katalogu głównym repozytorium, w nowym pliku
   `labs/05-works-on-my-machine/notes/my-observations.txt` zapisz
   własnymi słowami: (a) dlaczego krok 1 się nie powiódł, (b) co
   utworzył `uv sync` i po co, (c) co stałoby się z kolegą z zespołu,
   który uruchomiłby tylko `python3 main.py` na swojej maszynie, nigdy nie
   wykonawszy `uv sync`.
7. Otwórz `.devcontainer/devcontainer.json` w katalogu głównym
   repozytorium i znajdź linię, która dostarcza Pythona. Dopisz do
   swojego pliku notatek jeszcze jedno zdanie: jakie narzędzie dostarcza
   Go i Javę w tym samym pliku?

## Kryteria akceptacji

- `uv run pytest` przechodzi wewnątrz `examples/works-on-my-machine/python/`.
- `.venv/` i `uv.lock` istnieją w tym katalogu (uv je utworzył; nie pisz
  żadnego z nich ręcznie).
- `uv.lock`, utworzony przez `uv sync` (nie dostarczany razem ze
  starterem), jest zacommitowany do repozytorium — lock file jest
  przydatny koledze z zespołu tylko wtedy, gdy faktycznie jest wpięty
  do repo.
- `labs/05-works-on-my-machine/notes/my-observations.txt` odpowiada na
  wszystkie trzy punkty z kroku 6, plus na pytanie o devcontainer z
  kroku 7.

## Weryfikacja

```bash
cd examples/works-on-my-machine/python
uv run pytest
test -f uv.lock && echo "lock file exists"
test -d .venv && echo "virtualenv exists"
cd -
test -f labs/05-works-on-my-machine/notes/my-observations.txt && echo "notes exist"
```

## Zastanów się

- `uv.lock` przypina dokładne wersje; `pyproject.toml` podaje zakres
  wersji. Dlaczego potrzebujesz obu, a nie tylko jednego?
- Jeśli dwoje kolegów z zespołu uruchomi `uv sync` na tym samym
  `pyproject.toml` + `uv.lock` na różnych systemach operacyjnych, czy
  powinni skończyć z tymi samymi wersjami zależności? Dlaczego?
- Konfiguracja devcontainer dostarcza Pythona, Go i Javę systemowo, ale to
  laboratorium mimo to używa `uv` konkretnie do zależności Pythona. Jaka
  jest różnica między "runtime języka jest dostępny" a "zależności tego
  projektu są odtwarzalne"?

## Jeśli utkniesz

- **Podpowiedź 1:** Całe laboratorium to trzy polecenia: `uv sync`, `uv
  run python main.py`, `uv run pytest`. Reszta to czytanie i pisanie
  notatek.
- **Podpowiedź 2:** Jeśli `python3 main.py` "po prostu działa" u Ciebie
  bez `uv sync`, to dlatego, że `cowsay` jest przypadkiem już
  zainstalowany globalnie na Twojej maszynie — to dokładnie ta pułapka,
  o której jest to laboratorium. Spróbuj w zupełnie świeżym Codespace,
  żeby zobaczyć prawdziwą porażkę.
- **Podpowiedź 3:** `uv run <command>` uruchamia `<command>` wewnątrz
  środowiska zarządzanego przez sam projekt, bez potrzeby ręcznej
  aktywacji czegokolwiek.

Zanim pójdziesz dalej: zacommituj i wypchnij wszystko z tego laba,
włącznie z `uv.lock` (`git add -A && git commit -m "..."; git push`).
Nic później jeszcze nie zakłada czystego drzewa, ale Akt IV (od Lab 16)
już tak — wyrób sobie ten nawyk już teraz.

## Co dalej

Masz już jeden mały, odtwarzalny projekt. Prawdziwe projekty jednak nie
zostają w jednym pliku na długo. Dalej zajmiesz się skryptem, który
urósł ponad punkt, w którym "po prostu jeden plik" wciąż działa.

Przejdź do [Lab 06 — Od skryptu do projektu](../06-from-script-to-project/README.pl.md).

## Podgląd: ta sama lekcja w Go i Javie

Python jest na razie jedynym językiem, który ten kurs wspiera od
początku do końca. Wszystko powyżej tej sekcji to prawdziwy, kompletny
Lab 05 — zrób to, jeśli chcesz kontynuować do Lab 06 i reszty kursu już
teraz.

Dwie sekcje poniżej to **podgląd (preview)**: samodzielny sposób, żeby
poczuć tę samą lekcję o odtwarzalnym środowisku, używając własnych
toolchainów Go i Javy. Nie prowadzą do Lab 06 — nie istnieje jeszcze
Lab 06 dla Go albo Javy. Traktuj to jako wczesny podgląd ścieżki, którą
ten kurs wciąż buduje, nie jako drugi sposób na ukończenie kursu.

### Go (podgląd)

Starter: `examples/works-on-my-machine/go/`. Wymaga Go 1.27.x (patrz
tabela toolchainu w głównym README).

1. Potwierdź, że starter działa dokładnie tak, jak jest zacommitowany:
   ```bash
   cd examples/works-on-my-machine/go
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

Czego to uczy: linia `go` w `go.mod` to prawdziwe, wymuszane wymaganie,
tak jak `pyproject.toml` i `uv.lock` dla Pythona — nie komentarz, który
nikt nie sprawdza.

