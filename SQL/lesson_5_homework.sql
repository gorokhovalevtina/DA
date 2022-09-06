--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

sample:
1 1
2 1
1 2
2 2
1 3
2 3

create view pages_all_products_1 as
(select *,
case when  rn % 2=0 then rn/2 else rn/2 +1 end as page_num,
case when rn % 2=0 then 2 else 1 end as position
from (select *,
row_number() over (order by price desc) as rn
from laptop) a)

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)
create view distribution_by_type as
(select type, count(*)*100.0 / (select count(*) from product) as perc
from product
group by type)


select distinct type,
(cast(count(model) over (partition by type) as numeric) / cast(count(model) over () as numeric)) * 100 	as perc
from product


--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/

request = """
select *
from distribution_by_type
"""

df = pd.read_sql_query(request, conn)

fig = px.pie(df, values='perc', names='type', title='Процентное соотношение всех товаров по типу устройства')
fig.show()



--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов
create table ships_two_words_1 as
(select *
from ships s 
where name like '% %')

--task5 (lesson5)
-- Корабли:вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"
	
select name
from (select name, class
from ships
union
select ship, null 
from outcomes) a
where class is null and name like 'S%'

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции).
-- Вывести model


select p.model
from printer p join product p2 on p.model=p2.model
where maker='A'  and price > (select avg(price) from printer p3 join product p4 on p3.model=p4.model where maker='C')
union 
select model
from (select p.model,
row_number() over (order by price desc) rn
from printer p join product p2 on p.model=p2.model) a
where rn<=3
