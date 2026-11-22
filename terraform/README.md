# Terraform — VM Ubuntu 24.04 no Proxmox

Este módulo cria uma VM a partir de um template Ubuntu 24.04 já existente. Ele
usa o provider [`bpg/proxmox`](https://registry.terraform.io/providers/bpg/proxmox/0.123.1),
que declara suporte a Proxmox VE 9.x e Terraform 1.6+.

## Credenciais e TLS

O provider lê exclusivamente do ambiente protegido do Semaphore:

- `PROXMOX_VE_ENDPOINT` — URL HTTPS do Proxmox;
- `PROXMOX_VE_API_TOKEN` — token dedicado de provisionamento, com privilégio
  mínimo;
- CA corporativa instalada no trust store do LXC Semaphore.

O código fixa `insecure = false` e `min_tls = "1.3"`. Não use o token de
auditoria do preflight. Não grave esses valores em `tfvars`, no checkout ou no
GitHub.

## State, plano e serialização

O state e os planos ficam **fora do checkout**, em diretório persistente e
restrito do LXC Semaphore. O administrador configura o backend local em cada
execução de plano/aplicação e usa `flock` para serializar tarefas:

```bash
TF_LAB_DATA_DIR=/var/lib/semaphore/terraform-state \
TF_LAB_VARS_FILE=/var/lib/semaphore/secrets/ubuntu2404.tfvars \
  bash terraform/plan.sh
```

O script mantém o mesmo lock durante init e plan, recusa diretórios dentro do
checkout e exige permissões 700/600. Ele não executa apply. O plano pode conter
dados sensíveis; não o publique como artefato nem exponha logs a usuários sem acesso.


Se o lock já estiver ocupado, a tarefa deve falhar sem tentar um segundo plano
ou apply. O caminho local é exemplo operacional; permissões e retenção são
configurados pelo administrador do Semaphore, nunca no Git.

## Templates manuais Community

Crie templates nativos, sem YAML proprietário:

1. **Terraform — validação:** diretório `terraform/`; executar `terraform init
   -backend=false -input=false`, `terraform fmt -check -recursive` e
   `terraform validate`.
2. **Terraform — plano:** manual, com `flock`, backend externo ao checkout,
   variáveis locais e `terraform plan -out` em diretório protegido fora do Git.
3. **Terraform — aplicar:** manual e separado; usar o plano aprovado e o mesmo
   lock. Não liberar enquanto VMID, IP, template, token dedicado e ACL mínima
   não forem revisados.

O arquivo `terraform.tfvars.example` contém apenas valores de documentação e
não deve ser usado como configuração do laboratório.

## Validação local sem backend

```bash
cd terraform
terraform fmt -check -recursive
terraform init -backend=false -input=false
terraform validate
```

Esses comandos não chamam o Proxmox e não geram state remoto. `apply` e
`destroy` estão fora desta etapa.

## ACL mínima a revisar antes do apply

Crie token separado com permissões apenas para auditar nó/storage/bridge e
clonar/configurar/ligar a VM no escopo do laboratório. A lista exata depende
dos recursos habilitados e deve ser validada contra a documentação do provider
e do Proxmox antes da emissão. Não amplie o token de preflight.
