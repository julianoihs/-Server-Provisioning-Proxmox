# Preflight manual do Proxmox

## Escopo atual

O preflight é executado manualmente por um operador autorizado no ambiente do laboratório. Não há GitHub Actions self-hosted, runner dedicado ou execução remota neste ciclo.

## Limites de segurança

- Use somente o token de auditoria com menor privilégio, armazenado fora do repositório.
- Use a CA do cluster e o nome DNS coberto pelo certificado; nunca use `-k` ou `--insecure`.
- Não copie URL privada, token ou CA para GitHub, checkout, issue, log, artefato ou histórico de terminal.
- Faça apenas consultas `GET` de versão e nós. Não crie, altere ou remova VMs.

## Procedimento

1. Use a estação ou host administrativo que já possui o contrato local protegido preparado pela equipe de virtualização.
2. Confirme que o DNS do Proxmox resolve localmente e que a CA valida o certificado antes de autenticar.
3. Execute as consultas somente leitura aos endpoints de versão e nós com a ferramenta local aprovada, usando a CA e o token fora do checkout.
4. Registre somente a evidência sanitizada: sucesso/falha, versão e quantidade/estado geral de nós. Nunca registre endpoint, cabeçalho de autorização, token ou conteúdo da CA.
5. Em falha de TLS, DNS ou autenticação, interrompa a execução; não desative a validação TLS e não tente chamadas mutáveis.

## Critério de êxito

O preflight é considerado aprovado quando as duas consultas `GET` autenticadas respondem com TLS válido. Essa aprovação é local e manual; ela não representa execução de pipeline no GitHub.
