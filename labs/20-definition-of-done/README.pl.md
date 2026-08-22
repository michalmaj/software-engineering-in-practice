# Lab 20 — Co oznacza "zrobione"?

## Sytuacja

Dwoje kolegów z zespołu się nie zgadza: jedno mówi, że zadanie jest
zrobione, gdy testy przechodzą; drugie mówi, że nie jest zrobione,
dopóki nie jest faktycznie zmergowane, a sprawdzenie CI zielone. Oboje
mają rację, i oboje mają niepełny obraz.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Napisać konkretną, sprawdzalną Definition of Done dla konkretnego
  rodzaju projektu.
- Odróżnić kryterium sprawdzalne ("CI jest zielone") od mglistego
  ("kod jest dobry").
- Ocenić ukończoną pracę względem pisemnego standardu, a nie
  wrażenia.

## Zanim zaczniesz

- Laby 06-19 ukończone.
- Brak kodu w tym labie — przejrzyj (nie odtwarzaj od nowa) sekcje
  "Kryteria akceptacji" Labów 11 do 19, zanim zaczniesz.

## Twoje zadanie

1. Napisz `labs/20-definition-of-done/definition-of-done.md`
   zawierający jedną checklistę Definition of Done, 5-8 pozycji,
   używając checkboxów markdown (`- [ ] pozycja`), która miałaby
   zastosowanie do *każdej* przyszłej zmiany w
   `examples/team-inventory`. Oprzyj ją na tym, czego faktycznie
   użyłeś/aś w Labach 06-19 — testy, review, CI, dokumentacja — a nie
   na generycznej liście, na którą jeszcze nie zapracowałeś/aś.
2. Każda pozycja musi być sprawdzalna: odpowiadalna tak lub nie przez
   spojrzenie na coś konkretnego (kod wyjścia polecenia, istnienie
   pliku, stan PR-a) — a nie "kod jest czysty" czy "działa dobrze".
3. Wybierz jeden konkretny wcześniejszy lab (11 do 19) i, w tym samym
   pliku, sprawdź jego faktyczny wynik względem własnej checklisty,
   pozycja po pozycji. Tam, gdzie nie spełnia w pełni pozycji, powiedz
   to szczerze.

## Kryteria akceptacji

- `definition-of-done.md` ma między 5 a 8 pozycji checklisty, każda
  niezależnie sprawdzalna.
- Retrospektywne sprawdzenie względem jednego nazwanego wcześniejszego
  laba jest uwzględnione, z uczciwą odpowiedzią dla każdej pozycji
  (nie domyślnie wszystko "tak").

## Weryfikacja

```bash
test -f labs/20-definition-of-done/definition-of-done.md && echo "DoD exists"
grep -c '^- \[' labs/20-definition-of-done/definition-of-done.md
```

Oczekiwane: plik istnieje, a liczba jest między 5 a 8.

## Zastanów się

- Czy Definition of Done to koncepcja techniczna, czy koncepcja
  umowy zespołowej? Czy dwa różne zespoły, pracujące nad podobnej
  wielkości projektami, mogłyby zasadnie dojść do dwóch różnych, obu
  ważnych Definition of Done?
- Która pozycja na Twojej liście byłaby niemożliwa do napisania,
  zanim istniał Lab 19? Co to mówi o tym, jak Definition of Done
  ewoluuje razem z narzędziami samego projektu?

## Jeśli utkniesz

- **Podpowiedź 1:** Rozsądne kandydatki na pozycje: testy przechodzą
  lokalnie, testy przechodzą w CI, PR ma opis wyjaśniający dlaczego,
  co najmniej jeden komentarz recenzji został uwzględniony, żadne
  znaczniki konfliktu nigdzie nie pozostają, zmiana jest zmergowana
  (nie tylko otwarta jako PR).
- **Podpowiedź 2:** Jeśli pozycji nie da się sprawdzić uruchamiając
  polecenie albo patrząc na konkretny stan, przepisz ją, aż się da.
- **Podpowiedź 3:** Co do stylu dobrego pliku checklisty/notatek,
  spójrz jeszcze raz na `COMPARISON.md` z Lab 12 albo `my-notes.md` z
  Lab 15.

## Co dalej

Akt IV jest zakończony — potrafisz bezpiecznie pracować z zespołem:
rozgałęziać, rozwiązywać konflikty, recenzjować i pozwolić CI wyłapać
to, co przeoczy review. Dalej oprogramowanie musi przetrwać kontakt ze
światem zewnętrznym: innymi systemami, przechowywanymi danymi i
awariami, które nie są niczyją winą.

Akt V (Lab 21) będzie kontynuowany w kolejnym etapie kursu.
