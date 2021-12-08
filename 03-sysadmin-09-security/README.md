# Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"

1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.
---

Ответ.

![Результат](/03-sysadmin-09-security/img/hw39-1.jpg)

---
2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.
---

Ответ.

*Работает. Но экран смартфона запрещает демонстрировать внутренняя безопасность.*

---
3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.
---

Ответ.


*Добавляем перенаправление порттов для нашей виртуальной машины в vagrant файле.*  
```
config.vm.network "forwarded_port", guest: 443, host: 1443
```

*Устанавливаем и настраиваем сам appache.*  

```
vagrant@vagrant:~$ sudo apt update
<Skip>
vagrant@vagrant:~$ sudo apt install appache2
<Skip>
vagrant@vagrant:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=RU/ST=Example/L=Example/O=vagrant/OU=vm/CN=www.vagrant.vm"
Generating a RSA private key
................................+++++
.............................................+++++
writing new private key to '/etc/ssl/private/apache-selfsigned.key'
-----
vagrant@vagrant:~$ 
```
```
sudo mkdir /var/www/www.vagrant.vm
```
```
vagrant@vagrant:~$ sudo -i
root@vagrant:~# echo "<VirtualHost *:443>
   ServerName www.vagrant.vm
   DocumentRoot /var/www/www.vagrant.vm

   SSLEngine on
   SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
   SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>
" > /etc/apache2/sites-available/www.vagrant.vm.conf
root@vagrant:~# sudo echo "<h1>It worked.</h1>" > /var/www/www.vagrant.vm/index.html
root@vagrant:~# exit
logout
vagrant@vagrant:~$
```
```
vagrant@vagrant:~$ sudo a2enmod ssl
<Skip>
vagrant@vagrant:~$ sudo a2ensite www.vagrant.vm.conf
Enabling site www.vagrant.vm.
To activate the new configuration, you need to run:
  systemctl reload apache2
vagrant@vagrant:~$ sudo apache2ctl configtest
Syntax OK
vagrant@vagrant:~$ sudo systemctl restart apache2
vagrant@vagrant:~$
```

![Наш сервер](/03-sysadmin-09-security/img/hw39-2.png)  

---
4. Проверьте на TLS уязвимости произвольный сайт в интернете.
---

Ответ.

```
vagrant@vagrant:~/soft/testssl.sh$ ./testssl.sh -U --sneaky https://www.brunoromani.ru

###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/
    (f6571c7 2021-11-30 11:19:44 -- )

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
 on vagrant:./bin/openssl.Linux.x86_64
 (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")


 Start 2021-12-08 09:12:51        -->> 78.155.212.84:443 (www.brunoromani.ru) <<--

 rDNS (78.155.212.84):   --
 Service detected:       HTTP


 Testing vulnerabilities 

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=D296A60E974EE34172A6D7492FCFC292A9DD89B1D003EEFB94B2B57EE6056464 could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no common prime detected
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES128-SHA ECDHE-RSA-AES256-SHA DHE-RSA-AES128-SHA
                                                 DHE-RSA-AES256-SHA AES128-SHA AES256-SHA DHE-RSA-CAMELLIA256-SHA
                                                 DHE-RSA-CAMELLIA128-SHA CAMELLIA256-SHA CAMELLIA128-SHA 
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2021-12-08 09:13:28 [  39s] -->> 78.155.212.84:443 (www.brunoromani.ru) <<--


vagrant@vagrant:~/soft/testssl.sh$ 

```

---
5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
 ---

Ответ.

*Генерируем ключ.*   

```
vagrant@vagrant:~$ ssh-keygen -o -a 100 -t ed25519
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_ed25519): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/vagrant/.ssh/id_ed25519
Your public key has been saved in /home/vagrant/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:fTo8RI8mC4ieBl6DTRZAUKHntKzP56cZfVif0ba4nMA vagrant@vagrant
The key's randomart image is:
+--[ED25519 256]--+
|+++o             |
| .  .            |
|. oo      .      |
| ==o .   o +     |
|..=+. . S * =    |
|.+.... = B B .   |
|..+ . o E O .    |
| +  .o.. o =     |
|  oo+o    +      |
+----[SHA256]-----+
vagrant@vagrant:~$ cat .ssh/id_ed25519.pub >> .ssh/authorized_keys
```

*Подключаемся по новому ключу.*

```
vagrant@vagrant:~$ ssh 127.0.0.1 -i .ssh/id_ed25519
The authenticity of host '127.0.0.1 (127.0.0.1)' can't be established.
ECDSA key fingerprint is SHA256:wSHl+h4vAtTT7mbkj2lbGyxWXWTUf6VUliwpncjwLPM.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '127.0.0.1' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
<Skip>
vagrant@vagrant:~$
```

---
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.
---

Ответ.

```
vagrant@vagrant:~$ mv .ssh/id_ed25519 .ssh/ed25519_vagrant
vagrant@vagrant:~$ echo "Host vagrant
HostName vagrant
IdentityFile ~/.ssh/ed25519_vagrant
User vagrant
" > .ssh/config

```
```
vagrant@vagrant:~$ ssh vagrant
The authenticity of host 'vagrant (127.0.1.1)' can't be established.
ECDSA key fingerprint is SHA256:wSHl+h4vAtTT7mbkj2lbGyxWXWTUf6VUliwpncjwLPM.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'vagrant' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
<Skip>
vagrant@vagrant:~$
```

---
7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.
---

Ответ.

```
vagrant@vagrant:~$ sudo tcpdump -c 100 -w file.pcap
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
123 packets received by filter
0 packets dropped by kernel
vagrant@vagrant:~$
```

![Wireshark](/03-sysadmin-09-security/img/hw39-3.png)

---

