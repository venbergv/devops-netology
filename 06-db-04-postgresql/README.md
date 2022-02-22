# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

---

**Ответ.**

Делаем `docker-compose.yml`

```bash
agrant@server1:~/64$ cat docker-compose.yml 
version: "3.8"
services:

  db:
    image: postgres:13-alpine
    container_name: postgres13
    restart: always
    environment:
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - "./docker/db/data:/var/lib/postgresql/data"
```

Понимаем контейнер с `PostgreSQL 13`.

```bash
vagrant@server1:~/64$ docker-compose up -d
Creating network "64_default" with the default driver
Pulling db (postgres:13-alpine)...
13-alpine: Pulling from library/postgres
59bf1c3509f3: Pull complete
c50e01d57241: Pull complete
a0646b0f1ead: Pull complete
d61c3269c761: Pull complete
a98aa553905b: Pull complete
863a0e4b7c1c: Pull complete
11bfb8ea649e: Pull complete
4d752d0ff5ff: Pull complete
Digest: sha256:a003a8ef4aed3ec511525efe9230da56d5368f53f6033cb241154dd6781ffd23
Status: Downloaded newer image for postgres:13-alpine
Creating postgres13 ... done
```

Подключаемся к PostgreSQL используя `psql`.

```bash
vagrant@server1:~/64$ docker exec -it postgres13 sh
/ # su - postgres
d5b94583305d:~$ psql
psql (13.6)
Type "help" for help.

postgres=# 
```
**- вывода списка БД**
```bash
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres=#
```
**- подключение к БД**
```bash
postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
postgres=#
```
**- вывод списка таблиц**
```bash
postgres=# \dtS+
                                        List of relations
   Schema   |          Name           | Type  |  Owner   | Persistence |    Size    | Description 
------------+-------------------------+-------+----------+-------------+------------+-------------
 pg_catalog | pg_aggregate            | table | postgres | permanent   | 56 kB      | 
 pg_catalog | pg_am                   | table | postgres | permanent   | 40 kB      | 
 pg_catalog | pg_amop                 | table | postgres | permanent   | 80 kB      | 
 pg_catalog | pg_amproc               | table | postgres | permanent   | 64 kB      | 
 pg_catalog | pg_attrdef              | table | postgres | permanent   | 8192 bytes | 
...
```
**- вывод описания содержимого таблиц**
```bash
postgres=# \dS+ pg_attrdef
                                  Table "pg_catalog.pg_attrdef"
 Column  |     Type     | Collation | Nullable | Default | Storage  | Stats target | Description 
---------+--------------+-----------+----------+---------+----------+--------------+-------------
 oid     | oid          |           | not null |         | plain    |              | 
 adrelid | oid          |           | not null |         | plain    |              | 
 adnum   | smallint     |           | not null |         | plain    |              | 
 adbin   | pg_node_tree | C         | not null |         | extended |              | 
Indexes:
    "pg_attrdef_adrelid_adnum_index" UNIQUE, btree (adrelid, adnum)
    "pg_attrdef_oid_index" UNIQUE, btree (oid)
Access method: heap
```
**- выход из psql**
```bash
postgres=# \q
d5b94583305d:~$
```

---

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

---

**Ответ.**

Используя `psql` создаем БД `test_database`.

```bash
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=# 
```
Восстанавливаю бэкап БД в `test_database`.

```bash
0445093c9963:~$ psql -U postgres -f /var/tmp/test_dump.sql test_database
```
Перехожу в управляющую консоль `psql` внутри контейнера.

```bash
0445093c9963:~$ psql
psql (13.6)
Type "help" for help.

postgres=#
```

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```bash
test_database-# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database-# \dt+
                              List of relations
 Schema |  Name  | Type  |  Owner   | Persistence |    Size    | Description 
--------+--------+-------+----------+-------------+------------+-------------
 public | orders | table | postgres | permanent   | 8192 bytes | 
(1 row)

test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

Ищем столбец таблицы `orders` с наибольшим средним значением размера элементов в байтах.

```bash
test_database=# SELECT avg_width FROM pg_stats WHERE tablename='orders';
 avg_width 
-----------
         4
        16
         4
(3 rows)

test_database=#
```

Столбец номер **2**.

---

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

---

**Ответ.**

Т.к. секционировать уже созданную таблицу нельзя, то нужно создать таблицу заново.  
Т.к. верхние границы соседних секций не включаются в диапазон, то придется разбивать по значениям до 500 и выше 500.  

```bash
test_database=# ALTER TABLE orders RENAME TO orders_old;
ALTER TABLE
test_database=# CREATE TABLE orders (id integer, title character varying(80), price integer) PARTITION BY RANGE(price);
CREATE TABLE
test_database=# CREATE TABLE orders_before500 PARTITION OF orders FOR VALUES FROM (0) to (500);
CREATE TABLE
test_database=# CREATE TABLE orders_after500 PARTITION OF orders FOR VALUES FROM (500) to (1000);
CREATE TABLE
test_database=# INSERT INTO orders (id, title, price) SELECT * FROM orders_old;
INSERT 0 8
test_database=# DROP TABLE orders_old;
DROP TABLE
test_database=#
```

Проверяем результат по таблицам.

```bash
test_database=# SELECT * FROM orders;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
  2 | My little database   |   500
  6 | WAL never lies       |   900
  8 | Dbiezdmin            |   501
(8 rows)

test_database=# SELECT * FROM orders_after500;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# SELECT * FROM orders_before500;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

test_database=#
```

**Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?**

Нужно было изначально заложить секционирование при создании таблицы и создать функцию, с помощью которой данные будут распределяться автоматически.

---

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---

**Ответ.**

Создаем резервную копию.

```bash
/ # pg_dump -U postgres -d test_database > /var/tmp/test_database_dump.sql
```

Чтобы добавить уникальность значения столбца `title` для таблиц `test_database` предлагаю изменить  
`title character varying(80),`  
на  
`title character varying(80) UNIQUE,`  
в резервной копии.
---


