-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

opts = {
  snippets = {
    preset = "luasnip",
  },
}

vim.opt.number = true
vim.opt.relativenumber = false
vim.g.autoformat = false
