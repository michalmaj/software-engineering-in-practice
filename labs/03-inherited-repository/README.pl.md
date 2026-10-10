# Lab 03 — Dziedziczysz repozytorium

## Sytuacja

Masz dostęp do tego właśnie repozytorium. Zanim cokolwiek zmienisz,
musisz wiedzieć, jak sprawdzić, w jakim jest stanie, i jak zapisać własną
zmianę, niczego nie tracąc.

## Cele nauki

Po tym labie potrafisz:

- Wyjaśnić różnicę między katalogiem roboczym, obszarem stagingu a
  lokalnym repozytorium.
- Sprawdzić bieżący stan repozytorium za pomocą `git status`, `git log` i
  `git diff`.
- Dodać do stagingu i zacommitować zmianę z jasnym komunikatem.

## Zanim zaczniesz

- Lab 02 ukończony.
- Jesteś wewnątrz własnego klona tego repozytorium (skonfigurowałeś/aś to
  w [`START-HERE.pl.md`](../../START-HERE.pl.md) — albo, jeśli używasz
  Codespaces, jest już dla Ciebie przygotowany).
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
   teraźniejszym, np. `docs: add lab 03 observations`. Jeśli to Twój
   pierwszy commit na tej maszynie, Git może zatrzymać Cię komunikatem
   "Please tell me who you are" zamiast zacommitować — potrzebuje
   imienia i e-maila do podpisywania każdego Twojego commita tutaj.
   Uruchom te dwie komendy raz (użyj e-maila przypisanego do Twojego
   konta GitHub), potem powtórz commit:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "you@example.com"
   ```
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
wc -l < labs/03-inherited-repository/notes/my-observations.txt  # expect >= 3
```

## Zastanów się

- `git diff` i `git diff --staged` pokazały różne rzeczy. Dlaczego Git w
  ogóle rozróżnia te dwa stany?
- Gdyby `git commit` poszedł bez wcześniejszego `git add`, co stałoby
  się z Twoim nowym plikiem?

## Jeśli utkniesz

- **Podpowiedź 1:** Potrzebujesz dokładnie pięciu poleceń Gita: `status`,
  `log`, `diff`, `add`, `commit`.
- **Podpowiedź 2:** `git diff` (bez argumentów) pokazuje zmiany poza
  stagingiem; `git diff --staged` pokazuje, co faktycznie trafi do
  następnego commita.
- **Podpowiedź 3:** Commit potrzebuje komunikatu. Użyj `git commit -m
  "twoja wiadomość"` zamiast otwierać edytor, chyba że czujesz się z nim
  swobodnie.
- **Podpowiedź 4:** "Please tell me who you are" znaczy, że Git nie ma
  jeszcze skonfigurowanego `user.name` ani `user.email` na tej maszynie
  — zobacz krok 6 powyżej, dwie komendy `git config --global`, które
  naprawiają to raz na zawsze.

## Co dalej

Twój commit istnieje — ale tylko na tej maszynie, w tym lokalnym
repozytorium. Nikt inny go jeszcze nie widzi. Dalej dowiesz się, co
naprawdę oznacza "remote".

Przejdź do [Lab 04 — Lokalne to nie zdalne](../04-local-vs-remote/README.pl.md).
