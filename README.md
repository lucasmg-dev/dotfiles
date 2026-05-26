# dotfiles — Development Environment

Personal dotfiles for a macOS (Apple Silicon) development environment with **Ghostty**, **Fish Shell**, **tmux**, **Starship**, and **LazyVim**, themed with **Catppuccin Frappe** and **IosevkaTerm Nerd Font Mono**.

---

## Components

- **Ghostty**: GPU-accelerated terminal, full opacity
- **tmux**: Terminal multiplexer with manual Frappe-themed chips, CPU/MEM monitoring
- **Fish Shell**: Smart shell with autosuggestions and fnm version switching
- **Starship**: Fast prompt, Catppuccin Frappe palette
- **LazyVim**: Neovim configuration framework, Catppuccin Frappe
- **Claude Code**: AI coding assistant
- **OpenCode**: AI coding assistant with shared skills and MCP integrations
- **Gemini CLI**: Google Gemini CLI with antigravity MCP configuration

---

## Quick Start

### Prerequisites

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install core tools
brew install fish starship neovim tmux

# Install Ghostty (download from https://ghostty.org)

# Install IosevkaTerm Nerd Font
brew install --cask font-iosevka-term-nerd-font

# Install fnm (Node version manager)
brew install fnm
```

### Setup

1. **Clone this repository**:
   ```bash
   git clone git@github.com:lucasmg-dev/dotfiles.git ~/workspace/dotfiles
   ```

2. **Run the install script** — symlinks everything into place:
   ```bash
   cd ~/workspace/dotfiles
   ./install.sh
   ```
   This creates symlinks for `~/.tmux.conf`, `~/.claude/settings.json`, `~/.claude/CLAUDE.md`, `~/.gemini/settings.json`, and `~/.gemini/antigravity/`.

3. **Set Fish as default shell**:
   ```bash
   echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
   chsh -s /opt/homebrew/bin/fish
   ```

4. **Install tmux plugins** (TPM):
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   # Open tmux, then press Ctrl+a I to install plugins
   ```

5. **Install Neovim plugins**:
   ```bash
   nvim
   # Run :Lazy sync
   ```

6. **Restart your terminal** to apply all changes.

---

## Theme: Catppuccin Frappe

All components share the same color scheme:

| Component | Config |
|---|---|
| Ghostty | `theme = Catppuccin Frappe` |
| tmux | Manual chips using Frappe hex colors |
| Neovim | `catppuccin/nvim` with `flavour = "frappe"` |
| Starship | Custom Frappe palette in `starship.toml` |
| Claude statusline | Frappe ANSI 24-bit colors |

### Font: IosevkaTerm Nerd Font Mono

- **Ghostty**: size 18
- **Neovim**: inherits from terminal

---

## Shell Integration Flow

```
Ghostty (/opt/homebrew/bin/fish)
  -> Fish config.fish
    -> Homebrew PATH, zoxide, fnm, atuin, Starship
    -> auto-starts tmux (session "main") only in Ghostty
```

Fish detects Ghostty via `GHOSTTY_RESOURCES_DIR` and skips tmux if already inside a tmux session. `conf.d/fnm.fish` handles automatic Node version switching on `cd`.

---

## tmux

**Prefix**: `Ctrl+a`

### Shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl+a \|` | Split horizontal |
| `Ctrl+a -` | Split vertical |
| `Ctrl+a h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl+a z` | Toggle pane fullscreen |
| `Ctrl+a x` | Close pane (with confirmation) |
| `Ctrl+a c` | New window |
| `Ctrl+a n/p` | Next/previous window |
| `Ctrl+a 1-9` | Go to window by number |
| `Ctrl+a &` | Close window |
| `Ctrl+a r` | Reload config |
| `Ctrl+a I` | Install plugins (TPM) |

### Status Bar

- **Top position**, Frappe-colored chips (no plugin — raw `fg/bg` format strings)
- **Right**: session name · hostname · CPU% · RAM% · time
- **Left**: window tabs with index and name

### Plugins

- `tmux-plugins/tmux-sensible` — Sensible defaults
- `tmux-plugins/tmux-cpu` — CPU and memory metrics (`#{cpu_percentage}`, `#{ram_percentage}`)
- `christoomey/vim-tmux-navigator` — Seamless vim/tmux pane navigation

---

## Neovim / LazyVim

- Catppuccin Frappe, solid background
- Markdown: spell and markdownlint disabled; MarkdownPreview uses pre-built binary
- Bufferline/tabs disabled (single window workflow)
- Explorer tree disabled on startup (`<Space>e` to open)

### Custom Plugins

| File | Plugin |
|---|---|
| `colorscheme.lua` | Catppuccin Frappe with full integrations |
| `markdown_preview.lua` | MarkdownPreview (pre-built binary) + nvim-lint markdown disabled |
| `snacks.lua` | Picker/explorer config |
| `bufferline.lua` | Disabled |
| `vim-tmux-navigator.lua` | tmux/nvim pane navigation |
| `oil.lua` | File manager |

---

## Directory Structure

```
dotfiles/
├── fish/
│   ├── config.fish          # Main Fish config (PATH, tools, tmux auto-start)
│   ├── conf.d/
│   │   └── fnm.fish         # Auto Node version switching
│   ├── functions/           # Custom Fish functions
│   ├── completions/         # Auto-completions
│   └── fish_plugins         # Fisher plugin list
├── nvim/
│   └── lua/
│       ├── config/          # Neovim core config
│       └── plugins/         # Plugin configurations
├── ghostty/
│   └── config               # Ghostty config
├── opencode/
│   ├── opencode.json        # OpenCode config (MCPs, default agent)
│   └── skills/              # Skills (handoff, etc.)
├── ai/
│   └── skills/shared/       # Shared skills across tools (handoff)
├── gemini/
│   ├── settings.json        # Gemini CLI settings
│   └── antigravity/         # Antigravity MCP config
├── iterm2/
│   └── colors/              # Color presets (.itermcolors)
├── starship.toml            # Starship prompt config
├── install.sh               # Symlink installer
├── AGENTS.md                # Guidelines for AI coding agents
├── CLAUDE.md                # Guidelines for Claude Code
└── README.md                # This file

~/.tmux.conf                 # Symlink → dotfiles/.tmux.conf
~/.claude/                   # Symlinks → dotfiles/claude/
~/.gemini/                   # Symlinks → dotfiles/gemini/
```

---

## Reload Commands

| Component | Reload |
|---|---|
| Fish Shell | `exec fish` |
| Ghostty | `Cmd+Shift+,` or restart |
| Neovim | `:Lazy sync` or restart |
| Starship | `exec fish` |
| tmux | `Ctrl+a r` |

---

## Verification

```bash
fish -n ~/workspace/dotfiles/fish/config.fish  # Fish syntax check
nvim --headless -c "lua print('OK')" -c quit   # Neovim config check
starship print-config                          # Starship config check
ghostty +show-config                           # Ghostty config check
```

---

## Platform

Optimized for macOS (Apple Silicon). Homebrew binaries at `/opt/homebrew/bin/`.
