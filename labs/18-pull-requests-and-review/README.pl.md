# Lab 18 — Pull requesty i code review

## Sytuacja

Do teraz, każda zmiana trafiała na `main`, bo mergowałeś/aś ją sam/a.
Kolega z zespołu powinien zobaczyć zmianę, zanim trafi do kodu — nawet
gdy tym kolegą jest dziś prawdziwy kolega z klasy, albo po prostu
ostrożne-przyszłe-Ty innego dnia.

## Cele nauki

Po tym labie potrafisz:

- Otworzyć pull request z opisem wyjaśniającym, czemu zmiana istnieje,
  nie tylko co się zmieniło.
- Zrecenzować diff na podstawie konkretnej checklisty, nie mglistego
  wrażenia.
- Dojść do prawdziwego wyniku review przed mergem — rozwiązanego
  actionable comment, albo zatwierdzenia popartego faktycznym
  przejściem checklisty.

## Zanim zaczniesz

- Lab 17 ukończony: `main` ma obie funkcje, niskiego stanu i terminu
  ważności, zmergowane, w Twojej wybranej ścieżce.
- Twoja praca `examples/team-inventory/` mieszka w **Twoim własnym**
  repozytorium albo forku na GitHubie — PR tego laba dzieje się tam,
  nie w stosunku do wspólnego repozytorium kursu.
- Jeśli prowadzący sparował Cię z kolegą z klasy dla tego laba, zaplanuj
  wymianę pull requestów z nim w kroku 4.

### Python

- Bieżący katalog: `examples/team-inventory/python/`.

### Go

- Bieżący katalog: `examples/team-inventory/go/`.

### Java

- Bieżący katalog: `examples/team-inventory/java/`.

## Twoje zadanie

1. Utwórz branch `feature/reorder-report` z `main`.

### Python

2. Dodaj funkcję `reorder_report(inventory: list[dict], threshold: int
   = 5) -> str`, która ponownie używa `low_stock_items` i zwraca
   sformatowany string jak `"Reorder needed: Tomatoes, Milk"` (albo
   `"Nothing to reorder."`, jeśli lista jest pusta). Wstaw ją
   bezpośrednio powyżej `summarize`. Dodaj test. Zacommituj.

### Go

2. Dodaj funkcję `func ReorderReport(inventory []Item, threshold int)
   string`, która ponownie używa `LowStockItems` i zwraca sformatowany
   string jak `"Reorder needed: Tomatoes, Milk"` (albo `"Nothing to
   reorder."`, jeśli lista jest pusta). Wstaw ją bezpośrednio powyżej
   `Summarize`. Dodaj test. Zacommituj.

### Java

2. Dodaj metodę `public static String reorderReport(List<Item>
   inventory, int threshold)`, która ponownie używa `lowStockItems` i
   zwraca sformatowany string jak `"Reorder needed: Tomatoes, Milk"`
   (albo `"Nothing to reorder."`, jeśli lista jest pusta). Wstaw ją
   bezpośrednio powyżej `summarize`. Dodaj test. Zacommituj.

## Wszystkie ścieżki

3. Wypchnij branch i otwórz pull request. Najpierw sprawdź, dokąd
   faktycznie trafia — **nie zgaduj**:
   - **Web UI GitHuba** (wiarygodna ścieżka dla pierwszego PR): kliknij
     **Compare & pull request** na swoim wypchniętym branchu, albo
     przejdź do zakładki **Pull requests** swojego forka i kliknij
     **New pull request**. Przed kliknięciem finalnego przycisku
     **Create pull request**, przeczytaj **base repository** i **base
     branch** pokazane na górze strony — muszą być *Twoim własnym*
     forkiem i Twoim własnym `main`, nie repozytorium kursu, z którego
     pierwotnie zrobiłeś/aś fork. GitHub czasem domyślnie ustawia bazę
     na repozytorium, z którego zrobiłeś/aś fork, co jest tutaj
     dokładnie złym celem.
   - **`gh pr create`** (opcjonalnie — tylko jeśli masz już
     zainstalowany GitHub CLI; ten kurs nigdy nie wymaga jego
     instalacji): domyślnie otwiera PR względem repozytorium, z
     którego zrobiłeś/aś fork, nie Twojego własnego forka — uruchom
     `gh repo set-default <twój-fork>` raz, żeby domyślnie ustawiał
     się poprawnie, i sprawdź dwa razy base repository, które wypisuje,
     przed potwierdzeniem, tak czy inaczej.

   Nigdy nie kieruj tego (albo jakiegokolwiek przyszłego) PR do
   wspólnego repozytorium kursu — to zawsze `main` Twojego własnego
   forka.

   Napisz opis obejmujący: co się zmieniło, czemu, i jak to
   zweryfikowałeś/aś (jakie komendy uruchomiłeś/aś).
4. Zrecenzuj go, używając checklisty poniżej:
   - **W parze:** poproś partnera przypisanego przez prowadzącego o
     wymianę PR — recenzujesz jego, on recenzuje Twój.
   - **Solo:** zrecenzuj swój własny diff, jakby ktoś nieznajomy widział
     go pierwszy raz, używając tej samej checklisty.

   Checklista:
   - Czy opis wyjaśnia *czemu*, nie tylko *co*?
   - Czy test faktycznie ćwiczy nowe zachowanie, nie tylko wywołuje
     funkcję raz?
   - Czy jest tu logika zduplikowana z funkcji niskiego stanu, która
     powinna być ponownie użyta, nie przepisana?
   - Zrozumiałbyś/abyś ten diff bez pytania autora?
5. Zależnie od tego, co review faktycznie znajdzie:
   - **Znajduje actionable problem** — coś, czego czytelnik faktycznie
     chciałby zmienione albo wyjaśnione, nie przeformułowanie diffa:
     zostaw co najmniej jeden merytoryczny komentarz (na GitHubie,
     jeśli w parze; w
     `labs/18-pull-requests-and-review/my-review-notes.md`, jeśli
     solo), potem rozwiąż go — napraw kod, albo odpowiedz
     wyjaśniając czemu nie — i potwierdź, że poprawka faktycznie tam
     jest.
   - **Nie znajduje nic actionable**: zatwierdź go (na GitHubie, jeśli
     w parze), albo napisz jedną linię w `my-review-notes.md`, jeśli
     solo, potwierdzającą, że każdy element checklisty został
     faktycznie sprawdzony, nie tylko "wygląda dobrze". Nie wymyślaj
     komentarza tylko, żeby go wyprodukować.
6. Zmergeuj PR, używając przycisku merge GitHuba — nie lokalnego `git
   merge` — gdy review doszło do jednego z tych dwóch wyników.
7. Pobierz zmergowaną zmianę do swojego lokalnego `main`.

## Kryteria akceptacji

- Pull request istniał, kierowany do `main` **Twojego własnego forka**
  (nigdy repozytorium kursu), z opisem obejmującym co/czemu/jak
  zweryfikowane.
- Review doszło do jednego z dwóch uprawnionych wyników: merytoryczny
  komentarz został zostawiony i rozwiązany, albo checklista nie
  znalazła nic actionable, co potwierdza zatwierdzenie na GitHubie (w
  parze) albo krótki, konkretny zapis w `my-review-notes.md` (solo —
  GitHub nie pozwala formalnie zatwierdzić własnego pull requesta, więc
  ta notatka jest solo-odpowiednikiem, nie gorszym zamiennikiem) —
  nigdy komentarz wymyślony tylko, żeby zaspokoić ten wymóg.
- Po pobraniu, lokalny `main` zawiera nową funkcję/metodę i jej test, a
  komenda testowa Twojej ścieżki przechodzi.

## Weryfikacja

### Python

```bash
cd examples/team-inventory/python
git log --oneline -3
uv run pytest -v
cd -
```

### Go

```bash
cd examples/team-inventory/go
git log --oneline -3
go test ./... -v
cd -
```

### Java

```bash
cd examples/team-inventory/java
git log --oneline -3
./gradlew test
cd -
```

Oczekiwane: merge commit (albo squash commit, zależnie od ustawień
merge Twojego repo) dla `feature/reorder-report`, i wszystkie testy
przechodzą.

## Zastanów się

- Jaka jest różnica między reviewerem sprawdzającym "czy to się
  uruchamia" a reviewerem sprawdzającym "czy następna osoba, która to
  przeczyta, to zrozumie"? W którą stronę pchnęła Cię checklista?
- Jeśli recenzowałeś/aś solo, co zauważyłeś/aś w swoim własnym kodzie,
  co mógłbyś/mogłabyś przegapić, gdybyś tylko uruchomił/a testy i uznał/a
  to za zrobione?

## Jeśli utkniesz

- **Podpowiedź 1:** W web UI, base repository i base branch są pokazane
  jako dwa dropdowny na samej górze strony "Open a pull request" —
  przeczytaj je, zanim przeczytasz cokolwiek innego na tej stronie.
- **Podpowiedź 2:** "Ponownie użyj funkcji niskiego stanu" znaczy
  wywołanie jej z Twojej nowej funkcji/metody, nie skopiowanie jej
  logiki filtrowania do drugiego miejsca.
- **Podpowiedź 3:** Jeśli pracujesz solo, zapisz, co zapisujesz —
  komentarz albo notatkę zatwierdzenia — jakbyś nie pamiętał/a żadnego
  kontekstu za sześć miesięcy. To ograniczenie sprawia, że mgliste
  notatki są oczywiście bezużyteczne, niezależnie od tego, do jakiego
  wyniku doszło review.

Przed przejściem dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (zaczynający się od Lab 16)
tak — przyzwyczajaj się już teraz.

## Co dalej

Zrecenzowany, zmergowany kod jest wciąż tak dobry, jak to, o czym nikt
nie zapomniał sprawdzić. Dalej repozytorium zaczyna sprawdzać samo
siebie.

Przejdź do [Lab 19 — Repozytorium powinno sprawdzać samo siebie](../19-repository-checks-itself/README.pl.md).
