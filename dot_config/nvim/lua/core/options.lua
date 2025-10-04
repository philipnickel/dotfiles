-- Core Neovim options and settings

-- Basic settings
vim.opt.relativenumber = false
vim.opt.wrap = true
vim.opt.guifont = "JetBrainsMono Nerd Font Light:h14"
vim.opt.laststatus = 3
vim.opt.clipboard = "unnamedplus"

-- Nord theme UI settings to match terminal
vim.opt.background = "dark"
vim.opt.termguicolors = true

-- Ensure background is transparent to show terminal background
vim.opt.fillchars = {
  vert = "│",
  fold = " ",
  eob = " ",
  diff = "─",
  msgsep = "─",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
}

-- Window and buffer settings
vim.opt.number = true
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = ""

-- Tab and indent settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Window settings
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Scroll settings
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Completion settings
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Backup and swap settings
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true

-- Timeout settings
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 0

-- Spell checking
vim.opt.spell = false -- Enable manually with :set spell
vim.opt.spelllang = { "en_us" }
vim.opt.spellsuggest = "best,9"

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
