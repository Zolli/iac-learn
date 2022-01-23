resource "hcloud_network" "kubernetes_private" {
  ip_range = "10.0.0.0/16"
  name     = "kubernetes_private"
}