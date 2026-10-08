# Konfiguracja macOS

[In English →](macos.md) · [← Wróć do Zacznij tutaj](../../START-HERE.pl.md)

Jeśli gdzieś utkniesz, przejdź do [Jeśli utkniesz](#jeśli-utkniesz) na
dole, albo do wspólnego [`troubleshooting.pl.md`](troubleshooting.pl.md).

## Część 1 — Otwórz Terminal

1. Naciśnij `Cmd+Space`, żeby otworzyć wyszukiwanie Spotlight.
2. Wpisz `Terminal`.
3. Naciśnij Enter, albo kliknij **Terminal**, gdy się pojawi.

**Co powinieneś/aś zobaczyć:** okno z promptem tekstowym, coś jak
`twojanazwa@Twoj-MacBook ~ %`.

**Co zrobić, jeśli widzisz coś innego:** jeśli Spotlight nie znajduje
Terminala, jest też w **Applications → Utilities → Terminal** przez
Findera.

## Część 2 — Sprawdź Xcode Command Line Tools

Git na macOS przychodzi razem z narzędziami wiersza poleceń Apple, nie
jest instalowany osobno.

1. W Terminalu:
   ```bash
   git --version
   ```
2. **Co powinieneś/aś zobaczyć — jedno z dwóch:**
   - Prawdziwy numer wersji jak `git version 2.39.3 (Apple Git-145)` —
     narzędzia są już zainstalowane, przejdź do Części 3.
   - Okno popup: "The 'git' command requires the command line developer
     tools. Would you like to install the tools now?" — kliknij
     **Install**, potem zaakceptuj umowę licencyjną, która się pojawi.
3. Jeśli widziałeś/aś popup, zaczekaj, aż pobieranie i instalacja się
   zakończą (to może zająć kilka minut, zależnie od połączenia), potem
   potwierdź:
   ```bash
   git --version
   ```
   **Skąd wiesz, że możesz kontynuować:** wypisuje się prawdziwy numer
   wersji.

## Część 3 — Zainstaluj VS Code

Najprostsza ścieżka instaluje przez Homebrew, konsolowy menedżer
pakietów macOS. Jeśli nie chcesz instalować Homebrew, użyj alternatywy
z bezpośrednim pobraniem poniżej.

### Opcja A — Używając Homebrew (polecana)

1. Sprawdź, czy Homebrew jest już zainstalowany:
   ```bash
   brew --version
   ```
2. **Jeśli widzisz** `command not found: brew`, zainstaluj go oficjalną
   komendą (to jest prawdziwa komenda ze strony
   [brew.sh](https://brew.sh) — wklej ją dokładnie tak, jak jest
   napisana):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
3. Postępuj zgodnie z instrukcjami, które wypisze na końcu — na Makach
   z Apple Silicon instalator Homebrew zwykle prosi o uruchomienie
   jednej lub dwóch dodatkowych komend, żeby dodać go do `PATH` Twojej
   powłoki. Skopiuj i uruchom dokładnie to, co pokazuje.
4. Zamknij Terminal całkowicie i otwórz go ponownie (Część 1), potem
   potwierdź:
   ```bash
   brew --version
   ```
   **Skąd wiesz, że możesz kontynuować:** wypisuje się prawdziwy numer
   wersji.
5. Zainstaluj VS Code:
   ```bash
   brew install --cask visual-studio-code
   ```
6. **Co powinieneś/aś zobaczyć:** wynik pobierania i instalacji
   kończący się bez błędu.

### Opcja B — Bezpośrednie pobranie (bez Homebrew)

1. Wejdź na [code.visualstudio.com](https://code.visualstudio.com/) w
   przeglądarce i pobierz wersję dla macOS.
2. Otwórz pobrany plik `.zip` — rozpakowuje się do
   `Visual Studio Code.app`.
3. Przenieś go do folderu **Applications**.

### Uruchom VS Code

Naciśnij `Cmd+Space`, wpisz `Visual Studio Code`, naciśnij Enter.

**Co powinieneś/aś zobaczyć:** otwiera się okno VS Code z zakładką
powitalną i pustym panelem Explorer po lewej (puste jest normalne — nie
otworzyłeś/aś jeszcze żadnego projektu).

## Część 4 — Otwórz terminal wewnątrz VS Code

1. W menu VS Code kliknij **Terminal → New Terminal**.
2. **Co powinieneś/aś zobaczyć:** panel terminala otwiera się na dole
   okna, z tym samym rodzajem promptu, który widziałeś/aś w Części 1 —
   terminal VS Code na macOS to domyślnie zsh, bez dodatkowej
   konfiguracji (w przeciwieństwie do Windowsa).
3. Potwierdź:
   ```bash
   pwd
   ```
   **Co powinieneś/aś zobaczyć:** ścieżka, prawdopodobnie kończąca się
   na Twoim folderze domowym (coś jak `/Users/twojanazwa`).

## Część 5 — Orientacja: aktualny folder i dom

- `pwd` zawsze mówi Ci dokładnie, gdzie jesteś.
- `ls` wylistowuje, co jest w aktualnym folderze.
- `cd` bez argumentów, albo `cd ~`, zawsze zabiera Cię z powrotem do
  folderu domowego, niezależnie od tego, jak zagubiony/a się czujesz.
- `cd ..` przenosi Cię jeden poziom folderów wyżej.

Jeśli w jakimkolwiek momencie wynik komendy wygląda nieznajomo, najpierw
uruchom `pwd` — większość zamieszania wynika z bycia w nieoczekiwanym
folderze.

## Część 6 — Zrób fork, sklonuj i otwórz to repozytorium

To jest faktyczny cel tej strony. Od teraz wszystko dzieje się albo w
przeglądarce, albo w terminalu VS Code z Części 4.

**Masz już fork albo lokalną kopię z wcześniejszej próby?** Nie
powtarzaj tych kroków na ślepo — przejdź najpierw do
[`already-have-a-fork.pl.md`](already-have-a-fork.pl.md).

### 6.1 — Zrób fork repozytorium na GitHubie

1. Upewnij się, że jesteś zalogowany/a na GitHubie — otwórz
   [github.com](https://github.com) w przeglądarce i sprawdź, czy
   prawy górny róg pokazuje Twój avatar konta, nie przycisk "Sign in".
   Jeśli nie masz jeszcze konta GitHub, najpierw je utwórz (jest
   darmowe), zanim przejdziesz dalej.
2. Przejdź do
   `https://github.com/michalmaj/software-engineering-in-practice`.
3. Kliknij przycisk **Fork**, w prawym górnym rogu strony.
4. Na stronie "Create a new fork" upewnij się, że **Owner** pokazuje
   *Twoje* konto, nie prowadzącego — ten dropdown domyślnie ustawia się
   na konto, na którym jesteś zalogowany/a, co powinno już być Tobą.
5. Kliknij **Create fork**.

**Co powinieneś/aś zobaczyć:** GitHub przenosi Cię na nową stronę,
której URL to
`https://github.com/<twój-username>/software-engineering-in-practice`
— Twój własny username, nie `michalmaj`, jest teraz w adresie
przeglądarki i w tytule strony, zaraz pod ikonką repozytorium, która
pokazuje, że powstało jako fork `michalmaj/software-engineering-in-practice`.

**Skąd wiesz, że możesz kontynuować:** URL w adresie przeglądarki
zawiera *Twój* username z GitHuba, nie `michalmaj`.

### 6.2 — Skopiuj adres klonowania swojego forka

1. Na stronie swojego forka (z poprzedniego kroku) kliknij zielony
   przycisk **Code**.
2. Upewnij się, że wybrana jest zakładka **HTTPS** (nie SSH, nie GitHub
   CLI — ten kurs nie wymaga konfigurowania kluczy SSH).
3. Kliknij małą ikonkę kopiowania przy adresie, żeby go skopiować.
   Wygląda jak:
   ```text
   https://github.com/<twój-username>/software-engineering-in-practice.git
   ```
   z Twoim rzeczywistym username zamiast `<twój-username>`.

### 6.3 — Sklonuj je na swój komputer

Z powrotem w terminalu VS Code z Części 4:

1. Zdecyduj, gdzie powinny żyć Twoje projekty, i utwórz ten folder,
   jeśli jeszcze nie istnieje. Rozsądny, prosty wybór:
   ```bash
   mkdir -p ~/projects
   cd ~/projects
   ```
2. Sklonuj swój fork — wklej adres, który skopiowałeś/aś w 6.2.
   **Zastąp `<twój-username>` swoim rzeczywistym username z GitHuba**;
   nie wklejaj poniższej linii dosłownie:
   ```bash
   git clone https://github.com/<twój-username>/software-engineering-in-practice.git
   ```
3. **Co powinieneś/aś zobaczyć:** linie jak `Cloning into
   'software-engineering-in-practice'...`, potem `Receiving objects:
   100%`, kończące się bez błędu.
4. Przejdź do nowego folderu:
   ```bash
   cd software-engineering-in-practice
   ```
5. Potwierdź, gdzie jesteś i co tu jest:
   ```bash
   pwd
   ls
   ```
   **Co powinieneś/aś zobaczyć:** `pwd` wypisuje coś kończące się na
   `/projects/software-engineering-in-practice`; `ls` wylistowuje
   foldery włącznie z `labs`, `examples`, `scripts`, i pliki włącznie z
   `README.md` i `START-HERE.md`.
6. Potwierdź, że sam Git jest zadowolony, i że wskazuje na *Twój* fork,
   nie prowadzącego:
   ```bash
   git status
   git remote -v
   ```
   **Co powinieneś/aś zobaczyć:** `git status` mówi `On branch main` i
   `nothing to commit, working tree clean`. `git remote -v` pokazuje
   dwie linie (`origin` fetch i push), których adres zawiera **Twój
   własny username z GitHuba** — jeśli widzisz tam `michalmaj` zamiast
   swojego username, sklonowałeś/aś przez pomyłkę oryginalne
   repozytorium, nie swój fork; zobacz
   [Sklonowałem/am repozytorium prowadzącego zamiast własnego forka](#sklonowałemam-repozytorium-prowadzącego-zamiast-własnego-forka)
   poniżej.

**Skąd wiesz, że możesz kontynuować:** `git remote -v` pokazuje Twój
własny username, a `ls` pokazuje `labs/`, `examples/` i `scripts/`.

### 6.4 — Otwórz je w VS Code

1. W VS Code kliknij **File → Open Folder…** (albo **File → Open…** w
   niektórych wersjach VS Code — wciąż otwiera okno wyboru folderu na
   macOS).
2. Przejdź do folderu, który sklonowałeś/aś — jeśli podążyłeś/aś za 6.3
   dokładnie, to `projects` → `software-engineering-in-practice`
   wewnątrz Twojego folderu domowego.
3. Kliknij **Open**.
4. VS Code może zapytać "Do you trust the authors of the files in this
   folder?" — kliknij **Yes, I trust the authors**.

**Co powinieneś/aś zobaczyć:** panel Explorer po lewej wylistowuje
teraz `labs`, `examples`, `scripts`, `README.md` i więcej — to samo, co
`ls` pokazał Ci w 6.3.

5. Otwórz terminal wewnątrz tego okna (**Terminal → New Terminal**).
   Potwierdź, że jesteś we właściwym miejscu:
   ```bash
   pwd
   ```
   **Skąd wiesz, że możesz kontynuować:** ścieżka kończy się na
   `/software-engineering-in-practice`, a panel Explorer pokazuje
   folder `labs/`.

### 6.5 — Znajdź Lab 01

1. W panelu Explorer po lewej kliknij, żeby rozwinąć folder `labs`.
2. Znajdź i kliknij `01-workstation`, potem kliknij `README.pl.md`
   wewnątrz niego.

**Co powinieneś/aś zobaczyć:** otwiera się `Lab 01 — Witaj na swoim
stanowisku pracy` jako czytelny dokument w edytorze.

To wszystko — dotarłeś/aś do końca zadania tej strony. Przejdź do
[Zanim skończysz](#zanim-skończysz), żeby wszystko podwójnie sprawdzić,
a potem zacznij lab.

## Pierwszy push do GitHuba

Nie wypchniesz niczego do GitHuba aż do połowy Lab 03 albo Lab 04 —
klonowanie i czytanie nie wymagają zalogowania do samego Gita, tylko
Twojej sesji przeglądarki z 6.1. Gdy tam dotrzesz i `git push` zapyta o
autoryzację, zobacz [`github-auth.pl.md`](github-auth.pl.md) — jest
napisane właśnie na ten moment, więc nie musisz tego czytać teraz.

## Zanim skończysz

Sprawdź każde z tych, zanim uznasz Lab 01 za gotowy do zaczęcia:

- [ ] `git --version` działa w Terminalu.
- [ ] Terminal VS Code otwiera się i działa tak jak terminal z Części 1.
- [ ] `pwd` wewnątrz terminala VS Code kończy się na
      `/software-engineering-in-practice`.
- [ ] `git status` działa bez błędu.
- [ ] `git remote -v` pokazuje **Twój własny** username z GitHuba.
- [ ] Panel Explorer pokazuje `labs/`, `examples/` i `scripts/`.
- [ ] `labs/01-workstation/README.pl.md` się otwiera.

Wszystko zaznaczone? Otwórz
[`labs/01-workstation/README.pl.md`](../../labs/01-workstation/README.pl.md)
i zaczynaj.

## Jeśli utkniesz

### `brew`, `git` albo `code` mówi "command not found"

Zamknij Terminal całkowicie i otwórz nowy (Część 1) — nowo zainstalowany
program, i własna konfiguracja `PATH` Homebrew, czasem nie zadziałają w
oknie Terminala, które było już otwarte przed zakończeniem instalacji.
Jeśli `brew` wciąż go nie ma po tym, sprawdź ponownie koniec wyniku
instalacji Homebrew (Część 3) pod kątem dodatkowej komendy konfiguracji
`PATH`, o którą prosił — ten krok łatwo przegapić.

### Sklonowałem/am repozytorium prowadzącego zamiast własnego forka

Jeśli `git remote -v` pokazuje `michalmaj` zamiast Twojego username:
folder, który sklonowałeś/aś, wskazuje na repozytorium, do którego nie
masz prawa push, co zablokuje Cię później (Lab 03–04). Napraw to bez
utraty czegokolwiek:

```bash
cd ..
mv software-engineering-in-practice software-engineering-in-practice.instructor-copy
```

To zmienia nazwę źle sklonowanego folderu, odsuwając go z drogi, zamiast
go usuwać, potem powtórz 6.1–6.4 tym razem z adresem *swojego* forka.
Gdy Twoja prawdziwa kopia już działa, możesz usunąć przemianowany
folder, jeśli chcesz, albo po prostu go zostawić — nie robi żadnej
szkody, siedząc tam.

### Wszystko inne

Zobacz wspólne [`troubleshooting.pl.md`](troubleshooting.pl.md) dla
problemów niespecyficznych dla macOS (problemy z logowaniem do
GitHuba, "repo już istnieje na dysku", VS Code otworzył niewłaściwy
folder, problemy z pierwszym push i więcej).
