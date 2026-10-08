# Twój pierwszy push do GitHuba

[In English →](github-auth.md) · [← Wróć do Zacznij tutaj](../../START-HERE.pl.md)

Klonowanie i czytanie tego repozytorium nie wymagało żadnego logowania.
Jednak przy pierwszym uruchomieniu `git push` Git musi udowodnić
GitHubowi, że faktycznie jesteś sobą. Ta strona jest napisana właśnie na
ten moment — przeczytaj ją, gdy lab mówi Ci, żeby zrobić push, nie
wcześniej.

## Czego NIE robić

- **Nigdy nie wpisuj swojego hasła do konta GitHub**, gdy Git prosi o
  hasło przez HTTPS. GitHub lata temu przestał przyjmować hasła kont do
  operacji Gita — jeśli coś prosi Cię o hasło konta i je przyjmuje, nie
  rozmawiasz z GitHubem. Jeśli cokolwiek, co widzisz, prosi konkretnie o
  hasło konta, zatrzymaj się i zobacz
  [Jeśli utkniesz](#jeśli-utkniesz) poniżej, zamiast je wpisywać.
- **Nigdy nie wklejaj tokenu** (czegoś zaczynającego się na `ghp_` albo
  podobnie) do README tego repozytorium, do issue na GitHubie, do
  komunikatu commita, albo do wiadomości czatu do prowadzącego. Token
  wklejony gdziekolwiek publicznie albo pół-publicznie należy traktować
  jako skompromitowany — unieważnij go na GitHubie (**Settings →
  Developer settings → Personal access tokens**) i wygeneruj nowy.

## Co zrobić zamiast tego

### Łatwa droga: pozwól VS Code albo Gitowi to obsłużyć

W większości przypadków nie musisz robić niczego specjalnego — gdy
uruchomisz `git push` po raz pierwszy, albo VS Code, albo sam Git otworzy
okno przeglądarki proszące Cię o zalogowanie do GitHuba i autoryzację
dostępu. Zaloguj się normalnie (zwykłe hasło GitHub, i uwierzytelnianie
dwuetapowe, jeśli je masz skonfigurowane), kliknij **Authorize**, i
wróć do swojego terminala — push kontynuuje się sam.

To działa dzięki **Git Credential Manager**, który przychodzi w pakiecie
z Gitem dla Windows i jest zazwyczaj już obecny w instalacjach Gita na
macOS i Linuksie. Bezpiecznie przechowuje wynik tego jednorazowego
logowania przez przeglądarkę, więc nie zostaniesz o to zapytany/a
ponownie na tym komputerze.

### Jeśli żadne okno przeglądarki się nie pojawia

1. Spróbuj push jeszcze raz:
   ```bash
   git push
   ```
2. Jeśli Git wypisuje prompt jak `Username for
   'https://github.com':`, wpisz swój username z GitHuba i naciśnij
   Enter.
3. Jeśli potem wypisuje `Password for
   'https://<username>@github.com':`, to **nie** prosi o hasło Twojego
   konta — prosi o **personal access token**, który wygląda jak hasło,
   ale jest osobnym, odwołalnym poświadczeniem. Utwórz jeden:
   - W przeglądarce przejdź do **GitHub → Settings → Developer settings
     → Personal access tokens → Tokens (classic) → Generate new
     token**.
   - Daj mu nazwę, którą rozpoznasz (np.
     `software-engineering-in-practice`), datę wygaśnięcia (30-90 dni
     wystarczy na kurs), i zaznacz zakres **repo**.
   - Kliknij **Generate token**, potem skopiuj go natychmiast — GitHub
     pokazuje go dokładnie raz.
4. Wklej ten token w prompt hasła terminala (nie pojawi się, gdy
   wklejasz — to normalne) i naciśnij Enter.

**Skąd wiesz, że zadziałało:** terminal pokazuje postęp wysyłania
kończący się czymś jak `main -> main`, bez błędu.

## Jeśli utkniesz

- **"Prosi o hasło, a token też nie zadziałał."** Sprawdź podwójnie, czy
  skopiowałeś/aś cały token bez dodatkowych spacji, i czy nie wygasł.
  Wygeneruj nowy, jeśli nie jesteś pewien/pewna.
- **"Nie widzę okna przeglądarki i żaden prompt się nie pojawia —
  terminal po prostu zawisa."** Naciśnij `Ctrl+C`, żeby przerwać, potem
  spróbuj `git push` jeszcze raz ze świeżo otworzonego terminala.
- **Wciąż utknąłeś/aś?** Zobacz wspólne
  [`troubleshooting.pl.md`](troubleshooting.pl.md), jak zgłosić problem
  — i pamiętaj: nigdy nie dołączaj hasła, tokenu czy innego sekretu do
  takiego zgłoszenia.
