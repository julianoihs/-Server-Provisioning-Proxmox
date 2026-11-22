#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

require_file() {
  test -f "$root_dir/$1" || {
    echo "arquivo obrigatório ausente: $1" >&2
    exit 1
  }
}

require_text() {
  local file="$1"
  local pattern="$2"
  grep -Fq -- "$pattern" "$root_dir/$file" || {
    echo "contrato ausente em $file: $pattern" >&2
    exit 1
  }
}

require_file ansible/site.yml
require_file ansible/ansible.cfg
require_file ansible/requirements.yml
require_file ansible/inventory/README.md
require_file ansible/README.md
require_file terraform/main.tf
require_file terraform/providers.tf
require_file terraform/variables.tf
require_file terraform/outputs.tf
require_file terraform/README.md
require_file terraform/.terraform.lock.hcl

require_text ansible/site.yml "ansible.builtin.setup"
require_text ansible/site.yml "configure_baseline | bool"
require_text terraform/providers.tf "bpg/proxmox"
require_text terraform/providers.tf "insecure = false"
require_text terraform/README.md "fora do checkout"

if rg -n --hidden \
  -g '!**/.git/**' \
  -g '!**/.terraform/**' \
  -g '!tests/iac-contract.sh' \
  -e 'BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY' \
  -e 'insecure\s*=\s*true' \
  -e '(^|[^A-Za-z])(password|token|secret)\s*=\s*"[^"$][^"]+"' \
  "$root_dir/ansible" "$root_dir/terraform"; then
  echo 'material inseguro encontrado nos módulos de automação' >&2
  exit 1
fi

echo 'contrato de Ansible/Terraform aprovado'
