# Lab 17 — Konflikt merge'a

## Sytuacja

Obie funkcje są gotowe. Czas wprowadzić je do `main`, jedna po
drugiej.

## Cele nauki

Po tym labie potrafisz:

- Zmergować branch bez konfliktów i rozpoznać, jak wygląda czysty
  merge.
- Przeczytać markery konfliktu Gita i zidentyfikować dokładnie, co
  każda strona zmieniła.
- Rozwiązać konflikt, łącząc obie zmiany, nie wybierając na oślep
  jednej strony.

## Zanim zaczniesz

- Lab 16 ukończony: obie branche `feature/low-stock-warning` i
  `feature/expiry-warning` istnieją, każda z przechodzącym zestawem
  testów, w Twojej wybranej ścieżce.

### Python

- Bieżący katalog: `examples/team-inventory/python/`, na branchu
  `main`.

### Go

- Bieżący katalog: `examples/team-inventory/go/`, na branchu `main`.

### Java

- Bieżący katalog: `examples/team-inventory/java/`, na branchu
  `main`.

## Twoje zadanie

1. Potwierdź, że jesteś na `main`: `git switch main`.
2. Zmergeuj pierwszą funkcję: `git merge feature/low-stock-warning`. To
   powinno zakończyć się bez konfliktu — przeczytaj komunikat, który
   wypisuje Git (prawdopodobnie fast-forward, bo `main` się nie
   przesunął od Twojego rozgałęzienia).
3. Uruchom komendę testową swojej ścieżki, żeby potwierdzić, że `main`
   ma teraz funkcję niskiego stanu i wciąż przechodzi.
4. Zmergeuj drugą funkcję: `git merge feature/expiry-warning`. To
   **spowoduje** konflikt — w **dwóch plikach**: Twoim pliku
   źródłowym i Twoim pliku testowym.
5. Otwórz swój plik źródłowy (zobacz dokładny kształt konfliktu Twojej
   ścieżki poniżej). Przeczytaj obie strony każdego bloku, zanim
   czegokolwiek dotkniesz.
6. Rozwiąż konflikt, zachowując **obie** zmiany. Usuń każdy marker
   konfliktu.
7. Otwórz swój plik testowy (zobacz dokładny kształt konfliktu Twojej
   ścieżki poniżej). Rozwiąż go, zachowując **obie** zmiany.
8. Uruchom komendę testową swojej ścieżki. Wszystkie testy —
   oryginalny, niskiego stanu, i terminu ważności — muszą przechodzić.
9. Zastage'uj oba rozwiązane pliki i dokończ merge (Git wypełnia
   komunikat merge commita za Ciebie; nie potrzebujesz `-m`).
10. Uruchom `git log --oneline --graph -5` i potwierdź, że obie funkcje
    są teraz częścią historii `main`.

### Python — dokładny konflikt, który zobaczysz

Dwa bloki w `inventory.py`: jeden, gdzie każda branch dodała swoją
własną nową funkcję (całe ciało funkcji się różni, bo dwa filtry są
napisane inaczej), jeden wewnątrz `summarize`, gdzie każda branch
dołączyła swoje własne dwie linie. Dwa bloki w
`tests/test_inventory.py`: linia `import` (każda branch zaimportowała
inną nową nazwę), i nowa funkcja testowa, którą każda branch dodała
(każda nazwana inaczej i wywołująca inną funkcję — to jeden blok
konfliktu, bo dwie funkcje testowe siedzą na bezpośrednio sąsiadujących
liniach).

### Go — dokładny konflikt, który zobaczysz

To **nie jest** ten sam kształt co w Pythonie, i to jest oczekiwane,
nie Twoja pomyłka: Go nie ma linii `import`, na której mógłby być
konflikt (wywołanie innej funkcji w tym samym pakiecie nie potrzebuje
importu), więc `inventory_test.go` konfliktuje w dokładnie **jednym**
bloku — dwie funkcje testowe, sąsiadujące, każda nazwana inaczej i
wywołująca inną funkcję. W `inventory.go` pierwszy blok konfliktu
obejmuje cztery linie z każdej strony — sygnaturę funkcji, linię `var
names []string`, linię pętli `for`, i warunek `if` — nawet choć środkowe
dwie z tych czterech linii są tekstowo identyczne między branchami. Git
wciąż umieszcza je wewnątrz markerów. Tylko pięcioliniowy ogon po tym
(`names = append(names, item.Name)`, dwa zamykające nawiasy klamrowe,
`return names`, i zamykający nawias klamrowy funkcji) jest wystarczająco
zgodny, żeby Git zmergował go automatycznie, poza markerami. Drugi
konflikt, wewnątrz `Summarize`, obejmuje oba wstawione bloki w całości,
bo żadna strona nie ma tam zgodnego ogona.

### Java — dokładny konflikt, który zobaczysz

Ten sam kształt co Go, z tego samego powodu: brak konfliktu na linii
importu (obie branche wywołują statyczną metodę na tej samej klasie),
więc `InventoryTest.java` konfliktuje w dokładnie **jednym** bloku —
dwie metody `@Test`, sąsiadujące (sama linia anotacji `@Test` siedzi
zaraz *przed* konfliktem i zgadza się na obu stronach, więc nie jest
częścią oznaczonego bloku). W `Inventory.java`, jak w Go, pierwszy
blok konfliktu obejmuje cztery linie z każdej strony — sygnaturę
metody, linię `List<String> names = new ArrayList<>();`, linię pętli
`for`, i warunek `if` — nawet choć środkowe dwie są tekstowo identyczne
między branchami. Tylko pięcioliniowy ogon po tym (`names.add(item.name);`,
dwa zamykające nawiasy klamrowe, `return names;`, i zamykający nawias
klamrowy metody) mergeuje się automatycznie, poza markerami. Drugi
konflikt, wewnątrz `summarize`, obejmuje oba wstawione bloki w całości.

## Kryteria akceptacji

- Żadne markery konfliktu nie zostają nigdzie w Twoim pliku
  źródłowym albo pliku testowym.
- Obie nowe funkcje/metody są zdefiniowane i używane wewnątrz
  `summarize`/`Summarize`.
- Komenda testowa Twojej ścieżki przechodzi z każdym testem z obu
  branchy obecnym (3 testy łącznie).
- Merge commit dla `feature/expiry-warning` istnieje na `main`.

## Weryfikacja

### Python

```bash
cd examples/team-inventory/python
if grep -nE '^(<<<<<<<|=======|>>>>>>>)' inventory.py tests/test_inventory.py; then
    echo "Conflict markers remain."
    exit 1
else
    echo "No conflict markers remain."
fi
uv run pytest -v
git log --oneline -4
cd -
```

### Go

```bash
cd examples/team-inventory/go
if grep -nE '^(<<<<<<<|=======|>>>>>>>)' inventory.go inventory_test.go; then
    echo "Conflict markers remain."
    exit 1
else
    echo "No conflict markers remain."
fi
go test ./... -v
git log --oneline -4
cd -
```

### Java

```bash
cd examples/team-inventory/java
if grep -nE '^(<<<<<<<|=======|>>>>>>>)' src/main/java/Inventory.java src/test/java/InventoryTest.java; then
    echo "Conflict markers remain."
    exit 1
else
    echo "No conflict markers remain."
fi
./gradlew test
git log --oneline -4
cd -
```

Oczekiwane: `No conflict markers remain.`, każdy test przeszedł, i
merge commit widoczny w logu. Zauważ `exit 1` wewnątrz `if` — bez
niego, ten check wypisałby "Conflict markers remain." i wciąż
zakończyłby się sukcesem, co psuje cały sens checka. Wypróbuj to na
oba sposoby na pliku, o którym wiesz, że wciąż ma markery, i na takim,
który ich nie ma, żeby zobaczyć różnicę samemu/samej.

## Zastanów się

- Żadna branch nie edytowała linii, którą druga branch też edytowała —
  obie tylko *dodały* nowe linie, w tym samym miejscu, w tych samych
  dwóch plikach. Czemu Git wciąż traktował oba pliki jako konflikty,
  zamiast po cichu zachować obie dodane rzeczy?
- Kolega z zespołu mówi "weź po prostu moje, usuń ich", bez czytania
  drugiej strony konfliktu. Jakie jest konkretne ryzyko robienia tego
  tutaj — w którymkolwiek pliku?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** `<<<<<<< HEAD` oznacza początek wersji *Twojego
  bieżącego brancha*; `=======` dzieli obie strony; `>>>>>>>
  feature/expiry-warning` oznacza koniec wersji *przychodzącego*
  brancha.
- **Podpowiedź 2:** `inventory.py` ma dwa osobne bloki konfliktu; plik
  testowy też ma dwa — jeden na linii importu, jeden obejmujący nazwę
  i ciało nowej funkcji testowej. Rozwiąż każdy znaleziony blok — nie
  zatrzymuj się po pierwszym pliku.
- **Podpowiedź 3:** Po edycji, oba pliki powinny zawierać zero linii
  `<<<<<<<`, `=======` albo `>>>>>>>` — jeśli `grep` znajdzie
  jakiekolwiek w którymkolwiek pliku, nie jesteś gotowy/a.

### Go

- **Podpowiedź 1:** `<<<<<<< HEAD` oznacza początek wersji *Twojego
  bieżącego brancha*; `=======` dzieli obie strony; `>>>>>>>
  feature/expiry-warning` oznacza koniec wersji *przychodzącego*
  brancha.
- **Podpowiedź 2:** `inventory.go` ma dwa bloki konfliktu, ale pierwszy
  jest krótszy niż cała funkcja — kończy się przed liniami
  zamykającymi, które obie funkcje mają wspólne (`names = append(...)`
  przez finalne `}`), które nie są oznaczone wcale. Nie zakładaj, że
  musisz przepisać całą funkcję z markerów; przeczytaj, co faktycznie
  jest między nimi.
- **Podpowiedź 3:** Po edycji, oba pliki powinny zawierać zero linii
  `<<<<<<<`, `=======` albo `>>>>>>>` — jeśli `grep` znajdzie
  jakiekolwiek w którymkolwiek pliku, nie jesteś gotowy/a.

### Java

- **Podpowiedź 1:** `<<<<<<< HEAD` oznacza początek wersji *Twojego
  bieżącego brancha*; `=======` dzieli obie strony; `>>>>>>>
  feature/expiry-warning` oznacza koniec wersji *przychodzącego*
  brancha.
- **Podpowiedź 2:** `Inventory.java` ma dwa bloki konfliktu, ale
  pierwszy jest krótszy niż cała metoda — kończy się przed liniami
  zamykającymi, które obie metody mają wspólne (`names.add(...)` przez
  finalne `}`), które nie są oznaczone wcale. Nie zakładaj, że musisz
  przepisać całą metodę z markerów; przeczytaj, co faktycznie jest
  między nimi.
- **Podpowiedź 3:** Po edycji, oba pliki powinny zawierać zero linii
  `<<<<<<<`, `=======` albo `>>>>>>>` — jeśli `grep` znajdzie
  jakiekolwiek w którymkolwiek pliku, nie jesteś gotowy/a.

Przed przejściem dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (zaczynający się od Lab 16)
tak — przyzwyczajaj się już teraz.

## Co dalej

Rozwiązałeś/aś ten konflikt lokalnie, samodzielnie, potem dokończyłeś/aś
merge bezpośrednio na `main`. W prawdziwym zespole, taka zmiana
przeszłaby przez review, zanim trafiłaby do kodu. Dalej zrobisz to
właściwie.

Przejdź do [Lab 18 — Pull requesty i code review](../18-pull-requests-and-review/README.pl.md).
