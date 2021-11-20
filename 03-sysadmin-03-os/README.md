# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`.
---

Ответ:

```
vagrant@vagrant:~$ strace /bin/bash -c "cd /tmp"
<skip>
chdir("/tmp")
<skip>
```
---

1. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.
---

Ответ:

```
vagrant@vagrant:~$ strace file /dev/tty
<skip>
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
<skip>

```

*Остальные попытки неудачны из-за отсутствия файлов.*

*Это соответствует man file.*

---
    
1. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

---

Ответ:

```
agrant@vagrant:~$ who am i
vagrant  pts/0        2021-11-20 19:53 (10.0.2.2)
vagrant@vagrant:~$ cat > /tmp/1.tmp
qwerty
^Z
[1]+  Stopped                 cat > /tmp/1.tmp
vagrant@vagrant:~$ cat >> /tmp/1.tmp
123
```

```
vagrant@vagrant:~$ ps u | grep cat
vagrant     1102  0.0  0.0   8220   592 pts/1    S+   20:58   0:00 cat
vagrant     1107  0.0  0.0   8900   672 pts/0    S+   20:58   0:00 grep --color=auto cat
vagrant@vagrant:~$ lsof -p 1102
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
<skip>
cat     1102 vagrant    1w   REG  253,0        7 3670028 /tmp/1.tmp
<skip>
vagrant@vagrant:~$ rm /tmp/1.tmp
vagrant@vagrant:~$ lsof -p 1102
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
<skip>
cat     1102 vagrant    1w   REG  253,0        7 3670028 /tmp/1.tmp (deleted)
<skip>
vagrant@vagrant:~$ cp /dev/null /proc/1102/fd/1
vagrant@vagrant:~$ lsof -p 1102
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
<skip>
cat     1102 vagrant    1w   REG  253,0        0 3670028 /tmp/1.tmp (deleted)
<skip>
vagrant@vagrant:~$

```
*Тем самым мы обнулили файл удаленный, но открытый на запись файл*  `/tmp/1.tmp`

---

1. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

---
Ответ:

*Зомби процессы занимают только место в таблице процессов.*

---

1. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).
---

Ответ:

```
vagrant@vagrant:~$ sudo /usr/sbin/opensnoop-bpfcc -d 1
PID    COMM               FD ERR PATH
771    vminfo              4   0 /var/run/utmp
582    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
582    dbus-daemon        18   0 /usr/share/dbus-1/system-services
582    dbus-daemon        -1   2 /lib/dbus-1/system-services
582    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
vagrant@vagrant:~$ 
```

---
1. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
---

Ответ:

```
vagrant@vagrant:~$ strace uname -a
<skip>
uname({sysname="Linux", nodename="vagrant", ...}) = 0
<skip>
```
*Из man:*

```
Part of the utsname information is also accessible  via  /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.

```

---
1. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?
---

Ответ:

*`;` - разделитель последовательности команд.*

*`&&` - условный оператор, продолжающий последовательность команд, при удачном выполнении предидущей команды.*

*`set -e` - командная оболочка завершит свою работу если список команд завершится с ненулевым кодом выполнения*

*При необходимости контроля выполнения каждой команды в последновательности имеет смысл использовать* `&&`


---
1. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
---

Ответ:

*-e завершить выполнение командной оболочки, если последняя команда в *pipeline* завершится с ненулевым кодом выполнения*

*-u овыводить сообщение об ошибке каждый раз, когда используется не объявленная ранее переменная.*

*-x вывод трейса простых команд*

*-o pipefail возвращает код возврата набора/последовательности команд, ненулевой при последней команды или 0 для успешного выполнения команд.*

*Режим подойдет для отладки сценариев.*

---
1. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными). 
---

Ответ:

```
vagrant@vagrant:~$ ps -o stat
STAT
Ss
R+
vagrant@vagrant:~$ 
```
*S - процессы в состоянии сна*

*R - запущенные процессы*

 
