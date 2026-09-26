# Lab 28 — Zmiana wymagań

## Sytuacja

Właściciel restauracji dzwoni: "Ciągle odmawiamy dużym grupom —
przyjęciom urodzinowym, kolacjom firmowym, dziesięciu czy dwunastu
osobom. Czy system może to obsłużyć, zsuwając dwa stoliki?" Wasze MVP
było zbudowane wokół jednej rezerwacji, jednego stolika.

## Cele nauki

Po tym labie potrafisz:

- Zaimplementować prawdziwą zmianę wymagań względem własnego,
  istniejącego projektu, a nie przykładu-zabawki.
- Zidentyfikować dokładnie, które pliki i kształty danych zmiana Cię
  zmusza dotknąć — a których nie.
- Ocenić uczciwie, czy Wasz projekt z Lab 26-27 ograniczył koszt tej
  zmiany, czy go zwiększył, i wyjaśnić dlaczego.

## Zanim zaczniesz

- Lab 27 ukończony: Wasze MVP jest zaimplementowane, przetestowane,
  zrecenzowane i zmergowane, z zielonym CI.

## Twoje zadanie

**Zmiana (przekaż ją swojemu zespołowi w tej formie):**

> Niektóre grupy są większe niż jakikolwiek pojedynczy stolik.
> Restauracja chce, żeby TableTime wspierało łączenie dwóch
> konkretnych, fizycznie sąsiadujących stolików w jedną rezerwację, gdy
> grupa jest za duża na jakikolwiek pojedynczy stolik, ale wystarczająco
> mała, żeby zmieścić się w połączonej pojemności. Które konkretnie
> stoliki można łączyć, to stały, znany zestaw (Wy decydujecie które i
> ile par łączalnych istnieje, jako część projektu) — to nie jest
> "połącz dowolne dwa stoliki", to "te dwa stoliki akurat da się
> zsunąć w sali".

1. Utwórz gałąź dla tej zmiany (na przykład `feature/combined-tables`).
2. Zanim napiszesz jakikolwiek kod, zapisz przewidywanie w
   `docs/change-request-impact.md` (w repozytorium Waszego zespołu —
   utwórz `docs/`, jeśli jeszcze nie istnieje): które pliki albo
   komponenty spodziewasz się dotknąć, i czy Wasz obecny model danych
   ma już naturalne miejsce, żeby reprezentować "ta rezerwacja używa
   więcej niż jednego stolika"? Zacommituj to przewidywanie samo, jako
   osobny commit, zanim istnieje jakikolwiek kod implementacji — na
   przykład `docs: predict impact of combined-table change`. To jest
   zapis "przed", z którym porównasz się później; napisanie go po
   fakcie zrobiłoby z niego retrospektywę udającą przewidywanie.
3. Zaimplementuj zmianę, aktualizując i dodając testy w miarę
   potrzeby. Jeśli istniejący test musiał się zmienić tylko z powodu
   zmiany nazwy kształtu danych (nie dlatego, że jego faktyczna asercja
   zachowania była błędna), zanotuj to konkretnie w
   `docs/change-request-impact.md` — to jest dokładnie ten rodzaj
   kosztu zmiany powierzchni, o który Lab 12 prosił Was uważać.
4. Zanim otworzysz PR do review — nie po zmergowaniu — zaktualizuj ten
   sam `docs/change-request-impact.md` o to, co faktycznie się stało:
   które pliki albo komponenty faktycznie się zmieniły, jak to się ma
   do Twojego przewidywania, jakie nieoczekiwane powiązania się
   pojawiły, i co okazało się łatwiejsze albo trudniejsze niż
   oczekiwano. Powierzchnia zmiany jest sygnałem do analizy, nie
   wynikiem do minimalizowania — kilka sensownie powiązanych plików
   zmienionych z dobrego powodu może być lepszym wynikiem niż hack
   dotykający tylko jednego. Ta aktualizacja musi trafić do tego samego
   PR-a co implementacja, nie do osobnego commita po merge'u.
5. Otwórz PR, zdobądź review i zmerguj dopiero, gdy CI jest zielone —
   ta sama pętla co w Lab 27.

## Kryteria akceptacji

- Zachowanie łączenia stolików jest zaimplementowane, przetestowane,
  zrecenzowane i zmergowane przez ten sam workflow PR co Lab 27.
- `docs/change-request-impact.md` zawiera zarówno przewidywanie
  *przed*, jak i rzeczywistość *po*, i jest uczciwe co do wszelkich
  rozbieżności.
- Przewidywanie istnieje jako osobny commit w historii Gita, przed
  jakimkolwiek commitem implementującym zmianę — nie napisane po
  fakcie.
- Aktualizacja o rzeczywistym wpływie była częścią tego samego pull
  requesta, który implementował zmianę: `git status --short` jest
  czyste po merge'u, bez osobnego commita dokumentacyjnego dodanego
  później.
- Wasz pełny zestaw testów (MVP + ta zmiana) przechodzi z zielonym CI.

## Weryfikacja

```bash
# from your team's own repository
<your test command>
```

Oczekiwane: pełny zestaw zielony, włącznie z nowymi testami dla
zachowania łączenia stolików i dla odrzucenia grupy za dużej na
jakąkolwiek kombinację.

## Zastanów się

- Gdyby Wasz model danych miał już `table_ids: list` zamiast
  pojedynczego `table_id`, ta zmiana byłaby dużo mniejsza. Czy to
  dlatego, że Wasz zespół przewidział to wymaganie, czy z powodu
  niepowiązanej decyzji, która akurat zostawiła na to miejsce?
- Porównaj faktyczny koszt tej zmiany z tym, jak pewny siebie
  wydawał się Wasz `PROJECT_PLAN.md` co do Waszego projektu w Lab 26.
  Czy napisalibyście teraz swoje założenia z Lab 26 inaczej?

## Jeśli utkniesz

- **Podpowiedź 1:** Jeśli Wasze MVP przechowywało pojedynczy
  `table_id` na rezerwację, najmniejsza poprawna zmiana to zwykle
  przechowywanie listy id stolików wszędzie tam, gdzie to pole jest
  czytane albo zapisywane — oprzyjcie się pokusie dodania drugiego,
  równoległego pola tylko dla przypadku łączonego.
- **Podpowiedź 2:** Zdecydujcie swoje łączalne pary jako statyczne,
  znane dane (stała lista), a nie "dowolne dwa stoliki, które akurat
  się sumują" — brief konkretnie mówi, że to fizycznie stałe pary.
- **Podpowiedź 3:** Jeśli testy nie przechodzą tylko dlatego, że pole
  zmieniło nazwę, a faktyczne zachowanie, które sprawdzają, się nie
  zmieniło, to znak, że niepowodzenie dotyczy kształtu Waszych danych,
  a nie prawdziwej regresji — napraw asercję, nie logikę.

## Co dalej

Poczuliście, ile kosztuje prawdziwa zmiana wymagań. Dalej coś idzie
nie tak na produkcji, o co nikt nie prosił — i przekonacie się, czy
Wasze testy złapałyby to, zanim złapał to klient.

Przejdź do [Lab 29 — Incydent produkcyjny](../29-production-incident/README.pl.md).
