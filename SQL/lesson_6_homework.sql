--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.

explain create table new_tab1 as 
SELECT cast(random() * 1000000 as int) as one, cast(random() * 1000000 as int) as two, cast(random() * 1000000 as int) as three
FROM generate_series(1,10000)

explain select *
from new_tab1

explain select sum(one)
from new_tab1

explain select count(one)
from new_tab1

explain select avg(one)
from new_tab1

explain select min(one)
from new_tab1

explain select max(one)
from new_tab1

--task2 (lesson6, дополнительно)
-- GCP (Google Cloud Platform): Через GCP загрузите данные csv в базу PSQL по личным реквизитам (используя только bash и интерфейс bash) 
pscp -P 22 "C:\Users\user\Desktop\root1\avocado.csv" student8@178.170.196.15:/student8