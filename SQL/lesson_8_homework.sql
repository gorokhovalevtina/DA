--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

select a.Department, a.Employee, a.salary as Salary FROM
(select e.name as Employee, e.salary, dense_rank() over (partition by departmentId order by salary desc) as rank, 
d.name as Department
from Employee e
left join Department d
on e.departmentId = d.id) a
WHERE a.rank <=3

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

SELECT member_name , status , sum(amount *unit_price ) as costs
from FamilyMembers f left JOIN Payments pp on f.member_id=pp.family_member 
where date like '2005%'
group by member_name, status 

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select name from (select name, count(*)  as cnt
from passenger 
group by name ) a
where cnt>=2

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name ) as count 
from student 
where first_name ='Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select count (DISTINCT classroom) as count 
from Schedule
where date like '2019-09-02'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name ) as count 
from student 
where first_name ='Anna'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

select floor(avg(year(current_date) - year(birthday ))) as age
from FamilyMembers

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select good_type_name,sum(amount*unit_price ) as costs
from GoodTypes g left JOIN  goods g1 
on g.good_type_id=g1.type 
left join Payments p on g1.good_id=p.good
where date like '2005%'
group by good_type_name 

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select min(TIMESTAMPDIFF(YEAR,birthday ,current_date)) as year 
from Student

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

select max(TIMESTAMPDIFF(YEAR,birthday ,CURDATE())) as max_year
from student s left JOIN Student_in_class st on s.id=st.student 
left join class c on st.class=c.id
where name like '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select status, member_name, sum(amount *unit_price ) AS COSTS
from FamilyMembers f left join Payments p on f.member_id=p.family_member left join goods g on p.good=g.good_id left join GoodTypes gt on g.type=gt.good_type_id  
where good_type_name ='entertainment'
group by member_name, status

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

delete from Company
where id in (select company
from (SELECT count(id) cnt, company 
from trip
group by company) a 
where cnt = (select min(cnt) from (SELECT count(id) cnt, company 
from trip
group by company)b))

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select classroom 
from (select classroom , count(*) as cnt
from Schedule
group by classroom 
having cnt=(select max(cnt) from (select classroom , count(*) as cnt
from Schedule
group by classroom)a))b

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

select last_name 
from Teacher t left join Schedule s on t.id=s.teacher left join
Subject s1 on s.subject=s1.id
where name ='Physical Culture'
order by last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

select concat(last_name,'.',LEFT(first_name, 1),'.',LEFT(middle_name, 1),'.') as name
from student 
order by name
