# Unlock Bitwarden and export BW_SESSION in the current shell.
bw-unlock() {
  emulate -L zsh
  setopt err_return

  if ! command -v bw >/dev/null; then
    print -u2 "Error: Bitwarden CLI 'bw' not found."
    return 1
  fi

  local token=""
  # Try macOS Keychain item (triggers Touch ID if you set Access Control)
  if command -v security >/dev/null; then
    local pw
    pw="$(security find-generic-password -a "$USER" -s bitwarden-master -w 2>/dev/null || true)"
    if [[ -n "$pw" ]]; then
      token="$(bw unlock "$pw" --raw)"
    fi
  fi

  # Fallback: interactive unlock
  if [[ -z "$token" ]]; then
    token="$(bw unlock --raw)"
  fi

  export BW_SESSION="$token"
  print "Vault unlocked. BW_SESSION set."
}
