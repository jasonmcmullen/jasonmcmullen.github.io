terraform {
  required_version = ">= 1.4"
}

# Provider config should live here (provider "proxmox" {...}) with credentials from env vars or CI secrets.

module "npm_lxc" {
  source       = "../../modules/lxc"
  name         = "nginx-proxy-manager"
  cores        = 1
  memory       = 1024
  disk_gb      = 10
  storage_pool = "local-zfs"
  template     = "local:vztmpl/debian-12-standard_12.0-1_amd64.tar.gz"
  network_bridge = "vmbr0"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

# Example outputs
output "npm_name" {
  value = module.npm_lxc.name
}
