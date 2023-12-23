-- 1.1. Показать все названия книг вместе с именами издателей.
SELECT "Title", "PubName" FROM "Book"

-- 1.2. В какой книге наибольшее количество страниц?
SELECT "Book".* FROM "Book"
INNER JOIN (SELECT max("PagesNum") FROM "Book") AS max ON "PagesNum" = max

-- 1.3. Какие авторы написали более 5 книг?
SELECT Ac.* FROM (SELECT "Author", count(*) count
                  FROM "Book" counting
                  GROUP BY "Author") as Ac
WHERE count > 5

-- 1.4. В каких книгах более чем в два раза больше страниц, чем среднее количество страниц для всех книг?
SELECT "Book".* FROM "Book"
CROSS JOIN (SELECT avg("PagesNum") FROM "Book") as Ba
WHERE "PagesNum" > Ba.avg

-- 1.5. Какие категории содержат подкатегории?
SELECT "Category".* FROM "Category"
INNER JOIN public."Category" BC ON "Category"."CategoryName" = BC."ParentCat"

-- 1.6. У какого автора (предположим, что имена авторов уникальны) написано максимальное количество книг?
SELECT Ac."Author"
FROM (SELECT "Author", count("Author") count
      FROM "Book"
      GROUP BY "Author"
      ORDER BY count DESC) AS Ac
LIMIT 1

-- 1.7.  Какие читатели забронировали все книги (не копии), написанные "Марком Твеном"?
SELECT R.* FROM "Borrowing"
INNER JOIN public."Book" B on "Borrowing"."ISBN" = B."ISBN"
INNER JOIN public."Reader" R on "ReaderNr" = R."ID"
WHERE B."Author" = 'Марк Твен'

-- 1.8. Какие книги имеют более одной копии?
SELECT * FROM "Book" WHERE (SELECT count(*) FROM "Copy" WHERE "Book"."ISBN" = "Copy"."ISBN") >= 1

-- 1.9. ТОП 10 самых старых книг
SELECT * FROM "Book" ORDER BY "PubYear" LIMIT 10

-- 2.1. Добавьте запись о бронировании читателем ‘Василеем Петровым’ книги с ISBN 123456 и номером копии 4.
INSERT INTO "Borrowing" ("ISBN", "CopyNumber", "ReaderNr", "ReturnData")
    SELECT '123456', 4, "Reader"."ID", NULL
    FROM "Reader" WHERE "Reader"."FirstName" = 'Василий' AND "Reader"."LastName" = 'Петров'

-- 2.2. Удалить все книги, год публикации которых превышает 2000 год.
DELETE FROM "Book" WHERE "PubYear" > 2000

-- 2.3. Измените дату возврата для всех книг категории "Базы данных", начиная с 01.01.2016, чтобы они были в заимствовании на 30 дней дольше (предположим, что в SQL можно добавлять числа к датам).
UPDATE "Borrowing"
SET "ReturnData" = "ReturnData" + interval '30 day'
WHERE "ReturnData" > '01-01-2016'
  AND exists(SELECT * FROM "BookCat" WHERE "BookCat"."ISBN" = "Borrowing"."ISBN" AND "BookCat"."CategoryName" = 'Базы данных')
