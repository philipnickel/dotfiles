# AGENTS.md — Dotfiles (chezmoi)

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/). macOS primary,
Linux secondary. Configuration for Neovim (LazyVim), Fish shell, WezTerm,
tmux, Sketchybar, AeroSpace, Yazi, Lazygit, Zathura, and more.

## Repository Layout

```
.chezmoiignore              chezmoi ignore rules (Go template)
dot_config/
  nvim/                     Neovim (LazyVim) — Lua
  sketchybar/               macOS status bar — Lua + C helpers + shell plugins
  private_fish/             Fish shell config and functions
  yazi/                     Yazi file manager + plugins
  lazygit/                  Lazygit config (YAML)
  gh/ gh-dash/              GitHub CLI configs
  zathura/                  PDF viewer config
dot_aerospace.toml          AeroSpace tiling WM (macOS only)
dot_gitconfig               Git global config
dot_tmux.conf.tmpl          tmux config (chezmoi template)
dot_wezterm.lua.tmpl        WezTerm config (chezmoi template)
private_dot_ssh/            SSH config (private permissions)
dot_local/bin/              User scripts
```

## Chezmoi File Naming Conventions

These prefixes are **required by chezmoi** — do not rename files without understanding the mapping:

| Prefix | Meaning | Example |
|--------|---------|---------|
| `dot_` | Maps to `.` prefix in target | `dot_gitconfig` → `~/.gitconfig` |
| `private_` | Installed with restricted (0600/0700) permissions | `private_dot_ssh/` |
| `executable_` | Installed with execute bit set | `executable_sketchybarrc` |
| `readonly_` | Installed read-only | `readonly_main.lua` |
| `.tmpl` suffix | Processed by Go text/template at apply time | `dot_tmux.conf.tmpl` |

## Build / Apply / Lint Commands

### Chezmoi (dotfile management)

```sh
chezmoi apply              # Apply all dotfiles to $HOME
chezmoi apply --verbose    # Apply with detailed output
chezmoi diff               # Show what would change
chezmoi edit <file>        # Edit a managed file in the source dir
chezmoi add <file>         # Add a new file to chezmoi management
chezmoi unmanaged          # List unmanaged files in target dirs
```

### Sketchybar C Helpers (only build target in repo)

```sh
# From dot_config/sketchybar/helpers/
make                       # Builds all C event providers and menus
make -C event_providers    # Build cpu_load and network_load providers only
make -C menus              # Build menu helper only
```

### Lua Formatting

```sh
stylua dot_config/nvim/    # Format all Neovim Lua files
stylua --check dot_config/nvim/  # Check without modifying
```

Config: `dot_config/nvim/stylua.toml` — 2 spaces, 120 column width.

### No Test Framework

This is a dotfiles repo. There are no automated tests. Validate changes with
`chezmoi diff` before `chezmoi apply`.

## Chezmoi Templating

Templates use Go `text/template` syntax. Only three files use templates, all
for OS-conditional logic:

```
{{- if eq .chezmoi.os "darwin" }}
# macOS-specific config
{{- else if eq .chezmoi.os "linux" }}
# Linux-specific config
{{- end }}
```

- Always use `{{-` (trim whitespace) to avoid blank lines in output
- Only use templates when cross-platform differences genuinely exist
- Available data: `.chezmoi.os`, `.chezmoi.arch`, `.chezmoi.hostname`, etc.

## Code Style Guidelines

### Lua (Neovim — LazyVim)

- **Indent**: 2 spaces (enforced by StyLua)
- **Line width**: 120 characters max
- **Plugin specs**: One file per plugin/feature in `lua/plugins/`, each returning a table
- **Imports**: No top-level `require()` in plugin specs; use LazyVim's `dependencies` key
- **Naming**: `snake_case` for variables and functions
- **Error handling**: `pcall()` for optional modules with graceful fallback:
  ```lua
  local ok, mod = pcall(require, "some.module")
  if not ok then return end
  ```
- **Guard clauses**: Prefer early returns over deep nesting
- **Type annotations**: Use LuaCATS `---@` annotations for complex configs:
  ```lua
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  ---@param opts SomeType
  ```
- **Comments**: Use section headers with dashes (`-- ---- Section ----`) for
  logical groupings; numbered step comments in complex `config` functions

### Lua (Sketchybar)

- **Indent**: 2 spaces (match Neovim convention)
- **Imports**: Consistent preamble at top of item files:
  ```lua
  local colors = require("colors")
  local icons = require("icons")
  local settings = require("settings")
  ```
- **File organization**: Barrel `init.lua` files aggregate `require()` calls
- **Naming**: `snake_case` for everything

### Fish Shell

- **Section headers**: Use horizontal-rule comments for major sections:
  ```fish
  # ─────────────────────────────────────────────────────────────────────────────
  # Section Name
  # ─────────────────────────────────────────────────────────────────────────────
  ```
- **Functions**: Use `--description` flags on function definitions
- **Tool checks**: Guard with `if type -q <tool>` before using optional tools
- **Abbreviations**: Prefer `abbr --add -g` over `alias`
- **Environment variables**: `set -gx VAR value`

### Shell Scripts (Bash/sh — Sketchybar plugins)

- **Variables**: `UPPER_CASE` for all variables
- **Indent**: 2 spaces
- **Shebang**: `#!/bin/sh` (POSIX sh, not bash)
- **Error handling**: Simple conditionals with `exit 0` for early termination
- **Comments**: Include reference URLs for API documentation

### C (Sketchybar helpers)

- **Indent**: 2 spaces
- **Naming**: `snake_case` for functions and struct members; `UPPER_CASE` for
  macros and enum values
- **Error handling**: Check return codes, print error message, exit/return early

### TOML / YAML Config Files

- **Indent**: 2 spaces
- **Comments**: Include reference URLs to upstream documentation

## Theme and Visual Consistency

**Catppuccin Frappe** is the universal color theme across all tools. When adding
or modifying visual config, use Catppuccin Frappe colors. Transparency/blur is
enabled where supported (WezTerm 0.80 opacity, blur 60; Neovide 0.70 opacity).
Font: **JetBrains Mono** / **JetBrainsMono Nerd Font**.

## Git Conventions

- Remote: `git@github.com:philipnickel/dotfiles.git`
- Single `main` branch
- Keep commits focused; no conventional-commits format enforced
- Do not commit secrets or credentials
- The `.chezmoiignore` excludes runtime-generated files (lazy-lock.json,
  fish_variables); respect these exclusions

## Key Patterns to Preserve

1. **One concern per file** in Neovim plugins and Sketchybar items
2. **Minimal templating** — only use `.tmpl` for genuine cross-platform needs
3. **Defensive loading** — always `pcall` optional Lua modules
4. **Guard clauses** — early return over nested conditionals
5. **Consistent color theme** — Catppuccin Frappe everywhere
6. **chezmoi prefixes** — never strip `dot_`, `private_`, `executable_`, `readonly_`
