create table test (id int primary key, type_of_test varchar(30),  test_date date)
create table test2 (id int primary key, type_of_test varchar(30),  test_date date)

insert into test (id, type_of_test, test_date)
values (1, 'math', '20200102'), (2, 'eng', '20200802'), (3, 'geo', '20200509');

insert into test2 (id, type_of_test, test_date)
values (1, 'physics', '20200105'), (2, 'biology', '20200405'), (3, 'pol', '20200303');


select * from test
select * from test2

update test
set id = 5
where id = 1 

delete test
delete from test
where id = 2
truncate table test

create table tuition
(payment_id int primary key, id int not null, fee decimal(7,2), payment_date date not null default getdate(),
constraint xx foreign key(id) references test2)

select * from tuition

select 12 + '2' -- 14