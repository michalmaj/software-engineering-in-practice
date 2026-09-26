# Lab 30 — Handover

## Sytuacja

Zaangażowanie Waszego zespołu w TableTime się kończy. Przejmuje je inny
zespół — nowi ludzie, bez dostępu do Waszej pamięci o tym, dlaczego
cokolwiek zostało zbudowane tak, a nie inaczej. Wszystko, czego
potrzebują, musi już być w repozytorium.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Przygotować projekt tak, żeby obcy mógł go skonfigurować i uruchomić
  jego sprawdzenia, używając wyłącznie tego, co jest spisane.
- Ocenić, z perspektywy strony odbierającej, czy handover faktycznie
  się udał.
- Wprowadzić małą, prawdziwą zmianę w nieznanym kodzie w ograniczonym
  czasie, nie pytając oryginalnych autorów.

## Zanim zaczniesz

- Lab 29 ukończony: Wasze MVP, zmiana wymagań i poprawka incydentu są
  wszystkie zmergowane, przetestowane i udokumentowane.
- Jeśli jesteś w klasie: instruktor paruje Wasz zespół z innym do
  wymiany. Jeśli solo: ocenisz własny projekt jako "zespół
  odbierający", udając, że nigdy go nie widziałeś/aś.

## Twoje zadanie

**Jeśli przekazujecie (zespół oryginalny):**

1. Upewnijcie się, że sam główny `README.md` wystarczy, żeby ktoś
   wiedział: czym jest TableTime, jak sklonować repo, co zainstalować,
   jak uruchomić zestaw testów i jak uruchomić aplikację raz.
2. Dodajcie krótki `ARCHITECTURE.md` (kilka akapitów, nie pełny
   dokument projektowy) wskazujący nowej osobie, gdzie mieszka główna
   logika, i linkujący do `docs/adr/adr-001-language-choice.md` po
   uzasadnienie wyboru języka.
3. Potwierdźcie, że CI jest zielone na głównej gałęzi w momencie
   handoveru.
4. Nie brifujcie zespołu odbierającego ustnie poza dwuminutowym
   wprowadzeniem — resztę musi unieść repozytorium.

**Jeśli odbieracie (albo oceniacie własny projekt solo):**

Nie masz uprawnień do zapisu w repozytorium zespołu oryginalnego i nie
powinieneś/aś ich potrzebować — cała ta ścieżka działa przez fork i
pull request, tak samo jak zewnętrzny kontrybutor pracowałby z
dowolnym projektem, którego nie jest właścicielem.

5. Zrób fork repozytorium zespołu oryginalnego na GitHubie, potem
   sklonuj *swój własny fork* do świeżej lokalizacji, której wcześniej
   nie dotykałeś/aś.
6. Podążajcie wyłącznie za spisanym `README.md`, żeby skonfigurować
   projekt i uruchomić jego sprawdzenia. Nie zadawajcie jeszcze
   oryginalnemu zespołowi pytania doprecyzowującego — zanotujcie
   wszędzie, gdzie utknęliście albo musieliście zgadywać.
7. Przejrzyjcie `ARCHITECTURE.md` i kod na tyle, żeby zlokalizować,
   gdzie wprowadzilibyście małą zmianę.
8. Utwórz gałąź w swoim własnym forku i wprowadź jedną małą, prawdziwą
   zmianę w ustalonym limicie czasu (30 minut to rozsądnie): dodaj nową
   możliwość tylko-do-odczytu (na przykład "znajdź rezerwację po jej
   id") z własnym testem, spraw, żeby przechodził razem z istniejącym
   zestawem testów, a potem wypchnij gałąź do swojego forka.
9. Otwórz pull request z Twojego forka z powrotem do repozytorium
   zespołu oryginalnego. Czy go zmergują, to ich decyzja, nie wymóg
   tego laba — otwarcie poprawnego, gotowego do review PR-a do repo,
   którego nie jesteś właścicielem, to jest faktyczna umiejętność, którą
   ten lab sprawdza.
10. Napiszcie `HANDOVER_NOTES.md` (ze strony odbierającej) odpowiadając:
    co zadziałało samą dokumentacją, co nie, i jaka jedna zmiana w
    README albo dokumentacji oryginalnego zespołu zaoszczędziłaby Wam
    najwięcej czasu. Umieśćcie to w tym samym pull requeście (albo
    zlinkujcie z jego opisu), żeby feedback faktycznie dotarł do
    zespołu oryginalnego, nie tylko do Waszego forka.

## Kryteria akceptacji

- `README.md` i `ARCHITECTURE.md` zespołu oryginalnego istnieją i
  wystarczają same w sobie (zweryfikowane przez faktyczne użycie ich
  przez stronę odbierającą, i tylko ich).
- Strona odbierająca pomyślnie skonfigurowała projekt, uruchomiła jego
  sprawdzenia na zielono, i otworzyła pull request — z własnego forka,
  nie z gałęzi w repozytorium oryginalnym — z jedną małą, przetestowaną
  zmianą, bez bezpośredniej pomocy oryginalnych autorów.
- `HANDOVER_NOTES.md` istnieje z konkretnym, uczciwym feedbackiem — nie
  "poszło dobrze" — i dociera do zespołu oryginalnego przez PR.

## Weryfikacja

```bash
# from the receiving side, in a completely fresh clone
<the setup commands from the originating team's README>
<the test command from the originating team's README>
```

Oczekiwane: oba się udają, używając wyłącznie tego, co spisane w
repozytorium.

## Zastanów się

- Który fragment kontekstu nosiłeś/aś osobiście w głowie, a który
  nigdy nie trafił do README, `ARCHITECTURE.md` ani ADR-a? Dlaczego
  wydawał się wtedy niepotrzebny do zapisania?
- Zespół oryginalny jest oceniany częściowo po tym, jak dobrze inny
  zespół mógł pracować z ich projektem, a nie po tym, jak pewny siebie
  czuł się zespół oryginalny. Czy to uczciwy sposób mierzenia jakości
  inżynierskiej? Co uchwytuje, czego nie uchwytuje "czy testy
  przechodziły"?

## Jeśli utkniesz

- **Podpowiedź 1:** Jeśli strona odbierająca utknie na kroku 6, to
  dane, nie porażka — zanotujcie dokładnie gdzie, a to stanie się
  najcenniejszą linią w `HANDOVER_NOTES.md`.
- **Podpowiedź 2:** Dobry `ARCHITECTURE.md` odpowiada "od czego w ogóle
  zacząć czytanie" w kilku zdaniach — nie jest substytutem czytelnego
  kodu i nie powinien próbować wyjaśnić każdego pliku.
- **Podpowiedź 3:** Trzymajcie przydzieloną małą zmianę naprawdę małą
  i głównie-do-czytania (wyszukiwanie, filtr, pomocnik formatowania) —
  ten lab dotyczy jakości handoveru, nie testowania surowej szybkości
  implementacji zespołu odbierającego.
- **Podpowiedź 4:** Jeśli repozytorium zespołu oryginalnego jest
  prywatne i forkowanie nie jest proste w Waszej organizacji, dodanie
  jako collaborator jest rozsądnym zamiennikiem — ale fork-i-PR to
  ścieżka, przez którą ten lab faktycznie przechodzi, bo to ta, która
  działa bez konieczności ręcznego zarządzania uprawnieniami do
  repozytorium przez kogokolwiek.

## Co dalej

To ostatnie laboratorium. Przeszedłeś/aś od odnajdywania się w
terminalu do przekazania przetestowanego, zrecenzowanego, odpornego na
incydenty projektu, który ktoś inny może przejąć i kontynuować. To
ostatnie zdanie to właściwa definicja inżynierii oprogramowania, o którą
ten kurs się dopominał od Lab 01.
