# Lab 26 — Kickoff projektu

## Sytuacja

Nie naprawiasz już cudzego projektu. Właściciel restauracji ma
prawdziwy problem i żadnego oprogramowania, żeby go rozwiązać:
"Rezerwacje są śledzone na papierze. W godzinach szczytu trudno szybko
sprawdzić, które stoliki są wolne, potwierdzić, co już jest
zarezerwowane, albo obsłużyć anulowanie, zanim zadzwoni kolejny
klient." To cały brief. Reszta — zakres, projekt, język, plan — należy
do Was jako zespołu.

## Cele nauki

Po tym labie potrafisz:

- Zamienić otwarty problem na spisany zakres, zestaw założeń i
  konkretne kryteria akceptacji MVP.
- Napisać lekki Architecture Decision Record (ADR) uzasadniający
  prawdziwy wybór techniczny dla Waszego konkretnego zespołu i
  problemu.
- Wyprodukować plan kamieni milowych i listę ryzyk dla wielosesyjnego
  projektu.

## Zanim zaczniesz

- Laby 01-25 ukończone, w Waszym wybranym tracku (Python, Go albo
  Java).
- Jeśli jesteś w klasie: instruktor przydzielił Cię do zespołu 3-4
  osób. Jeśli pracujesz solo: Ty *jesteś* zespołem — wykonaj każdy krok
  poniżej, włącznie z tymi o przydziale ról, decydując samodzielnie.
- Prawie bez kodu: jedyny kod, którego dotkniesz, to starter kopiowany
  w ostatnim kroku poniżej, gdy Wasz zespół już zdecyduje o języku.
  Reszta tego labu to planowanie i zakładanie repozytorium.

## Twoje zadanie

**Problem (przekaż go swojemu zespołowi w tej formie):**

> Restauracja potrzebuje małego wewnętrznego narzędzia o nazwie
> **TableTime** do zarządzania rezerwacjami stolików. Dziś rezerwacje
> są śledzone na papierze.
>
> Minimalne niezbędne możliwości:
> 1. Utworzenie rezerwacji: imię i nazwisko klienta, wielkość grupy,
>    dzień i przedział czasowy.
> 2. Wylistowanie wszystkich rezerwacji na dany dzień.
> 3. Anulowanie rezerwacji.
>
> Restauracja ma stałą, małą liczbę stolików, każdy o maksymalnej
> pojemności miejsc — dokładne liczby ustalacie jako część swojego
> projektu. Rezerwacja musi mieć przydzielony stolik, który pomieści
> grupę.
>
> Nie ma (jeszcze) żadnego wymagania co do tego, co się dzieje, gdy
> dwie rezerwacje trafią na ten sam stolik w nakładających się porach.
> To prawdziwa, celowa luka w briefie, nie przeoczenie, które macie
> zatuszować — zdecydujcie sami, czy ma znaczenie dla tego MVP, a jeśli
> zdecydujecie, że tak, nic nie stoi na przeszkodzie, żeby obsłużyć to
> już teraz zamiast później.

### Krok 1 — załóżcie prawdziwe repozytorium Waszego zespołu

To inne repozytorium niż to, w którym czytasz ten lab. Wasz osobisty
fork tego repozytorium kursowego to miejsce, gdzie zrobiliście Laby
01-25; TableTime żyje gdzieś nowym, utworzonym od zera, do którego cały
Wasz zespół może pushować. Nie twórzcie go przez zforkowanie tego
repozytorium kursowego i nie budujcie TableTime wewnątrz swojego
istniejącego forka nigdzie — świeże, puste repozytorium, należące do
Waszego zespołu, to krok pierwszy.

1. **Jedna osoba z zespołu je zakłada** (ktokolwiek — nie musi to być
   ta sama osoba co w każdym labie). Na [github.com](https://github.com)
   kliknij **+** w prawym górnym rogu, potem **New repository**.
2. **Nazwijcie je** czymś krótkim i rozpoznawalnym — `tabletime`
   wystarczy.
3. **Zostawcie odznaczone "Add a README file".** Zaraz napiszecie
   własny `README.md` lokalnie i wypushujecie go sami jako pierwszy
   prawdziwy commit — pozwolenie GitHubowi na automatyczne utworzenie
   jednego oznaczałoby tylko usunięcie go parę minut później. Zostawcie
   też rozwijane listy `.gitignore` i licencji na "None" — przyniesiecie
   `.gitignore`, który dostarczy wybrany starter, w ostatnim kroku
   poniżej.
4. Kliknij **Create repository**. GitHub wyląduje Cię na stronie z
   "Quick setup" i kilkoma fragmentami komend — zostaw tę stronę
   otwartą, zaraz potrzebujesz z niej URL.
5. **Skopiuj URL HTTPS** (pole blisko góry, zaczynające się od
   `https://github.com/...`, z ikoną kopiowania obok) — nie SSH, żeby
   zachować spójność z tym, jak klonowaliście repozytoria przez cały
   kurs.
6. **Sklonujcie je lokalnie**, w nowym terminalu, w lokalizacji poza
   Waszym istniejącym klonem repozytorium kursowego — `git clone <URL,
   który właśnie skopiowałeś/aś>`, potem `cd` do nowego folderu.
7. **Otwórzcie ten folder w VS Code** — świeże **File → Open
   Folder...** (albo `code .` z terminala), osobno od tego, które okno
   VS Code ma otwarte Wasze repozytorium kursowe.
8. **Potwierdźcie, że `origin` wskazuje na Wasze nowe repozytorium
   zespołu**, nie na fork kursowy: `git remote -v` powinno pokazać URL,
   który właśnie sklonowałeś/aś, zarówno dla `fetch`, jak i `push`.
9. Napisz teraz, ręcznie, główny `README.md` z jednym albo dwoma
   zdaniami o tym, czym jest TableTime, i placeholderem, że instrukcje
   setupu/uruchomienia wylądują tutaj, gdy starter zostanie skopiowany.
   Zacommituj go (`git add README.md && git commit -m "docs: add
   initial README"`) i wypushuj (`git push`) — to pierwszy prawdziwy
   commit Waszego repozytorium zespołu.
10. **Jeśli jesteście zespołem**, jeszcze jeden krok, zanim ktokolwiek
    inny dotknie kodu: na GitHubie wejdź w **Settings → Collaborators**
    nowego repozytorium i dodaj każdego kolegę/koleżankę z zespołu po
    jego nazwie użytkownika GitHub albo mailu, którego użył/a do
    rejestracji. GitHub wyśle mu/jej zaproszenie mailem; każdy
    akceptuje je z tego maila (albo z powiadomień/dzwonka na GitHubie),
    zanim będzie mógł pushować.
11. **Każdy z zespołu klonuje potem ten sam URL** z kroku 5 na swoją
    maszynę, tak samo jak zrobiłeś/aś to w kroku 6 — każdy kończy z
    własną lokalną kopią jednego repozytorium zespołu, dokładnie tak,
    jak robiliście to z własnym forkiem kursowym od Lab 03, tylko
    wskazującym na inny remote.
12. Od teraz `README.md` (dopiero co zaczęty), a niedługo
    `PROJECT_PLAN.md` i `docs/adr/adr-001-language-choice.md`, żyją w
    korzeniu *tego* repozytorium — nie gdziekolwiek wewnątrz Waszego
    forka kursowego.

Żadnego CLI `gh`, kluczy SSH, WSL ani Dockera do niczego z powyższego —
wszystko powyżej to albo interfejs WWW GitHuba, albo zwykły `git`, ten
sam setup Git Bash wewnątrz VS Code, którego używaliście na Windows
przez cały kurs.

### Krok 2 — napiszcie `PROJECT_PLAN.md`

Jako zespół napiszcie `PROJECT_PLAN.md` (w Waszym nowym repozytorium)
obejmujący:

- **Zakres**: co jest w MVP, co jest jawnie poza nim.
- **Założenia**: cokolwiek, czego brief nie sprecyzował, a Wy
  zdecydowaliście sami — ile stolików, ich pojemności, i, szczegółowo,
  Wasz model czasu:
  - Jakie wartości rzeczywiście przyjmuje przedział czasowy rezerwacji
    — godziny zegarowe (`"19:00"`), nazwane sloty (`"lunch"`,
    `"dinner"`), czy coś innego?
  - Jaki rzeczywisty przedział reprezentuje jedna rezerwacja, i przez
    mniej więcej jak długo stolik jest przez nią zajęty?
  - Co dzieje się na granicach — czy rezerwacja kończąca się w tym
    samym momencie, w którym zaczyna się inna, liczy się jako
    nakładająca, czy nie?

  Opiszcie to na tyle precyzyjnie, że *później* ktokolwiek z zespołu
  mógłby spojrzeć na dwie rezerwacje i stwierdzić na pewno, czy
  nakładają się w czasie — mimo że nie musicie jeszcze pisać żadnego
  kodu, który to sprawdza (to osobna decyzja, zostawiona Wam, zgodnie z
  luką w briefie powyżej). Model wspierający tylko garstkę nazwanych,
  nienakładających się slotów (`"lunch"`/`"dinner"`) to zupełnie
  prawidłowy wybór *jeśli jawnie to powiecie* — co nie jest
  akceptowalne, to pozostawienie tego na tyle niejasnym, że nikt nie
  mógłby odpowiedzieć na to pytanie później bez zgadywania, co
  mieliście na myśli teraz.
- **Kryteria akceptacji**: skąd będziecie wiedzieć, że MVP jest gotowe
  — konkretne, sprawdzalne stwierdzenia, w stylu Definition of Done z
  Lab 20.
- **Odpowiedzialności**: kto za co odpowiada, jeśli jesteście zespołem;
  jeśli solo, w jakiej kolejności zajmiesz się jakimi zagadnieniami.
- **Plan kamieni milowych**: przybliżone zmapowanie tego, co dzieje się
  w Lab 27 (iteracja), 28 (zmiana wymagań), 29 (incydent) i 30
  (handover).
- **Największe ryzyka**: 2-3 konkretne rzeczy, które mogłyby wykoleić
  ten projekt, i co warto by z każdą zrobić.

### Krok 3 — napiszcie ADR

Zanim napiszecie ADR: wszystkie trzy języki tego kursu są naprawdę
dostępne dla tego capstone'u — Python, Go i Java są równie prawdziwymi
wyborami, nie domyślnym plus dwiema alternatywami. Do tej pory Wasz
zespół spędził cały Akt V (Laby 21-25) budując prawdziwe, przetestowane,
utrwalone, obserwowalne HTTP API w którymkolwiek tracku wybraliście,
więc "nie znamy wystarczająco dobrze tego języka" nie jest już
automatycznie prawdą dla żadnego z trzech tak, jak mogłoby być jeszcze
przy Lab 14. Oprzyjcie decyzję na tym, co faktycznie ma znaczenie dla
*tego* zespołu i *tego* projektu:

- który język Wasz zespół już zna najlepiej, z Aktu V i
  którychkolwiek wcześniejszych labów w nim;
- w którym tracku już byliście, jeśli przełączenie nie daje realnej
  korzyści;
- prawdziwa preferencja zespołu, jeśli więcej niż jedna opcja jest
  równie komfortowa;
- który język utrzymuje faktyczną logikę MVP najprościej wyrażoną;
- jakiekolwiek ograniczenie narzucone przez Wasze środowisko (wspólne
  maszyny, setup oceniania instruktora, i tak dalej).

Ani "wybraliśmy ten sam język co nasz track z Aktu V", ani
"przełączyliśmy się, bo chcieliśmy" nie potrzebuje większego
uzasadnienia niż to — po prostu zapiszcie prawdziwe, specyficzne dla
Waszego zespołu, nie ogólne stwierdzenie, który język jest lepszy.
Potem napiszcie `docs/adr/adr-001-language-choice.md` (w Waszym nowym
repozytorium) używając tego szablonu:

```markdown
# ADR-001: Choice of implementation language

## Status
Accepted

## Context
[What are you building, and what constraints matter — team
familiarity, deployment target, existing course experience with
Python/Go/Java from Labs 14-15?]

## Decision
[Which language: Python, Go, or Java, and why — for this team, this
problem, not "which language is best in general."]

## Consequences
[What does this choice make easier? What does it make harder? What
would make you revisit this decision later?]
```

### Krok 4 — skopiujcie odpowiedni starter

Teraz, gdy Krok 3 ustalił język, skopiujcie odpowiedni starter z
`examples/capstone-starters/<python|go|java>/` (w tym repozytorium
kursu) do korzenia Waszego nowego repozytorium. Pracujcie na świeżym
klonie repozytorium kursowego, jeśli Wasza robocza kopia ma
niezacommitowane zmiany, których nie chcecie przypadkiem przeciągnąć.

- Skopiujcie **całą zawartość** katalogu startera, włącznie z plikami
  zaczynającymi się od kropki (`.gitignore`, a dla Pythona
  `.python-version`) — zwykłe kopiowanie przez Findera/Eksploratora
  albo `cp -r`/`xcopy` może po cichu pominąć pliki, których nazwa
  zaczyna się od kropki; sprawdźcie dwukrotnie przez `ls -a` (albo
  ``Get-ChildItem -Force`` w PowerShell) w miejscu docelowym potem.
- **Nie** kopiujcie folderu `.git`, jeśli starter przypadkiem ma jeden
  gdzieś w środku zagnieżdżony — nie powinno go tam być, ale jeśli
  `ls -a` pokaże jeden, usuńcie go przed commitem; zagnieżdżony `.git`
  po cichu zamieniłby część Waszego repozytorium w niepowiązane,
  zepsute podrepozytorium.
- Własny `STARTER.md` startera **nie** nadpisze `README.md`, który
  napisaliście w Kroku 1 — to różne pliki. Przeczytajcie `STARTER.md`
  raz, żeby poznać dokładne polecenia setupu, a potem usuńcie go; to
  rusztowanie, nie część Waszego projektu.

Szczegóły zależne od tracku:

#### Python

Nic do zmiany nazwy — `examples/capstone-starters/python/pyproject.toml`
ma już `name = "capstone-starter"`, co jest kosmetyczne i nie musi
zgadzać się z nazwą repozytorium Waszego zespołu, żeby `uv sync`/`uv
run pytest` działały. Zmieńcie to później, jeśli chcecie schludniejszy
`pyproject.toml`, ale to nie jest wymagane.

#### Go

Starterowy `go.mod` deklaruje `module capstonestarter`. Ta nazwa jest
używana tylko dla *wewnętrznych* ścieżek importu w ramach Waszego
własnego modułu — ponieważ ten starter to pojedynczy `package main`
bez pod-pakietów importujących się nawzajem po ścieżce, nic się nie
psuje, jeśli zostawicie to jako `capstonestarter` na zawsze. Jeśli
jednak wolelibyście zmienić nazwę, żeby pasowała do Waszego projektu
(na przykład `tabletime`), bezpieczna procedura to jedna komenda,
uruchomiona raz, zaraz po skopiowaniu startera i przed napisaniem
jakiegokolwiek własnego kodu: `go mod edit -module tabletime`. Potem
potwierdźcie, że `go build ./...` i `go test ./...` nadal przechodzą,
zanim zrobicie pierwszy commit — ten kurs zweryfikował, że dokładnie ta
zmiana nazwy nie powoduje żadnych problemów dla kształtu tego startera,
ale potwierdzenie tego samodzielnie zajmuje sekundy i nic nie
kosztuje.

#### Java

Zachowajcie cały zacommitowany Gradle Wrapper (`gradlew`, `gradlew.bat`,
`gradle/wrapper/gradle-wrapper.jar`, `gradle/wrapper/gradle-wrapper.properties`)
dokładnie tak, jak skopiowany — to pliki binarne/przypięte, nie coś do
regenerowania czy edytowania. `rootProject.name = 'capstone-starter'`
w `settings.gradle` jest kosmetyczne, tak samo jak nazwa modułu w Go;
jeśli chcecie, żeby brzmiało `tabletime` zamiast tego, zedytujcie tę
jedną linię i potwierdźcie, że `./gradlew test` nadal przechodzi, zanim
zrobicie pierwszy commit. **Nie** uruchamiajcie `gradle init` ani
żadnej komendy generującej Gradle wrapper wewnątrz Waszego nowego
repozytorium — to utworzyłoby drugi, inny wrapper i prawdopodobnie
skonfliktowałoby się z tym, który właśnie skopiowaliście.

Zakończcie checkpointem wspólnym dla każdego tracku:

```text
Team repository exists
→ correct starter copied
→ tests green
→ commit
→ push
→ teammates can clone and run tests
```

Zacommitujcie starter jako Wasz własny pierwszy prawdziwy commit
projektu (na przykład `feat: add <language> project starter`),
wypushujcie, i — jeśli jesteście zespołem — niech każdy kolega/
koleżanka zrobi `git pull` i uruchomi lokalnie komendę testów swojego
tracku, potwierdzając zielony wynik, zanim ktokolwiek napisze choć
jedną linię prawdziwej logiki TableTime.

## Kryteria akceptacji

- `PROJECT_PLAN.md` istnieje i odpowiada na wszystkie sześć punktów z
  Kroku 2 konkretnie, bez placeholderów — włącznie z jednoznacznym
  opisem tego, co znaczy przedział czasowy i jak długo stolik jest
  uznawany za zajęty.
- `docs/adr/adr-001-language-choice.md` istnieje i podaje prawdziwą
  decyzję z prawdziwym uzasadnieniem specyficznym dla tego zespołu, nie
  "wybraliśmy Pythona, bo jest popularny" (albo odpowiednik dla Go czy
  Javy).
- Istnieje nowe repozytorium zespołu, osobne od repozytorium kursowego,
  z głównym `README.md`, skopiowanym starterem, i każdym członkiem
  zespołu zdolnym je sklonować i uruchomić jego testy na zielono.

## Weryfikacja

Nie ma automatycznego sprawdzenia dla planu — zweryfikuj go tak, jak
zrobiłby to recenzent: przeczytaj `PROJECT_PLAN.md` na zimno. Czy ktoś,
kto nie był przy Waszym kickoffie, mógłby stwierdzić, samym
dokumentem, co budujecie, dlaczego podjęliście takie wybory, i czy
dwie podane rezerwacje liczyłyby się jako nakładające się według
Waszego opisanego modelu czasu?

## Zastanów się

- Brief celowo nie mówi, co się dzieje przy nakładających się
  rezerwacjach tego samego stolika. Czy Wasz zespół zauważył tę lukę
  przy pisaniu kryteriów akceptacji, czy dopiero przy ponownym czytaniu
  tego pytania?
- Wasz ADR powinien dać się zrewidować. Jaka konkretna nowa informacja,
  gdyby pojawiła się w Lab 28 albo Lab 29, sprawiłaby, że chcielibyście
  wrócić do ADR-001?
- Musieliście dopracować swój model czasu na tyle precyzyjnie, żeby
  odpowiedzieć "czy te dwie rezerwacje się nakładają?", nie decydując
  jeszcze, czy system *zapobiega* nakładaniu. Dlaczego to dwie różne
  decyzje, i która faktycznie ma znaczenie dla MVP z Lab 27?

## Jeśli utkniesz

- **Podpowiedź 1:** Dobre kryterium akceptacji brzmi jak nazwa testu:
  "utworzenie rezerwacji dla grupy większej niż jakikolwiek stolik
  rzuca błąd", a nie "rezerwacje działają poprawnie".
- **Podpowiedź 2:** Trzymajcie model stolików mały — 4-6 stolików z
  2-3 różnymi pojemnościami wystarczy, żeby kolejne laby były
  interesujące, bez przeprojektowywania kickoffu.
- **Podpowiedź 3:** Jeśli Wasz zespół nie może się zgodzić co do
  języka, wróćcie do porównania z Lab 14 (Python `Protocol` kontra Go
  `interface` kontra Java `implements`) i niech *ta* dyskusja, plus to,
  w którym tracku jesteście najmocniejsi po Akcie V, wpłynie na
  ADR-001 — nie zgadywanie, który język jest "lepszy".
- **Podpowiedź 4:** Jeśli `git remote -v` pokazuje URL Waszego forka
  kursowego zamiast nowego repozytorium zespołu, zaraz zacommitujecie
  TableTime w złym miejscu — zatrzymajcie się i sklonujcie na nowo z
  poprawnego URL (Krok 1), zamiast próbować przekierować `origin` na
  repozytorium, które już ma niepowiązaną historię.

## Co dalej

Macie plan i zapis decyzji. Teraz budujecie tę rzecz, używając każdego
nawyku z Aktu IV, w sposób ciągły.

Przejdź do [Lab 27 — Iteracja rozwojowa](../27-development-iteration/README.pl.md).
