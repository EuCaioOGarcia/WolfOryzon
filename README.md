# WolfOryzon

Repositório de contexto do agente **Akinator Oryzon** para o projeto TCC Invest / Oryzon.

Mantém o contexto do projeto sincronizado entre todos os membros do time via skill do HubAI Nitro Wolf.

---

## Primeira vez nesta máquina?

```bash
git clone https://github.com/EuCaioOGarcia/WolfOryzon.git
cd WolfOryzon
bash wolf/scripts/setup.sh
```

Isso cria os symlinks necessários em `~/.wolf/` apontando para os arquivos deste repo.
Rode uma vez — depois basta `git pull` para manter o contexto atualizado.

---

## Manter o contexto atualizado

```bash
# No diretório do repo:
git pull
```

Na próxima sessão com o agente, o contexto já estará atualizado.

---

## Atualizar o contexto do projeto

Edite `wolf/SKILL.md` com as mudanças (nova decisão técnica, status de módulo, nova entidade, etc.), commite e faça push:

```bash
git add wolf/SKILL.md
git commit -m "context: <descreva a mudança>"
git push
```

O time recebe na próxima vez que fizer `git pull`.

---

## Estrutura

```
wolf/
  SKILL.md        ← contexto profundo do projeto (lido automaticamente pelo agente)
  HEARTBEAT.md    ← checklist de início de sessão do agente
  scripts/
    setup.sh      ← script de setup (uma vez por máquina)
```

---

## Convenção de commit para este repo

```
context: <o que mudou>     → mudança no SKILL.md
setup: <o que mudou>       → mudança no setup.sh
heartbeat: <o que mudou>   → mudança no HEARTBEAT.md
```
