# Server Provisioning Proxmox Lab

Laboratório para desenhar, registrar e validar o fluxo de provisionamento de servidores no Proxmox antes de qualquer adoção em outro ambiente.

## Estado

Estrutura inicial criada na branch `dev-lab`. O preflight Proxmox permanece manual neste ciclo; não há runner nem automação de provisionamento.

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
- `.github/ISSUE_TEMPLATE/task.md` — modelo de tarefa para o GitHub.
- `.github/workflows/` — validação e segurança executadas pelo GitHub Actions.

## Como começar

1. Registre as informações conhecidas do ambiente na tarefa de inventário.
2. Crie uma issue para cada decisão ou experimento usando o modelo de tarefa.
3. Execute mudanças no laboratório somente após definir critério de sucesso e reversão na issue.

## Fora de escopo nesta fase

- provisionamento automático;
- armazenamento de segredos no repositório;
- alterações no Proxmox sem tarefa aprovada e plano de reversão.
