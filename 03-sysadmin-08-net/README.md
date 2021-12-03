# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```
---

Ответ.

```
route-views>show ip route 78.155.2xx.xx
Routing entry for 78.155.2xx.0/22
  Known via "bgp 6447", distance 20, metric 0
  Tag 3356, type external
  Last update from 4.68.4.46 2w0d ago
  Routing Descriptor Blocks:
  * 4.68.4.46, from 4.68.4.46, 2w0d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 3356
      MPLS label: none
route-views>
```

```
route-views>show bgp 78.155.2xx.xx
BGP routing table entry for 78.155.2xx.0/22, version 1375137498
Paths: (24 available, best #12, table default)
  Not advertised to any peer
  Refresh Epoch 1
  701 1273 3216 3216 3216 20764 199860
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin IGP, localpref 100, valid, external
      path 7FE04B3D0B88 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 1273 3216 3216 3216 20764 199860
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin IGP, localpref 100, valid, external
      Community: 2516:1030 7660:9003
      path 7FE13F718128 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 9002 199860
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE04F949B18 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 3
  3303 9002 199860
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 3303:1004 3303:1007 3303:1030 3303:3067 9002:64667
      path 7FE15D8E54D8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3267 20764 199860
    194.85.40.15 from 194.85.40.15 (185.141.126.1)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE01902B438 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  57866 9002 199860
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 9002:0 9002:64667
      path 7FE13C8FF7A0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 3356 9002 199860
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin IGP, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE154B8B228 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 20764 199860
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      Community: 20764:1322 20764:1332 20764:3002 20764:3010 20764:3021
      path 7FE173CCE450 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 9002 199860
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3257:8052 3257:50001 3257:54900 3257:54901 20912:65004 65535:65284
      path 7FE112D2D648 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  49788 12552 20764 199860
    91.218.184.60 from 91.218.184.60 (91.218.184.60)
      Origin IGP, localpref 100, valid, external
      Community: 12552:12000 12552:12100 12552:12101 12552:22000
      Extended Community: 0x43:100:1
      path 7FE172379628 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  8283 20764 199860
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 8283:1 8283:101 20764:1322 20764:1332 20764:3002 20764:3010 20764:3021
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x18
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001
      path 7FE0B174E728 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 9002 199860
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external, best
      Community: 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067
      path 7FE0B0B62920 RPKI State not found
      rx pathid: 0, tx pathid: 0x0
  Refresh Epoch 1
  2497 3356 9002 199860
    202.232.0.2 from 202.232.0.2 (58.138.96.254)
      Origin IGP, localpref 100, valid, external
      path 7FE121C86CC0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  852 3356 9002 199860
    154.11.12.212 from 154.11.12.212 (96.1.209.43)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE0228A5BA8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1221 4637 9002 199860
    203.62.252.83 from 203.62.252.83 (203.62.252.83)
      Origin IGP, localpref 100, valid, external
      path 7FE04BD233E8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20130 6939 9002 199860
    140.192.8.16 from 140.192.8.16 (140.192.8.16)
      Origin IGP, localpref 100, valid, external
      path 7FE1571C1B38 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  6939 9002 199860
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external
      path 7FE0516AFC20 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3257 9002 199860
    89.149.178.10 from 89.149.178.10 (213.200.83.26)
      Origin IGP, metric 10, localpref 100, valid, external
      Community: 3257:8052 3257:50001 3257:54900 3257:54901 65535:65284
      path 7FE0A3732348 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 9002 199860
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067 3549:2581 3549:30840
      path 7FE0A58789B0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 174 20764 20764 20764 199860
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin IGP, localpref 100, valid, external
      Community: 174:21101 174:22014 53767:5000
      path 7FE0F8950048 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  101 3356 9002 199860
    209.124.176.223 from 209.124.176.223 (209.124.176.223)
      Origin IGP, localpref 100, valid, external
      Community: 101:20100 101:20110 101:22100 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067
      Extended Community: RT:101:22100
      path 7FE14AB1FA10 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3561 3910 3356 9002 199860
    206.24.210.80 from 206.24.210.80 (206.24.210.80)
      Origin IGP, localpref 100, valid, external
      path 7FE0F679E508 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1351 20764 20764 20764 20764 20764 20764 20764 199860
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external
      path 7FE1413625D0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  19214 3257 9002 199860
    208.74.64.40 from 208.74.64.40 (208.74.64.40)
      Origin IGP, localpref 100, valid, external
      Community: 3257:8791 3257:50001 3257:53100 3257:53101 65535:65284
      path 7FE11C735338 RPKI State not found
      rx pathid: 0, tx pathid: 0
route-views>
```

---
2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
---

Ответ.

*Текущая конфигурация.*  
```
vagrant@vagrant:~$ sudo ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
vagrant@vagrant:~$ sudo ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 84264sec preferred_lft 84264sec
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link 
       valid_lft forever preferred_lft forever
vagrant@vagrant:~$ 
```
*Добавляем интерфейс* `dummy0`. *И добавляем статические маршруты.*

```
vagrant@vagrant:~$ sudo ip link add dummy0 type dummy
vagrant@vagrant:~$ sudo ip addr add 192.168.100.1/24 dev dummy0
vagrant@vagrant:~$ sudo ip link set dummy0 up
vagrant@vagrant:~$ sudo ip route add to 192.168.200.0/24 via 192.168.100.1
vagrant@vagrant:~$ sudo ip route add to 192.168.210.0/24 via 192.168.100.1
vagrant@vagrant:~$
```

*Проверяем таблицу маршрутизации*

```
vagrant@vagrant:~$ ip route
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100 
192.168.100.0/24 dev dummy0 proto kernel scope link src 192.168.100.1 
192.168.200.0/24 via 192.168.100.1 dev dummy0 
192.168.210.0/24 via 192.168.100.1 dev dummy0 
vagrant@vagrant:~$
```

---
3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
---

Ответ.

```
agrant@vagrant:~$ sudo ss -nlpt
State   Recv-Q  Send-Q    Local Address:Port     Peer Address:Port  Process                                                    
LISTEN  0       4096            0.0.0.0:111           0.0.0.0:*      users:(("rpcbind",pid=572,fd=4),("systemd",pid=1,fd=35))  
LISTEN  0       4096      127.0.0.53%lo:53            0.0.0.0:*      users:(("systemd-resolve",pid=573,fd=13))                 
LISTEN  0       128             0.0.0.0:22            0.0.0.0:*      users:(("sshd",pid=760,fd=3))                             
LISTEN  0       4096               [::]:111              [::]:*      users:(("rpcbind",pid=572,fd=6),("systemd",pid=1,fd=37))  
LISTEN  0       128                [::]:22               [::]:*      users:(("sshd",pid=760,fd=4))                             
vagrant@vagrant:~$ 
```

*Port 111 - RPC Portmapper служит для обеспечения сервисов Remote Procedure Call, таких как NIS и NFS.*  
*Port 53 - используется DNS. Сервис systemd-resolve.*  
*Port 22 - использует sshd.*  

---
4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
---

Ответ.

```
vagrant@vagrant:~$ sudo ss -nlpu
State   Recv-Q  Send-Q    Local Address:Port     Peer Address:Port  Process                                                    
UNCONN  0       0         127.0.0.53%lo:53            0.0.0.0:*      users:(("systemd-resolve",pid=573,fd=12))                 
UNCONN  0       0        10.0.2.15%eth0:68            0.0.0.0:*      users:(("systemd-network",pid=399,fd=19))                 
UNCONN  0       0               0.0.0.0:111           0.0.0.0:*      users:(("rpcbind",pid=572,fd=5),("systemd",pid=1,fd=36))  
UNCONN  0       0                  [::]:111              [::]:*      users:(("rpcbind",pid=572,fd=7),("systemd",pid=1,fd=38))  
vagrant@vagrant:~$
```

*Port 68 - используется DHCP.*

---
5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 
---

Ответ.

![Моя сеть](03-sysadmin-08-net/img/1.png)

---

