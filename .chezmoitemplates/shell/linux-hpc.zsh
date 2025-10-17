# ─────────────────────────────────────────────────────────────────────────────
# Linux HPC configuration (DTU Scientific Linux)
# ─────────────────────────────────────────────────────────────────────────────

# Base system PATH (Linux standard)
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"

# HPC module system (if available)
if [[ -f /appl/lmod/lmod/init/zsh ]]; then
  source /appl/lmod/lmod/init/zsh
elif [[ -f /usr/share/lmod/lmod/init/zsh ]]; then
  source /usr/share/lmod/lmod/init/zsh
fi

# Common HPC paths
path+=(
  "$HOME/.npm-global/bin"
  "$HOME/.bun/bin"
)

# Linux standard library paths
export LD_LIBRARY_PATH="$HOME/.local/lib:${LD_LIBRARY_PATH:-}"

# Bitwarden SSH Agent (Linux paths)
if [[ -S "$HOME/.bitwarden-ssh-agent.sock" ]]; then
  export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
fi

# Linux-specific aliases
command -v xdg-open >/dev/null 2>&1 && alias open='xdg-open'
alias pdf='xdg-open'
