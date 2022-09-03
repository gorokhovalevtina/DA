--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

with list as
(select model from pc p
union all
select model from printer p2
union all
select  model from laptop l)
select distinct l2.model,maker,type
from list l2 left join product p3 on l2.model=p3.model


select *
from product p 


--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"
select *,
case when price > (select avg(price) from pc)
then 1
else 0
end flag
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
select o.ship
from ships s full join outcomes o on s.name=o.ship
where class is null


--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.


with bat as
(SELECT name,extract(year from date) as year  
FROM battles b )
select b.name
from ships s full join outcomes o on s.name=o.ship  full join bat b on o.battle =b."name" 
where year not in (select launched from ships s2)


--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
select battle
from ships s join outcomes o on s."name" =o.ship 
where class='Kongo'

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300 as
with model as 
(select model,price
from pc p 
union all
select model,price from laptop l 
union all
select model,price from printer)
select *,
case when price>300
then 1
else 0
end flag
from model


	
--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as
with model as 
(select model,price
from pc p 
union all
select model,price from laptop l 
union all
select model,price from printer)
select *,
case when price>(select avg(price) from model)
then 1
else 0
end flag
from model



--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with all_price as 
(select p.model,maker,price
from product p2 join printer p on p.model=p2.model)
select model
from all_price
where maker='A' and price>
					(select avg(price) from all_price where maker='D' or maker='C')

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with all_price as 
(select product.model, price, maker
from product 
join pc 
on pc.model = product.model
union all
select product.model, price, maker
from product 
join laptop 
on laptop.model = product.model
union all
select product.model, price, maker
from product 
join printer 
on printer.model = product.model)
select model
from all_price
where maker='A' and price>
					(select avg(price) from printer 
join product 
on product.model = printer.model
where maker = 'D'  or maker='C')		
					



--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
with list_p as 
(select distinct model,price from pc p 
union 
select distinct model,price from laptop l 
union
select distinct model,price from printer) 
select avg(price), lp.model
from list_p lp join product p2 on lp.model=p2.model
where maker='A'
group by lp.model



--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count
create view count_products_by_makers_1 as
with list_p as 
(select model,price from pc p 
union all
select  model,price from laptop l 
union all
select  model,price from printer) 
select maker, count(*) as cn
from list_p lp join product p2 on lp.model=p2.model 
group by maker

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

request = """
SELECT cn,maker
from count_products_by_makers_1
order by cn desc
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.maker.to_list(), y=df.cn.to_list(), labels={'x':'maker', 'y':'count'})
fig.show()


--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create view printer_updated as
select code,p.model,p.color,p.type,p.price
from printer p join product p2 on p.model=p2.model
where maker!='D'


--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as
select code,p.model,p.color,p.type,p.price, maker
from printer p join product p2 on p.model=p2.model
where maker!='D'


--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)
create view sunk_ships_by_classes_1 as
with list_ships as
(select name, class from ships
union all
select distinct ship, NULL as class
from Outcomes
where ship not in (select name from ships))
select class, count(name) as cnt
from list_ships
where name in (select ship from Outcomes where result='sunk')
group by class

SELECT cnt,class
from sunk_ships_by_classes_1
order by cnt desc


--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)
request = """
SELECT class, count(name) as cnt
from sunk_ships_by_classes_1
order by cnt desc
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.class.to_list(), y=df.cnt.to_list(), labels={'x':'class', 'y':'count'})
fig.show()


--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create view classes_with_flag as
select *, 
case when numguns >=9
then 1
else 0
end flag
from classes c 


--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

request = """
select country, count(class) as cnt
from classes_with_flag
group by country
"""
df_1 = pd.read_sql_query(request, conn)
fig = px.bar(x=df_1.country.to_list(), y=df_1.cnt.to_list(), labels={'x':'country', 'y':'count'})
fig.show()

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select count(name)
from ships s
where name like 'O%' or name like 'M%'


--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(name)
from ships s
where name like '% %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

request = """
select launched as year,count(name) as cnt
from ships
group by launched 
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.year.to_list(), y=df.cnt.to_list(), labels={'x':'year', 'y':'count'})
fig.show()