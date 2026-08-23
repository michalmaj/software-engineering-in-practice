# Lab 27 — Iteracja rozwojowa

## Sytuacja

Plan jest napisany. ADR zaakceptowany. Teraz to już tylko budowanie —
z tym że "tylko budowanie" to moment, w którym każdy nawyk z Aktu IV
albo utrzymuje się przy prawdziwym, ciągłym użyciu, albo cicho zostaje
pominięty, gdy ktoś się pierwszy raz spieszy.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Uruchomić pełną pętlę issue → branch → commity → testy → PR → review
  → CI → merge wielokrotnie, bez README laba mówiącego Ci za każdym
  razem, co dalej.
- Utrzymać działający projekt uczciwie pod presją czasu — małe PR-y,
  faktycznie uruchamiane testy, faktycznie czytane recenzje.
- Rozpoznać moment, w którym skrót, po który sięgasz, jest dokładnie
  tym, czemu Akt IV miał zapobiec.

## Zanim zaczniesz

- Lab 26 ukończony: `PROJECT_PLAN.md` i
  `docs/adr/adr-001-language-choice.md` istnieją w Waszym własnym
  repozytorium zespołu.
- Repozytorium Waszego zespołu ma skopiowany starter kapstone z Lab 26
  (`examples/capstone-starters/<język>/` w repozytorium kursu) —
  działające "hello world" i jeden przechodzący test, w wybranym przez
  Was języku.
- Jeśli pracujesz solo: ten lab obejmuje cały build Twojego MVP, nie
  jedną 90-minutową sesję. Nie ściskaj pętli, żeby zmieściła się w
  zegarku — albo rozłóż ten lab na tyle prawdziwych sesji, ile Twoje
  MVP faktycznie potrzebuje, albo zawęź zakres MVP w
  `PROJECT_PLAN.md` do czegoś, co jedna 90-minutowa sesja da radę
  uczciwie skończyć od początku do końca. Zespół rozkłada tę samą pracę
  między swoich członków.

## Twoje zadanie

Ten lab nie ma stałej listy funkcji do zbudowania — to jest właśnie
sedno. Pracując z zakresu MVP z własnego `PROJECT_PLAN.md`:

1. Skonfiguruj teraz CI dla swojego repozytorium, ponownie stosując
   wzorzec z Lab 19: workflow, który instaluje zależności i uruchamia
   Wasz zestaw testów przy każdym push i pull requeście. Zrób to
   *przed* budowaniem funkcji, nie po — chcesz, żeby wyłapywało błędy
   już od Waszego pierwszego prawdziwego PR-a. Krótki przepis dla
   języka, który wybraliście w Lab 26:
   - **Python:** `actions/setup-python@v5` (dopasowany do wersji z
     `.devcontainer/devcontainer.json`), potem zainstaluj `uv` i
     uruchom `uv sync --locked` oraz `uv run pytest` — te same dwa
     polecenia co w Lab 19, zastosowane do Waszego repozytorium.
   - **Go:** `actions/setup-go@v5` z `go-version: '1.25'`, potem
     `go test ./...`. Bez osobnego kroku instalacji zależności.
   - **Java:** `actions/setup-java@v4` z `distribution: 'temurin'` i
     `java-version: '21'`, potem `./gradlew test`. Committed wrapper
     załatwia resztę — bez osobnego kroku instalacji Gradle w CI.
2. Dla każdej możliwości MVP z Waszego planu (utworzenie rezerwacji,
   wylistowanie rezerwacji na dzień, anulowanie rezerwacji i cokolwiek
   jeszcze Wasz zespół zakresił), powtórz pełną pętlę: otwórz issue
   albo zadanie ją opisujące, rozgałęź, napisz failing test,
   zaimplementuj, commituj w recenzowalnych krokach, wypchnij, otwórz
   PR z prawdziwym opisem, zdobądź recenzję (prawdziwego kolegę z
   zespołu, jeśli go masz; checklistę solo z Lab 18, jeśli nie), zajmij
   się feedbackiem, zmerguj dopiero gdy CI jest zielone.
3. Trzymaj każdy PR na tyle mały, żeby jego recenzent faktycznie mógł
   utrzymać całą zmianę w głowie — jeśli PR robi trzy niepowiązane
   rzeczy, podziel go.
4. Pod koniec tego laba wszystkie Wasze kryteria akceptacji MVP z
   `PROJECT_PLAN.md` powinny być spełnione i zmergowane do głównej
   gałęzi, z zielonym CI.

## Kryteria akceptacji

- CI jest skonfigurowane i zielone na Waszej głównej gałęzi.
- Każda możliwość MVP z `PROJECT_PLAN.md` jest zaimplementowana,
  przetestowana i zmergowana przez zrecenzowany PR (albo zrecenzowany
  solo, wg Lab 18).
- Możesz wskazać historię commitów i listę PR-ów Waszego repozytorium
  jako dowód pętli, a nie tylko opis zamiaru jej stosowania.

## Weryfikacja

```bash
# run from your team's own repository, with whatever command runs your tests
<your test command>
```

Oczekiwane: Wasz pełny zestaw testów przechodzi, a Wasz dostawca CI
pokazuje zielone na ostatnim commicie Waszej głównej gałęzi.

## Zastanów się

- Którą część pętli z Aktu IV byłeś/aś najbardziej skłonny/a pominąć,
  gdy nikt już nie patrzył lab-po-labie — napisanie najpierw failing
  testu, napisanie prawdziwego opisu PR-a, czy faktyczne przeczytanie
  diffa kolegi przed zaakceptowaniem?
- Gdyby kolega z zespołu (albo Ty sam/a jako solo-recenzent) automatycznie
  zaakceptował PR bez faktycznego czytania, w którym najwcześniejszym
  momencie dalej w tym kapstone stałoby się to widoczne?

## Jeśli utkniesz

- **Podpowiedź 1:** Jeśli nie wiesz, co budować dalej, przeczytaj
  ponownie sekcję zakresu własnego `PROJECT_PLAN.md` — odpowiedź jest
  już zapisana.
- **Podpowiedź 2:** Workflow CI, który musi tylko zainstalować
  zależności i uruchomić testy, to bezpośrednia adaptacja tego z Lab
  19 — ten sam kształt, inny projekt.
- **Podpowiedź 3:** Jeśli recenzje zaczynają wyglądać na formalność,
  wróć do checklisty z Lab 18 i trzymaj się jej (albo trzymaj kolegę)
  jawnie, na głos.

## Co dalej

Wasze MVP działa, jest przetestowane i zrecenzowane. Teraz wymaganie
się zmienia — i przekonacie się, ile faktycznie kosztował Was Wasz
projekt.

Przejdź do [Lab 28 — Zmiana wymagań](../28-change-request/README.pl.md).
