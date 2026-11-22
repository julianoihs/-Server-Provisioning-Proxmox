#!/usr/bin/env bash
set -euo pipefail

workflow=".github/workflows/proxmox-preflight.yml"

if [[ ! -f "$workflow" ]]; then
  printf 'FAIL: workflow ausente: %s\n' "$workflow" >&2
  exit 1
fi

require() {
  local pattern="$1"
  if ! grep -Fq -- "$pattern" "$workflow"; then
    printf 'FAIL: requisito ausente: %s\n' "$pattern" >&2
    exit 1
  fi
}

require 'workflow_dispatch:'
require 'permissions: {}'
require 'runs-on: [self-hosted, linux, proxmox-lab]'
require 'PROXMOX_PREFLIGHT_CONFIG_FILE'
require '/etc/proxmox-lab/preflight.env'
require '--cacert'
require '--request GET'
require '/api2/json/version'
require '/api2/json/nodes'

forbid() {
  local pattern="$1"
  if grep -Fq -- "$pattern" "$workflow"; then
    printf 'FAIL: item proibido no workflow: %s\n' "$pattern" >&2
    exit 1
  fi
}

forbid 'secrets.'
forbid 'vars.'
forbid 'environment:'
forbid 'actions/checkout'
forbid 'upload-artifact'
forbid 'GITHUB_STEP_SUMMARY'

if grep -Eq -- '(^|[[:space:]])(-k|--insecure)([[:space:]]|$)' "$workflow"; then
  printf 'FAIL: TLS inseguro não é permitido\n' >&2
  exit 1
fi

if grep -Eq -- '(^|[[:space:]])(POST|PUT|PATCH|DELETE)([[:space:]]|$)' "$workflow"; then
  printf 'FAIL: método mutável não é permitido\n' >&2
  exit 1
fi

printf 'PASS: contrato de segurança do preflight Proxmox\n'
