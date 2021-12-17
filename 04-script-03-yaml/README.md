# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис
---

Ответ.

*1. Потерялась запятая в 6 строке.*  
*2. Потеряны кавычки в 9 строке.*
*3. В 5 строке что-то непохожее на ip. Возможно ошибка в самом коде сервиса.*

```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```
---
## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
##!/usr/bin/env python3
"""Check ip"""

import socket
import time
import sys

WAIT = 3

srv = {
    'drive.google.com': '0.0.0.0',
    'mail.google.com': '0.0.0.0',
    'google.com':' 0.0.0.0'
    }
try:
    while True:
        for srv_name, srv_ip  in srv.items():
            try:
                chk_ip = socket.gethostbyname(srv_name)
            except socket.gaierror:
                sys.exit('\n'+srv_name+' - Host Not Resolve')
            if chk_ip != srv_ip:
                print(f'[ERROR] {srv_name} IP mismatch: {srv_ip} New IP: {chk_ip}')
                srv[srv_name] = chk_ip
            else:
                print(f'{srv_name} - {srv_ip}')
            time.sleep(WAIT)
            with open("log_ip.json", 'w') as file_json, open("log_ip.yml", 'w') as file_yaml:
                file_json.write(json.dumps(srv, indent=4))
                file_yaml.write(yaml.dump(srv))
except KeyboardInterrupt:
    print('\n User Abort Script.')
```

### Вывод скрипта при запуске при тестировании:
```bash
vagrant@vagrant:/vagrant/script/4.3$ python3 script1.py
[ERROR] drive.google.com IP mismatch: 0.0.0.0 New IP: 173.194.222.194
[ERROR] mail.google.com IP mismatch: 0.0.0.0 New IP: 173.194.73.19
[ERROR] google.com IP mismatch: 0.0.0.0 New IP: 74.125.131.138
drive.google.com - 173.194.222.194
[ERROR] mail.google.com IP mismatch: 173.194.73.19 New IP: 173.194.73.83
[ERROR] google.com IP mismatch: 74.125.131.138 New IP: 74.125.131.139
drive.google.com - 173.194.222.194
mail.google.com - 173.194.73.83
google.com - 74.125.131.139
drive.google.com - 173.194.222.194
^C
 User Abort Script.
vagrant@vagrant:/vagrant/script/4.3$ 
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{
    "drive.google.com": "173.194.222.194",
    "mail.google.com": "173.194.73.83",
    "google.com": "74.125.131.139"
}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
drive.google.com: 173.194.222.194
google.com: 74.125.131.139
mail.google.com: 173.194.73.83
```


