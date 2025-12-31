#!/usr/bin/env bash
# generate_inventory.sh
# Run from this directory or let the script cd into the terraform directory.
set -euo pipefail
TF_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${TF_DIR%/envs/example}"
OUTPUT_FILE="$REPO_ROOT/infrastructure/ansible/inventory/hosts"

cd "$TF_DIR"
if ! terraform output -json > /tmp/tfout.json 2>/dev/null; then
  echo "Error: terraform output failed. Make sure you ran 'terraform apply' in $TF_DIR."
  exit 1
fi

# Try to find an IP output: prefer explicit npm_ip, otherwise any output that ends with _ip or ip
IP=$(jq -r 'to_entries[] | select(.key=="npm_ip" or (.key|test("_ip$|ip$"))) | .value.value' /tmp/tfout.json | head -n1 || true)

if [ -z "$IP" ] || [ "$IP" = "null" ]; then
  echo "No suitable IP output found in terraform outputs. Available outputs:" >&2
  jq -r 'keys[]' /tmp/tfout.json >&2
  rm -f /tmp/tfout.json
  exit 2
fi

mkdir -p "$(dirname "$OUTPUT_FILE")"
cat > "$OUTPUT_FILE" <<EOF
[nginx-proxy]
npm ansible_host=$IP ansible_user=infrauser
EOF

echo "Wrote inventory to $OUTPUT_FILE"
rm -f /tmp/tfout.json
