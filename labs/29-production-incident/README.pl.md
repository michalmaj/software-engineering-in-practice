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

1. Odtwórz incydent na własnym systemie: utwórz dwie rezerwacje na ten
   sam dzień i przedział czasowy, na tyle małe, że logika przydziału
   stolików z Waszego MVP dałaby obu ten sam stolik (to zależy od
   Waszego własnego projektu z Lab 26-28 — jeśli Wasz zespół już się
   przed tym zabezpieczył, powiedzcie to jawnie i wyjaśnijcie dlaczego,
   zamiast wymuszać błąd, który nie istnieje).
2. Napisz failing test, który uchwyci dokładny defekt: dwie rezerwacje
   na ten sam dzień/przedział czasowy nigdy nie mogą dostać nakładającego
   się zestawu stolików.
3. Napraw defekt najmniejszą zmianą, która sprawia, że nowy test
   przechodzi, nie psując żadnego istniejącego testu.
4. Napisz `POSTMORTEM.md`, bezstronny (bez nazwisk, bez obwiniania),
   obejmujący: co się stało, wpływ na klienta, główną przyczynę (lukę
   projektową z MVP, nie narrację "ktoś popełnił błąd"), jak to
   wykryto (skarga klienta, nie alert monitoringu — zanotujcie to
   jawnie), poprawkę, dodany test regresyjny, i jedną konkretną zmianę
   systemową albo procesową, która zmniejszyłaby szansę powtórzenia się
   tej klasy awarii.

## Kryteria akceptacji

- Istnieje test regresyjny, nazwany konkretnie wokół zapobiegania
  nakładającemu się przydziałowi stolików, który nie przechodzi przed
  poprawką i przechodzi po niej.
- Poprawka nie psuje żadnego testu napisanego w Lab 26-28.
- `POSTMORTEM.md` istnieje, jest bezstronny i kończy się konkretną
  rekomendacją systemową — nie tylko "być bardziej ostrożnym".

## Weryfikacja

```bash
# z Waszego własnego repozytorium zespołu
<Wasze polecenie testowe>
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

- **Podpowiedź 1:** Jeśli Wasz zespół już zapobiegł temu w Lab 26-28
  (projektem albo przypadkiem), nie wymuszajcie fałszywego błędu —
  zamiast tego napiszcie test dowodzący, że ochrona istnieje, i użyjcie
  postmortemu, żeby opisać *powiązane* niebezpieczne pominięcie,
  którego Wasz projekt wciąż nie pokrywa (na przykład: co się dzieje z
  połączonymi stolikami, gdy tylko jeden z pary jest już zajęty?).
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
