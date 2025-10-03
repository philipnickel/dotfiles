-- Treesitter configuration for LunarVim
-- This file contains treesitter language configurations

-- Treesitter configuration for LaTeX
vim.list_extend(lvim.builtin.treesitter.ensure_installed, {
  "markdown",
  "markdown_inline",
  "yaml",
  "html",
  "css",
  "javascript",
  "typescript",
  "lua",
  "latex",
  "bibtex",
})