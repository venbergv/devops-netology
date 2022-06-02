# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

---

***Ответ.***

```
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo apt-add-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
```

```bash
$ ansible --version
ansible [core 2.12.6]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/vagrant/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/vagrant/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Nov 26 2021, 20:14:08) [GCC 9.3.0]
  jinja version = 2.10.1
  libyaml = True
```

---

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

---

***Ответ.***

```bash
$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ***********************************************************************************************

TASK [Gathering Facts] **********************************************************************************************
ok: [localhost]

TASK [Print OS] *****************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP **********************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

*В данном случае `some_fact`=12*

---

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

---

***Ответ.***

*Изменяем переменную в файле 'group_vars/all/examp.yml'*

```bash
$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ***********************************************************************************************

TASK [Gathering Facts] **********************************************************************************************
ok: [localhost]

TASK [Print OS] *****************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP **********************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

---

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

---

***Ответ.***

Подготавливаем и запускаем свои контейнеры.  
Мой [docker-compose.yml](/08-ansible-01-base/docker-compose.yml)

```bash
$ docker ps
CONTAINER ID   IMAGE                      COMMAND            CREATED          STATUS          PORTS     NAMES
ef1094108201   pycontribs/centos:7        "sleep infinity"   21 seconds ago   Up 20 seconds             centos7
11bb5caf0f1b   pycontribs/ubuntu:latest   "sleep infinity"   21 seconds ago   Up 20 seconds             ubuntu
```

---

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

---

***Ответ.***

```bash
$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] **********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *********************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

*Значения `some_fact`:*  

*Для `Centos` - `el`*  
*Для `Ubuntu` - `deb`*

---

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

---

***Ответ.***


*Для `group_vars/deb/examp.yml`*

```bash
---
some_fact: "deb default fact"
```

*Для `group_vars/el/examp.yml`*

```bash
---
some_fact: "el default fact"
```

---

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

---

***Ответ.***

```bash
$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] **********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *********************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

---

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

---

***Ответ.***

```bash
$ ansible-vault encrypt group_vars/deb/examp.yml group_vars/el/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
```

```bash
$ cat group_vars/deb/examp.yml
$ANSIBLE_VAULT;1.1;AES256
36326231633132616163396566346562613036643566356637653131373430383065636630336133
3464343664326165383865656133633963636632386563310a616338623034316237643334323262
31303431663330643266336565626165633865383933393636633835626631343230633739616462
3664633066356266390a336634636538393632336565323962663236393761313330303337336435
63636639306666346462623632623532333231373062306664623365393235656138646338326366
6166616365373835353131326261316530653632656636313537
```

```bash
$ cat group_vars/el/examp.yml
$ANSIBLE_VAULT;1.1;AES256
33666435613232336234613136303265303433636562633266323261653730363132356538353530
6436656361333630326336323232373638643930303938340a626637653735643134346535343530
35336430353930373432356131643663663138396137653333363231623465393764656431323335
3230663161383563630a633238386531343231653835383033663536613936373261376166373734
63376264313133386665356633393335346136636666393135383035323930386338373464316639
6330656430313030616237383939383566626630386563656562
```

---

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

---

***Ответ.***

```bash
$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] **********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *********************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

---

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

---

***Ответ.***

```bash
$ ansible-doc --type=connection -l
[WARNING]: Collection ibm.qradar does not support Ansible version 2.12.6
[WARNING]: Collection splunk.es does not support Ansible version 2.12.6
[DEPRECATION WARNING]: ansible.netcommon.napalm has been deprecated. See the plugin documentation for more details. This feature will be 
removed from ansible.netcommon in a release after 2022-06-01. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ansible.netcommon.httpapi      Use httpapi to run command on network appliances                                                        
ansible.netcommon.libssh       (Tech preview) Run tasks using libssh for ssh connection                                                
ansible.netcommon.napalm       Provides persistent connection using NAPALM                                                             
ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol                                             
ansible.netcommon.network_cli  Use network_cli to run command on network appliances                                                    
ansible.netcommon.persistent   Use a persistent unix socket for connection                                                             
community.aws.aws_ssm          execute via AWS Systems Manager                                                                         
community.docker.docker        Run tasks in docker containers                                                                          
community.docker.docker_api    Run tasks in docker containers                                                                          
community.docker.nsenter       execute on host running controller container                                                            
community.general.chroot       Interact with local chroot                                                                              
community.general.funcd        Use funcd to connect to target                                                                          
community.general.iocage       Run tasks in iocage jails                                                                               
community.general.jail         Run tasks in jails                                                                                      
community.general.lxc          Run tasks in lxc containers via lxc python library                                                      
community.general.lxd          Run tasks in lxc containers via lxc CLI                                                                 
community.general.qubes        Interact with an existing QubesOS AppVM                                                                 
community.general.saltstack    Allow ansible to piggyback on salt minions                                                              
community.general.zone         Run tasks in a zone instance                                                                            
community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt                                                                 
community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines                                                              
community.okd.oc               Execute tasks in pods running on OpenShift                                                              
community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools                                                              
community.zabbix.httpapi       Use httpapi to run command on network appliances                                                        
containers.podman.buildah      Interact with an existing buildah container                                                             
containers.podman.podman       Interact with an existing podman container                                                              
kubernetes.core.kubectl        Execute tasks in pods running on Kubernetes                                                             
local                          execute on controller                                                                                   
paramiko_ssh                   Run tasks via python ssh (paramiko)                                                                     
psrp                           Run tasks over Microsoft PowerShell Remoting Protocol                                                   
ssh                            connect via SSH client binary                                                                           
winrm                          Run tasks over Microsoft's WinRM
```

*Нас интересует `execute on controller`.*

---

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

---

***Ответ.***

```
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```

---

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

---

***Ответ.***

```bash
$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] *********************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ***************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ********************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

---

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

---

***Ответ.***

[Заполненый `README.md`](https://github.com/venbergv/devops-netology/tree/main/08-ansible-01-base/)

---

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

