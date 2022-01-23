module "project_init" {
  source = "./project_init"

  hcloud_token = var.hcloud_token
  github_user  = var.github_user
}