Terraform module: proxmox LXC (scaffold)

Purpose:
- Create an LXC on ProxMox and optionally a ZFS dataset for persistent storage.
- This scaffold is intentionally minimal and commented so you can adapt provider details.

Usage:
- Put provider configuration in the root Terraform (`envs/production/backend.tf` / `provider.tf`).
- Call the module with required inputs: `name`, `cores`, `memory`, `disk_gb`, `storage_pool`, `template`, `network_bridge`, `ssh_public_key`.

Notes:
- This module contains an example `proxmox_lxc` resource block commented for reference. Adjust to the ProxMox provider version you use.
- Do not store secrets here; pass them via env vars or CI secrets.