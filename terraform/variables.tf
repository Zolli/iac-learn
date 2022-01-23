variable "hcloud_token" {
  type        = string
  description = "The project access token for the hcloud project"
  sensitive   = true
}

variable "github_user" {
  type = string
  description = "The Github user account which first SSH key is used"
}

variable "server_node_count" {
  type        = number
  description = "The number of server nodes to create"
  default     = 1
}

variable "server_node_type" {
  type = string
  description = "The type of server to use as the server nodes"
  default = "cx11"
}

variable "worker_node_count" {
  type        = number
  description = "The number of worker nodes to create"
  default     = 1
}

variable "worker_node_type" {
  type = string
  description = "The type of server to use as the worker nodes"
  default = "cx11"
}