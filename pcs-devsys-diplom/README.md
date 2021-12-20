#Курсовая работа по итогам модуля "DevOps и системное администрирование"


---
1. Создайте виртуальную машину Linux.
---

*Создана новая виртуальная машина `Ubuntu`.*  

```
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
```
---
2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.
---

```bash
vagrant@vagrant:~$ sudo ufw status
Status: inactive
vagrant@vagrant:~$ sudo ufw allow 22/tcp
Rules updated
Rules updated (v6)
vagrant@vagrant:~$ sudo ufw allow 443/tcp
Rules updated
Rules updated (v6)
vagrant@vagrant:~$ sudo ufw allow in on lo to any
Rules updated
Rules updated (v6)
vagrant@vagrant:~$ sudo ufw allow out on lo to any
Rules updated
Rules updated (v6)
vagrant@vagrant:~$ sudo ufw default deny incoming
Default incoming policy changed to 'deny'
(be sure to update your rules accordingly)
vagrant@vagrant:~$ sudo ufw default allow outgoing
Default outgoing policy changed to 'allow'
(be sure to update your rules accordingly)
vagrant@vagrant:~$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
vagrant@vagrant:~$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere                  
443/tcp                    ALLOW IN    Anywhere                  
Anywhere on lo             ALLOW IN    Anywhere                  
22/tcp (v6)                ALLOW IN    Anywhere (v6)             
443/tcp (v6)               ALLOW IN    Anywhere (v6)             
Anywhere (v6) on lo        ALLOW IN    Anywhere (v6)             

Anywhere                   ALLOW OUT   Anywhere on lo            
Anywhere (v6)              ALLOW OUT   Anywhere (v6) on lo       

vagrant@vagrant:~$ 
```

---
3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).
---

*Устанавливаем HasiCorp Vault.*

```bash
vagrant@vagrant:~$ sudo curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
vagrant@vagrant:~$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
<Skip>
Reading package lists... Done
vagrant@vagrant:~$ sudo apt update && sudo apt install vault
<Skip>
Vault TLS key and self-signed certificate have been generated in '/opt/vault/tls'.
vagrant@vagrant:~$ 
```
```bash
vagrant@vagrant:~$ vault
Usage: vault <command> [args]

Common commands:
    read        Read data and retrieves secrets
    write       Write data, configuration, and secrets
    delete      Delete secrets and configuration
    list        List data or secrets
    login       Authenticate locally
    agent       Start a Vault agent
    server      Start a Vault server
    status      Print seal and HA status
    unwrap      Unwrap a wrapped secret

Other commands:
    audit          Interact with audit devices
    auth           Interact with auth methods
    debug          Runs the debug command
    kv             Interact with Vault's Key-Value storage
    lease          Interact with leases
    monitor        Stream log messages from a Vault server
    namespace      Interact with namespaces
    operator       Perform operator-specific tasks
    path-help      Retrieve API help for paths
    plugin         Interact with Vault plugins and catalog
    policy         Interact with policies
    print          Prints runtime configurations
    secrets        Interact with secrets engines
    ssh            Initiate an SSH session
    token          Interact with tokens
vagrant@vagrant:~$ 
```

---
4. Создайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).
---

*Устанавливаем дополнительный пакет `jq`, запускаем сервис, утанавливаем переменные.*  

```bash
vagrant@vagrant:~$ sudo apt install jq
```

```bash
vagrant@vagrant:~$ sudo systemctl start vault.service
vagrant@vagrant:~$ sudo systemctl status vault.service
● vault.service - "HashiCorp Vault - A tool for managing secrets"
     Loaded: loaded (/lib/systemd/system/vault.service; disabled; vendor preset: enabled)
     Active: active (running) since Fri 2021-12-17 18:35:38 UTC; 11s ago
       Docs: https://www.vaultproject.io/docs/
   Main PID: 1930 (vault)
      Tasks: 6 (limit: 1071)
     Memory: 188.2M
     CGroup: /system.slice/vault.service
             └─1930 /usr/bin/vault server -config=/etc/vault.d/vault.hcl

Dec 17 18:35:39 vagrant vault[1930]:               Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", m>
Dec 17 18:35:39 vagrant vault[1930]:                Log Level: info
Dec 17 18:35:39 vagrant vault[1930]:                    Mlock: supported: true, enabled: true
Dec 17 18:35:39 vagrant vault[1930]:            Recovery Mode: false
Dec 17 18:35:39 vagrant vault[1930]:                  Storage: file
Dec 17 18:35:39 vagrant vault[1930]:                  Version: Vault v1.9.1
Dec 17 18:35:39 vagrant vault[1930]: ==> Vault server started! Log data will stream in below:
Dec 17 18:35:39 vagrant vault[1930]: 2021-12-17T18:35:38.870Z [INFO]  proxy environment: http_proxy="\"\"" https_proxy="\"\"" no>
Dec 17 18:35:39 vagrant vault[1930]: 2021-12-17T18:35:38.871Z [WARN]  no `api_addr` value specified in config or in VAULT_API_AD>
Dec 17 18:35:39 vagrant vault[1930]: 2021-12-17T18:35:39.063Z [INFO]  core: Initializing VersionTimestamps for core
vagrant@vagrant:~$ 
```
```bash
vagrant@vagrant:~$ export VAULT_ADDR=http://127.0.0.1:8200
vagrant@vagrant:~$
```
```bash
vagrant@vagrant:~$ vault status
Key                Value
---                -----
Seal Type          shamir
Initialized        false
Sealed             true
Total Shares       0
Threshold          0
Unseal Progress    0/0
Unseal Nonce       n/a
Version            1.9.1
Storage Type       file
HA Enabled         false
vagrant@vagrant:~$ 
```
*Инициализируем новый Vault.*  

```bash
vagrant@vagrant:~$ vault operator init -key-shares=3 -key-threshold=2
Unseal Key 1: e0QyadOztTpGsIW8iPX8q4rvKvHXjoKXUR7e/w3xSNXn
Unseal Key 2: pTGt9mT16BVwzXoHOorURJKeR3D+EAvDH8NRA5bDuZAH
Unseal Key 3: otOQyxXqRnwJnV6dz3uYH18laHhv8LECsrgTW/Lj1/PL

Initial Root Token: s.JVOEICRa8R6eUhXLMPFgvd1g

Vault initialized with 3 key shares and a key threshold of 2. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 2 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 2 keys to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
vagrant@vagrant:~$ 
```
*Открываем Vault и подключаемся к нему.*  
```bash
vagrant@vagrant:~$ vault operator unseal e0QyadOztTpGsIW8iPX8q4rvKvHXjoKXUR7e/w3xSNXn
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       3
Threshold          2
Unseal Progress    1/2
Unseal Nonce       f5cbd134-6d97-0abc-85af-8630aa364e54
Version            1.9.1
Storage Type       file
HA Enabled         false
vagrant@vagrant:~$ vault operator unseal otOQyxXqRnwJnV6dz3uYH18laHhv8LECsrgTW/Lj1/PL
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    3
Threshold       2
Version         1.9.1
Storage Type    file
Cluster Name    vault-cluster-16f8ce57
Cluster ID      a8bdf3e4-ea57-9278-bac5-f1e9eba665cb
HA Enabled      false
vagrant@vagrant:~$ vault login s.JVOEICRa8R6eUhXLMPFgvd1g
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.JVOEICRa8R6eUhXLMPFgvd1g
token_accessor       am8OGeLLrKRm82MLRJSMYsvX
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
vagrant@vagrant:~$ 
```
*Содаем ключ и сертификат для центра сертификации, сроком на 10 лет.*  
```bash
vagrant@vagrant:~$ vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
vagrant@vagrant:~$ vault secrets tune -max-lease-ttl=87600h pki
Success! Tuned the secrets engine at: pki/
vagrant@vagrant:~$ 
```
```bash
vagrant@vagrant:~$ vault write -field=certificate pki/root/generate/internal common_name=project.devel ttl=87600 > CA_cert.crt
vagrant@vagrant:~$ vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls
vagrant@vagrant:~$ 
```
*Создаем промежуточный сертификат, сроком на 5 лет.*  
```bash
vagrant@vagrant:~$ vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
vagrant@vagrant:~$ vault secrets tune -max-lease-ttl=43800h pki_int
Success! Tuned the secrets engine at: pki_int/
vagrant@vagrant:~$ vault write -format=json pki_int/intermediate/generate/internal common_name="project.devel Intermediate Authority" | jq -r '.data.csr' > pki_intermediate.csr
vagrant@vagrant:~$ vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle ttl="43800h"| jq -r '.data.certificate' > intermediate.cert.pem
vagrant@vagrant:~$ vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
vagrant@vagrant:~$ 
```
*Создаем роль.*  
```bash
vagrant@vagrant:~$ vault write pki_int/roles/project-dot-devel allowed_domains="project.devel" allow_bare_domains=true allow_subdomains=true max_ttl="720h"
Success! Data written to: pki_int/roles/project-dot-devel
vagrant@vagrant:~$ 
```
*Генерируем сертификат для домена на месяц. В формате `json` для удобства дальнейшего использования при настройке nginx.*  

```bash
vagrant@vagrant:~$ vault write -format=json pki_int/issue/project-dot-devel common_name="project.devel" ttl="720h" > project.devel.raw.json
```


---
5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
---

```bash
devuser@devhost:~$ sudo mv CA_cert.crt /usr/local/share/ca-certificates/CA_cert.crt
devuser@devhost:~$ sudo update-ca-certificates
Updating certificates in /etc/ssl/certs...
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
devuser@devhost:~$ 
```

---
6. Установите nginx.
---

```
```bash
vagrant@vagrant:~$ sudo apt update
<Skip>
vagrant@vagrant:~$ sudo apt install nginx
<Skip>
vagrant@vagrant:/etc/ssl$ 
vagrant@vagrant:~$ systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-12-20 09:27:05 UTC; 28min ago
       Docs: man:nginx(8)
   Main PID: 5854 (nginx)
      Tasks: 2 (limit: 1071)
     Memory: 4.3M
     CGroup: /system.slice/nginx.service
             ├─5854 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             └─5855 nginx: worker process

Dec 20 09:27:05 vagrant systemd[1]: Starting A high performance web server and a reverse proxy server...
Dec 20 09:27:05 vagrant systemd[1]: Started A high performance web server and a reverse proxy server.
vagrant@vagrant:~$ 

```

---
7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:
  - можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
  - можно использовать и другой html файл, сделанный вами;
---

*Подготавливаем каталог для нашего будущего сайта.*   
```bash
vagrant@vagrant:~$ sudo mkdir -p /var/www//project.devel/html/
vagrant@vagrant:/var/www/html$ sudo cp /var/www/html/index.nginx-debian.html /var/www/project.devel/html/index.html
vagrant@vagrant:~$
```
*Создаем конфигурацию для нашего сайта.`/etc/nginx/sites-available/project.devel*  
```
server {
        listen 443 ssl;

        root /var/www/project.devel/html;
        index index.html;

        server_name project.devel;

        ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers         HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;

        ssl_certificate     /etc/ssl/certs/project.devel.crt;
        ssl_certificate_key /etc/ssl/private/project.devel.key;

        location / {
                try_files $uri $uri/ =404;
        }
}
```
*Подготавливаем цепочки сертификатов и ключи.*  
```bash
vagrant@vagrant:~$ sudo cat project.devel.raw.json | jq -r '.data.certificate' > /etc/ssl/certs/project.devel.crt
vagrant@vagrant:~$ sudo cat project.devel.raw.json | jq -r '.data.ca_chain[]' >> /etc/ssl/certs/project.devel.crt
vagrant@vagrant:~$ sudo cat project.devel.raw.json | jq -r '.data.private_key' > /etc/ssl/private/project.devel.key
```
```bash
vagrant@vagrant:~$ systemctl reload nginx
```

---
8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.
---

![Наш сайт](/pcs-devsys-diplom/img/1.png)
![Наш сертификат](/pcs-devsys-diplom/img/2.png)
---
9. Создайте скрипт, который будет генерировать новый сертификат в vault:
  - генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
  - перезапускаем nginx для применения нового сертификата.
---

*Создаем скрипт для обновления сертификатов и обновления конфигурации nginx.*

```
#!/usr/bin/env bash

#Start HashiCorp vault.service
systemctl start vault.service
sleep 10

#Open vault
export VAULT_ADDR='http://127.0.0.1:8200'
vault operator unseal e0QyadOztTpGsIW8iPX8q4rvKvHXjoKXUR7e/w3xSNXn
vault operator unseal otOQyxXqRnwJnV6dz3uYH18laHhv8LECsrgTW/Lj1/PL
vault login s.JVOEICRa8R6eUhXLMPFgvd1g

#Generate new certificate
TEMP_DATA=$(vault write -format=json pki_int/issue/project-dot-devel common_name="project.devel" ttl="720h")
jq -r '.data.certificate' <<< "$TEMP_DATA" > /etc/ssl/certs/project.devel.crt
jq -r '.data.ca_chain[]' <<< "$TEMP_DATA" >> /etc/ssl/certs/project.devel.crt
jq -r '.data.private_key' <<< "$TEMP_DATA" > /etc/ssl/private/project.devel.key

#Stop HashiCorp vault.service
systemctl stop vault.service

# restart nginx
systemctl reload nginx

```
```bash
chmod 755 update_crt.sh
```
---
10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.
---

*Добавляем в crontab -e.*   
```
49 21 * * * /root/script/update_crt.sh 
```

![Наш новый сертификат](/pcs-devsys-diplom/img/3.png)

*Устанавливаю получение нового сертификата на 3 чача, 10 минут, 1 числа, каждого месяца.*  
```
10 3 1 * * /root/script/update_crt.sh 
```


