if status is-interactive
    # Commands to run in interactive sessions can go here
    # Homebrew (Apple Silicon)
    fish_add_path -gP /opt/homebrew/bin /opt/homebrew/sbin

    # Claude Code CLI
    fish_add_path -gP ~/.local/bin

    # Soporte truecolor para Ghostty, Fish y Starship
    set -gx COLORTERM truecolor

    # OpenCode installer
    fish_add_path -gP ~/.opencode/bin

    # fisher (gestor de plugins para Fish)
    if not functions -q fisher
        set -l fisher_file $HOME/.config/fish/functions/fisher.fish
        if test -f $fisher_file
            source $fisher_file
        else
            curl -sL https://git.io/fisher | source
            fisher install jorgebucaran/fisher
        end
    end

    # zoxide (only if installed)
    if type -q zoxide
        zoxide init fish | source
    end

    # fnm (Node version manager)
    if type -q fnm
        fnm env --use-on-cd | source
    end

    # fnm
    if type -q fnm
        fnm env --shell fish | source
    end

    # atuin (shell history)
    if type -q atuin
        atuin init fish | source
    end

    # Starship prompt
    if type -q starship
        starship init fish | source
    end

    # tmux auto-start (solo en Ghostty/iTerm2 y si no estamos ya en tmux)
    if begin; set -q GHOSTTY_RESOURCES_DIR; or set -q ITERM_SESSION_ID; end; and not set -q TMUX
        exec tmux new-session -A -s main
    end
end

# opencode
fish_add_path /Users/naranjax/.opencode/bin
export PATH="$HOME/.local/bin:$PATH"


# Added by Antigravity CLI installer
set -gx PATH "/Users/naranjax/.local/bin" $PATH

# Added by Antigravity IDE
fish_add_path /Users/naranjax/.antigravity-ide/antigravity-ide/bin

# Added by Devin
fish_add_path /Users/naranjax/.codeium/windsurf/bin
