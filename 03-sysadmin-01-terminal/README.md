# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"

***5.** Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?*

Vagrant выдал следующие ресурсы:

 - 2 vCPU   
 - 1 GB RAM
 - 64 GB  VMDK Sata storage
 - 1 LAN Intel PRO/1000 MT Desktop (NAT)
 - 1 VBoxVGA 4 MB
 

***6.** Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: документация. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?*

Согласно представленной документации по [vagrant](https://www.vagrantup.com/docs/providers/virtualbox/configuration),
```
config.vm.provider "virtualbox" do |v|
  v.memory = 1024
  v.cpus = 2
end
```


***8.** Ознакомиться с разделами man bash, почитать о настройках самого bash:*
*какой переменной можно задать длину журнала `history` , и на какой строчке manual это описывается?* 

HISTSIZE

Строка 1053-1058

*что делает директива* `ignoreboth` *в bash?*

ignoreboth - это сокращение включающее в себя:
- ignorespace (не запоминать в истории строки, начинающиеся на пробел)
- ignoredups (не запоминать дубли строк, которые уже есть в истории)


***9.** В каких сценариях использования применимы скобки* `{}` *и на какой строчке* `man bash` *это описано?*

```
      { list; }
              list  is simply executed in the current shell environment.  list must be
              terminated with a newline or semicolon.  This is known as a  group  com‐
              mand.   The  return status is the exit status of list.  Note that unlike
              the metacharacters ( and ), { and } are reserved words  and  must  occur
              where  a reserved word is permitted to be recognized.  Since they do not
              cause a word break, they must be separated from list  by  whitespace  or
              another shell metacharacter.
```
строки 284-291
Список исполняется в текущем окружении командной оболочки. Это групповая команда. Взвращает код возврата последней команды из списка. 

***10.** Основываясь на предыдущем вопросе, как создать однократным вызовом*  `touch` *100000 файлов? А получилось ли создать 300000? Если нет, то почему?*

Создаем 100000 файлов
```
touch {1..100000}.tmp; echo $?
0
```

Пытаемся создать 300000 файлов
```
touch {1..300000}.tmp; echo $?
-bash: /usr/bin/touch: Argument list too long
126
```
Ошибка происходит из-за слишком большого количества аргументов переданных bash. Размер буфера задается ситемной переменной `ARG_MAX`. Текущий размер 2MB.


***11.** В man bash поищите по* `/\[\[` *. Что делает конструкция* `[[ -d /tmp ]]` *?*

Конструкция `[[ -d /tmp ]]` возвращает "0" если каталог `/tmp` существует.


***12.** Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:*

```
bash is /tmp/new_path_directory/bash
bash is /usr/local/bin/bash
bash is /bin/bash
```

*(прочие строки могут отличаться содержимым и порядком) В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.*

```
vagrant@vagrant:~/test$ type -a bash
bash is /usr/bin/bash
bash is /bin/bash
agrant@vagrant:~/test$ mkdir /tmp/new_path_directory
vagrant@vagrant:~/test$ ln -s /bin/bash /tmp/new_path_directory/bash
vagrant@vagrant:~/test$ export PATH=/tmp/new_path_directory:$PATH
vagrant@vagrant:~/test$ type -a bash
bash is /tmp/new_path_directory/bash
bash is /usr/bin/bash
bash is /bin/bash
vagrant@vagrant:~/test$
```


***13.** Чем отличается планирование команд с помощью*  `batch` *и*  `at` *?*

- `batch` - выполнит задачу при определенном уровне загрузки системы.
- `at` - выполняет задачу в указанное время.


