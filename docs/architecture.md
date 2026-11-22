# Arquitetura inicial do laboratório

## Propósito

O projeto concentra o planejamento e os experimentos de provisionamento para um ambiente Proxmox de laboratório. Ele é independente do projeto principal e não pressupõe integração com produção.

## Fluxo proposto

```text
Tarefa registrada -> definição do experimento -> alteração controlada no lab
-> validação -> registro do resultado -> próxima decisão
```

## Componentes a confirmar

| Componente | Informação necessária |
| --- | --- |
| Proxmox | versão, nós, cluster e permissões disponíveis |
| Rede | bridge/VLAN, DHCP ou IP estático, DNS e gateway |
| Armazenamento | datastore, capacidade e tipo de disco |
| Imagem-base | sistema operacional, origem e checksum |
| Acesso | conta de serviço, SSH e local seguro para segredos |
| Automação | ferramenta a avaliar após o inventário |

## Princípios

- Laboratório primeiro: nenhuma decisão depende de produção.
- Mudanças pequenas, reversíveis e documentadas.
- Segredos ficam fora do Git.
- Toda tarefa define validação e reversão antes da execução.
