task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select
case
when grades.grade >= 8 then students.name
when grades.grade < 8 then NULL
end AS name, grades.grade, students.marks
from students
left join grades
on students.marks >= min_mark and students.marks <= max_mark
order by grades.grade DESC, students.name ASC, students.marks ASC;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

with doctors as ( select name, row_number() over(order by name ) rank
from occupations
where occupation ='doctor'),
professors as( select name, row_number() over(order by name ) rank
from occupations
where occupation ='professor'),
singers as ( select name, row_number() over(order by name ) rank
from occupations
where occupation ='singer'),
actors as ( select name,row_number() over(order by name ) rank
from occupations
where occupation ='actor')
select d.name, p.name, s.name, a.name from doctors d full join professors p on p.rank=d.rank full join
singers s on s.rank=p.rank full join actors a on a.rank=s.rank;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city
from station
where city NOT like '[AEUIO]%';

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city
from station
where city NOT like '%[aeuio]';

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct city
from station
where city NOT like '[AEUIO]%' or city NOT like '%[aeuio]';

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct city
from station
where city NOT like '[AEUIO]%' and city NOT like '%[aeuio]';


--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name
from Employee 
where salary>=2000 and months<10
order by employee_id asc;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select
case
when grades.grade >= 8 then students.name
when grades.grade < 8 then NULL
end AS name, grades.grade, students.marks
from students
left join grades
on students.marks >= min_mark and students.marks <= max_mark
order by grades.grade DESC, students.name ASC, students.marks ASC;