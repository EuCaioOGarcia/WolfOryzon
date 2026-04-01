# Oryzon / TCC Invest — Contexto do Projeto

> Arquivo mantido pelo time. Atualize aqui sempre que houver mudança relevante de arquitetura, regras de negócio ou status. Commite e faça push — todos os membros recebem na próxima sessão.

---

## Visão Geral

Plataforma de gestão e acompanhamento de investimentos que permite assessores externos monitorar carteiras e enviar recomendações de produtos financeiros para clientes PicPay de forma eficiente, segura e alinhada à CVM 178.

**Problema resolvido:** o modelo atual restringe a atuação apenas a assessores internos, limitando escala. O Oryzon abre o ecossistema para assessores externos com controle, validação e governança.

---

## Perfis de Usuário

| Perfil | O que pode fazer |
|---|---|
| **Administrador** | Cadastrar e gerenciar assessores, configurar sistema, validar onboarding |
| **Assessor** | Visualizar carteiras de clientes vinculados, selecionar ofertas, enviar recomendações |
| **Gerente** | Acompanhar métricas de desempenho e conversão por assessor |

---

## Stack Técnica

> Preencher conforme o time definir

- **Frontend:** —
- **Backend:** —
- **Banco de dados:** —
- **Autenticação:** Google OAuth (sem senha própria — ADR-01)
- **Notificações:** Push notification no app do cliente
- **Hospedagem/Infra:** —

---

## Entidades Principais (MVP)

- **Usuário** — perfis: Administrador, Assessor, Gerente
- **Cliente** — usuário PicPay com carteira de investimentos
- **Oferta** — produto financeiro disponível (ex: CDB, LCA, LCI)
- **Recomendação** — seleção de ofertas feita pelo assessor para um cliente (status: pendente, aceita, recusada)
- **Carteira** — conjunto de produtos ativos do cliente
- **Métricas** — indicadores de conversão e desempenho por assessor

---

## Fluxos do MVP

### Fluxo de Recomendação
1. Assessor seleciona cliente vinculado
2. Assessor acessa a vitrine de produtos disponíveis
3. Assessor seleciona uma ou mais ofertas e edita valores de aplicação
4. Sistema valida saldo disponível do cliente antes do envio
5. Recomendação é enviada — cliente recebe notificação push
6. Cliente aceita (ou recusa) diretamente no app PicPay

### Fluxo de Cadastro de Assessor
1. Administrador cadastra o assessor na plataforma
2. Assessor autentica via Google
3. Assessor vinculado aos clientes que irá atender

### Visão Gerencial
- Gerente acessa painel com métricas por assessor
- Indicadores: recomendações enviadas, taxa de aceite, conversão, volume aplicado

---

## Regras de Negócio Críticas

- Assessor só acessa clientes que estão vinculados a ele
- Validação de saldo ocorre **antes** do envio da recomendação
- Notificação push é disparada após envio — aceite acontece no app do cliente
- Autenticação exclusivamente via Google OAuth (sem cadastro de senha)
- Plataforma não oferece aconselhamento financeiro personalizado — o papel do assessor é de recomendação dentro dos limites CVM 178

---

## Decisões Arquiteturais

| ADR | Decisão | Motivo |
|---|---|---|
| ADR-01 | Autenticação via Google OAuth | Sem gestão de senha própria, UX mais simples, segurança delegada ao Google |
| ADR-02 | Vitrine filtrada por elegibilidade | Evita que assessor recomende produto indisponível para o perfil do cliente |

> Adicione ADRs conforme forem tomadas decisões relevantes.

---

## Status do MVP

> Atualizar a cada sprint ou mudança relevante.

| Módulo | Status |
|---|---|
| Gestão de Acessos (cadastro + autenticação) | 🔲 Não iniciado |
| Fluxo de Recomendação | 🔲 Não iniciado |
| Vitrine de Produtos | 🔲 Não iniciado |
| Notificação Push + Aceite no App | 🔲 Não iniciado |
| Visão Gerencial | 🔲 Não iniciado |

---

## Fora do Escopo do MVP (visão ampliada)

- Consolidação de investimentos multi-instituição
- Análise de rentabilidade histórica
- Monitoramento contínuo automatizado de carteiras
- Governança avançada e relatórios regulatórios completos

---

## Convenções de Código

> Preencher conforme o time definir (naming, estrutura de pastas, padrões de PR, etc.)

---

## Contatos do Time

> Preencher com nome + papel + contato preferido de cada membro.

