# Дипломный практикум в YandexCloud
 
---
## Этапы выполнения:

### Подготовительные действия:

1. Заведен аккаунт в YandexCloud
2. Сгенерированы необходимые ключи доступа в YandexCloud.
3. Создан Object Storage.
4. У регистратора [reg.ru](https://reg.ru) зарегистрирован домен `venbergv.fun`
5. Домен делегирован под управление `ns1.yandexcloud.net` и `ns2.yandexcloud.net`
6. Создан worckspace 'stage'.
```bash
$ cd terraform
$ terraform workspace new stage
$ terraform workspace select stage
$ terraform workspace list
  default
  prod
* stage
```
7. Перед началом развертывания все переменные в файле `variables.tf` должны быть заполнены соответствующими значениям.
8. Опционально можно изменить параметры уровня [производительности машин](https://cloud.yandex.ru/docs/compute/concepts/performance-levels). По умолчанию для `stage` определен уровень 20%.

### Создание инфраструктуры

Если workspace уже создан, то достаточно выполнить следующее.

```bash
$ terraform init
$ terraform plan
$ terraform apply -auto-approve
```

Время выполнения приблизительно 20-40 минут.

![](/devops-diplom-yandexcloud/img/complete.png)

После выполнения можем увидеть следующее: 

Виртуальные машины в **YandexCloud**
![](/devops-diplom-yandexcloud/img/vm-cloud.png)

Записи DNS нашего домена в **YandexCloud**
![](/devops-diplom-yandexcloud/img/vm-cloud.png)

Наш основной сайт, с автоматически сгенерированным проектом `Experimental`
![](/devops-diplom-yandexcloud/img/app1.png)

Мониторинг всей нашей системы:

1. Prometheus
![](/devops-diplom-yandexcloud/img/prometheus1.png)

![](/devops-diplom-yandexcloud/img/prometheus2.png)

![](/devops-diplom-yandexcloud/img/prometheus3.png)

2. Alertmanager
![](/devops-diplom-yandexcloud/img/alertm1.png)

![](/devops-diplom-yandexcloud/img/alertm3.png)

3. Grafana
![](/devops-diplom-yandexcloud/img/grafana1.png)

![](/devops-diplom-yandexcloud/img/grafana2.png)

Локальный Gitlab-CE и предустановленный Gitlab-runner

![](/devops-diplom-yandexcloud/img/gitlab1.png)

![](/devops-diplom-yandexcloud/img/runner1.png)


---

### Gitlab CE и Gitlab Runner

1. Создаем новый проект в `Gitlab`.  
Для этого используем импорт по URL. [Мой проект](https://github.com/venbergv/dp-cicd.git)

![](/devops-diplom-yandexcloud/img/gitlab2.png)

![](/devops-diplom-yandexcloud/img/gitlab3.png)

Мой .gitlab-ci.yml

```
stages:
  - deploy

deploy-job:
  stage: deploy
  script:
    - if [ "$CI_COMMIT_TAG" = "" ] ; then echo "Need add tag!";
      else 
        ssh -o StrictHostKeyChecking=no ubuntu@app.venbergv.fun sudo chown ubuntu /var/www/venbergv.fun -R;
        scp -q -o StrictHostKeyChecking=no -r $CI_PROJECT_DIR/wp/* ubuntu@app.venbergv.fun:/var/www/venbergv.fun/;
        ssh -o StrictHostKeyChecking=no ubuntu@app.venbergv.fun sudo chown www-data /var/www/venbergv.fun -R;
      fi
    - echo "The End"

```

2. Привязываем наш текущий `runner` к нашему проекту.  
3. Добавляем tag 1.0.0 согласно заданию.  
4. Проверяем успешное выполнение `pipeline`  

![](/devops-diplom-yandexcloud/img/gitlab5.png)

![](/devops-diplom-yandexcloud/img/gitlab6.png)

---
После окончания всех работ, для экономии средств, выполняем в каталоге `terraform` следующую команду.

```bash
$ terraform destroy -auto-approve 
```
---