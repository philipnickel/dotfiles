# LuaSnip Setup Complete! ✅

Your Neovim is now configured with LuaSnip and luasnip-latex-snippets following the guide from https://ejmastnak.com/tutorials/vim-latex/luasnip/

## What Was Added

### Configuration Files
1. **`lua/plugins/editing.lua`** - LuaSnip plugin configuration
   - LuaSnip with luasnip-latex-snippets integration
   - Keybindings for snippet expansion and navigation
   - Enabled autosnippets and visual selection
   - VimTeX integration for math mode detection

2. **`lua/luasnip-helper-funcs.lua`** - Reusable helper functions
   - `get_visual()` for visual selection
   - LaTeX context detection (math, text, comments, environments)
   - VimTeX integration for smart snippet expansion

### Snippet Files
3. **`luasnippets/all.lua`** - Global snippets (work everywhere)
4. **`luasnippets/tex/examples.lua`** - Example LaTeX snippets
5. **`luasnippets/README.md`** - Comprehensive documentation

### New LaTeX Snippets Plugin
6. **`iurimateus/luasnip-latex-snippets.nvim`** - Port of Gilles Castel's LaTeX snippets
   - Hundreds of LaTeX snippets for math, text formatting, environments
   - Smart math mode detection using VimTeX
   - Works in both `.tex` and `.md` files

## Quick Start

### Keybindings
- **`<Tab>`** - Expand snippet or jump forward
- **`<Shift-Tab>`** - Jump backward
- **`<Ctrl-l>`** - Cycle through choice nodes
- **`<leader>sr`** - Reload snippets

### Visual Selection Workflow
1. Select text in visual mode (`V` or `v`)
2. Press `<Tab>` to store selection
3. Type a snippet trigger that uses `get_visual`
4. Selected text appears in the snippet!

### Try These Examples

Open a `.tex` file and try:

1. **Type** `;a` → expands to `\alpha` (Greek letters)
2. **Type** `ff` (in math mode) → expands to `\frac{}{}` (fractions)
3. **Type** `sum` (in math mode) → expands to `\sum_{}^{}` (summation)
4. **Type** `bf` → expands to `\textbf{}` (bold text)
5. **Type** `eq` (at start of line) → creates equation environment
6. **Type** `item` (at start of line) → creates itemize environment

### Visual Selection Example
1. Open a `.tex` file
2. Type some text: `hello world`
3. Select "hello world" with `V`
4. Press `<Tab>`
5. Type `tii` → wraps in `\textit{hello world}`

## Writing Your Own Snippets

### Template for New Snippet File

```lua
-- Load helpers at the top of each snippet file
local helpers = require('luasnip-helper-funcs')
local get_visual = helpers.get_visual

-- LuaSnip abbreviations
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {
  -- Simple snippet
  s({trig = "hello"},
    { t("Hello, world!") }
  ),

  -- With insert nodes
  s({trig = "cmd"},
    fmta("\\command{<>}", { i(1) })
  ),

  -- With visual selection
  s({trig = "bold"},
    fmta("\\textbf{<>}", { d(1, get_visual) })
  ),

  -- Math-only snippet
  s({trig = "sum", condition = helpers.in_mathzone, snippetType = "autosnippet"},
    fmta("\\sum_{<>}^{<>}", { i(1), i(2) })
  ),
}
```

### Where to Put Snippets

- **Global snippets**: `luasnippets/all.lua`
- **LaTeX snippets**: `luasnippets/tex/*.lua` (any filename works)
- **Python snippets**: `luasnippets/python.lua`
- **Markdown snippets**: `luasnippets/markdown.lua`

### Available LaTeX Snippets

The `luasnip-latex-snippets.nvim` plugin provides hundreds of snippets including:

- **Greek letters**: `;a` → `\alpha`, `;b` → `\beta`, etc.
- **Math symbols**: `ff` → `\frac{}{}`, `sum` → `\sum_{}^{}`, `int` → `\int_{}^{}`
- **Text formatting**: `bf` → `\textbf{}`, `it` → `\textit{}`, `tt` → `\texttt{}`
- **Environments**: `eq` → equation, `ali` → align, `item` → itemize
- **And many more!** Check the plugin documentation for the full list

## Next Steps

1. **Read the documentation**: `~/.config/lvim/luasnippets/README.md`
2. **Study examples**: `~/.config/lvim/luasnippets/tex/examples.lua`
3. **Check existing snippets**: Your `tex/` folder has many snippets already!
4. **Read the full guide**: https://ejmastnak.com/tutorials/vim-latex/luasnip/

## Troubleshooting

### Snippets not working?
1. Restart LunarVim completely
2. Check for errors with `:LspInfo` and `:checkhealth luasnip`
3. Try `:lua print(vim.inspect(require('luasnip').get_snippets()))`

### VimTeX functions not working?
- Make sure VimTeX plugin is installed and active
- Open a `.tex` file to activate VimTeX

### Need to reload snippets?
- Press `<Leader>L` or `<Leader>sr`
- Or restart LunarVim

## Resources

- **Official LuaSnip docs**: `:help luasnip`
- **Guide this is based on**: https://ejmastnak.com/tutorials/vim-latex/luasnip/
- **LuaSnip GitHub**: https://github.com/L3MON4D3/LuaSnip
- **LaTeX snippets plugin**: https://github.com/iurimateus/luasnip-latex-snippets.nvim
- **Your snippet README**: `~/.config/lvim/luasnippets/README.md`

Happy snippet writing! 🚀
