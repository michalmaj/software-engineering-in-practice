# Lab 02 — Terminal jako narzędzie pracy

## Sytuacja

Wczoraj nauczyłeś/aś się rozglądać. Dziś musisz faktycznie coś zrobić bez
dotykania myszki: skopiować pliki, przeszukać ich zawartość, połączyć
polecenia w łańcuch i uruchomić coś, co działa, dopóki tego nie zatrzymasz.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Kopiować, przenosić i usuwać pliki oraz katalogi z poziomu powłoki.
- Przeszukiwać zawartość plików i znajdować pliki po nazwie.
- Przekierowywać wyjście do pliku i przekazywać wyjście jednego polecenia
  do drugiego.
- Uruchomić długo działający proces, obserwować go i zatrzymać przez
  `Ctrl+C`.

## Zanim zaczniesz

- Lab 01 ukończony (potrafisz nawigować i tworzyć pliki z terminala).
- Bieżący katalog: Twój katalog domowy albo checkout repozytorium — oba
  są w porządku dla tego laboratorium.

## Twoje zadanie

1. Wewnątrz `~/lab01-notes/` skopiuj `findings.txt` do `findings.bak.txt`.
2. Utwórz katalog `~/lab02-notes/` i przenieś do niego `findings.bak.txt`.
3. Wyszukaj w `findings.txt` linię zawierającą `whoami` za pomocą `grep`
   i przekieruj tę jedną pasującą linię do nowego pliku
   `~/lab02-notes/whoami-line.txt`.
4. Użyj `find`, żeby zlokalizować każdy plik o nazwie `findings.txt` w
   Twoim katalogu domowym (powinien być dokładnie jeden, z Lab 01).
5. Uruchom prosty, długo działający serwer:
   `python3 -m http.server 8000` z Twojego katalogu domowego.
6. Gdy działa, w **drugim terminalu** potwierdź, że odpowiada:
   `curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8000/`
   (oczekiwane `200`).
7. Zatrzymaj serwer w pierwszym terminalu przez `Ctrl+C`. Potwierdź w
   drugim terminalu, że to samo polecenie `curl` teraz nie łączy się.

## Kryteria akceptacji

- `~/lab02-notes/findings.bak.txt` oraz `~/lab02-notes/whoami-line.txt`
  istnieją, a ten drugi zawiera dokładnie jedną linię, pasującą do
  `whoami`.
- Potrafisz wskazać dokładne polecenie, które zatrzymało serwer, i
  wyjaśnić, jaki sygnał wysyła `Ctrl+C`.
- Potrafisz wyjaśnić różnicę między `>` a `>>`.

## Weryfikacja

```bash
test -f ~/lab02-notes/findings.bak.txt && echo "backup exists"
test -f ~/lab02-notes/whoami-line.txt && echo "grep output exists"
wc -l < ~/lab02-notes/whoami-line.txt   # oczekiwane dokładnie 1
find ~ -name findings.txt               # oczekiwana dokładnie jedna ścieżka
```

## Zastanów się

- Jaka jest praktyczna różnica między przekazaniem (`|`) jednego polecenia
  do drugiego a przekierowaniem (`>`) do pliku?
- Serwer działał dalej po naciśnięciu Enter w pierwszym poleceniu. Dlaczego
  terminal nie oddał Ci od razu nowego prompta?
- Co zrobiłoby `>` (zamiast `>>`) z `findings.txt`, gdybyś użył/a go przez
  pomyłkę w Lab 01?

## Jeśli utkniesz

- **Podpowiedź 1:** Potrzebujesz `cp`, `mv`, `rm` do operacji na plikach;
  `grep` i `find` do wyszukiwania; `>` i `>>` do przekierowań; `|` do
  przekazywania wyjścia.
- **Podpowiedź 2:** `grep "whoami" plik > wyjscie.txt` zapisuje pasujące
  linie z `plik` do `wyjscie.txt`, nadpisując go, jeśli istnieje.
- **Podpowiedź 3:** Żeby uruchomić polecenie i od razu odzyskać terminal,
  możesz wysłać je w tło przez `&`, ale w tym laboratorium użyj zamiast
  tego drugiej karty/panelu terminala, żeby obserwować oba naraz.

## Co dalej

Potrafisz już uruchamiać rzeczy i sprawdzać ich wynik — ale nie masz
jeszcze sposobu, żeby stwierdzić, co zmieniło się w tym projekcie od
wczoraj, ani żeby cofnąć pomyłkę. Do tego służy system kontroli wersji.

Przejdź do [Lab 03 — Odziedziczyłeś/aś repozytorium](../03-inherited-repository/README.pl.md).
