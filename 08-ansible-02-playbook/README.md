# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению

1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.

---

***Ответ.***

[Мой публичный репозиторий](https://github.com/venbergv/devops-netology/blob/main/08-ansible-02-playbook/)

---

2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
3. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

---

***Ответ.***

Будем использовать тестовую `VM` с `Centos 7`.

---

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.

---

***Ответ.***

```
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: srv-study-c7
      ansible_connection: ssh
      ansible_ssh_user: root
```

---

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.

---

***Ответ.***

```
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service

    - name: Force restart clickhouse service
      ansible.builtin.meta: flush_handlers

    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0

- name: Install Vector
  hosts: clickhouse
  handlers:
    - name: Start vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
    - name: Get vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/0.22.0/vector-0.22.0-1.x86_64.rpm"
        dest: ./vector.rpm
    - name: Install vector packages
      become: true
      ansible.builtin.yum:
        name:
          - vector.rpm
      notify: Start vector service
```

---

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

---

***Ответ.***

```bash
vagrant@server1:~/82/playbook$ ansible-lint site.yml
vagrant@server1:~/82/playbook$
```

---

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

---

***Ответ.***

```bash
$ ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] *************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *********************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *********************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ****************************************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system"]}

PLAY RECAP ****************************************************************************************************************************************************
clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0 
```

---

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

---

***Ответ.***

```bash
$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] *************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *********************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *********************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ****************************************************************************************************************************
changed: [clickhouse-01]

TASK [Force restart clickhouse service] ***********************************************************************************************************************

RUNNING HANDLER [Start clickhouse service] ********************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] ****************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install Vector] *****************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get vector distrib] *************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install vector packages] ********************************************************************************************************************************
changed: [clickhouse-01]

RUNNING HANDLER [Start vector service] ************************************************************************************************************************
changed: [clickhouse-01]

PLAY RECAP ****************************************************************************************************************************************************
clickhouse-01              : ok=9    changed=7    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
```

---

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

---

***Ответ.***

```bash
$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] *************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *********************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *********************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ****************************************************************************************************************************
ok: [clickhouse-01]

TASK [Force restart clickhouse service] ***********************************************************************************************************************

TASK [Create database] ****************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] *****************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get vector distrib] *************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install vector packages] ********************************************************************************************************************************
ok: [clickhouse-01]

PLAY RECAP ****************************************************************************************************************************************************
clickhouse-01              : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
```

---

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

---

***Ответ.***

**Ссылка на соответствующий [README.md](./playbook/README.md)**

---

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

***Ответ.***

**Ссылка на соответствующий [тег](https://github.com/venbergv/devops-netology/releases/tag/08-ansible-02-playbook)**

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
