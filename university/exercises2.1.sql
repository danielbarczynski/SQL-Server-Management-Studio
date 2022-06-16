-- SUBQUERIES

/*21.01
Identyfikatory i nazwy wykład�w, na kt�re nie zosta� zapisany �aden student. Dane posortowane malej�co 
wed�ug nazw wyk�ad�w. U�yj sk�adni podzapytania. 4 rekordy, studenci o identyfikatorach 26, 25, 24 i 23 (w podanej kolejno�ci)*/

select * from modules
where module_id not in
(select module_id from students_modules)
order by module_id desc 

-- pozwala nam zwrocic *, nie to co operatory union itd
-- vs operator except

select module_id from modules
except 
select module_id from students_modules

/*21.02
Identyfikatory student�w, kt�rzy przyst�pili do egzaminu zar�wno 2018-03-22 jak i 2018 09 30. Dane posortowane malej�co wed�ug identyfikator�w. 
Napisz dwie wersje tego zapytania: raz u�ywaj�c sk�adni podzapytania, drugi raz operatora INTERSECT.
Studenci o identyfikatorach 18 i 2 (w podanej kolejno�ci)*/

select student_id from student_grades
where exam_date = '20180322' and student_id in
(select student_id from student_grades
where exam_date = '20180930')
order by student_id desc

--INTERSECT:

select student_id from student_grades
where exam_date = '2018-03-22' 
intersect
select student_id from student_grades
where exam_date = '2018-09-30'
order by student_id desc

/*21.03
Identyfikatory, nazwiska, imiona i numery grup student�w, kt�rzy zapisali si� zar�wno na wyk�ad o identyfikatorze 2 jak i 4. 
Dane posortowane malej�co wed�ug nazwisk. U�yj sk�adni podzapytania a w zapytaniu zewn�trznym tak�e z��czenia.
3 rekordy, studenci o identyfikatorach 16, 3, 20 (w podanej kolejno�ci)*/

select s.student_id, first_name, surname, group_no from students s
inner join students_modules sm on sm.student_id=s.student_id -- gdy bylo module id na student id, wyskakiwaly te same student id tylko ze z jednym gosciem
where module_id = 2 and s.student_id in
(select sm.student_id from students_modules sm
where module_id = 4)
order by surname desc

/*21.04
Identyfikatory, nazwiska i imiona student�w, kt�rzy zapisali si� na wyk�ad z matematyki (Mathematics) ale nie zapisali si� 
na wyk�ad ze statystyki (Statistics). Zapytanie napisz korzystaj�c ze sk�adni podzapytania, wed�ug nast�puj�cego algorytmu:
�	najbardziej wewn�trznym zapytaniem wybierz identyfikatory student�w, kt�rzy zapisali si� na wyk�ad ze statystyki 
(tu potrzebne b�dzie z��czenie),
�	kolejnym zapytaniem wybierz identyfikatory student�w, kt�rzy zapisali si� na wyk�ad z matematyki (tak�e potrzebne b�dzie z��czenie) 
oraz nie zapisali si� na wyk�ad ze statystyki (ich identyfikatory nie nale�� do zbioru zwr�conego przez poprzednie zapytanie),
�	zewn�trznym zapytaniem wybierz dane o studentach, kt�rych identyfikatory nale�� do zbioru zwr�conego przez zapytanie �rodkowe.
5 rekord�w, studenci o identyfikatorach 3, 6, 16, 20, 33*/

select * from students
where student_id in
(select student_id
from students_modules sm inner join modules m on m.module_id=sm.module_id
where module_name = 'mathematics' and student_id not in
(select student_id
from students_modules sm inner join modules m on m.module_id=sm.module_id
where module_name = 'statistics'))


/*21.05
Imiona, nazwiska i numery grup student�w z grup, kt�rych nazwa zaczyna si� na DMIe i ko�czy cyfr� 1 i kt�rzy nie s� zapisani na wyk�ad�Ancient history�. 
U�yj sk�adni zapytania negatywnego a w zapytaniu wewn�trznym tak�e z��czenia.
3 rekordy (studenci z grupy DMIe1011 o nazwiskach Hunt, Holmes i Lancaster)*/

SELECT first_name, surname, group_no
FROM students 
WHERE group_no LIKE 'DMIe%1' AND student_id NOT IN 
(SELECT student_id FROM students_modules sm 
INNER JOIN modules m ON sm.module_id=m.module_id
 WHERE module_name='Ancient history')

/*21.06
Nazwy wyk�ad�w o najmniejszej liczbie godzin. Zapytanie, opr�cz nazw wyk�ad�w, ma zwr�ci� tak�e liczb� godzin.
U�yj operatora ALL.
Jeden wyk�ad: Advanced Statistics, 9 godzin*/

select module_name, no_of_hours from modules
where no_of_hours = 
(select MIN(no_of_hours)
from modules)

--ALL:

select module_name, no_of_hours from modules
where no_of_hours <= all  -- bez znaku "=" w ogole nie dziala, po all/any/some nastepuje subquery
(select no_of_hours from modules)

select min(no_of_hours) as minimum from modules 

/*21.07
Identyfikatory i nazwiska student�w, kt�rzy otrzymali ocen� wy�sz� od najni�szej. Dane ka�dego studenta maj� 
si� pojawi� tyle razy, ile takich ocen otrzyma�. U�yj operatora ANY. W zapytaniu nie wolno pos�ugiwa� si� 
liczbami oznaczaj�cymi oceny 2, 3, itd.) ani funkcjami agreguj�cymi (MIN, MAX).45 rekord�w
Sprawd�, czy liczba rekord�w zwr�conych przez zapytanie jest poprawna, wykonuj�c odpowiednie 
zapytanie do tabeli student_grades (wybieraj�ce rekordy, w kt�rych ocena jest wy�sza ni� 2).*/

select s.student_id, surname from students s
inner join student_grades sg on s.student_id=sg.student_id 
where grade > any
(select grade from student_grades)

/*21.08
Napisz jedno zapytanie, kt�re zwr�ci dane o najm�odszych i najstarszych studentach (do po��czenia tych danych 
u�yj jednego z operator�w typu SET). W zapytaniu nie wolno u�ywa� funkcji agreguj�cych (MIN, MAX).
Uwaga: nale�y uwzgl�dni� fakt, �e data urodzenia w tabeli students mo�e by� NULL, do por�wnania nale�y wi�c 
wybra� rekordy, kt�re w polu date_of_birth maj� wpisane daty. Najstarszym studentem jest Melissa Hunt urodzona 
1978-10-18 Najm�odszym studentem jest Layla Owen urodzona 2001-06-20. Napisz zapytanie do tabeli students i sprawd�,
czy otrzymane dane o najm�odszych i najstarszych studentach s� poprawne.*/

select * from students
where date_of_birth <= all
(select date_of_birth from students where date_of_birth is not null)
union
select * from students
where date_of_birth >= all
(select date_of_birth from students where date_of_birth is not null)

/*21.09a
Identyfikatory, imiona i nazwiska student�w z grupy DMIe1011, kt�rzy otrzymali oceny z egzaminu wcze�niej, ni�
wszyscy pozostali studenci z innych grup (nie uwzgl�dniamy student�w, kt�rzy nie s� zapisani do �adnej grupy).
Dane ka�dego studenta maj� si� pojawi� tylko raz. U�yj z��czenia i operatora ALL. 3 rekordy, studenci o 
identyfikatorach 1, 3 i 6*/

select distinct s.student_id, first_name, surname, group_no from students s
inner join student_grades sg on s.student_id=sg.student_id
where group_no = 'DMIe1011' and exam_date < all
(select exam_date from students s
inner join student_grades sg on s.student_id=sg.student_id
where group_no <> 'DMIe1011')

/*21.09b
Jak wy�ej, ale tym razem nale�y uwzgl�dni� student�w, kt�rzy nie s� zapisani do �adnej grupy. 
Wynikiem jest tabela pusta
Odpowiedz na pytanie, jaki jest identyfikator studenta, kt�ry spowodowa�, �e wynikiem jest tabela pusta.*/

select distinct s.student_id, first_name, surname, group_no, exam_date from students s
inner join student_grades sg on s.student_id=sg.student_id
where group_no = null and exam_date <= all
(select exam_date from student_grades)

-- wyjasnienie dlaczego:

select distinct s.student_id, first_name, surname, group_no, exam_date from students s
inner join student_grades sg on s.student_id=sg.student_id
where group_no is null and exam_date <= all
(select exam_date from student_grades)

/*21.10
Nazwy wyk�ad�w, kt�rym przypisano najwi�ksz� liczb� godzin (wraz z liczb� godzin).
Wykorzystaj sk�adni� podzapytania z operatorem =. W zapytaniu wewn�trznym u�yj funkcji MAX.
Jeden rekord: Econometrics, 45 godzin*/

select module_name, no_of_hours from modules
where no_of_hours >= all
(select no_of_hours from modules)

-- max:

select module_name, no_of_hours from modules
where no_of_hours =
(select MAX (no_of_hours) from modules)

/*21.11
Nazwy wyk�ad�w, kt�rym przypisano liczb� godzin wi�ksz� od najmniejszej. 
U�yj funkcji MIN i sk�adni podzapytania z operatorem >.
25 rekord�w*/

select module_name from modules
where no_of_hours >
(select MIN(no_of_hours) from modules)

/*21.12a
Wszystkie dane o najm�odszym studencie z ka�dej grupy. 
U�yj fujnkcji MIN i sk�adni podzapytania skorelowanego z operatorem =.
11 rekord�w, np. w grupie DMIe1013 najm�odszy jest Elliot Fisher, ur. 1998-07-19*/

select * from students s1
where date_of_birth =
(select min(date_of_birth) from students s2 where s1.group_no=s2.group_no)

/*21.12b
Wszystkie numery grup z tabeli students posortowane wed�ug numer�w grup. Ka�da grupa ma si� pojawi� jeden raz.
Zapytanie zwr�ci�o 13 rekord�w. Poniewa� jedn� z warto�ci jest NULL, wi�c studenci s� przypisani do 12 r�nych grup.
Poprzednie zapytanie, zwracaj�ce dane o najm�odszym studencie z ka�dej grupy, zwr�ci�o 11 rekord�w. Znajd� przyczyn� 
tej r�nicy.*/

select distinct group_no from students
order by group_no

/*21.13
Identyfikatory, nazwiska i imiona student�w, kt�rzy otrzymali ocen� 5.0. Nazwisko ka�dego studenta ma si� pojawi� 
jeden raz.  U�yj operatora EXISTS. 6 student�w o identyfikatorach 1, 2, 14, 18, 19, 21
Napisz zapytanie: SELECT * FROM student_grades where grade=5 i sprawd� otrzymany wynik.*/

select distinct surname, s.student_id, first_name from students s
left join student_grades sg on s.student_id=sg.student_id
where grade = 5

-- exist:

select distinct surname, s.student_id, first_name from students s
where exists
(select grade from student_grades sg where s.student_id=sg.student_id and grade = 5) -- musi byc dolaczenie (bez joina)

SELECT * FROM student_grades where grade=5


/*21.14a
Wszystkie dane o wyk�adach, w kt�rych uczestnictwo wymaga wcze�niejszego uczestnictwa w wyk�adzie o identyfikatorze 3. 
U�yj operatora EXISTS.
Trzy wyk�ady o identyfikatorach 10, 16 i 25*/

-- wystarczyloby...

select * from modules where
preceding_module = 3

select * from modules m1
where exists
(select * from modules m2 where m1.module_id=m2.module_id and preceding_module = 3)

/*21.15a
Dane student�w z grupy DMIe1011 wraz z najwcze�niejsz� dat� planowanego dla nich egzaminu (pole planned_exam_date w tabeli students_modules). 
Zapytanie nie zwraca danych o studentach, kt�rzy nie maj� wyznaczonej takiej daty. Sortowanie rosn�ce wed�ug planned_exam_date a nast�pnie
student_id. U�yj operatora APPLY.
Uwaga: nale�y uwzgl�dni� fakt, �e data planowanego egzaminu mo�e by� NULL.
3 rekordy, studenci o identyfikatorach 3, 29 i 1 (w takiej kolejno�ci)
Najwcze�niejsza planned_exam_date dla studenta o id=3 to 2018-03-21*/

select * from students s
cross apply
(select top(1) planned_exam_date from students_modules sm
where s.student_id=sm.student_id and planned_exam_date is not null
order by planned_exam_date) as t
where group_no = 'DMIe1011'
order by planned_exam_date, student_id

/*21.15b
Jak wy�ej, tylko zapytanie ma zwr�ci� najp�niejsz� dat� planowanego egzaminu. Ponadto zapytanie ma tak�e zwr�ci� dane o studentach, 
kt�rzy nie maj� wyznaczonej takiej daty. Sortowanie rosn�ce wed�ug planned_exam_date. U�yj operatora APPLY.
6 rekord�w, studenci o identyfikatorach 4, 6, 30 (dla kt�rych planned_exam_date jest NULL)
oraz 29, 3 i 1 (z istniej�c� planned_exam_date). Najwcze�niejsza planned_exam_date dla studenta o id=3 to 2018-10-13*/

select * from students s
outer apply
(select top(1) planned_exam_date from students_modules sm
where s.student_id=sm.student_id and planned_exam_date is not null
order by planned_exam_date desc) as t
where group_no = 'DMIe1011'
order by planned_exam_date, student_id


/*21.16a
Identyfikatory i nazwiska student�w oraz dwie najlepsze oceny dla ka�dego studenta wraz z datami ich przyznania. 
Zapytanie uwzgl�dnia tylko student�w, kt�rym zosta�a przyznana co najmniej jedna ocena. U�yj operatora APPLY. 37 rekord�w.
Ostatni rekord: 33, Bowen, 2.0, 2018-09-23 Np. w przypadku student�w o id=1, 2 i 3 zwr�cone zosta�y po dwie oceny. 
W przypadku studenta o id=4 jedna ocena. Student o id=5 nie otrzyma� �adnej oceny.*/

select * from students s -- bierzemy jednego studenta
cross apply -- dziala jak inner join, musi miec alias
--outer apply -- dziala jak outer join, wypisuje rowniez studentow ktorzy nie maja oceny
(select top (2) grade, exam_date from student_grades sg-- szukamy dla niego wszystkich ocen, zwraca tez exam_date, dziala inaczej niz subquery
where s.student_id=sg.student_id
order by grade desc)
as A

/*21.16b
Identyfikatory i nazwiska student�w oraz dwie najgorsze oceny dla ka�dego studenta wraz z datami ich przyznania. 
Zapytanie uwzgl�dnia tak�e student�w, kt�rym nie zosta�a przyznana �adna ocena. U�yj operatora APPLY. 51 rekord�w.
Pierwszy: 1, Bowen, 2.0, 2018-03-22 Ostatni: 35, Fisher, NULL, NULL
W kilku przypadkach (np. studenci o id: 5, 11, 13, 16) studenci nie otrzymali �adnej oceny.*/

select * from students s
outer apply
(select top(1) grade, exam_date from student_grades sg 
where s.student_id=sg.student_id order by grade) as app

/*21.17
Identyfikatory i nazwiska student�w oraz kwoty dw�ch ostatnich wp�at za studia wraz z datami tych wp�at. 
Zapytanie uwzgl�dnia tak�e student�w, kt�rzy nie dokonali �adnej wp�aty. U�yj operatora APPLY. 54 rekordy.
Trzeci: 2, Palmer, 450.00, 2018-10-30. W kilku przypadkach (np. studenci o id: 9, 10, 20) studenci nie dokonali �adnej wp�aty.*/

select * from students s
outer apply
(select top(2) fee_amount, date_of_payment from tuition_fees tf
where s.student_id=tf.student_id
order by date_of_payment desc) as app


