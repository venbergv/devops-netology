# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = ""
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = ""
}

# Заменить на имя своего bucket
# 
variable "yandex_buket" {
  default = ""
}

# Заменить на access_key
# 
variable "yandex_s3_acc_key" {
  default = ""
}

# Заменить на secret_key
# 
variable "yandex_s3_sec_key" {
  default = ""
}

# Заменить на свой домен
# Или оставить закомментированной определение домена для тестов
variable "my_domain" {
  default = "venbergv.fun"
}

# По умолчанию используем временные сертификаты Let's Encrypt
# Если нужны реальные сертификаты, то заменить на "false"
variable "my_le_staging" {
  default = "true"
}

# Внутренние переменные.

# ID образа Ubuntu 20.04 LTS
# 
variable "ubuntu-latest" {
  default = "fd87tirk5i8vitv9uuo1"
}

# ID Образа Ubuntu 18.04 для Nat
# 
variable "ubuntu-nat" {
  default = "fd84mnpg35f7s7b0f5lg"
}

#
# Токен для работы Gitlab c runner
variable "my_gitlab_runner" {
  default = "o9PZATGl+oOKkyN+06jRq0usrREGzHpV7cg26xJcYBk="
}

#
# Внутренний пароль для репликации между базами MySQL
variable "my_replicator_psw" {
  default = "P@sswW0rd!R"
}

# Пароли для доступа к графическим интерфейсам.

#
# Пароль для доступа к Grafana от пользователя `admin`
variable "my_grafana_psw" {
  default = "P@ssW0rd!G"
}

#
# Пароль для доступа к Gitlab от пользователя `root`
variable "my_gitlab_psw" {
  default = "Gitl@bPa$$word"
}


