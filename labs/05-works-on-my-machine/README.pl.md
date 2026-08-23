# Lab 05 — "Działa na moim komputerze"

## Sytuacja

Kolega z zespołu przysyła Ci `main.py` z tego folderu i mówi "po prostu to
uruchom, wypisuje ładny komunikat". Próbujesz `python3 main.py`. Program
się wywala. Jego maszyna i Twoja najwyraźniej nie są tą samą maszyną.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Wyjaśnić, dlaczego "u mnie działa" nie jest dowodem na to, że program
  jest poprawnie zapakowany.
- Użyć `uv`, żeby utworzyć odtwarzalne środowisko Pythona na podstawie
  manifestu projektu.
- Wyjaśnić, za co odpowiadają `pyproject.toml` i `uv.lock`.
- Wyjaśnić na wysokim poziomie, do czego służy konfiguracja devcontainer w
  tym repozytorium.

## Zanim zaczniesz

- Lab 04 ukończony.
- Bieżący katalog: `labs/05-works-on-my-machine/` dla wszystkich poleceń
  poniżej, chyba że zaznaczono inaczej.
- Zainstalowane `uv`. Jeśli jesteś w Codespace/devcontainerze tego
  repozytorium, jest już gotowe (patrz główny
  [`README.pl.md`](../../README.pl.md)). Jeśli jeszcze go nie masz,
  zainstaluj poleceniem:
  `curl -LsSf https://astral.sh/uv/install.sh | sh`

## Twoje zadanie

1. Bez instalowania czegokolwiek, spróbuj: `python3 main.py`. Przeczytaj
   błąd.
2. Otwórz `pyproject.toml` i zidentyfikuj, od jakiego pakietu faktycznie
   zależy projekt.
3. Uruchom `uv sync`. Zobacz, co pojawiło się w tym katalogu.
4. Uruchom `uv run python main.py`. Porównaj ten wynik z krokiem 1.
5. Uruchom `uv run pytest` i potwierdź, że testy przechodzą.
6. W nowym pliku `labs/05-works-on-my-machine/notes/my-observations.txt`
   zapisz własnymi słowami: (a) dlaczego krok 1 się nie powiódł, (b) co
   utworzył `uv sync` i po co, (c) co stałoby się z kolegą z zespołu,
   który uruchomiłby tylko `python3 main.py` na swojej maszynie, nigdy nie
   wykonawszy `uv sync`.
7. Otwórz `.devcontainer/devcontainer.json` w katalogu głównym
   repozytorium i znajdź linię, która dostarcza Pythona. Dopisz do
   swojego pliku notatek jeszcze jedno zdanie: jakie narzędzie dostarcza
   Go i Javę w tym samym pliku?

## Kryteria akceptacji

- `uv run pytest` przechodzi wewnątrz `labs/05-works-on-my-machine/`.
- `.venv/` i `uv.lock` istnieją w tym katalogu (uv je utworzył; nie pisz
  żadnego z nich ręcznie).
- `uv.lock`, utworzony przez `uv sync` (nie ship'owany ze starterem),
  jest zacommitowany do repozytorium — lock file jest przydatny
  koledze z zespołu tylko wtedy, gdy faktycznie jest wpięty do repo.
- `notes/my-observations.txt` odpowiada na wszystkie trzy punkty z kroku
  6, plus na pytanie o devcontainer z kroku 7.

## Weryfikacja

```bash
cd labs/05-works-on-my-machine
uv run pytest
test -f uv.lock && echo "lock file exists"
test -d .venv && echo "virtualenv exists"
test -f notes/my-observations.txt && echo "notes exist"
cd -
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
