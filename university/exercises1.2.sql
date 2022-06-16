--Skill 1.2 � u�ywaj�c sk�adni z��cze� napisz zapytania do bazy danych college.

--CROSS JOIN (ka�dy rekord z ka�dym)

select * from modules 
cross join students

-- INNER JOIN (cz�� wsp�lna) INNER JOIN = JOIN

select * from students s
inner join student_grades sm on s.student_id=sm.student_id

select * from student_grades --58 rek
select * from students -- 35 rek

-- LEFT JOIN (podpi�cie do lewej tablicy (students)  prawej (st_grades) 
--(72 rekordy 14 nulli w st_grades, bo uwzglednia takze studentow, ktorych nie ma w st_grades)

select * from students s left join student_grades sm on s.student_id=sm.student_id
--            LEFT SIDE              RIGHT SIDE       
-- RIGHT JOIN (podpi�cie do prawej (st_grades) lewej (students) (58 rekordow, tyle ile jest w st_grades) 

select * from students s
right join student_grades sm on s.student_id=sm.student_id

-- FULL JOIN = RIGHT + LEFT + INNER

select * from students s
full join student_grades sm on s.student_id=sm.student_id

/*12.01
Identyfikatory i nazwy wyk�ad�w na kt�re nie zosta� zapisany �aden student. 
Dane posortowane malej�co wed�ug nazw wyk�ad�w. 4 rekordy, wyk�ady o identyfikatorach 26, 25, 24, 23*/

select m.module_id, module_name, student_id from modules m 
left join students_modules sm on sm.module_id = m.module_id 
where student_id is null 
order by m.module_id desc

select * from modules

/*12.02
Identyfikatory i nazwy wyk�ad�w oraz nazwiska wyk�adowc�w prowadz�cych wyk�ady, na kt�re nie zapisa� si� 
�aden student. 4 rekordy, wyk�ady o identyfikatorach 23, 24, 25, 26*/

select m.module_id, module_name, e.surname, lecturer_id, student_id from modules m 
left join students_modules sm on sm.module_id = m.module_id 
left join employees e on m.lecturer_id=e.employee_id
where student_id is null 
order by m.module_id asc

/*12.03
Identyfikatory (pod nazw� lecturer_id) i nazwiska wszystkich wyk�adowc�w wraz z nazwami wyk�ad�w, kt�re prowadz�. 
Dane posortowane rosn�co wed�ug nazwisk. 37 rekord�w, w pierwszych dw�ch rekordach s� wyk�adowcy
o identyfikatorach 5 i 12*/

select l.lecturer_id, surname, module_name 
from lecturers l
inner join employees e on l.lecturer_id=e.employee_id
left join modules m on l.lecturer_id=m.lecturer_id
order by surname asc

/*12.04
Identyfikatory, nazwiska i imiona pracownik�w, kt�rzy s� wyk�adowcami.
28 rekord�w*/

select employee_id, surname, first_name from employees
right join lecturers on employee_id=lecturer_id


/*12.05
Identyfikatory, nazwiska i imiona pracownik�w, kt�rzy nie s� wyk�adowcami.
14 rekord�w*/

select employee_id, surname, first_name, lecturer_id from employees
left join lecturers on employee_id=lecturer_id
where lecturer_id is null

/*12.06
Identyfikatory, imiona, nazwiska i numery grup student�w, kt�rzy nie s� zapisani na �aden wyk�ad. 
Dane posortowane rosn�co wed�ug nazwisk i imion. 9 rekord�w, ostatni: 13 Layla Owen NULL*/

select s.student_id, first_name, surname, group_no, module_id from students s
left join students_modules sm on s.student_id=sm.student_id
where module_id is null
order by surname, first_name 

/*12.07
Nazwiska, imiona i identyfikatory student�w, kt�rzy przyst�pili do egzaminu co najmniej raz oraz daty egzamin�w. 
Je�li student danego dnia przyst�pi� do wielu egzamin�w, jego dane maj� si� pojawi� tylko raz. 
Dane posortowane rosn�co wzgl�dem dat. 50 rekord�w, ostatni: Cox Megan, 32, 2018-09-30*/

select distinct s.student_id, first_name, surname, exam_date from students s
inner join student_grades sg on s.student_id=sg.student_id
order by exam_date 

/*12.08
Nazwy wszystkich wyk�ad�w, liczby godzin przewidziane na ka�dy z nich oraz identyfikatory, nazwiska i 
imiona prowadz�cych. Dane posortowane rosn�co wed�ug nazw wyk�ad�w a nast�pnie nazwisk i imion prowadz�cych.
26 rekord�w, ostatni: Windows server services, 15, 8, Evans Thomas*/

select module_name, no_of_hours, lecturer_id, first_name from modules m
left join employees e on m.lecturer_id=e.employee_id
order by module_name, surname, first_name

/*12.09
Identyfikatory, nazwiska i imiona student�w zapisanych na wyk�ad z Statistics, posortowane rosn�co
wed�ug nazwiska i imienia. 4 student�w o identyfikatorach (w podanej kolejno�ci) 32, 10, 12, 2*/

select s.student_id, surname, first_name from students s
inner join students_modules sm on s.student_id=sm.student_id
left join modules m on m.module_id=sm.module_id
where module_name='Statistics'
order by surname, first_name

select * from modules
/*12.10
Nazwiska, imiona i stopnie/tytu�y naukowe pracownik�w Department of Informatics. 
Dane posortowane rosn�co wed�ug nazwisk i imion. 7 rekord�w, pierwszy: Craven Lily doctor*/

select surname, first_name, acad_position from lecturers l
inner join employees e on e.employee_id=l.lecturer_id
where department = 'Department of Informatics'
order by surname, first_name 

/*12.11
Nazwiska i imiona wszystkich pracownik�w, a dla tych, kt�rzy s� wyk�adowcami tak�e nazwy katedr.
Dane posortowane rosn�co wed�ug nazwisk oraz malej�co wed�ug imion. 42 rekordy, pierwszy: Brown John NULL

Odpowiedz na pytanie: czy John Brown, dla kt�rego nazwa katedry jest NULL jest wyk�adowc�, czy na podstawie
otrzymanych danych nie jeste�my w stanie tego stwierdzi�?
Czy w udzieleniu odpowiedzi na pytanie pomocny mo�e by� projekt logiczny (diagram) bazy danych?*/

select surname, first_name, department from employees e
left join lecturers l on e.employee_id=l.lecturer_id
order by surname asc, first_name desc

/*12.12
Nazwiska i imiona wszystkich wyk�adowc�w wraz z nazwami katedr, w kt�rych pracuj�. 
Dane posortowane rosn�co wed�ug nazwisk oraz malej�co wed�ug imion. 28 rekord�w, 
pierwszy: Brown Jacob, Department of Economics*/

select surname, first_name, department from lecturers l
inner join employees e on e.employee_id=l.lecturer_id
order by surname asc, first_name desc

/*12.13
Identyfikatory, nazwiska, imiona i stopnie/tytu�y naukowe wyk�adowc�w, kt�rzy nie prowadz� �adnego wyk�adu.
Dane posortowane malej�co wed�ug stopni naukowych. 17 rekord�w, pierwszy: 35, Jones Lily, master*/

select l.lecturer_id, surname, first_name, acad_position from lecturers l
inner join employees on l.lecturer_id=employee_id
left join modules m on l.lecturer_id=m.lecturer_id
where module_id is null
order by acad_position desc

/*12.14
Imiona i nazwiska wszystkich student�w, nazwy wyk�ad�w, na kt�re s� zapisani, nazwiska prowadz�cych te wyk�ady 
(pole ma mie� nazw� lecturer_surname) oraz nazwy katedr, w kt�rych ka�dy z wyk�adowc�w pracuje. 
Dane posortowane malej�co wed�ug nazw wyk�ad�w a nast�pnie rosn�co wed�ug nazwisk wyk�adowc�w.
103 rekordy, pierwszy: Mason Ben, Web applications, Jones, Department of History*/

select s.first_name, s.surname, module_name, e.surname lecturer_surname, l.department from students s
left join students_modules sm on sm.student_id=s.student_id
left join modules m on m.module_id=sm.module_id
left join lecturers l on l.lecturer_id=m.lecturer_id
left join employees e on e.employee_id=l.lecturer_id
order by module_name desc, e.surname 

--or

SELECT s.surname, s.first_name, module_name, 
e.surname AS lecturer_surname, l.department
FROM students s LEFT JOIN 
 (((students_modules sm INNER JOIN modules m 
ON sm.module_id=m.module_id)
 LEFT JOIN lecturers l ON l.lecturer_id=m.lecturer_id)
  LEFT JOIN employees e ON l.lecturer_id=employee_id) 
ON s.student_id=sm.student_id
ORDER BY module_name DESC, e.surname

/*12.15
Liczba godzin wyk�ad�w, dla kt�rych nie da si� ustali� kwoty, jak� trzeba zap�aci� za ich przeprowadzenie.
Wskaz�wka: we� pod uwag� fakt, �e nie jeste�my w stanie ustali�, ile uczelnia musi zap�aci� za danych wyk�ad w dw�ch przypadkach:
1. 	Gdy w tabeli modules warto�� w polu lecturer_id jest Null
2. 	Gdy w tabeli modules warto�� w polu lecturer_id istnieje, ale w tabeli lecturers wyk�adowca prowadz�cy ten wyk�ad nie ma 
wpisanego acad_position. Wynikiem jest liczba 165*/

select sum(no_of_hours) sum_hours from modules m
left join lecturers l on l.lecturer_id=m.lecturer_id
where m.lecturer_id is null or l.acad_position is null

/*12.16
Identyfikatory, nazwy wyk�ad�w oraz nazwy katedr odpowiedzialnych za prowadzenie wyk�ad�w, dla kt�rych nie mo�na ustali� kwoty, 
jak� trzeba zap�aci� za ich przeprowadzenie. 7 wyk�ad�w o identyfikatorach 4, 5, 7, 13, 15, 20, 22*/

select module_id, module_name, l.department from modules m
left join lecturers l on m.lecturer_id=l.lecturer_id
where m.lecturer_id is null or l.acad_position is null

/*12.17
Nazwy wszystkich wyk�ad�w, kt�rych nazwa zaczyna si� od s�owa computer (z uwzgl�dnieniem wielko�ci liter � wszystkie litery ma�e) oraz 
liczb� godzin przewidzianych na ka�dy z tych wyk�ad�w, nazwiska prowadz�cych i nazwy katedr, w kt�rych pracuj�. Dane posortowane malej�co
wed�ug nazwisk. Wynikiem jest tabela pusta.*/

select module_name, no_of_hours, surname, l.department from modules m
left join lecturers l on m.lecturer_id=l.lecturer_id
left join employees on l.lecturer_id=employee_id
where module_name like 'computer%' collate polish_cs_as
order by surname desc

/*12.18
Nazwy wszystkich wyk�ad�w, kt�rych nazwa zaczyna si� od s�owa Computer (z uwzgl�dnieniem wielko�ci liter � pierwsza litera du�a) 
oraz liczb� godzin przewidzianych na ka�dy z tych wyk�ad�w, nazwiska prowadz�cych i nazwy katedr, w kt�rych pracuj�. 
Dane posortowane malej�co wed�ug nazwisk.*/

select module_name, no_of_hours, surname, l.department from modules m
left join lecturers l on m.lecturer_id=l.lecturer_id
left join employees on l.lecturer_id=employee_id
where module_name like 'Computer%' collate polish_cs_as
order by surname desc