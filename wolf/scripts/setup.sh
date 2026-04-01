#!/bin/bash
# =============================================================================
# Oryzon Wolf Setup
# Rode este script UMA VEZ por máquina para instalar a skill do projeto.
# Após isso, basta fazer `git pull` neste repo para manter o contexto atualizado.
# =============================================================================

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SKILL_DIR="$HOME/.wolf/skills/oryzon"
SKILL_SOURCE="$REPO_DIR/wolf/SKILL.md"
HEARTBEAT_DIR="$HOME/.wolf"
HEARTBEAT_SOURCE="$REPO_DIR/wolf/HEARTBEAT.md"

echo "╔══════════════════════════════════════╗"
echo "║     Oryzon Wolf Setup                ║"
echo "╚══════════════════════════════════════╝"
echo ""

# --- Skill ---
echo "→ Instalando skill Oryzon..."
mkdir -p "$SKILL_DIR"

if [ -L "$SKILL_DIR/SKILL.md" ]; then
  echo "  Symlink já existe — atualizando..."
  rm "$SKILL_DIR/SKILL.md"
fi

ln -sf "$SKILL_SOURCE" "$SKILL_DIR/SKILL.md"
echo "  ✓ Skill instalada em $SKILL_DIR/SKILL.md"

# --- Heartbeat ---
echo "→ Instalando Heartbeat..."

if [ -L "$HEARTBEAT_DIR/HEARTBEAT.md" ]; then
  echo "  Symlink já existe — atualizando..."
  rm "$HEARTBEAT_DIR/HEARTBEAT.md"
fi

ln -sf "$HEARTBEAT_SOURCE" "$HEARTBEAT_DIR/HEARTBEAT.md"
echo "  ✓ Heartbeat instalado em $HEARTBEAT_DIR/HEARTBEAT.md"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  Setup concluído!                    ║"
echo "║                                      ║"
echo "║  Para manter o contexto atualizado:  ║"
echo "║  → git pull (neste repo)             ║"
echo "║                                      ║"
echo "║  Abra uma nova sessão no HubAI Nitro ║"
echo "║  com o agente Akinator Oryzon.       ║"
echo "╚══════════════════════════════════════╝"
