# Lab 30 — Handover

## Sytuacja

Zaangażowanie Waszego zespołu w TableTime się kończy. Przejmuje je inny
zespół — nowi ludzie, bez dostępu do Waszej pamięci o tym, dlaczego
cokolwiek zostało zbudowane tak, a nie inaczej. Wszystko, czego
potrzebują, musi już być w repozytorium.

## Cele nauki

Po tym labie potrafisz:

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
  odbierający", tak jakby widziano go po raz pierwszy.

### Notatka dla prowadzących parujących zespoły

Parujcie zespoły, które użyły **tego samego tracku językowego**,
kiedy tylko możecie — Python z Pythonem, Go z Go, Java z Javą. Zespół
odbierający powinien już mieć zainstalowany toolchain i zapamiętaną
komendę testów z własnej pracy w Akcie V i VI; to właśnie pozwala temu
labowi testować jakość dokumentacji i handover konkretnie, nie to, czy
ktoś potrafi zainstalować toolchain nieznanego języka pod presją czasu.
Jeśli mix językowy zespołów w Waszej klasie naprawdę nie dzieli się
równo na pary w tym samym języku, nie każcie zespołowi instalować
toolchainu, którego nigdy nie używał, tylko po to, żeby wymusić
parowanie — parujcie między językami tylko wtedy, gdy zespół odbierający
już ma dostępny ten toolchain z innego powodu (na przykład z własnego
doświadczenia z Lab 14), i jasno powiedzcie, że faktyczny handover kodu
(kroki 6-9 poniżej) jest opcjonalny, jeśli toolchain naprawdę nie jest
dostępny: dokładny przegląd samej dokumentacji to prawdziwa, uczciwa
alternatywa, ale musi być zaraportowany jako taki w
`HANDOVER_NOTES.md`, nie opisany tak, jakby pełny handover kodu się
wydarzył, gdy się nie wydarzył. Nie wymagajcie Codespaces, żeby to
obejść — model local-first z reszty kursu wciąż tu obowiązuje.

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
powinno się ich potrzebować — cała ta ścieżka działa przez fork i
pull request, tak samo jak zewnętrzny kontrybutor pracowałby z
dowolnym projektem, którego nie jest właścicielem.

5. Zrób fork repozytorium zespołu oryginalnego na GitHubie, potem
   sklonuj *swój własny fork* do świeżej, wcześniej nietkniętej
   lokalizacji.
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

Nie ma tu jednej komendy — cały sens polega na tym, że to własny
`README.md` zespołu oryginalnego definiuje komendy setupu i testów, a
to zależy od tego, jaki język wybrali. Po stronie odbierającej, na
zupełnie świeżym klonie: podążaj za krokami setupu spisanymi w
`README.md` zespołu oryginalnego dokładnie tak, jak są napisane, potem
uruchom komendę testów, którą określa (`uv run pytest`, `go test
./...`, albo `./gradlew test`, zależnie od ich tracku).

Oczekiwane: oba się udają, używając wyłącznie tego, co spisane w
repozytorium.

## Zastanów się

- Jaki fragment kontekstu istniał tylko w Twojej głowie, a nigdy nie
  trafił do README, `ARCHITECTURE.md` ani ADR-a? Dlaczego wydawał się
  wtedy niepotrzebny do zapisania?
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

To ostatnie laboratorium. Zaczęło się od odnajdywania się w terminalu,
a kończy na przekazaniu przetestowanego, zrecenzowanego, odpornego na
incydenty projektu, który ktoś inny może przejąć i kontynuować.
