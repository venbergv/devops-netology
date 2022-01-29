
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

#
---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

---

***Ответ.***

Свой репозиторий создан на hub.docker.com.

Выбираю nginx:stable-alpine

```bash
vagrant@server1:~/53$ docker pull nginx:stable-alpine
stable-alpine: Pulling from library/nginx
97518928ae5f: Pull complete 
a15dfa83ed30: Pull complete 
acae0b19bbc1: Pull complete 
fd4282442678: Pull complete 
b521ea0d9e3f: Pull complete 
b3282d03aa58: Pull complete 
Digest: sha256:74694f2de64c44787a81f0554aa45b281e468c0c58b8665fafceda624d31e556
Status: Downloaded newer image for nginx:stable-alpine
docker.io/library/nginx:stable-alpine
agrant@server1:~/53$ docker images
REPOSITORY   TAG             IMAGE ID       CREATED        SIZE
nginx        stable-alpine   373f8d4d4c60   2 months ago   23.2MB
vagrant@server1:~/53$ 
```
Создаем **Dockerfile**

```
FROM nginx:alpine

COPY demo-content /usr/share/nginx/html

EXPOSE 80
```

Рядом создаю папку **html** с нашим файлом **index.html**

```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

Делаем сборку нашего образа с именем **hw53**.
```bash
vagrant@server1:~/53$ docker build . -t hw53
Sending build context to Docker daemon  3.584kB
Step 1/3 : FROM nginx:alpine
alpine: Pulling from library/nginx
59bf1c3509f3: Pull complete 
8d6ba530f648: Pull complete 
5288d7ad7a7f: Pull complete 
39e51c61c033: Pull complete 
ee6f71c6f4a8: Pull complete 
f2303c6c8865: Pull complete 
Digest: sha256:da9c94bec1da829ebd52431a84502ec471c8e548ffb2cedbf36260fd9bd1d4d3
Status: Downloaded newer image for nginx:alpine
 ---> bef258acf10d
Step 2/3 : COPY html /usr/share/nginx/html
 ---> 68ef891a1dfd
Step 3/3 : EXPOSE 80
 ---> Running in e26a2787183b
Removing intermediate container e26a2787183b
 ---> 9de05828772c
Successfully built 9de05828772c
Successfully tagged hw53:latest
vagrant@server1:~/53$ 
```

Запускаем наш контейнер. И проверяем работу **nginx**.

```bash
vagrant@server1:~/53$ docker run --name my-hw53 -d -p 8080:80 hw53
88cb05f35e4356c80acaac8ca7d7b671150b4b60ee5a837e36e723a3b1d1f5c6
vagrant@server1:~/53$ curl localhost:8080
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I'm DevOps Engineer!</h1>
</body>
</html>
vagrant@server1:~/53$ 
```

Теперь логинимся на докерхабе.  
Добавляем тег нашему образу.  
Загружаем обрраз в мой репозиторий.  

```bash
vagrant@server1:~/53$ docker tag hw53:latest venbergv/netology:latest
vagrant@server1:~/53$ docker push venbergv/netology:latest
The push refers to repository [docker.io/venbergv/netology]
b5bab0e01f57: Layer already exists 
6fda88393b8b: Layer already exists 
a770f8eba3cb: Layer already exists 
318191938fd7: Layer already exists 
89f4d03665ce: Layer already exists 
67bae81de3dc: Layer already exists 
8d3ac3489996: Layer already exists 
latest: digest: sha256:d2b80fcaa81f83ccfaf0594e48bab31f95cea6a0151cb0ad60d4f319a273a584 size: 1775
vagrant@server1:~/53$ 
```

[Мой репозиторий] (https://hub.docker.com/r/venbergv/netology)


---

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

---

***Ответ.***


- Высоконагруженное монолитное java веб-приложение;

Т.к. это монолит, то максимальная производительность будет на физическом сервере. Но для оптимизации ресурсов подойдет виртуальная машина.

- Nodejs веб-приложение;

Docker будет подходящим выбором. Так же будет удобно масштабировать приложение при необходимости.

- Мобильное приложение c версиями для Android и iOS;

Для запуска мобильных приложений подойдут виртуальные машины с эмуляторами соответствующих ОС. Или физические платформы для разработки, с соответствующими ОС. 

- Шина данных на базе Apache Kafka;

Подойдут все три варианта. Все будет зависеть от реальной нагрузки.

- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;

Подойдут контейнеры. Официально Elasticsearch сам предлагает работать в контейнере.

- Мониторинг-стек на базе Prometheus и Grafana;

Подойдет контейнеризация приложения.

- MongoDB, как основное хранилище данных для java-приложения;

Для тестирования и разработки вполне подходит контейнеризация. При продуктивном использовании физический или виртуальный сервер. В зависимости от нагрузки.

- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

Подойдет физический или виртуальный сервер. В зависимости от нагрузки.

---

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

---

***Ответ.***


Создаем папку **data**.

Будем запускать контейнеры в интерактивном режиме.

В первом терминале запускаем контейнер ***centos***

```bash
agrant@server1:~/53$ who am i
vagrant  pts/0        2022-01-28 19:50 (10.0.2.2)
vagrant@server1:~/53$ docker run -ti -v /home/vagrant/53/data:/data centos
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
[root@636ff39a69a6 /]#
```

Во втором терминале запускаем контейнер ***debian***

```bash
vagrant@server1:~/53$ who am i
vagrant  pts/1        2022-01-29 08:35 (10.0.2.2)
vagrant@server1:~/53$ docker run -ti -v /home/vagrant/53/data:/data debian
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
0c6b8ff8c37e: Pull complete 
Digest: sha256:fb45fd4e25abe55a656ca69a7bef70e62099b8bb42a279a5e0ea4ae1ab410e0d
Status: Downloaded newer image for debian:latest
root@35c08355b2d1:/# 
```

В первом терминале, находясь в сессии centos, добавляем **centos_file.txt**

```bash
[root@636ff39a69a6 /]# touch /data/centos_file.txt
[root@636ff39a69a6 /]# 
```

В терминале хоста добавляем в папку ***data*** файл ***host_file.txt***

```bash
vagrant@server1:~/53$ who am i
vagrant  pts/2        2022-01-29 08:53 (10.0.2.2)
vagrant@server1:~/53$ touch /home/vagrant/53/data/host_file.txt
vagrant@server1:~/53$ 
```

Проверяем содержимое папки ***data*** из контейнера debian.

```bash
root@35c08355b2d1:/# ls -la /data
total 8
drwxrwxr-x 2 1000 1000 4096 Jan 29 08:54 .
drwxr-xr-x 1 root root 4096 Jan 29 08:46 ..
-rw-r--r-- 1 root root    0 Jan 29 08:50 centos_file.txt
-rw-rw-r-- 1 1000 1000    0 Jan 29 08:54 host_file.txt
root@35c08355b2d1:/# 
```

---




