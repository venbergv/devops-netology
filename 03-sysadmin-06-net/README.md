# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?

---

Ответ.

```
vagrant@vagrant:~$ telnet stackoverflow.com 80
Trying 151.101.65.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: 75fcc73c-488a-4c0b-b7f0-286d47a65f65
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Fri, 26 Nov 2021 09:04:47 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-hhn4020-HHN
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1637917488.690435,VS0,VE92
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=d7cfeb49-1749-be5b-2bfb-3d91d71040c9; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.
vagrant@vagrant:~$ 
```

*Получен код 301 - "Перемещен навсегда"*

*Адрес нового месторасположения ресурса указывается в поле Location - https://stackoverflow.com/questions.*

---

2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.

---

Ответ.

*Ответ 200. Запрос выполнен успешно.*

*Дольше всего грузится сам документ. 271мс.*

![Консоль браузера](/03-sysadmin-06-net/img/net1.png)

---

3. Какой IP адрес у вас в интернете?

---

Ответ.

*78.155.2xx.xx*

---

4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`

---

Ответ.

```
% Information related to '78.155.2xx.0/22AS199860'

route:          78.155.2xx.0/22
origin:         AS199860
remarks:        region-id = Russia, Saint Petersburg
mnt-by:         ADC-XELENT-MNT
created:        2016-08-01T09:35:25Z
last-modified:  2021-07-22T10:12:22Z
source:         RIPE # Filtered

% This query was served by the RIPE Database Query Service version 1.101 (BLAARKOP)
```

---

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`

---

Ответ.

```
traceroute -An 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  192.168.x.xxx [*]  0.451 ms  0.435 ms  0.422 ms
 2  192.168.x.xxx [*]  0.409 ms  0.361 ms  0.339 ms
 3  78.155.2xx.x [AS199860]  562.930 ms  562.926 ms  562.907 ms
 4  185.44.12.70 [AS199860]  0.629 ms  0.603 ms  0.599 ms
 5  109.239.137.237 [AS31500]  1.627 ms  1.614 ms  1.599 ms
 6  74.125.244.133 [AS15169]  0.956 ms  0.965 ms 74.125.244.181 [AS15169]  2.272 ms
 7  142.251.51.187 [AS15169]  4.576 ms  4.564 ms 72.14.232.84 [AS15169]  1.417 ms
 8  216.239.48.163 [AS15169]  4.385 ms 172.253.79.237 [AS15169]  4.348 ms 216.239.48.163 [AS15169]  4.266 ms
 9  216.239.47.167 [AS15169]  6.354 ms * *
10  * * *
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * 8.8.8.8 [AS15169]  4.536 ms *
```

---

6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?

---

Ответ.

```
mtr -z -r -c 10 8.8.8.8
Start: 2021-11-26T15:27:35+0300
HOST: SRV-CTL                     Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    192.168.x.xxx        0.0%    10    0.1   0.1   0.1   0.2   0.0
  2. AS???    192.168.x.xxx      0.0%    10    0.2   0.2   0.1   0.2   0.0
  3. AS199860 78.155.2xx.x         0.0%    10   11.8   1.5   0.3  11.8   3.6
  4. AS199860 185.44.12.70         0.0%    10    0.7   0.6   0.6   0.7   0.0
  5. AS???    109.239.137.237      0.0%    10    1.0   1.5   0.9   6.9   1.9
  6. AS15169  74.125.244.181       0.0%    10    1.1   1.1   1.0   1.3   0.1
  7. AS15169  72.14.232.84         0.0%    10    1.5   1.7   1.3   3.8   0.8
  8. AS15169  216.239.48.163      10.0%    10    4.3   9.8   4.3  46.5  13.8
  9. AS15169  172.253.64.113       0.0%    10    6.2   6.2   6.0   6.6   0.2
 10. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 11. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 12. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 13. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 14. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 15. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 16. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 17. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 18. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 19. AS15169  dns.google          60.0%    10    4.2   4.3   4.2   4.4   0.1
```
*Наибольшая задержка из ответивших хостов у AS15169  216.239.48.163.*

---

7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`

---

Ответ.

*Получаем список NS серверов.*

```
vagrant@vagrant:~$ dig ns dns.google +noall +answer
dns.google.		398	IN	NS	ns3.zdns.google.
dns.google.		398	IN	NS	ns1.zdns.google.
dns.google.		398	IN	NS	ns2.zdns.google.
dns.google.		398	IN	NS	ns4.zdns.google.
vagrant@vagrant:~$
```

*Получаем список А записей.*

```
vagrant@vagrant:~$ dig A dns.google +noall +answer
dns.google.		769	IN	A	8.8.8.8
dns.google.		769	IN	A	8.8.4.4
vagrant@vagrant:~$ 
```

---

8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`

В качестве ответов на вопросы можно приложите лог выполнения команд в консоли или скриншот полученных результатов.

---

Ответ.

```
vagrant@vagrant:~$ dig -x 8.8.8.8 +short
dns.google.
vagrant@vagrant:~$ dig -x 8.8.4.4 +short
dns.google.
vagrant@vagrant:~$ 
```

---

