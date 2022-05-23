# Домашнее задание к занятию "09.03 Jenkins"

## Подготовка к выполнению

1. Установить jenkins по любой из [инструкций](https://www.jenkins.io/download/)

---

**Ставим jenkins.**

```bash
root@server2:/home/vagrant# java --version
openjdk 11.0.15 2022-04-19
OpenJDK Runtime Environment (build 11.0.15+10-Ubuntu-0ubuntu0.20.04.1)
OpenJDK 64-Bit Server VM (build 11.0.15+10-Ubuntu-0ubuntu0.20.04.1, mixed mode, sharing)
root@server2:/home/vagrant# systemctl status jenkins
● jenkins.service - Jenkins Continuous Integration Server
     Loaded: loaded (/lib/systemd/system/jenkins.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2022-05-21 19:48:26 UTC; 2min 3s ago
   Main PID: 16860 (java)
      Tasks: 42 (limit: 2279)
     Memory: 720.2M
     CGroup: /system.slice/jenkins.service
             └─16860 /usr/bin/java -Djava.awt.headless=true -jar /usr/share/java/jenkins.war --webroot=/var/cache/jenkins/war --httpPort=8080

May 21 19:48:02 server2 jenkins[16860]: This may also be found at: /var/lib/jenkins/secrets/initialAdminPassword
May 21 19:48:02 server2 jenkins[16860]: *************************************************************
May 21 19:48:02 server2 jenkins[16860]: *************************************************************
May 21 19:48:02 server2 jenkins[16860]: *************************************************************
May 21 19:48:26 server2 jenkins[16860]: 2022-05-21 19:48:26.174+0000 [id=28]        INFO        jenkins.InitReactorRunner$1#onAttained: Completed initialization
May 21 19:48:26 server2 jenkins[16860]: 2022-05-21 19:48:26.195+0000 [id=22]        INFO        hudson.lifecycle.Lifecycle#onReady: Jenkins is fully up and running
May 21 19:48:26 server2 systemd[1]: Started Jenkins Continuous Integration Server.
May 21 19:48:27 server2 jenkins[16860]: 2022-05-21 19:48:27.094+0000 [id=45]        INFO        h.m.DownloadService$Downloadable#load: Obtained the updated data file for hudson.task>
May 21 19:48:27 server2 jenkins[16860]: 2022-05-21 19:48:27.100+0000 [id=45]        INFO        hudson.util.Retrier#start: Performed the action check updates server successfully at >
May 21 19:48:27 server2 jenkins[16860]: 2022-05-21 19:48:27.107+0000 [id=45]        INFO        hudson.model.AsyncPeriodicWork#lambda$doRun$1: Finished Download metadata. 24,906 ms

root@server2:/home/vagrant#
```

---

2. Запустить и проверить работоспособность

---

![Работоспособность Jenkins](/09-ci-03-jenkins/img/1.png)

---

3. Сделать первоначальную настройку
4. Настроить под свои нужды
5. Поднять отдельный cloud

---

```bash
vagrant@server2:~$ chmod 777 /var/run/docker.sock
```

![Мой Cloud](/09-ci-03-jenkins/img/2.png)

---

6. Для динамических агентов можно использовать [образ](https://hub.docker.com/repository/docker/aragast/agent)

---

```bash
vagrant@server2:~$ docker pull aragast/agent:7
7: Pulling from aragast/agent
ab5ef0e58194: Pull complete 
1e72a26aff50: Pull complete 
f77543c42f4c: Pull complete 
7422d683f4c6: Pull complete 
e71ed7ae47d2: Pull complete 
Digest: sha256:ebf0a78bcb580c8497efdc256c8b9a9b8293e50adc1e05a7549e7d861c93edf8
Status: Downloaded newer image for aragast/agent:7
docker.io/aragast/agent:7
vagrant@server2:~$
```

---

7. Обязательный параметр: поставить label для динамических агентов: `ansible_docker`

---

![Настройка динамических агентов](/09-ci-03-jenkins/img/3.png)

---

8.  Сделать форк репозитория с [playbook](https://github.com/aragastmatb/example-playbook)

---

Проведя более 10 часов, в попытках получить рабочую сборку и сделав более 20 нерабочих сборок, решил отказаться от использования 'secret' и 'ansible-vault. Т.к. ДЗ все же не об ключах git и умении их пропихивать в готовый docker образ.

**Изменил `requirements.yml`:**

```bash
---
  - src: https://github.com/netology-code/mnt-homeworks-ansible.git
    scm: git
    version: "1.0.1"
    name: java 
    #key_file: ./secret
```

---

## Основная часть

1. Сделать Freestyle Job, который будет запускать `ansible-playbook` из форка репозитория

---

```bash
ansible-galaxy role install -p roles/ -r requirements.yml java
ansible-playbook site.yml -i inventory/prod.yml
```

**Из консоли сборки.**

![Консоль сборки](/09-ci-03-jenkins/img/4.png)

---

2. Сделать Declarative Pipeline, который будет выкачивать репозиторий с плейбукой и запускать её

---

**Мой `pipeline script`.**

```bash
pipeline {
    agent {
        node {
            label 'ansible_docker'
            }
        }
    stages {
        stage('Get code from GitHub') {
            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/venbergv/example-playbook.git'
            }
        }
        stage('Run ansible') {
            steps {
                sh 'ansible-galaxy install -p $WORKSPACE -r requirements.yml'
                sh 'ansible-playbook $WORKSPACE/site.yml -i $WORKSPACE/inventory/prod.yml'
            }
        }
    }
}
```

**Вывод на консоль.**

```
Started by user admin
[Pipeline] Start of Pipeline
[Pipeline] node
Running on ansible_docker-0000l891w6puq on docker in /workspace/Declarative-Pipeline-Netology-2
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Get code from GitHub)
[Pipeline] git
The recommended git tool is: NONE
No credentials specified
Cloning the remote Git repository
Cloning repository https://github.com/venbergv/example-playbook.git
 > git init /workspace/Declarative-Pipeline-Netology-2 # timeout=10
Fetching upstream changes from https://github.com/venbergv/example-playbook.git
 > git --version # timeout=10
 > git --version # 'git version 1.8.3.1'
 > git fetch --tags --progress https://github.com/venbergv/example-playbook.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Avoid second fetch
Checking out Revision 0f9852fc1cdc40c457e63d9bcab84579fce5a2b9 (refs/remotes/origin/master)
 > git config remote.origin.url https://github.com/venbergv/example-playbook.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 0f9852fc1cdc40c457e63d9bcab84579fce5a2b9 # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git checkout -b master 0f9852fc1cdc40c457e63d9bcab84579fce5a2b9 # timeout=10
Commit message: "Update requirements.yml"
First time build. Skipping changelog.
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Run ansible)
[Pipeline] sh
+ ansible-galaxy install -p /workspace/Declarative-Pipeline-Netology-2 -r requirements.yml
Starting galaxy role install process
- extracting java to /workspace/Declarative-Pipeline-Netology-2/java
- java (1.0.1) was installed successfully
[Pipeline] sh
+ ansible-playbook /workspace/Declarative-Pipeline-Netology-2/site.yml -i /workspace/Declarative-Pipeline-Netology-2/inventory/prod.yml

PLAY [Install Java] ************************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [java : Upload .tar.gz file containing binaries from local storage] *******
skipping: [localhost]

TASK [java : Upload .tar.gz file conaining binaries from remote storage] *******
changed: [localhost]

TASK [java : Ensure installation dir exists] ***********************************
changed: [localhost]

TASK [java : Extract java in the installation directory] ***********************
changed: [localhost]

TASK [java : Export environment variables] *************************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   

[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

---

3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`

---

**Перенёс в файл [репозитория](https://github.com/venbergv/example-playbook)**

---

4. Перенастроить Job на использование `Jenkinsfile` из репозитория

---

![Сборка](/09-ci-03-jenkins/img/5.png)

**Консоль сборки.**

```
Started by user admin
Obtained Jenkinsfile from git https://github.com/venbergv/example-playbook.git
[Pipeline] Start of Pipeline
[Pipeline] node
Running on ansible_docker-0000mhsnqymdk on docker in /workspace/Declarative-Pipeline-Netology-2
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
using credential 5992545b-5363-4ef7-b232-986191b7b5bf
Cloning the remote Git repository
Cloning repository https://github.com/venbergv/example-playbook.git
 > git init /workspace/Declarative-Pipeline-Netology-2 # timeout=10
Avoid second fetch
Fetching upstream changes from https://github.com/venbergv/example-playbook.git
 > git --version # timeout=10
 > git --version # 'git version 1.8.3.1'
using GIT_SSH to set credentials 
 > git fetch --tags --progress https://github.com/venbergv/example-playbook.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config remote.origin.url https://github.com/venbergv/example-playbook.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
Checking out Revision cd7b9470e85a7802496c6091be97faceba48e034 (refs/remotes/origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f cd7b9470e85a7802496c6091be97faceba48e034 # timeout=10
Commit message: "Update Jenkinsfile"
 > git rev-list --no-walk cd7b9470e85a7802496c6091be97faceba48e034 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Get code from GitHub)
[Pipeline] git
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
No credentials specified
Fetching changes from the remote Git repository
 > git rev-parse --resolve-git-dir /workspace/Declarative-Pipeline-Netology-2/.git # timeout=10
 > git config remote.origin.url https://github.com/venbergv/example-playbook.git # timeout=10
Fetching upstream changes from https://github.com/venbergv/example-playbook.git
 > git --version # timeout=10
 > git --version # 'git version 1.8.3.1'
 > git fetch --tags --progress https://github.com/venbergv/example-playbook.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Checking out Revision cd7b9470e85a7802496c6091be97faceba48e034 (refs/remotes/origin/master)
Commit message: "Update Jenkinsfile"
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Run ansible)
[Pipeline] sh
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f cd7b9470e85a7802496c6091be97faceba48e034 # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git checkout -b master cd7b9470e85a7802496c6091be97faceba48e034 # timeout=10
+ ansible-galaxy install -p /workspace/Declarative-Pipeline-Netology-2 -r requirements.yml
Starting galaxy role install process
- extracting java to /workspace/Declarative-Pipeline-Netology-2/java
- java (1.0.1) was installed successfully
[Pipeline] sh
+ ansible-playbook /workspace/Declarative-Pipeline-Netology-2/site.yml -i /workspace/Declarative-Pipeline-Netology-2/inventory/prod.yml

PLAY [Install Java] ************************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [java : Upload .tar.gz file containing binaries from local storage] *******
skipping: [localhost]

TASK [java : Upload .tar.gz file conaining binaries from remote storage] *******
changed: [localhost]

TASK [java : Ensure installation dir exists] ***********************************
changed: [localhost]

TASK [java : Extract java in the installation directory] ***********************
changed: [localhost]

TASK [java : Export environment variables] *************************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   

[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

---

5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline)
6. Заменить credentialsId на свой собственный
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозитрий в файл `ScriptedJenkinsfile`

---

**Получился такой скрипт.**

```
node("ansible_docker"){
    stage("Git checkout"){
        git credentialsId: '5992545b-5363-4ef7-b232-986191b7b5bf', url: 'https://github.com/venbergv/example-playbook.git'
    }
    stage("Check ssh key"){
        secret_check=true
    }
    stage("Run playbook"){
        if (secret_check){
            sh 'ansible-galaxy install -r requirements.yml -p roles'
            sh 'ansible-playbook site.yml -i inventory/prod.yml'
        }
        else{
            echo 'no more keys'
        }
        
    }
}
```

**Проверяем сборку.**

![Сборка](/09-ci-03-jenkins/img/6.png)

**Консоль сборки.**

```
Started by user admin
[Pipeline] Start of Pipeline
[Pipeline] node
Running on ansible_docker-0000n418e3zdi on docker in /workspace/Scripted-Pipeline-Netology-3
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Git checkout)
[Pipeline] git
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
using credential 5992545b-5363-4ef7-b232-986191b7b5bf
Cloning the remote Git repository
Cloning repository https://github.com/venbergv/example-playbook.git
 > git init /workspace/Scripted-Pipeline-Netology-3 # timeout=10
Fetching upstream changes from https://github.com/venbergv/example-playbook.git
 > git --version # timeout=10
 > git --version # 'git version 1.8.3.1'
using GIT_SSH to set credentials 
 > git fetch --tags --progress https://github.com/venbergv/example-playbook.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Avoid second fetch
Checking out Revision cd7b9470e85a7802496c6091be97faceba48e034 (refs/remotes/origin/master)
 > git config remote.origin.url https://github.com/venbergv/example-playbook.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f cd7b9470e85a7802496c6091be97faceba48e034 # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git checkout -b master cd7b9470e85a7802496c6091be97faceba48e034 # timeout=10
Commit message: "Update Jenkinsfile"
First time build. Skipping changelog.
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Check ssh key)
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Run playbook)
[Pipeline] sh
+ ansible-galaxy install -r requirements.yml -p roles
Starting galaxy role install process
- extracting java to /workspace/Scripted-Pipeline-Netology-3/roles/java
- java (1.0.1) was installed successfully
[Pipeline] sh
+ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Install Java] ************************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [java : Upload .tar.gz file containing binaries from local storage] *******
skipping: [localhost]

TASK [java : Upload .tar.gz file conaining binaries from remote storage] *******
changed: [localhost]

TASK [java : Ensure installation dir exists] ***********************************
changed: [localhost]

TASK [java : Extract java in the installation directory] ***********************
changed: [localhost]

TASK [java : Export environment variables] *************************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   

[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS

```

---

8. Отправить ссылку на репозиторий в ответе

---

**Ссылка на мой [репозиторий](https://github.com/venbergv/example-playbook)**

---
