-- Core Neovim options and settings

-- Python provider: prefer active virtualenv (uv), then uv-managed default, then system python
local function normalize(path)
  if not path or path == "" then
    return nil
  end
  path = vim.fn.expand(path)
  local stat = vim.loop.fs_stat(path) or vim.loop.fs_lstat(path)
  if stat and (stat.type == "file" or stat.type == "link") then
    return path
  end
  return nil
end

local default_uv_python = normalize("~/.local/share/uv/nvim-python/bin/python")
if default_uv_python then
  vim.g.python3_host_prog = default_uv_python
end

local ensured_hosts = {}

local function ensure_python_host_packages(host)
  if not host or host == "" or ensured_hosts[host] then
    return
  end
  if vim.fn.executable("uv") ~= 1 then
    return
  end
  local args = {
    "uv",
    "pip",
    "install",
    "--python",
    host,
    "pynvim",
  }
  local result = vim.system(args):wait()
  if result and result.code == 0 then
    ensured_hosts[host] = true
  end
end

local function update_python_host()
  local venv = vim.env.VIRTUAL_ENV
  if venv and venv ~= "" then
    local venv_python = normalize(venv .. "/bin/python")
    if not venv_python then
      venv_python = normalize(venv .. "/Scripts/python.exe")
    end
    if venv_python then
      if vim.g.python3_host_prog ~= venv_python then
        vim.g.python3_host_prog = venv_python
      end
      ensure_python_host_packages(vim.g.python3_host_prog)
      return
    end
  end

  if default_uv_python then
    if vim.g.python3_host_prog ~= default_uv_python then
      vim.g.python3_host_prog = default_uv_python
    end
    ensure_python_host_packages(vim.g.python3_host_prog)
    return
  end

  local system_python = normalize(vim.fn.exepath("python3"))
  if not system_python then
    system_python = normalize(vim.fn.exepath("python"))
  end
  if system_python then
    vim.g.python3_host_prog = system_python
    ensure_python_host_packages(vim.g.python3_host_prog)
  end
end

update_python_host()

vim.api.nvim_create_autocmd({ "DirChanged", "BufEnter" }, {
  callback = function()
    update_python_host()
  end,
})

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

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    pcall(vim.highlight.on_yank, { higroup = "IncSearch", timeout = 200 })
  end,
})
