terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.32"
    }
    github = {
      source = "integrations/github"
      version = "~> 4.0"
    }
  }
}