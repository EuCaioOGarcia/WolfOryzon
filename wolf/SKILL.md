---
name: "Oryzon — TCC Invest"
description: >
  Base de conhecimento completa do projeto Oryzon/TCC Invest (PicPay + Germinare).
  Plataforma web de assessoria de investimentos para assessores externos.
  Cobre perfis (Admin, Assessor, Gerente, Cliente), fluxo de recomendação ponta
  a ponta, regras do Invest Place, vínculo cliente-assessor, escopo MVP vs pós-MVP,
  decisões de arquitetura (React, MySQL, Oracle Cloud, Keycloak, Apollo DS),
  segurança (CVM 178, Roger Oberdan) e equipe. Use para responder dúvidas sobre
  regras de negócio, fluxos, decisões técnicas, terminologia oficial e roadmap do projeto.
  Triggers: oryzon, tcc invest, assessor externo, recomendação de investimento,
  invest place, horizon, fluxo de push, vitrine de ofertas, vínculo cliente.
activation: auto
metadata:
  author: caio.garcia
  version: "1.0.0"
  category: product
  tags: oryzon,tcc-invest,investimentos,assessor,picpay,germinare,cvm178
---

## Contexto

Projeto TCC Invest do Germinare em parceria com o PicPay Invest.
Plataforma web para assessores externos recomendarem produtos de investimento a clientes PicPay.

**Problema:** O modelo atual restringe assessores apenas ao quadro interno. A CVM 178 exige governança clara para assessores externos.

**Solução:** Plataforma controlada com assessores externos cadastrados que visualizam carteiras de clientes PicPay e enviam recomendações via push notification.

---

## Perfis de Usuário

| Perfil | Responsabilidades |
|--------|------------------|
| **Administrador** | Cadastra/gerencia assessores, define permissões, acessa painel gerencial com métricas |
| **Assessor** | Visualiza carteira de clientes vinculados, acessa vitrine de ofertas, envia recomendações via push |
| **Gerente** | Acompanha desempenho dos assessores e métricas de conversão |
| **Cliente** | Usuário PicPay que recebe push e aceita/recusa recomendações no app |

---

## Fluxo de Recomendação (ponta a ponta)

1. Assessor acessa a plataforma (autenticado via AD/Keycloak)
2. Visualiza lista de clientes vinculados
3. Acessa carteira do cliente (custódias ativas, saldo investido)
4. Acessa vitrine de ofertas via API do Invest Place (exige `Consumer ID` do cliente)
5. Seleciona oferta(s), define valor sugerido, escreve mensagem personalizada (opcional)
6. Confirma → sistema cria ordem no Invest Place + dispara push ao cliente
7. Cliente recebe push no app PicPay → visualiza detalhes → aceita com biometria/FaceID ou recusa
8. Sistema valida saldo antes de completar; se insuficiente, exibe mensagem
9. Assessor recebe notificação por e-mail (MVP) quando cliente aceitar/recusar

---

## Invest Place — Integração

- **3 chamadas essenciais:** listar ofertas → criar ordem → disparar push
- Validações de saldo, mínimo, máximo e múltiplo acontecem **no front-end** (dados da resposta de listagem)
- Dados de ofertas **não são duplicados** no banco local — consumir diretamente via API
- Para push fora do Focus: usar **usuário sistêmico genérico** (ex: ID 600) no MVP
- Contato push/documentação Confluence: **Mauro Rodrigues Borges**
- Contato time Comercial para criação do usuário sistêmico: **Michael**

### Regras de validação do push

| Regra | Detalhe |
|-------|---------|
| Duração | 1h, 6h, 8h ou 1 dia (1 dia com cautela — ofertas podem mudar) |
| Validade | Cada oferta tem prazo próprio, não geral |
| Múltiplo | Valor deve ser múltiplo definido pela oferta. Sistema sugere valor compatível se não respeitado |
| Máximo | Limitado pela disponibilidade da Trend ou contrato da oferta |
| Push ≠ investimento | Cliente ainda precisa confirmar com 2º fator (FaceID) |

---

## Vínculo Cliente-Assessor

- Cliente vincula ao assessor via app PicPay digitando código único do assessor
- Cliente pode trocar ou remover vínculo a qualquer momento
- Assessor pode aceitar ou recusar vínculo (controle de carga)
- Assessor vê apenas **saldo em investimentos (custódia)** — não dados bancários gerais (CVM 178)
- Relacionamento preservado com campo `status` (ativo/inativo) — nunca apagar, apenas desativar

---

## Decisões de Arquitetura

### Autenticação
- **MVP (assessores internos):** Active Directory (AD) via SSO — cadastrar ID da aplicação no AD e definir grupos autorizados
- **Pós-MVP (assessores externos):** Keycloak (KCL) — já usado na plataforma PJ. AD descartado para externos: burocracia, custo de licenciamento, necessidade de VPN + EDR
- MFA/OTP/bloqueio por tentativa: incluso nativamente no AD para internos
- Contatos Keycloak (Gatekeepers): **Mina ou Liso**

### Infraestrutura
- Hospedagem na **Oracle Cloud**, padrão **Moonlight**, com CI/CD
- Começar com **um único microsserviço centralizado (BFF)** — não dois separados
- Validar com **Dani Amaral** se usa endpoints existentes do Invest Place ou cria novo BFF focado em assessoria

### Banco de Dados
- **MySQL** para tabelas do sistema (User, Client, Advisor-Client, Recommendations)
- Métricas complexas e analytics → Data Lake / MongoDB (não tabelas relacionais)
- **Triggers nativos do MySQL** para auditoria (não tabela de log manual)
- Nome do banco/projeto no Confluence: **Horizon**

### Frontend
- **React** (maioria do time tem experiência)
- Arquitetura **MVVM** (a definir com tech lead de front)
- Design System: **Apollo** (PicPay) — storybook do Apollo para componentes
- Referência visual: **HeroDash** (menu lateral, cards, tabelas, chips de filtro, side sheet)
- Contato Apollo/HeroDash: **Lunna Bergami Luiz**

---

## Escopo MVP vs Pós-MVP

### MVP ✅
- Cadastro de usuários (Admin, Assessor, Gerente) com login AD/Google
- Gestão de assessores: cadastrar, ativar/desativar, importar via CSV/Excel
- Código único de assessor (ex: A1234) gerado automaticamente
- Listagem de clientes vinculados com status
- Visualização de carteira do cliente (custódias, sem gráficos)
- Vitrine de ofertas por cliente (via Consumer ID)
- Fluxo de recomendação: selecionar oferta + valor + mensagem → enviar push
- Acompanhamento de recomendações: status enviada / aceita / recusada / expirada
- Aceite/recusa no app do cliente com 2º fator
- Notificação ao assessor por **e-mail** no aceite/recusa
- Termo de ciência CVM 178 (genérico, PDF assinado no pós-MVP)
- Painel gerencial básico (total de clientes vinculados por assessor)

### Pós-MVP ⏳
- Dashboards e gráficos comparativos na vitrine
- Notificações em tempo real (popup) na plataforma
- Granularidade de permissões por campo no vínculo cliente-assessor
- Recomendações por IA (contatar time de dados "cacaus")
- Autenticação de assessores externos via Keycloak
- Relatórios periódicos (semanal/mensal) de conversão

### Fora do escopo 🚫
- Modificar fluxo de push/aceite existente no app do cliente
- Dados bancários além de investimentos
- Integração com WhatsApp ou outros canais
- Clientes não-PicPay

---

## Segurança (Alinhamento com Roger Oberdan)

- Dados financeiros do cliente devem ser **minimamente exibidos e anonimizados** (alta/média/baixa em vez de valores exatos quando possível)
- Exibir valores associados a CPF exige validação jurídica e contrato
- Controles obrigatórios: **rate limit** e/ou **reCAPTCHA** para prevenir extração por bots
- Validação jurídica necessária para acesso de terceiros/PJs
- Contato jurídico (privacidade): **Priscila**
- Assessor externo **não deve ver:** endereço do cliente, dados bancários não relacionados a investimentos

---

## Terminologia Oficial

| Termo | Definição |
|-------|-----------|
| **Oferta** | Produto disponível para investimento (antes da compra) |
| **Custódia** | Produto já adquirido (investimento efetivado) |
| **Ordem** | Intenção de compra criada no Invest Place |
| **Push** | Notificação enviada ao cliente para aceite |
| **Consumer ID** | ID do cliente no sistema PicPay (obrigatório para vitrine e push) |
| **Focus** | Sistema interno de gestão de assessores internos |
| **Invest Place** | Marketplace interno de produtos de investimento |
| **Horizon** | Nome do projeto no Confluence |

---

## Equipe

| Nome | Papel |
|------|-------|
| Angelo Luis Rodrigues Da Silva | Tech Lead / Arquiteto |
| Murilo Viviani | PO / Referência de produto |
| Giovanne Antony Bahia Torquato | Tech / Engenharia |
| Marianna Lopes De Paula Luna | Produto / Histórias de usuário |
| Diogo Barbosa de Queiroz | Tech / Frontend |
| Gustavo Henrique Almeida Ferreira | Tech / Requisitos |
| Caio De Oliveira Garcia | Tech |
| Petherson Martins Costa | Tech / Frontend |
| Joyce Nicole Pereira Santana | Design / Produto |
| Roger Oberdan | Segurança corporativa |
| Mauro Rodrigues Borges | Referência push / Invest Place |
| Lunna Bergami Luiz | Design System Apollo / HeroDash |
| Dani Amaral | Arquitetura / Banco de dados |
| Raíssa | Focus / Dashboards |
| Lucas Sala | Design |

---

## Limites do Agente

- Não oferecer aconselhamento ou recomendação de investimento personalizada
- Não expor dados sensíveis de clientes, assessores ou credenciais
- Não contradizer diretrizes regulatórias (CVM 178); quando ambíguo, remeter à área responsável
- Não inventar comportamentos, integrações ou regras não definidas; quando incerto, declarar e pedir esclarecimento
- Não garantir prazos ou escopo sem validação do time
