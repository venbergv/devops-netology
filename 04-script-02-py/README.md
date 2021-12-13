### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md). Заполните недостающие части документа решением задач и отправляйте на проверку.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | будет ошибка.`TypeError` |
| Как получить для переменной `c` значение 12?  | `c=str(a)+b` |
| Как получить для переменной `c` значение 3?  | `c=a+int(b)` |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

"""Check modififed git file."""

import os

path_var = '~/netology/sysadm-homeworks'
bash_command = ["cd "+path_var, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
# is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path_var+'/'+prepare_result)
#        break
```

### Вывод скрипта при запуске при тестировании:
```bash
vagrant@vagrant:/vagrant/script/4.2$ python3 script2.py
~/netology/sysadm-homeworks/proj1/readme.md
~/netology/sysadm-homeworks/proj2/readme.md
vagrant@vagrant:/vagrant/script/4.2$ 
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

"""Check modififed git file."""

import os
import sys

if len(sys.argv)>=2:
    path_var = sys.argv[1]
    chk_git = os.path.exists(f'{path_var}/.git')
    if chk_git is not True:
        raise SystemExit(path_var+' - It\'s not git path' )
    print('Search modified files in path: '+path_var)
else:
    path_var = '~/netology/sysadm-homeworks'
    print('Search modified files in Local path: '+path_var)
bash_command = ["cd "+path_var, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path_var+'/'+prepare_result)
```
*Сделаем тестовые каталоги.*  
```bash
vagrant@vagrant:~/netology/sysadm-homeworks2$ 
vagrant@vagrant:~/netology/other-homeworks$ ll
total 12
drwxrwxr-x 3 vagrant vagrant 4096 Dec 13 13:16 ./
drwxrwxr-x 5 vagrant vagrant 4096 Dec 13 13:16 ../
drwxrwxr-x 7 vagrant vagrant 4096 Dec 13 13:16 .git/
vagrant@vagrant:~/netology/other-homeworks$ cd ../sysadm-homeworks
vagrant@vagrant:~/netology/sysadm-homeworks$ ll
total 20
drwxrwxr-x 5 vagrant vagrant 4096 Dec 12 14:38 ./
drwxrwxr-x 5 vagrant vagrant 4096 Dec 13 13:16 ../
drwxrwxr-x 8 vagrant vagrant 4096 Dec 13 13:09 .git/
drwxrwxr-x 2 vagrant vagrant 4096 Dec 12 14:55 proj1/
drwxrwxr-x 2 vagrant vagrant 4096 Dec 12 14:55 proj2/
vagrant@vagrant:~/netology/sysadm-homeworks$ cd ../sysadm-homeworks2
vagrant@vagrant:~/netology/sysadm-homeworks2$ ll
total 8
drwxrwxr-x 2 vagrant vagrant 4096 Dec 13 13:20 ./
drwxrwxr-x 5 vagrant vagrant 4096 Dec 13 13:16 ../
vagrant@vagrant:~/netology/sysadm-homeworks2$ 
```

### Вывод скрипта при запуске при тестировании:

```bash
vagrant@vagrant:~/netology/sysadm-homeworks2$ 
vagrant@vagrant:/vagrant/script/4.2$ python3 script3.py
Search modified files in Local path: ~/netology/sysadm-homeworks
~/netology/sysadm-homeworks/proj1/readme.md
~/netology/sysadm-homeworks/proj2/readme.md
vagrant@vagrant:/vagrant/script/4.2$ python3 script3.py ~/netology/other-homeworks
Search modified files in path: /home/vagrant/netology/other-homeworks
vagrant@vagrant:/vagrant/script/4.2$ python3 script3.py ~/netology/sysadm-homeworks
Search modified files in path: /home/vagrant/netology/sysadm-homeworks
/home/vagrant/netology/sysadm-homeworks/proj1/readme.md
/home/vagrant/netology/sysadm-homeworks/proj2/readme.md
vagrant@vagrant:/vagrant/script/4.2$ python3 script3.py ~/netology/sysadm-homeworks2
/home/vagrant/netology/sysadm-homeworks2 - It's not git path
vagrant@vagrant:/vagrant/script/4.2$
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
##!/usr/bin/env python3
"""Check ip"""

import socket
import time

WAIT = 10

srv = {
    'drive.google.com':'0.0.0.0',
    'mail.google.com':'0.0.0.0',
    'google.com':'0.0.0.0'
    }

while True:
    for srv_name, srv_ip  in srv.items():
        chk_ip = socket.gethostbyname(srv_name)
        if chk_ip != srv_ip:
            print(f'[ERROR] {srv_name} IP mismatch: {srv_ip} New IP: {chk_ip}')
            srv[srv_name] = chk_ip
        else:
            print(f'{srv_name} - {srv_ip}')
        time.sleep(WAIT)
```

### Вывод скрипта при запуске при тестировании:
```bash
vagrant@vagrant:/vagrant/script/4.2$ python3 script4.py
[ERROR] drive.google.com IP mismatch: 0.0.0.0 New IP: 64.233.165.194
[ERROR] mail.google.com IP mismatch: 0.0.0.0 New IP: 209.85.233.18
[ERROR] google.com IP mismatch: 0.0.0.0 New IP: 74.125.131.102
drive.google.com - 64.233.165.194
mail.google.com - 209.85.233.18
[ERROR] google.com IP mismatch: 74.125.131.102 New IP: 74.125.131.113
drive.google.com - 64.233.165.194
mail.google.com - 209.85.233.18
google.com - 74.125.131.113
<Skip>
```


