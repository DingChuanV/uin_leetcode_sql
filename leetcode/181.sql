Create table If Not Exists Employee
(
    id        int,
    name      varchar(255),
    salary    int,
    managerId int
);
Truncate table Employee;
insert into Employee (id, name, salary, managerId)
values ('1', 'Joe', '70000', '3');
insert into Employee (id, name, salary, managerId)
values ('2', 'Henry', '80000', '4');
insert into Employee (id, name, salary, managerId)
values ('3', 'Sam', '60000', 'Null');
insert into Employee (id, name, salary, managerId)
values ('4', 'Max', '90000', 'Null');

select *
from Employee;

select t1.name as Salary
from Employee t1
         join Employee t2 on t1.managerId = t2.id and t1.managerId is not null
where t1.salary > t2.salary;


select t1.name as Salary
from Employee t1,
     Employee t2
where t1.managerId = t2.id
  and t1.salary > t2.salary;