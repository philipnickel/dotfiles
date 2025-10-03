-- Example LaTeX snippets demonstrating the helper functions
-- This file shows you how to use the various features from the guide

-- Load helper functions
local helpers = require('utils.luasnip-helper-funcs')
local get_visual = helpers.get_visual

-- LuaSnip abbreviations
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  -- =========================================================================
  -- Basic Examples
  -- =========================================================================

  -- Simple text expansion
  s({trig = ";a", snippetType = "autosnippet"},
    { t("\\alpha") }
  ),

  s({trig = ";b", snippetType = "autosnippet"},
    { t("\\beta") }
  ),

  s({trig = ";g", snippetType = "autosnippet"},
    { t("\\gamma") }
  ),

  -- Using fmta for better readability
  s({trig = "tt", dscr = "Expands 'tt' into '\\texttt{}'"},
    fmta("\\texttt{<>}", { i(1) })
  ),

  s({trig = "tii", dscr = "Italic text with visual selection"},
    fmta("\\textit{<>}", { d(1, get_visual) })
  ),

  -- =========================================================================
  -- Regex Triggers (prevents expansion in words)
  -- =========================================================================

  -- mm expands to inline math, but not in words like "comment"
  s({trig = "([^%a])mm", wordTrig = false, regTrig = true, snippetType = "autosnippet"},
    fmta(
      "<>$<>$",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual),
      }
    )
  ),

  -- ff expands to frac, but not in words like "off"
  s({trig = '([^%a])ff', regTrig = true, wordTrig = false, snippetType = "autosnippet"},
    fmta(
      [[<>\frac{<>}{<>}]],
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1),
        i(2)
      }
    )
  ),

  -- =========================================================================
  -- Math-Context Specific Snippets
  -- =========================================================================

  -- This ff only expands in math mode (alternative to regex trigger)
  s({trig = "ff", dscr = "Fraction (math only)", condition = helpers.in_mathzone, snippetType = "autosnippet"},
    fmta(
      "\\frac{<>}{<>}",
      { i(1), i(2) }
    )
  ),

  -- Square root, only in math
  s({trig = "sq", dscr = "Square root", condition = helpers.in_mathzone, snippetType = "autosnippet"},
    fmta("\\sqrt{<>}", { d(1, get_visual) })
  ),

  -- =========================================================================
  -- Line-Begin Snippets (for environments)
  -- =========================================================================

  -- New environment
  s({trig = "beg", dscr = "Begin/end environment", condition = line_begin, snippetType = "autosnippet"},
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        rep(1),
      }
    )
  ),

  -- Equation environment
  s({trig = "eq", dscr = "Equation environment", condition = line_begin},
    fmta(
      [[
        \begin{equation}
            <>
        \end{equation}
      ]],
      { i(0) }  -- i(0) is the final cursor position
    )
  ),

  -- Section command
  s({trig = "h1", dscr = "Section", condition = line_begin},
    fmta([[\section{<>}]], { i(1) })
  ),

  s({trig = "h2", dscr = "Subsection", condition = line_begin},
    fmta([[\subsection{<>}]], { i(1) })
  ),

  -- =========================================================================
  -- Environment-Specific Snippets
  -- =========================================================================

  -- Draw command, only in tikzpicture
  s({trig = "dd", dscr = "Draw command (TikZ only)", condition = helpers.in_tikz, snippetType = "autosnippet"},
    fmta(
      "\\draw [<>] ",
      { i(1, "params") }
    )
  ),

  -- =========================================================================
  -- Repeated Nodes (Mirrored Tabstops)
  -- =========================================================================

  s({trig = "env", dscr = "Generic environment with mirrored name", snippetType = "autosnippet"},
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        rep(1),  -- Repeats the value of i(1)
      }
    )
  ),

  -- =========================================================================
  -- Placeholder Text
  -- =========================================================================

  s({trig = "hr", dscr = "Hyperref href command"},
    fmta(
      [[\href{<>}{<>}]],
      {
        i(1, "url"),
        i(2, "display name"),
      }
    )
  ),
}
