# Домашнее задание к занятию "09.02 CI\CD"

## Знакомоство с SonarQube

### Подготовка к выполнению

1. Выполняем `docker pull sonarqube:8.7-community`
2. Выполняем `docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:8.7-community`
3. Ждём запуск, смотрим логи через `docker logs -f sonarqube`
4. Проверяем готовность сервиса через [браузер](http://localhost:9000)
5. Заходим под admin\admin, меняем пароль на свой

В целом, в [этой статье](https://docs.sonarqube.org/latest/setup/install-server/) описаны все варианты установки, включая и docker, но так как нам он нужен разово, то достаточно того набора действий, который я указал выше.

---

**Подготовка.**

```bash
vagrant@server1:~/92$ docker pull sonarqube:8.7-community
8.7-community: Pulling from library/sonarqube
22599d3e9e25: Pull complete 
00bb4d95f2aa: Pull complete 
3ef8cf8a60c8: Pull complete 
928990dd1bda: Pull complete 
07cca701c22e: Pull complete 
Digest: sha256:70496f44067bea15514f0a275ee898a7e4a3fedaaa6766e7874d24a39be336dc
Status: Downloaded newer image for sonarqube:8.7-community
docker.io/library/sonarqube:8.7-community
vagrant@server1:~/92$ docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:8.7-community
0d2b06cb71cfde28778eaea434b8f7c2fe69904bdde6068f297dcf8fb44d82d0
vagrant@server1:~/92$
```

---

### Основная часть

1. Создаём новый проект, название произвольное
2. Скачиваем пакет sonar-scanner, который нам предлагает скачать сам sonarqube
3. Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
4. Проверяем `sonar-scanner --version`
5. Запускаем анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`
6. Смотрим результат в интерфейсе
7. Исправляем ошибки, которые он выявил(включая warnings)
8. Запускаем анализатор повторно - проверяем, что QG пройдены успешно
9. Делаем скриншот успешного прохождения анализа, прикладываем к решению ДЗ

---

**Ответ.**

1. Создаем новый проект. `netology-test`  
2. [Sonar-scanner](https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip)  
3. Меняем переменную PATH.

```bash
vagrant@server1:~/92/sonar/bin$ export PATH=$PATH:$(pwd)
```

4. Проверяем `sonar-scanner --version`

```bash
vagrant@server1:~/92$ sonar-scanner --version
INFO: Scanner configuration file: /home/vagrant/92/sonar/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 5.4.0-91-generic amd64
vagrant@server1:~/92$
```

5. Запускаем анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`

```bash
sonar-scanner \
  -Dsonar.projectKey=netology-test \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=beb80f96a5aa5c6043b2bc3a2a1e259fce3c8a74\
  -Dsonar.coverage.exclusions=fail.py

```

6. Наблюдаем ошибки.  
![Ошибки](/09-ci-02-cicd/img/1.png)

7. Исправляем ошибки.

```python
def increment(index):
    return index+1
def get_square(numb):
    return numb*numb
def print_numb(numb):
    print("Number is {}".format(numb))

index = 0
while (index < 10):
    index = increment(index)
    print(get_square(index))
```

8. Запускаем анализатор повторно - проверяем, что QG пройдены успешно.  
9. Делаем скриншот успешного прохождения анализа, прикладываем к решению ДЗ.
![Ошибки](/09-ci-02-cicd/img/2.png) 

---

## Знакомство с Nexus

### Подготовка к выполнению

1. Выполняем `docker pull sonatype/nexus3`
2. Выполняем `docker run -d -p 8081:8081 --name nexus sonatype/nexus3`
3. Ждём запуск, смотрим логи через `docker logs -f nexus`
4. Проверяем готовность сервиса через [бразуер](http://localhost:8081)
5. Узнаём пароль от admin через `docker exec -it nexus /bin/bash`
6. Подключаемся под админом, меняем пароль, сохраняем анонимный доступ

---

**Ответ.**

```bash
bash-4.4$ cat nexus-data/admin.password
f8bb9957-f2d1-4996-a004-e0a0e6ea6a49
bash-4.4$
```
---

### Основная часть

1. В репозиторий `maven-public` загружаем артефакт с GAV параметрами:
   1. groupId: netology
   2. artifactId: java
   3. version: 8_282
   4. classifier: distrib
   5. type: tar.gz
2. В него же загружаем такой же артефакт, но с version: 8_102
3. Проверяем, что все файлы загрузились успешно
4. В ответе присылаем файл `maven-metadata.xml` для этого артефекта

---
![nexus](/09-ci-02-cicd/img/3.png)


![maven-metadata.xml](/09-ci-02-cicd/img/maven-metadata.xml)

### Знакомство с Maven

### Подготовка к выполнению

1. Скачиваем дистрибутив с [maven](https://maven.apache.org/download.cgi)

```bash
vagrant@server1:~/92/mvn$ wget https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
--2022-05-16 19:45:42--  https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
Resolving dlcdn.apache.org (dlcdn.apache.org)... 151.101.2.132, 2a04:4e42::644
Connecting to dlcdn.apache.org (dlcdn.apache.org)|151.101.2.132|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 8673123 (8.3M) [application/x-gzip]
Saving to: ‘apache-maven-3.8.5-bin.tar.gz’

apache-maven-3.8.5-bin.tar.gz   100%[====================================================>]   8.27M  8.59MB/s    in 1.0s    

2022-05-16 19:45:43 (8.59 MB/s) - ‘apache-maven-3.8.5-bin.tar.gz’ saved [8673123/8673123]

vagrant@server1:~/92/mvn$
```

2. Разархивируем, делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)

```bash
vagrant@server1:~/92/mvn/bin$ export PATH=$PATH:$(pwd)
```

3. Проверяем `mvn --version`

```bash
vagrant@server1:~/92/mvn/bin$ mvn --version
Apache Maven 3.8.5 (3599d3414f046de2324203b78ddcf9b5e4388aa0)
Maven home: /home/vagrant/92/mvn
Java version: 11.0.15, vendor: Private Build, runtime: /usr/lib/jvm/java-11-openjdk-amd64
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "5.4.0-91-generic", arch: "amd64", family: "unix"
vagrant@server1:~/92/mvn/bin$
```

4. Забираем директорию [mvn](./mvn) с pom

### Основная часть

1. Меняем в `pom.xml` блок с зависимостями под наш артефакт из первого пункта задания для Nexus (java с версией 8_282)
2. Запускаем команду `mvn package` в директории с `pom.xml`, ожидаем успешного окончания
3. Проверяем директорию `~/.m2/repository/`, находим наш артефакт

```bash
vagrant@server1:~/92$ ls -la ~/.m2/repository/netology/java/8_282/
total 20
drwxrwxr-x 2 vagrant vagrant 4096 May 16 20:13 .
drwxrwxr-x 3 vagrant vagrant 4096 May 16 20:13 ..
-rw-rw-r-- 1 vagrant vagrant    0 May 16 20:13 java-8_282-distrib.tar.gz
-rw-rw-r-- 1 vagrant vagrant   40 May 16 20:13 java-8_282-distrib.tar.gz.sha1
-rw-rw-r-- 1 vagrant vagrant  382 May 16 20:13 java-8_282.pom.lastUpdated
-rw-rw-r-- 1 vagrant vagrant  175 May 16 20:13 _remote.repositories
vagrant@server1:~/92$
```

4. В ответе присылаем исправленный файл `pom.xml`

![pom.xml](/09-ci-02-cicd/mvn/pom.xml)

---


