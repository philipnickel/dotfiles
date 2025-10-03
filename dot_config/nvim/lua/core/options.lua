-- Core Neovim options and settings

-- Basic settings
vim.opt.relativenumber = false
vim.opt.wrap = true
vim.opt.guifont = "JetBrainsMono Nerd Font Light:h14"
vim.opt.laststatus = 3
vim.opt.clipboard = "unnamedplus"

-- Suppress deprecation warnings by overriding the deprecated function
vim.tbl_add_reverse_lookup = function(tbl)
  -- Create reverse lookup table without deprecation warning
  local reverse = {}
  for k, v in pairs(tbl) do
    reverse[v] = k
  end
  return reverse
end

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    pcall(vim.highlight.on_yank, { higroup = "IncSearch", timeout = 200 })
  end,
})
