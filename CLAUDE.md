# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for a macOS (Apple Silicon) development environment. **This is NOT a traditional project** — there are no tests, builds, or CI/CD. Changes require manual reload of each tool.

See `AGENTS.md` for detailed code style guidelines (Lua, Fish, TOML) and file structure conventions.

## Components & Reload Commands

| Component | Config Location | Reload |
|---|---|---|
| Fish Shell | `fish/config.fish` | `exec fish` |
| Ghostty | `ghostty/config` | `Cmd+Shift+,` or restart |
| Neovim/LazyVim | `nvim/lua/` | `:Lazy sync` or restart |
| Starship | `starship.toml` | `exec fish` |
| tmux | `~/.tmux.conf` | `Ctrl+a r` inside tmux |

## Architecture

### Theme: Catppuccin Mocha (everywhere)

The README.md says "Frappe" but actual configs all use **Mocha**. Theme changes must stay consistent across:
- `ghostty/config` → `theme = Catppuccin Mocha`
- `nvim/lua/plugins/colorscheme.lua` → `flavour = "mocha"`
- `starship.toml` → custom colors matching palette
- `~/.tmux.conf` → status bar uses Mocha hex colors

### Fonts

- **Ghostty**: Monaspace Argon, size 16
- **Neovim GUI**: IosevkaTerm Nerd Font, size 14 (`nvim/lua/config/options.lua`)

### Shell Integration Flow

Ghostty → Fish (`/opt/homebrew/bin/fish`) → loads Homebrew PATH, zoxide, fnm, atuin, Starship → auto-starts tmux (session "main") only when `GHOSTTY_RESOURCES_DIR` is set and not already in tmux.

### Neovim Plugin Architecture

LazyVim framework. Entry: `nvim/init.lua` → `lua/config/lazy.lua`. One plugin per file in `lua/plugins/`. Enabled extras: DAP, git, java, json, kotlin, markdown, php, python, tailwind, typescript, dot.

## Key Conventions

- **Paths**: Homebrew binaries at `/opt/homebrew/bin/`. Ghostty config must use full paths since it launches with `bash --noprofile --norc`.
- **Language**: Comments and docs in English or Spanish OK.
- **Preferred CLI tools**: `bat` over `cat`, `rg` over `grep`, `fd` over `find`, `eza` over `ls`, `sd` over `sed`.
- **Lua**: 2-space indent, double quotes, `snake_case`, format with stylua (120 col width).
- **Fish**: 4-space indent, one function per file in `fish/functions/`, use `-d` for descriptions.
- **TOML**: `kebab-case` keys, double quotes for strings.

## Validation

```bash
fish -n ~/.config/fish/config.fish          # Fish syntax check
nvim --headless -c "lua print('OK')" -c quit  # Neovim config check
starship print-config                        # Starship config check
ghostty +show-config                         # Ghostty config check
```
