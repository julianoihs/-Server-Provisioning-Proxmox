# Server Provisioning Proxmox Lab

Laboratório para desenhar, registrar e validar o fluxo de provisionamento de servidores no Proxmox antes de qualquer adoção em outro ambiente.

## Estado

A automação do laboratório será executada manualmente pelo Semaphore UI
Community. O GitHub fornece a fonte versionada na branch `dev-lab` e mantém
somente verificações de qualidade e segurança; não há GitHub runner nem job com
acesso ao laboratório.

## Objetivo inicial

Manter as tarefas e decisões do laboratório rastreáveis enquanto são definidos:

- inventário e versão do Proxmox;
- rede, armazenamento e imagens-base disponíveis;
- método de criação de VMs e bootstrap inicial;
- automações futuras e seus critérios de validação.

## Estrutura

- `docs/architecture.md` — escopo e desenho inicial do laboratório.
- `docs/backlog.md` — tarefas iniciais e decisões pendentes.
- `docs/security.md` — regras para segredos e pipelines do repositório.
- `docs/proxmox-preflight-manual.md` — procedimento manual e somente leitura do preflight.
- `docs/semaphore-community.md` — contrato de execução manual pelo Semaphore UI Community.
- `.github/ISSUE_TEMPLATE/task.md` — modelo de tarefa para o GitHub.
- `.github/workflows/` — validação e segurança executadas pelo GitHub Actions.

## Como começar

1. Registre as informações conhecidas do ambiente na tarefa de inventário.
2. Crie uma issue para cada decisão ou experimento usando o modelo de tarefa.
3. Cadastre no Semaphore apenas templates manuais revisados; o contrato está em
   `docs/semaphore-community.md`.
4. Execute mudanças no laboratório somente após definir critério de sucesso e reversão na issue.

## Fora de escopo nesta fase

- armazenamento de segredos no repositório;
- alterações no Proxmox sem tarefa aprovada e plano de reversão.
