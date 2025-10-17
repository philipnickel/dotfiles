-- Neovim Configuration
-- Entry point for the configuration

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

if vim.tbl_islist and vim.islist then
  vim.tbl_islist = vim.islist
end

-- Load core configurations
require("core.options")
require("core.keymaps")
require("core.colorscheme")

-- Load plugin manager and plugins
require("plugins.init")

-- Load language-specific configurations
require("lsp.init")

-- Load utility functions
require("utils.pdf_handler")
require("utils.smart-navigation").setup()
require("utils.sympy-config")
require("utils.luasnip-config")

require("utils.project-root").setup()
