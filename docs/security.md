# Segurança do repositório e das pipelines

## Regra principal

Nenhuma chave, senha, token, certificado privado, arquivo `.env`, estado Terraform ou inventário com dados sensíveis deve ser versionado. A pipeline falha quando identifica tipos comuns desses arquivos ou chaves privadas.

## Pipelines

- **Repository validation**: valida a integridade Git, a estrutura base e erros de espaço em branco em `push` e pull request para `dev-lab`.
- **Security checks**: impede arquivos sensíveis, chaves privadas e formatos comuns de token em `push`, pull request, execução semanal e execução manual.
- **Dependabot**: abre atualizações semanais apenas para as GitHub Actions usadas pelas pipelines.

As ações externas usadas estão fixadas por SHA e o checkout não preserva a credencial temporária do GitHub Actions.

## Segredos de automação

Quando Packer, Terraform ou Ansible forem incluídos, os valores de acesso devem vir de um cofre local protegido no executor dedicado. Nunca copie valores para GitHub Actions Secrets, GitHub Actions Variables, arquivos `.tfvars`, variáveis de CI, inventários, commits, issues ou logs.

O preflight Proxmox lê um contrato local fora do checkout, em `/etc/proxmox-lab/preflight.env`, com permissão `0600` para o usuário do runner. O arquivo define URL HTTPS com nome DNS do certificado, token de API e caminho local para a CA; a CA também deve ter permissão `0600`. Os valores não são impressos, resumidos, enviados como artefato nem configurados no GitHub. A validação TLS permanece ativa.

O workflow `Proxmox preflight` só pode ser iniciado manualmente e só executa no runner dedicado com os rótulos `self-hosted`, `linux` e `proxmox-lab`. Ele não faz checkout do repositório, não aceita pull request/fork e consulta apenas os endpoints de versão e nós com `GET`.

## Proteções a habilitar no GitHub

No repositório, habilite **Secret scanning** e **Push protection**. Ao criar o fluxo de mudança, exija aprovação de pull request e sucesso das duas pipelines antes de aceitar alterações em `dev-lab`.

## Limites

As verificações reduzem erros comuns, mas não substituem revisão humana, proteção nativa contra segredos nem um cofre de segredos. Antes de adicionar uma nova integração, revise quais permissões mínimas ela precisa.
