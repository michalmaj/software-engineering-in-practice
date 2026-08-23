# Software Engineering in Practice

Praktyczny kurs laboratoryjny z inżynierii oprogramowania, opowiedziany jako
jedna ciągła historia, a nie lista niepowiązanych tematów.

## Dla kogo jest ten kurs

Dla studentów kursu laboratoryjnego z Inżynierii Oprogramowania. Nie zakładamy
wcześniejszego doświadczenia zawodowego w programowaniu. Powinieneś/powinnaś
swobodnie pisać podstawowy kod w Pythonie.

## Idea stojąca za kursem

> Programowanie polega na tym, żeby program działał.
> Inżynieria oprogramowania polega na tym, żeby oprogramowanie dało się
> bezpiecznie zmieniać, rozumieć, przeglądać, odtwarzać, obsługiwać i
> przekazywać innym ludziom.

Każde laboratorium istnieje dlatego, że poprzedni stan projektu stworzył
problem wart rozwiązania. Najpierw spotkasz problem, dopiero potem jego nazwę.

## Jak zorganizowany jest kurs

30 spotkań laboratoryjnych po 90 minut, pogrupowanych w sześć aktów:

| Akt | Laby  | Temat                                      |
|-----|-------|---------------------------------------------|
| I   | 01-05 | Jestem developerem                          |
| II  | 06-10 | Kod to jeszcze nie projekt                  |
| III | 11-15 | Oprogramowanie musi przetrwać zmianę        |
| IV  | 16-20 | Nie pracujesz sam/sama                      |
| V   | 21-25 | System żyje w większym świecie              |
| VI  | 26-30 | Jesteście zespołem inżynierskim             |

Python jest wspólnym językiem przez większość kursu. Go i Java pojawiają się
od Laboratorium 14 przy okazji jawnych porównań między-językowych, a w Akcie
VI stają się wyborem implementacyjnym dla Twojego zespołu.

## Od czego zacząć

Otwórz [`labs/01-workstation/README.pl.md`](labs/01-workstation/README.pl.md)
(albo [`README.md`](labs/01-workstation/README.md) po angielsku) i przechodź
przez laboratoria w kolejności numerycznej. Każde laboratorium kończy się
sekcją "Co dalej", która mówi, dokąd pójść.

## Zdobycie środowiska: GitHub Codespaces (zalecane)

1. Potrzebujesz konta na GitHubie.
2. Otwórz to repozytorium na GitHubie i kliknij **Fork** (prawy górny
   róg). To tworzy Twoją własną kopię — potrzebujesz własnego forka,
   bo kolejne laby każą Ci commitować i pushować, a nie masz uprawnień
   do zapisu w oryginalnym repozytorium kursowym.
3. Na **swoim forku** kliknij **Code → Codespaces → Create codespace on
   main**. (Utworzenie Codespace'a na oryginalnym repozytorium kursu
   zamiast na swoim forku to najczęstszy błąd na starcie — sprawdź
   dwa razy nazwę repozytorium w adresie URL, zanim przejdziesz dalej.)
4. Poczekaj, aż codespace się zainicjalizuje (za pierwszym razem może to
   potrwać kilka minut).
5. Otwórz zintegrowany terminal: **Terminal → New Terminal**.
6. Zweryfikuj swój toolchain (patrz niżej).
7. Repozytorium jest już wypięte w `/workspaces/<nazwa-repo>` wewnątrz
   codespace'a, z `origin` już wskazującym na Twój fork.
8. Kończąc pracę, zatrzymaj codespace z poziomu **github.com/codespaces**
   (albo pozwól mu się automatycznie uśpić) — to nie usuwa Twojej pracy.
9. Codespaces ma miesięczne limity użycia. Zatrzymuj codespace'y, z których
   aktualnie nie korzystasz; usuwaj te, których już nie potrzebujesz.
10. Żeby później pobrać aktualizacje kursu, dodaj oryginalne
    repozytorium jako drugi remote: `git remote add upstream <adres-oryginalnego-repo>`,
    potem `git fetch upstream` i `git merge upstream/main`, gdy będzie
    potrzeba.

## Zdobycie środowiska: lokalna maszyna uniksopodobna (wspierany fallback)

Działa na Linuksie i macOS. Wymaga tylko Gita — bez uprawnień administratora,
bez Docker Desktop, bez WSL.

1. Zrób fork tego repozytorium na GitHubie (ten sam powód co wyżej:
   potrzebujesz uprawnień do zapisu do kolejnych labów).
2. Sklonuj **swój fork**, nie oryginalne repozytorium:
   ```bash
   git clone <adres-Twojego-forka>
   cd software-engineering-in-practice
   ```
3. Dodaj oryginalne repozytorium jako drugi remote, żeby móc później
   pobierać aktualizacje kursu:
   ```bash
   git remote add upstream <adres-oryginalnego-repozytorium>
   ```

Poszczególne laboratoria powiedzą Ci, które dodatkowe narzędzie (np. `uv`)
zainstalować i jak, dokładnie wtedy, gdy będzie potrzebne. Patrz
"Weryfikacja toolchainu" niżej, co dokładnie i kiedy jest potrzebne
każdemu labowi.

## Weryfikacja toolchainu

Gdy Twoje środowisko już działa (Codespaces albo lokalnie), sprawdź, co jest
dostępne:

```bash
git --version
python3 --version
go version
java -version
```

Laboratorium 01 prowadzi Cię przez czytanie i interpretowanie takiego wyniku,
jeśli coś z tego jest dla Ciebie nieznane.

Nie każdy lab potrzebuje każdego narzędzia. Oto, kiedy faktycznie ma
znaczenie każde z nich:

| Narzędzie | Pierwszy raz potrzebne w | Instalacja, jeśli brakuje |
|-----------|--------------------------|----------------------------|
| Git | Lab 01 | Już jest w Codespaces; na macOS/Linuksie zwykle preinstalowany albo przez menedżera pakietów |
| Python 3.13 | Lab 01 | Codespaces go ma; lokalnie użyj Pythona z systemu albo [pyenv](https://github.com/pyenv/pyenv), jeśli potrzebujesz konkretnej wersji |
| `uv` | Lab 05 | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Go 1.25 | Lab 14 | Codespaces go ma; lokalnie zobacz [go.dev/doc/install](https://go.dev/doc/install) |
| JDK 21 | Lab 14 | Codespaces go ma; lokalnie zobacz menedżer pakietów swojego systemu (np. `brew install openjdk@21`) |

Uruchom `scripts/check-environment.sh` w dowolnym momencie, żeby
zobaczyć, które z nich faktycznie ma Twoje bieżące środowisko.

## Język tego repozytorium

To repozytorium jest dwujęzyczne. Każde laboratorium ma dwie wersje:

```text
labs/0N-temat/README.md      # angielski
labs/0N-temat/README.pl.md   # polski
```

Obie wersje są pedagogicznie równoważne — wybierz tę, która czyta Ci się
wygodniej. Kod, polecenia, nazwy plików i identyfikatory zawsze są po
angielsku, niezależnie od wybranego README.

## Praca nad laboratoriami

- Przechodź laboratoria w kolejności — każde zakłada, że poprzednie jest
  zrobione.
- Wykonaj zadanie opisane w laboratorium, a nie tylko przeczytaj je.
- Użyj sekcji "Weryfikacja" w laboratorium, żeby potwierdzić, że faktycznie
  skończyłeś/aś, zanim pójdziesz dalej.
- Jeśli utkniesz, skorzystaj ze stopniowanych podpowiedzi, zanim poprosisz
  o gotowe rozwiązanie.

## Co dalej

Zacznij od [`labs/01-workstation/README.pl.md`](labs/01-workstation/README.pl.md).
