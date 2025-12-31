---
title: "Home Server Tools & Utilities — IaC Friendly Guide"
last_modified_at: 2025-12-30T22:50:00-05:00
categories:
  - Blog
tags:
  - Home Server
  - IaC
  - Tools
  - Terraform
  - Ansible
---

This short guide summarizes common home-server tools and utilities and gives simple, infrastructure-as-code (IaC) oriented steps to get each one running reproducibly. It draws on the common-service patterns from the TechHut list but is written in original, actionable form so you can follow with Terraform + Ansible patterns.

## Who?

Anyone running services at home who wants predictability and repeatability — whether you're rebuilding after hardware changes, migrating to new storage, or sharing your setup with others.

## What?

This covers small, well-known services and how I approach provisioning them with IaC:

- Reverse proxies (NGINX Proxy Manager / SWAG)
- DNS & ad-blocking (Pi-hole / AdGuard Home)
- Media stacks (Plex / Jellyfin + Radarr/Sonarr)
- File services (Nextcloud)
- Password managers (Vaultwarden)
- Home automation (Home Assistant)
- Monitoring (Prometheus / Grafana)
- Utility UIs (Portainer / Cockpit)
- Backups (restic + ZFS snapshots)

## When?

Start using IaC now if you plan to change configuration often, want easy recovery, or want to make your home lab reproducible for testing. IaC pays off quickly for repeatable deployments and safe rollbacks.

## Where?

Keep code in a simple repo structure so operators (or CI) can apply changes predictably:

- `infrastructure/terraform/` — modules and env roots
- `infrastructure/cloud-init/` — small userdata templates
- `infrastructure/ansible/` — roles and playbooks
- `infrastructure/apps/<app>/` — compose files and app configs

## Why IaC for these tools?

- Reproducible: define VMs/LXCs, storage, and networks in Terraform so rebuilds are identical.
- Auditable: source control captures changes and reasoning.
- Safe: combine `terraform plan` with ZFS snapshots and Ansible convergence to reduce blast radius.

## How? (simple, repeatable steps for each service)

The short pattern I use for every service below is: Terraform → Snapshot → Apply → Ansible.

1. Terraform: define a small module for the service host

```hcl
module "vaultwarden" {
  source = "../modules/lxc"
  name   = "vaultwarden"
  cores  = 1
  memory = 1024
  disk_gb = 10
  userdata = file("../../cloud-init/vaultwarden.yaml")
}
```

2. Plan and review

```bash
cd infrastructure/terraform/envs/example
terraform init
terraform plan -out=tfplan
terraform show -no-color tfplan
```

3. Snapshot storage (quick rollback safety)

```bash
ssh proxmox sudo zfs snapshot rpool/data/vaultwarden@pre-$(date +%Y%m%d-%H%M)
```

4. Apply Terraform

```bash
terraform apply tfplan
```

5. Generate inventory and run Ansible

```bash
./generate_inventory.sh   # writes infrastructure/ansible/inventory/hosts
cd ../../ansible
ansible-playbook -i inventory/hosts site.yml --limit vaultwarden
```

6. Verify service, then add monitoring and backups

- Smoke-test HTTP endpoints or ports.
- Ensure `restic` jobs or scheduled ZFS snapshot retention exist for the dataset.

## Quick notes for specific utilities

- Reverse proxy: run as a container behind a small LXC. Declare the proxy host in Terraform, deploy `docker-compose` with Ansible, and use LetsEncrypt DNS or HTTP challenge automated in the compose.
- DNS/ad-blocking: Pi-hole works well in a single, lightweight container. Give it a static IP via Terraform outputs so DHCP/DNS updates are stable.
- Media & file services: create a ZFS dataset per service in Terraform, mount it into the container/VM, and manage permissions with Ansible to avoid drift.
- Vaultwarden: treat secrets via CI secrets or `ansible-vault` and mount the data volume from a dataset created by Terraform.
- Home Assistant: if you need USB passthrough, prefer an LXC or VM declared in Terraform with device passthrough enabled; cloud-init + Ansible can ensure correct drivers and user groups.

## Backups & safety

- Always take a ZFS snapshot before any `apply` that touches disks.
- Use `restic` to ship encrypted backups off-site; store `RESTIC_PASSWORD` and backend creds in your secret manager.

## Testing & CI

- Run `terraform fmt`/`validate` and `ansible-lint` in PR checks.
- Run `terraform plan` in CI and require manual approvals for `apply` runs that target `production` environment.

## Where to go next

- Scaffold a `modules/lxc` and a small `envs/test` Terraform root to try one service without affecting production.
- Build a single Ansible role per app (`roles/vaultwarden`, `roles/nginx-proxy-manager`) so they are reusable and testable locally.

### #KeepItSimple

This guide is intentionally short — pick one service, write a module + role for it, and repeat the pattern.

```
