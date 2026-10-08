# Konfiguracja Windows

[In English →](windows.md) · [← Wróć do Zacznij tutaj](../../START-HERE.pl.md)

Ta strona prowadzi Cię od zupełnie nowego laptopa z Windows 11 do
własnej kopii tego kursu, otwartej w VS Code, z działającym
terminalem Git Bash wewnątrz. Podążaj za nią od samego początku, po
kolei. Nie przeskakuj do przodu — kolejne kroki zakładają, że
wcześniejsze faktycznie zadziałały, i każdy mówi dokładnie, jak to
sprawdzić, zanim przejdziesz dalej.

Jeśli gdzieś utkniesz, nie zgaduj — przejdź do
[Jeśli utkniesz](#jeśli-utkniesz) na dole tej strony, albo do
wspólnego [`troubleshooting.pl.md`](troubleshooting.pl.md).

## Część 1 — Otwórz PowerShell jako administrator

Uprawnienia administratora potrzebujesz tylko na kroki *instalacyjne*
w Częściach 2–3. Nic innego w tym kursie ich nie wymaga.

1. Naciśnij klawisz **Windows** (albo kliknij przycisk Start, w lewym
   dolnym rogu ekranu).
2. Wpisz `powershell`. Windows pokaże **Windows PowerShell** jako
   wynik wyszukiwania.
3. Kliknij **prawym przyciskiem myszy** ten wynik wyszukiwania.
4. Kliknij **Uruchom jako administrator**.
5. Może pojawić się okno z pytaniem "Czy chcesz zezwolić tej aplikacji
   na wprowadzanie zmian na tym urządzeniu?". Kliknij **Tak**.

**Co powinieneś/aś zobaczyć:** okno terminala z niebieskim tłem, w
którego tytule jest **Administrator: Windows PowerShell**. Słowo
"Administrator" w tytule okna mówi Ci, że to sesja z podwyższonymi
uprawnieniami — zwykłe okno PowerShell tego nie ma.

**Jeśli widzisz coś innego:** jeśli w tytule okna nie ma słowa
"Administrator", otworzyłeś/aś zwykłe okno PowerShell przez pomyłkę —
zamknij je i powtórz kroki 1–4, pamiętając, żeby kliknąć prawym
przyciskiem i wybrać **Uruchom jako administrator**, a nie po prostu
nacisnąć Enter.

**Skąd wiesz, że możesz kontynuować:** tytuł okna mówi
**Administrator: Windows PowerShell**.

## Część 2 — Zainstaluj Chocolatey (menedżer pakietów dla Windows)

Chocolatey pozwala zainstalować Gita i VS Code jedną komendą każdy,
zamiast szukać instalatorów i klikać przez kreatory konfiguracji.

1. W **administratorskim** oknie PowerShell z Części 1, sprawdź, czy
   jest już zainstalowany:
   ```powershell
   choco --version
   ```
2. **Co powinieneś/aś zobaczyć:** numer wersji (coś jak `2.3.0`).
   Jeśli to widzisz, Chocolatey jest już zainstalowany — przejdź do
   Części 3.
3. **Jeśli widzisz** `choco: The term 'choco' is not recognized...`,
   Chocolatey jeszcze nie jest zainstalowany. Uruchom oficjalną
   komendę instalacyjną (to jest prawdziwa komenda ze strony
   [chocolatey.org/install](https://chocolatey.org/install) —
   wklej ją dokładnie tak, jak jest napisana):
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```
4. **Co powinieneś/aś zobaczyć:** kilka linii wyniku instalacji,
   kończących się czymś jak `Chocolatey (choco.exe) is now ready`.
5. Zamknij to okno PowerShell całkowicie i otwórz nowe
   **administratorskie** okno PowerShell (powtórz Część 1). Chocolatey
   staje się dostępny tylko w nowych oknach terminala, nie w tym, z
   którego go zainstalowano.
6. Potwierdź, że zadziałało:
   ```powershell
   choco --version
   ```
   **Skąd wiesz, że możesz kontynuować:** wypisuje się numer wersji,
   nie błąd.

**Jeśli nie masz uprawnień administratora na tym komputerze**
(częste na komputerach uczelnianych albo wspólnych): pomiń Chocolatey
całkowicie i przejdź do [Brak uprawnień administratora?](#brak-uprawnień-administratora)
poniżej, a potem wróć tutaj, gdy Git i VS Code będą już zainstalowane
inną metodą.

## Część 3 — Zainstaluj Git for Windows

Wciąż w **administratorskim** oknie PowerShell:

1. ```powershell
   choco install git -y
   ```
2. **Co powinieneś/aś zobaczyć:** wynik pobierania i instalacji,
   kończący się czymś jak `git v2.xx.x already installed` albo
   komunikatem sukcesu. Może to zająć minutę lub dwie.
3. Zamknij to okno PowerShell. Nie będziesz już potrzebować uprawnień
   administratora w resztce tego kursu.
4. Otwórz **zwykłe** (nieadministratorskie) okno PowerShell: naciśnij
   klawisz Windows, wpisz `powershell`, tym razem naciśnij **Enter**
   (bez prawego przycisku).
5. Potwierdź, że Git się zainstalował:
   ```powershell
   git --version
   ```
   **Co powinieneś/aś zobaczyć:** `git version 2.xx.x.windows.x`.

   **Jeśli widzisz** `git: The term 'git' is not recognized...`:
   zamknij *wszystkie* okna PowerShell i terminala, włącznie z VS
   Code, jeśli jest otwarty, i spróbuj jeszcze raz ze świeżo
   otworzonego okna. Instalacja nowego programu czasem nie działa w
   oknach, które były już otwarte wcześniej. Jeśli wciąż nie można go
   znaleźć, zobacz [Jeśli utkniesz](#jeśli-utkniesz).

**Skąd wiesz, że możesz kontynuować:** `git --version` wypisuje
prawdziwy numer wersji.

## Część 4 — Znajdź Git Bash

Instalacja Git for Windows instaluje też **Git Bash** — osobny program
terminalowy, który rozumie polecenia w stylu Unix (`ls`, `pwd`, `cat`
i podobne), w przeciwieństwie do PowerShell.

1. Naciśnij klawisz **Windows**.
2. Wpisz `git bash`.
3. Kliknij **Git Bash**, gdy się pojawi, żeby go otworzyć.

**Co powinieneś/aś zobaczyć:** okno terminala z czarnym albo ciemnym
tłem i promptem wyglądającym jak `ty@TWÓJKOMPUTER MINGW64 ~`. Właśnie
`MINGW64` mówi Ci, że to Git Bash, nie PowerShell ani stary Wiersz
polecenia.

Możesz zamknąć to okno na razie — do Git Bash wrócisz przez VS Code w
Części 6. Celem tego kroku było tylko potwierdzenie, że on tam
rzeczywiście jest.

### PowerShell kontra Git Bash kontra terminal VS Code — jaka jest różnica?

- **PowerShell** to własny terminal Windows. Użyłeś/aś go w Częściach
  1–3 tylko do *instalowania* rzeczy. Instrukcje tego kursu (`ls`,
  `cat`, `grep` i podobne) nie działają w nim tak samo — nie używaj go
  do labów.
- **Git Bash** to terminal w stylu Unix, który przychodzi z Git for
  Windows. To właśnie zakłada każda instrukcja tego kursu — gdy lab
  mówi "uruchom to w swoim terminalu", oznacza Git Bash.
- **Terminal VS Code** to po prostu panel terminala *wewnątrz* okna VS
  Code. Domyślnie na Windowsie otwiera PowerShell — Część 6 poniżej
  zmienia ten domyślny wybór na Git Bash, raz, żeby każdy terminal,
  który otworzysz wewnątrz VS Code od teraz, był już właściwy.

## Część 5 — Zainstaluj VS Code

1. Otwórz **zwykłe** okno PowerShell (klawisz Windows → wpisz
   `powershell` → Enter — administrator niepotrzebny tutaj).
2. ```powershell
   choco install vscode -y
   ```
3. **Co powinieneś/aś zobaczyć:** wynik instalacji kończący się
   komunikatem sukcesu.
4. Zamknij to okno PowerShell, potem otwórz VS Code: naciśnij klawisz
   Windows, wpisz `code`, kliknij **Visual Studio Code**.

**Co powinieneś/aś zobaczyć:** otwiera się okno VS Code, z zakładką
powitalną i pustym panelem Explorer po lewej (nic do pokazania jeszcze
— to normalne, nie otworzyłeś/aś jeszcze żadnego projektu).

## Część 6 — Ustaw Git Bash jako domyślny terminal w VS Code

Zrób to raz, teraz, żebyś nigdy więcej nie musiał/a o tym myśleć.

1. W VS Code otwórz menu **Terminal → New Terminal**.
2. **Co powinieneś/aś zobaczyć:** panel terminala otwiera się na dole
   okna. Na świeżej instalacji to zwykle PowerShell — to normalne,
   właśnie to zmienisz.
3. Kliknij małą **strzałkę rozwijania** przy ikonie `+` w prawym
   górnym rogu panelu terminala. Jeśli nie widzisz tam strzałki
   rozwijania, otwórz Command Palette (**View → Command Palette…**,
   albo `Ctrl+Shift+P`) i wpisz:
   ```text
   Terminal: Select Default Profile
   ```
4. Z listy, która się pojawi, kliknij **Git Bash**.
5. Zamknij panel terminala, który jest aktualnie otwarty (kliknij
   ikonę koszyka, albo kliknij w niego i naciśnij `Ctrl+D`).
6. Otwórz nowy: **Terminal → New Terminal** jeszcze raz.
7. **Co powinieneś/aś zobaczyć:** prompt wyglądający jak
   `ty@TWÓJKOMPUTER MINGW64 ~` — ten sam styl, który widziałeś/aś w
   Części 4, teraz wewnątrz VS Code.
8. Potwierdź, że to naprawdę Bash, nie PowerShell w przebraniu:
   ```bash
   echo "$BASH_VERSION"
   ```
   **Skąd wiesz, że możesz kontynuować:** wypisuje się prawdziwy numer
   wersji (coś jak `5.2.26(1)-release`). PowerShell wcale nie rozumie
   `$BASH_VERSION` i pokazałby nic albo błąd — jeśli to właśnie
   widzisz, zmiana domyślnego profilu z kroku 4 nie zadziałała; zobacz
   następną sekcję.

### Nie widzę Git Bash w VS Code

Jeśli **Git Bash** nigdy nie pojawił się na liście w kroku 4, albo
nowy terminal wciąż jest PowerShellem po przejściu kroków 1–7:

1. **Zrestartuj VS Code całkowicie** — zamknij każde okno, otwórz
   ponownie i spróbuj Część 6 od kroku 1. VS Code skanuje profile
   terminala takie jak Git Bash tylko przy starcie, więc może
   przegapić instalację, która zdarzyła się, gdy był już otwarty.
2. Jeśli wciąż go nie ma, wskaż VS Code na Git Bash ręcznie:
   - Otwórz Command Palette (`Ctrl+Shift+P`) i uruchom
     **Preferences: Open User Settings (JSON)**.
   - Dodaj to (scal z istniejącym `{ }` — zapytaj w
     [Jeśli utkniesz](#jeśli-utkniesz), jeśli nie jesteś pewien/pewna,
     jak scalić JSON, nie zgaduj):
     ```json
     "terminal.integrated.profiles.windows": {
       "Git Bash": {
         "path": "C:\\Program Files\\Git\\bin\\bash.exe"
       }
     },
     "terminal.integrated.defaultProfile.windows": "Git Bash"
     ```
   - Zapisz plik, potem powtórz kroki 5–8 powyżej.
   - Jeśli Gita nie ma w `C:\Program Files\Git`, najpierw znajdź,
     gdzie faktycznie jest: w oknie PowerShell uruchom
     `(Get-Command git).Source` — wypisuje prawdziwą ścieżkę, a
     `bash.exe` mieszka w tym samym folderze `Git\bin\`.

## Część 7 — Zrób fork, sklonuj i otwórz to repozytorium

To jest faktyczny cel całej tej strony. Od teraz każdy krok dzieje się
albo w przeglądarce, albo w terminalu Git Bash wewnątrz VS Code z
Części 6.

**Masz już fork albo lokalną kopię z wcześniejszej próby?** Nie
powtarzaj tych kroków na ślepo — przejdź najpierw do
[`already-have-a-fork.pl.md`](already-have-a-fork.pl.md).

### 7.1 — Zrób fork repozytorium na GitHubie

1. Upewnij się, że jesteś zalogowany/a na GitHubie — otwórz
   [github.com](https://github.com) w przeglądarce i sprawdź, czy
   prawy górny róg pokazuje Twój avatar konta, nie przycisk "Sign in".
   Jeśli nie masz jeszcze konta GitHub, najpierw je utwórz (jest
   darmowe), zanim przejdziesz dalej.
2. Przejdź do
   `https://github.com/michalmaj/software-engineering-in-practice`.
3. Kliknij przycisk **Fork**, w prawym górnym rogu strony.
4. Na stronie "Create a new fork" upewnij się, że **Owner** pokazuje
   *Twoje* konto, nie prowadzącego — ten dropdown domyślnie ustawia
   się na konto, na którym jesteś zalogowany/a, co powinno już być
   Tobą.
5. Kliknij **Create fork**.

**Co powinieneś/aś zobaczyć:** GitHub przenosi Cię na nową stronę,
której URL to
`https://github.com/<twój-username>/software-engineering-in-practice`
— Twój własny username, nie `michalmaj`, jest teraz w adresie
przeglądarki i w tytule strony, zaraz pod ikonką repozytorium, która
pokazuje, że powstało jako fork `michalmaj/software-engineering-in-practice`.

**Skąd wiesz, że możesz kontynuować:** URL w adresie przeglądarki
zawiera *Twój* username z GitHuba, nie `michalmaj`.

### 7.2 — Skopiuj adres klonowania swojego forka

1. Na stronie swojego forka (z poprzedniego kroku) kliknij zielony
   przycisk **Code**.
2. Upewnij się, że wybrana jest zakładka **HTTPS** (nie SSH, nie
   GitHub CLI — ten kurs nie wymaga konfigurowania kluczy SSH).
3. Kliknij małą ikonkę kopiowania przy adresie, żeby go skopiować.
   Wygląda jak:
   ```text
   https://github.com/<twój-username>/software-engineering-in-practice.git
   ```
   z Twoim rzeczywistym username zamiast `<twój-username>`.

### 7.3 — Sklonuj je na swój komputer

Z powrotem w terminalu Git Bash wewnątrz VS Code (Część 6):

1. Zdecyduj, gdzie powinny żyć Twoje projekty, i utwórz ten folder,
   jeśli jeszcze nie istnieje. Rozsądny, prosty wybór:
   ```bash
   mkdir -p ~/projects
   cd ~/projects
   ```
2. Sklonuj swój fork — wklej adres, który skopiowałeś/aś w 7.2.
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
   foldery włącznie z `labs`, `examples`, `scripts`, i pliki włącznie
   z `README.md` i `START-HERE.md`.
6. Potwierdź, że sam Git jest zadowolony, i że wskazuje na *Twój*
   fork, nie prowadzącego:
   ```bash
   git status
   git remote -v
   ```
   **Co powinieneś/aś zobaczyć:** `git status` mówi `On branch main`
   i `nothing to commit, working tree clean`. `git remote -v` pokazuje
   dwie linie (`origin` fetch i push), których adres zawiera **Twój
   własny username z GitHuba** — jeśli widzisz tam `michalmaj` zamiast
   swojego username, sklonowałeś/aś przez pomyłkę oryginalne
   repozytorium, nie swój fork; zobacz
   [Sklonowałem/am repozytorium prowadzącego zamiast własnego forka](#sklonowałemam-repozytorium-prowadzącego-zamiast-własnego-forka)
   poniżej.

**Skąd wiesz, że możesz kontynuować:** `git remote -v` pokazuje Twój
własny username, a `ls` pokazuje `labs/`, `examples/` i `scripts/`.

### 7.4 — Otwórz je w VS Code

1. W VS Code otwórz menu **File → Open Folder…**
2. Przejdź do folderu, który sklonowałeś/aś — jeśli podążyłeś/aś za
   7.3 dokładnie, to `projects` → `software-engineering-in-practice`
   wewnątrz Twojego folderu użytkownika Windows.
3. Kliknij **Select Folder**.
4. VS Code może zapytać "Do you trust the authors of the files in
   this folder?" — kliknij **Yes, I trust the authors**.

**Co powinieneś/aś zobaczyć:** panel Explorer po lewej wylistowuje
teraz `labs`, `examples`, `scripts`, `README.md` i więcej — to samo,
co `ls` pokazał Ci w 7.3.

5. Otwórz terminal wewnątrz tego okna (**Terminal → New Terminal**) —
   powinien już domyślnie być Git Bash, bo ustawiłeś/aś to w Części 6.
   Potwierdź, że jesteś we właściwym miejscu:
   ```bash
   pwd
   ```
   **Skąd wiesz, że możesz kontynuować:** ścieżka kończy się na
   `/software-engineering-in-practice`, a panel Explorer pokazuje
   folder `labs/`.

### 7.5 — Znajdź Lab 01

1. W panelu Explorer po lewej kliknij, żeby rozwinąć folder `labs`.
2. Znajdź i kliknij `01-workstation`, potem kliknij `README.pl.md`
   wewnątrz niego.

**Co powinieneś/aś zobaczyć:** otwiera się `Lab 01 — Witaj na swoim
stanowisku pracy` jako czytelny dokument w edytorze.

To wszystko — dotarłeś/aś do końca zadania tej strony. Przejdź do
[Zanim skończysz](#zanim-skończysz), żeby wszystko podwójnie
sprawdzić, a potem zacznij lab.

## Pierwszy push do GitHuba

Nie wypchniesz niczego do GitHuba aż do połowy Lab 03 albo Lab 04 —
klonowanie i czytanie nie wymagają zalogowania do samego Gita, tylko
Twojej sesji przeglądarki z 7.1. Gdy tam dotrzesz i `git push`
zapyta o autoryzację, zobacz
[`github-auth.pl.md`](github-auth.pl.md) — jest napisane właśnie na
ten moment, więc nie musisz tego czytać teraz.

## Zanim skończysz

Sprawdź każde z tych, zanim uznasz Lab 01 za gotowy do zaczęcia:

- [ ] `git --version` działa w zwykłym terminalu.
- [ ] Nowy terminal w VS Code domyślnie otwiera Git Bash
      (`echo "$BASH_VERSION"` wypisuje wersję).
- [ ] `pwd` wewnątrz terminala VS Code kończy się na
      `/software-engineering-in-practice`.
- [ ] `git status` działa bez błędu.
- [ ] `git remote -v` pokazuje **Twój własny** username z GitHuba.
- [ ] Panel Explorer pokazuje `labs/`, `examples/` i `scripts/`.
- [ ] `labs/01-workstation/README.pl.md` się otwiera.

Wszystko zaznaczone? Otwórz
[`labs/01-workstation/README.pl.md`](../../labs/01-workstation/README.pl.md)
i zaczynaj.

## Brak uprawnień administratora?

Jeśli Części 1–2 nie są możliwe na tym komputerze (częste na
komputerach uczelnianych), możesz wciąż zainstalować wszystko przez
oficjalne instalatory zamiast Chocolatey — nie wymagają tych samych
podwyższonych uprawnień, a niektóre pozwalają zainstalować do
własnego folderu użytkownika konkretnie:

- **Git for Windows**: pobierz instalator ze strony
  [git-scm.com/download/win](https://git-scm.com/download/win).
  Uruchom go; gdy kreator konfiguracji zapyta, gdzie zainstalować,
  zwykle możesz wskazać folder wewnątrz własnego profilu użytkownika
  zamiast `C:\Program Files`, jeśli nie masz tam prawa zapisu.
  Zachowaj każdą inną domyślną opcję bez zmian.
- **VS Code**: pobierz **User Installer** (nie "System Installer") ze
  strony [code.visualstudio.com](https://code.visualstudio.com/) —
  User Installer jest zaprojektowany specjalnie, żeby instalować do
  własnego folderu użytkownika bez potrzeby uprawnień administratora.

Gdy oba są zainstalowane w ten sposób, wznów od Części 4 powyżej —
wszystko od tego miejsca działa tak samo, niezależnie od tego, jak Git
i VS Code trafiły na Twój komputer.

Jeśli żaden instalator nie może się uruchomić na tym komputerze w
ogóle, nie potrzebujesz lokalnej konfiguracji — zobacz
[GitHub Codespaces](../../START-HERE.pl.md#github-codespaces-opcja-bez-instalacji)
w Zacznij tutaj.

## Jeśli utkniesz

### `choco`, `git` albo `code` mówi "not recognized"

Zamknij *każde* okno terminala i VS Code i otwórz świeże — nowo
zainstalowany program często nie pojawia się w oknach, które były już
otwarte przed zakończeniem instalacji. Jeśli wciąż go nie ma po tym,
sprawdź podwójnie, czy odpowiadająca Część powyżej faktycznie
zakończyła się bez błędu w połowie.

### Sklonowałem/am repozytorium prowadzącego zamiast własnego forka

Jeśli `git remote -v` pokazuje `michalmaj` zamiast Twojego username:
folder, który sklonowałeś/aś, wskazuje na repozytorium, do którego nie
masz prawa push, co zablokuje Cię później (Lab 03–04). Napraw to bez
utraty czegokolwiek:

```bash
cd ..
mv software-engineering-in-practice software-engineering-in-practice.instructor-copy
```

To zmienia nazwę źle sklonowanego folderu, odsuwając go z drogi,
zamiast go usuwać, potem powtórz 7.1–7.4 tym razem z adresem *swojego*
forka. Gdy Twoja prawdziwa kopia już działa, możesz usunąć
przemianowany folder, jeśli chcesz, albo po prostu go zostawić — nie
robi żadnej szkody, siedząc tam.

### Wszystko inne

Zobacz wspólne [`troubleshooting.pl.md`](troubleshooting.pl.md) dla
problemów niespecyficznych dla Windows (problemy z logowaniem do
GitHuba, "repo już istnieje na dysku", niewłaściwy folder otwarty w VS
Code, problemy z pierwszym push i więcej).
