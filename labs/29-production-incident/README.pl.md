# Lab 29 — Incydent produkcyjny

## Sytuacja

Menedżer restauracji dzwoni, zirytowany: "W zeszłą sobotę dwie grupy
pojawiły się o 19:00, obie z potwierdzeniem na stolik 4. Musieliśmy się
gimnastykować. To nie może się powtórzyć."

## Cele nauki

Po tym labie potrafisz:

- Odtworzyć zgłoszony incydent jako konkretny, failing test, zanim
  dotkniesz kodu implementacji.
- Naprawić prawdziwy defekt, nie psując żadnego wcześniej
  przechodzącego zachowania.
- Napisać bezstronny (blameless) postmortem skupiony na systemie i
  procesie, a nie na tym, kto napisał którą linię.
- Uczciwie obsłużyć zgłoszenie incydentu, nawet gdy okaże się
  nieodtwarzalne na Waszym własnym systemie, bez udawania naprawy
  czegoś, co nigdy nie było faktycznie zepsute.

## Zanim zaczniesz

- Lab 28 ukończony: wsparcie łączonych stolików dla dużych grup jest
  zmergowane.

## Twoje zadanie

**Incydent (przekaż go swojemu zespołowi w tej formie):**

> W sobotni wieczór dwie osobne rezerwacje obie dostały przydzielony
> stolik 4 na 19:00. Obie grupy przyszły, oczekując tego stolika.
> Odtwórz to, napraw, i upewnij się, że nie może się to powtórzyć — ani
> po cichu, ani jawnie.

Zanim wybierzecie ścieżkę: sprawdźcie to na *własnym* systemie, tak
jak faktycznie się zachowuje, nie względem ramowania `19:00`/`7pm`
powyższej skargi — tak klient opisuje problem, to nie jest stwierdzenie
o Waszym wewnętrznym modelu danych. Podążajcie **Ścieżką A**, jeśli
dwie rezerwacje na ten sam dzień i ten sam przedział czasowy (w
jakiejkolwiek formie przyjmuje Wasz model czasu z Lab 26) mogą dziś
dostać nakładające się stoliki. Podążajcie **Ścieżką B**, jeśli ten
dokładny przypadek jest już zapobiegany, ale nie sprawdziliście jeszcze
subtelniejszego wariantu. Podążajcie **Ścieżką C**, jeśli naprawdę nie
potraficie odtworzyć żadnej wersji tego incydentu, włącznie z tą
subtelniejszą. Nie wymuszajcie fałszywego błędu w żadną z tych ścieżek
i nie wymuszajcie poprawki tam, gdzie nie jest potrzebna.

1. Utwórz gałąź dla tej poprawki (na przykład `fix/double-booking`).
   Incydent pod presją to dokładnie moment, w którym pojawia się
   kuszenie, żeby zacommitować bezpośrednio na `main` i pominąć
   branch/PR/review — to jest dokładnie moment, dla którego ten
   workflow istnieje. Nic w tym, że to incydent, go nie zawiesza.

**Ścieżka A — błąd jest prawdziwy:**

2. Odtwórz go: utwórz dwie rezerwacje na ten sam dzień i dokładnie ten
   sam przedział czasowy, na tyle małe, że Wasza logika przydziału
   daje obu ten sam stolik.
3. Napisz failing test uchwytujący dokładny defekt: dwie rezerwacje na
   ten sam dzień/przedział czasowy nigdy nie mogą dostać nakładającego
   się zestawu stolików.
4. Napraw defekt najmniejszą zmianą, która sprawia, że nowy test
   przechodzi, nie psując żadnego istniejącego testu.
5. Przejdź do kroku 6 poniżej.

**Ścieżka B — dokładny przypadek jest już zapobiegany:**

2. Napisz test *dowodzący*, że ochrona istnieje (dwie rezerwacje, ten
   sam dokładny dzień/przedział czasowy, muszą dostać nienakładające
   się stoliki) — powinien już przechodzić, demonstrując pokrycie, a
   nie je tworząc.
3. Teraz zejdźcie o poziom głębiej, używając modelu czasu *Waszego
   własnego zespołu* z Lab 26 — nie ogólnego przykładu zakładającego
   model, którego faktycznie nie zbudowaliście. Znajdźcie prawdziwy,
   dodatkowy przypadek, który Wasze reguły systemu pozwoliłyby
   przeoczyć, coś w stylu:
   - dwóch rezerwacji z nakładającymi się oknami zajętości,
     zaczynającymi się w różnych godzinach zegarowych, jeśli Wasz model
     reprezentuje czas jako wartości zegarowe z zakładanym czasem
     trwania zajętości;
   - rezerwacji używającej stolika, który jest już zaangażowany jako
     połowa połączonej pary z Lab 28, jeśli Wasz model wspiera łączenie
     stolików;
   - innego przypadku, który uczciwie wynika z założeń, które
     faktycznie zapisaliście w `PROJECT_PLAN.md` — nie wymyślonego
     wyłącznie, żeby sfabrykować awarię.

   Jeśli model Waszego zespołu ma tylko garstkę nazwanych, rozłącznych
   slotów (`"lunch"`/`"dinner"`), bez możliwości drobniejszego
   nakładania się z konstrukcji, to na tym poziomie naprawdę może nie
   być głębszej luki do znalezienia — jeśli to prawda dla Waszego
   systemu, powiedzcie to jawnie i przejdźcie do Ścieżki C zamiast
   wymyślać scenariusz, na który Wasz własny projekt faktycznie nie
   pozwala.
4. Odtwórzcie głębszy przypadek, który zidentyfikowaliście, na
   własnym systemie.
5. Napiszcie failing test go uchwytujący: dwie rezerwacje, które
   według reguł Waszego własnego systemu powinny kolidować — według
   faktycznej definicji nakładania się Waszego zespołu z Lab 26, nie
   pożyczonej skądinąd — nie mogą dzielić stolika, nawet jeśli ich
   przechowane wartości nie są identyczne.
6. Napraw to. Przejdź do kroku 7 poniżej.

**Ścieżka C — nie potraficie odtworzyć żadnej wersji tego incydentu:**

Nie fabrykujcie awarii tylko po to, żeby mieć co naprawić. Incydent,
który się nie odtwarza, to wciąż prawdziwa praca i wciąż produkuje te
same cele nauki — próby odtworzenia, dowody, test regresyjny, jeśli
faktycznie czegoś brakowało, i uczciwa dokumentacja — tylko z inną,
równie uczciwą konkluzją.

2. Traktujcie zgłoszenie jako incydent wymagający weryfikacji, nie
   jako potwierdzony defekt. Spróbujcie go odtworzyć, używając tego
   samego przypadku dokładnego-slotu z kroku 2 Ścieżki A, oraz
   głębszego, specyficznego dla Waszego modelu przypadku z kroku 3
   Ścieżki B.
3. Dla każdej próby zapiszcie, co spróbowaliście i co faktycznie się
   stało — test demonstrujący, że ochrona już działa, liczy się jako
   dowód, tak samo jak w Ścieżce B.
4. Jeśli Wasz istniejący zestaw testów nie miał jeszcze testu
   dowodzącego tę konkretną ochronę, dodajcie go teraz — nie dlatego,
   że znaleźliście defekt, ale dlatego, że "ochrona istnieje"
   zasługuje na test tak samo, jak każde inne zachowanie, na którym
   warto polegać.
5. Zapiszcie wprost, czego nie udało się Wam potwierdzić — scenariusz,
   na który zabrakło czasu, obawę o obciążenie albo współbieżność,
   której nie da się łatwo odtworzyć w teście, albo cokolwiek innego
   uczciwego o granicach tego dochodzenia. To należy do sekcji
   ograniczeń `POSTMORTEM.md`, nie do cichego pominięcia.
6. Przejdź do kroku 7 poniżej.

**Wszystkie ścieżki:**

7. Napisz `POSTMORTEM.md`, bezstronny — bez nazwisk, bez obwiniania —
   obejmujący: co zgłoszono, wpływ na klienta, co faktycznie
   znaleźliście (czy to potwierdzony defekt, głębsza luka, czy
   zweryfikowany brak jednego i drugiego), główną przyczynę, jeśli
   istnieje (lukę projektową, nie narrację "ktoś popełnił błąd"), jak
   to zbadano (zaczęło się od skargi klienta, nie alertu monitoringu —
   zanotujcie to jawnie), poprawkę, jeśli była, dodany test regresyjny
   albo potwierdzający, wszelkie ograniczenia tego, co udało się Wam
   zweryfikować (zwłaszcza Ścieżka C), i jedną konkretną zmianę
   systemową albo procesową, która zmniejszyłaby szansę, że tego
   rodzaju problem pozostanie niezauważony w przyszłości, niezależnie
   od tego, którą ścieżką podążaliście. Jeśli podążaliście Ścieżką B,
   zanotujcie też, że oryginalny projekt Waszego zespołu już pokrywał
   prostszy przypadek, i opiszcie zamiast tego znalezioną głębszą
   lukę. Jeśli podążaliście Ścieżką C, powiedzcie to wprost — to była
   weryfikacja, nie naprawa, a postmortem nigdy nie powinien twierdzić,
   że naprawa się wydarzyła, jeśli się nie wydarzyła.
8. Uruchom pełny zestaw testów, potem zacommituj poprawkę (jeśli
   jakaś powstała), test regresyjny albo potwierdzający, i
   `POSTMORTEM.md` na tej gałęzi — razem albo w kilku małych commitach,
   o ile wszystkie trafią przed PR.
9. Wypchnij gałąź, otwórz PR i zdobądź review — review nie musi być
   długie przy oczywistym hotfixie albo opisie weryfikacji, ale wciąż
   musi się wydarzyć. Zmerguj dopiero, gdy CI jest zielone.

## Kryteria akceptacji

- **Ścieżka A:** istnieje test regresyjny, nie przechodzi przed
  poprawką i przechodzi po niej, nie psując żadnego wcześniejszego
  testu.
- **Ścieżka B:** test dowodzi istniejącej ochrony tego samego
  przedziału, *a* drugi test dla głębszego przypadku, specyficznego
  dla Waszego modelu czasu, nie przechodzi przed swoją poprawką i
  przechodzi po niej, nie psując żadnego wcześniejszego testu.
- **Ścieżka C:** co najmniej jeden test dowodzi, że odpowiednie
  ochrony już działają, a `POSTMORTEM.md` jawnie stwierdza, że to była
  weryfikacja, nie naprawa, włącznie z tym, czego nie udało się
  potwierdzić.
- `POSTMORTEM.md` istnieje, jest bezstronny, dokładnie odzwierciedla,
  którą ścieżką podążyliście, i kończy się konkretną rekomendacją
  systemową — nie tylko "być bardziej ostrożnym".
- Poprawka (jeśli jakaś powstała), jej test regresyjny albo
  potwierdzający, i `POSTMORTEM.md` zostały zmergowane przez pull
  request z zielonym checkiem CI, nie zacommitowane bezpośrednio na
  `main` — incydent czy nie.
- Po tym labie `main` zawiera to, co faktycznie wyprodukowała Ścieżka
  A/B/C, plus `POSTMORTEM.md`, a pełny zestaw testów nadal przechodzi.

## Weryfikacja

Uruchom z korzenia repozytorium Waszego zespołu, w zależności od tego,
co ustaliliście w ADR z Lab 26:

### Python

```bash
uv run pytest -v
```

### Go

```bash
go test ./...
```

### Java

```bash
./gradlew test
```

Oczekiwane: pełny zestaw zielony, włącznie z tym, co faktycznie
wyprodukowała Wasza ścieżka — test regresyjny albo potwierdzający.

## Zastanów się

- Brief z Lab 26 nigdy nie wymagał zapobiegania podwójnej rezerwacji.
  Czy to pominięcie było błędem w briefie, czy realistycznym
  odzwierciedleniem tego, jak prawdziwe specyfikacje zostawiają luki,
  które ujawniają się dopiero, gdy coś się psuje?
- Sekcja "jak to zbadano" Waszego postmortemu powinna być uczciwa.
  Jeśli uczciwa odpowiedź brzmi "klient się poskarżył, nie nasze testy
  ani monitoring", co to sugeruje o tym, co nawyki obserwowalności z
  Lab 24 powinny były pokryć w Waszym własnym projekcie?
- Jeśli podążaliście Ścieżką C, w jaki sposób "zweryfikowaliśmy, że
  ochrona już działa, i oto test, który to dowodzi" to faktycznie
  użyteczny wynik dla kogoś, kto przeczyta ten postmortem później — nie
  rozczarowujący brak wydarzenia?

## Jeśli utkniesz

- **Podpowiedź 1:** Jeśli jesteście na Ścieżce B, nie sięgajcie po
  konkretny format zegarowy tylko dlatego, że to popularny przykład —
  wróćcie do tego, co `PROJECT_PLAN.md` faktycznie mówi, że znaczą
  Wasze przedziały czasowe, i znajdźcie głębszy przypadek, na jaki
  *ten* model pozwala. Jeśli Wasz model faktycznie reprezentuje czas
  jako wartości zegarowe z zakładanym czasem trwania zajętości,
  przeliczenie na wspólną jednostkę (powiedzmy, minuty-od-północy) i
  sprawdzenie, czy dwa okna w ogóle się nakładają — nie tylko czy ich
  surowe wartości się zgadzają — to zwykły kształt poprawki.
- **Podpowiedź 2:** Bezstronny postmortem opisuje, co *system*
  dopuścił (albo poprawnie zapobiegł), nie co *osoba* zrobiła źle —
  "logika przydziału nie sprawdzała istniejących rezerwacji", a nie
  "ktoś zapomniał dodać sprawdzenie".
- **Podpowiedź 3:** Test regresyjny albo potwierdzający powinien
  zawodzić (albo demonstrować ochronę) z tego samego powodu, dla
  którego poskarżyłby się prawdziwy klient — sprawdzajcie bezpośrednio
  nakładanie się stolików, nie jakiś pośredni objaw.
- **Podpowiedź 4:** Jeśli naprawdę nie jesteście pewni, czy jesteście
  na Ścieżce A, B czy C, napiszcie najpierw próbę odtworzenia ze
  Ścieżki A (krok 2) — jej wynik powie Wam, na jakiej ścieżce
  faktycznie jesteście, zamiast zgadywać na podstawie samego opisu
  incydentu.

## Co dalej

Wasz projekt przetrwał prawdziwą zmianę wymagań i prawdziwe zgłoszenie
incydentu, z testami, review i CI wspierającymi każdy krok. Ostatni
krok: udowodnijcie, że ktoś inny niż Wasz własny zespół może go
przejąć i kontynuować.

Przejdź do [Lab 30 — Handover](../30-handover/README.pl.md).
