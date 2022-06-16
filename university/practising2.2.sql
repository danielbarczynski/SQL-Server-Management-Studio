select 'nowak' + null

-- Prosta funkcja:

create or alter function id_f -- f od funcion
(@id as int)
returns table as return
select * from students
where student_id=@id 

select * from id_f(6) -- widok juz tak nie dziala, trzeba to obejsc nieco

-- Prosty view:

create or alter view id_v as -- v od view
select * from students
where student_id =SESSION_CONTEXT(N'id') 

exec sp_set_session_context @key=N'id', @value=5 
select * from id_v 

-- Prosty row number:

select ROW_NUMBER() over
(partition by group_no order by group_no) licznik_grupy, group_no, student_id, surname, first_name
from students
--where licznik_grupy = 3 -- nie dzia³a, potrzebne cte lub dt

-- Prosty DT: (derived table)

select * from 
(select ROW_NUMBER() over
(partition by group_no order by group_no) licznik_grupy, group_no, student_id, surname, first_name
from students) as dt
where licznik_grupy=4

-- Prosty CTE: (common table expression)

with cte as(
select ROW_NUMBER() over
(partition by group_no order by group_no) licznik_grupy, group_no, student_id, surname, first_name
from students)
select * from cte where licznik_grupy=5

-- Prosty widok z CTE:

create or alter view cte_v as
with cte as
(select ROW_NUMBER() over
(partition by group_no order by group_no) licznik_grupy, group_no, student_id, surname, first_name
from students)
select * from cte 

select * from cte_v where licznik_grupy = 3

-- Prosta funkcja z CTE:

create or alter function cte_f 
(@cte as int)
returns table as return
with cte as(
select ROW_NUMBER() over
(partition by group_no order by group_no) licznik_grupy, group_no, student_id, surname, first_name
from students)
select * from cte 
where licznik_grupy <= @cte


select * from cte_f(2)
order by licznik_grupy


-- Prosta funkcja z CTE (2 parametry):

create or alter function ctee_f
(@group as varchar(20), @licznik as int)
returns table as return
with cte as
(select ROW_NUMBER() over
(partition by group_no order by group_no) as licznik_grupy, student_id, first_name, surname from students
where group_no=@group)
select * from cte
where licznik_grupy<=@licznik -- wewnatrz nawiasow by go nie widzialo

select * from ctee_f('DMIe1011', 4)

-- Zaawansowane CTE:

with cte as
(select module_id, module_name, preceding_module, 0 as distance from modules
where module_id = 9
union all
select m.module_id, m.module_name, m.preceding_module, distance+1 from cte c
join modules m on m.module_id=c.preceding_module)
select * from cte

select * from students_modules
where planned_exam_date like '2018-11%'
