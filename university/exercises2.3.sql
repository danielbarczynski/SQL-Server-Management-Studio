/*23/1.01
Liczba student�w zarejestrowanych w bazie danych.
Zapytanie zwraca liczb� 35*/

select COUNT(*) from students

/*23/1.02
Liczba student�w, kt�rzy s� przypisani do jakiej� grupy.
Zapytanie zwraca liczb� 28*/

select COUNT(group_no) from students

/*23/1.03
Liczba student�w, kt�rzy nie s� przypisani do �adnej grupy.
Zapytanie zwraca liczb� 7*/

select COUNT(*) from students
where group_no is null

/*23/1.04
Liczba grup, do kt�rych jest przypisany co najmniej jeden student.
Takich grup jest 12*/

select COUNT(distinct group_no) from students

/*23/1.05
Nazwy grup, do kt�rych zapisany jest przynajmniej jeden student wraz z liczb� zapisanych student�w. Zapytanie ma zwr�ci� tak�e informacj�,
ilu student�w nie jest zapisanych do �adnej grupy. Kolumna zwracaj�ca liczb� student�w ma mie� nazw� no_of_students. Dane posortowane 
rosn�co wed�ug liczby student�w. 13 rekord�w w pi�ciu grupach jest po jednym studencie, w czterech po dw�ch,
w jednej czterech, w jednej pi�ciu, w jednej sze�ciu i w jednej siedmiu*/

select distinct group_no, COUNT(*) as no_of_students from students -- domyslnie chyba wlasnie student_id liczy, klucz glowny
group by group_no -- bez tego blad lol
order by no_of_students

/*23/1.06
Nazwy grup, do kt�rych zapisanych jest przynajmniej trzech student�w wraz z liczb� tych student�w.
Kolumna zwracaj�ca liczb� student�w ma mie� nazw� no_of_students. Dane posortowane rosn�co wed�ug liczby student�w. 4 rekordy*/

select distinct group_no, COUNT(*) as no_of_students from students
group by group_no
having count(*) >= 3

/*23/1.07
Wszystkie mo�liwe oceny oraz ile razy ka�da z ocen zosta�a przyznana (kolumna ma mie� nazw� no_of_grades). Dane posortowane wed�ug ocen.
8 rekord�w. Ocena 2.0 zosta�a przyznane 13 razy. Ocena 5.5 4 razy. Ocena 6.0 nie zosta�a przyznana ani raz.*/

select grade, COUNT(*) as no_of_grades from student_grades
group by grade

/*23/1.08
Nazwy wszystkich katedr oraz ile godzin wyk�ad�w w sumie maj� pracownicy zatrudnieni w  tych katedrach. 
Kolumna zwracaj�ca liczb� godzin ma mie� nazw� total_hours. Dane posortowane rosn�co wed�ug kolumny total_hours.
11 rekord�wDla pierwszych sze�ciu total_hours jest NULLOstatni rekord: Department of Informatics, 117 godzin*/

select d.department, SUM(no_of_hours) total_hours from departments d -- z departments poniewaz WSZYSTKICH
left join lecturers l on d.department=l.department -- dlatego tez left join
left join modules m on l.lecturer_id=m.lecturer_id
group by d.department
order by total_hours

select * from modules

/*23/1.09
Nazwisko ka�dego wyk�adowcy wraz z liczb� prowadzonych przez niego wyk�ad�w (zapytanie ma zwr�ci� tak�e nazwiska wyk�adowc�w, kt�rzy 
nie prowadz� �adnego wyk�adu). Kolumna zawieraj�ca liczb� wyk�ad�w ma mie� nazw� no_of_modules. Dane posortowane malej�co wed�ug nazwiska.
28 rekord�w. Pierwszy: Wright, nie prowadzi �adnego wyk�adu. Trzeci: White, prowadzi jeden wyk�ad.*/

select l.lecturer_id ,surname, COUNT(module_id) no_of_modules from lecturers l
left join employees e on l.lecturer_id=e.employee_id
left join modules m on l.lecturer_id=m.lecturer_id
group by surname, l.lecturer_id
order by surname desc

/*23/1.10
Nazwiska i imiona wyk�adowc�w prowadz�cych co najmniej dwa wyk�ady wraz z liczb� prowadzonych przez nich wyk�ad�w.
Dane posortowane malej�co wed�ug liczby wyk�ad�w a nast�pnie rosn�co wed�ug nazwiska.
6 rekord�w. Pierwszy: Harry Jones, 4 wyk�ady Ostatni: Lily Taylor, 2 wyk�ady*/

select surname, first_name, lecturers.lecturer_id, COUNT(module_id) no_of_modules from lecturers
left join employees on employee_id=lecturer_id
left join modules on modules.lecturer_id=lecturers.lecturer_id
group by surname, first_name, lecturers.lecturer_id
having COUNT(module_id)>=2
order by no_of_modules desc, surname 

--or

SELECT surname, first_name
FROM modules INNER JOIN employees ON lecturer_id=employee_id


SELECT surname, first_name, count(*) AS no_of_modules
FROM modules INNER JOIN employees ON lecturer_id=employee_id
GROUP BY employee_id, surname, first_name
HAVING count(*)>=2
ORDER BY no_of_modules DESC, surname

/*23/1.11a
Nazwiska i imiona wszystkich student�w o nazwisku Bowen, kt�rzy otrzymali przynajmniej jedn� ocen� wraz ze �redni� ocen 
(ka�dego Bowena z osobna). Kolumna zwracaj�ca �redni� ma mie� nazw� avg_grade. Dane posortowane malej�co wed�ug nazwisk i 
malej�co wed�ug imion. Dwa rekordy:  Harry Bowen, �rednia 3.7 Charlie Bowen, �rednia 2.0*/

select first_name, surname, AVG(grade) as avg_grade from students s
join student_grades sg on s.student_id=sg.student_id
where surname = 'Bowen'
group by first_name, surname
order by surname desc, first_name desc

/*23/1.11b
Na podstawie powy�szego zapytania utw�rz funkcj� o nazwie avg_grade, kt�ra zwr�ci dane o studentach, kt�rych nazwisko zostanie podane 
jako parametr. Pami�taj, �e w funkcji nie wolno u�ywa� klauzuli ORDER BY.*/

create or alter function avg_grade
(@surname as varchar(50))
returns table as return
select s.student_id, first_name, surname, group_no, AVG(grade) avg_grade from students s
join student_grades sg on s.student_id=sg.student_id
where surname = @surname
group by s.student_id, first_name, surname, group_no

SELECT * FROM avg_grade('Fisher') --zwraca jeden rekord: Katie Fisher, �rednia 4.1666

/*23/1.12a
Napisz funkcj� o nazwie student_no, kt�ra zwr�ci liczb� student�w zapisanych na wyk�ad o nazwie podanej jako parametr. 
Spraw, aby w parametrze usuni�te zosta�y wszystkie wiod�ce i ko�cowe spacje.*/

create or alter function student_no
(@module as varchar(50))
returns table as return 
select COUNT(student_id) student_no from modules m
join students_modules sm on m.module_id=sm.module_id 
where module_name=@module


SELECT * FROM student_no('Databases') -- z ewentualnymi spacjami na pocz�tku i ko�cu --zwraca liczb� 2
SELECT * FROM student_no('Statistics') --zwraca liczb� 4
SELECT * FROM student_no('Macroeconomics') --zwraca liczb� 0

/*23/1.12b
Zmodyfikuj poprzedni� funkcj�, aby zwraca�a nazwy wyk�ad�w wraz z liczb� student�w zapisanych na ka�dy z wyk�ad�w o nazwie 
zaczynaj�cej si� tekstem podanym jako parametr. Je�li jako parametr zostanie podana warto�� NULL, funkcja ma zwr�ci� tabel� pust�.
Wskaz�wka: w klauzuli WHERE u�yj operatora +
Na wyk�ad Computer network devices zapisanych jest 9 student�w.
Na Contemporary history 2 student�w.*/

create or alter function student_no
(@module as varchar(50))
returns table as return 
select module_name, COUNT(student_id) student_no from modules m
join students_modules sm on m.module_id=sm.module_id 
where module_name like @module + '%'
group by module_name

SELECT * FROM student_no(NULL) --zwraca tabel� pust�
SELECT * FROM student_no('C') --Zwraca 5 rekord�w. 

/*23/1.12c
Zmodyfikuj poprzedni� funkcj�, aby dla parametru NULL funkcja zwraca�a dane o wszystkich wyk�adach.
Wskaz�wka: w klauzuli WHERE u�yj funkcji CONCAT*/

create or alter function student_no
(@module as varchar(50))
returns table as return 
select module_name, COUNT(student_id) student_no from modules m
left join students_modules sm on m.module_id=sm.module_id 
where module_name like concat(@module, '%')
group by module_name

SELECT * FROM student_no(NULL) -- zwraca 26 rekord�w na cztery wyk�ady nie zapisa� si� �aden student
SELECT * FROM student_no('Macroeconomics') -- zwraca 1 rekord: Marcroeconomics, 0 student�w

/*23/1.13
Nazwiska i imiona wyk�adowc�w, kt�rzy prowadz� co najmniej jeden wyk�ad wraz ze �redni� ocen jakie dali studentom 
(je�li wyk�adowca nie da� do tej pory �adnej oceny, tak�e ma si� pojawi� na li�cie). Kolumna zwracaj�ca �redni� ma mie�
nazw� avg_grade. Dane posortowane malej�co wed�ug �redniej.
11 rekord�w. Pierwszy rekord: James Robinson, �rednia 5.0. Jeden wyk�adowca nie wystawi� �adnej oceny.*/

select surname, first_name, avg(grade) avg_grade from lecturers l
join employees e on l.lecturer_id=e.employee_id
join modules m on l.lecturer_id=m.lecturer_id
left join student_grades sg on m.module_id=sg.module_id
group by l.lecturer_id, surname, first_name -- po dodaniu l.lecturer_id, przybyl rekord. TRZEBA PRZY JOINACH DOPISYWAC TAK�E DOLACZONE ID
order by avg_grade desc

/*23/1.14a
Nazwy wyk�ad�w oraz kwot�, jak� uczelnia musi przygotowa� na wyp�aty pracownikom prowadz�cym wyk�ady ze Statistics i Economics (osobno).
Je�li jest wiele wyk�ad�w o nazwie Statistics lub Economics, suma dla nich ma by� obliczona ��cznie. Zapytanie ma wi�c zwr�ci� 
dwa rekordy (jeden dla wyk�ad�w ze Statistics, drugi dla Economics).
Kwot� za jeden wyk�ad nale�y obliczy� jako iloczyn stawki godzinowej prowadz�cego wyk�adowcy oraz liczby godzin przeznaczonych na wyk�ad.
Zapytanie zwraca jeden rekord: Economics 1200.00
Odpowiedz na pytanie, dlaczego zapytanie nie zwr�ci�o danych o wyk�adzie Statistics.*/

SELECT module_name, SUM(overtime_rate * no_of_hours) sum_of_money FROM acad_positions ap 
JOIN lecturers l ON ap.acad_position=l.acad_position
JOIN modules m ON m.lecturer_id=l.lecturer_id
WHERE module_name in ('Statistics','Economics')
GROUP BY module_name


/*23/1.14b
Zapytanie zwracaj�ce jedn� liczb�: kwot�, jak� uczelnia musi przygotowa� na wyp�aty z tytu�u prowadzonych wyk�ad�w. 
Kwot� za jeden wyk�ad nale�y wyliczy� jako iloczyn stawki godzinowej prowadz�cego wyk�adowcy oraz liczby godzin przeznaczonych 
na ten wyk�ad. Pami�taj, aby nazwa� kolumn� zwracaj�c� szukan� kwot�.
Odpowiedz na pytanie: czy mo�liwe jest wyliczenie pe�nej kwoty nale�no�ci z tytu�u przeprowadzonych wyk�ad�w? Uzasadnij odpowied�.
Wynikiem jest kwota 20265.00*/

SELECT SUM(overtime_rate * no_of_hours) sum_of_money FROM acad_positions ap 
JOIN lecturers l ON ap.acad_position=l.acad_position
JOIN modules m ON m.lecturer_id=l.lecturer_id

/*23/1.14c
Kwot�, jak� uczelnia musi przygotowa� na wyp�aty z tytu�u prowadzenia wyk�ad�w, kt�rym nie jest przypisany �aden wyk�adowca, 
przy za�o�eniu, �e za godzin� takiego wyk�adu nale�y zap�aci� �redni� z pola overtime_rate w tabeli acad_positions.
Wskaz�wka: wykorzystaj CTE. Wynik CTE, kt�rym b�dzie obliczona �rednia, po��cz iloczynem kartezja�skim z tabel� modules.
7649.99*/

with cte as
(select avg(overtime_rate) avg_or FROM acad_positions)
select SUM(no_of_hours*avg_or)
from modules cross join cte
where lecturer_id is null

/*23/1.14d
Maksymaln� kwot�, jak� uczelnia musi przygotowa� na wyp�aty z tytu�u prowadzenia wyk�ad�w, dla kt�rych nie mo�na tej kwoty obliczy�.
S� to wyk�ady, kt�rym nie jest przypisany �aden wyk�adowca lub wyk�adowca jest przypisany, ale nieznany jest jego stopie�/tytu� naukowy.
13200*/

with maksimum as
(select max(overtime_rate) avg_or from acad_positions)
select sum(no_of_hours*avg_or) from modules m 
left join lecturers l on m.lecturer_id=l.lecturer_id
cross join maksimum
where m.lecturer_id is null or acad_position is null

/*23/1.15
Nazwiska i imiona wyk�adowc�w wraz z sumaryczn� liczb� godzin wyk�ad�w prowadzonych przez ka�dego z nich z osobna ale tylko w przypadku, 
gdy suma godzin prowadzonych wyk�ad�w jest wi�ksza od 30. Kolumna zwracaj�ca liczb� godzin ma mie� nazw� no_of_hours. 
Dane posortowane malej�co wed�ug liczby godzin. 5 rekord�w.  Pierwszy: Jones Harry, 72 godziny. Ostatni: Katie Davies 55 godzin.*/

select surname, first_name, SUM(no_of_hours) no_of_hours from lecturers l
join employees e on l.lecturer_id=e.employee_id
join modules m on l.lecturer_id=m.lecturer_id
group by surname, first_name, l.lecturer_id
having SUM(no_of_hours)> 30
order by no_of_hours desc

/*23/1.16
Nazwy wszystkich grup oraz liczb� student�w zapisanych do ka�dej grupy (kolumna ma mie� nazw� no_of_students). 
Dane posortowane rosn�co wed�ug liczby student�w a nast�pnie numeru grupy. 23 rekordy.
Do 11 grup nie zosta� zapisany �aden student. Ostatni rekord: grupa DMIe1011, 6 student�w*/

select g.group_no, COUNT(student_id) as no_of_students from groups g
left join students s on g.group_no=s.group_no 
group by g.group_no
order by no_of_students, group_no

/*23/1.17
Nazwy wszystkich wyk�ad�w, kt�rych nazwa zaczyna si� liter� A oraz �redni� ocen ze wszystkich tych wyk�ad�w osobno 
(je�li jest wiele takich wyk�ad�w, to �rednia ma by� obliczona dla ka�dego z nich oddzielnie). Je�li z danego wyk�adu nie ma
�adnej oceny, tak�e powinien on pojawi� si� na li�cie. Kolumna ma mie� nazw� average. 3 rekordy:
Advanced databases NULL Advanced statistics 4.25 Ancient history 4.25*/

select distinct module_name, AVG(grade) average from modules m
left join student_grades sg on m.module_id=sg.module_id
where module_name like 'A%'
group by module_name

/*23/1.18
Nazwy grup, do kt�rych jest zapisanych co najmniej dw�ch student�w, liczba student�w zapisanych do tych grup 
(kolumna ma mie� nazw� no_of_students) oraz �rednie ocen dla ka�dej grupy (kolumna ma mie� nazw� average_grade).
Dane posortowane malej�co wed�ug �redniej. 8 rekord�w.
Pierwszy: ZMIe2012, liczba student�w 5, �rednia 6.6 Ostatni: DMIe1014, liczba student�w 2, �rednia 3.25*/


SELECT group_no, COUNT(s.student_id) AS no_of_students, 
AVG(grade) AS average_grade FROM students s INNER JOIN student_grades sg 
ON s.student_id=sg.student_id
GROUP BY group_no
HAVING COUNT(s.student_id) >= 2
ORDER BY average_grade DESC
