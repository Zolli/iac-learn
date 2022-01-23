variable "hcloud_token" {
  type        = string
  description = "The project access token for the hcloud project"
  sensitive   = true
}

variable "github_user" {
  type = string
  description = "The Github user account which first SSH key is used"
}