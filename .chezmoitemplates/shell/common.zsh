# ─────────────────────────────────────────────────────────────────────────────
# Common shell configuration (all platforms)
# ─────────────────────────────────────────────────────────────────────────────

# Powerlevel10k instant prompt (must stay near the top)
source ~/.p10k.zsh

# ─────────────────────────────────────────────────────────────────────────────
# Environment
# ─────────────────────────────────────────────────────────────────────────────
export EDITOR="nvim"

# User binaries
typeset -aU path
path=(
  "$HOME/.local/bin"
  $path
)

# ─────────────────────────────────────────────────────────────────────────────
# Oh-My-Zsh
# ─────────────────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CACHE_DIR="$ZSH/cache"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump-$HOST-$ZSH_VERSION"
export DISABLE_UPDATE_PROMPT=true
export DISABLE_AUTO_UPDATE=true
export ZSH_DISABLE_COMPFIX=true

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_CUSTOM="$ZSH/custom"

# Plugins (syntax-highlighting should be last)
plugins=(
  git
  you-should-use
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# Optional: legacy bash aliases
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

# ─────────────────────────────────────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────────────────────────────────────
alias lg='lazygit'
alias lv='nvim'
alias nv='nvim'
alias dotfrg='cd "$HOME/.local/share/chezmoi" && rgf'

# zoxide
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# fzf
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# ─────────────────────────────────────────────────────────────────────────────
# ripgrep + fzf helper
# ─────────────────────────────────────────────────────────────────────────────
rgf() {
  local preview="cat"
  command -v bat >/dev/null 2>&1 && preview="bat --color=always"

  local -a fzf_cmd=(fzf)
  if command -v fzf-tmux >/dev/null 2>&1 && [[ -n "$TMUX" ]]; then
    fzf_cmd=(fzf-tmux -p)
  fi

  "${fzf_cmd[@]}" \
    --bind "change:reload(rg --column --line-number --no-heading --color=always --smart-case --fixed-strings {q} || true)" \
    --ansi \
    --preview "$preview {1} --highlight-line {2}" \
    --delimiter : \
    --nth 3.. \
    --bind 'enter:execute(nvim +{2} {1})' \
    --header "Type to search (rg). Enter: open in nvim. Ctrl-D: cancel."
}

# ─────────────────────────────────────────────────────────────────────────────
# Custom scripts
# ─────────────────────────────────────────────────────────────────────────────
# Load personal command functions
PN_FUNC_DIR="$HOME/.config/pn/functions"
if [[ -d "$PN_FUNC_DIR" ]]; then
  for f in "$PN_FUNC_DIR"/*.zsh(N); do
    source "$f"
  done
fi

# Helper to list your commands
pn-list() {
  emulate -L zsh
  print "Loaded commands:"
  for f in "$PN_FUNC_DIR"/*.zsh(N:t); do
    print "  ${f%.zsh}"
  done
}

# ─────────────────────────────────────────────────────────────────────────────
# Shell completions
# ─────────────────────────────────────────────────────────────────────────────
command -v uv >/dev/null 2>&1 && eval "$(uv generate-shell-completion zsh)"
