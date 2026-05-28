#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Componentes que van a ~/.config/
CONFIG_DIRS=(fish ghostty nvim iterm2)
CONFIG_FILES=(starship.toml)

# Componentes que van a ~/
HOME_FILES=(.tmux.conf)

# Claude Code: archivos dentro de ~/.claude/ (runtime dir, no se puede symlinkar entero)
CLAUDE_FILES=(settings.json CLAUDE.md statusline-command.sh)

# Gemini CLI: archivos/carpetas dentro de ~/.gemini/
# antigravity/ NO se symlinkea: es estado de runtime (conversaciones, brain, etc.)
GEMINI_ITEMS=(settings.json)

link_item() {
    local src="$1" dest="$2"
    if [ -L "$dest" ]; then
        rm "$dest"
    elif [ -e "$dest" ]; then
        mv "$dest" "${dest}.backup"
        echo "  Backup: ${dest}.backup"
    fi
    ln -s "$src" "$dest"
    echo "  Linked: $dest → $src"
}

mkdir -p "$HOME/.config"

echo "Linking dotfiles from $DOTFILES_DIR"
echo ""

for dir in "${CONFIG_DIRS[@]}"; do
    link_item "$DOTFILES_DIR/$dir" "$HOME/.config/$dir"
done

for file in "${CONFIG_FILES[@]}"; do
    link_item "$DOTFILES_DIR/$file" "$HOME/.config/$file"
done

for file in "${HOME_FILES[@]}"; do
    link_item "$DOTFILES_DIR/$file" "$HOME/$file"
done

# AI tools: source of truth is ai/

# OpenCode: ~/.config/opencode con config (items individuales) + agent/ (carpeta entera)
# Migración: si la versión anterior linkeó ~/.config/opencode como symlink
# entero al repo, hay que removerlo antes de los linkeos granulares para que
# mkdir / link_item no operen dentro del propio repo.
if [ -L "$HOME/.config/opencode" ]; then
    rm "$HOME/.config/opencode"
    echo "  Removed legacy symlink: $HOME/.config/opencode"
fi
mkdir -p "$HOME/.config/opencode"

# (1) Items individuales de ai/opencode/
for item in opencode.json package.json package-lock.json README.md .gitignore node_modules; do
    link_item "$DOTFILES_DIR/ai/opencode/$item" "$HOME/.config/opencode/$item"
done

# (2) Agents: linkear ai/agents/opencode/ entero. Cualquier .md nuevo aparece auto.
# Si previamente era carpeta real con symlinks adentro (versión anterior), la limpio.
if [ -d "$HOME/.config/opencode/agent" ] && [ ! -L "$HOME/.config/opencode/agent" ]; then
    rm -rf "$HOME/.config/opencode/agent"
    echo "  Removed legacy folder: $HOME/.config/opencode/agent"
fi
link_item "$DOTFILES_DIR/ai/agents/opencode" "$HOME/.config/opencode/agent"

# Claude Code: symlink archivos de config dentro de ~/.claude/
mkdir -p "$HOME/.claude"
for file in "${CLAUDE_FILES[@]}"; do
    link_item "$DOTFILES_DIR/ai/claude/$file" "$HOME/.claude/$file"
done

# Skills: merge ai/skills/{opencode,shared}/<name>/ → symlinks en los 3 agentes:
# ~/.agents/skills/ (OpenCode), ~/.claude/skills/ (Claude) y
# ~/.gemini/antigravity-cli/skills/ (agy). Sin estos symlinks la skill no
# cascadea. Las skills de Superpowers para agy van aparte (no tiene plugin):
# ver ai/skills/install-superpowers-agy.sh
# Migración: si agy tenía el dir de skills linkeado entero al repo, lo removemos
# para usar carpeta real (ahí conviven superpowers descargadas + symlinks custom).
if [ -L "$HOME/.gemini/antigravity-cli/skills" ]; then
    rm "$HOME/.gemini/antigravity-cli/skills"
    echo "  Removed legacy symlink: $HOME/.gemini/antigravity-cli/skills"
fi
mkdir -p "$HOME/.agents/skills" "$HOME/.claude/skills" "$HOME/.gemini/antigravity-cli/skills"
for src_dir in "$DOTFILES_DIR/ai/skills/opencode" "$DOTFILES_DIR/ai/skills/shared"; do
    for skill in "$src_dir"/*/; do
        [ -d "$skill" ] || continue
        name=$(basename "$skill")
        link_item "${skill%/}" "$HOME/.agents/skills/$name"
        link_item "${skill%/}" "$HOME/.claude/skills/$name"
        link_item "${skill%/}" "$HOME/.gemini/antigravity-cli/skills/$name"
    done
done

# Gemini CLI: symlink archivos de config dentro de ~/.gemini/
mkdir -p "$HOME/.gemini"
for item in "${GEMINI_ITEMS[@]}"; do
    link_item "$DOTFILES_DIR/gemini/$item" "$HOME/.gemini/$item"
done

echo ""
echo "Done!"
