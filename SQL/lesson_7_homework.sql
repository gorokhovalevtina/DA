colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

create table table1 as 
SELECT cast(random() * 1000 as int) as one, cast(random() * 1000 as int) as two, cast(random() * 1000 as int) as three
FROM generate_series(1,1000)

import psycopg2
import pandas as pd 

import sqlite3
conn_sqlite = sqlite3.connect('task1_7.db')  


DB_HOST = '178.170.196.15'
DB_USER = 'student8'
DB_USER_PASSWORD = 'student8_password'
DB_NAME = 'sql_ex_for_student8'

conn = psycopg2.connect(host=DB_HOST, user=DB_USER, password=DB_USER_PASSWORD, dbname=DB_NAME)
cur = conn.cursor()

table1_query = 'select * from table1'

table1 = pd.read_sql(sql=table1_query, con=conn)

table1.to_sql('table1', conn_sqlite)

--Гистограмма

import matplotlib.pyplot as plt
import numpy as np
fig, ax = plt.subplots()

a_heights, a_bins = np.histogram(table1['one'])
b_heights, b_bins = np.histogram(table1['two'], bins=a_bins)
c_heights, c_bins = np.histogram(table1['two'], bins=a_bins)

width = (a_bins[1] - a_bins[0])/4

ax.bar(a_bins[:-1], a_heights, width=width, facecolor='cornflowerblue')
ax.bar(b_bins[:-1]+width, b_heights, width=width, facecolor='seagreen')
ax.bar(c_bins[:-1]+width+width, c_heights, width=width, facecolor='blue')

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select email
from
(select email, count(id) as idc
from person
group by email) a
where idc>=2

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

CREATE TABLE Employee (
  id INT NOT NULL,
  name VARCHAR NOT NULL,
  salary INT,
  managerId INT,
  PRIMARY KEY (id)
);

INSERT INTO Employee VALUES (1, 'Joe', 70000,3)

INSERT INTO Employee VALUES (2, 'Henry', 80000,4)

INSERT INTO Employee VALUES (3, 'Sam', 60000,NULL)

INSERT INTO Employee VALUES (4, 'Max', 90000,NULL)

select Name as Employee 
from Employee e 
where e.ManagerId in (select ID from Employee) 
and e.Salary > 
(
    select  ee.Salary from Employee ee where e.ManagerId=ee.Id
);

select e.name as Employee
from Employee e left join Employee e1 on e.ManagerId= e1.id 
where e.salary>e1.salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/
CREATE TABLE Scores (
  id INT NOT NULL,
  score decimal,
  PRIMARY KEY (id)
);

INSERT INTO Scores VALUES (1, 3.50)

INSERT INTO Scores VALUES (2, 3.65)

INSERT INTO Scores VALUES (3, 4.00)

INSERT INTO Scores VALUES (4, 3.85)

INSERT INTO Scores VALUES (5, 4.00)

INSERT INTO Scores VALUES (6, 3.65)


select score,
dense_rank() over (order by score desc) as "rank"
from scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

CREATE TABLE Address (
  addressId INT,
  personId  int,
  city varchar,
  state  varchar,     
  PRIMARY KEY (addressId)
);

INSERT INTO Address VALUES (1,2,'New York City','New York')

INSERT INTO Address VALUES (2,3,'Leetcode','California')

CREATE TABLE Person (
  personId  int,
  lastName  varchar,
  firstName  varchar,     
  PRIMARY KEY (personId)
);

INSERT INTO Person VALUES (1,'Wang', 'Allen')

INSERT INTO Person VALUES (2,'Alice', 'Bob')


select firstName, lastname, city, state
from person p left join address a on p.personId=a.personId