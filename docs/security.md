# Segurança do repositório e das pipelines

## Regra principal

Nenhuma chave, senha, token, certificado privado, arquivo `.env`, estado Terraform ou inventário com dados sensíveis deve ser versionado. A pipeline falha quando identifica tipos comuns desses arquivos ou chaves privadas.

## Pipelines

- **Repository validation**: valida a integridade Git, a estrutura base e erros de espaço em branco em `push` e pull request para `dev-lab`.
- **Security checks**: impede arquivos sensíveis, chaves privadas e formatos comuns de token em `push`, pull request, execução semanal e execução manual.
- **Dependabot**: abre atualizações semanais apenas para as GitHub Actions usadas pelas pipelines.

As ações externas usadas estão fixadas por SHA e o checkout não preserva a credencial temporária do GitHub Actions.

## Segredos de automação

Quando Packer, Terraform ou Ansible forem incluídos, os valores de acesso devem vir de um cofre local protegido no ambiente administrativo. Nunca copie valores para GitHub Actions Secrets, GitHub Actions Variables, arquivos `.tfvars`, variáveis de CI, inventários, commits, issues ou logs.

O preflight Proxmox é manual neste ciclo e usa somente o contrato local protegido do ambiente administrativo, fora do checkout. Ele contém URL HTTPS com nome DNS do certificado, token de API e CA local. Os valores não são impressos, resumidos, enviados como artefato nem configurados no GitHub. A validação TLS permanece ativa.

Não existe workflow de preflight nem runner no escopo atual. O procedimento manual documentado consulta apenas versão e nós com `GET`; quando uma automação for retomada, ela exigirá revisão de segurança própria antes de ser adicionada ao GitHub.

## Proteções a habilitar no GitHub

No repositório, habilite **Secret scanning** e **Push protection**. Ao criar o fluxo de mudança, exija aprovação de pull request e sucesso das duas pipelines antes de aceitar alterações em `dev-lab`.

## Limites

As verificações reduzem erros comuns, mas não substituem revisão humana, proteção nativa contra segredos nem um cofre de segredos. Antes de adicionar uma nova integração, revise quais permissões mínimas ela precisa.
