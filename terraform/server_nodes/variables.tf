variable "hcloud_token" {
  type        = string
  description = "The project access token for the hcloud project"
  sensitive   = true
}

variable "server_node_count" {
  type        = number
  description = "The number of server nodes to create"
  default     = 1
}

variable "server_node_type" {
  type        = string
  description = "The type of server to use as the server nodes"
  default     = "cx11"
}

variable "kubernetes_private_network_id" {
  type        = number
  description = "The private network ID where the server is attached to"
}

variable "ssh_key_name" {
  type        = string
  description = "The SSH key name that is used. Must be present in the current project"
}

variable "location_short_name" {
  type        = string
  description = "The short name of the location (ex. fsn1, nbg1)"
  default     = "fsn1"
}

variable "placement_group_id" {
  type = number
  description = "The placement group that is used during the server provisioning"
}

variable "image_name" {
  type        = string
  description = "The image that will be used to provision the server"
  default     = "ubuntu-20.04"
}