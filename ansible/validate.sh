#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C.UTF-8
cd "$(dirname "$0")"
ansible-playbook -i inventory/placeholder.yml site.yml --syntax-check
