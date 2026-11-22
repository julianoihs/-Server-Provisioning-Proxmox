variable "node_name" {
  description = "Nome do nó Proxmox que receberá a VM."
  type        = string
}

variable "vm_id" {
  description = "VMID reservado previamente e confirmado como livre."
  type        = number

  validation {
    condition     = var.vm_id > 0
    error_message = "vm_id deve ser positivo e reservado antes do apply."
  }
}

variable "vm_name" {
  description = "Nome lógico da VM."
  type        = string
}

variable "template_vmid" {
  description = "VMID do template Ubuntu 24.04 existente."
  type        = number
}

variable "datastore_id" {
  description = "Storage Proxmox para disco e cloud-init."
  type        = string
}

variable "bridge" {
  description = "Bridge de rede já existente no Proxmox."
  type        = string
}

variable "cpu_cores" {
  description = "Quantidade de vCPU."
  type        = number
  default     = 2

  validation {
    condition     = var.cpu_cores >= 1
    error_message = "cpu_cores deve ser maior ou igual a 1."
  }
}

variable "memory_mib" {
  description = "Memória dedicada em MiB."
  type        = number
  default     = 2048

  validation {
    condition     = var.memory_mib >= 512
    error_message = "memory_mib deve ser maior ou igual a 512."
  }
}

variable "disk_size_gib" {
  description = "Tamanho do disco principal em GiB."
  type        = number
  default     = 32

  validation {
    condition     = var.disk_size_gib >= 8
    error_message = "disk_size_gib deve ser maior ou igual a 8."
  }
}

variable "ipv4_address" {
  description = "IPv4 e prefixo reservados no IPAM, por exemplo 192.0.2.10/24."
  type        = string
}

variable "ipv4_gateway" {
  description = "Gateway IPv4 da rede reservada."
  type        = string
}

variable "guest_username" {
  description = "Usuário administrativo inicial da VM."
  type        = string
  default     = "ubuntu"
}

variable "guest_ssh_public_keys" {
  description = "Chaves públicas da VM, fornecidas pelo Key Store do Semaphore."
  type        = list(string)
  default     = []
  sensitive   = true
}

variable "start_vm" {
  description = "Inicia a VM após criação; manter false até a aprovação do apply."
  type        = bool
  default     = false
}
