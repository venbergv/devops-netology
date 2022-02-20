# Домашнее задание к занятию "6.3. MySQL"


## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

---

**Ответ.**

Конфигурация для контейнера MySQL

```bash
vagrant@server1:~/63$ cat docker-compose.yml 
version: "3.8"
services:

  db:
    image: mysql:8
    container_name: mysql8
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: mysql
    ports:
      - "3306:3306"
    volumes:
      - type: bind
        source: './db'
        target: /var/tmp
      - './docker/db/data:/var/lib/mysql'
```

Поднимаем инстанс MySQL

```bash
vagrant@server1:~/63$ docker-compose up -d
Creating network "63_default" with the default driver
Pulling db (mysql:8)...
8: Pulling from library/mysql
6552179c3509: Pull complete
d69aa66e4482: Pull complete
3b19465b002b: Pull complete
7b0d0cfe99a1: Pull complete
9ccd5a5c8987: Pull complete
2dab00d7d232: Pull complete
5d726bac08ea: Pull complete
11bb049c7b94: Pull complete
7fcdd679c458: Pull complete
11585aaf4aad: Pull complete
5b5dc265cb1d: Pull complete
fd400d64ffec: Pull complete
Digest: sha256:e3358f55ea2b0cd432685d7e3c79a33a85c7a359b35fa87fc4993514b9573446
Status: Downloaded newer image for mysql:8
Creating mysql8 ... done
vagrant@server1:~/63$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                                  NAMES
93c1c458a421   mysql:8   "docker-entrypoint.s…"   9 seconds ago   Up 7 seconds   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   mysql8
vagrant@server1:~/63$
```
Подключаемся к контейнеру и восстанавливаем базу.

```bash
vagrant@server1:~/63$ docker exec -it mysql8 sh
# mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 13
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE DATABASE test_db DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
Query OK, 1 row affected (0.08 sec)

mysql> \q
Bye
#                 
# mysql -uroot -p test_db </var/tmp/test_dump.sql
Enter password: 
# 
```

Проверяем версию **mysql**.

```bash
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		16
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.28 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			30 min 17 sec

Threads: 2  Questions: 51  Slow queries: 0  Opens: 138  Flush tables: 3  Open tables: 56  Queries per second avg: 0.028
--------------
```

Версия сервера **8.0.28**.


Получаем список таблиц из **test_db**.

```bash
mysql> use test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)
```

Количество записей с price > 300

```bash
mysql> SELECT * FROM orders WHERE price >300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)

mysql> 
```

---

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

---

**Ответ.**

```bash
mysql> CREATE USER 'test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test-pass';
Query OK, 0 rows affected (0.17 sec)
```

```bash
mysql> ALTER USER 'test'@'localhost' PASSWORD EXPIRE INTERVAL 180 DAY;
Query OK, 0 rows affected (0.14 sec)
mysql> ALTER USER 'test'@'localhost' FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME UNBOUNDED;
Query OK, 0 rows affected (0.15 sec)
mysql> ALTER USER 'test'@'localhost' WITH MAX_QUERIES_PER_HOUR 100;
Query OK, 0 rows affected (0.15 sec)
mysql> ALTER USER 'test'@'localhost' ATTRIBUTE '{"firstname":"James", "lastname":"Pretty"}';
Query OK, 0 rows affected (0.15 sec)
```

```bash
mysql> GRANT Select ON test_db.orders TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.15 sec)
```

```bash
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"firstname": "James", "lastname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)

mysql> 

```

---

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

---

**Ответ.**

Устанавливаем профилирование `SET profiling = 1`.

```bash
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)
```

Делаем запрос.

```bash
mysql> SELECT * FROM orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)
```

Смотрим вывод профилирования команд `SHOW PROFILES;`.

```bash
mysql> SHOW PROFILES;
+----------+------------+----------------------------------+
| Query_ID | Duration   | Query                            |
+----------+------------+----------------------------------+
|       15 | 0.00029175 | SET profiling_history_size = 100 |
|       16 | 0.00056625 | SELECT * FROM orders             |
+----------+------------+----------------------------------+
2 rows in set, 1 warning (0.00 sec)
```

Смотрим какой  `engine` используется в таблице БД `test_db`

```bash
mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)
```
---

Изменяем `engine`. Приводим время выполнения и запрос на изменения из профайлера.

```bash
mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.20 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.20 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+-----------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                   |
+----------+------------+-----------------------------------------------------------------------------------------+
|        9 | 0.00036250 | SET profiling_history_size = 100                                                        |
|       10 | 0.00062875 | SELECT * FROM orders                                                                    |
|       11 | 0.01277900 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'test_db' |
|       12 | 0.21162275 | ALTER TABLE orders ENGINE = MyISAM                                                      |
|       13 | 0.20219675 | ALTER TABLE orders ENGINE = InnoDB                                                      |
+----------+------------+-----------------------------------------------------------------------------------------+
5 rows in set, 1 warning (0.00 sec)
```
---

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

---

**Ответ.**

```bash
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# for IO speed
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DSYNC

# for compression
innodb_file_per_table = 1
innodb_file_format = Barracuda

# change log_buffer_size
innodb_log_buffer_size = 1M

# change buffer_pool_size 30%
innodb_buffer_pool_size = 295M

# change log_file_size
innodb_log_file_size = 100M
```
---


