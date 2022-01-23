data "github_user" "github_user" {
  username = var.github_user
}

resource "hcloud_ssh_key" "ssh_key" {
  name       = "key_${var.github_user}"
  public_key = data.github_user.github_user.ssh_keys.0
}