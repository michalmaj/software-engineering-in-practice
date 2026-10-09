# Lab 23 — Świat zewnętrzny zawodzi

## Sytuacja

Każde nowe zamówienie powinno wywołać powiadomienie do serwisu
śledzenia dostaw kuchni. Ten serwis jest prawdziwy, zewnętrzny i — jak
każdy serwis zewnętrzny — czasem nie odpowiada od pierwszego razu.

## Cele nauki

Po tym labie potrafisz:

- Owinąć niestabilne wywołanie polityką ponowień z maksymalną liczbą
  prób i stałym odstępem między próbami.
- Testować logikę ponowień bez prawdziwej sieci, używając fake'a, który
  zawodzi na żądanie, i bez prawdziwego oczekiwania, kontrolując
  odstęp z testu.
- Wyjaśnić, dlaczego zamówienie jest wciąż tworzone, nawet gdy
  powiadomienie w końcu zawiedzie.

To **bounded retry ze stałym odstępem** — nie exponential backoff.
Odstęp między próbami to zawsze ta sama liczba; nigdy nie rośnie.
Exponential backoff to prawdziwa technika, ale nie to ćwiczy ten lab.

## Zanim zaczniesz

### Python

- Lab 22 ukończony: zamówienia przetrwają w SQLite, migracja `notes`
  działa.
- Bieżący katalog: `examples/order-api/python/`.

### Go

- Lab 22 ukończony: zamówienia przetrwają w SQLite, migracja `notes`
  działa.
- Bieżący katalog: `examples/order-api/go/`.

### Java

- Lab 22 ukończony: zamówienia przetrwają w SQLite, migracja `notes`
  działa.
- Bieżący katalog: `examples/order-api/java/`.

## Twoje zadanie

Każdy track stosuje tę samą politykę: maksymalnie 3 próby domyślnie;
odstęp 0,2 sekundy (200ms) między próbami, ale nigdy po ostatniej;
sukces natychmiast kończy retry; po wyczerpaniu wszystkich prób błąd
wraca do wywołującego; ponawiamy wyłącznie rozpoznany błąd
powiadomienia — nic innego.

### Krok 1 — zdefiniuj rozpoznawalny błąd powiadomienia

#### Python

Utwórz `kitchen_client.py` z `class NotifierError(Exception): pass`.

#### Go

Utwórz `notifier.go` z sentinel error:
`var ErrNotification = errors.New("kitchen notification failed")`.
Ponawiane powinny być tylko błędy zgodne z tym jednym (sprawdzane przez
`errors.Is`) — coś innego to nieoczekiwany bug, nie niestabilna
zależność, i powinno propagować się natychmiast, a nie być ponawiane 3
razy.

#### Java

Utwórz `NotificationException.java` z dedykowanym checked exception:

```java
public class NotificationException extends Exception {
    public NotificationException(String message) {
        super(message);
    }

    public NotificationException(String message, Throwable cause) {
        super(message, cause);
    }
}
```

### Krok 2 — napisz funkcję bounded retry

#### Python

W `kitchen_client.py` napisz
`call_with_retries(send_fn, max_attempts: int = 3, backoff_seconds:
float = 0.2) -> None`: wywołaj `send_fn()`; jeśli zgłosi
`NotifierError`, zaczekaj `backoff_seconds` i spróbuj ponownie, do
`max_attempts` prób łącznie; jeśli każda próba zawiedzie, zgłoś
ponownie ostatni błąd. Produkcyjne miejsce wywołania (Krok 4) wywołuje
to bez nadpisywania `backoff_seconds`, więc naprawdę czeka `0.2`
sekundy między próbami — polityka retry, która nigdy nie czeka, nie
uczy odstępu, uczy tylko "spróbuj trzy razy natychmiast".

#### Go

Najpierw zdefiniuj minimalny kontrakt, jaki musi spełniać wywołanie
powiadomienia — w Go to po prostu funkcja zwracająca `error`, nic
więcej. W `notifier.go` napisz:

```go
func callWithRetries(send func() error, maxAttempts int, backoff time.Duration) error
```

Wywołaj `send()`; jeśli zwróci błąd zgodny z `ErrNotification`
(`errors.Is`), zaczekaj `backoff` i spróbuj ponownie, do `maxAttempts`
prób łącznie; jeśli `send()` zwróci jakikolwiek inny błąd, zwróć go
natychmiast bez ponawiania; jeśli wszystkie próby się wyczerpią, zwróć
ostatni błąd. Nie ma tu żadnego mechanizmu wyjątków do tłumaczenia —
`err := send()` **jest** naturalnym sposobem Go na zgłoszenie awarii,
o której jest ten lab; nie wymyślaj równoległej struktury imitującej
Pythonowe `try`/`except`.

Dodaj też sam produkcyjny notifier jako zmienną na poziomie pakietu, a
nie zwykłą funkcję — to pozwala testowi z Kroku 4 zastąpić go fake'em,
i to jest to, co wywołuje kod produkcyjny:

```go
var notifyKitchen = func(orderID string) error {
    return nil // no real delivery service to call yet
}
```

I produkcyjne wartości domyślne, jako `const` i `var` (nie dwa
`const`y — Krok 4 potrzebuje nadpisać odstęp z testu, a tylko `var`
może zostać ponownie przypisany):

```go
const defaultMaxAttempts = 3

var notificationBackoff = 200 * time.Millisecond
```

#### Java

Minimalny kontrakt, jaki musi spełniać wywołanie powiadomienia, jako
functional interface w `KitchenNotifier.java`:

```java
@FunctionalInterface
public interface KitchenNotifier {
    void send(String orderId) throws NotificationException;
}
```

Potem, w `RetryingNotifier.java`:

```java
public final class RetryingNotifier {
    public static void callWithRetries(
            KitchenNotifier notifier, String orderId, int maxAttempts, long backoffMillis)
            throws NotificationException {
        // ...
    }
}
```

Wywołaj `notifier.send(orderId)`; na przechwyconym
`NotificationException` zaczekaj `backoffMillis` (przez
`Thread.sleep`) i spróbuj ponownie, do `maxAttempts` prób łącznie;
jeśli każda próba zawiedzie, zgłoś ostatni wyjątek. Jeśli używasz
`Thread.sleep`, musisz jawnie przechwycić `InterruptedException` i
obsłużyć go — wywołaj `Thread.currentThread().interrupt()`, żeby
przywrócić flagę przerwania, a potem przestań ponawiać (na przykład
opakowując to w `NotificationException` i je zgłaszając). Pusty
`catch (InterruptedException e) {}` po cichu wyrzuca sygnał, że JVM
próbuje zamknąć ten wątek — nigdy tego nie rób.

Nie sięgaj po Spring Retry, Resilience4j ani framework do dependency
injection. To mała, skupiona klasa — nie reużywalna biblioteka retry i
nie powód, żeby budować hierarchię abstrakcji, której jeszcze nie
potrzebujesz.

### Krok 3 — trzy testy samej polityki retry

Napisz je jako nowe testy, niezależne od serwera HTTP. Każdy musi
sprawdzać dokładną liczbę wywołań, nie tylko końcowy rezultat —
polityka retry, która wywołuje złą liczbę razy, ale przypadkiem zwraca
dobrą odpowiedź, wciąż jest zepsuta.

**A. Natychmiastowy sukces** — fake nigdy nie zawodzi; dokładnie jedno
wywołanie; brak ponowień.

**B. Powrót po przejściowej awarii** — fake zawodzi przy pierwszych
dwóch wywołaniach, potem się udaje; dokładnie trzy wywołania; operacja
kończy się sukcesem.

**C. Wyczerpanie** — fake zawodzi stale; przy `max_attempts=3`,
dokładnie trzy wywołania; błąd wraca (zgłoszony/rzucony) do
wywołującego.

#### Python

W `tests/test_kitchen_client.py` napisz pomocniczy `FlakyClient` do
testów — klasę z metodą `send(self)`, która zgłasza `NotifierError`
przy pierwszych `fail_times` wywołaniach, potem się udaje, śledząc,
ile razy została wywołana:

```python
class FlakyClient:
    def __init__(self, fail_times: int) -> None:
        self.fail_times = fail_times
        self.calls = 0

    def send(self) -> None:
        self.calls += 1
        if self.calls <= self.fail_times:
            raise NotifierError("delivery service unavailable")
```

Napisz trzy testy wobec niego, używając `backoff_seconds=0`, żeby
działały natychmiast zamiast naprawdę czekać.

#### Go

W `notifier_test.go` napisz pomocniczy `flakyClient` do testów o tym
samym kształcie — pole `calls int` i metodę `send() error`, która
zwraca `ErrNotification` przy pierwszych `failTimes` wywołaniach, potem
`nil`. Napisz trzy testy wobec `callWithRetries`, przekazując `0` jako
argument `backoff`, żeby działały natychmiast.

#### Java

W `RetryingNotifierTest.java` napisz pomocniczy `FlakyNotifier` do
testów implementujący `KitchenNotifier`, o tym samym kształcie. Napisz
trzy testy wobec `RetryingNotifier.callWithRetries`, przekazując `0`
jako `backoffMillis`, żeby działały natychmiast.

### Krok 4 — podłącz powiadomienie do tworzenia zamówienia i udowodnij, że awaria go nie psuje

Powiadomienie następuje **dopiero po** utrwaleniu zamówienia w SQLite —
nigdy przed, nigdy zamiast tego:

```text
POST /orders
    ↓
validate request
    ↓
persist order in SQLite
    ↓
attempt kitchen notification
    ↓
notification succeeds OR retry exhausts
    ↓
HTTP 201
```

Jeśli persystencja zawiedzie, nie udawaj, że się udała, i w ogóle nie
podejmuj próby powiadomienia. Jeśli persystencja się uda, ale wszystkie
próby powiadomienia zawiodą: `POST` nadal zwraca `201`; zamówienie
pozostaje w bazie; `GET /orders/{id}` nadal je zwraca; liczba prób
powiadomienia nadal jest ograniczona do `max_attempts`. Response body i
statusy z Lab 22 się nie zmieniają — żadnego nowego pola
`notification_status`, żadnego nowego statusu. To prawdziwy trade-off,
nie darmowa wygrana: operacja biznesowa (utworzenie zamówienia) się
udała, ale powiadomienie mogło nigdy nie dotrzeć do kuchni. To nie to
samo co system z gwarantowaną dostawą, i ten lab go nie buduje — buduje
granicę, która nie pozwala, żeby awaria efektu ubocznego cofnęła
główny sukces.

#### Python

W `api.py` dodaj funkcję `notify_kitchen(order_id: str) -> None` (na
razie po prostu `pass` — nie masz prawdziwego serwisu dostawy do
wywołania). W `do_POST`, zaraz po udanym utworzeniu zamówienia, wywołaj
ją przez swój wrapper retry:
`call_with_retries(lambda: notify_kitchen(order["order_id"]))`,
przechwytując `NotifierError`, żeby nieudane powiadomienie nie zawaliło
całego żądania.

#### Go

W `handleCreateOrder` w `api.go`, zaraz po udanym `createOrder`,
wywołaj swój notifier przez wrapper retry:

```go
err = callWithRetries(func() error {
    return notifyKitchen(order.OrderID)
}, defaultMaxAttempts, notificationBackoff)
```

Jego zwrócony błąd mówi Ci tylko, że każda próba zawiodła — już
przeszedł przez pętlę retry, więc nie ma nic do cofnięcia. Nie zawalaj
żądania z jego powodu.

#### Java

Daj `ApiServer` pole `KitchenNotifier` i dwa konstruktory:
bezargumentowy, używany przez `Main` (domyślnie stub, który nic nie
robi, `orderId -> { }`, z domyślnym odstępem 200ms), i taki, który
przyjmuje `KitchenNotifier` i `backoffMillis` — ten drugi jest tym,
czego używa poniższy test z Kroku 4, żeby wstrzyknąć zawodzącego
fake'a *i* pominąć prawdziwy odstęp w tym samym kroku:

```java
public ApiServer() {
    this(orderId -> { /* no real delivery service to call yet */ });
}

public ApiServer(KitchenNotifier notifier) {
    this(notifier, 200L);
}

public ApiServer(KitchenNotifier notifier, long notificationBackoffMillis) {
    this.notifier = notifier;
    this.notificationBackoffMillis = notificationBackoffMillis;
}
```

W `handleCreateOrder`, zaraz po udanym `OrderDb.createOrder`, wywołaj
`RetryingNotifier.callWithRetries(notifier, order.orderId, 3,
notificationBackoffMillis)`, przechwytując `NotificationException`,
żeby nieudane powiadomienie nie zawaliło całego żądania. Dodaj
pasujące przeciążenie `createServer(int port, ApiServer handler)` obok
istniejącego `createServer(int port)`, żeby test mógł zbudować serwer
wokół konkretnej instancji `ApiServer` zamiast zawsze dostawać
domyślną.

Teraz dodaj czwarty, obowiązkowy test — ten prowadzi przez prawdziwą
ścieżkę HTTP, nie tylko przez samą funkcję retry w izolacji. Żaden z
testów z Kroku 3 nie wychwyciłby buga w podłączeniu, w którym awaria
powiadomienia przypadkiem zawaliła całe żądanie; tylko prawdziwe
żądanie przez prawdziwy handler, trafiające w prawdziwy (tymczasowy,
per-test) plik SQLite, by to wychwyciło.

#### Python

Dodaj jeszcze jeden test w `tests/test_api.py`:

- Użyj `monkeypatch`, żeby zastąpić `api.notify_kitchen` fake'em,
  który zawsze zgłasza `NotifierError`, i żeby zastąpić `time.sleep`
  no-opem, żeby test nie czekał naprawdę przez ponowienia.
- Wykonaj `POST` zamówienia przez prawdziwy serwer. Potwierdź, że
  odpowiedź to nadal `201`.
- Wykonaj potem `GET` tego samego zamówienia i potwierdź, że nadal
  tam jest.
- Potwierdź, że Twój fake został wywołany dokładnie `max_attempts`
  razy (3).

#### Go

Dodaj jeszcze jeden test w `api_test.go`:

- Tymczasowo przypisz na nowo pakietowe `notifyKitchen` do fake'a,
  który zawsze zwraca `ErrNotification` i liczy swoje wywołania, oraz
  tymczasowo przypisz na nowo `notificationBackoff` na `0` — oba
  przywrócone przez `defer` na końcu testu. To Go-owy odpowiednik
  Pythonowego `monkeypatch`: zwykłe ponowne przypisanie zmiennej,
  przywracane na koniec testu.
- Wykonaj `POST` zamówienia przez `httptest.Server`. Potwierdź, że
  odpowiedź to nadal `201`.
- Wykonaj potem `GET` tego samego zamówienia i potwierdź, że nadal
  tam jest.
- Potwierdź, że Twój fake został wywołany dokładnie `defaultMaxAttempts`
  razy.

#### Java

Dodaj jeszcze jeden test w `ApiServerTest.java`:

- Zbuduj fake'owy `KitchenNotifier`, który zawsze zgłasza
  `NotificationException` i liczy swoje wywołania.
- Zatrzymaj serwer uruchomiony przez Twój `@BeforeEach` i uruchom nowy
  z `ApiServer.createServer(0, new ApiServer(fakeNotifier, 0))` — `0`
  jako `backoffMillis` to to, co powstrzymuje ten test od
  prawdziwego czekania ~0,4 sekundy.
- Wykonaj `POST` zamówienia przez prawdziwy klient HTTP. Potwierdź, że
  odpowiedź to nadal `201`.
- Wykonaj potem `GET` tego samego zamówienia i potwierdź, że nadal
  tam jest.
- Potwierdź, że Twój fake został wywołany dokładnie 3 razy.

### Krok 5 — branch, PR, review, merge

Zrób pracę z tego labu na gałęzi (na przykład
`feature/outside-world-fails`), wypchnij ją i otwórz pull request.
Zmerguj dopiero, gdy CI jest zielone — ta sama pętla co w Labach 21 i
22.

## Kryteria akceptacji

- Istnieje rozpoznawalny błąd powiadomienia (`NotifierError` /
  `ErrNotification` / `NotificationException`), a zbudowana wokół
  niego funkcja bounded retry domyślnie robi 3 próby i czeka 0,2s
  (200ms) między próbami, nigdy po ostatniej.
- Wszystkie trzy testy zachowania retry przechodzą, każdy sprawdzając
  dokładną liczbę wywołań, nie tylko końcowy rezultat.
- Tworzenie zamówienia nadal się udaje (`201`), mimo że powiadomienie
  kuchni to na razie tylko stub.
- Prawdziwy test na poziomie HTTP dowodzi, że zamówienie jest tworzone
  i wciąż pobieralne, nawet gdy dostarczenie powiadomienia zawodzi
  przy każdej próbie — tego nie da się spełnić, testując samą funkcję
  retry.
- Ten test na poziomie HTTP działa natychmiast — żaden test w tym
  labie nie czeka naprawdę przez prawdziwy odstęp.
- Zmiany z tego labu zostały zmergowane przez pull request z zielonym
  checkiem CI, nie zacommitowane bezpośrednio na `main`.

## Weryfikacja

### Python

```bash
cd examples/order-api/python
uv run pytest -v
cd -
```

### Go

```bash
cd examples/order-api/go
go test ./... -v
cd -
```

### Java

```bash
cd examples/order-api/java
./gradlew test
cd -
```

Oczekiwane: wszystkie testy przechodzą (9 razem: 5 z Labów 21-22, 3
testy zachowania retry i nowy test integracyjny ścieżki awarii).

## Zastanów się

- Twoje testy nigdy nie czekają naprawdę (`backoff_seconds=0` /
  `backoff: 0` / `backoffMillis: 0`), mimo że prawdziwa funkcja
  obsługuje odstęp. Dlaczego to dobry trade-off dla testu, a zły dla
  produkcji?
- Zamówienie jest tworzone w bazie *przed* próbą powiadomienia, a
  awaria powiadomienia tego nie cofa. Co by się zepsuło, gdybyś
  zbudował/a to odwrotnie — najpierw powiadomienie, a zamówienie
  tworzone tylko, gdyby się ono udało?
- Zarówno Go, jak i Java potrzebowały jawnego, nadpisywalnego miejsca
  do kontrolowania odstępu retry w testach (zmienna `var` do
  ponownego przypisania, albo parametr konstruktora). Test w Pythonie
  użył `monkeypatch`, żeby zastąpić samo `time.sleep`. Dlaczego Go ani
  Java nie mają odpowiednika `monkeypatch`, i co to mówi o
  trade-offach dynamicznie typowanego języka z mutowalnym stanem
  modułu w porównaniu ze statycznie typowanym, kompilowanym?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** `call_with_retries` potrzebuje pętli od `1` do
  `max_attempts` włącznie, `try`/`except NotifierError` i `return`
  przy sukcesie.
- **Podpowiedź 2:** `FlakyClient` musi liczyć swoje wywołania
  (`self.calls += 1`), żeby Twoje testy mogły sprawdzić, ile razy
  `send_fn` faktycznie zadziałało.
- **Podpowiedź 3:** Lambda `lambda: notify_kitchen(order["order_id"])`
  pozwala `call_with_retries` wywoływać `notify_kitchen` z właściwym
  argumentem przy każdej próbie, bez potrzeby, żeby
  `call_with_retries` znało sygnaturę `notify_kitchen`.
- **Podpowiedź 4:** `monkeypatch.setattr(api, "notify_kitchen",
  your_fake)` zastępuje funkcję, którą faktycznie wywołuje `do_POST`,
  tak samo jak fixture z Lab 22 użył `monkeypatch.setattr(db,
  "DB_PATH", ...)`, żeby przekierować nazwę na poziomie modułu.
  `monkeypatch.setattr(time, "sleep", lambda seconds: None)` (z
  `import time` na górze pliku testowego) robi to samo dla odstępu
  między próbami.

### Go

- **Podpowiedź 1:** `errors.Is(err, ErrNotification)` jest `true`
  tylko wtedy, gdy `err` jest (albo opakowuje) konkretnie
  `ErrNotification` — niepowiązany błąd z buga gdzie indziej nie
  pasuje, a `callWithRetries` powinno zwrócić go natychmiast zamiast
  go ponawiać.
- **Podpowiedź 2:** `flakyClient` potrzebuje pola `calls int`
  zwiększanego na początku `send()`, przed decyzją, czy zawieść.
- **Podpowiedź 3:** Closure przechwytuje `order.OrderID` za Ciebie —
  `func() error { return notifyKitchen(order.OrderID) }` to wartość,
  którą `callWithRetries` może wywoływać wielokrotnie, bez wiedzy o
  sygnaturze `notifyKitchen`.
- **Podpowiedź 4:** Ponowne przypisanie `notifyKitchen` i
  `notificationBackoff` w teście działa tylko dlatego, że to `var`y na
  poziomie pakietu, nie `const`y ani lokalne zmienne `main`. Zawsze
  przywracaj oryginalną wartość przez `defer`, zanim test się skończy
  — inaczej przeciekniesz fake'owy notifier do tego, jaki test
  uruchomi się następny.

### Java

- **Podpowiedź 1:** Lambda w stylu `orderId -> { throw new
  NotificationException("boom"); }` to kompletny `KitchenNotifier` —
  functional interfaces w Javie pozwalają jednolinijkowej lambdzie
  zastąpić całą fake'ową implementację.
- **Podpowiedź 2:** `FlakyNotifier` potrzebuje pola `int calls`
  zwiększanego na początku `send(...)`, przed decyzją, czy zgłosić
  wyjątek.
- **Podpowiedź 3:** `Thread.currentThread().interrupt()` wewnątrz
  bloku `catch (InterruptedException e)` przywraca flagę przerwania,
  którą `Thread.sleep` wyczyścił, gdy został przerwany — pominięcie
  tego oznacza, że reszta Twojego programu nigdy nie dowie się, że ten
  wątek został poproszony o zatrzymanie.
- **Podpowiedź 4:** Trójargumentowy konstruktor `ApiServer
  (KitchenNotifier, long)` istnieje właśnie po to, żeby test mógł
  ustawić `backoffMillis` na `0` — bez niego test ścieżki awarii HTTP
  naprawdę czekałby mniej więcej 2 × 200ms na uruchomienie.

## Co dalej

Powiadomienia mogą teraz zawodzić po cichu — nic nie zapisuje, że się
wydarzyły, ani że nie. Dalej dajesz systemowi sposób, żeby wytłumaczył
się po fakcie.

Przejdź do [Lab 24 — Produkcja mówi "to nie działa"](../24-production-says-it-doesnt-work/README.pl.md).
