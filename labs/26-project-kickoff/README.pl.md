# Lab 26 — Kickoff projektu

## Sytuacja

Nie naprawiasz już cudzego projektu. Właściciel restauracji ma
prawdziwy problem i żadnego oprogramowania, żeby go rozwiązać:
"Kelnerzy śledzą rezerwacje stolików na papierze. To wolne, i ciągle
podwójnie rezerwujemy stoliki w busy wieczory." To cały brief. Reszta —
zakres, projekt, język, plan — należy do Was jako zespołu.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Zamienić otwarty problem na spisany zakres, zestaw założeń i
  konkretne kryteria akceptacji MVP.
- Napisać lekki Architecture Decision Record (ADR) uzasadniający
  prawdziwy wybór techniczny dla Waszego konkretnego zespołu i
  problemu.
- Wyprodukować plan kamieni milowych i listę ryzyk dla wielosesyjnego
  projektu.

## Zanim zaczniesz

- Laby 01-25 ukończone.
- Jeśli jesteś w klasie: instruktor przydzielił Cię do zespołu 3-4
  osób. Jeśli pracujesz solo: Ty *jesteś* zespołem — wykonaj każdy krok
  poniżej, włącznie z tymi o przydziale ról, decydując sam/a za siebie.
- Jeszcze bez kodu — ten lab to tylko planowanie.

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
> pojemności miejsc — dokładne liczby ustalasz jako część swojego
> projektu. Rezerwacja musi mieć przydzielony stolik, który pomieści
> grupę.
>
> Nie ma (jeszcze) żadnego wymagania co do tego, co się dzieje, gdy
> dwie rezerwacje trafią na ten sam stolik w nakładających się porach.
> Zdecydujcie sami, czy to ma znaczenie dla tego MVP.

1. Załóżcie teraz prawdziwe repozytorium Waszego zespołu (nowe, osobne
   od tego repozytorium kursowego), z głównym `README.md` wyjaśniającym,
   czym jest TableTime i jak je uruchomić, gdy już powstanie. Wszystko
   od tej chwili powstaje w tym repozytorium, nie w tym.
2. Skopiujcie odpowiedni starter językowy z
   `examples/capstone-starters/<python|go|java>/` (w tym repozytorium
   kursu) do korzenia Waszego nowego repozytorium, gdy już podejmiecie
   decyzję językową w kroku 4 poniżej — zacommitujcie to jako Wasz
   pierwszy prawdziwy commit.
3. Jako zespół napiszcie `PROJECT_PLAN.md` (w Waszym nowym
   repozytorium) obejmujący:
   - **Zakres**: co jest w MVP, co jest jawnie poza nim.
   - **Założenia**: cokolwiek, czego brief nie sprecyzował, a Wy
     zdecydowaliście sami (ile stolików, ich pojemności, czym jest
     "przedział czasowy" — godzina? konkretne okno rezerwacji?).
   - **Kryteria akceptacji**: skąd będziecie wiedzieć, że MVP jest
     gotowe — konkretne, sprawdzalne stwierdzenia, w stylu Definition
     of Done z Lab 20.
   - **Odpowiedzialności**: kto za co odpowiada, jeśli jesteście
     zespołem; jeśli solo, w jakiej kolejności zajmiesz się jakimi
     zagadnieniami.
   - **Plan kamieni milowych**: przybliżone zmapowanie tego, co dzieje
     się w Lab 27 (iteracja), 28 (zmiana wymagań), 29 (incydent) i 30
     (handover).
   - **Największe ryzyka**: 2-3 konkretne rzeczy, które mogłyby wykoleić
     ten projekt, i co byś z każdą zrobił/a.
4. Napiszcie `docs/adr/adr-001-language-choice.md` (w Waszym nowym
   repozytorium) używając tego szablonu:
   ```markdown
   # ADR-001: Wybór języka implementacji

   ## Status
   Zaakceptowany

   ## Kontekst
   [Co budujecie i jakie ograniczenia mają znaczenie — znajomość
   zespołu, cel wdrożenia, dotychczasowe doświadczenie kursowe z
   Pythonem/Go/Javą z Lab 14-15?]

   ## Decyzja
   [Który język: Python, Go czy Java, i dlaczego — dla tego zespołu,
   tego problemu, nie "który język jest najlepszy w ogóle".]

   ## Konsekwencje
   [Co ten wybór ułatwia? Co utrudnia? Co sprawiłoby, że wrócilibyście
   do tej decyzji później?]
   ```

## Kryteria akceptacji

- `PROJECT_PLAN.md` istnieje i odpowiada na wszystkie sześć punktów z
  kroku 1 konkretnie, bez placeholderów.
- `docs/adr/adr-001-language-choice.md` istnieje i podaje prawdziwą
  decyzję z prawdziwym uzasadnieniem, nie "wybraliśmy Pythona, bo jest
  popularny".
- Istnieje nowe repozytorium zespołu, osobne od repozytorium kursowego,
  z co najmniej głównym `README.md`.

## Weryfikacja

Nie ma automatycznego sprawdzenia dla planu — zweryfikuj go tak, jak
zrobiłby to recenzent: przeczytaj `PROJECT_PLAN.md` na zimno. Czy ktoś,
kto nie był przy Waszym kickoffie, mógłby stwierdzić, samym dokumentem,
co budujecie i dlaczego podjęliście takie wybory?

## Zastanów się

- Brief celowo nie mówi, co się dzieje przy nakładających się
  rezerwacjach tego samego stolika. Czy Wasz zespół zauważył tę lukę
  przy pisaniu kryteriów akceptacji, czy dopiero przy ponownym czytaniu
  tego pytania?
- Wasz ADR powinien dać się zrewidować. Jaka konkretna nowa informacja,
  gdyby pojawiła się w Lab 28 albo Lab 29, sprawiłaby, że chcielibyście
  wrócić do ADR-001?

## Jeśli utkniesz

- **Podpowiedź 1:** Dobre kryterium akceptacji brzmi jak nazwa testu:
  "utworzenie rezerwacji dla grupy większej niż jakikolwiek stolik
  rzuca błąd", a nie "rezerwacje działają poprawnie".
- **Podpowiedź 2:** Trzymajcie model stolików mały — 4-6 stolików z
  2-3 różnymi pojemnościami wystarczy, żeby kolejne laby były
  interesujące, bez przeprojektowywania kickoffu.
- **Podpowiedź 3:** Jeśli Wasz zespół nie może się zgodzić co do
  języka, wróćcie do porównania z Lab 14 (Python `Protocol` kontra Go
  `interface` kontra Java `implements`) i niech *ta* dyskusja, a nie
  sama znajomość, wpłynie na ADR-001.

## Co dalej

Macie plan i zapis decyzji. Teraz faktycznie budujecie tę rzecz —
używając każdego nawyku z Aktu IV, naprawdę, w sposób ciągły.

Przejdź do [Lab 27 — Iteracja rozwojowa](../27-development-iteration/README.pl.md).
