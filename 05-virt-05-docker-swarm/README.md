# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"


---

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?

---

**Ответ.**

**В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?**

- Режим `replication` - сервис будет запущен на указанном количестве нод. Ноды будут выбраны автоматически или в соответствии с заданными параметрами `constraints`.
- Режим `global` - сервис будет запущен на всех нодах кластера.

**Какой алгоритм выбора лидера используется в Docker Swarm кластере?** 

- Для выбора лидера используется алгоритм согласования `Raft`.

**Что такое Overlay Network?**

- Это распределенная виртуальная сеть между хостами Docker. Она создается поверх существующей сети. Используется для безопасной передачи данных и команд управления между нодами. В работе сети используются технологии VXLAN и протокол Gossip.

---

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```

---

**Ответ.**


![Задача 2](/05-virt-05-docker-swarm/img/2.png)

---


## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```

---

**Ответ.**


![Задача 3](/05-virt-05-docker-swarm/img/3.png)

---


## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```

---

**Ответ.**


```bash
root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
qunf1tve29c5zg8f9ikdegzbq *   node01.netology.yc   Ready     Active         Leader           20.10.12
3ojdl704m83a23lhurh7vch00     node02.netology.yc   Ready     Active         Reachable        20.10.12
tmmwn0v82o42c5dmoraasrijr     node03.netology.yc   Ready     Active         Reachable        20.10.12
js5b0f98o32vjd7p4mespwy3s     node04.netology.yc   Ready     Active                          20.10.12
7qvk13psa90paszvvz8nzgg09     node05.netology.yc   Ready     Active                          20.10.12
9gvhkt21v7n670i810k69phal     node06.netology.yc   Ready     Active                          20.10.12
[root@node01 ~]# docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-OQFZZFC4kWfdsLgeYycplu34a4c/yuHvNa0tJ8l22RI

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
[root@node01 ~]# 
```

Включается автоблокировка роя для защиты ключей шифрования. В этом режиме информация Raft-логов `manadger` нод шифруется. И необходим ключ при перезапуске `manadger` нод для подключения к кластеру. 
Одна из причин, по которой эта функция была введена, заключалась в поддержке новой функции секретов Docker.

---
