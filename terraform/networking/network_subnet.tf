resource "hcloud_network_subnet" "kubernetes_private_subnet" {
  ip_range     = hcloud_network.kubernetes_private.ip_range
  network_id   = hcloud_network.kubernetes_private.id
  network_zone = "eu-central"
  type         = "server"
}