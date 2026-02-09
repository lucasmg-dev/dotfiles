# .config - Development Environment Configuration

Personal dotfiles for a macOS (Apple Silicon) development environment with **Ghostty**, **Fish Shell**, **tmux**, **Starship**, and **LazyVim**, themed with **Catppuccin Mocha** and **Monaspace Argon** font.

---

## Components

- **Ghostty**: GPU-accelerated terminal with transparency and blur
- **tmux**: Terminal multiplexer with Catppuccin theme, CPU/MEM monitoring
- **Fish Shell**: Smart shell with autosuggestions
- **Starship**: Fast, customizable prompt
- **LazyVim**: Neovim configuration framework
- **Atuin**: Shell history sync and search
- **OpenCode**: AI-powered coding assistant

---

## Quick Start

### Prerequisites

```bash
# Install Homebrew (macOS)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install core tools
brew install fish starship atuin neovim tmux ghostty

# Install Monaspace Argon font
brew install --cask font-monaspace
```

### Setup

1. **Clone this repository** to `~/.config`:
   ```bash
   git clone <your-repo-url> ~/.config
   ```

2. **Set Fish as default shell**:
   ```bash
   echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
   chsh -s /opt/homebrew/bin/fish
   ```

3. **Install tmux plugins** (TPM):
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   # Open tmux, then press Ctrl+a I to install plugins
   ```

4. **Install Fish plugins** (Fisher):
   ```bash
   fish
   # Fisher auto-installs on first run
   ```

5. **Install Neovim plugins**:
   ```bash
   nvim
   # Run :Lazy sync
   ```

6. **Symlink Ghostty CLI** (optional):
   ```bash
   ln -sf /Applications/Ghostty.app/Contents/MacOS/ghostty /opt/homebrew/bin/ghostty
   ```

7. **Symlink CLAUDE.md for global Claude Code persona**:
   ```bash
   ln -sf ~/.config/CLAUDE.md ~/.claude/CLAUDE.md
   ```

8. **Restart your terminal** to apply all changes

---

## Theme: Catppuccin Mocha

All components share the same color scheme:

| Component | Config |
|---|---|
| Ghostty | `theme = Catppuccin Mocha` |
| tmux | `@catppuccin_flavor "mocha"` via catppuccin/tmux plugin |
| Neovim | `catppuccin/nvim` with `flavour = "mocha"`, transparent background |
| Starship | Custom color palette in `starship.toml` |

### Font: Monaspace Argon

- **Ghostty**: size 15
- **Neovim GUI**: IosevkaTerm Nerd Font, size 14 (`nvim/lua/config/options.lua`)

---

## Shell Integration Flow

```
Ghostty (/opt/homebrew/bin/fish)
  -> Fish config.fish
    -> Homebrew PATH, zoxide, fnm, atuin, Starship
    -> auto-starts tmux (session "main") only in Ghostty
```

Fish detects Ghostty via `GHOSTTY_RESOURCES_DIR` and skips tmux if already inside a tmux session.

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

- **Top position**, Catppuccin Mocha styled
- **Right**: CPU usage (color changes by load) + MEM usage
- **Center**: Window tabs with number and command name

### Plugins

- `catppuccin/tmux` - Theme
- `tmux-plugins/tmux-cpu` - CPU and memory metrics
- `christoomey/vim-tmux-navigator` - Seamless vim/tmux pane navigation

---

## Neovim / LazyVim

- Transparent background (inherits Ghostty opacity)
- Bufferline/tabs disabled (single window workflow)
- Explorer tree disabled on startup (`<Space>e` to open)
- File picker excludes `node_modules`, `.git`, `.cache`
- Shows hidden files, hides git-ignored files

### Custom Plugins

| File | Plugin |
|---|---|
| `colorscheme.lua` | Catppuccin Mocha with transparency |
| `snacks.lua` | Picker/explorer config |
| `bufferline.lua` | Disabled |
| `vim-tmux-navigator.lua` | tmux/nvim pane navigation |
| `oil.lua` | File manager |
| `markdown_preview.lua` | Markdown preview |

---

## Directory Structure

```
.config/
├── fish/
│   ├── config.fish          # Main Fish config (PATH, tools, tmux auto-start)
│   ├── functions/           # Custom Fish functions
│   ├── completions/         # Auto-completions
│   └── fish_plugins         # Fisher plugin list
├── nvim/
│   └── lua/
│       ├── config/          # Neovim core config
│       └── plugins/         # Plugin configurations
├── ghostty/
│   └── config               # Ghostty config
├── tmux/
│   └── mem.sh               # Memory usage script
├── opencode/                # OpenCode config
├── starship.toml            # Starship prompt config
├── AGENTS.md                # Guidelines for AI coding agents
├── CLAUDE.md                # Guidelines for Claude Code
└── README.md                # This file

~/.tmux.conf                 # tmux configuration
~/.tmux/plugins/             # TPM plugins (catppuccin, tmux-cpu, vim-tmux-navigator)
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
fish -n ~/.config/fish/config.fish          # Fish syntax check
nvim --headless -c "lua print('OK')" -c quit  # Neovim config check
starship print-config                        # Starship config check
ghostty +show-config                         # Ghostty config check
ghostty +list-themes                         # List available Ghostty themes
```

---

## Platform

Optimized for macOS (Apple Silicon). Homebrew binaries at `/opt/homebrew/bin/`.
