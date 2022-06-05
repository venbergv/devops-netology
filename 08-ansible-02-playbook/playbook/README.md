### Что делает playbook

Плейбук развернёт на хосте следующее ПО:
- `Clickhouse`
- `Vector`

### Список устанавливаемых компонентов:

**Компоненты `Clickhouse` версии `22.3.3.44`:**  
- clickhouse-client
- clickhouse-server
- clickhouse-common-static

**Компоненты версии `Vector` `0.22.0`:**
- vector

### Какие у него есть параметры 

- Файл **[playbook/inventory/prod.yml](./inventory/prod.yml)** с настройками хоста, на котором запускается playbook.  
- В файле **[playbook/group_vars/clickhouse/vars.yml](./group_vars/clickhouse/vars.yml)** содержится информация о списке компонентов `Clickhouse` и его версия.  

### Какие у него есть теги

Мы не использовали теги для нашего `playbook`.
