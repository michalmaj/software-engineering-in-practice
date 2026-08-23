# Lab 28 — Zmiana wymagań

## Sytuacja

Właściciel restauracji dzwoni: "Ciągle odmawiamy dużym grupom —
przyjęciom urodzinowym, kolacjom firmowym, dziesięciu czy dwunastu
osobom. Czy system może to obsłużyć, zsuwając dwa stoliki?" Wasze MVP
było zbudowane wokół jednej rezerwacji, jednego stolika.

## Cele nauki

Po tym laboratorium powinieneś/aś umieć:

- Zaimplementować prawdziwą zmianę wymagań względem własnego,
  istniejącego projektu, a nie przykładu-zabawki.
- Zidentyfikować dokładnie, które pliki i kształty danych zmiana Cię
  zmusza dotknąć — a których nie.
- Ocenić uczciwie, czy Wasz projekt z Lab 26-27 uczynił tę zmianę tanią
  czy drogą, i wyjaśnić dlaczego.

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

1. Zaimplementuj tę zmianę w swoim kodzie.
2. Zanim napiszesz jakikolwiek kod, zapisz (w
   `labs/28-change-request/impact-notes.md`) przewidywanie: które
   pliki spodziewasz się dotknąć, i czy Wasz obecny model danych ma już
   naturalne miejsce, żeby reprezentować "ta rezerwacja używa więcej
   niż jednego stolika"?
3. Zaimplementuj zmianę, aktualizując i dodając testy w miarę
   potrzeby. Jeśli istniejący test musiał się zmienić tylko z powodu
   zmiany nazwy kształtu danych (nie dlatego, że jego faktyczna asercja
   zachowania była błędna), zanotuj to konkretnie w
   `impact-notes.md` — to jest dokładnie ten rodzaj kosztu zmiany
   powierzchni, o który Lab 12 prosił Was uważać.
4. Po zmergowaniu zaktualizuj `impact-notes.md` o to, co faktycznie się
   stało: jak bliskie było Twoje przewidywanie? Które pliki faktycznie
   się zmieniły?

## Kryteria akceptacji

- Zachowanie łączenia stolików jest zaimplementowane, przetestowane,
  zrecenzowane i zmergowane przez ten sam workflow PR co Lab 27.
- `impact-notes.md` zawiera zarówno przewidywanie *przed*, jak i
  rzeczywistość *po*, i jest uczciwe co do wszelkich rozbieżności.
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
