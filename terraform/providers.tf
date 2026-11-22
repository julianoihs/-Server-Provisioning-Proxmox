terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.123.1"
    }
  }

  # O estado real é configurado fora do checkout via -backend-config.
  backend "local" {}
}

provider "proxmox" {
  # Endpoint e token vêm exclusivamente do ambiente protegido do Semaphore:
  # PROXMOX_VE_ENDPOINT e PROXMOX_VE_API_TOKEN.
  insecure = false
  min_tls  = "1.3"
}
