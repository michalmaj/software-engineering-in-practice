# Software Engineering in Practice

[Read this in English →](README.md)

[![Course Health](https://github.com/michalmaj/software-engineering-in-practice/actions/workflows/course-health.yml/badge.svg)](https://github.com/michalmaj/software-engineering-in-practice/actions/workflows/course-health.yml)
[![Python 3.13](https://img.shields.io/badge/Python-3.13-blue)](https://www.python.org/)
[![Go 1.25](https://img.shields.io/badge/Go-1.25-00ADD8)](https://go.dev/)
[![Java 21](https://img.shields.io/badge/Java-21-ED8B00)](https://adoptium.net/)
[![30 Labs](https://img.shields.io/badge/30%20Labs-orange)](#mapa-kursu)
[![Bilingual EN | PL](https://img.shields.io/badge/EN%20%7C%20PL-9cf)](README.md)
[![License: MIT](https://img.shields.io/badge/code-MIT-yellow)](LICENSE)
[![License: CC BY 4.0](https://img.shields.io/badge/content-CC%20BY%204.0-lightgrey)](LICENSE-CONTENT.md)
[![Codespaces — ready](https://img.shields.io/badge/Codespaces%20%E2%80%94%20ready-success)](#github-codespaces)

> Od terminala do zespołu — ucz się budować oprogramowanie, które przetrwa zmianę.

## Czym jest ten kurs

30 spotkań laboratoryjnych po 90 minut: praktyczny kurs laboratoryjny z
inżynierii oprogramowania, opowiedziany jako jedna ciągła, progresywna
historia, a nie katalog technologii. Jest pomyślany dla studentów kursu
laboratoryjnego z Inżynierii Oprogramowania — nie zakłada wcześniejszego
doświadczenia zawodowego w programowaniu, tylko podstawową znajomość
Pythona.

## Główna idea

> Programowanie polega na tym, żeby program działał. Inżynieria
> oprogramowania polega na tym, żeby oprogramowanie dało się bezpiecznie
> zmieniać, rozumieć, przeglądać, odtwarzać, obsługiwać i przekazywać
> dalej.

Każde laboratorium istnieje dlatego, że poprzedni stan projektu stworzył
problem wart rozwiązania. Najpierw spotkasz problem, dopiero potem jego
nazwę.

## Podróż przez kurs

```text
stanowisko pracy → terminal → Git → projekt → testy → projektowanie →
współpraca → CI → API / dane / awarie → wydanie →
projekt zespołowy → przekazanie
```

| Akt | Laby  | Temat                                      |
|-----|-------|---------------------------------------------|
| I   | 01-05 | Jestem developerem                          |
| II  | 06-10 | Kod to jeszcze nie projekt                  |
| III | 11-15 | Oprogramowanie musi przetrwać zmianę        |
| IV  | 16-20 | Nie pracujesz sam/sama                      |
| V   | 21-25 | System żyje w większym świecie              |
| VI  | 26-30 | Jesteście zespołem inżynierskim             |

## Zacznij tutaj

Preferowana ścieżka to: **fork → Codespace → terminal → Lab 01.** Ten
kurs nie zakłada GitHub Classroom — wystarczy zwykłe konto na GitHubie.

1. Zrób fork tego repozytorium (przycisk **Fork** w prawym górnym rogu
   strony GitHub).
2. Na **swoim forku** otwórz **Code → Codespaces → Create codespace on
   main**.
3. Otwórz zintegrowany terminal (**Terminal → New Terminal**).
4. Otwórz
   [`labs/01-workstation/README.pl.md`](labs/01-workstation/README.pl.md)
   i zaczynaj.

## GitHub Codespaces

Codespaces to zalecany sposób przechodzenia tego kursu: każdy dostaje to
samo środowisko, bez niczego do instalowania na własnej maszynie na
starcie.

- **Dlaczego z tego korzystamy:** brak lokalnego setupu, brak "u mnie
  działa" jeszcze przed Labem 1, i działa z dowolnej maszyny, która
  potrafi uruchomić przeglądarkę.
- **Środowisko jest oparte na Linuksie** (Ubuntu), niezależnie od tego,
  co masz na własnym laptopie. Każde polecenie i ścieżka w tym kursie
  zakłada powłokę uniksopodobną.
- **Utwórz go na swoim forku**, nie na oryginalnym repozytorium kursu —
  potrzebujesz uprawnień do zapisu do kolejnych labów, które każą Ci
  commitować i pushować. Utworzenie Codespace'a na oryginalnym
  repozytorium zamiast na swoim forku to najczęstszy błąd na starcie —
  sprawdź dwa razy nazwę repozytorium w adresie URL, zanim przejdziesz
  dalej.
- **Otwórz terminal** przez **Terminal → New Terminal**, gdy Codespace
  skończy się inicjalizować.
- **Zweryfikuj swój toolchain**, uruchamiając
  `./scripts/check-environment.sh` — sprawdza wersje, których ten kurs
  faktycznie potrzebuje, i mówi dokładnie, czego brakuje albo co się nie
  zgadza.
- **Zatrzymuj Codespace'y, z których nie korzystasz** z poziomu
  [github.com/codespaces](https://github.com/codespaces) (albo pozwól
  im się automatycznie uśpić). Codespaces ma miesięczne limity użycia;
  zatrzymanie nie usuwa Twojej pracy.

## Lokalne środowisko uniksopodobne

Linux i macOS to wspierany fallback. Samo zdobycie repozytorium wymaga
tylko Gita i forka — bez Docker Desktop, bez WSL. Same laby jednak
potrzebują prawdziwego toolchainu, i nie będziemy udawać inaczej:

```bash
git clone <your-fork-url>
cd software-engineering-in-practice
./scripts/check-environment.sh
```

| Narzędzie | Wymagana wersja      |
|-----------|------------------------|
| Python    | 3.13.x                 |
| `uv`      | dokładnie 0.11.21      |
| Go        | 1.25.x                 |
| JDK       | 21                     |

Gradle **nie** jest wymaganiem globalnym: starter Java na kapstone ma
już własny, committed Gradle Wrapper (`./gradlew`), więc lokalnie
potrzebujesz tylko JDK.

## Języki i narzędzia

| Ekosystem | Toolchain                | Testy                       |
|-----------|----------------------------|-------------------------------|
| Python    | `uv`                       | `pytest`                      |
| Go        | standardowe narzędzia Go    | `go test`                     |
| Java      | JDK 21 + Gradle Wrapper     | JUnit, przez `./gradlew test` |

Python niesie większość kursu; Go i Java pojawiają się od Lab 14 przy
okazji jawnych porównań między-językowych. We wszystkich trzech język
jest medium — przedmiotem jest inżynieria oprogramowania.

## Jak działają laby

Każdy lab ma tę samą strukturę: **Sytuacja → Cele nauki → Zanim
zaczniesz → Twoje zadanie → Kryteria akceptacji → Weryfikacja →
Zastanów się → Jeśli utkniesz → Co dalej.** Ta spójność jest celowa —
te materiały są zaprojektowane do samodzielnej pracy, czy to solo, czy
jako część zajęć w klasie.

## Mapa kursu

| Lab | Tytuł | Lab | Tytuł |
|-----|-------|-----|-------|
| [01](labs/01-workstation/README.pl.md) | Witaj na swoim stanowisku pracy | [16](labs/16-parallel-branches/README.pl.md) | Gałęzie istnieją, bo praca dzieje się równolegle |
| [02](labs/02-terminal/README.pl.md) | Terminal jako narzędzie pracy | [17](labs/17-merge-conflict/README.pl.md) | Konflikt scalania |
| [03](labs/03-inherited-repository/README.pl.md) | Odziedziczyłeś/aś repozytorium | [18](labs/18-pull-requests-and-review/README.pl.md) | Pull requesty i code review |
| [04](labs/04-local-vs-remote/README.pl.md) | Lokalne to nie zdalne | [19](labs/19-repository-checks-itself/README.pl.md) | Repozytorium powinno sprawdzać się samo |
| [05](labs/05-works-on-my-machine/README.pl.md) | "Działa na moim komputerze" | [20](labs/20-definition-of-done/README.pl.md) | Co oznacza "zrobione"? |
| [06](labs/06-from-script-to-project/README.pl.md) | Od skryptu do projektu | [21](labs/21-api-is-a-contract/README.pl.md) | API to kontrakt |
| [07](labs/07-automated-tests/README.pl.md) | Skąd wiemy, że to działa? | [22](labs/22-data-outlives-code/README.pl.md) | Kod się zmienił, stare dane zostały |
| [08](labs/08-bug-report/README.pl.md) | Nadchodzi zgłoszenie błędu | [23](labs/23-outside-world-fails/README.pl.md) | Świat zewnętrzny zawodzi |
| [09](labs/09-automated-checks/README.pl.md) | Maszyny mogą sprawdzać nudne rzeczy | [24](labs/24-production-says-it-doesnt-work/README.pl.md) | Produkcja mówi "to nie działa" |
| [10](labs/10-one-way-to-check/README.pl.md) | Jeden oczywisty sposób sprawdzania projektu | [25](labs/25-release-and-compatibility/README.pl.md) | Wydanie i kompatybilność |
| [11](labs/11-changed-requirements/README.pl.md) | Klient zmienił zdanie | [26](labs/26-project-kickoff/README.pl.md) | Kickoff projektu |
| [12](labs/12-change-surface/README.pl.md) | Gdzie powinna trafić ta zmiana? | [27](labs/27-development-iteration/README.pl.md) | Iteracja rozwojowa |
| [13](labs/13-refactoring-safety-net/README.pl.md) | Refaktoryzacja z siatką bezpieczeństwa | [28](labs/28-change-request/README.pl.md) | Zmiana wymagań |
| [14](labs/14-one-contract-three-languages/README.pl.md) | Jeden kontrakt, trzy języki | [29](labs/29-production-incident/README.pl.md) | Incydent produkcyjny |
| [15](labs/15-patterns-without-worship/README.pl.md) | Wzorce bez kultu wzorców | [30](labs/30-handover/README.pl.md) | Handover |

## Zdrowie repozytorium

Uruchom `./scripts/check-course.sh`, żeby uruchomić te same sprawdzenia,
które własne CI tego repozytorium uruchamia przy każdym pushu i pull
requeście: strukturę repozytorium, parytet EN/PL oraz testy, składnię i
lockfile'y każdego przykładowego projektu. To repozytorium trzyma się
tych samych praktyk, których
uczy.

## Współpraca / zgłaszanie problemów

Znalazłeś/aś błąd, niejasną instrukcję albo coś, co nie działa w Twoim
środowisku? Otwórz issue.

## Licencjonowanie

To repozytorium ma podwójną licencję:

- **Kod** — kod źródłowy, testy, skrypty, konfiguracja, workflowy
  CI/CD, starter projekty i fragmenty kodu osadzone w Markdownach
  labów — jest objęty [licencją MIT](LICENSE).
- **Treść dydaktyczna** — README labów, opisy zadań, narracja, pytania,
  podpowiedzi i diagramy — jest objęta licencją
  [Creative Commons Attribution 4.0 International](LICENSE-CONTENT.md)
  (CC BY 4.0).

Materiały stron trzecich zawarte w tym repozytorium, jeśli takie
istnieją, zachowują własne oryginalne prawa autorskie i warunki
licencyjne.

## Prowadzący / autor

Stworzone i utrzymywane przez Michała Maja.
