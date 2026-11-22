#!/usr/bin/env bash
set -euo pipefail
umask 077
: "${TF_LAB_DATA_DIR:?Set an absolute protected directory outside checkout}"
: "${TF_LAB_VARS_FILE:?Set an external variables file}"
cd "$(dirname "$0")"
root=$(pwd -P)
data=$(realpath -e "$TF_LAB_DATA_DIR")
vars=$(realpath -e "$TF_LAB_VARS_FILE")
case "$data/" in "$root/"*|"$(dirname "$root")/"*) echo 'Data must be outside checkout' >&2; exit 1;; esac
case "$vars" in "$(dirname "$root")/"*) echo 'Variables must be outside checkout' >&2; exit 1;; esac
[[ $(stat -c %a "$data") == 700 ]] || { echo 'Data directory requires mode 700' >&2; exit 1; }
[[ $(stat -c %a "$vars") == 600 ]] || { echo 'Variables require mode 600' >&2; exit 1; }
exec 9>"$data/proxmox.lock"
flock -n 9 || { echo 'Another task owns the lock' >&2; exit 1; }
export TF_DATA_DIR="$data/init"
export TF_IN_AUTOMATION=1
terraform init -input=false -lockfile=readonly -reconfigure -backend-config="path=$data/ubuntu2404.tfstate"
terraform plan -input=false -var-file="$vars" -out="$data/ubuntu2404.tfplan"
