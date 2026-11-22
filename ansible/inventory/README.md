# Inventário externo

Este diretório contém apenas o inventário vazio usado pelo `syntax-check`.
Os hosts, IPs, usuários e chaves são cadastrados no inventário e no Key Store
do Semaphore UI. Não criar arquivos de host com dados reais neste repositório.

O template Community deve selecionar o inventário do Semaphore e executar
`ansible/site.yml` contra o grupo `ubuntu_2404`.
