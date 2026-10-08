# Rozwiązywanie problemów

[In English →](troubleshooting.md) · [← Wróć do Zacznij tutaj](../../START-HERE.pl.md)

Ta strona zbiera problemy, które mogą się zdarzyć w dowolnym momencie
konfiguracji, nie tylko na jednym systemie operacyjnym. Znajdź
nagłówek, który odpowiada temu, co widzisz.

## Nie mam uprawnień administratora na tym komputerze

Zobacz sekcję
[Brak uprawnień administratora?](windows.pl.md#brak-uprawnień-administratora)
w przewodniku dla Windows — opisuje instalację Gita i VS Code bez
uprawnień administratora. Jeśli nawet to jest zablokowane na tym
komputerze, użyj
[GitHub Codespaces](../../START-HERE.pl.md#github-codespaces-opcja-bez-instalacji)
zamiast tego — nie wymaga żadnej lokalnej instalacji.

## `choco`, `git`, `code` albo `brew` mówi "not recognized" / "command not found"

Zamknij każde okno terminala (i VS Code, jeśli jest otwarty) i otwórz
nowe. Program, który właśnie skończył się instalować, często nie
pojawia się w oknie, które było już otwarte wcześniej. Jeśli wciąż go
nie ma po tym, wróć do kroku instalacji w przewodniku dla swojego
systemu i sprawdź, czy faktycznie się zakończył — przewiń ten terminal
wyżej, żeby poszukać błędu w połowie.

## Git Bash nie jest widoczny w terminalu VS Code (Windows)

Zobacz dedykowaną sekcję
[Nie widzę Git Bash w VS Code](windows.pl.md#nie-widzę-git-bash-w-vs-code)
w przewodniku dla Windows — opisuje restart VS Code i ręczne wskazanie
mu Git Bash.

## Mam problem z zalogowaniem się do GitHuba

- Sprawdź podwójnie, czy używasz e-maila albo username (bez literówki)
  przypisanego do Twojego konta GitHub.
- Jeśli uwierzytelnianie dwuetapowe prosi o kod, a nie masz przy sobie
  telefonu, strona logowania GitHuba ma link zapasowy "Use a recovery
  code" albo podobny — użyj kodów odzyskiwania, które otrzymałeś/aś przy
  konfigurowaniu 2FA.
- Jeśli naprawdę nigdy nie miałeś/aś konta GitHub, przejdź do
  [github.com/join](https://github.com/join) i utwórz jedno — jest
  darmowe.

## GitHub mówi, że już mam fork tego repozytorium

To w porządku — nie musisz go robić jeszcze raz. Przejdź do
[`already-have-a-fork.pl.md`](already-have-a-fork.pl.md) i podążaj za
"Zrobiłem/am fork na GitHubie, ale nie wiem, czy go sklonowałem/am."

## Sklonowałem/am repozytorium prowadzącego zamiast własnego forka

Zobacz sekcję "Sklonowałem/am repozytorium prowadzącego zamiast
własnego forka" w przewodniku dla swojego systemu
([Windows](windows.pl.md#sklonowałemam-repozytorium-prowadzącego-zamiast-własnego-forka),
[macOS](macos.pl.md#sklonowałemam-repozytorium-prowadzącego-zamiast-własnego-forka),
[Linux](linux.pl.md#sklonowałemam-repozytorium-prowadzącego-zamiast-własnego-forka))
— pokazuje bezpieczną, nie-destrukcyjną naprawę.

## Repozytorium jest już gdzieś na moim dysku — nie chcę go klonować jeszcze raz

Przejdź do [`already-have-a-fork.pl.md`](already-have-a-fork.pl.md) i
podążaj za "Mam już lokalną kopię" — pokazuje, jak ją znaleźć i
sprawdzić, czy jest w bezpiecznym stanie, bez ponownego klonowania.

## Nie wiem, w jakim folderze jestem

Uruchom:
```bash
pwd
```
To zawsze mówi Ci dokładnie, gdzie jesteś. Jeśli to nie jest to, czego
się spodziewasz, `cd ~` zabiera Cię z powrotem do folderu domowego, i
możesz nawigować od tego miejsca.

## VS Code otworzył niewłaściwy folder

Jeszcze raz **File → Open Folder…**, i tym razem przejdź starannie do
folderu swojego sklonowanego repozytorium (ten, który `pwd` pokazuje po
wejściu w niego w terminalu). Folder, który chcesz, zawiera `labs`,
`examples` i `scripts` jako podfoldery — jeśli panel Explorer nie
pokazuje tych trzech po otwarciu, otworzyłeś/aś niewłaściwy poziom
(zbyt wysoko, jak cały Twój folder `projects`, albo zbyt niskо, jak
wewnątrz samego `labs`).

## "command not found" dla czegoś innego niż git/code/choco/brew

Sprawdź, czy jesteś w terminalu, który skonfigurował przewodnik dla
Twojego systemu (Git Bash na Windowsie, domyślny terminal na
macOS/Linuksie) — komenda, która istnieje w jednej powłoce, może nie
istnieć w innej. Jeśli nie jesteś pewien/pewna, w którym terminalu
jesteś, zamknij go i otwórz nowy dokładnymi krokami z przewodnika dla
swojego systemu.

## `labs/`, `examples/` albo `scripts/` brakuje w projekcie

To praktycznie zawsze znaczy, że VS Code (albo Twój terminal) jest
otwarty na niewłaściwym folderze, albo klonowanie się nie zakończyło.
Uruchom:
```bash
pwd
ls
```
Jeśli `ls` nie pokazuje `labs`, `examples` i `scripts`, jesteś w
niewłaściwym miejscu — `cd` do właściwego folderu repozytorium, albo
otwórz je ponownie w VS Code przez **File → Open Folder…**.

## Mój pierwszy `git push` nie działa

Zobacz [`github-auth.pl.md`](github-auth.pl.md) — jest napisane
specjalnie na problemy z autoryzacją pierwszego push, włącznie z tym,
co zrobić, jeśli żadne okno przeglądarki się nie pojawia.

## Git Bash mówi coś o końcach linii, albo skrypt `.sh` nie chce się uruchomić (Windows)

Jeśli skrypt zawodzi z czymś jak `$'\r': command not found` albo
podobnym, plik prawdopodobnie ma końce linii w stylu Windows. Własne
skrypty tego kursu są już zacommitowane z właściwymi końcami linii, więc
to mało prawdopodobne, żeby dotyczyło czegokolwiek w `labs/`,
`examples/` czy `scripts/` tak, jak zostały sklonowane — jeśli widzisz
to na pliku, którego nie stworzyłeś/aś albo nie edytowałeś/aś sam/a,
zgłoś to, zamiast próbować naprawić plik (zobacz poniżej). Jeśli to
plik, który sam/a stworzyłeś/aś w edytorze tekstu innym niż VS Code,
otwórz go i zapisz ponownie z VS Code — domyślnie używa właściwych
końców linii dla tego repozytorium.

## Jeśli wciąż utkniesz

Zgłoś problem prowadzącemu z tymi pięcioma informacjami:

1. Twój system operacyjny (Windows 11, macOS, albo która dystrybucja
   Linuksa).
2. Na którym numerze kroku albo sekcji byłeś/aś.
3. Dokładna komenda, którą uruchomiłeś/aś.
4. Dokładny komunikat błędu, który zobaczyłeś/aś (skopiuj tekst, albo
   zrzut ekranu).
5. Co oczekiwałeś/aś, że się stanie zamiast tego.

**Nigdy nie dołączaj hasła, personal access tokenu, czy innego sekretu
do tego zgłoszenia** — ani w tekście, ani na zrzucie ekranu. Jeśli
zrzut ekranu by go pokazał, przytnij go albo zamaskuj najpierw.
