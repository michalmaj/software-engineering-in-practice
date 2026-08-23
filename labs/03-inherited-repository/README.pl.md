# Lab 03 — Odziedziczyłeś/aś repozytorium

## Sytuacja

Dostałeś/aś dostęp do tego właśnie repozytorium. Zanim cokolwiek zmienisz,
musisz wiedzieć, jak sprawdzić, w jakim jest stanie, i jak zapisać własną
zmianę, niczego nie tracąc.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Wyjaśnić różnicę między katalogiem roboczym, obszarem stagingu a
  lokalnym repozytorium.
- Sprawdzić bieżący stan repozytorium za pomocą `git status`, `git log` i
  `git diff`.
- Dodać do stagingu i zacommitować zmianę z jasnym komunikatem.

## Zanim zaczniesz

- Lab 02 ukończony.
- Jesteś wewnątrz klona tego repozytorium (Codespaces daje Ci go od razu;
  lokalnie użyj polecenia `git clone` z głównego
  [`README.pl.md`](../../README.pl.md)).
- Bieżący katalog: katalog główny repozytorium.

## Twoje zadanie

1. Uruchom `git status` i `git log` w katalogu głównym repozytorium.
   Przeczytaj wynik, zanim zrobisz cokolwiek innego.
2. Utwórz nowy plik
   `labs/03-inherited-repository/notes/my-observations.txt` zawierający co
   najmniej dwa zdania: jedno opisujące, co pokazał `git status`, drugie
   opisujące, co pokazał `git log`.
3. Uruchom ponownie `git status` i wyjaśnij własnymi słowami (zapisz to w
   tym samym pliku, jako trzecią linię), dlaczego nowy plik pokazuje się
   właśnie w taki sposób.
4. Dodaj do stagingu tylko ten plik poleceniem `git add`.
5. Uruchom `git diff --staged` i zaobserwuj, co pokazuje w porównaniu do
   zwykłego `git diff`.
6. Zacommituj zmianę ze stagingu z jasnym, angielskim komunikatem w czasie
   teraźniejszym, np. `docs: add lab 03 observations`.
7. Uruchom `git log` jeszcze raz i potwierdź, że Twój commit jest na
   szczycie.

## Kryteria akceptacji

- `labs/03-inherited-repository/notes/my-observations.txt` istnieje, jest
  zacommitowany i zawiera co najmniej trzy linie jak opisano wyżej.
- `git log` pokazuje Twój commit z jasnym, angielskim komunikatem.
- Potrafisz wyjaśnić, bez ponownego czytania dokumentacji Gita, co
  oznacza "staged".

## Weryfikacja

```bash
git log --oneline -1                      # your commit should be at HEAD
git status                                 # should be clean (nothing to commit)
test -f labs/03-inherited-repository/notes/my-observations.txt && echo "notes exist"
wc -l < labs/03-inherited-repository/notes/my-observations.txt  # oczekiwane >= 3
```

## Zastanów się

- `git diff` i `git diff --staged` pokazały różne rzeczy. Dlaczego Git w
  ogóle rozróżnia te dwa stany?
- Gdybyś uruchomił/a `git commit` bez wcześniejszego `git add`, co
  stałoby się z Twoim nowym plikiem?

## Jeśli utkniesz

- **Podpowiedź 1:** Potrzebujesz dokładnie pięciu poleceń Gita: `status`,
  `log`, `diff`, `add`, `commit`.
- **Podpowiedź 2:** `git diff` (bez argumentów) pokazuje zmiany poza
  stagingiem; `git diff --staged` pokazuje, co faktycznie trafi do
  następnego commita.
- **Podpowiedź 3:** Commit potrzebuje komunikatu. Użyj `git commit -m
  "twoja wiadomość"` zamiast otwierać edytor, chyba że czujesz się z nim
  swobodnie.

## Co dalej

Twój commit istnieje — ale tylko na tej maszynie, w tym lokalnym
repozytorium. Nikt inny go jeszcze nie widzi. Dalej dowiesz się, co
naprawdę oznacza "remote".

Przejdź do [Lab 04 — Lokalne to nie zdalne](../04-local-vs-remote/README.pl.md).
