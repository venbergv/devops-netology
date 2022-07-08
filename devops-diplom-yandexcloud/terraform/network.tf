# My Network
resource "yandex_vpc_network" "myvpc-net" {
  name = "myvpc"
}

# My Public Subnet in zone b
resource "yandex_vpc_subnet" "pub-subnet" {
  name = "pubsubnet"
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.myvpc-net.id}"
  v4_cidr_blocks = ["192.168.100.0/24"]
}

# Routing Table for Private Subnet
resource "yandex_vpc_route_table" "natinst" {
  network_id = "${yandex_vpc_network.myvpc-net.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.100.11"
  }
}

# My Private Subnet in zone a
resource "yandex_vpc_subnet" "priv-subnet" {
  name = "privsubnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.myvpc-net.id}"
  route_table_id = "${yandex_vpc_route_table.natinst.id}"
  v4_cidr_blocks = ["192.168.101.0/24"]
}
