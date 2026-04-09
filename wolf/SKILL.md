# Oryzon / TCC Invest — Base de Conhecimento

> ⚠️ **INSTRUÇÃO OBRIGATÓRIA — EXECUTAR ANTES DE QUALQUER RESPOSTA**
>
> Este contexto vive no GitHub. Antes de responder qualquer pergunta sobre o projeto, o agente **deve**:
>
> 1. Verificar se o repo está clonado localmente:
>    ```bash
>    ls ~/WolfOryzon 2>/dev/null || echo "NÃO CLONADO"
>    ```
> 2. Se não estiver clonado — orientar o usuário:
>    ```bash
>    git clone https://github.com/EuCaioOGarcia/WolfOryzon.git
>    cd WolfOryzon && bash wolf/scripts/setup.sh
>    ```
> 3. Se estiver clonado — executar `git pull` silenciosamente e recarregar este arquivo:
>    ```bash
>    cd ~/WolfOryzon && git pull
>    ```
> 4. Só depois responder — sempre com base na versão mais recente do arquivo.
>
> **Nunca responder com base em contexto em cache sem verificar o GitHub primeiro.**

---

Projeto TCC Invest do Germinare em parceria com o PicPay Invest.  
Plataforma web para assessores externos de investimentos recomendarem produtos a clientes PicPay.

---

## Visão Geral do Projeto

**Problema:** O modelo atual restringe a atuação de assessores apenas ao quadro interno, limitando escalabilidade. A CVM 178 exige governança clara para assessores externos.

**Solução:** Plataforma controlada onde assessores externos cadastrados podem visualizar carteiras de clientes PicPay e enviar recomendações de investimento via push notification.

**Regulação:** CVM 178 — define parâmetros para atuação de assessores de investimentos no Brasil.

---

## Perfis de Usuário

| Perfil | Responsabilidades |
|--------|------------------|
| **Administrador** | Cadastra e gerencia assessores, define permissões, acessa painel gerencial com métricas |
| **Assessor** | Visualiza carteira de clientes vinculados, acessa vitrine de ofertas, envia recomendações via push |
| **Gerente** | Acompanha desempenho dos assessores e métricas de conversão |
| **Cliente** | Usuário PicPay que recebe push e aceita/recusa recomendações no próprio app |

---

## Decisões de Arquitetura (das reuniões)

### Autenticação
- **Assessores internos (MVP):** Active Directory (AD) da PicPay via Single Sign-On. Não requer implementação extra — cadastrar ID da aplicação no AD e definir grupos autorizados.
- **Assessores externos (pós-MVP):** Keycloak (KCL) — já usado na plataforma PJ. AD descartado para externos por burocracia, custo de licenciamento e necessidade de VPN + EDR.
- **Autenticação via Google** foi discutida para login de assessores (similar ao Invest Play Admin / conta Microsoft).
- **MFA/OTP/bloqueio por tentativa:** já incluso nativamente no AD para internos.

### Infraestrutura
- Hospedagem na **Oracle Cloud**, padrão **Moonlight**, com CI/CD.
- **Arquitetura evolutiva:** começar com **um único microsserviço centralizado** (BFF), não dois separados. Validar com Dani Amaral se usa endpoints existentes do Invest Place ou cria novo BFF focado em assessoria.

### Banco de Dados
- **MySQL** para tabelas do sistema (User, Client, Advisor-Client, Recommendations).
- **Tabela intermediária Advisor/Client** com campo `status` (ativo/inativo) para preservar histórico de vínculos — nunca apagar relacionamentos, apenas desativar.
- Dados de ofertas **não são duplicados** no banco local — consumir diretamente do Invest Place via API.
- Métricas complexas e analytics → delegadas a Data Lake / MongoDB, não em tabelas relacionais.
- **Triggers nativos do MySQL** para auditoria em vez de tabela de log manual.
- Nome do banco/projeto no Confluence: **Horizon**.

### Frontend
- **React** (maioria do time tem experiência).
- Arquitetura **MVVM** (a definir com suporte de um tech lead de front).
- Design System: **Apollo** (PicPay) — usar storybook do Apollo para componentes. Referência visual: HeroDash (menu lateral, cards, tabelas, chips de filtro, side sheet para filtros complexos).

---

## Fluxo de Recomendação (ponta a ponta)

1. Assessor acessa a plataforma web (autenticado via AD/Keycloak).
2. Visualiza lista de clientes vinculados.
3. Acessa carteira do cliente (custódias ativas, saldo investido).
4. Acessa vitrine de ofertas (consome API do Invest Place — exige `Consumer ID` do cliente).
5. Seleciona oferta(s), define valor sugerido, escreve mensagem personalizada (opcional).
6. Confirma → sistema chama API do Invest Place para criar ordem + dispara push notification ao cliente.
7. Cliente recebe push no app PicPay → visualiza detalhes (produto, valor) → aceita com biometria/FaceID ou recusa.
8. Sistema valida saldo antes de completar; se insuficiente, exibe mensagem.
9. Assessor recebe notificação (MVP: por e-mail; pós-MVP: real-time via popup na plataforma).

---

## Invest Place (sistema legado integrado)

- Funciona como **marketplace centralizado de produtos de investimento** (CDB, renda fixa, fundos, LCI, LCA, etc.).
- Normaliza ofertas de múltiplos sistemas de origem.
- Sabe para onde redirecionar cada ordem de execução.
- **3 chamadas essenciais ao backend:** listar ofertas → criar ordem → disparar push.
- Validações de saldo, mínimo, máximo e múltiplo acontecem **no front-end**, usando dados da resposta de listagem de ofertas.
- Para envio de push fora do Focus: usar **usuário sistêmico genérico** (ex: ID 600) no MVP. Validar com time Comercial (Michael) a criação desse usuário.
- Documentação do fluxo de push está no Confluence (Mauro Rodrigues Borges é o contato).

### Regras de validação do push
- **Duração:** 1h, 6h, 8h ou 1 dia (usar 1 dia com cautela — ofertas podem mudar).
- **Validade por oferta:** cada oferta tem prazo de validade próprio, não geral.
- **Múltiplo:** valor de aplicação deve ser múltiplo definido pela oferta (ex: R$1.000). Sistema sugere valor compatível se não respeitado.
- **Máximo:** limitado pela disponibilidade da Trend ou contrato da oferta.
- Push ≠ investimento. O cliente ainda precisa confirmar com 2º fator (FaceID).

---

## Vínculo Cliente-Assessor

- Cliente se vincula ao assessor via app PicPay digitando código/credencial única do assessor.
- Cliente pode trocar ou remover vínculo a qualquer momento.
- Assessor pode aceitar ou recusar vínculo (para controlar carga de clientes).
- Vínculo conforme **CVM 178**: assessor só vê saldo em investimentos (custódia), não dados bancários gerais.
- Permissões de acesso a dados do cliente: para MVP, conjunto fixo pré-definido. Granularidade por campo (CPF, e-mail, saldo, cofrinho) fica para V2.

---

## Segurança (Alinhamento com Roger Oberdan — 25/03)

- Acesso de assessores externos via **Keycloak** (já usado no PJ). AD descartado.
- Dados financeiros do cliente devem ser **minimamente exibidos e anonimizados** (usar classificações como alta/média/baixa em vez de valores exatos quando possível).
- Exibir valores associados a CPF exige validação jurídica e contrato.
- Controles obrigatórios: **rate limit** e/ou **reCAPTCHA** para prevenir extração por bots.
- Validação jurídica necessária para acesso de terceiros/PJs — equipe jurídica deve formular contrato com finalidade de acesso definida.
- Contato jurídico: **Priscila** (privacidade). Contato Gatekeepers (KCL): **Mina ou Liso**.
- Assessor externo não deve ver: endereço do cliente, dados bancários não relacionados a investimentos.

---

## Escopo MVP vs Pós-MVP

### MVP (must have)
- Cadastro de usuários (Admin, Assessor, Gerente) com login AD/Google.
- Gestão de assessores: cadastrar, ativar/desativar, importar via CSV/Excel.
- Código único de assessor (ex: A1234) gerado automaticamente.
- Listagem de clientes vinculados com status.
- Visualização de carteira do cliente (custódias, sem gráficos).
- Vitrine de ofertas por cliente (via Consumer ID).
- Fluxo de recomendação: selecionar oferta + valor + mensagem → enviar push.
- Tela de acompanhamento de recomendações com status (enviada, aceita, recusada, expirada).
- Aceite/recusa no app do cliente com 2º fator.
- Notificação para assessor por **e-mail** quando cliente aceitar/recusar.
- Termo de ciência CVM 178 (genérico para MVP, PDF assinado depois).
- Painel gerencial básico (total de clientes vinculados por assessor).

### Pós-MVP (should/could have)
- Dashboards e gráficos comparativos na vitrine.
- Notificações em tempo real (popup) na plataforma.
- Granularidade de permissões por campo no vínculo cliente-assessor.
- Recomendações por IA (contatar time de dados "cacaus" para avaliar o que existe).
- Autenticação de assessores externos via Keycloak.
- Relatórios periódicos (semanal/mensal) de conversão.

### Fora do escopo
- Modificar fluxo de push/aceite existente no app do cliente.
- Dados bancários além de investimentos.
- Integração com WhatsApp ou outros canais.
- Clientes não-PicPay.

---

## Terminologia Oficial

| Termo | Definição |
|-------|-----------|
| **Oferta** | Produto disponível para investimento (antes da compra) |
| **Custódia** | Produto já adquirido (investimento efetivado) |
| **Ordem** | Intenção de compra criada no Invest Place |
| **Push** | Notificação enviada ao cliente para aceite |
| **Consumer ID** | ID do cliente no sistema PicPay (obrigatório) |
| **Focus** | Sistema interno de gestão de assessores internos |
| **Invest Place** | Marketplace interno de produtos de investimento |
| **Horizon** | Nome do projeto no Confluence |

---

## Equipe do Projeto

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

## Reuniões — Log de Decisões

### 18/03/2026 — Kick-off Backend e Arquitetura
- Cadastro de usuário genérico: nome, e-mail, CPF, telefone. Tipo define roles.
- Assessor vinculado a empresa (CNPJ + razão social).
- Autenticação via Google (não usuário/senha).
- Consumer ID obrigatório para clientes.
- Telas MVP priorizadas: Home, Clientes, Listagem de Ofertas, Envio de Push.
- Push ≠ ordem: plataforma envia push, aceite aciona backend.

### 25/03/2026 — Weekly + Alinhamento (partes 1 e 2)
- Relacionamento cliente-assessor no MySQL (fora do Focus).
- APIs existentes no Invest Place: listar ofertas + criar ordens.
- Invest Place = Amazon de produtos de investimento.
- Diretrizes: usar HubAI Nitro no desenvolvimento (obrigatório pela organização).
- Login: modelo similar ao Invest Place Admin (conta Microsoft/Google).
- Tela home do assessor: patrimônio total administrado + alertas de vencimentos.
- MER e DER a serem criados; publicar no Confluence (Horizon).
- Frontend em React, arquitetura MVVM.
- Notificações ao assessor: apenas sistema interno (não e-mail), para evitar spam.

### 25/03/2026 — Alinhamento de Segurança (com Roger Oberdan)
- AD descartado para externos. Keycloak definido.
- VPN + EDR para assessores externos: inviável (custo + complexidade).
- Anonimizar dados financeiros: usar classificações, não valores exatos.
- Exibir mínimo de dados pessoais do cliente.
- Validação jurídica obrigatória antes de exibir CPF + valores associados.
- Rate limit + reCAPTCHA obrigatórios.
- Próximos passos: contatar Gatekeepers (Mina/Liso) para Keycloak.

### 02/04/2026 — Weekly TCC Parte 1
- Assessor cadastrado já como **ativo** (sem pendência de ativação).
- Desativação = remoção da role de assessor (mantém histórico).
- Permissões configuráveis por assessor, vigência imediata.
- Painel gerencial com métricas de desempenho.
- Autenticação interna: AD já cobre MFA, OTP, bloqueio — não implementar.
- Vínculo cliente-assessor: cliente libera conjunto fixo de permissões (V2 = granular).
- Aceite de recomendação: push → detalhes → aceitar com biometria.
- Validade das ofertas: por oferta, não geral. Validar com Mauro Borges.
- Dashboards na vitrine: pós-MVP.
- Infraestrutura: Oracle + Moonlight.
- Microsserviço único para começar (arquitetura evolutiva).
- Notificação para assessor: **e-mail como must have**, real-time como could have.

### 02/04/2026 — Weekly TCC Parte 2
- Tela ADM: sem acesso a dados detalhados de clientes (só assessores + gestão básica).
- Termo "custódia" para produtos comprados; "oferta" para disponíveis.
- Tabela intermediária Advisor/Client com status para histórico de vínculo.
- Dados de ofertas: não duplicar no banco local, consumir do Invest Place.
- Vitrine de ofertas = aba dentro da visão do cliente (exige Consumer ID).
- Oferta Combo: ofertas exclusivas que habilitam outras — implementar com cautela.
- Métricas do ADM: Data Lake / MongoDB, não tabelas relacionais.
- Triggers MySQL para auditoria.
- Princípio do MVP: "comprometa-se com pouca coisa, entregue excelência".

### 07/04/2026 — Funcionamento do Push para o App
- Push definido no Focus: valor + duração (1h/6h/8h/1dia).
- Validações de saldo, mínimo, máximo e múltiplo: todas no front-end.
- 3 chamadas de backend: listar ofertas → criar ordem → disparar push.
- Invest Place abstrai complexidade de roteamento.
- Usuário sistêmico genérico (ID 600 ou similar) para autenticar push externo no MVP.
- Validar com time Comercial (Michael) o uso do usuário sistêmico.
- Mauro enviará documentação do Confluence + Figma do fluxo.

---

## Contexto Regulatório (CVM 178)

- Assessor externo pode visualizar carteira e recomendar, mas **não decide** pelo cliente.
- Cliente sempre tem controle final (aceite com 2º fator).
- Assessor só vê dados de investimentos, não dados bancários amplos.
- Termo de ciência obrigatório no vínculo.
- Perfil de suitability do cliente: assessor pode recomendar fora do perfil, mas é decisão do assessor (não do sistema).

---

## Limites do Agente

Não ofereço: aconselhamento personalizado de investimento, exposição de dados sensíveis (PII, tokens, credenciais), contradição de CVM 178, invenção de comportamentos não definidos nas reuniões, garantia de prazos ou escopo sem validação do time.
