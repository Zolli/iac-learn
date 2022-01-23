module "project_init" {
  source = "./project_init"

  hcloud_token = var.hcloud_token
  github_user  = var.github_user
}

module "networking" {
  source = "./networking"

  hcloud_token = var.hcloud_token
}

module "server_nodes" {
  source = "./server_nodes"

  hcloud_token                  = var.hcloud_token
  server_node_count             = var.server_node_count
  server_node_type              = var.server_node_type
  ssh_key_name                  = module.project_init.ssh_key_name
  kubernetes_private_network_id = module.networking.kubernetes_private_network_id
  placement_group_id            = module.project_init.placement_group_id
}

module "worker_nodes" {
  source = "./worker_nodes"

  hcloud_token                  = var.hcloud_token
  worker_node_count             = var.worker_node_count
  worker_node_type              = var.worker_node_type
  ssh_key_name                  = module.project_init.ssh_key_name
  kubernetes_private_network_id = module.networking.kubernetes_private_network_id
  placement_group_id            = module.project_init.placement_group_id
}