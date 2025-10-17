# Minimal DTU login: key via agent + auto-send DTU password only if asked.
# Uses ControlMaster so the final interactive ssh is NOT tied to expect.
dtu-hpc() {
  emulate -L zsh
  setopt err_return

  for cmd in bw expect ssh; do
    command -v "$cmd" >/dev/null || { print -u2 "Error: '$cmd' not found."; return 1; }
  done

  # Ensure Bitwarden is unlocked so we can read the DTU password.
  if [[ -z "${BW_SESSION:-}" ]]; then
    if typeset -f bw-unlock >/dev/null; then
      bw-unlock || { print -u2 "bw-unlock failed."; return 1; }
    else
      print -u2 "BW_SESSION not set. Run 'bw-unlock' first."; return 1
    fi
  fi

  # Your Bitwarden item UUID for the DTU ACCOUNT password:
  local bw_item_id="1ea643f0-f32e-4873-867a-b36e00722b8"
  local pw
  pw="$(bw get password "$bw_item_id" --raw 2>/dev/null || true)"
  [[ -z "$pw" ]] && { print -u2 "Could not read DTU password from Bitwarden."; return 1; }

  # ControlMaster socket path (unique-ish)
  local cpath="/tmp/ssh-ctl-hpc_dtu-$UID"

  # Export for expect to read
  export BW_PASS="$pw" CPATH="$cpath"
  unset pw

  # 1) Open a background master connection (will prompt for password if needed)
  expect <<'EXPECT'
    log_user 1
    set timeout 90

    # Open a master connection that will persist for 10 minutes.
    # -f: background *after* auth; -N: no remote command.
    set sshcmd [list ssh -tt \
      -o ControlMaster=yes \
      -o ControlPath=$env(CPATH) \
      -o ControlPersist=600 \
      -o NumberOfPasswordPrompts=1 \
      -o PreferredAuthentications=publickey,password,keyboard-interactive \
      hpc_dtu -N -f]

    spawn {*}$sshcmd

    expect {
      -re "(?i)are you sure you want to continue connecting" {
        send -- "yes\r"
        exp_continue
      }
      -re "(?i)password: *$" {
        send -- "$env(BW_PASS)\r"
        exp_continue
      }
      timeout {
        puts "Timed out establishing master connection."
        exit 1
      }
      eof {
        # ssh backgrounds itself after auth (-f), so we should hit EOF here.
        exit 0
      }
    }
EXPECT

  # We don't need the password anymore.
  unset BW_PASS

  # 2) Start a *normal* interactive session via the master connection.
  #    This is a plain ssh in your shell; it won't die when expect exits.
  ssh -tt -o ControlPath="$cpath" hpc_dtu

  # 3) When you exit the session, close the master socket to be tidy.
  ssh -O exit -o ControlPath="$cpath" hpc_dtu >/dev/null 2>&1 || true
}
