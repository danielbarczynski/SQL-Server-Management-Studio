-- unique key

CREATE TABLE Persons (
    ID int NOT NULL UNIQUE,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int
);

-- many unique keys

CREATE TABLE Persons2 (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    CONSTRAINT UC_Person UNIQUE (ID,LastName)
);

-- procedure

CREATE PROCEDURE nazwiska2
AS
select surname from students
GO;

exec nazwiska2

-- trigger

create TABLE Orders (id INT identity(1,1) primary key, OrdPiority varchar(10))


create trigger tblOrdersInsert
on Orders
for insert
as
IF( SELECT COUNT(*) FROM Orders WHERE OrdPiority = 'High') = 2 -- orders can also be written as 'inserted'
    BEGIN
        PRINT 'Email Code Goes Here'
    END
GO
INSERT into Orders VALUES (1, 'High'),(2, 'High')
truncate table Orders
select * from Orders

-- function

create function addNum(@number int)
returns int as
begin
declare @wynik int = 5
set @wynik = @wynik + @number
return @wynik
end

declare @string varchar(10) 
set @string = 'o'
print @string

print [dbo].addNum(15)

select * from students

-- subquery

select surname from students
where student_id in
(select student_id from student_grades) -- podzapytanie jest kompilowane pierwsze

-- aggregate function

select COUNT(surname) from students

-- scalar function

SELECT lower(surname) FROM students
select UPPER(surname) from students

-- copy

Select * into studentcopy from students
select * into ordersCopy from Orders
select * from ordersCopy
-- empty table from existing table

select * into studentcopy2 from studentcopy where 0=1000
select * from studentcopy2

-- fetching common records from 2 tables

select student_id from students 
intersect
select student_id from student_grades

-- difference (join)

select * from students s
inner join student_grades sg on s.student_id=sg.student_id

select * from student_grades order by student_id
-- fetch first 5 characters from row

select * from students
select SUBSTRING(surname, 1,5) from students

-- operator for pattern matching = LIKE

select * from students where surname like '%n'

-- increase all empl income by 5%

create table emplyees(
empId int primary key,
surname varchar(10),
income decimal (4, 1))


insert into emplyees values (1, 'bowen', 250.0), (2, 'nick', 350.0)

select * from emplyees
drop table emplyees


update emplyees 
set income = income + (income * 0.05)

select * from emplyees
where income between 200 and 300

--loop

declare @liczba int  = 1
while @liczba <= 10
begin
print @liczba
set @liczba = @liczba + 1
end

-- try catch

BEGIN TRY
SELECT 'Foo' AS Result;
END TRY
BEGIN CATCH
SELECT 'Foo' AS Result2;
END CATCH

select student_id from students
where not student_id = 5

SELECT TOP(1) * FROM Students ORDER BY NEWID();
select top(1) * from Orders order by id asc

-- create table 

create table test
(id int primary key, firstName varchar(30))

insert into test values (1, 'test1'),(2, 'test2'), (3, 'test3')
alter table test 
alter column firstName varchar(10)

select * from test

-- transaction + try catch

begin try
begin transaction
update test set firstName = 'nottest2' where id = 3
update test set firstName = 'wwwwwwwwwwwwwwwwwwwwwwwww' where id = 2
commit transaction
print 'transaction committed'
end try
begin catch
rollback transaction
print 'transaction rolled back'
end catch

-- view

create view abstraction as
select * from students
where student_id <= 5

select * from abstraction
where student_id = 4

--

alter trigger watchOrders
on Orders
for insert
as
if (select COUNT(*) from Orders where OrdPiority = 'High') = 3
print 'trigger activated'


insert into Orders (OrdPiority) values('High')

select * from Orders

CREATE SCHEMA test AUTHORIZATION [dbo]

-- modyfing data as select

create table numbers (number int)

insert into numbers values (1),(8),(3),(5),(4),(5)

select number * number * number as result from numbers

-- offset

select * from student_grades 
order by exam_date asc 
offset 6 rows 
fetch next 10 rows only 