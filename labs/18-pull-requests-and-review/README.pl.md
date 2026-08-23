# Lab 18 — Pull requesty i code review

## Sytuacja

Do tej pory każda zmiana lądowała na `main`, bo sam/a ją mergowałeś/aś,
samotnie. Kolega z zespołu powinien zobaczyć zmianę, zanim wyląduje —
nawet gdy tym kolegą jest dziś prawdziwy kolega z klasy, albo po prostu
ostrożniejszy-Ty w inny dzień.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Otworzyć pull request z opisem, który wyjaśnia, dlaczego zmiana
  istnieje, a nie tylko co się zmieniło.
- Zrecenzować diff według konkretnej checklisty, a nie mglistego
  wrażenia.
- Zostawić praktyczne komentarze recenzji i odpowiedzieć na nie przed
  mergem.

## Zanim zaczniesz

- Lab 17 ukończony: `main` ma zmergowane obie funkcje, niskiego stanu
  i terminu ważności.
- Twoja praca nad `examples/team-inventory/` mieszka w **Twoim
  własnym** repozytorium albo forku na GitHubie — PR z tego laba
  dzieje się tam, nie przeciwko wspólnemu repozytorium kursu.
- Jeśli instruktor sparował Cię z kolegą z klasy do tego laba, zaplanuj
  wymianę pull requestów w kroku 4.

## Twoje zadanie

1. Utwórz gałąź `feature/reorder-report` z `main`.
2. Dodaj funkcję `reorder_report(inventory: list[dict], threshold: int
   = 5) -> str`, która ponownie używa `low_stock_items` i zwraca
   sformatowany string w stylu `"Reorder needed: Tomatoes, Milk"` (albo
   `"Nothing to reorder."`, jeśli lista jest pusta). Dodaj test.
   Zacommituj.
3. Wypchnij gałąź i otwórz pull request. **Jeśli pracujesz z forka**,
   `gh pr create` domyślnie otwiera PR przeciwko domyślnej gałęzi
   *oryginalnego* repozytorium, nie `main` Twojego forka — dla tego
   ćwiczenia (i każdego kolejnego PR-a w tym kursie) chcesz, żeby PR
   celował w Twój własny fork. Użyj albo interfejsu webowego GitHuba
   (który pokazuje repozytorium bazowe, zanim potwierdzisz), albo
   uruchom raz `gh repo set-default <Twój-fork>`, żeby `gh pr create`
   domyślnie celował w Twój fork, i tak czy inaczej sprawdź dwa razy
   pokazane repozytorium bazowe przed wysłaniem. Napisz opis
   obejmujący: co się zmieniło, dlaczego i jak to zweryfikowałeś/aś
   (jakie polecenia uruchomiłeś/aś).
4. Zrecenzuj go, używając poniższej checklisty:
   - **W parze:** poproś przydzielonego przez instruktora partnera o
     wymianę PR-ów — zrecenzuj jego, on/ona zrecenzuje Twój.
   - **Solo:** zrecenzuj własny diff tak, jakby obcy widział go po raz
     pierwszy, używając tej samej checklisty.

   Checklista:
   - Czy opis wyjaśnia *dlaczego*, a nie tylko *co*?
   - Czy test faktycznie sprawdza nowe zachowanie, a nie tylko
     wywołuje funkcję raz?
   - Czy jest tu logika powielona z `low_stock_items`, która powinna
     być ponownie użyta zamiast przepisana?
   - Czy zrozumiałbyś/zrozumiałabyś ten diff bez zadawania autorowi
     pytania?
5. Zostaw co najmniej jeden merytoryczny komentarz recenzji — na
   GitHubie, jeśli w parze; w
   `labs/18-pull-requests-and-review/my-review-notes.md`, jeśli solo.
   "Merytoryczny" znaczy, że wskazuje coś, co czytelnik faktycznie
   chciałby zmienić albo doprecyzować — nie parafrazę diffa. Jeśli diff
   naprawdę daje powód do więcej niż jednego takiego punktu, zostaw
   więcej; nie wymuszaj drugiego komentarza tylko po to, żeby osiągnąć
   liczbę.
6. Zajmij się każdym komentarzem (napraw kod albo napisz jednolinijkową
   odpowiedź wyjaśniającą dlaczego nie), potem zmerguj PR przyciskiem
   merge'a na GitHubie — nie lokalnym `git merge`.
7. Pobierz zmergowaną zmianę do swojego lokalnego `main`.

## Kryteria akceptacji

- Istniał pull request z opisem obejmującym co/dlaczego/jak
  zweryfikowano.
- Istnieje co najmniej jeden merytoryczny komentarz recenzji (na
  GitHubie albo w `my-review-notes.md`, jeśli solo) — na tyle
  konkretny, żeby autor wiedział dokładnie, co z nim zrobić.
- Po pobraniu lokalny `main` zawiera `reorder_report` i jego test, a
  `uv run pytest` przechodzi.

## Weryfikacja

```bash
cd examples/team-inventory
git log --oneline -3
uv run pytest -v
cd -
```

Oczekiwane: commit merge'a (albo squash, zależnie od ustawień mergowania
Twojego repozytorium) dla `feature/reorder-report`, i wszystkie testy
przechodzące.

## Zastanów się

- Jaka jest różnica między recenzentem sprawdzającym "czy to działa" a
  recenzentem sprawdzającym "czy następna osoba, która to przeczyta,
  zrozumie to"? Ku któremu pchnęła Cię checklista?
- Jeśli recenzowałeś/aś solo, co zauważyłeś/aś we własnym kodzie, co
  mogłeś/mogłabyś pominąć, gdybyś tylko uruchomił/a testy i uznał/a
  sprawę za zamkniętą?

## Jeśli utkniesz

- **Podpowiedź 1:** `gh pr create --fill` używa komunikatów commitów z
  Twojej gałęzi, żeby wstępnie wypełnić tytuł i treść PR-a — szybsze
  niż wpisywanie obu ręcznie, choć i tak powinieneś/aś potem poprawić
  opis.
- **Podpowiedź 2:** "Ponowne użycie `low_stock_items`" oznacza
  wywołanie jej z `reorder_report`, a nie skopiowanie jej logiki
  filtrowania w drugie miejsce.
- **Podpowiedź 3:** Jeśli pracujesz solo, pisz komentarze recenzji tak,
  jakbyś za sześć miesięcy nie pamiętał/a żadnego kontekstu — to
  ograniczenie sprawia, że mgliste komentarze stają się oczywiście
  bezużyteczne.

## Co dalej

Zrecenzowany, zmergowany kod jest wciąż tak dobry, jak to, o czym nikt
nie pamiętał, żeby faktycznie sprawdzić. Dalej repozytorium zaczyna
sprawdzać się samo.

Przejdź do [Lab 19 — Repozytorium powinno sprawdzać się samo](../19-repository-checks-itself/README.pl.md).
