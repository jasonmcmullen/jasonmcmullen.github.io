# Example scaffold for a ProxMox LXC resource.
# IMPORTANT: This is a template. Adjust fields to match the ProxMox Terraform provider version you use.

# Example (commented) proxmox_lxc resource:
# resource "proxmox_lxc" "this" {
#   node        = "proxmox-node-1"
#   hostname    = var.name
#   ostemplate  = var.template
#   cores       = var.cores
#   memory      = var.memory
#   rootfs      = "${var.storage_pool}:" + tostring(var.disk_gb) + "G"
#   net {
#     name = "eth0"
#     bridge = var.network_bridge
#     gw = "192.168.1.1" # optional
#     ip = "dhcp"        # or static: "192.168.1.50/24"
#   }
#   features {
#     nesting = true
#   }
#   # cloud-init / user-data injection depends on provider support; often passed via `ssh_keys`/`user_data` fields.
#   # metadata or config for cloud-init should be passed from the root module or using a template file.
# }

# Outputs should expose things you need downstream (example below uses generic placeholders).
locals {
  example_note = "Replace the commented resource with the provider resource block for your proxmox provider."
}

output "note" {
  value = local.example_note
}
