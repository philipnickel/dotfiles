-- Basic LaTeX snippets

-- Load helper functions
local helpers = require('utils.luasnip-helper-funcs')

-- LuaSnip abbreviations
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

-- Return snippets table
return {
  -- Basic LaTeX commands
  s({trig = "bf", dscr = "Bold text"},
    fmt("\\textbf{{{}}}", { i(1, "text") })
  ),

  s({trig = "it", dscr = "Italic text"},
    fmt("\\textit{{{}}}", { i(1, "text") })
  ),

  s({trig = "em", dscr = "Emphasized text"},
    fmt("\\emph{{{}}}", { i(1, "text") })
  ),

  -- Math snippets
  s({trig = "eq", dscr = "Equation environment"},
    fmt([[
\begin{{equation}}
    {}
\end{{equation}}]], { i(1, "x = y") })
  ),

  s({trig = "align", dscr = "Align environment"},
    fmt([[
\begin{{align}}
    {}
\end{{align}}]], { i(1, "x &= y \\\\\n    z &= w") })
  ),
}