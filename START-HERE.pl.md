# Zacznij tutaj

[Start here (in English) →](START-HERE.md)

Ta strona prowadzi Cię od "nigdy nie używałem/am terminala" do "mam
własną kopię tego kursu na swoim komputerze, otwartą w VS Code, gotową
na Lab 01". Nie wyjaśnia jeszcze, czym jest ten kurs — to jest w
głównym [`README.pl.md`](README.pl.md). Ta strona dotyczy wyłącznie
części komputerowej.

## Co będziesz mieć/a na końcu

- Własny **fork** tego kursu na GitHubie (własną kopię, na własnym
  koncie).
- **Klon** tego forka na swoim komputerze (lokalną kopię, którą możesz
  edytować).
- Tę kopię otwartą w **VS Code**, z działającym terminalem wewnątrz.
- Jasność, co zrobić, jeśli coś nie zgadza się z tym, co mówi ta
  strona.

**Nie** zainstalujesz jeszcze Pythona, Go ani Javy. Te przychodzą
później, gdy już wybierzesz swój track językowy — ta strona dotyczy
wyłącznie tego, żeby samo repozytorium trafiło na Twój komputer.

## Wybierz swój system

| Twój komputer | Przewodnik |
|---|---|
| Windows 11 | [`docs/setup/windows.pl.md`](docs/setup/windows.pl.md) |
| macOS | [`docs/setup/macos.pl.md`](docs/setup/macos.pl.md) |
| Linux | [`docs/setup/linux.pl.md`](docs/setup/linux.pl.md) |

Każdy przewodnik to jedna, kompletna ścieżka: otwórz terminal,
zainstaluj Git i VS Code, jeśli ich nie masz, zrób fork i sklonuj to
repozytorium, i otwórz je w VS Code. Podążaj za tym dla swojego
systemu od samego początku — nie musisz czytać dwóch pozostałych.

Woli(sz) nie instalować niczego na własnym komputerze? Zobacz
[GitHub Codespaces](#github-codespaces-opcja-bez-instalacji) poniżej
— to wciąż wspierana ścieżka, tylko już nie domyślna.

## Jesteś już w trakcie?

Nie musisz zaczynać od nowa.

- **"Już zrobiłem/am fork tego repozytorium na GitHubie, ale jeszcze
  nie sklonowałem/am go."** Przejdź do kroku "Sklonuj swój fork" w
  przewodniku dla swojego systemu powyżej.
- **"Mam już lokalną kopię tego repozytorium na swoim komputerze."**
  Przejdź prosto do
  [`docs/setup/already-have-a-fork.pl.md`](docs/setup/already-have-a-fork.pl.md) —
  mówi, jak ją znaleźć, otworzyć i sprawdzić, czy jest w bezpiecznym
  stanie, bez odtwarzania czegokolwiek od nowa.
- **"Coś pójło nie tak i nie jestem pewien/pewna, w jakim stanie
  jestem."** Zobacz
  [`docs/setup/troubleshooting.pl.md`](docs/setup/troubleshooting.pl.md).

## Kiedy jesteś gotów/gotowa na Lab 01

Jesteś gotowy/a, gdy każde z poniższych jest prawdą:

- [ ] Mam własny fork na GitHubie.
- [ ] Mam jego kopię na swoim komputerze.
- [ ] Wiem, gdzie na dysku ta kopia mieszka.
- [ ] VS Code otwiera ten projekt.
- [ ] Terminal działa wewnątrz VS Code.
- [ ] Na Windowsie ten terminal to Git Bash.
- [ ] `git status` działa i nie pokazuje błędu.
- [ ] `git remote -v` pokazuje **mój własny** username na GitHubie, nie
  prowadzącego.
- [ ] Wiem, gdzie znaleźć instrukcje Lab 01.
- [ ] Wiem, co zrobić, jeśli później utknę.

To jest rzeczywista definicja "gotowości do Lab 01" w tym kursie. Jeśli
wszystkie dziesięć są prawdą, otwórz
[`labs/01-workstation/README.pl.md`](labs/01-workstation/README.pl.md)
i zaczynaj.

## GitHub Codespaces (opcja bez instalacji)

Codespaces uruchamia ten kurs w środowisku w przeglądarce, zamiast na
Twoim własnym komputerze — nic do instalowania lokalnie, ale wymaga
stabilnego internetu na każdą sesję, a darmowy limit GitHuba ma
miesięczne ograniczenia.

1. Zrób fork tego repozytorium (przycisk **Fork**, w prawym górnym
   rogu strony GitHub), tak samo jak w ścieżce lokalnej.
2. Na **swoim forku** otwórz **Code → Codespaces → Create codespace on
   main**.
3. Otwórz zintegrowany terminal (**Terminal → New Terminal**).
4. Otwórz
   [`labs/01-workstation/README.pl.md`](labs/01-workstation/README.pl.md)
   i zaczynaj.

Terminal w Codespace jest już Bashem, więc punkt checklisty "na
Windowsie ten terminal to Git Bash" powyżej nie ma zastosowania — każdy
prompt Bash go spełnia.
