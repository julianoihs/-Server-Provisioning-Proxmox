# Contrato de execução — Semaphore UI Community

## Objetivo

O Semaphore UI Community é o plano de controle da automação do laboratório.
Ele consulta a branch `dev-lab` do repositório GitHub a cada execução manual de
template. O GitHub permanece como fonte versionada de código e como executor
somente das verificações de qualidade e segurança do repositório.

Não há GitHub Actions runner, workflow de provisionamento nem job GitHub com
acesso ao laboratório neste ciclo.

## Limites da edição Community

Usar somente **Task Templates** iniciados manualmente. Workflows, project
runners e fontes externas de segredos são recursos de edição Pro e não fazem
parte deste desenho. Sem runners remotos configurados, o próprio servidor
Semaphore executa as tarefas; portanto ele precisa estar na rede administrativa
com acesso apenas aos destinos necessários.

Referências oficiais:

- [Task Templates](https://semaphoreui.com/docs/user-guide/task-templates)
- [Repositories](https://semaphoreui.com/docs/user-guide/repositories)
- [Key Store](https://semaphoreui.com/docs/user-guide/key-store)
- [Runners](https://semaphoreui.com/docs/admin-guide/runners)
- [Editions](https://semaphoreui.com/docs/editions)

## Fonte Git e acesso

1. Criar um projeto no Semaphore e cadastrar o repositório remoto em modo
   somente leitura, apontando para a branch `dev-lab`.
2. Para repositório privado, gerar no Key Store do Semaphore uma chave de
   implantação exclusiva, cadastrar **somente a chave pública** no GitHub e
   manter acesso de escrita desabilitado.
3. Não registrar token, senha, chave privada, URL interna, CA ou variável de
   infraestrutura no GitHub, no checkout ou em logs de tarefa.
4. O Key Store e a base persistente do Semaphore ficam no LXC e são protegidos
   pelo administrador da plataforma. O material secreto não é exportado nem
   reproduzido neste repositório.

## Templates manuais previstos

Os caminhos abaixo são contratos de integração. Eles só devem ser cadastrados
depois que os respectivos arquivos forem revisados e publicados.

| Nome | Aplicação | Caminho no repositório | Uso permitido agora |
| --- | --- | --- | --- |
| `Ansible — validação` | Ansible | `ansible/site.yml` | syntax-check com inventário e chave locais do Semaphore |
| `Terraform — validação` | Terraform/OpenTofu | `terraform/` | `init -backend=false`, `fmt -check` e `validate` |
| `Terraform — plano` | Terraform/OpenTofu | `terraform/` | manual, depois de configurar state local protegido e credencial de provisionamento mínima |
| `Terraform — aplicar` | Terraform/OpenTofu | `terraform/` | manual, separado do plano e sujeito a aprovação operacional |

O template Ansible recebe inventário, chave SSH e dados de `become` do Key Store
local; nada disso entra no Git. O template Terraform recebe credencial dedicada
de provisionamento e a CA por material local protegido. O token de auditoria do
preflight não pode ser usado para provisionar.

## State e serialização do Terraform

O state e qualquer plano devem estar fora do checkout e fora do GitHub, em
armazenamento persistente protegido do host Semaphore. A configuração de backend
e os valores sensíveis são locais. A etapa de `apply` só pode começar se houver
uma forma de locking ou uma regra operacional que garanta uma única execução
por vez; uma segunda execução concorrente deve ser bloqueada.

Versionar `.terraform.lock.hcl` é permitido e recomendado após revisão: ele fixa
as dependências e checksums do provider; não contém o state.

## Ordem de cadastro pelo administrador do Semaphore

1. Confirmar que o LXC e a persistência do Semaphore estão saudáveis após
   reinício.
2. Cadastrar a fonte Git somente leitura na branch `dev-lab` e validar um clone
   sem exibir dados de autenticação.
3. Criar inventário e credenciais Ansible no Key Store local.
4. Executar primeiro os templates de validação. Eles não podem fazer `apply`,
   `destroy`, nem modificar hosts.
5. Configurar state persistente, controle de concorrência e token mínimo de
   provisionamento antes de liberar plano ou aplicação Terraform.

## Critérios de aceitação

- O clone usa o commit atual de `dev-lab` e não tem permissão de escrita no
  repositório.
- Os templates de validação terminam sem dados sensíveis nos logs.
- As verificações GitHub continuam limitadas a qualidade e segurança do código;
  nenhuma delas acessa o laboratório.
- Não há `state`, plano, certificado, chave, token, senha, endpoint privado ou
  inventário real versionado.
