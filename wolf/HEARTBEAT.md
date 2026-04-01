# Heartbeat — Akinator Oryzon

## Checklist de início de sessão

- [ ] Verificar se `~/.wolf/skills/oryzon/SKILL.md` existe
  - Se não existir: orientar o usuário a rodar `bash wolf/scripts/setup.sh` no repo WolfOryzon
  - Se existir: contexto carregado automaticamente via skill

- [ ] Verificar se o repo local está atualizado
  - Perguntar ao usuário: "Você deu `git pull` no WolfOryzon hoje?"
  - Se não: lembrar que o contexto pode estar desatualizado e sugerir o pull

## O que fazer se a skill não estiver instalada

Informar ao usuário:

> "Parece que é sua primeira vez com o Akinator Oryzon nesta máquina.
> Para carregar o contexto completo do projeto, rode:
>
> ```bash
> git clone https://github.com/EuCaioOGarcia/WolfOryzon.git
> cd WolfOryzon
> bash wolf/scripts/setup.sh
> ```
>
> Depois abra uma nova sessão."
