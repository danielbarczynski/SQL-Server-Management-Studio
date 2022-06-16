select cast(sysdatetime() as date)

select cast(sysdatetime() as time)

select DATEDIFF(day, '20180509', getdate())

select format(159, '0000') -- 159 - 0159 (4 zeros)

select RAND() -- random

select case 
when student_id >= 10 and student_id <= 20 then 'mid'
when student_id > 20  then 'end'
else 'top' end from students

select surname, first_name,
case employee_id 
when 1 then 'o'
when 2 then 'b'
when 3 then 'i'
else 'wan'
end id
from employees

declare 
@x as varchar(3) = null,
@y as varchar(9) = '1234567890'
select coalesce(@x,  @y) coal
select ISNULL(@x, @y) nul -- na opak w stosunku do coalesce

select choose(3, 'a', 'b', 'c') -- wybiera 3 litere

DECLARE @empid AS INT = 10
SELECT employee_id, first_name, surname
FROM Employees
WHERE  employee_id = @empid;
IF @@ROWCOUNT = 0 -- jesli nic nie znalazlo/zwrocilo
PRINT CONCAT('Employee ', CAST(@empid AS VARCHAR(10)), ' was not found.');

print('hi')
print concat('hi', ' you')

declare @studid int = 5
select first_name, surname, student_id from students
where student_id = @studid

declare @number as int = 100
select cast(@number as varchar) number

declare @string as varchar(10) = 'danielllo'
select @string string

declare @imie as varchar(10) = 'daniel'
print concat('siema ', @imie)

declare @z int = 2;
select 5 / @z z --not 2.5

DECLARE @p1 AS INT = 5, @p2 AS INT = 2;	
select 1.0 * @p1/@p2 wynik -- to double

select top(10) employee_id, first_name, surname from employees
order by NEWID() -- ordering by random (NOT RAND!) 


