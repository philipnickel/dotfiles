# ─────────────────────────────────────────────────────────────────────────────
# macOS-specific configuration
# ─────────────────────────────────────────────────────────────────────────────

# Base system PATH with Homebrew
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/bin:${PATH:-}"

# macOS-specific paths
path+=(
  "$HOME/.npm-global/bin"
  "$HOME/.bun/bin"
  "/Applications/flutter/bin"
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  "/usr/local/opt/python/libexec/bin"
)

# Homebrew extras
if command -v brew >/dev/null 2>&1; then
  export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:${DYLD_LIBRARY_PATH:-}"
fi

# DBus for macOS
if command -v launchctl >/dev/null 2>&1; then
  dbus_socket="$(launchctl print "gui/$(id -u)/org.freedesktop.dbus-session" 2>/dev/null | awk -F' => ' '/DBUS_LAUNCHD_SESSION_BUS_SOCKET/ {print $2; exit}')"
  [[ -n "$dbus_socket" ]] && export DBUS_SESSION_BUS_ADDRESS="unix:path=$dbus_socket"
fi

# Lua rocks
export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;${LUA_PATH:-}"
export LUA_CPATH="$HOME/.luarocks/lib/lua/5.1/?.so;${LUA_CPATH:-}"

# Bitwarden SSH Agent (macOS paths)
if [[ -S "$HOME/.bitwarden-ssh-agent.sock" ]]; then
  export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
elif [[ -S "$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock" ]]; then
  export SSH_AUTH_SOCK="$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
fi

