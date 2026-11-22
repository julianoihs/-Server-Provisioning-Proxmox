# Ansible — preflight Ubuntu 24.04

`site.yml` é o ponto de entrada do template Ansible do Semaphore UI.
Por padrão ele apenas coleta fatos mínimos e verifica que o alvo é Ubuntu 24.04
ou posterior. Não altera SSH, firewall, usuários, rede nem pacotes.

## Template Community

- Aplicação: **Ansible**
- Playbook: `ansible/site.yml`
- Inventário: inventário externo do Semaphore, com grupo `ubuntu_2404`
- Credenciais: chave SSH e, se necessário, `become` do Key Store local
- Execução normal: sem variáveis extras, somente tag `preflight`

Para permitir a baseline mínima de `ca-certificates` e `curl`, informe as duas
variáveis `configure_baseline=true` e `confirm_configuration=true`, e execute
somente após aprovação operacional. Não há inventory, IP, usuário, senha ou
chave neste repositório.

## Validação local

```bash
cd ansible
ansible-galaxy install -r requirements.yml
ansible-playbook --syntax-check site.yml
```

O `placeholder.yml` é vazio e existe apenas para a validação. O teste não se
conecta a hosts.
