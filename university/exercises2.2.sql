/*22.01a – Widok (view) i funkcja (function)
Nazwiska i imiona studentów zapisanych na wyk³ad z matematyki (Mathematics). 
Dane posortowane wed³ug nazwisk. U¿yj sk³adni podzapytania. 6 rekordów.
Studenci o nazwiskach (kolejno): Bowen, Foster, Holmes, Hunt, Palmer, Powell*/

select * from students
where student_id in
(select student_id from students_modules
where module_id in
(select module_id from modules
where module_name = 'Mathematics'))
order by surname

/*22.01b – Widok (view) i funkcja (function)
Napisz funkcjê o nazwie studmod_f, która zwróci nazwiska i imiona studentów zapisanych na wyk³ad o nazwie przekazanej
do funkcji przy pomocy parametru. Uruchom funkcjê podaj¹c jako parametr nazwê wybranego wyk³adu.*/

create or alter function studmod_f -- jesli istnieje alter ja podmieni, updatuje, _f oznacza ze to funkcja
(@module as varchar(100)) -- @up: podkresla bo utworzone
returns table as return
select * from students -- kod z poprzedniego pytania
where student_id in -- tu musi byc in
(select student_id from students_modules -- zapytanie wewnetrzne do tego powyzej
where module_id = -- moze byc = lub in
(select module_id from modules
where module_name=@module)) --'Mathematics'))
--order by surname -- w funkcji nie mozna sortowac, wiec trzebac to bez funkcji

select * from studmod_f('Mathematics') -- uruchamiamy funkcje 6 rek
SELECT * FROM studmod_f('Statistics') -- 4
SELECT * FROM studmod_f('Databases') -- 2


/*22.01c – Widok (view) i funkcja (function)
Jedn¹ z ró¿nic miêdzy funkcj¹ a widokiem jest to, ¿e do funkcji mo¿na przekazaæ parametr a do widoku nie. 
Aby przekazaæ parametr do widoku, mo¿na jednak u¿yæ context info lub session context (zobacz Chapter 1, Skill 3).
Utwórz widok o nazwie studmod_v, który zwróci nazwiska i imiona studentów zapisanych na wyk³ad o nazwie przekazanej 
do widoku przy pomocy session context. Wykorzystaj mechanizm session context do przekazania nazwy wyk³adu do widoku i uruchom widok*/

create or alter view studmod_v as -- _v jako view
select * from students
where student_id in 
(select student_id from students_modules 
where module_id = 
(select module_id from modules
where module_name=SESSION_CONTEXT(N'module')))--'Mathematics')) 
-- przekazujemy ja do widoku za pomoca session context
-- jesli zamkniemy sesje, trzeba go potem bedzie ponownie tworzyc!!!

--Instrukcja tworz¹ca parê @key-@value session context i uruchamiaj¹ca widok:
exec sp_set_session_context @key=N'module', @value='Statistics'
select * from studmod_v


/*22.02 – Funkcja ROW_NUMBER()
Wszystkie dane z tabeli student_grades, w ramach ka¿dego module_id (partition by) posortowane wed³ug daty egzaminu a nastêpnie 
identyfikatora studenta oraz ponumerowane kolejnymi liczbami. Pole zawieraj¹ce kolejny numer oceny w ramach ka¿dego module_id 
ma mieæ nazwê sequence_num.*/

SELECT ROW_NUMBER() OVER
(PARTITION BY module_id
ORDER BY exam_date, student_id) AS sequence_num,
student_id, module_id, exam_date, grade
FROM student_grades;

/*22.03 – Funkcja ROW_NUMBER()
Wszystkie dane z tabeli student_grades, w ramach ka¿dego student_id posortowane wed³ug daty egzaminu oraz ponumerowane kolejnymi liczbami.
Zapytanie ma zwróciæ jedynie dane o ocenach pozytywnych (wiêkszych ni¿ 2). Pole zawieraj¹ce kolejny numer oceny w ramach ka¿dego student_id 
ma mieæ nazwê sequence_num. 45 rekordów 
pierwsze cztery dotycz¹ studenta o id=1 (w kolumnie sequence_num s¹ liczby 1-4)
kolejne cztery dotycz¹ studenta o id=2 (w kolumnie sequence_num s¹ liczby 1-4), itd.*/

(SELECT ROW_NUMBER() OVER
(PARTITION BY student_id
ORDER BY exam_date) AS sequence_num,
student_id, module_id, exam_date, grade
FROM
(SELECT*FROM student_grades WHERE grade > 2) AS D)

/*22.04 – Funkcja ROW_NUMBER() -- przekombinowane, lepsze cte albo derive table
Identyfikatory i nazwiska studentów oraz daty egzaminów, w ramach ka¿dego student_id posortowane wed³ug daty egzaminu oraz ponumerowane
kolejnymi liczbami. Zapytanie ma zwróciæ jedynie dane o ocenach negatywnych (równych 2). Pole zawieraj¹ce kolejny numer oceny w 
ramach ka¿dego student_id ma mieæ nazwê sequence_num. 13 rekordów
studenci o identyfikatorach 2, 3 i 12 maj¹ po dwie oceny 2,0
studenci o identyfikatorach 1, 6, 7, 8, 10, 20 i 33 po jednej*/

(SELECT ROW_NUMBER() OVER
(PARTITION BY student_id
ORDER BY exam_date) AS sequence_num,
student_id, exam_date, surname, grade
FROM
(SELECT
s_g.student_id, exam_date, surname, grade
FROM student_grades s_g JOIN students s ON s_g.student_id = s.student_id
WHERE grade = 2) AS D)

/*22.05 – Funkcja ROW_NUMBER()
Wszystkie dane z tabeli students, grupami. W ramach ka¿dej grupy dane posortowane wed³ug daty urodzenia studenta. W ramach ka¿dej grupy 
rekordy maj¹ byæ ponumerowane. 35 rekordów. Zauwa¿, ¿e w pierwszych 7 rekordach group_no jest NULL i rekordy te s¹ traktowane jako jedna partycja.*/

SELECT ROW_NUMBER() OVER 
(PARTITION BY group_no
ORDER BY date_of_birth) AS rownum,
group_no, student_id, surname, first_name, date_of_birth
FROM students;

/*22.06a -- to lepsze
Identyfikator, nazwisko i datê ostatniego egzaminu dla ka¿dego studenta. Zapytanie ma zwróciæ jedynie dane o studentach, 
którzy przyst¹pili co najmniej do jednego egzaminu. Napisz zapytanie w dwóch wersjach: raz u¿ywaj¹c sk³adni derived tables, raz CTE.
21 rekordów Trzeci: 3, Hunt, 2018-09-20 Ostatni: 33, Bowen, 2018-09-23*/

--Derived tables:

SELECT dt.student_id, surname, exam_date, rownum FROM
(SELECT ROW_NUMBER() OVER 
(PARTITION BY s.student_id
ORDER BY exam_date DESC) AS rownum,
s.student_id, surname, exam_date
FROM students s INNER JOIN student_grades sg ON s.student_id=sg.student_id) AS dt
WHERE rownum=1

--CTE:

with cte_table as (
select ROW_NUMBER() over (partition by s.student_id order by exam_date desc) rownum,
s.student_id, surname, exam_date
from students s inner join student_grades sg on s.student_id=sg.student_id)
select * from cte_table where rownum=1

/*22.06b
Korzystaj¹c z poprzedniego zapytania utwórz widok (VIEW) o nazwie last_exam zwracaj¹cy identyfikator, nazwisko i datê ostatniego egzaminu 
dla ka¿dego studenta. Uruchom widok i sprawdŸ poprawnoœæ jego dzia³ania. 
Wskazówka: Aby utworzyæ widok, nale¿y zapytanie poprzedziæ instrukcj¹ CREATE VIEW.
Uwaga: Widok nie mo¿e mieæ takiej samej nazwy jak inny obiekt w bazie danych (tabela, funkcja).*/

CREATE OR ALTER VIEW last_exam AS
WITH cte AS
(SELECT ROW_NUMBER() OVER 
(PARTITION BY s.student_id
ORDER BY exam_date DESC) AS rownum,
s.student_id, surname, exam_date
FROM students s INNER JOIN student_grades sg 
ON s.student_id=sg.student_id)
SELECT student_id, surname, exam_date
FROM cte
WHERE rownum=1;

SELECT * FROM last_exam


/*(22.06c
Zmodyfikuj utworzony widok o nazwie last_exam, aby wywo³uj¹c go instrukcj¹ SELECT mo¿na by³o podaæ liczbê oznaczaj¹c¹, 
ile rekordów z danymi o ostatnich egzaminach ma zostaæ zwróconych dla ka¿dego studenta. Wskazówka: widok powinien zwracaæ 
dane o wszystkich egzaminach dla ka¿dego studenta, dziêki czemu zapytanie uruchamiaj¹ce widok mo¿e zawieraæ klauzulê WHERE 
zawieraj¹c¹ warunek wskazuj¹cy, ile ostatnich egzaminów dla ka¿dego studenta ma zostaæ zwróconych.*/

CREATE OR ALTER VIEW last_exam AS
WITH CTE_table AS
(SELECT ROW_NUMBER() OVER 
(PARTITION BY s.student_id
ORDER BY exam_date DESC) AS rownum,
s.student_id, surname, exam_date
FROM students s INNER JOIN student_grades sg 
ON s.student_id=sg.student_id)
SELECT student_id, surname, exam_date, rownum
FROM CTE_table
--WHERE rownum=1;
-- W widoku nale¿y usun¹æ ostatni¹ klauzulê WHERE oraz w ostatniej instrukcji SELECT umieœciæ na liœcie pole rownum.

SELECT * FROM last_exam
WHERE rownum=1 --zwraca 21 rekordów
SELECT * FROM last_exam
WHERE rownum<=3 --zwraca 46 rekordów

/*22.06d
Korzystaj¹c z poprzedniego zapytania utwórz funkcjê o nazwie last_exams zwracaj¹c¹ identyfikator, nazwisko i datê tylu ostatnich egzaminów
ka¿dego studenta, ile wynosi wartoœæ parametru funkcji (np. jeœli jako parametr funkcji podana zostanie liczba 4, to funkcja ma 
zwróciæ daty ostatnich 4 egzaminów ka¿dego studenta). Uruchom funkcjê i sprawdŸ poprawnoœæ jej dzia³ania.*/

CREATE OR ALTER FUNCTION last_exams(@exam_no AS int) 
RETURNS TABLE AS RETURN
WITH CTE_table AS
(SELECT ROW_NUMBER() OVER 
(PARTITION BY s.student_id
ORDER BY exam_date DESC) AS rownum,
s.student_id, surname, exam_date
FROM students s INNER JOIN student_grades sg 
ON s.student_id=sg.student_id)
SELECT student_id, surname, exam_date
FROM CTE_table
WHERE rownum<=@exam_no;

SELECT * FROM last_exams(1) --zwraca 21 rekordów
SELECT * FROM last_exams(2) --zwraca 37 rekordów
SELECT * FROM last_exams(4) --zwraca 52 rekordy

/*22.07a
Wszystkie dane o dwóch najm³odszych studentach w ka¿dej grupie. W zapytaniu pomiñ dane o studentach, którzy nie s¹ przypisani do
¿adnej grupy oraz o tych, którzy nie maj¹ przypisanej daty urodzenia. Napisz zapytanie w dwóch wersjach: raz u¿ywaj¹c sk³adni 
derived tables, raz CTE. 17 rekordów.*/


--Derived tables:

SELECT rownum, group_no, student_id, surname, first_name, date_of_birth
FROM
(SELECT ROW_NUMBER() OVER 
(PARTITION BY group_no
ORDER BY date_of_birth DESC) AS rownum,
group_no, student_id, surname, first_name, date_of_birth
FROM students
WHERE group_no IS NOT NULL and date_of_birth IS NOT NULL) AS s
WHERE rownum<=2;

--CTE:

WITH CTE_table AS
(SELECT ROW_NUMBER() OVER 
(PARTITION BY group_no
ORDER BY date_of_birth DESC) AS rownum,
group_no, student_id, surname, first_name, date_of_birth
FROM students
WHERE group_no IS NOT NULL and date_of_birth IS NOT NULL)
SELECT rownum, group_no, student_id, surname, first_name,
date_of_birth
FROM CTE_table
WHERE rownum<=2;

/*22.07b
Korzystaj¹c z poprzedniego zapytania napisz funkcjê o nazwie youngest_students, która zwróci dane o tylu najm³odszych studentach, 
ile wskazuje pierwszy parametr funkcji, z grupy, której nazwa zostanie podana jako drugi parametr.
Uruchom funkcjê (wykorzystaj instrukcjê SELECT) i sprawdŸ poprawnoœæ jej dzia³ania.
Wywo³anie funkcji:*/

CREATE or ALTER FUNCTION youngest_students 
(@number AS tinyint, @group AS varchar(20)) 
RETURNS TABLE AS RETURN
WITH s AS
(SELECT ROW_NUMBER() OVER 
(PARTITION BY group_no
ORDER BY date_of_birth DESC) AS rownum,
group_no, student_id, surname, first_name, date_of_birth
FROM students
WHERE group_no=@group and date_of_birth IS NOT NULL)
SELECT rownum, group_no, student_id, surname, first_name,
date_of_birth
FROM s
WHERE rownum<=@number;

SELECT * FROM youngest_students(4, 'DMIe1011')
SELECT * FROM youngest_students(3, 'ZMIe2012')
SELECT * FROM youngest_students(5, 'DZZa3001')

/*22.08a – recursive CTE
Module_id, module_name and no_of_hours wyk³adu o identyfikatorze 9 wraz z ³añcuchem poprzedzaj¹cych wyk³adów. Kolumnê zawieraj¹c¹ 
kolejny poziom nazwij distance.*/

WITH modulesCTE AS
(SELECT module_id, module_name, preceding_module, no_of_hours, 0 AS distance
FROM modules
WHERE module_id = 9
UNION ALL
SELECT m.module_id, m.module_name, m.preceding_module, m.no_of_hours,
e.distance + 1 AS distance
FROM modulesCTE e INNER JOIN modules m
ON e.preceding_module = m.module_id)
SELECT module_id, module_name, no_of_hours, distance
FROM modulesCTE;


/*22.08b
Na podstawie powy¿szego zapytania napisz funkcjê o nazwie preceding_modules zwracaj¹c¹ module_id, module_no oraz no_of_hours wyk³adu 
o identyfikatorze podanym jako parametr funkcji wraz z ³añcuchem poprzedzaj¹cych wyk³adów.*/

CREATE or ALTER FUNCTION preceding_modules 
(@number AS tinyint) RETURNS TABLE AS 
RETURN
WITH modulesCTE AS
(SELECT module_id, module_name, preceding_module, no_of_hours, 0 AS distance FROM modules
WHERE module_id = @number
UNION ALL
SELECT m.module_id, m.module_name, m.preceding_module, m.no_of_hours,
e.distance + 1 AS distance
FROM modulesCTE e INNER JOIN modules m
ON e.preceding_module = m.module_id)
SELECT module_id, module_name, no_of_hours, distance
FROM modulesCTE;

select * from preceding_modules(9)

