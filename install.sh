#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Componentes que van a ~/.config/
CONFIG_DIRS=(fish ghostty nvim opencode iterm2 claude)
CONFIG_FILES=(starship.toml)

# Componentes que van a ~/
HOME_FILES=(.tmux.conf)

# Archivos individuales dentro de ~/.claude/ (runtime dir, no se puede symlinkar entero)
CLAUDE_FILES=(settings.json CLAUDE.md)

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

# Claude Code: symlink archivos de config dentro de ~/.claude/
mkdir -p "$HOME/.claude"
for file in "${CLAUDE_FILES[@]}"; do
    link_item "$DOTFILES_DIR/claude/$file" "$HOME/.claude/$file"
done

echo ""
echo "Done!"
