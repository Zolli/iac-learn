output "placement_group_id" {
  value = hcloud_placement_group.group_spread.id
}

output "ssh_key" {
  value = hcloud_ssh_key.ssh_key.public_key
}

output "ssh_key_id" {
  value = hcloud_ssh_key.ssh_key.id
}

output "ssh_key_name" {
  value = hcloud_ssh_key.ssh_key.name
}