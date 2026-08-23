# Lab 29 — Incydent produkcyjny

## Sytuacja

Menedżer restauracji dzwoni, zirytowany: "W zeszłą sobotę dwie grupy
pojawiły się o 19:00, obie z potwierdzeniem na stolik 4. Musieliśmy się
gimnastykować. To nie może się powtórzyć."

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Odtworzyć zgłoszony incydent jako konkretny, failing test, zanim
  dotkniesz kodu implementacji.
- Naprawić prawdziwy defekt, nie psując żadnego wcześniej
  przechodzącego zachowania.
- Napisać bezstronny (blameless) postmortem skupiony na systemie i
  procesie, a nie na tym, kto napisał którą linię.

## Zanim zaczniesz

- Lab 28 ukończony: wsparcie łączonych stolików dla dużych grup jest
  zmergowane.

## Twoje zadanie

**Incydent (przekaż go swojemu zespołowi w tej formie):**

> W sobotni wieczór dwie osobne rezerwacje obie dostały przydzielony
> stolik 4 na 19:00. Obie grupy przyszły, oczekując tego stolika.
> Odtwórz to, napraw, i upewnij się, że nie może się to powtórzyć — ani
> po cichu, ani jawnie.

Podążaj **Ścieżką A**, jeśli da się to odtworzyć w Waszym systemie
dzisiaj. Podążaj **Ścieżką B**, jeśli Wasz zespół już zapobiega
dokładnie takiej samej podwójnej rezerwacji dzień/przedział czasowy —
nie wymuszajcie fałszywego błędu w żadną stronę.

**Ścieżka A — błąd jest prawdziwy:**

1. Odtwórz go: utwórz dwie rezerwacje na ten sam dzień i dokładnie ten
   sam przedział czasowy, na tyle małe, że Wasza logika przydziału
   daje obu ten sam stolik.
2. Napisz failing test uchwytujący dokładny defekt: dwie rezerwacje na
   ten sam dzień/przedział czasowy nigdy nie mogą dostać nakładającego
   się zestawu stolików.
3. Napraw defekt najmniejszą zmianą, która sprawia, że nowy test
   przechodzi, nie psując żadnego istniejącego testu.
4. Przejdź do kroku 5 poniżej.

**Ścieżka B — już temu zapobiegacie:**

1. Napisz test *dowodzący*, że ochrona istnieje (dwie rezerwacje, ten
   sam dokładny dzień/przedział czasowy, muszą dostać nienakładające
   się stoliki) — powinien już przechodzić, demonstrując pokrycie, a
   nie je tworząc.
2. Teraz zejdź o poziom głębiej: dwie rezerwacje na *tym samym
   stoliku*, tego samego dnia, w porach będących różnymi stringami,
   ale które realistycznie nakładałyby się w prawdziwej sali — na
   przykład `19:00` i `19:15`, jeśli stolik jest zajęty przez około 90
   minut. Odtwórz to na własnym systemie.
3. Napisz failing test uchwytujący to: rezerwacje, których przedziały
   czasowe mieszczą się w zakładanym oknie zajętości Waszego systemu,
   nie mogą dzielić stolika, nawet jeśli stringi przedziałów czasowych
   nie są identyczne.
4. Napraw to — to prawdopodobnie będzie wymagało potraktowania
   `time_slot` jako porównywalnej wartości czasu z czasem trwania, a
   nie tylko stringa do porównania na dokładną równość. Przejdź do
   kroku 5 poniżej.

**Obie ścieżki:**

5. Napisz `POSTMORTEM.md`, bezstronny — bez nazwisk, bez obwiniania —
   obejmujący: co się stało, wpływ na klienta, główną przyczynę (lukę
   projektową, nie narrację "ktoś popełnił błąd"), jak to wykryto
   (skarga klienta, nie alert monitoringu — zanotujcie to jawnie),
   poprawkę, dodany test regresyjny, i jedną konkretną zmianę systemową
   albo procesową, która zmniejszyłaby szansę powtórzenia się tej klasy
   awarii. Jeśli podążaliście Ścieżką B, zanotujcie też w postmortemie,
   że oryginalny projekt Waszego zespołu już pokrywał prostszy
   przypadek, i opiszcie zamiast tego znalezioną głębszą lukę.

## Kryteria akceptacji

- **Ścieżka A:** istnieje test regresyjny, nie przechodzi przed
  poprawką i przechodzi po niej, nie psując żadnego wcześniejszego
  testu.
- **Ścieżka B:** test dowodzi istniejącej ochrony tego samego
  przedziału, *a* drugi test dla przypadku nakładających-się-ale-innych
  przedziałów nie przechodzi przed swoją poprawką i przechodzi po niej,
  nie psując żadnego wcześniejszego testu.
- `POSTMORTEM.md` istnieje, jest bezstronny i kończy się konkretną
  rekomendacją systemową — nie tylko "być bardziej ostrożnym".

## Weryfikacja

```bash
# from your team's own repository
<your test command>
```

Oczekiwane: pełny zestaw zielony, włącznie z nowym testem regresyjnym
podwójnej rezerwacji.

## Zastanów się

- Brief z Lab 26 nigdy nie wymagał zapobiegania podwójnej rezerwacji.
  Czy to pominięcie było błędem w briefie, czy realistycznym
  odzwierciedleniem tego, jak prawdziwe specyfikacje zostawiają luki,
  które ujawniają się dopiero, gdy coś się psuje?
- Sekcja "jak to wykryto" Waszego postmortemu powinna być uczciwa.
  Jeśli uczciwa odpowiedź brzmi "klient się poskarżył, nie nasze testy
  ani monitoring", co to sugeruje o tym, co nawyki obserwowalności z
  Lab 24 powinny były pokryć w Waszym własnym projekcie?

## Jeśli utkniesz

- **Podpowiedź 1:** Jeśli jesteście na Ścieżce B, niebezpieczne
  pominięcie nakładających się przedziałów jest konkretne: wybierzcie
  stały czas zajętości (powiedzmy, 90 minut) dla każdej rezerwacji,
  przeliczcie stringi `time_slot` na minuty-od-północy do porównania, i
  traktujcie dwie rezerwacje na tym samym stoliku jako konfliktujące,
  jeśli ich okna zajętości w ogóle się nakładają — nie tylko jeśli ich
  surowe stringi się zgadzają.
- **Podpowiedź 2:** Bezstronny postmortem opisuje, co *system*
  dopuścił, nie co *osoba* zrobiła źle — "logika przydziału nie
  sprawdzała istniejących rezerwacji", a nie "ktoś zapomniał dodać
  sprawdzenie".
- **Podpowiedź 3:** Test regresyjny powinien zawodzić z tego samego
  powodu, dla którego poskarżyłby się prawdziwy klient — sprawdzajcie
  bezpośrednio nakładanie się stolików, nie jakiś pośredni objaw.

## Co dalej

Wasz projekt przetrwał prawdziwą zmianę wymagań i prawdziwy incydent, z
testami, review i CI wspierającymi każdy krok. Ostatni krok: udowodnijcie,
że ktoś inny niż Wasz własny zespół może go przejąć i kontynuować.

Przejdź do [Lab 30 — Handover](../30-handover/README.pl.md).
