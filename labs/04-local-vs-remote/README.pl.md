# Lab 04 — Lokalne to nie zdalne

## Sytuacja

Twój commit z Lab 03 bezpiecznie siedzi w lokalnym repozytorium. Kolega z
zespołu pyta: "wypchnąłeś/aś to już?". Zdajesz sobie sprawę, że tak
naprawdę nie wiesz jeszcze, co to pytanie właściwie oznacza.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Wyjaśnić różnicę między katalogiem roboczym, lokalnym repozytorium a
  repozytorium zdalnym.
- Sprawdzić, z jakim(i) zdalnym(i) repozytorium(-ami) skonfigurowane jest
  Twoje lokalne repozytorium.
- Opublikować lokalny commit na zdalnym repozytorium poleceniem `git push`
  i pobrać cudzą pracę poleceniem `git pull`.
- Wyjaśnić, że Git (narzędzie) i GitHub (usługa hostująca repozytoria Git)
  to nie to samo.

## Zanim zaczniesz

- Lab 03 ukończony — masz co najmniej jeden lokalny commit.
- Twoje repozytorium ma skonfigurowany remote (Codespaces i zwykłe `git
  clone` ustawiają to automatycznie).
- Bieżący katalog: katalog główny repozytorium.
- Jeśli `git remote -v` pokazuje adres URL, który *nie* jest Twoim
  własnym forkiem (wskazuje na oryginalne repozytorium kursu), zatrzymaj
  się tutaj — wróć do instrukcji forkowania w głównym
  [`README.pl.md`](../../README.pl.md), zanim będziesz kontynuować.
  Push do repozytorium, którego nie jesteś właścicielem, zawiedzie z
  błędem uprawnień.

## Twoje zadanie

1. Uruchom `git remote -v` i zanotuj adres(y) URL pokazane dla `origin`.
2. Rozszerz
   `labs/04-local-vs-remote/notes/my-observations.txt` o jedno zdanie
   wyjaśniające własnymi słowami, do czego odnosi się `origin`.
3. Dodaj i zacommituj ten plik (`docs: add lab 04 observations`).
4. Uruchom `git push`. Jeśli się powiedzie, Twoje commity (z tego
   laboratorium i z Lab 03, jeśli nie były jeszcze wypchnięte) istnieją
   teraz też na zdalnym repozytorium.
5. Uruchom lokalnie `git log`, a potem porównaj go z historią commitów
   pokazaną w interfejsie webowym remote'a (np. widok "Commits" na
   GitHubie) dla tej samej gałęzi.
6. Uruchom `git pull`. Nawet bez nowych zmian na remote, potwierdź, że
   kończy się bez błędu — to jest polecenie, na którym będziesz polegać,
   żeby pobierać pracę kolegów z zespołu w dalszej części kursu.

## Kryteria akceptacji

- Wynik `git remote -v` jest zapisany (własnymi słowami) w
  `my-observations.txt`.
- Twoje commity z Lab 03 i Lab 04 są widoczne zarówno w lokalnym `git
  log`, jak i w historii Twojej gałęzi na remote.
- Potrafisz na głos podać jedno zdanie odróżniające "repozytorium lokalne"
  od "repozytorium zdalnego" oraz jedno zdanie odróżniające Git od
  GitHuba.

## Weryfikacja

```bash
git remote -v
git log --oneline -3
git status   # powinno pokazać "up to date" / "nothing to commit"
```

Następnie otwórz repozytorium na GitHubie (albo swoim hoście Gita) i
potwierdź, że Twój ostatni commit też się tam pojawia.

## Zastanów się

- Jeśli nigdy nie uruchomisz `git push`, czy Twoja praca istnieje
  gdziekolwiek poza Twoją własną maszyną?
- `git pull` to tak naprawdę dwie operacje sklejone razem (fetch + merge).
  Dlaczego może mieć znaczenie, żeby to wiedzieć, gdy zaczniesz pracować z
  zespołem?

## Jeśli utkniesz

- **Podpowiedź 1:** Potrzebujesz trzech nowych poleceń poza Lab 03: `git
  remote -v`, `git push`, `git pull`.
- **Podpowiedź 2:** Jeśli `git push` zostanie odrzucony, zwykle oznacza to,
  że remote ma commity, których nie masz jeszcze lokalnie — najpierw
  zrób `git pull`, potem wypchnij ponownie.
- **Podpowiedź 3:** `origin` to po prostu nazwa (lokalny alias) dla adresu
  URL remote'a — to nie jest specjalne słowo kluczowe Gita, to zwyczajowa
  domyślna nazwa.

## Co dalej

Potrafisz już opisać, gdzie fizycznie istnieje Twój kod. Ale do tej pory
każdy projekt, którego dotykałeś/aś, był na tyle mały, że dało się go
uruchomić z pamięci. Dalej zobaczysz, co się dzieje, gdy projekt działa
"tylko na mojej maszynie" i nigdzie indziej.

Przejdź do [Lab 05 — "Działa na moim komputerze"](../05-works-on-my-machine/README.pl.md).
