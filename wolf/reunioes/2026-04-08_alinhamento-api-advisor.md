# Reunião: Alinhamento API Advisor — Junior Juliano
**Data:** 2026-04-08

## Participantes
- Diogo Barbosa de Queiroz
- Gustavo Henrique Almeida Ferreira
- Marianna Lopes De Paula Luna
- Junior Juliano Da Silva (PicPay — dono da API Advisor)
- Caio De Oliveira Garcia
- + demais membros do grupo TCC

## Resumo
Reunião de alinhamento técnico com Junior Juliano, responsável pela API Advisor no PicPay. O grupo esclareceu dúvidas sobre quais serviços utilizar para os fluxos de push e listagem de clientes.

---

## API Advisor (`place offers advisor API`)

É a API central do fluxo de push. Endpoints confirmados:

| Endpoint | O que faz |
|----------|-----------|
| Listar ofertas | Ofertas disponíveis para o cliente específico |
| Criar push | Dispara o push pro cliente aprovar ou recusar |
| Enviar mensagem | Notificação que chega no app do cliente |
| Pesquisar ordens | Histórico de pushs gerados |
| Consultar ofertas | Ofertas que o assessor pode recomendar ao cliente |
| Simulação de resgate | Existe, mas fora do escopo do MVP |

---

## Como buscar a lista de clientes de um assessor

Não é via API Advisor. O fluxo correto é:
> **Buscar portfólios do gerente → de cada portfólio, extrair os clientes vinculados**

- A API específica é Java — Junior não confirmou exatamente qual
- Referência indicada: **Igor Barros**
- Alternativa: **Tiara** (Front-end) — mexe na tela que consulta esses endpoints

---

## Testes

- Existe uma doc com cURLs dos endpoints de push (Junior está revisando)
- **Atenção:** ofertas ficam inativas com o tempo. Para testar, buscar uma oferta válida no **Invest Place** e substituir no cURL antes de disparar o push

---

## Próximas etapas

- [ ] **Junior** — confirmar qual API Java gerencia permissões de assessores e lista de clientes
- [ ] **Junior** — limpar e atualizar doc dos endpoints de push com cURLs para testes
- [ ] **Time** — falar com **Tiara** e/ou **Igor Barros** sobre endpoints de listagem de clientes

---

## Impacto no modelo de dados

Valida a decisão de **não guardar ofertas no banco** — elas vêm da API Advisor em tempo real. A tabela `client_holdings` registra apenas o que foi efetivado. Modelo v3 alinhado. ✅
