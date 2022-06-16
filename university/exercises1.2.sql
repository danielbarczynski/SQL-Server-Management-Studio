--Skill 1.2 – u¿ywaj¹c sk³adni z³¹czeñ napisz zapytania do bazy danych college.

--CROSS JOIN (ka¿dy rekord z ka¿dym)

select * from modules 
cross join students

-- INNER JOIN (czêœæ wspólna) INNER JOIN = JOIN

select * from students s
inner join student_grades sm on s.student_id=sm.student_id

select * from student_grades --58 rek
select * from students -- 35 rek

-- LEFT JOIN (podpiêcie do lewej tablicy (students)  prawej (st_grades) 
--(72 rekordy 14 nulli w st_grades, bo uwzglednia takze studentow, ktorych nie ma w st_grades)

select * from students s left join student_grades sm on s.student_id=sm.student_id
--            LEFT SIDE              RIGHT SIDE       
-- RIGHT JOIN (podpiêcie do prawej (st_grades) lewej (students) (58 rekordow, tyle ile jest w st_grades) 

select * from students s
right join student_grades sm on s.student_id=sm.student_id

-- FULL JOIN = RIGHT + LEFT + INNER

select * from students s
full join student_grades sm on s.student_id=sm.student_id

/*12.01
Identyfikatory i nazwy wyk³adów na które nie zosta³ zapisany ¿aden student. 
Dane posortowane malej¹co wed³ug nazw wyk³adów. 4 rekordy, wyk³ady o identyfikatorach 26, 25, 24, 23*/

select m.module_id, module_name, student_id from modules m 
left join students_modules sm on sm.module_id = m.module_id 
where student_id is null 
order by m.module_id desc

select * from modules

/*12.02
Identyfikatory i nazwy wyk³adów oraz nazwiska wyk³adowców prowadz¹cych wyk³ady, na które nie zapisa³ siê 
¿aden student. 4 rekordy, wyk³ady o identyfikatorach 23, 24, 25, 26*/

select m.module_id, module_name, e.surname, lecturer_id, student_id from modules m 
left join students_modules sm on sm.module_id = m.module_id 
left join employees e on m.lecturer_id=e.employee_id
where student_id is null 
order by m.module_id asc

/*12.03
Identyfikatory (pod nazw¹ lecturer_id) i nazwiska wszystkich wyk³adowców wraz z nazwami wyk³adów, które prowadz¹. 
Dane posortowane rosn¹co wed³ug nazwisk. 37 rekordów, w pierwszych dwóch rekordach s¹ wyk³adowcy
o identyfikatorach 5 i 12*/

select l.lecturer_id, surname, module_name 
from lecturers l
inner join employees e on l.lecturer_id=e.employee_id
left join modules m on l.lecturer_id=m.lecturer_id
order by surname asc

/*12.04
Identyfikatory, nazwiska i imiona pracowników, którzy s¹ wyk³adowcami.
28 rekordów*/

select employee_id, surname, first_name from employees
right join lecturers on employee_id=lecturer_id


/*12.05
Identyfikatory, nazwiska i imiona pracowników, którzy nie s¹ wyk³adowcami.
14 rekordów*/

select employee_id, surname, first_name, lecturer_id from employees
left join lecturers on employee_id=lecturer_id
where lecturer_id is null

/*12.06
Identyfikatory, imiona, nazwiska i numery grup studentów, którzy nie s¹ zapisani na ¿aden wyk³ad. 
Dane posortowane rosn¹co wed³ug nazwisk i imion. 9 rekordów, ostatni: 13 Layla Owen NULL*/

select s.student_id, first_name, surname, group_no, module_id from students s
left join students_modules sm on s.student_id=sm.student_id
where module_id is null
order by surname, first_name 

/*12.07
Nazwiska, imiona i identyfikatory studentów, którzy przyst¹pili do egzaminu co najmniej raz oraz daty egzaminów. 
Jeœli student danego dnia przyst¹pi³ do wielu egzaminów, jego dane maj¹ siê pojawiæ tylko raz. 
Dane posortowane rosn¹co wzglêdem dat. 50 rekordów, ostatni: Cox Megan, 32, 2018-09-30*/

select distinct s.student_id, first_name, surname, exam_date from students s
inner join student_grades sg on s.student_id=sg.student_id
order by exam_date 

/*12.08
Nazwy wszystkich wyk³adów, liczby godzin przewidziane na ka¿dy z nich oraz identyfikatory, nazwiska i 
imiona prowadz¹cych. Dane posortowane rosn¹co wed³ug nazw wyk³adów a nastêpnie nazwisk i imion prowadz¹cych.
26 rekordów, ostatni: Windows server services, 15, 8, Evans Thomas*/

select module_name, no_of_hours, lecturer_id, first_name from modules m
left join employees e on m.lecturer_id=e.employee_id
order by module_name, surname, first_name

/*12.09
Identyfikatory, nazwiska i imiona studentów zapisanych na wyk³ad z Statistics, posortowane rosn¹co
wed³ug nazwiska i imienia. 4 studentów o identyfikatorach (w podanej kolejnoœci) 32, 10, 12, 2*/

select s.student_id, surname, first_name from students s
inner join students_modules sm on s.student_id=sm.student_id
left join modules m on m.module_id=sm.module_id
where module_name='Statistics'
order by surname, first_name

select * from modules
/*12.10
Nazwiska, imiona i stopnie/tytu³y naukowe pracowników Department of Informatics. 
Dane posortowane rosn¹co wed³ug nazwisk i imion. 7 rekordów, pierwszy: Craven Lily doctor*/

select surname, first_name, acad_position from lecturers l
inner join employees e on e.employee_id=l.lecturer_id
where department = 'Department of Informatics'
order by surname, first_name 

/*12.11
Nazwiska i imiona wszystkich pracowników, a dla tych, którzy s¹ wyk³adowcami tak¿e nazwy katedr.
Dane posortowane rosn¹co wed³ug nazwisk oraz malej¹co wed³ug imion. 42 rekordy, pierwszy: Brown John NULL

Odpowiedz na pytanie: czy John Brown, dla którego nazwa katedry jest NULL jest wyk³adowc¹, czy na podstawie
otrzymanych danych nie jesteœmy w stanie tego stwierdziæ?
Czy w udzieleniu odpowiedzi na pytanie pomocny mo¿e byæ projekt logiczny (diagram) bazy danych?*/

select surname, first_name, department from employees e
left join lecturers l on e.employee_id=l.lecturer_id
order by surname asc, first_name desc

/*12.12
Nazwiska i imiona wszystkich wyk³adowców wraz z nazwami katedr, w których pracuj¹. 
Dane posortowane rosn¹co wed³ug nazwisk oraz malej¹co wed³ug imion. 28 rekordów, 
pierwszy: Brown Jacob, Department of Economics*/

select surname, first_name, department from lecturers l
inner join employees e on e.employee_id=l.lecturer_id
order by surname asc, first_name desc

/*12.13
Identyfikatory, nazwiska, imiona i stopnie/tytu³y naukowe wyk³adowców, którzy nie prowadz¹ ¿adnego wyk³adu.
Dane posortowane malej¹co wed³ug stopni naukowych. 17 rekordów, pierwszy: 35, Jones Lily, master*/

select l.lecturer_id, surname, first_name, acad_position from lecturers l
inner join employees on l.lecturer_id=employee_id
left join modules m on l.lecturer_id=m.lecturer_id
where module_id is null
order by acad_position desc

/*12.14
Imiona i nazwiska wszystkich studentów, nazwy wyk³adów, na które s¹ zapisani, nazwiska prowadz¹cych te wyk³ady 
(pole ma mieæ nazwê lecturer_surname) oraz nazwy katedr, w których ka¿dy z wyk³adowców pracuje. 
Dane posortowane malej¹co wed³ug nazw wyk³adów a nastêpnie rosn¹co wed³ug nazwisk wyk³adowców.
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
Liczba godzin wyk³adów, dla których nie da siê ustaliæ kwoty, jak¹ trzeba zap³aciæ za ich przeprowadzenie.
Wskazówka: weŸ pod uwagê fakt, ¿e nie jesteœmy w stanie ustaliæ, ile uczelnia musi zap³aciæ za danych wyk³ad w dwóch przypadkach:
1. 	Gdy w tabeli modules wartoœæ w polu lecturer_id jest Null
2. 	Gdy w tabeli modules wartoœæ w polu lecturer_id istnieje, ale w tabeli lecturers wyk³adowca prowadz¹cy ten wyk³ad nie ma 
wpisanego acad_position. Wynikiem jest liczba 165*/

select sum(no_of_hours) sum_hours from modules m
left join lecturers l on l.lecturer_id=m.lecturer_id
where m.lecturer_id is null or l.acad_position is null

/*12.16
Identyfikatory, nazwy wyk³adów oraz nazwy katedr odpowiedzialnych za prowadzenie wyk³adów, dla których nie mo¿na ustaliæ kwoty, 
jak¹ trzeba zap³aciæ za ich przeprowadzenie. 7 wyk³adów o identyfikatorach 4, 5, 7, 13, 15, 20, 22*/

select module_id, module_name, l.department from modules m
left join lecturers l on m.lecturer_id=l.lecturer_id
where m.lecturer_id is null or l.acad_position is null

/*12.17
Nazwy wszystkich wyk³adów, których nazwa zaczyna siê od s³owa computer (z uwzglêdnieniem wielkoœci liter – wszystkie litery ma³e) oraz 
liczbê godzin przewidzianych na ka¿dy z tych wyk³adów, nazwiska prowadz¹cych i nazwy katedr, w których pracuj¹. Dane posortowane malej¹co
wed³ug nazwisk. Wynikiem jest tabela pusta.*/

select module_name, no_of_hours, surname, l.department from modules m
left join lecturers l on m.lecturer_id=l.lecturer_id
left join employees on l.lecturer_id=employee_id
where module_name like 'computer%' collate polish_cs_as
order by surname desc

/*12.18
Nazwy wszystkich wyk³adów, których nazwa zaczyna siê od s³owa Computer (z uwzglêdnieniem wielkoœci liter – pierwsza litera du¿a) 
oraz liczbê godzin przewidzianych na ka¿dy z tych wyk³adów, nazwiska prowadz¹cych i nazwy katedr, w których pracuj¹. 
Dane posortowane malej¹co wed³ug nazwisk.*/

select module_name, no_of_hours, surname, l.department from modules m
left join lecturers l on m.lecturer_id=l.lecturer_id
left join employees on l.lecturer_id=employee_id
where module_name like 'Computer%' collate polish_cs_as
order by surname desc