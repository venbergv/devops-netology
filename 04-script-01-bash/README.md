
# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательные задания

1. Есть скрипт:
	```bash
	a=1
	b=2
	c=a+b
	d=$a+$b
	e=$(($a+$b))
	```
	* Какие значения переменным c,d,e будут присвоены?
	* Почему?

---

Ответ.

```
vagrant@vagrant:~$ a=1
vagrant@vagrant:~$ b=2
vagrant@vagrant:~$ c=a+b
vagrant@vagrant:~$ d=$a+$b
vagrant@vagrant:~$ e=$(($a+$b))
```
```
vagrant@vagrant:~$ echo $a
1
vagrant@vagrant:~$ echo $b
2
```
```
vagrant@vagrant:~$ echo $c
a+b
```

*Строка текста.*  

```
vagrant@vagrant:~$ echo $d
1+2
```

*Строка текста из строковых переменных $a и $b.*  

```
vagrant@vagrant:~$ echo $e
3
```

*В круглых скобках интерпретатор преобразовал значения из переменных $a и $b в числовые значения и произвел с ними операцию сложения.*  

---
2. На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
	```bash
	while ((1==1)
	do
	curl https://localhost:4757
	if (($? != 0))
	then
	date >> curl.log
	fi
	done
	```
---

Ответ.

*В первой строке ошибка. Нехватает закрывающей скобки у логического выражения.*  
*В самом скрипте нет условия прекаращения работы скрипта.*  
*Для избежания переполнения диска логичным будет ограничить повтор проверки, например один раз в 10 секунд.*

```bash
#!/usr/bin/env bash
while ((1==1))
do
  curl https://localhost:4757
  if (($? != 0))
  then
    date >> curl.log
  elthe
    break
  fi
  sleep 10
done
```
---
3. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.
---

Ответ.

```bash
#!/usr/bin/env bash
echo "Start check hosts" > chk_host.log
date >> chk_host.log
array_hosts=(192.168.0.1 173.194.222.113 87.250.250.24)
timeout=3
for h in ${array_hosts[@]}
do
  for i in {1..5}
  do
    curl -s --connect-timeout $timeout $h:80 >/dev/null
    if (($? != 0))
      then
        echo "Host" $h "Failed" "status" $? >> chk_host.log
      else
        echo "Host" $h "Sucsess" "status" $? >> chk_host.log
      fi
  done
done
```

---
4. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается
---

Ответ.

```bash
#!/usr/bin/env bash
array_hosts=(192.168.0.1 173.194.222.113 87.250.250.24)
timeout=3
while ((1==1))
do
  for h in ${array_hosts[@]}
  do
    curl -s --connect-timeout $timeout $h:80 >/dev/null
    if (($? != 0))
      then
        echo "Host" $h "Failed" "status" $? > error
        exit 1
      fi
  done
done
```

---