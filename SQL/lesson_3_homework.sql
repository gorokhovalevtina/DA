--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

with sunk_ship as (select ship, class 
	from outcomes o left join ships s on o.ship=s.name 
	where result = 'sunk'
		union 
	select ship, class 
	from outcomes o left join classes c on o.ship=c.class 
	where result = 'sunk')
select s.class,count(ship)
from classes s left join sunk_ship ss on s.class=ss.class
group by s.class

	
--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.


with min_year as (select class,min(launched) as min_year
from ships s 
group by class)
select s."class",
case when s.launched is null
then min.min_year
else s.launched
end flag
from classes c left join ships s on c.class = s.name					
		left join min_year min on c.class = min.class


--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.
with sunk_ships as 				
(select ship, class 
from outcomes o left join ships s on o.ship=s.name 
where result = 'sunk'
union 
select ship, class 
from outcomes o left join classes c on o.ship=c.class 
where result = 'sunk'),	
all_ships as 				
(select name, class 
from ships
union 
select ship as name, ship as class 
from outcomes
where ship in (select class from classes))
select c.class, count(ship)
from classes c join sunk_ships s on c.class = s.class 
where c.class in (select class 
		from all_ships
		group by class
		having count(*) >= 3)
group by c.class				
			
		
		
		
--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).
		
SELECT name
FROM (SELECT O.ship AS name, numGuns, displacement
 FROM Outcomes O JOIN 
 Classes C ON O.ship = C.class
 UNION
 SELECT S.name AS name, numGuns, displacement 
 FROM Ships S  JOIN 
 Classes C ON S.class = C.class 
 ) a  JOIN 
 (select max(numGuns) as numGuns ,displacement
 from(SELECT numGuns, displacement
 FROM Outcomes O  JOIN 
 Classes C ON O.ship = C.class AND 
 O.ship NOT IN (SELECT name 
 FROM Ships
 ) 
 UNION
 SELECT numGuns, displacement
 FROM Ships S  JOIN 
 Classes C ON S.class = C.class) ab
 GROUP BY displacement) b
 ON a.numGuns = b.numGuns AND 
 a.displacement = b.displacement
 
 
--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

SELECT distinct maker
FROM product
WHERE model IN (SELECT model FROM pc
WHERE ram = (SELECT MIN(ram) FROM pc)
AND speed = (SELECT MAX(speed) FROM pc
WHERE ram = (SELECT MIN(ram) FROM pc)))
AND
maker IN (
SELECT maker
FROM product
WHERE type='Printer'
)
		
		
		
		