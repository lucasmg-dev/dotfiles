# AGENTS - Dotfiles Configuration Repository

This document defines guidelines for code agents working in `/Users/lgonzalez/.config`, a configuration repository for nvim (LazyVim), fish shell, ghostty terminal, starship prompt, and related utilities.

---

## Repository Context

**Type**: Dotfiles / Development configurations  
**Main components**:
- `nvim/`: LazyVim config (Lua)
- `fish/`: Fish shell config, functions, completions
- `ghostty/`: Terminal emulator config
- `starship.toml`: Prompt configuration
- `opencode/`: OpenCode AI plugin config

**NOT a traditional project** with tests/builds. This is a modular configuration system.

---

## Essential Commands

### Neovim / LazyVim

```bash
# Open Neovim and sync plugins
nvim
:Lazy sync              # Install/update plugins
:Lazy clean             # Remove unused plugins
:checkhealth            # Diagnose issues

# Verify Lua config without opening editor
nvim --headless -c "lua print('Config OK')" -c quit

# List installed plugins
ls ~/.local/share/nvim/lazy/
```

### Fish Shell

```bash
# Reload configuration
exec fish
source ~/.config/fish/config.fish

# Fisher (plugin manager)
fisher update           # Update all plugins
fisher list             # List installed plugins
fisher install <repo>   # Install new plugin

# Testing functions
fish -c "my_function"   # Execute specific function

# Debugging
fish -d 3               # Run with debug level 3
```

### Ghostty

```bash
# Reload config (at runtime)
# Use: Cmd+Shift+,

# Verify current config
ghostty +show-config

# View option documentation
ghostty +show-config --docs

# Validate config without opening (no official command, check manually)
```

### Starship

```bash
# Apply changes (reload shell)
exec fish

# View rendered current config
starship print-config

# Debug prompt
starship explain

# Validate TOML syntax
starship config  # Should return without errors
```

---

## Code Style

### Lua (Neovim)

**Format and Structure**:
```lua
-- Use double quotes
local text = "example"

-- Indentation: 2 spaces
local config = {
  option = "value",
  nested = {
    key = true,
  },
}

-- Prefer local variables
local function my_function()
  -- code
end

-- Plugin config in separate files under lua/plugins/
return {
  {
    "author/plugin-name",
    lazy = false,
    priority = 1000,
    config = function()
      -- configuration
    end,
  },
}
```

**Conventions**:
- File names: `snake_case.lua`
- Variables/functions: `snake_case`
- Constants: `SCREAMING_SNAKE_CASE`
- Comments: `-- English or Spanish OK, describe the "why"`
- Imports: `require("module")` at the beginning of file

**Error Handling**:
```lua
-- Use pcall for operations that may fail
local ok, result = pcall(require, "optional_module")
if not ok then
  vim.notify("Module not found", vim.log.levels.WARN)
  return
end
```

### Fish Shell

**Format and Structure**:
```fish
# Functions in separate files: fish/functions/name.fish
function my_function -d "Clear description"
    # Indentation: 4 spaces
    if test -n "$argv[1]"
        echo "Argument: $argv[1]"
    else
        echo "No arguments"
        return 1
    end
end

# Exported global variables
set -gx VARIABLE_NAME value

# Local variables
set -l temp_var value
```

**Conventions**:
- Function names: `snake_case`
- Variables: `SCREAMING_SNAKE_CASE` (export) or `lowercase` (local)
- One function per file in `fish/functions/`
- Use `-d` for description in function definition
- Prefer `test` over `[` for conditionals

### TOML (Starship, Ghostty)

**Format**:
```toml
# Descriptive comments before each section
[section]
key = "value"
number = 42
boolean = true

# Logical grouping with blank line between sections
[another_section]
option = "example"
```

**Conventions**:
- Key names: `kebab-case`
- Strings: double quotes
- Maintain alphabetical order within sections when possible
- Comments in English or Spanish OK

---

## File Structure

### Neovim
```
nvim/
├── init.lua                 # Entry point (if exists, else lazy.lua)
└── lua/
    ├── config/
    │   ├── autocmds.lua     # Autocommands
    │   ├── keymaps.lua      # Key mappings
    │   ├── lazy.lua         # Lazy.nvim bootstrap
    │   └── options.lua      # Vim options
    └── plugins/
        ├── colorscheme.lua  # Theme config
        ├── example.lua      # Template/reference
        └── *.lua            # One plugin per file
```

### Fish
```
fish/
├── config.fish          # Main config (interactive setup)
├── fish_plugins         # Fisher plugin list
├── functions/           # One function per file
│   ├── fisher.fish
│   └── custom.fish
├── completions/         # Auto-completions
└── themes/              # Color schemes
    └── *.theme
```

---

## Conventions and Best Practices

### General
- **Language**: Comments and documentation in English or Spanish OK
- **Encoding**: UTF-8 always
- **Line endings**: LF (Unix)
- **Indentation**: 2 spaces (Lua), 4 spaces (Fish), tabs/spaces per context (TOML)
- **Trailing whitespace**: Always remove

### Modifications
1. **Read before editing**: Use `Read` tool to understand context
2. **Minimal changes**: Modify only what's necessary
3. **Respect existing style**: Maintain consistency with surrounding code
4. **Comment complex changes**: Explain the "why", not the "what"
5. **Don't overwrite**: Use `Edit` tool, not `Write`, except for new file creation

### Testing and Validation
```bash
# Neovim: verify Lua syntax
nvim --headless -c "luafile ~/.config/nvim/lua/config/options.lua" -c quit

# Fish: verify syntax
fish -n ~/.config/fish/config.fish

# Ghostty: verify it starts without errors
ghostty --version

# Starship: validate TOML
starship config
```

### Git Workflow
- **DO NOT create commits** unless explicitly requested by user
- **DO NOT use destructive commands**: `git reset --hard`, `git push --force`
- Verify changes with `git diff` before committing
- Commit messages: English or Spanish OK, format: `type: brief description`
  - Examples: `feat: add telescope plugin`, `fix: correct keybinding`, `docs: update README`

---

## Preferred CLI Tools

Use modern tools when available:
- `bat` instead of `cat`
- `rg` (ripgrep) instead of `grep`
- `fd` instead of `find`
- `eza` instead of `ls`
- `sd` instead of `sed`

Install via Homebrew if missing: `brew install <tool>`

---

## Important Notes

1. **This is NOT a project with tests**: Don't look for `npm test`, `cargo test`, etc.
2. **Changes require manual reload**: 
   - Neovim: `:Lazy sync` or restart
   - Fish: `exec fish`
   - Ghostty: `Cmd+Shift+,` or restart
   - Starship: `exec fish`
3. **Themes**: Currently uses Catppuccin Frappe. Theme changes must be consistent across nvim, ghostty, fish and starship
4. **Font**: IosevkaTerm Nerd Font or Monaspace Argon (verify configs before changing)
5. **Ask before assuming**: If something is unclear, ask ONCE with explicit assumption

---

## Main Agent

**OpenCode CLI** (`openai/gpt-5.1-codex`):
- Interacts in **Spanish** (can respond in English if requested)
- Prioritizes user instructions over conventions
- Uses specialized tools (Read, Edit, Grep, Glob)
- Documents changes made concisely
- Avoids destructive operations without explicit confirmation
