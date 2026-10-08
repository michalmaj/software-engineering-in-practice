# Masz już fork albo lokalną kopię?

[In English →](already-have-a-fork.md) · [← Wróć do Zacznij tutaj](../../START-HERE.pl.md)

Jeśli już zrobiłeś/aś fork tego repozytorium, już je sklonowałeś/aś,
albo zaczynałeś/aś tę konfigurację kiedyś wcześniej i nie jesteś
pewien/pewna, w jakim stanie jesteś, ta strona pomaga Ci to bezpiecznie
ustalić. Nic tutaj niczego nie usuwa — jeśli krok wymagałby usunięcia
albo nadpisania Twojej pracy, mówi, żeby się zatrzymać i zapytać,
zamiast to robić.

## "Zrobiłem/am fork na GitHubie, ale nie wiem, czy go sklonowałem/am"

1. Otwórz [github.com](https://github.com) w przeglądarce, kliknij swój
   avatar (prawy górny róg), kliknij **Your repositories**.
2. Poszukaj `software-engineering-in-practice` na liście. Jeśli tam
   jest, już zrobiłeś/aś fork — nie rób go jeszcze raz.
3. Na swoim komputerze sprawdź, czy też już go sklonowałeś/aś: otwórz
   terminal i uruchom
   ```bash
   find ~ -maxdepth 4 -iname "software-engineering-in-practice" -type d 2>/dev/null
   ```
   Jeśli to wypisuje ścieżkę, masz już lokalną kopię — przejdź do "Mam
   już lokalną kopię" poniżej. Jeśli nic nie wypisuje, jeszcze nie
   sklonowałeś/aś — przejdź do kroku "Sklonuj swój fork" w przewodniku
   dla swojego systemu
   ([Windows](windows.pl.md#73--sklonuj-je-na-swój-komputer),
   [macOS](macos.pl.md#63--sklonuj-je-na-swój-komputer),
   [Linux](linux.pl.md#63--sklonuj-je-na-swój-komputer)).

## "Mam już lokalną kopię"

1. Otwórz terminal (albo ten wewnątrz VS Code) i przejdź do folderu,
   który wypisała komenda `find` powyżej, na przykład:
   ```bash
   cd ~/projects/software-engineering-in-practice
   ```
2. Sprawdź, czy to naprawdę repozytorium Git wskazujące na Twój własny
   fork:
   ```bash
   git remote -v
   ```
   **Jeśli to pokazuje Twój własny username z GitHuba:** dobrze, to
   jest Twoja działająca kopia — przejdź do "Otwieranie jej ponownie"
   poniżej.

   **Jeśli to pokazuje `michalmaj` zamiast Twojego username:** to jest
   klon oryginalnego repozytorium prowadzącego, nie Twój fork. Nie
   usuwaj go — zamiast tego zmień mu nazwę, odsuwając z drogi, potem
   sklonuj swój prawdziwy fork od nowa:
   ```bash
   cd ..
   mv software-engineering-in-practice software-engineering-in-practice.instructor-copy
   ```
   Potem podążaj za krokiem "Sklonuj swój fork" w przewodniku dla
   swojego systemu.

3. Sprawdź, czy masz niezapisane zmiany siedzące w tej kopii:
   ```bash
   git status
   ```
   - `nothing to commit, working tree clean` — nic niezapisanego,
     bezpiecznie kontynuować.
   - Jakikolwiek inny wynik (zmodyfikowane pliki, nieśledzone pliki) —
     **nie wyrzucaj ich**. Jeśli nie pamiętasz, że robiłeś/aś tę zmianę
     celowo, i nie jesteś pewien/pewna, czy ma znaczenie, to nic — zostaw
     ją taką, jaka jest, na razie i kontynuuj; możesz zapytać o to
     prowadzącego później. Nigdy nie uruchamiaj komendy, która wyrzuca
     zmiany (zobacz
     [Czego nigdy tutaj nie robić](#czego-nigdy-tutaj-nie-robić)
     poniżej), tylko po to, żeby ten komunikat zniknął.

## Otwieranie jej ponownie

1. Otwórz VS Code.
2. **File → Open Folder…**, przejdź do folderu z kroku powyżej.
3. Otwórz terminal wewnątrz VS Code (**Terminal → New Terminal**) i
   potwierdź:
   ```bash
   pwd
   git status
   ```
   **Skąd wiesz, że jesteś we właściwym miejscu:** `pwd` kończy się na
   `/software-engineering-in-practice`, a `git status` działa bez
   błędu.

## "Mój fork wygląda nieaktualny w porównaniu z repozytorium kursu"

To może się zdarzyć, jeśli prowadzący wypchnął aktualizacje od czasu,
gdy zrobiłeś/aś fork. Nie potrzebujesz tego, żeby zacząć Lab 01 — ma to
znaczenie tylko wtedy, gdy konkretny lab mówi Ci zsynchronizować. Gdy
jakiś lab o to prosi, użyj własnej, bezpiecznej funkcji synchronizacji
GitHuba, zamiast jakiejkolwiek ręcznej operacji Gita:

1. Na stronie swojego forka na GitHubie poszukaj przycisku **Sync
   fork** (GitHub pokazuje go automatycznie, gdy Twój fork jest w
   tyle).
2. Kliknij go, potem **Update branch**.
3. Z powrotem w terminalu zaktualizuj swoją lokalną kopię, żeby się
   zgadzała:
   ```bash
   git pull
   ```

Jeśli `git pull` zgłasza konflikt, zatrzymaj się i zapytaj
prowadzącego, zamiast zgadywać — nie rozwiązuj go żadną z komend
wymienionych poniżej.

## Czego nigdy tutaj nie robić

Żadna z tych komend nie powinna być uruchamiana jako część
"naprawiania" problemu konfiguracyjnego w tym kursie, ponieważ każda z
nich może permanentnie zniszczyć pracę, której nie wypchnąłeś/aś
jeszcze nigdzie indziej:

- `git reset --hard`
- `git clean -fd` (albo `-fdx`)
- `rm -rf` na folderze Twojego repozytorium
- `git push --force` / `git push -f`

Jeśli sytuacja wydaje się wymagać jednej z nich, to nie — zatrzymaj się
i zapytaj prowadzącego, opisując, co widzisz (zobacz wspólne
[`troubleshooting.pl.md`](troubleshooting.pl.md), jak zgłosić problem).

## Wciąż nie jesteś pewien/pewna, w jakim stanie jesteś?

Zobacz wspólne [`troubleshooting.pl.md`](troubleshooting.pl.md), albo
wróć do [Zacznij tutaj](../../START-HERE.pl.md) i podążaj za
przewodnikiem dla swojego systemu od samego początku — ponowne
przeczytanie go kosztuje Cię kilka minut; zgadywanie naprawy ryzykuje
Twoją pracę.
