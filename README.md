# WolfOryzon

Repositório de contexto do agente **Akinator Oryzon** — ponto único de verdade sobre o projeto **TCC Invest / Oryzon**.

---

## O que é isso?

Este repo contém a base de conhecimento que alimenta o agente de IA do projeto. Toda vez que alguém abre uma sessão com o Akinator Oryzon, ele carrega automaticamente o conteúdo daqui — garantindo que todos do time recebam as mesmas respostas, alinhadas ao estado atual do projeto.

---

## Estrutura

```
wolf/
├── SKILL.md              # Base de conhecimento principal (arquitetura, decisões, fluxos, MVP)
├── HEARTBEAT.md          # Checklist do heartbeat periódico do agente
├── reunioes/             # Transcrições e resumos de todas as reuniões
│   ├── 2026-03-18_kickoff-backend-arquitetura.md
│   ├── 2026-03-24_aula-designer-apollo.md
│   ├── 2026-03-25_weekly-alinhamento-resumo.md
│   ├── 2026-03-25_weekly-invest-place-apis.md
│   ├── 2026-03-25_alinhamento-seguranca.md
│   ├── 2026-04-02_weekly-tcc-parte1.md
│   ├── 2026-04-02_weekly-tcc-parte2.md
│   └── 2026-04-07_push-funcionamento.md
└── scripts/
    └── setup.sh          # Script de instalação do agente
```

---

## Como instalar (primeira vez)

```bash
git clone https://github.com/EuCaioOGarcia/WolfOryzon.git
cd WolfOryzon
bash wolf/scripts/setup.sh
```

Depois importe o arquivo `AkinatorOryzon.agent.md` no HubAI Nitro e abra uma nova sessão.

---

## Como atualizar o contexto

```bash
cd WolfOryzon
git pull
```

O contexto é carregado via symlink — não precisa reinstalar nada.

---

## Como contribuir

**Depois de cada reunião importante:**
1. Edite `wolf/SKILL.md` com as novas decisões (seção "Decisões de Arquitetura" ou "Log de Decisões").
2. Adicione o arquivo de transcrição/resumo em `wolf/reunioes/YYYY-MM-DD_titulo.md`.
3. Commit e push.

```bash
git add wolf/
git commit -m "feat: atualiza contexto com reunião DD/MM"
git push
```

Todos do time que derem `git pull` antes de abrir uma sessão terão o contexto atualizado automaticamente.

---

## Equipe

| Nome | Papel |
|------|-------|
| Angelo Luis Rodrigues Da Silva | Tech Lead / Arquiteto |
| Murilo Viviani | PO |
| Giovanne Antony Bahia Torquato | Tech |
| Marianna Lopes De Paula Luna | Produto |
| Diogo Barbosa de Queiroz | Tech / Frontend |
| Gustavo Henrique Almeida Ferreira | Tech |
| Caio De Oliveira Garcia | Tech |
| Petherson Martins Costa | Tech / Frontend |
| Joyce Nicole Pereira Santana | Design / Produto |
