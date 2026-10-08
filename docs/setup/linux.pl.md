# Konfiguracja Linuksa

[In English →](linux.md) · [← Wróć do Zacznij tutaj](../../START-HERE.pl.md)

Ta strona jest zweryfikowana dla Ubuntu/Debiana — jeśli masz inną
dystrybucję (Fedora, Arch, openSUSE, ...), komendy menedżera pakietów w
Części 2 będą inne; podmień je na odpowiednik dla swojej dystrybucji,
reszta strony dotyczy Cię bez zmian.

Jeśli gdzieś utkniesz, przejdź do [Jeśli utkniesz](#jeśli-utkniesz) na
dole, albo do wspólnego [`troubleshooting.pl.md`](troubleshooting.pl.md).

## Część 1 — Otwórz terminal

1. Otwórz menu aplikacji (dokładna nazwa i ikonka zależą od Twojego
   środowiska graficznego — GNOME nazywa to **Activities**, KDE ma
   własny launcher aplikacji, itd).
2. Wyszukaj **Terminal** (na Ubuntu zwykle nazywa się właśnie
   "Terminal", ikonka wygląda jak ciemny prostokąt z `>_`).
3. Kliknij, żeby go otworzyć.

**Co powinieneś/aś zobaczyć:** okno z promptem tekstowym, zwykle
kończącym się na `$`, coś jak `ty@twojkomputer:~$`.

**Jeśli widzisz coś innego:** jeśli po otwarciu menu aplikacji nie
widzisz pola wyszukiwania, poszukaj ikonki "Terminal" albo "Terminal
Emulator" prosto na pasku zadań albo docku — praktycznie każdy pulpit
Linuksa ma jeden domyślnie, czasem pod lekko inną nazwą.

## Część 2 — Sprawdź Gita i zainstaluj, jeśli go nie ma

1. W terminalu sprawdź, czy Git jest już zainstalowany:
   ```bash
   git --version
   ```
2. **Co powinieneś/aś zobaczyć:** coś jak `git version 2.43.0`. Jeśli to
   widzisz, przejdź do Części 3.
3. **Jeśli widzisz** `git: command not found` albo `Command 'git' not
   found`, zainstaluj go. Dokładna komenda zależy od Twojej
   dystrybucji:

   - **Ubuntu / Debian:**
     ```bash
     sudo apt update
     sudo apt install -y git
     ```
   - **Fedora:**
     ```bash
     sudo dnf install -y git
     ```
   - **Arch:**
     ```bash
     sudo pacman -S git
     ```

   Przedrostek `sudo` oznacza, że to wymaga hasła administratora Twojego
   konta — wpisz je, gdy zostaniesz o to poproszony/a (nie pojawi się na
   ekranie, gdy piszesz, to normalne) i naciśnij Enter.
4. Potwierdź, że zadziałało:
   ```bash
   git --version
   ```
   **Skąd wiesz, że możesz kontynuować:** wypisuje się prawdziwy numer
   wersji, nie błąd.

## Część 3 — Zainstaluj VS Code

1. Wejdź na [code.visualstudio.com](https://code.visualstudio.com/) w
   przeglądarce i pobierz pakiet `.deb` (Ubuntu/Debian) albo
   odpowiednik dla swojej dystrybucji.
2. **Ubuntu/Debian**, z terminala, w folderze, do którego go
   pobrałeś/aś (zwykle `~/Downloads`):
   ```bash
   cd ~/Downloads
   sudo apt install -y ./code_*.deb
   ```
   Dla innych dystrybucji użyj menedżera pakietów swojej dystrybucji z
   pobranym pakietem, albo podążaj za instrukcjami na stronie pobierania
   — nazywa ona dokładną komendę dla Twojego formatu pakietu (`.rpm`,
   AUR dla Archa, itd).
3. Uruchom VS Code: otwórz menu aplikacji, wyszukaj **Visual Studio
   Code**, kliknij go.

**Co powinieneś/aś zobaczyć:** otwiera się okno VS Code z zakładką
powitalną i pustym panelem Explorer po lewej (puste jest normalne — nie
otworzyłeś/aś jeszcze żadnego projektu).

## Część 4 — Otwórz terminal wewnątrz VS Code

1. W menu VS Code kliknij **Terminal → New Terminal**.
2. **Co powinieneś/aś zobaczyć:** panel terminala otwiera się na dole
   okna, z tym samym rodzajem promptu, który widziałeś/aś w Części 1 —
   terminal VS Code na Linuksie to domyślnie prawdziwy Bash, bez
   dodatkowej konfiguracji (w przeciwieństwie do Windowsa).
3. Potwierdź:
   ```bash
   pwd
   ```
   **Co powinieneś/aś zobaczyć:** ścieżka, prawdopodobnie kończąca się
   na Twoim folderze domowym (coś jak `/home/twojanazwa`).

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

1. W VS Code kliknij **File → Open Folder…**.
2. Przejdź do folderu, który sklonowałeś/aś — jeśli podążyłeś/aś za 6.3
   dokładnie, to `projects` → `software-engineering-in-practice`
   wewnątrz Twojego folderu domowego.
3. Kliknij **OK** (albo **Open**).
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

- [ ] `git --version` działa w terminalu.
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

### `git` albo `code` mówi "command not found"

Zamknij terminal i otwórz nowy (Część 1 albo Część 4) — nowo
zainstalowany program czasem nie pojawia się w terminalu, który był już
otwarty przed zakończeniem instalacji. Jeśli wciąż go nie ma, sprawdź,
czy komenda instalacyjna z Części 2 albo 3 faktycznie zakończyła się bez
błędu w połowie — przewiń terminal wyżej, żeby to sprawdzić.

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
problemów niespecyficznych dla Linuksa (problemy z logowaniem do
GitHuba, "repo już istnieje na dysku", VS Code otworzył niewłaściwy
folder, problemy z pierwszym push i więcej).
