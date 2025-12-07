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
vim.g.maplocalleader = "-"

-- Soft wrap (visual only, doesn't modify the file)
vim.opt.wrap = true
vim.opt.linebreak = true      -- Wrap at word boundaries, not mid-word
vim.opt.breakindent = true    -- Preserve indentation on wrapped lines
vim.opt.breakindentopt = "shift:2"  -- Extra indent for wrapped lines
vim.opt.showbreak = "↪ "      -- Visual indicator for wrapped lines
