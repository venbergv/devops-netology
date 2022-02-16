# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

---

**Ответ.**

Делаю `docker-compose.yml`

```bash
version: "3.8"
services:

  db:
    image: postgres:12-alpine
    container_name: postgres12
    restart: always
    environment:
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - base:/var/lib/postgresql/data
      - backup:/var/tmp/pg

volumes:
  base:
  backup:
```

Понимаю контейнер с `PostgreSQL 12`.

```bash
vagrant@server1:~/62$ docker-compose up -d
Creating network "62_default" with the default driver
Creating volume "62_base" with default driver
Creating volume "62_backup" with default driver
Pulling db (postgres:12-alpine)...
12-alpine: Pulling from library/postgres
59bf1c3509f3: Pull complete
c50e01d57241: Pull complete
a0646b0f1ead: Pull complete
c4cf156c3ca3: Pull complete
51ed07340794: Pull complete
7c158e4ed48f: Pull complete
d88a6b4803ae: Pull complete
372cd963b4bd: Pull complete
Digest: sha256:b5da30d2ba744fe890fa18695e201cea1366491be287a74b8d7709da8a5b9304
Status: Downloaded newer image for postgres:12-alpine
Creating postgres12 ... done
```

Подключаемся к `postgres`.

```bash
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED         STATUS         PORTS                                       NAMES
235f4e57d419   postgres:12-alpine   "docker-entrypoint.s…"   8 minutes ago   Up 8 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres12
vagrant@server1:~$ docker exec -it postgres12 sh
/ # 
```

Текущее состояние.

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
---

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

---

**Ответ.**

Создаем пользователя и базу:

```bash
postgres=# CREATE USER "test-admin-user" WITH PASSWORD 'testpg12';
CREATE ROLE
postgres=# CREATE DATABASE test_db;
CREATE DATABASE
postgres=# 
```

Не забываем зайти в созданную базу!

```bash
postgres=# \c test_db
psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1), server 12.10)
You are now connected to database "test_db" as user "postgres".
test_db-#
```

Создаем таблицу `orders`:

```bash
CREATE TABLE orders
(
    id SERIAL PRIMARY KEY,
    наименование TEXT,
    цена INTEGER
);
```

Создаем таблицу `clients`:

```bash
CREATE TABLE clients
(
    id SERIAL PRIMARY KEY,
    фамилия TEXT,
    "страна проживания" TEXT,
    заказ INTEGER,
    FOREIGN KEY (заказ) REFERENCES orders (id)
);
```
```bash
CREATE INDEX ON clients ("страна проживания"); 
```

Создаем пользователя `test-simple-user`:

```bash
CREATE USER "test-simple-user" WITH PASSWORD 'testpg12';
```
Выдаем привелегии пользователям:

```bash
GRANT ALL PRIVILEGES ON TABLE public.orders TO "test-admin-user";
GRANT ALL PRIVILEGES ON TABLE public.clients TO "test-admin-user";
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.orders TO "test-simple-user";
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.clients TO "test-simple-user";
```

**- итоговый список БД после выполнения пунктов выше,**

```bash
test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

test_db=# 
```

**- описание таблиц (describe)**

```bash
test_db=# \d
               List of relations
 Schema |      Name      |   Type   |  Owner   
--------+----------------+----------+----------
 public | clients        | table    | postgres
 public | clients_id_seq | sequence | postgres
 public | orders         | table    | postgres
 public | orders_id_seq  | sequence | postgres
(4 rows)

test_db=# 
```

```bash
test_db=# \d+ orders
                                                   Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default               | Storage  | Stats target | Description 
--------------+---------+-----------+----------+------------------------------------+----------+--------------+-------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
 наименование | text    |           |          |                                    | extended |              | 
 цена         | integer |           |          |                                    | plain    |              | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap

test_db=# \d+ clients
                                                      Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default               | Storage  | Stats target | Description 
-------------------+---------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass) | plain    |              | 
 фамилия           | text    |           |          |                                     | extended |              | 
 страна проживания | text    |           |          |                                     | extended |              | 
 заказ             | integer |           |          |                                     | plain    |              | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_страна проживания_idx" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap

test_db=# 
```


**- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db**  
**- список пользователей с правами над таблицами test_db**

Пример запроса и его ответ:

```bash
SELECT * FROM information_schema.table_privileges WHERE grantee in ('test-admin-user','test-simple-user');
```

```bash
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(22 rows)
```

Или более компактно:

```bash
SELECT grantee, table_catalog, table_name, array_agg(privilege_type) FROM information_schema.role_table_grants WHERE grantee in ('test-admin-user','test-simple-user') GROUP BY grantee, table_catalog, table_name;
```   

```bash
     grantee      | table_catalog | table_name |                         array_agg                         
------------------+---------------+------------+-----------------------------------------------------------
 test-admin-user  | test_db       | clients    | {TRIGGER,REFERENCES,TRUNCATE,DELETE,INSERT,SELECT,UPDATE}
 test-admin-user  | test_db       | orders     | {INSERT,SELECT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER}
 test-simple-user | test_db       | clients    | {DELETE,INSERT,SELECT,UPDATE}
 test-simple-user | test_db       | orders     | {DELETE,UPDATE,SELECT,INSERT}
(4 rows)

```

---
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

---

**Ответ.**

Наполняем таблицы:

```bash
test_db=# INSERT INTO orders
test_db-# (наименование, цена)
test_db-# VALUES
test_db-# ('Шоколад', 10),
test_db-# ('Принтер', 100),
test_db-# ('Книга', 50),
test_db-# ('Монитор', 7000),
test_db-# ('Гитара', 4000);
INSERT 0 5
test_db=# INSERT INTO clients
test_db-# (фамилия, "страна проживания")
test_db-# VALUES
test_db-# ('Иванов Иван Иванович', 'USA'),
test_db-# ('Петров Петр Петрович', 'Canada'),
test_db-# ('Иоганн Себастьян Бах', 'Japan'),
test_db-# ('Ронни Джеймс Дио', 'Russia'),
test_db-# ('Ritchie Blackmore', 'Russia');
INSERT 0 5
test_db=# 
```
Вычисляем количество записей в таблицах:

```bash
test_db=# select count (*) from orders;
 count 
-------
     5
(1 row)
```

```bash
test_db=# select count (*) from clients;
 count 
-------
     5
(1 row)
```

---

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказка - используйте директиву `UPDATE`.

---

**Ответ.**

```bash
test_db=# UPDATE clients SET заказ=3 WHERE id=1;
UPDATE 1
test_db=# UPDATE clients SET заказ=4 WHERE id=2;
UPDATE 1
test_db=# UPDATE clients SET заказ=5 WHERE id=3;
UPDATE 1
test_db=#
```

```bash
test_db=# SELECT * FROM clients WHERE заказ IS NOT NULL;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)

test_db=# 
```


---

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

---

**Ответ.**

```bash
test_db=# EXPLAIN SELECT * FROM clients WHERE заказ IS NOT NULL;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: ("заказ" IS NOT NULL)
(2 rows)

test_db=#
```
`cost` - ожидаемая условная стоимость выполнения плана запроса. 
`rows` - ожидаемое количество строк.
`width` - ожидаемый размер строк в байтах.

---

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---

**Ответ.**

Делаем резервную копию данных.

```bash
pg_dump -U postgres -h localhost -p 5432 -x --format=custom --clean --create -f /var/tmp/pg/test_db.dump test_db
```

Останавливаем контейнер

```bash
vagrant@server1:~/62$ docker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED       STATUS       PORTS                                       NAMES
b8f3028e49b8   postgres:12-alpine   "docker-entrypoint.s…"   4 hours ago   Up 4 hours   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres12
vagrant@server1:~/62$ docker stop postgres12
postgres12
vagrant@server1:~/62$ docker rm postgres12
postgres12
vagrant@server1:~/62$ docker volume ls
DRIVER    VOLUME NAME
local     62_backup
local     62_base
vagrant@server1:~/62$ docker volume rm 62_base
62_base
vagrant@server1:~/62$
```

Поднимаем пустой контейнер

```bash
vagrant@server1:~/62$ docker-compose up -d
Creating volume "62_base" with default driver
Creating postgres12 ... done
vagrant@server1:~/62$ docker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED         STATUS         PORTS                                       NAMES
24102a8b8403   postgres:12-alpine   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres12
vagrant@server1:~/62$ docker exec -it postgres12 sh
/ # cd /var/tmp/pg
/var/tmp/pg # ls
test_db.dump
/var/tmp/pg #
```

```bash
/var/tmp/pg # su - postgres
24102a8b8403:~$ psql
psql (12.10)
Type "help" for help.

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

Восстанавливаем БД test_db в новом контейнере.

```bash
/ # pg_restore -U postgres -C -d postgres /var/tmp/pg/test_db.dump
/ # psql -U postgres
psql (12.10)
Type "help" for help.

postgres=# 
```
Смотрим восстановленное.

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
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".
test_db=# SELECT * FROM clients;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  4 | Ронни Джеймс Дио     | Russia            |      
  5 | Ritchie Blackmore    | Russia            |      
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(5 rows)

test_db=# SELECT * FROM orders;
 id | наименование | цена 
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      |  100
  3 | Книга        |   50
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)

test_db=# 
```

---

