# Lab 11 — Klient zmienił zdanie

## Sytuacja

Właściciel restauracji mówi: "Chcemy, żeby kelnerzy mogli wpisać kod
rabatowy przy kasie." To całe zlecenie. Żadnej wzmianki o tym, jakie
kody, ile są warte, czy łączą się z istniejącym rabatem lojalnościowym,
ani co się dzieje, gdy ktoś się pomyli przy wpisywaniu.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Zamienić niejasne zlecenie na listę konkretnych pytań doprecyzowujących.
- Zamienić ustalone wymaganie na konkretne przykłady wejście/wyjście.
- Wyjaśnić, dlaczego "co się dzieje przy niepoprawnych danych wejściowych"
  samo w sobie jest wymaganiem, a nie szczegółem implementacji.

## Zanim zaczniesz

- Laby 06-10 ukończone.
- Brak kodu w tym labie — to wyłącznie analiza wymagań.

## Twoje zadanie

1. Zanim przeczytasz dalej, zapisz co najmniej pięć pytań, które
   zadałbyś/zadałabyś właścicielowi restauracji o "kodach rabatowych
   przy kasie". Umieść je w
   `labs/11-changed-requirements/my-clarifying-questions.md`. Pomyśl o:
   jakie kody istnieją, ile jest wart każdy, czy łączą się z istniejącym
   rabatem lojalnościowym, co się dzieje przy nierozpoznanym kodzie i
   czy więcej niż jeden kod może być użyty na zamówienie.
2. Teraz przeczytaj ustaloną specyfikację poniżej — to jest to, co
   właściciel naprawdę miał na myśli, gdy ktoś zapytał:

   - Istnieją dokładnie dwa kody rabatowe: `SAVE10` i `SAVE5`.
   - `SAVE10` zdejmuje 10% z kwoty, która pozostaje *po* zastosowaniu
     istniejącego rabatu lojalnościowego.
   - `SAVE5` zdejmuje płaskie $5 z tej samej pozostałej kwoty.
   - Co najwyżej jeden kod rabatowy może być użyty na zamówienie.
   - Nierozpoznany kod to błąd — system musi odmówić realizacji
     zamówienia, a nie po cichu naliczyć pełną cenę.
3. W tym samym pliku notatek dodaj tabelę z co najmniej czterema
   konkretnymi przykładami obejmującymi: zamówienie z `SAVE10`,
   zamówienie z `SAVE5`, zamówienie bez żadnego kodu i zamówienie z
   kodem, który nie istnieje. Dla każdego podaj, co powinno się stać
   (suma albo błąd).

## Kryteria akceptacji

- `my-clarifying-questions.md` zawiera co najmniej pięć odrębnych pytań
  doprecyzowujących, napisanych *przed* przeczytaniem ustalonej
  specyfikacji.
- Ten sam plik zawiera tabelę przykładów z co najmniej czterema
  wierszami obejmującymi scenariusze z kroku 3.

## Weryfikacja

```bash
test -f labs/11-changed-requirements/my-clarifying-questions.md && echo "notes exist"
grep -c '^[0-9]\.' labs/11-changed-requirements/my-clarifying-questions.md
```

Nie ma automatycznego sprawdzenia *treści* analizy wymagań — to
laboratorium weryfikujesz, ponownie czytając własne notatki i
potwierdzając, że każdy przykład rozstrzyga się jednoznacznie.

## Zastanów się

- Z pięciu pytań, które napisałeś/aś, ile już było odpowiedzianych przez
  ustaloną specyfikację? Ile nie było — i co zrobiłbyś/zrobiłabyś z
  nimi w prawdziwym projekcie?
- "Nierozpoznany kod to błąd" samo w sobie jest decyzją projektową, a
  nie oczywistym domyślnym zachowaniem. Co zmieniłoby się w zachowaniu
  systemu, gdyby właściciel powiedział zamiast tego "po prostu ignoruj
  kody, których nie rozpoznajemy"?

## Jeśli utkniesz

- **Podpowiedź 1:** Dobre pytania doprecyzowujące mają odpowiedź w
  postaci konkretnego faktu, a nie "to zależy". "Czy kody rabatowe
  wygasają?" jest lepsze niż "jak powinny działać kody rabatowe?".
- **Podpowiedź 2:** Dla tabeli przykładów wybierz konkretne liczby —
  rzeczywistą sumę zamówienia, rzeczywisty kod, rzeczywisty oczekiwany
  wynik — a nie opisy w stylu "jakieś zamówienie".
- **Podpowiedź 3:** Jeśli nie jesteś pewien/pewna, czy `SAVE10`
  stosuje się przed czy po rabacie lojalnościowym, przeczytaj ponownie
  ustaloną specyfikację — mówi to wprost.

Zanim pójdziesz dalej: zacommituj i wypchnij wszystko z tego laba
(`git add -A && git commit -m "..."; git push`). Nic później jeszcze
nie zakłada czystego drzewa, ale Akt IV (od Lab 16) już tak — wyrób
sobie ten nawyk już teraz.

## Co dalej

Wiesz już dokładnie, co trzeba zbudować. Teraz: gdzie w kodzie ta
zmiana właściwie powinna trafić?

Przejdź do [Lab 12 — Gdzie powinna trafić ta zmiana?](../12-change-surface/README.pl.md).
