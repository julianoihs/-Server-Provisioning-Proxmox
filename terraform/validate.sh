#!/usr/bin/env bash
set -euo pipefail
umask 077
cd "$(dirname "$0")"
export TF_IN_AUTOMATION=1
terraform fmt -check -recursive
terraform init -backend=false -input=false -lockfile=readonly
terraform validate -no-color
