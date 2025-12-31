Ansible role: nginx-proxy-manager

Purpose:
- Deploy `nginx-proxy-manager` as a docker-compose stack on the target host.
- This role copies a `docker-compose.yml` template, creates the data directory, and runs `docker compose up -d`.

Assumptions:
- Target host already has Docker and Docker Compose installed. Use a `roles/docker` or `roles/common` role to ensure that.
- Secrets (DB password, admin token) are provided via Ansible vault or CI secrets injected into `env`.

Example usage in `site.yml`:

- hosts: nginx-proxy
  roles:
    - role: nginx-proxy-manager
      vars:
        npm_env:
          DB_HOST: "db"
          DB_USER: "npm"

