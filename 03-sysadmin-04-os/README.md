# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
---

Ответ:

*Устанавливаем `node_exporter` согласно [документации](https://prometheus.io/docs/guides/node-exporter/)*

```
vagrant@vagrant:~/soft$ wget https://github.com/prometheus/node_exporter/releases/download/v1.3.0/node_exporter-1.3.0.linux-amd64.tar.gz
vagrant@vagrant:~/soft$ tar xzf node_exporter-1.3.0.linux-amd64.tar.gz
vagrant@vagrant:~/soft$ cd node_exporter-1.3.0.linux-amd64
```

*Создаем unit-файл:*

```
[Unit]
Description=Node Exporter
  
[Service]
ExecStart=/usr/local/bin/node_exporter 
  
[Install]
WantedBy=multi-user.target
```

*Запускаем:*

```
vagrant@vagrant:~$ sudo systemctl daemon-reload
vagrant@vagrant:~$ sudo systemctl start node_expoprter
vagrant@vagrant:~$ sudo systemctl status node_expoprter
vagrant@vagrant:~$ sudo systemctl enable node_expoprter
```

*Перезапускаем систему и проверяем работу сервиса*

```
vagrant@vagrant:~$ sudo reboot
vagrant@vagrant:~$ sudo systemctl status node_expoprter
vagrant@vagrant:~$ sudo systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2021-11-21 02:19:17 UTC; 1 day 4h ago
   Main PID: 612 (node_exporter)
      Tasks: 4 (limit: 1071)
     Memory: 13.1M
     CGroup: /system.slice/node_exporter.service
             └─612 /usr/local/bin/node_exporter
<Skip>
```


---
2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
---

Ответ:

```
vagrant@vagrant:~$ curl http://localhost:9100/metrics | egrep ^node_
```

**CPU**

    node_cpu_seconds_total
    node_cpu_guest_seconds_total

**Память**
    
    node_memory_MemAvailable_bytes 
    node_memory_MemFree_bytes

**Диск**

    node_disk_io_time_seconds_total
    node_disk_read_bytes_total 
    node_disk_read_time_seconds_total
    node_disk_write_time_seconds_total


**Сеть**

    node_network_transmit_queue_length
    node_network_receive_errs_total
    node_network_receive_bytes_total
    node_network_transmit_bytes_total
    node_network_transmit_errs_total

---
3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
---

Ответ:

*Проводим установку согласно документации*

*Проверяем работу `netdata`*

![Netdata](/03-sysadmin-04-os/img/netdata.png)

---
4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
---

Ответ:

*Да можно.*

```
vagrant@vagrant:~$ dmesg | grep virtual
[    0.001747] CPU MTRRs all blank - virtualized system.
[    0.086176] Booting paravirtualized kernel on KVM
[    2.533763] systemd[1]: Detected virtualization oracle.
vagrant@vagrant:~$ 
```

---
5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
---

Ответ:

```
vagrant@vagrant:~$ sysctl fs.nr_open
fs.nr_open = 1048576
vagrant@vagrant:~$ 
```

*Это максимальное количество возможных открытых файлов в системе.* 


```
vagrant@vagrant:~$ ulimit -Sn
1024
```

*Это мягкий лимит на количество открытых файлов и его можно увеличивать до жесткого лимита*

```
vagrant@vagrant:~$ ulimit -Hn
1048576
```

*Это жесткий лимит, задаваемый администратором. Он не может превышать* `fs.nr_open`

---
6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.
---

Ответ:

```
vagrant@vagrant:~$ sudo -i
root@vagrant:~# unshare -f --pid --mount-proc sleep 1h
```

*С другой консоли проверяем*

```
vagrant@vagrant:~$ ps -aux | grep sleep 
root        1739  0.0  0.0   8080   592 pts/0    S+   08:49   0:00 unshare -f --pid --mount-proc sleep 1h
root        1740  0.0  0.0   8076   528 pts/0    S+   08:49   0:00 sleep 1h
vagrant     1746  0.0  0.0   8900   664 pts/1    S+   08:51   0:00 grep --color=auto sleep
vagrant@vagrant:~$ sudo nsenter --target 1740 --pid --mount
root@vagrant:/# ps -aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   8076   528 pts/0    S+   08:49   0:00 sleep 1h
root           2  0.0  0.4   9836  4088 pts/1    S    08:52   0:00 -bash
root          11  0.0  0.3  11680  3532 pts/1    R+   08:52   0:00 ps -aux
root@vagrant:/# 
```



---
7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
 ---

Ответ:

`:()` - *объявление функции с именем* `:`

`{}` - *код функции*

`:|: &` - *функция `:` передает вывод в свою же рекурсивно запущенную копию. И все остается в фоновых процессах*

`;:` - *первый запуск самой функции*

*Такое поведение называется форк-бомбой*

*Останавливает этот ужас:*

```
cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope
```

*Лимит на процессы пользователя можно изменить на текущий момент:*

```
systemctl [--runtime] set-property user-<uid>.slice TasksMax=<value>
```

*Или постоянно:*

```
/etc/systemd/system/user-.slice.d/15-limits.conf
```


