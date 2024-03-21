--- 1. Сделать запрос для получения атрибутов из указанных таблиц, применив фильтры по указанным условиям:
--- Таблицы: Н_ЛЮДИ, Н_ВЕДОМОСТИ.
--- Вывести атрибуты: Н_ЛЮДИ.ОТЧЕСТВО, Н_ВЕДОМОСТИ.ДАТА.
--- Фильтры (AND):
--- a) Н_ЛЮДИ.ИМЯ = Александр.
--- b) Н_ВЕДОМОСТИ.ИД = 1250972.
--- Вид соединения: INNER JOIN.

SELECT Н_ЛЮДИ.ОТЧЕСТВО, Н_ВЕДОМОСТИ.ДАТА 
FROM Н_ЛЮДИ
INNER JOIN Н_ВЕДОМОСТИ ON Н_ЛЮДИ.ИД = Н_ВЕДОМОСТИ.ЧЛВК_ИД 
WHERE Н_ЛЮДИ.ИМЯ = 'Александр' AND Н_ВЕДОМОСТИ.ИД = 1250972;

-------------------------------------------------------------------------------------------

--- 2. Сделать запрос для получения атрибутов из указанных таблиц, применив фильтры по указанным условиям:
--- Таблицы: Н_ЛЮДИ, Н_ВЕДОМОСТИ, Н_СЕССИЯ.
--- Вывести атрибуты: Н_ЛЮДИ.ОТЧЕСТВО, Н_ВЕДОМОСТИ.ЧЛВК_ИД, Н_СЕССИЯ.УЧГОД.
--- Фильтры (AND):
--- a) Н_ЛЮДИ.ФАМИЛИЯ = Иванов.
--- b) Н_ВЕДОМОСТИ.ДАТА = 2010-06-18.
--- Вид соединения: LEFT JOIN.

SELECT Н_ЛЮДИ.ОТЧЕСТВО, Н_ВЕДОМОСТИ.ЧЛВК_ИД, Н_СЕССИЯ.УЧГОД
FROM Н_ЛЮДИ
LEFT JOIN Н_ВЕДОМОСТИ ON Н_ЛЮДИ.ИД = Н_ВЕДОМОСТИ.ЧЛВК_ИД
LEFT JOIN Н_СЕССИЯ ON Н_ВЕДОМОСТИ.СЭС_ИД = Н_СЕССИЯ.СЭС_ИД
WHERE Н_ЛЮДИ.ФАМИЛИЯ = 'Иванов'
AND Н_ВЕДОМОСТИ.ДАТА = '2010-06-18';

-------------------------------------------------------------------------------------------

--- 3. Составить запрос, который ответит на вопрос, есть ли среди студентов вечерней формы обучения те, кто младше 20 лет.

SELECT EXISTS (SELECT Н_ИЗМ_ЛЮДИ.ФАМИЛИЯ, Н_ИЗМ_ЛЮДИ.ДАТА_РОЖДЕНИЯ, Н_УЧЕНИКИ.КОНЕЦ, Н_ПЛАНЫ.ФО_ИД
FROM Н_ИЗМ_ЛЮДИ JOIN Н_УЧЕНИКИ ON Н_ИЗМ_ЛЮДИ.ЧЛВК_ИД = Н_УЧЕНИКИ.ЧЛВК_ИД
JOIN Н_ПЛАНЫ ON Н_УЧЕНИКИ.ПЛАН_ИД = Н_ПЛАНЫ.ПЛАН_ИД
WHERE Н_ИЗМ_ЛЮДИ.ДАТА_РОЖДЕНИЯ > '21.03.2004'
AND Н_ПЛАНЫ.ФО_ИД = 2 --- Проверка на вечернюю форму обучения
AND Н_УЧЕНИКИ.КОНЕЦ_ПО_ПРИКАЗУ > '21.03.2024'); --- Проверка на то, что все еще учится

-------------------------------------------------------------------------------------------

--- 4. Найти группы, в которых в 2011 году было более 5 обучающихся студентов на ФКТИУ.
--- Для реализации использовать подзапрос.

SELECT ГРУППЫ_КТиУ_2011.ГРУППА, ГРУППЫ_КТиУ_2011.КОЛИЧЕСТВО FROM
    (SELECT Н_УЧЕНИКИ.ГРУППА, count(Н_УЧЕНИКИ.ИД) AS КОЛИЧЕСТВО FROM Н_УЧЕНИКИ
    JOIN Н_ПЛАНЫ
    ON Н_УЧЕНИКИ.ПЛАН_ИД = Н_ПЛАНЫ.ИД
    AND Н_ПЛАНЫ.УЧЕБНЫЙ_ГОД = '2010/2011'
    JOIN Н_ОТДЕЛЫ
    ON Н_ОТДЕЛЫ.ИД = Н_ПЛАНЫ.ОТД_ИД
    AND Н_ОТДЕЛЫ.КОРОТКОЕ_ИМЯ = 'КТиУ'
    GROUP BY Н_УЧЕНИКИ.ГРУППА 
  ) AS ГРУППЫ_КТиУ_2011
WHERE ГРУППЫ_КТиУ_2011.КОЛИЧЕСТВО > 5;

-------------------------------------------------------------------------------------------

--- 5. Выведите таблицу со средним возрастом студентов во всех группах (Группа, Средний возраст),
--- где средний возраст меньше максимального возраста в группе 1101

SELECT Н_УЧЕНИКИ.ГРУППА, avg(date_part('year', age(Н_ЛЮДИ.ДАТА_РОЖДЕНИЯ)))
FROM Н_ЛЮДИ
JOIN Н_УЧЕНИКИ ON Н_УЧЕНИКИ.ЧЛВК_ИД = Н_ЛЮДИ.ИД
GROUP BY Н_УЧЕНИКИ.ГРУППА
HAVING avg(date_part('year', age(Н_ЛЮДИ.ДАТА_РОЖДЕНИЯ))) < (
    SELECT max(date_part('year', age(Н_ЛЮДИ.ДАТА_РОЖДЕНИЯ)))
    FROM Н_ЛЮДИ
    JOIN Н_УЧЕНИКИ ON Н_УЧЕНИКИ.ЧЛВК_ИД = Н_ЛЮДИ.ИД
    WHERE Н_УЧЕНИКИ.ГРУППА = '1101');

-------------------------------------------------------------------------------------------

--- 6. Получить список студентов, отчисленных до первого сентября 2012 года с заочной формы обучения. В результат включить:
--- номер группы;
--- номер, фамилию, имя и отчество студента;
--- номер пункта приказа;
--- Для реализации использовать соединение таблиц.

SELECT Н_УЧЕНИКИ.ГРУППА, Н_ЛЮДИ.ИД, Н_ЛЮДИ.ФАМИЛИЯ, Н_ЛЮДИ.ИМЯ, Н_ЛЮДИ.ОТЧЕСТВО, Н_УЧЕНИКИ.П_ПРКОК_ИД
FROM Н_УЧЕНИКИ
JOIN Н_ЛЮДИ ON Н_УЧЕНИКИ.ЧЛВК_ИД = Н_ЛЮДИ.ИД
JOIN Н_ПЛАНЫ ON Н_УЧЕНИКИ.ПЛАН_ИД = Н_ПЛАНЫ.ПЛАН_ИД
WHERE Н_УЧЕНИКИ.ПРИЗНАК = 'отчисл'
AND Н_УЧЕНИКИ.СОСТОЯНИЕ = 'утвержден'
AND Н_ПЛАНЫ.ФО_ИД = 3
AND Н_УЧЕНИКИ.КОНЕЦ < '01.09.2012';

--- 7. Вывести список студентов, имеющих одинаковые отчества, но не совпадающие ид.

SELECT Н_ЛЮДИ.ФАМИЛИЯ, Н_УЧЕНИКИ.ЧЛВК_ИД
FROM Н_ЛЮДИ
JOIN Н_УЧЕНИКИ ON Н_УЧЕНИКИ.ЧЛВК_ИД = Н_ЛЮДИ.ИД
WHERE Н_ЛЮДИ.ФАМИЛИЯ IN (
    SELECT ФАМИЛИЯ
    FROM Н_ЛЮДИ
    GROUP BY ФАМИЛИЯ
    HAVING COUNT(*) > 1)
AND Н_УЧЕНИКИ.ЧЛВК_ИД NOT IN (
    SELECT DISTINCT ЧЛВК_ИД
    FROM Н_УЧЕНИКИ
    GROUP BY ЧЛВК_ИД
    HAVING COUNT(*) > 1
)ORDER BY Н_ЛЮДИ.ФАМИЛИЯ;