# LuaSnip Configuration for Neovim

This directory contains LuaSnip snippets configured according to the guide at https://ejmastnak.com/tutorials/vim-latex/luasnip/

**NEW**: Now includes `luasnip-latex-snippets.nvim` - a port of Gilles Castel's LaTeX snippets with hundreds of pre-made snippets!

## Directory Structure

```
luasnippets/
├── README.md           # This file
├── all.lua            # Global snippets (work in all filetypes)
└── tex/               # LaTeX-specific snippets
    ├── examples.lua   # Example snippets demonstrating features
    ├── math.lua       # Math snippets
    ├── fonts.lua      # Font commands
    ├── floats.lua     # Figure/table environments
    └── ...            # Other LaTeX snippet files
```

## Keybindings

### Snippet Expansion and Navigation
- `<Tab>` - Expand snippet or jump to next tabstop
- `<Shift-Tab>` - Jump to previous tabstop
- `<Ctrl-l>` - Cycle through choice nodes (if using them)
- `<leader>sr` - Reload snippets

### Visual Selection
1. Select text in visual mode (`v`, `V`, or `Ctrl-v`)
2. Press `<Tab>` to store the selection
3. Type snippet trigger that uses `get_visual`
4. Selected text appears in the snippet

## Helper Functions

The file `lua/luasnip-helper-funcs.lua` provides reusable functions:

### Visual Selection
- `get_visual(args, parent)` - Insert visually selected text

### LaTeX Context Detection (requires VimTeX)
- `in_mathzone()` - Returns true in math mode
- `in_text()` - Returns true outside math mode
- `in_comment()` - Returns true in comments
- `in_env(name)` - Returns true inside environment `name`
- `in_equation()` - Returns true in equation environment
- `in_tikz()` - Returns true in tikzpicture environment
- `line_begin()` - Returns true at start of line

## Writing Snippets

### Basic Structure

```lua
-- At the top of each snippet file
local helpers = require('luasnip-helper-funcs')
local get_visual = helpers.get_visual

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {
  -- Your snippets here
}
```

### Simple Text Expansion

```lua
s({trig = ";a", snippetType = "autosnippet"},
  { t("\\alpha") }
),
```

### With Insert Nodes

```lua
s({trig = "tt"},
  fmta("\\texttt{<>}", { i(1) })
),
```

### With Visual Selection

```lua
s({trig = "tii"},
  fmta("\\textit{<>}", { d(1, get_visual) })
),
```

### Regex Triggers (Prevent Expansion in Words)

```lua
s({trig = "([^%a])mm", wordTrig = false, regTrig = true, snippetType = "autosnippet"},
  fmta(
    "<>$<>$",
    {
      f(function(_, snip) return snip.captures[1] end),
      d(1, get_visual),
    }
  )
),
```

### Math-Only Snippets

```lua
s({trig = "ff", condition = helpers.in_mathzone, snippetType = "autosnippet"},
  fmta("\\frac{<>}{<>}", { i(1), i(2) })
),
```

### Line-Begin Snippets

```lua
local line_begin = require("luasnip.extras.expand_conditions").line_begin

s({trig = "beg", condition = line_begin, snippetType = "autosnippet"},
  fmta(
    [[
      \begin{<>}
          <>
      \end{<>}
    ]],
    { i(1), i(2), rep(1) }
  )
),
```

## Snippet Options

### In the trigger table:
- `trig` - The trigger string (required)
- `dscr` - Description
- `snippetType` - `"autosnippet"` for auto-expansion, `"snippet"` for manual
- `regTrig` - Set to `true` for regex triggers
- `wordTrig` - Set to `false` to allow expansion mid-word
- `condition` - Function that returns true when snippet should expand

### Common patterns:

```lua
-- Autosnippet that expands automatically
{trig = "mm", snippetType = "autosnippet"}

-- Regex trigger (with wordTrig=false)
{trig = "([^%a])ff", regTrig = true, wordTrig = false}

-- Conditional expansion (math only)
{trig = "ff", condition = helpers.in_mathzone}

-- Line-begin only
{trig = "eq", condition = line_begin}
```

## Node Types

- `t("text")` - Static text
- `i(1)` - Insert node (jump point 1)
- `i(0)` - Final cursor position
- `rep(1)` - Repeat content of node 1
- `d(1, get_visual)` - Dynamic node for visual selection
- `f(function(_, snip) return snip.captures[1] end)` - Function node for regex captures

## Tips

1. **Use autotriggered snippets** - Much faster than manual triggers
2. **Short triggers** - 2-3 characters work best
3. **Regex triggers** - Prevent expansion in words (e.g., `ff` in "offer")
4. **Math context** - Use `condition = helpers.in_mathzone` for math snippets
5. **Visual selection** - Great for surrounding existing text
6. **Home row triggers** - `jk`, `kl`, `df` are fast to type
7. **Reload snippets** - Use `<Leader>L` when editing snippets in another vim

## Available LaTeX Snippets

The `luasnip-latex-snippets.nvim` plugin provides hundreds of snippets including:

### Greek Letters
- `;a` → `\alpha`, `;b` → `\beta`, `;g` → `\gamma`, etc.

### Math Symbols
- `ff` → `\frac{}{}` (fractions)
- `sum` → `\sum_{}^{}` (summation)
- `int` → `\int_{}^{}` (integral)
- `lim` → `\lim_{}` (limit)

### Text Formatting
- `bf` → `\textbf{}` (bold)
- `it` → `\textit{}` (italic)
- `tt` → `\texttt{}` (typewriter)

### Environments
- `eq` → equation environment (at start of line)
- `ali` → align environment (at start of line)
- `item` → itemize environment (at start of line)

### And Many More!
Check the plugin documentation for the complete list of available snippets.

## Examples

See `tex/examples.lua` for comprehensive examples of all features.
