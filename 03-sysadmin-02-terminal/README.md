# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"


***1.** Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.*

```
vagrant@vagrant:~/test$ type cd
cd is a shell builtin
```
Командная оболочка предоставляет небольшой набор встроенных команд, которые невозможно или неудобно реализовывать с помощью отдельных утилит. Так , например, cd, break, continue и exec не могут быть реализованы вне оболочки, так как они непосредственно манипулируют самой оболочкой.


***2.** Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.*

Согласно man grep

```
grep -c <some_string> <some_file>
```


***3.** Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?*

```
agrant@vagrant:~/test$ ps -p 1
    PID TTY          TIME CMD
      1 ?        00:00:01 systemd
vagrant@vagrant:~/test$ ps -F -p 1
UID          PID    PPID  C    SZ   RSS PSR STIME TTY          TIME CMD
root           1       0  0 25419 11336   0 Nov14 ?        00:00:01 /sbin/init
vagrant@vagrant:~/test$
```
Родителем является `systemd`. 


***4.** Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?*

```
ls not-exists-dir 2>/dev/pts/1
```


***5.** Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.*

```
vagrant@vagrant:~/test$ echo "hello world" > file.input
vagrant@vagrant:~/test$ cat < ./file.input > file.output
vagrant@vagrant:~/test$ cat file.output
hello world
vagrant@vagrant:~/test$
```


***6.** Получится ли вывести находясь в графическом режиме данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?*

Подключаемся к PTY (pseudo-teletype) через ssh и запускаем TTY (teletype) из консоли самого VirtualBox, к нашей виртуальной машине, созданной vagrant.
 
```
vagrant@vagrant:~/test$ who am i
vagrant  pts/0        2021-11-14 21:32 (10.0.2.2)
vagrant@vagrant:~/test$ echo "hello world from /pts/0" > /dev/tty2
vagrant@vagrant:~/test$
```

```
vagrant@vagrant:~$ who am i
vagrant  tty2        2021-11-15 03:14
vagrant@vagrant:~$ hello world from /pts/0
```


***7.** Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?*

```
vagrant@vagrant:~/test$ bash 5>&1
vagrant@vagrant:~/test$ echo netology > /proc/$$/fd/5
netology
vagrant@vagrant:~/test$ 
```
Команда `bash 5>&1` запускает командную оболочку с перенаправлением потока для файлового дескриптора №5 в стандартный поток вывода.

Переменная $$  сохраняет PID текущей оболочки.

Команда `echo netology > /proc/$$/fd/5` записывает слово netology в поток вывода с дескриптором №5. Который оказывается связан с потоком вывода командной оболочки первой командой. 


***8.** Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.*

```
agrant@vagrant:~/test$ who am i
vagrant  pts/0        2021-11-14 21:32 (10.0.2.2)
vagrant@vagrant:~/test$ ls /var /not-exists-dir 2>&1 1>/dev/pts/0 | cat > error.log
/var:
backups  cache  crash  lib  local  lock  log  mail  opt  run  snap  spool  tmp
vagrant@vagrant:~/test$ cat error.log
ls: cannot access '/not-exists-dir': No such file or directory
vagrant@vagrant:~/test$ 
```


***9.** Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?*

Команда выведет список переменных окружения текущей оболочки.
Похожее можно получить командой `printenv`

***10.** Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.*

```
/proc/[pid]/cmdline
Этот файл только для чтения, содержит полную командную строку запуска процесса, кроме тех процессов, что полностью ушли в своппинг, а также тех, что превратились  в зомби. В этих двух случаях в файле ничего нет, то есть чтение этого файла вернет 0 символов. Аргументы командной строки в этом файле указаны как список строк, каждая из которых завешается нулевым символом, с добавочным нулевым байтом после последней строки. 
```
```
/proc/[pid]/exe
Под Linux 2.2 и более позних является символьной ссылкой, содержащей фактическое полное имя выполняемого файла. Символьная ссылка exe может использоваться обычным образом - при попытке открыть exe будет открыт исполняемый файл. Вы можете даже ввести /proc/[number]/exe чтобы запустить другую копию процесса такого же как и процесс с номером [число]. 
              Under  Linux  2.2  and  later,  this  file is a symbolic link containing the actual pathname of the executed command.  This symbolic link can be
              dereferenced normally; attempting to open it will open the executable.  You can even type /proc/[pid]/exe to run another copy of the  same  exe‐
              cutable  that  is being run by process [pid].  If the pathname has been unlinked, the symbolic link will contain the string '(deleted)' appended
              to the original pathname.  In a multithreaded process, the contents of this symbolic link are not available if the main thread has already  ter‐
              minated (typically by calling pthread_exit(3)).
```

***11.** Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью* `/proc/cpuinfo`.

```
vagrant@vagrant:~/test$ cat /proc/cpuinfo | grep sse
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase avx2 invpcid rdseed clflushopt md_clear flush_l1d
```
Старшая версия `sse4_2`. А так же есть поддержка более нового набора SIMD инструкций - `AVX`.

***12.** При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:*

    ```bash
	vagrant@netology1:~$ ssh localhost 'tty'
	not a tty
    ```

*Почитайте, почему так происходит, и как изменить поведение.*

Проверяем

```	
vagrant@vagrant:~/test$ ssh localhost "tty"
vagrant@localhost's password: 
not a tty
```

Исправляем поведение.

```
vagrant@vagrant:~/test$ ssh -t localhost "tty"
vagrant@localhost's password: 
/dev/pts/1
Connection to localhost closed.
vagrant@vagrant:~/test$ 
```

По умолчанию, если мы передаем команду на удаленный компьютер через ssh, то tty не назначается для удаленной сессии. Т.к. ожидается передача бинарных данных. Принудительно это поведение изменяется ключом `-t`. 

***13.** Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.*

Устанавливаем `reptyr`

```
sudo apt install reptyr
```
Согласно [документации](https://github.com/nelhage/reptyr), вносим исправления.

```
sudo echo 0 > /proc/sys/kernel/yama/ptrace_scope
```
Теперь можно использовать.

```
vagrant@vagrant:~$ who am i
vagrant  pts/3        2021-11-15 15:28 (10.0.2.2)
vagrant@vagrant:~$ ps u
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
vagrant     1679  0.0  0.4   9836  4096 pts/3    Ss   15:28   0:00 -bash
vagrant     1748  0.0  0.3   9836  4008 pts/1    Ss+  15:30   0:00 -bash
vagrant     1778  0.0  0.3  11492  3312 pts/3    R+   15:32   0:00 ps u
vagrant@vagrant:~$ sudo reptyr -T 1748
who am i
vagrant  pts/1        2021-11-15 15:30 (10.0.2.2)
vagrant@vagrant:~$ 
vagrant@vagrant:~$ ps u
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
vagrant     1679  0.0  0.4   9836  4096 pts/3    Ss   15:28   0:00 -bash
vagrant     1748  0.0  0.3   9840  4012 pts/1    Ss   15:30   0:00 -bash
vagrant     1841  0.0  0.3  11492  3252 pts/1    R+   15:39   0:00 ps u
vagrant@vagrant:~$ 
```


***14.** `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.*

Команда `tee` принимает данные из одного источника и может сохранять их на выходе в нескольких местах.

```
agrant@vagrant:~$ type echo
echo is a shell builtin
vagrant@vagrant:~$ type tee
tee is /usr/bin/tee
vagrant@vagrant:~$
```
Команда `echo` является встроенной командой оболочки, а перенаправлением стандартного вывода управляет сама оболочка.

Команда `tee` является самостоятельной командой. И по этому возможно делать перенаправление стандартных потоков для этой команды.


