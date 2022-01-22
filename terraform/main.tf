terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.32.2"
    }
    github = {
      source = "integrations/github"
      version = "~> 4.0"
    }
  }
}

variable "hcloud_token" {
  type        = string
  description = "The project access token for the hcloud project"
  sensitive   = true
}

variable "github_user" {
  type = string
  description = "The Github user account which first SSH key is used"
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "github" {}

data "github_user" "my_user" {
  username = var.github_user
}

resource "hcloud_network" "kubernetes_network" {
  ip_range = "10.0.0.0/16"
  name     = "network-kubernetes"
}

resource "hcloud_network_subnet" "kubernetes_netwok_subnet" {
  ip_range     = hcloud_network.kubernetes_network.ip_range
  network_id   = hcloud_network.kubernetes_network.id
  network_zone = "eu-central"
  type         = "server"
}

resource "hcloud_placement_group" "group_spread" {
  name = "group_spread"
  type = "spread"
}

resource "hcloud_ssh_key" "ssh_key_zolli" {
  name       = "key_zolli"
  public_key = data.github_user.my_user.ssh_keys.0
}

resource "hcloud_firewall" "firewall_kubernetes" {
  name = "firewall_kubernetes"

  rule {
    description = "Allow SSH In"
    direction   = "in"
    port        = 22
    protocol    = "tcp"
    source_ips  = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    description = "Allow ICMP In"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    description     = "Allow ICMP Out"
    direction       = "out"
    protocol        = "icmp"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    description     = "Allow DNS TCP Out"
    direction       = "out"
    port            = 53
    protocol        = "tcp"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    description     = "Allow DNS UDP Out"
    direction       = "out"
    port            = 53
    protocol        = "udp"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    description     = "Allow HTTP Out"
    direction       = "out"
    port            = 80
    protocol        = "tcp"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    description     = "Allow HTTPS Out"
    direction       = "out"
    port            = 443
    protocol        = "tcp"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    description     = "Allow NTP UDP Out"
    direction       = "out"
    port            = 123
    protocol        = "udp"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_server" "master-1" {
  image              = "ubuntu-20.04"
  name               = "master-1"
  server_type        = "cx11"
  datacenter         = "nbg1-dc3"
  ssh_keys           = ["key_zolli"]
  placement_group_id = hcloud_placement_group.group_spread.id
  firewall_ids       = [
    hcloud_firewall.firewall_kubernetes.id
  ]

  network {
    network_id = hcloud_network.kubernetes_network.id
  }

  depends_on = [
    hcloud_network_subnet.kubernetes_netwok_subnet,
    hcloud_firewall.firewall_kubernetes,
  ]
}