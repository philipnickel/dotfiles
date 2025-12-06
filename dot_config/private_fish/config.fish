# ~/.config/fish/config.fish
# ─────────────────────────────────────────────────────────────────────────────
# Interactive guard
if status is-interactive
    # Silence greeting
    set -g fish_greeting

    # System info on new shell
    if type -q fastfetch
        fastfetch
    end
end

# ─────────────────────────────────────────────────────────────────────────────
# Homebrew (macOS)
# ─────────────────────────────────────────────────────────────────────────────
# Homebrew (macOS)
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end
# ─────────────────────────────────────────────────────────────────────────────
# D-Bus for zathura/vimtex synctex (macOS)
# ─────────────────────────────────────────────────────────────────────────────
if type -q launchctl
    # Try launchctl getenv first
    set -l dbus_socket (launchctl getenv DBUS_LAUNCHD_SESSION_BUS_SOCKET 2>/dev/null)
    # Fallback: parse launchctl print output
    if test -z "$dbus_socket"
        set dbus_socket (launchctl print gui/(id -u)/org.freedesktop.dbus-session 2>/dev/null | string match -r 'DBUS_LAUNCHD_SESSION_BUS_SOCKET => (.+)' | tail -1)
    end
    # Fallback: find socket via lsof (slower but reliable)
    if test -z "$dbus_socket"; and pgrep -q dbus-daemon
        set dbus_socket (lsof -c dbus-daemon 2>/dev/null | string match -r '/private/tmp/.+/unix_domain_listener' | head -1)
    end
    if test -n "$dbus_socket"
        set -gx DBUS_SESSION_BUS_ADDRESS "unix:path=$dbus_socket"
    end
end

# ─────────────────────────────────────────────────────────────────────────────
# Editor / PATH (use fish_user_paths, not PATH=…)
# ─────────────────────────────────────────────────────────────────────────────
set -gx EDITOR nvim

# Prepend custom bin dirs (dedup automatically)
for p in \
    $HOME/.local/bin \
    $HOME/.npm-global/bin \
    $HOME/.bun/bin \
    /Applications/flutter/bin \
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" \
    /usr/local/opt/python/libexec/bin
    if test -d $p
        fish_add_path --path $p
    end
end

# ─────────────────────────────────────────────────────────────────────────────
# Lazygit helper: change directory after exit (parity with your zsh function)
# ─────────────────────────────────────────────────────────────────────────────
function lg --description 'lazygit with post-exit cd support'
    set -gx LAZYGIT_NEW_DIR_FILE $HOME/.lazygit/newdir
    command lazygit $argv
    if test -f $LAZYGIT_NEW_DIR_FILE
        cd (cat $LAZYGIT_NEW_DIR_FILE)
        rm -f $LAZYGIT_NEW_DIR_FILE >/dev/null 2>&1
    end
end

# ─────────────────────────────────────────────────────────────────────────────
# Yazi helper: change directory after exit
# ─────────────────────────────────────────────────────────────────────────────
function y --description 'yazi with post-exit cd support'
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# ─────────────────────────────────────────────────────────────────────────────
# Aliases / Abbreviations
# ─────────────────────────────────────────────────────────────────────────────
alias nv "nvim"
alias lv "nvim"
alias sc "source ~/.config/fish/config.fish; echo 'sourced fish config'"
# clear screen + scrollback (closest to your zsh alias)
alias ca 'printf "\033[3J\033c\033[H\033[2J"'

# eza (ls) and tree view
if type -q eza
    abbr --add -g ls  'eza -G --classify --all --group-directories-first --icons=auto'
    abbr --add -g lst 'eza -G --classify --all --group-directories-first -T --icons=auto'
    abbr --add -g lsa 'eza -la --total-size'
end

# bat (cat)
if type -q bat
    abbr --add -g cat 'bat'
end

# trash (rm)
if type -q trash
    abbr --add -g rm 'trash'
end

# ─────────────────────────────────────────────────────────────────────────────
# zoxide / fzf
# ─────────────────────────────────────────────────────────────────────────────
if type -q zoxide
    zoxide init fish | source
end

# If you use PatrickF1/fzf.fish (recommended), these will exist:
if functions -q fzf_configure_bindings
    fzf_configure_bindings
end
set -g fzf_diff_highlighter "delta --paging=never --width=20"
set -g fzf_directory_opts --bind 'ctrl-o:execute($EDITOR {} &> /dev/tty)'

# ─────────────────────────────────────────────────────────────────────────────
# Bitwarden SSH agent (macOS paths)
# ─────────────────────────────────────────────────────────────────────────────
if test -S $HOME/.bitwarden-ssh-agent.sock
    set -gx SSH_AUTH_SOCK $HOME/.bitwarden-ssh-agent.sock
else if test -S $HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
    set -gx SSH_AUTH_SOCK $HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
end

# ─────────────────────────────────────────────────────────────────────────────
# Lua rocks
# ─────────────────────────────────────────────────────────────────────────────
set -gx LUA_PATH  "$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;$LUA_PATH"
set -gx LUA_CPATH "$HOME/.luarocks/lib/lua/5.1/?.so;$LUA_CPATH"

# ─────────────────────────────────────────────────────────────────────────────
# Keybindings tweaks (optional)
# ─────────────────────────────────────────────────────────────────────────────
# Clear line on Ctrl-C (built-in preset binding is usually fine)
bind --preset \cC 'cancel-commandline'
