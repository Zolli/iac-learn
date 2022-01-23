data "hcloud_location" "server_expected_location" {
  name = var.location_short_name
}

resource "hcloud_server" "worker_node" {
  count              = var.worker_node_count
  image              = var.image_name
  location           = data.hcloud_location.server_expected_location.name
  placement_group_id = var.placement_group_id
  name               = "kubernetes-worker-${count.index}"
  server_type        = var.worker_node_type

  ssh_keys           = [var.ssh_key_name]
  labels             = {
    kubernetes_role = "worker"
  }
}

resource "hcloud_server_network" "kubernetes_private_network" {
  count      = var.worker_node_count
  network_id = var.kubernetes_private_network_id
  server_id  = hcloud_server.worker_node[count.index].id
}