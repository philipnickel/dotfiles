-- Colorscheme configuration

-- Set default colorscheme (with fallback)
local function set_colorscheme()
  local ok, _ = pcall(vim.cmd, "colorscheme catppuccin-frappe")
  if not ok then
    vim.cmd("colorscheme default")
    vim.notify("Catppuccin colorscheme not available, using default", vim.log.levels.WARN)
  end
end

-- Set colorscheme after plugins are loaded
vim.api.nvim_create_autocmd("VimEnter", {
  callback = set_colorscheme,
  once = true,
})

-- Configure lualine theme to match catppuccin
vim.g.lualine_theme = "catppuccin"