# Segurança do repositório e das pipelines

## Regra principal

Nenhuma chave, senha, token, certificado privado, arquivo `.env`, estado Terraform ou inventário com dados sensíveis deve ser versionado. A pipeline falha quando identifica tipos comuns desses arquivos ou chaves privadas.

## Pipelines

- **Repository validation**: valida a integridade Git, a estrutura base e erros de espaço em branco em `push` e pull request para `dev-lab`.
- **Security checks**: impede arquivos sensíveis, chaves privadas e formatos comuns de token em `push`, pull request, execução semanal e execução manual.
- **Dependabot**: abre atualizações semanais apenas para as GitHub Actions usadas pelas pipelines.

As ações externas usadas estão fixadas por SHA e o checkout não preserva a credencial temporária do GitHub Actions.

## Segredos de automação

Quando Terraform ou Ansible forem incluídos, os valores de acesso devem vir do
Key Store local do Semaphore ou de armazenamento protegido administrado no LXC.
Nunca copie valores para GitHub Actions Secrets, GitHub Actions Variables,
arquivos `.tfvars`, variáveis de CI, inventários, commits, issues ou logs.

O preflight Proxmox é manual neste ciclo e usa somente o contrato local protegido do ambiente administrativo, fora do checkout. Ele contém URL HTTPS com nome DNS do certificado, token de API e CA local. Os valores não são impressos, resumidos, enviados como artefato nem configurados no GitHub. A validação TLS permanece ativa.

Não existe workflow de preflight nem runner no escopo atual. O procedimento
manual documentado consulta apenas versão e nós com `GET`.

O Semaphore Community consulta o GitHub para obter código, mas executa seus
templates manualmente no próprio servidor Semaphore. Os checks GitHub não
podem acessar o laboratório. Consulte o contrato em
`docs/semaphore-community.md` antes de cadastrar qualquer template.

State e planos Terraform devem permanecer fora do checkout, em persistência
protegida do Semaphore. O arquivo `.terraform.lock.hcl` pode ser versionado
após revisão; `*.tfstate*`, planos e backend com dados locais não.

## Proteções a habilitar no GitHub

No repositório, habilite **Secret scanning** e **Push protection**. Ao criar o fluxo de mudança, exija aprovação de pull request e sucesso das duas pipelines antes de aceitar alterações em `dev-lab`.

## Limites

As verificações reduzem erros comuns, mas não substituem revisão humana, proteção nativa contra segredos nem um cofre de segredos. Antes de adicionar uma nova integração, revise quais permissões mínimas ela precisa.
