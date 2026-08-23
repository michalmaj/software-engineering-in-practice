# Lab 01 — Witaj na swoim stanowisku pracy

## Sytuacja

Właśnie dołączyłeś/aś do projektu. Ktoś podał Ci laptopa albo, jak w tym
przypadku, świeżego GitHub Codespace'a. Zanim zmienisz choćby jedną linijkę
kodu, musisz wiedzieć, gdzie jesteś, co jest dookoła i jak się poruszać.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Ustalić swoją bieżącą lokalizację w systemie plików i poruszać się między
  katalogami.
- Wylistować pliki, w tym ukryte, i odczytać podstawowy wynik listowania w
  formacie długim.
- Tworzyć i sprawdzać pliki oraz katalogi z poziomu terminala.
- Wyjaśnić własnymi słowami, czym są `$HOME`, `$PATH` i bieżąca powłoka.

## Zanim zaczniesz

- Masz otwarte środowisko (Codespaces albo lokalne — zobacz główny
  [`README.pl.md`](../../README.pl.md)).
- Masz otwarty zintegrowany terminal.
- Żadne wcześniejsze laboratorium nie jest wymagane — to jest pierwsze.

## Twoje zadanie

Pracując wyłącznie w terminalu:

1. Sprawdź swój bieżący katalog, potem przejdź do katalogu domowego i
   potwierdź, że tam jesteś.
2. Wylistuj zawartość katalogu domowego, wliczając pliki ukryte.
3. Utwórz katalog `lab01-notes` wewnątrz katalogu domowego.
4. W jego wnętrzu utwórz plik `findings.txt`.
5. Uruchom `echo "$SHELL"` i przeczytaj, co wypisuje — to Twoja bieżąca
   powłoka.
6. Zapisz do `findings.txt` wynik tych pięciu poleceń, po jednym w linii,
   opisanych etykietą: `whoami`, `uname -a`, `echo "$HOME"`,
   `echo "$PATH"`, `echo "$SHELL"`. Nie poznałeś/aś jeszcze edytora
   tekstu, więc użyj tej jednej małej sztuczki: `>>` dopisuje linię
   wyniku polecenia do pliku bez otwierania czegokolwiek —
   `echo "whoami: $(whoami)" >> ~/lab01-notes/findings.txt` dodaje
   jedną opisaną linię. Powtórz dla każdego z pięciu poleceń. (Poznasz
   `>>` porządnie, razem z `>` i `|`, w Lab 02 — to jeden element,
   którego potrzebujesz wcześniej, żeby skończyć ten lab.)
7. Użyj `which`, żeby sprawdzić, gdzie na dysku faktycznie znajdują się
   programy `python3` i `git`.
8. Otwórz `findings.txt` poleceniem `less` i potwierdź jego zawartość.

## Kryteria akceptacji

- `~/lab01-notes/findings.txt` istnieje i zawiera pięć opisanych linii z
  prawdziwym wynikiem z Twojej maszyny (nie wymyślonym).
- Potrafisz, bez ponownego sprawdzania, podać ścieżkę swojego katalogu
  domowego i nazwę swojej bieżącej powłoki.
- Potrafisz w jednym lub dwóch zdaniach wyjaśnić, do czego służy `$PATH`.

## Weryfikacja

```bash
test -f ~/lab01-notes/findings.txt && echo "file exists"
wc -l < ~/lab01-notes/findings.txt   # oczekiwane co najmniej 5
which python3
which git
```

Jeśli obie komendy `which` wypisują ścieżkę (a nie błąd), Twoje narzędzia są
osiągalne z poziomu powłoki.

## Zastanów się

- Co by się stało, gdyby `$PATH` nie zawierał katalogu, w którym znajduje
  się `git`?
- Dwa różne konta na tej samej maszynie mogą mieć różne `$HOME`. Dlaczego
  ma to znaczenie dla skryptu, który zakłada stałą lokalizację pliku?

## Jeśli utkniesz

- **Podpowiedź 1:** Każde z tych zadań odpowiada dokładnie jednemu krótkiemu
  poleceniu. Nie potrzebujesz żadnych nowych flag poza `-la` do listowania
  ukrytych plików i `-a` dla `uname`.
- **Podpowiedź 2:** Potrzebne polecenia to: `pwd`, `cd`, `ls -la`, `mkdir`,
  `touch`, `cat`, `whoami`, `uname -a`, `echo`, `which`, `less`.
- **Podpowiedź 3:** Jeśli nie jesteś pewien/pewna, czy sztuczka z `>>`
  zadziałała, uruchom potem `cat ~/lab01-notes/findings.txt` i potwierdź,
  że wszystkie pięć linii tam jest — każde dopisanie powinno dodać
  dokładnie jedną nową linię.

## Co dalej

Potrafisz już poruszać się i sprawdzać swoje środowisko. Dalej terminal
przestaje być miejscem do uruchamiania jednego polecenia na raz —
zaczniesz łączyć polecenia i zarządzać uruchomionymi procesami.

Przejdź do [Lab 02 — Terminal jako narzędzie pracy](../02-terminal/README.pl.md).
