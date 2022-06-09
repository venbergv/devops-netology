# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1gqo6r13ihd0vmgjq8p"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1gf3qaa4c5nl8l72v3q"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "ubuntu-latest" {
  default = "fd87tirk5i8vitv9uuo1"
}
