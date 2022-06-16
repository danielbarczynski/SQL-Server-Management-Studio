-- 11.01 (NULL w wyra�eniach i funkcjach agreguj�cych)

--a) Wykonaj zapytanie:

SELECT 34+NULL
select 3 * 2 - 5

-- b) Wszystkie dane o tych pracownikach, dla kt�rych brakuje numeru PESEL lub daty zatrudnienia 
-- (warunek klauzuli WHERE napisz w taki spos�b aby by� SARG) 13 rekord�w 

select * from employees
where PESEL is null or employment_date is null

--c) Zapytanie wybieraj�ce wszystkie dane z tabeli students_modules.
--Zauwa�, �e dla niekt�rych egzamin�w nie wyznaczono planned_exam_date.

select * from students_modules

/* d) Zapytanie, kt�re dla ka�dego rekordu z tabeli students_modules zwr�ci informacj�, 
ile dni min�o od planowanego egzaminu (wykorzystaj funkcj� DateDiff).
Dane posortowane malej�co wed�ug daty. 
Zapami�taj ile rekord�w zwr�ci�o zapytanie. 94 rekordy, w pierwszych dw�ch student_id jest 17 i 1*/ 

SELECT student_id, module_id, planned_exam_date, DATEDIFF(day, planned_exam_date,  getdate()) AS no_days
from students_modules 
order by planned_exam_date desc

/* e) Zapytanie zwracaj�ce wynik dzia�ania funkcji agreguj�cej COUNT na polu planned_exam_date tabeli 
students_modules. Zwr�cona warto�� oznaczaj�ca liczb� takich rekord�w jest mniejsza 
ni� liczba rekord�w w tabeli. Wyja�nij dlaczego. 16 rekord�w*/ 

select COUNT(planned_exam_date) as no_of_records from students_modules

/* f) Zapytanie zwracaj�ce wynik dzia�ania funkcji agreguj�cej COUNT(*) dla tabeli students_modules. 
Warto�� oznaczaj�ca liczb� rekord�w jest r�wna liczbie rekord�w w tabeli. Wyja�nij dlaczego.
Zapytanie zwr�ci�o liczb� 94*/

select count (*) as quantity from students_modules 
--(*) always returns numbers of rows

--11.02 (DISTINCT)

/* a) Zapytanie zwracaj�ce identyfikatory student�w wraz z datami przyst�pienia do egzamin�w. 
Je�li student danego dnia przyst�pi� do wielu egzamin�w, jego identyfikator ma si� pojawi� tylko raz.
Dane posortowane malej�co wzgl�dem dat.50 rekord�w*/

select distinct student_id, exam_date from student_grades order by exam_date desc

/* b) Zapytanie zwracaj�ce identyfikatory student�w, kt�rzy przyst�pili do egzaminu w marcu 2018 roku. 
Identyfikator ka�dego studenta ma si� pojawi� tylko raz. Dane posortowane malej�co wed�ug 
identyfikator�w student�w. 10 rekord�w*/

select distinct student_id from student_grades 
where exam_date > '20180301' and exam_date < '20180401'
order by student_id desc

--or

select distinct student_id from student_grades
where exam_date between '20180301' and '20180401'
order by student_id desc

--11.03

/* Spr�buj wykona� zapytanie:
SELECT student_id, surname AS family_name
FROM students
WHERE family_name='Fisher'
Wyja�nij dlaczego jest ono niepoprawne a nast�pnie je skoryguj.*/

SELECT student_id, surname 
FROM students
WHERE surname='Fisher' -- where odwo�uje si� do istniej�cego rekordu a nie nazwanego przez AS?

--11.04 (SARG) SearchARGument

/*Zapytanie zwracaj�ce module_name oraz lecturer_id z tabeli modules z tych rekord�w, 
dla kt�rych lecturer_id jest r�wny 8 lub NULL. 
Zapytanie napisz dwoma sposobami � raz wykorzystuj�c funkcj� COALESCE (��czy�)
(jako drugi parametr przyjmij 0) raz tak, aby predykat(w�a�ciwo��) podany w warunku WHERE by� SARG. 9 rekord�w*/

select lecturer_id, module_name from modules
where lecturer_id = 8 or lecturer_id is null

-- coalesce 

select lecturer_id, module_name from modules
where coalesce(lecturer_id,0) = 0 or lecturer_id = 8

--coalesce2

select lecturer_id, module_name from modules
where lecturer_id = 8 or coalesce(lecturer_id, 0) = 0 -- doesnt work if we put something like (lecturer_id, 50) lol

--other example

select coalesce(lecturer_id, 69420) as lecturer_id, module_name from modules -- maybe cuz here coalesce is with select
where lecturer_id = 8 or lecturer_id is null

--11.05

/*Wykorzystaj funkcj� CAST i TRY_CAST jako parametr instrukcji SELECT pr�buj�c zamieni� tekst ABC
na liczb� typu INT. Skomentuj otrzymane wyniki.*/

select cast('ABC' AS int) -- b��d
SELECT TRY_CAST('ABC' AS int) -- null

--11.06
--Napisz trzy razy instrukcj� SELECT wykorzystuj�c funkcj� CONVERT zamieniaj�c� dzisiejsz� dat� na tekst. 
--Jako ostatni parametr funkcji CONVERT podaj 101, 102 oraz 103. Skomentuj otrzymane wyniki.

select CONVERT(varchar(30), getdate(), 101)
select CONVERT(varchar(30), getdate(), 102)
select CONVERT(varchar(30), getdate(), 103) -- this one

-- 11.07 (LIKE)
--Napisz zapytania z u�yciem operatora LIKE wybieraj�ce nazwy grup (wielko�� liter jest nieistotna):

--a)zaczynaj�ce si� na DM 6 rekord�w

select * from groups where group_no like 'dm%' -- start with dm

--b)niemaj�ce w nazwie ci�gu '10' 15 rekord�w

select * from groups where group_no not like '%10%'

--c)kt�rych drugim znakiem jest M 9 rekord�w

select * from groups where group_no like '_m%' -- end with m

--d)kt�rych przedostatnim znakiem jest 0 (zero) 11 rekord�w

select * from groups where group_no like '%0_'

--e)kt�rych ostatnim znakiem jest 1 lub 2 12 rekord�w

select * from groups where group_no like '%1' or group_no like '%2'
select * from groups where group_no like '%[12]'

--f)kt�rych pierwszym znakiem nie jest litera D 8 rekord�w

select * from groups where group_no not like 'd%'
select * from groups where group_no like'[^D]%'

--g)kt�rych drugim znakiem jest dowolna litera z zakresu A-P 10 rekord�w

select * from groups where group_no like '_[a-p]%'

--11.08 (LIKE i COLLATE) 
--Napisz zapytania z u�yciem operatora LIKE i/lub klauzuli COLLATE (zestawi�, por�wna�):

--a)wybieraj�ce nazwy wyk�ad�w, kt�re w nazwie maj� liter� o (wielko�� liter nie ma znaczenia) 19 rekord�w

select * from modules where module_name like '%o%'

--b)wybieraj�ce nazwy wyk�ad�w, kt�re w nazwie maj� du�� liter� O 1 rekord, Operational systems

select * from modules where module_name like '%O%' collate polish_cs_as -- case sensitive

--c)wybieraj�ce nazwy grup, kt�re w nazwie maj� trzeci� liter� i (wielko�� liter nie ma znaczenia) 16 rekord�w

select * from groups where group_no like '__i%'

--d)wybieraj�ce nazwy grup, kt�re w nazwie maj� trzeci� liter� ma�e i 4 rekordy

select * from groups where group_no like '__i%' collate polish_cs_as

/*11.09 (COLLATE)

Instrukcj� CREATE utw�rz tabel� #tmp (je�li stworzymy tabel�, kt�rej nazwa b�dzie poprzedzona znakiem #,
tabela zostanie automatycznie usuni�ta po zamkni�ciu sesji) sk�adaj�c� si� z p�l:

id int primary key
nazwisko varchar(30) collate polish_cs_as

Jedn� instrukcj� INSERT wprowad� do tabeli #tmp nast�puj�ce rekordy (zwracaj�c uwag� na wielko�� liter):
1	Kowalski
2	kowalski
3	KoWaLsKi
4	KOWALSKI

a)	Wybierz z tabeli #tmp rekordy, kt�re w polu nazwisko maj� (wielko�� liter jest istotna):
pierwsz� liter� du�e K 3 rekordy, napis Kowalski 1 rekord, drug� liter� od ko�ca du�e K 2 rekordy*/

create table #tmp( 
id int primary key,
nazwisko varchar(30) collate polish_cs_as)

insert into #tmp(id, nazwisko)
values
(1, 'Kowalski'),
(2, 'kowalski'),
(3, 'KoWaLsKi'),
(4, 'KOWALSKI')

select * from #tmp where nazwisko like 'K%'
select * from #tmp where nazwisko like '%K_'

/*b)Wy�wietl rekordy, kt�re w polu nazwisko maj� (wielko�� liter jest nieistotna):
napis kowalski 4 rekordy, drug� liter� o 4 rekordy
Odpowiedz na pytanie, w kt�rym przypadku, a) czy b), u�ycie klauzuli COLLATE by�o konieczne i dlaczego.*/

select * from #tmp where nazwisko = 'kowalski' collate polish_ci_as
select * from #tmp where nazwisko like '_o%' collate polish_ci_as 

/*11.10

Napisz zapytanie:
SELECT DISTINCT surname
FROM students
ORDER BY group_no
Wyja�nij na czym polega b��d i skoryguj zapytanie tak, aby zwraca�o nazwiska student�w z tabeli students
posortowane wed�ug numeru grupy. 35 rekord�w */

SELECT surname -- without distinct
FROM students
ORDER BY group_no

/*11.11 (TOP)

--a)Napisz zapytanie wybieraj�ce 5 pierwszych rekord�w z tabeli student_grades, kt�re w polu exam_date 
maj� najdawniejsze daty 5 rekord�w*/

select * from student_grades
select top(5) * from student_grades 
order by exam_date asc

--b)Skoryguj zapytanie z punktu a) dodaj�c klauzul� WITH TIES. Skomentuj otrzymany wynik. 6 rekord�w

select top(5) with ties * from student_grades 
order by exam_date asc
-- with ties allows double returns

--11.12 (TOP, OFFSET)

--a)Sprawd�, ile rekord�w jest w tabeli student_grades

select * from student_grades

--b)Wybierz 20% pocz�tkowych rekord�w z tabeli student_grades. Posortuj wynik wed�ug exam_date. 
--Sprawd�, ile rekord�w zosta�o zwr�conych i wyja�nij dlaczego. 12 rekord�w

select top (20) percent * from student_grades order by exam_date asc

--c)Pomi� pierwszych 6 rekord�w i wybierz kolejnych 10 rekord�w z tabeli student_grades. 
--Posortuj wynik wed�ug exam_date. pierwszy rekord: student_id=6 i module_id=4

select * from student_grades 
order by exam_date asc 
offset 6 rows 
fetch next 10 rows only -- offset(bootstrap) after orderby

--d)Wybierz wszystkie rekordy z tabeli student_grades z pomini�ciem pierwszych 20 
--(sortowanie wed�ug exam_date). 38 rekord�w

select * from student_grades order by exam_date asc offset 20 rows

--11.13 (INTERSECT, UNION, EXCEPT)

--a)Wszystkie nazwiska z tabel students i employees (ka�de ma si� pojawi� tylko raz) 
--posortowane wed�ug nazwisk 40 rekord�w

select surname from students 
union -- union like distinct
select surname from employees 
order by surname desc 

--b)Wszystkie nazwiska z tabel students i employees (ka�de ma si� pojawi� tyle razy ile razy wyst�puje w tabelach) 
--posortowane wed�ug nazwisk 77 rekord�w

select surname from students 
union all -- without distinct
select surname from employees order by surname desc

--c)Te nazwiska z tabeli students, kt�re nie wyst�puj� w tabeli employees 21 rekord�w

select surname from students 
except -- z wy��czeniem
select surname from employees order by surname -- asc by default

--d)Te nazwiska z tabeli students, kt�re wyst�puj� tak�e w tabeli employees 1 rekord � nazwisko Craven

select surname from students 
intersect -- ��czenie cech wspolncyh
select surname from employees order by surname desc

-- e)Informacj�, pracownicy kt�rych katedr (departments) nie s� przypisani jako potencjalni prowadz�cy 
--do �adnego wyk�adu (u�yj operatora EXCEPT) 1 rekord � Department of Foreign Affairs

select department from lecturers except select department from modules -- lecturers ktorych nie ma w modules

--f)Informacj�, pracownicy kt�rych katedr s� przypisani jako potencjalni prowadz�cy wyk�ady, kt�rych nazwa 
-- zaczyna  si� na M 2 rekordy, Department of Economics and Department of Mathematics

select department from lecturers intersect select department from modules where module_name like 'm%'  

--g)Te pary id_studenta, id_wykladu z tabeli student_grades, kt�rym nie zosta�a przyznana 
--dotychczas �adna ocena 45 rekord�w

select student_id, module_id from students_modules 
except 
select student_id, module_id from student_grades

--h)Identyfikatory student�w, kt�rzy zapisali si� zar�wno na wyk�ad o identyfikatorze 3 jak i 12
--Trzech student�w o identyfikatorach 9, 14 i 18

select student_id from students_modules
where module_id = 3
intersect -- to ta sama tabela, wiec laczymy czesc wspolna
select student_id from students_modules
where module_id = 12

/*i)Nazwiska i imiona student�w wraz z numerami grup, zapisanych do grup o nazwach zaczynaj�cych si� 
na DMIe oraz nazwiska i imiona wyk�adowc�w wraz z nazwami katedr, w kt�rych pracuj�. 
Ostatnia kolumna ma mie� nazw� group_department. Dane posortowane rosn�co wed�ug ostatniej kolumny.
Wskaz�wka: W zapytaniu wybieraj�cym dane o wyk�adowcach nale�y u�y� z��czenia 37 rekord�w*/

select first_name, surname, group_no as group_department from students where group_no like 'dmie%'
union
select surname, first_name, department from employees e
inner join lecturers l
on e.employee_id=l.lecturer_id
order by group_department 

-- without inner join

select first_name, surname from students where group_no like 'dmie%'
union
select surname, first_name from employees 





