-- Global snippets that work in all filetypes
-- Place snippets here that you want available everywhere

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
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

-- Return snippets table
return {
  -- Simple text snippet
  s({trig = "hello", dscr = "Hello world snippet"},
    fmta(
      "Hello, <>!",
      { i(1, "world") }
    )
  ),

  -- Example: Using visual selection
  s({trig = "quote", dscr = "Surround with double quotes"},
    fmta(
      [["<>"]],
      { d(1, get_visual) }
    )
  ),
}