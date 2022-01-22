terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.32.2"
    }
  }
}

variable "hcloud_token" {
  type        = string
  description = "The project access token for the hcloud project"
  sensitive   = true
}

provider "hcloud" {
  token = var.hcloud_token
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEx60XjFcsAk1n2C8+1RtQ/J3p+eJWlCIBCsI8LMnVoWcLdf7MgSqteAPuvUoUC5MW6AaumlDiVj0Grl5NYrgC7nm2g9dbKZJURtNtAngWqSJoDOxXLvwyuNsat2JMKnpeLPpeZVNT5EhbKnaBJ+uOZLm/ZBhx9OwTovEudKfidYt1oAd+u6rTZ5CgUP3jwJLTSYDxy4NT9W9wZMxBcR6ev90k9crs4fL4ZTReGtW/EFLoJ/X8cRX0j5A4GV4aKy/lBWgUnqMgNZJZZLGB2FnkumzjqE+c20jr6BRij82opI3/1DcQO0dzlkaSDCUcZK/kS46hfyCtJpgCBmpVohSRarTZJJUvLqjXuj7O6VJOV5FYqTDqmuJkPNHUZWzikZxn51xyYAhzcU9PnEXdaWgNaoZiyYiYyOGuyDuwSnp8/rYwSnDwGS0Y4NS63xO04rEOUNpdMbqu0EJseISAH0bz8aWka7+kBopbG58FU3SyNfxYGqIx27nuCLgvRbsH/IZDF/WmrODZJMXaK5haQeX/N28SPTTt35VFCSjGnQBMPCplH417KQVrp2SWeQgpVfo2grrRykpx9RnhKO0HgP7hdJR2TqrZ1wiGDp6kUIYqr6xXdZOm1KVGN+21eu5dNw6ndFp0DoyskXHnu7qX0dlVlHf6PbdO4wzHnHD/psTBsQ== zolli07@gmail.com"
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