
# Создаем публичную DNS зону 
resource "yandex_dns_zone" "myvpc-zone" {
  name             = "myvpc-public-zone"
  zone             = "${var.my_domain}."
  public           = true
}

# Прописываем основную A-запись
resource "yandex_dns_recordset" "a1" {
  zone_id = yandex_dns_zone.myvpc-zone.id
  name    = "${var.my_domain}."
  type    = "A"
  ttl     = 90
  data    = [yandex_compute_instance.node01nginx.network_interface.0.nat_ip_address]
  depends_on = [yandex_compute_instance.node01nginx]
}

# Прописываем A-записи для доменов 3 уровня
resource "yandex_dns_recordset" "a2" {
  zone_id = yandex_dns_zone.myvpc-zone.id
  name    = "www"
  type    = "A"
  ttl     = 90
  data    = [yandex_compute_instance.node01nginx.network_interface.0.nat_ip_address]
  depends_on = [yandex_compute_instance.node01nginx]
}

resource "yandex_dns_recordset" "a3" {
  zone_id = yandex_dns_zone.myvpc-zone.id
  name    = "gitlab"
  type    = "A"
  ttl     = 90
  data    = [yandex_compute_instance.node01nginx.network_interface.0.nat_ip_address]
  depends_on = [yandex_compute_instance.node01nginx]
}

resource "yandex_dns_recordset" "a4" {
  zone_id = yandex_dns_zone.myvpc-zone.id
  name    = "grafana"
  type    = "A"
  ttl     = 90
  data    = [yandex_compute_instance.node01nginx.network_interface.0.nat_ip_address]
  depends_on = [yandex_compute_instance.node01nginx]
}

resource "yandex_dns_recordset" "a5" {
  zone_id = yandex_dns_zone.myvpc-zone.id
  name    = "prometheus"
  type    = "A"
  ttl     = 90
  data    = [yandex_compute_instance.node01nginx.network_interface.0.nat_ip_address]
  depends_on = [yandex_compute_instance.node01nginx]
}

resource "yandex_dns_recordset" "a6" {
  zone_id = yandex_dns_zone.myvpc-zone.id
  name    = "alertmanager"
  type    = "A"
  ttl     = 90
  data    = [yandex_compute_instance.node01nginx.network_interface.0.nat_ip_address]
  depends_on = [yandex_compute_instance.node01nginx]
}
