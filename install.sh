#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Componentes que van a ~/.config/
CONFIG_DIRS=(fish ghostty nvim iterm2)
CONFIG_FILES=(starship.toml)

# Componentes que van a ~/
HOME_FILES=(.tmux.conf)

# Claude Code: archivos dentro de ~/.claude/ (runtime dir, no se puede symlinkar entero)
CLAUDE_FILES=(settings.json CLAUDE.md)

# Gemini CLI: archivos/carpetas dentro de ~/.gemini/
GEMINI_ITEMS=(settings.json antigravity)

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
# OpenCode: ~/.config/opencode -> ai/opencode
link_item "$DOTFILES_DIR/ai/opencode" "$HOME/.config/opencode"

# Claude Code: symlink archivos de config dentro de ~/.claude/
mkdir -p "$HOME/.claude"
for file in "${CLAUDE_FILES[@]}"; do
    link_item "$DOTFILES_DIR/ai/claude/$file" "$HOME/.claude/$file"
done

# Gemini CLI: symlink archivos de config dentro de ~/.gemini/
mkdir -p "$HOME/.gemini"
for item in "${GEMINI_ITEMS[@]}"; do
    link_item "$DOTFILES_DIR/gemini/$item" "$HOME/.gemini/$item"
done

echo ""
echo "Done!"
