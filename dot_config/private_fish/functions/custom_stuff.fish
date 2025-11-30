# clear shell screen and reload config
function c --description="clear screen"
  clear
  printf "\033[3J\033c\033[H\033[2J"
end

function s --description="reload config"
  source ~/.config/fish/config.fish
end

function cs --description="clear screen and reload config"
  c
  source ~/.config/fish/config.fish
end

function fd --description="fuzzy find directory"
  _fzf_search_directory
end

function fh --description="fuzzy find command from history"
  _fzf_search_history
end

function fgl --description="fuzzy find git log"
  _fzf_search_git_log
end

function fgs --description="fuzzy find git status"
  _fzf_search_git_status
end

function fp --description="Cracked content Fuzzy find"
  rga-fzf
end

function zf --description="fuzzy find with zoxide"
  zoxide query -l | fzf --height 40% --layout=reverse --ansi --preview 'tree -C {} | head -100' | read -l dir; and cd "$dir"
end

function zot --description="Cd to Zotero library"
  cd "/Users/philipnickel/Library/Mobile Documents/com~apple~CloudDocs/zotero/storage"
  fd
end
