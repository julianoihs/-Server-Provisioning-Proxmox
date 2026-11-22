output "vm_id" {
  description = "VMID solicitado para a VM Ubuntu."
  value       = proxmox_virtual_environment_vm.ubuntu.vm_id
}

output "vm_name" {
  description = "Nome lógico da VM Ubuntu."
  value       = proxmox_virtual_environment_vm.ubuntu.name
}
