-- 183. 从不订购的客户

Create table If Not Exists Customers
(
    id
        int,
    name
        varchar(255)
);
Create table If Not Exists Orders
(
    id int,
    customerId int
);
Truncate table Customers;
insert into Customers (id, name)
values ('1', 'Joe');
insert into Customers (id, name)
values ('2', 'Henry');
insert into Customers (id, name)
values ('3', 'Sam');
insert into Customers (id, name)
values ('4', 'Max');
Truncate table Orders;
insert into Orders (id, customerId)
values ('1', '3');
insert into Orders (id, customerId)
values ('2', '1');

select Name as Customers
from Customers c
         left join Orders o on c.Id = o.CustomerId
where o.Id is null;

select Name as Customers
from Customers
where Id not in (select CustomerId from Orders);