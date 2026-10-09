# Lab 24 — Produkcja mówi "to nie działa"

## Sytuacja

Użytkownik zgłasza: "próbowałem/am sprawdzić moje zamówienie i nic nie
dostałem/am". Proces nadal działa. Nie ma błędu na Twoim ekranie. Nie
masz pojęcia, które zamówienie, ani co faktycznie się stało, bo nic
nigdy nie zostało zapisane.

## Cele nauki

Po tym labie potrafisz:

- Dodać komunikaty logów z poziomami (`INFO`/`WARNING`/`ERROR` — albo
  najbliższy odpowiednik Twojego języka) w momentach, które mają
  znaczenie w cyklu życia żądania.
- Umieścić wystarczający kontekst (id zamówienia, numer próby) w
  rekordzie logu, żeby prześledzić historię jednego konkretnego
  żądania.
- Przetestować, że rekord logu faktycznie powstał, przechwytując go
  programistycznie zamiast patrzeć na output w terminalu.
- Oddzielić *konfigurację* logowania (wykonywaną raz, przy starcie) od
  *użycia* logowania (rozrzuconego po kodzie wszędzie tam, gdzie
  dzieje się coś wartego zapisania).

Standardowe API logowania Javy nazywa swój najcięższy poziom `SEVERE`,
nie `ERROR` — to akceptowany odpowiednik w tym labie, nie odstępstwo od
niego. `log/slog` w Go renderuje swój poziom ostrzeżenia jako `WARN`, a
nie `WARNING` w outpucie — ta sama sytuacja.

## Zanim zaczniesz

### Python

- Lab 23 ukończony: `call_with_retries` i `notify_kitchen` istnieją i
  są podłączone do `do_POST`.
- Bieżący katalog: `examples/order-api/python/`.

### Go

- Lab 23 ukończony: `callWithRetries` i `notifyKitchen` istnieją i są
  podłączone do `handleCreateOrder`.
- Bieżący katalog: `examples/order-api/go/`.

### Java

- Lab 23 ukończony: `RetryingNotifier` i `KitchenNotifier` istnieją i
  są podłączone do `handleCreateOrder`.
- Bieżący katalog: `examples/order-api/java/`.

## Twoje zadanie

Zdarzenia, które każdy track musi logować, i na jakim poziomie:

| Zdarzenie | Poziom |
|---|---|
| Utworzenie zamówienia | INFO |
| Żądanie nieistniejącego zamówienia | WARNING |
| Jedna nieudana próba powiadomienia | WARNING |
| Wyczerpanie wszystkich prób powiadomienia | ERROR (`SEVERE` w Javie) |

Nigdy nie loguj pełnej zawartości `items` ani `notes` — liczba
elementów wystarczy do tego labu. Nie loguj sekretów, tokenów ani
niczego innego, czego prawdziwy system produkcyjny nie chciałby mieć w
pliku logów. Rekord logu powinien pozwolić odpowiedzieć: co się
wydarzyło, kiedy, na jakim poziomie, i — ilekroć id jest dostępne —
którego zamówienia dotyczyło.

### Krok 1 — skonfiguruj logowanie raz, przy starcie

#### Python

Dodaj `import logging` i `logger = logging.getLogger("order_api")`
blisko góry `api.py`. W `run()` skonfiguruj logowanie raz przez
`logging.basicConfig`, uwzględniając timestamp, level i nazwę loggera
w formacie — nigdy wewnątrz handlera żądania i nigdy przy imporcie,
inaczej każde żądanie (albo każdy import w teście) skonfigurowałoby je
na nowo.

#### Go

Domyślny logger `log/slog` już działa bez żadnej konfiguracji, ale ten
lab chce, żebyś skonfigurował/a go jawnie, raz, w `main()` — nie
rozproszonego po każdym pliku, który akurat coś loguje:

```go
slog.SetDefault(slog.New(slog.NewTextHandler(os.Stdout, nil)))
```

#### Java

Utwórz `LoggingConfig.java` z pojedynczą metodą `configure()`,
wywoływaną raz z `Main`, zanim cokolwiek innego się wydarzy. Usuń
jakiekolwiek handlery, które root logger już ma (żeby nie skończyć z
każdą linią wydrukowaną dwa razy — raz przez Twój handler, raz przez
domyślny `java.util.logging`), a potem podłącz dokładnie jeden
`ConsoleHandler` z `SimpleFormatter`:

```java
public static void configure() {
    Logger root = Logger.getLogger("");
    for (Handler handler : root.getHandlers()) {
        root.removeHandler(handler);
    }
    ConsoleHandler handler = new ConsoleHandler();
    handler.setFormatter(new SimpleFormatter());
    handler.setLevel(Level.ALL);
    root.addHandler(handler);
    root.setLevel(Level.INFO);
}
```

Żadnego SLF4J, żadnego Log4j, żadnej dodatkowej zależności —
`java.util.logging` jest już częścią JDK.

### Krok 2 — loguj utworzenie zamówienia na INFO

#### Python

W `do_POST`, zaraz po utworzeniu zamówienia, loguj na `INFO`:
uwzględnij id zamówienia i ile ma pozycji.

#### Go

W `handleCreateOrder`, zaraz po udanym `createOrder`, loguj na `Info`,
z id zamówienia i liczbą pozycji jako nazwanymi atrybutami (nie
wpisanymi na sztywno w string komunikatu):

```go
slog.Info("order created", "order_id", order.OrderID, "item_count", len(items))
```

#### Java

Dodaj `private static final Logger LOGGER =
Logger.getLogger("order_api");` do `ApiServer`. Zaraz po udanym
`OrderDb.createOrder`, loguj na `INFO`, z id zamówienia i liczbą
pozycji jako parametrami:

```java
LOGGER.log(Level.INFO, "order {0} created with {1} items",
        new Object[] {order.orderId, items.size()});
```

### Krok 3 — loguj brakujące zamówienie na WARNING

#### Python

W `do_GET`, gdy zamówienie nie zostanie znalezione, loguj na
`WARNING`: uwzględnij id zamówienia, o które poproszono.

#### Go

W `handleGetOrder`, gdy `getOrder` zgłosi "nie znaleziono", loguj na
`Warn` z żądanym id jako nazwanym atrybutem:
`slog.Warn("order not found", "order_id", id)`.

#### Java

W `handleGetOrder` w `ApiServer`, gdy `OrderDb.getOrder` zwróci
`null`, loguj na `WARNING` z żądanym id:
`LOGGER.log(Level.WARNING, "order {0} not found", id)`.

### Krok 4 — loguj diagnostykę retry

To idzie do wnętrza funkcji retry, którą już zbudowałeś/aś w Lab 23 —
nie piszesz tu nowej logiki retry, tylko dodajesz widoczność do
logiki, która już istnieje.

#### Python

W `kitchen_client.py` dodaj `logger = logging.getLogger
("kitchen_client")`. W `call_with_retries` loguj `WARNING` przy każdej
nieudanej próbie (uwzględnij numer próby i błąd) i `ERROR`, jeśli
wszystkie próby się wyczerpią.

#### Go

W `notifier.go`, wewnątrz `callWithRetries`, loguj `Warn` przy każdej
ponawianej awarii (uwzględnij numer próby i błąd jako nazwane
atrybuty) i `Error` raz, dopiero po wyczerpaniu wszystkich prób:

```go
slog.Warn("notification attempt failed", "attempt", attempt, "error", err)
// ... and, once, after the loop:
slog.Error("notification failed after attempts", "attempts", maxAttempts)
```

#### Java

Dodaj `private static final Logger LOGGER =
Logger.getLogger("kitchen_notifier");` do `RetryingNotifier`. Wewnątrz
`callWithRetries` loguj `WARNING` przy każdej ponawianej awarii
(uwzględnij numer próby i komunikat wyjątku) i `SEVERE` raz, dopiero po
wyczerpaniu wszystkich prób:

```java
LOGGER.log(Level.WARNING, "notification attempt {0} failed: {1}",
        new Object[] {attempt, e.getMessage()});
// ... and, once, after the loop:
LOGGER.log(Level.SEVERE, "notification failed after {0} attempts", maxAttempts);
```

### Krok 5 — przeprowadź ogłoszenie startu przez swój logger

Teraz, gdy logowanie jest skonfigurowane, linia ogłaszająca gotowość
serwera jest dokładnie tym rodzajem szczegółu operacyjnego, o który
chodzi w tym labie — nie outputem dla użytkownika, który ktoś ma
przeczytać z narzędzia CLI.

#### Python

Zastąp `print(...)`, który ogłasza, że serwer nasłuchuje,
`logger.info(...)`.

#### Go

Zastąp linię ogłaszającą, że serwer nasłuchuje,
`slog.Info("order-api listening on http://" + addr)`. Jej dokładny
wygląd na ekranie się zmienia (ma teraz przed sobą prefiks
timestamp/level z handlera), ale sam tekst — łącznie z pełnym
`http://host:port`, tą częścią, którą Lab 21 kazał Ci obserwować —
wciąż jest w tej linii.

#### Java

Zastąp linię ogłaszającą, że serwer nasłuchuje,
`LOGGER.info("order-api listening on http://localhost:" + port)`
(używając tego samego loggera `"order_api"` z Kroku 2). Ten sam
trade-off co w Go: otaczający format się zmienia, sam komunikat nie.

### Krok 6 — napisz dwa testy przechwytujące rekordy logów

Przechwyć rekord programistycznie i sprawdź jego poziom i treść —
nigdy nie sprawdzaj dokładnej wyrenderowanej linii (timestampy czynią
to niewiarygodnym) i nigdy nie polegaj tylko na patrzeniu na output w
terminalu jako jedynym sprawdzeniu.

#### Python

Używając fixture'a `caplog` z pytest, napisz dwa testy: jeden
potwierdzający, że utworzenie zamówienia produkuje rekord logu `INFO`;
jeden potwierdzający, że żądanie brakującego zamówienia produkuje
rekord `WARNING`.

#### Go

Wskaż domyślny logger `slog` na `bytes.Buffer`, używając JSON handlera
na czas testu (przywracając oryginalny domyślny potem), wykonaj
żądanie, a potem sprawdź zawartość bufora:

```go
var buf bytes.Buffer
original := slog.Default()
slog.SetDefault(slog.New(slog.NewJSONHandler(&buf, nil)))
defer slog.SetDefault(original)
```

Napisz dwa testy: jeden potwierdzający, że `POST` produkuje rekord z
`"level":"INFO"` i polem `order_id`; jeden potwierdzający, że `GET`
brakującego zamówienia produkuje rekord z `"level":"WARN"` i żądanym
id w środku.

#### Java

Używając małego `ListLogHandler`, który piszesz do tego (podklasa
`Handler`, która dopisuje każdy otrzymany `LogRecord` do listy zamiast
go drukować), podłącz go do `Logger.getLogger("order_api")` przed
żądaniem i odłącz potem:

```java
class ListLogHandler extends Handler {
    final List<LogRecord> records = new ArrayList<>();

    @Override public void publish(LogRecord record) { records.add(record); }
    @Override public void flush() { }
    @Override public void close() { }
}
```

Napisz dwa testy: jeden potwierdzający, że `POST` produkuje rekord na
`Level.INFO`; jeden potwierdzający, że `GET` brakującego zamówienia
produkuje rekord na `Level.WARNING`, którego parametry zawierają
żądane id (`record.getParameters()`).

### Krok 7 — odczytaj swoje własne logi ręcznie

Uruchom serwer ręcznie, wykonaj parę żądań (w tym jedno dla
brakującego zamówienia) i odczytaj output logów w swoim terminalu.
Potwierdź, że potrafisz powiedzieć, co się stało, bez otwierania pliku
źródłowego.

### Krok 8 — branch, PR, review, merge

Zrób pracę z tego labu na gałęzi (na przykład
`feature/production-logging`), wypchnij ją i otwórz pull request.
Zmerguj dopiero, gdy CI jest zielone — ta sama pętla co w reszcie
Aktu V.

## Kryteria akceptacji

- Logowanie jest skonfigurowane dokładnie raz, przy starcie — nie na
  żądanie, nie przy imporcie/ładowaniu klasy.
- Utworzenie zamówienia loguje na INFO z id zamówienia; brakujące
  zamówienie loguje na WARNING z żądanym id; awaria retry loguje na
  WARNING, a wyczerpanie wszystkich prób loguje raz na ERROR/SEVERE.
- Dwa testy przechwytujące logi przechodzą, potwierdzając przypadki
  INFO i WARNING z Kroku 6.
- Żaden `print`/`fmt.Println`/`System.out.println` nie zastępuje logu
  operacyjnego w kodzie tego labu.
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

Oczekiwane: wszystkie testy przechodzą (11 razem: 9 z Labów 21-23,
plus dwa nowe testy logowania).

## Zastanów się

- Mógłbyś/mogłabyś użyć `print()`/`fmt.Println`/`System.out.println`
  wszędzie zamiast biblioteki do logowania. Co przez to tracisz —
  konkretnie, co Twój test przechwytujący logi mógłby sprawdzić w
  wywołaniu logu z poziomem, czego nie mógłby sprawdzić w zwykłym
  outpucie konsoli?
- Dlaczego awaria retry loguje na WARNING przy *każdej* próbie, ale
  ERROR/SEVERE tylko *raz*, na końcu, zamiast przy każdej nieudanej
  próbie?
- `java.util.logging` nazywa swój najcięższy wbudowany poziom
  `SEVERE`; `slog` w Go renderuje swój poziom ostrzeżenia jako `WARN`.
  Żaden nie pasuje do tabeli na początku tego labu znak w znak.
  Dlaczego to tutaj jest w porządku, i czego faktycznie szukałbyś/
  szukałabyś w API logowania danego języka, żeby zdecydować, czy nazwa
  poziomu jest "wystarczająco bliska"?

## Jeśli utkniesz

### Python

- **Podpowiedź 1:** `logging.getLogger(name)` zwraca ten sam obiekt
  loggera za każdym razem, gdy jest wywołane z tą samą `name` — tak
  `api.py` i jego testy mogą oba odnosić się do `"order_api"` i widzieć
  tę samą konfigurację.
- **Podpowiedź 2:** `caplog.at_level(logging.INFO, logger="order_api")`
  jako context manager przechwytuje tylko rekordy na `INFO` lub wyżej,
  z tego konkretnego loggera, dla kodu wewnątrz bloku `with`.
- **Podpowiedź 3:** `logger.info("order %s created with %d items",
  order_id, count)` — przekazuj wartości jako osobne argumenty, nie
  przez f-string; to pozwala `logging` całkowicie pominąć formatowanie,
  gdy poziom logu jest wyłączony.

### Go

- **Podpowiedź 1:** `slog.Info`/`slog.Warn`/`slog.Error` przyjmują
  string komunikatu, a potem naprzemienne pary klucz/wartość —
  `slog.Warn("notification attempt failed", "attempt", attempt,
  "error", err)` produkuje jeden strukturalny rekord, nie ręcznie
  sformatowany string.
- **Podpowiedź 2:** `slog.NewJSONHandler(&buf, nil)` pisze jeden obiekt
  JSON na linię do dowolnego `io.Writer`, który mu podasz —
  `*bytes.Buffer` działa, a `strings.Contains(buf.String(), ...)`
  wystarczy, żeby sprawdzić pole bez pełnego parsowania JSON.
- **Podpowiedź 3:** `slog.SetDefault` to globalny stan na poziomie
  procesu — test, który go zmienia i zapomina przywrócić, przecieknie
  do tego, jaki test uruchomi się następny. Zawsze paruj wywołanie
  `SetDefault` z `defer`, które przywraca poprzedni domyślny.

### Java

- **Podpowiedź 1:** `Logger.getLogger(name)` zwraca tę samą instancję
  loggera za każdym razem, gdy jest wywołane z tą samą nazwą — to samo
  zachowanie identyczności-po-nazwie, co Pythonowe
  `logging.getLogger`.
- **Podpowiedź 2:** `Handler` potrzebuje tylko zaimplementowanych
  `publish`, `flush` i `close` — `publish` jest wywoływane raz na
  każdy rekord logu, który do niego dotrze, więc dopisywanie do
  `List<LogRecord>` tam wystarczy, żeby przechwycić wszystko do testu.
- **Podpowiedź 3:** `LogRecord.getParameters()` zwraca `Object[]`,
  który przekazałeś/aś jako drugi argument do `LOGGER.log(Level,
  String, Object[])` — tak test może sprawdzić, że *samo id* zostało
  zalogowane, nie tylko że jakieś `WARNING` się wydarzyło.
- **Podpowiedź 4:** Usuń handler, który dodałeś/aś w
  `@BeforeEach`/samym teście, gdy już go nie potrzebujesz
  (`logger.removeHandler(handler)`) — inaczej będzie dalej gromadzić
  rekordy z każdego kolejnego testu, który dotyka tego samego loggera.

## Co dalej

Masz testy, review, CI i teraz logi, w którymkolwiek tracku
realizowałeś/aś. Od tego miejsca podgląd Go i Javy znowu robi przerwę —
Lab 25 na razie zostaje Python-first, tak samo jak po Lab 22. Wszystko,
co zbudowałeś/aś w Go i Javie — walidacja, trwałość danych, migracja,
retry i logowanie — to kompletne, działające `order-api` samo w sobie.

Jeśli kontynuujesz w Pythonie: masz testy, review, CI i logi. Dalej
musisz zdecydować, co właściwie znaczy "ta wersja", kiedy przekazujesz
ją komuś innemu.

Przejdź do [Lab 25 — Wydanie i kompatybilność](../25-release-and-compatibility/README.pl.md).
