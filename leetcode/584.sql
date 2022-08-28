-- 584. 寻找用户推荐人
Create table If Not Exists Customer
(
    id
    int,
    name
    varchar
(
    25
), referee_id int);
Truncate table Customer;
insert into Customer (id, name, referee_id)
values ('1', 'Will', 'NULL');
insert into Customer (id, name, referee_id)
values ('2', 'Jane', 'NULL');
insert into Customer (id, name, referee_id)
values ('3', 'Alex', '2');
insert into Customer (id, name, referee_id)
values ('4', 'Bill', 'NULL');
insert into Customer (id, name, referee_id)
values ('5', 'Zack', '1');
insert into Customer (id, name, referee_id)
values ('6', 'Mark', '2');
-- 写一个查询语句，返回一个客户列表，列表中客户的推荐人的编号都 不是 2。

select name from Customer t where t.referee_id!=2 or referee_id is NULL;