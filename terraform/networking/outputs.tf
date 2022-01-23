output "kubernetes_private_network_id" {
  value = hcloud_network.kubernetes_private.id
}

output "kubernetes_private_network_subnet_id" {
  value = hcloud_network_subnet.kubernetes_private_subnet.id
}