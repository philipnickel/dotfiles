-- LuaSnip Helper Functions
-- This file contains reusable helper functions for LuaSnip snippets

local M = {}

-- LuaSnip node abbreviations (required for the functions below)
local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node

-- ============================================================================
-- Visual Selection Helper
-- ============================================================================

--- Returns a snippet node containing the visual selection or an empty insert node
--- @param args table: arguments passed by LuaSnip
--- @param parent table: parent snippet
--- @return table: snippet node
function M.get_visual(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end

-- ============================================================================
-- LaTeX-Specific Conditional Expansion Functions (requires VimTeX)
-- ============================================================================

--- Check if cursor is in a LaTeX math zone
--- @return boolean
function M.in_mathzone()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

--- Check if cursor is in LaTeX text (not math)
--- @return boolean
function M.in_text()
  return not M.in_mathzone()
end

--- Check if cursor is in a LaTeX comment
--- @return boolean
function M.in_comment()
  return vim.fn['vimtex#syntax#in_comment']() == 1
end

--- Check if cursor is inside a specific LaTeX environment
--- @param name string: environment name (e.g., "equation", "itemize")
--- @return boolean
function M.in_env(name)
  local is_inside = vim.fn['vimtex#env#is_inside'](name)
  return (is_inside[1] > 0 and is_inside[2] > 0)
end

--- Check if cursor is in an equation environment
--- @return boolean
function M.in_equation()
  return M.in_env('equation')
end

--- Check if cursor is in an itemize environment
--- @return boolean
function M.in_itemize()
  return M.in_env('itemize')
end

--- Check if cursor is in an enumerate environment
--- @return boolean
function M.in_enumerate()
  return M.in_env('enumerate')
end

--- Check if cursor is in a tikzpicture environment
--- @return boolean
function M.in_tikz()
  return M.in_env('tikzpicture')
end

--- Check if cursor is in an align environment
--- @return boolean
function M.in_align()
  return M.in_env('align') or M.in_env('align*')
end

-- ============================================================================
-- Line Position Helpers
-- ============================================================================

--- Check if cursor is at the beginning of a line (with optional whitespace)
--- @return boolean
function M.line_begin()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col('.') - 1
  return line:sub(1, col):match("^%s*$") ~= nil
end

--- Check if cursor is on an even-numbered line
--- @return boolean
function M.is_even_line()
  local line_number = vim.fn.line('.')
  return (line_number % 2) == 0
end

return M
