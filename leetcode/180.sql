Create table If Not Exists Logs
(
    id  int,
    num int
);
Truncate table Logs;
insert into Logs (id, num)
values ('1', '1');
insert into Logs (id, num)
values ('2', '1');
insert into Logs (id, num)
values ('3', '1');
insert into Logs (id, num)
values ('4', '2');
insert into Logs (id, num)
values ('5', '1');
insert into Logs (id, num)
values ('6', '2');
insert into Logs (id, num)
values ('7', '2');

select *
from Logs;

# 查找所有至少连续出现三次的数字
# 1. 三表直接连接
select distinct l1.num as ConsecutiveNums
from Logs as l1,
     Logs as l2,
     Logs as l3
where l1.id = l2.id - 1
  and l1.id = l3.id - 2
  and l1.num = l2.num
  and l2.num = l3.num;

# 2. 利用窗口函数求出diff后进行分组，再用having子句过滤
select distinct num as ConsecutiveNums
from (select num, id + 1 - row_number() over (partition by num order by id) as diff
      from Logs) t
group by num, diff
having count(*) >= 3;

# 3. 如果id不是连续的，要求按照表中连续3个以上的记录
select distinct num as ConsecutiveNums
from (select num, (row_number() over (order by id) - row_number() over (partition by num order by id)) as diff
      from Logs) t
group by num, diff
having count(*) >= 3;