create table UserOrders(UserId int, OrderQuantity int)
insert into UserOrders values 
(5,10), (6,3), (6,5), (6, 8), (7, 22), (7, 33)

select * from UserOrders

-- 1. Write a query that will return the sum of all orders for particular UserIds
-- output: 5,10; 6, 16; 7,55;

select UserId, sum(OrderQuantity) as TotalOrderQuantity
from UserOrders
group by UserId

-----------------------------------------------------------

 create table UserNames(UserId int, UserName nvarchar(50))
 insert into UserNames values
 (5, 'Bob'), (6, 'Jack'), (7, 'Marlena') 
 
 select * from UserNames

-- 2. Write a query that will return UserName and their order quantity
-- output: Bob,10; Jack,3; Jack,5; Jack,8; Marlena,22; Marlena,33;

select UserName,OrderQuantity from UserNames un
inner join UserOrders uo on un.UserId=uo.UserId

-----------------------------------------------------------

create table tblReservation(CustomerName varchar(20) , Reservations int)
insert into tblReservation values ('Mark', 10), ('John', 2), ('Hyenna', 3), ('Lena', 8), ('Will', 15)

alter table tblReservation
add Discount varchar(5) 

select * from tblReservation

select CustomerName, count(*) Reservations
from tblReservation
group by CustomerName
order by Reservations desc

-- 3. We want to give a special discount for the customers that made more than 5 reservations. How to modify this query to get such report?


select CustomerName, sum(Reservations) Reservations
from tblReservation
group by CustomerName
having sum(Reservations) > 5 
order by Reservations desc 

-- in original was count, but that would be too much inserting single data

