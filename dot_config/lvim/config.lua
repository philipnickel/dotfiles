-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- Basic settings
lvim.transparent_window = false
vim.opt.relativenumber = false
vim.opt.wrap = true
vim.opt.guifont = "JetBrainsMono Nerd Font Light:h14"
vim.opt.laststatus = 0
lvim.colorscheme = "nordic"
lvim.builtin.lualine.options.theme = "nordic"

local function open_chezmoi_files()
  local ok, telescope = pcall(require, 'telescope')
  if not ok then
    vim.notify('telescope not available', vim.log.levels.WARN)
    return
  end
  if not (telescope.extensions and telescope.extensions.chezmoi) then
    local ok_ext = pcall(telescope.load_extension, 'chezmoi')
    if not ok_ext then
      vim.notify('failed to load chezmoi telescope extension', vim.log.levels.WARN)
      return
    end
  end
  if telescope.extensions and telescope.extensions.chezmoi then
    telescope.extensions.chezmoi.find_files()
  else
    vim.notify('chezmoi telescope extension not available', vim.log.levels.WARN)
  end
end

_G.LVIM_OPEN_CHEZMOI_FILES = open_chezmoi_files

-- Suppress deprecation warnings by overriding the deprecated function
vim.tbl_add_reverse_lookup = function(tbl)
  -- Create reverse lookup table without deprecation warning
  local reverse = {}
  for k, v in pairs(tbl) do
    reverse[v] = k
  end
  return reverse
end


-- Leader key is set to space by default in LunarVim

-- Configure which-key to avoid loading conflicts
lvim.builtin.which_key.active = true
lvim.builtin.which_key.setup = lvim.builtin.which_key.setup or {}

-- Use LunarVim's built-in which-key system
lvim.builtin.which_key.mappings["p"] = {
  name = "Preview",
  p = { "<cmd>RenderMarkdown toggle<cr>", "Toggle Render Markdown" },
}

lvim.builtin.which_key.mappings["l"] = {
  name = "LaTeX",
  l = { "<cmd>VimtexCompile<cr>", "Compile" },
  v = { "<cmd>VimtexView<cr>", "View PDF" },
  k = { "<cmd>VimtexStop<cr>", "Stop" },
  e = { "<cmd>VimtexErrors<cr>", "Show Errors" },
  o = { "<cmd>VimtexCompileOutput<cr>", "Show Output" },
  g = { "<cmd>VimtexStatus<cr>", "Status" },
  G = { "<cmd>VimtexStatusAll<cr>", "Status All" },
  c = { "<cmd>VimtexClean<cr>", "Clean" },
  C = { "<cmd>VimtexClean!<cr>", "Clean!" },
  m = { "<cmd>VimtexImapsList<cr>", "Imaps List" },
  x = { "<cmd>VimtexReload<cr>", "Reload" },
  s = { "<cmd>VimtexToggleMain<cr>", "Toggle Main" },
}

lvim.builtin.which_key.mappings["f"] = {
  name = "Find",
  f = { "<cmd>Telescope find_files<cr>", "Find File" },
  g = { "<cmd>Telescope live_grep<cr>", "Grep Text" },
  b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
  h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
  r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
  c = { "<cmd>Telescope commands<cr>", "Commands" },
}

lvim.builtin.which_key.mappings["C"] = {
  name = "ChezMoi",
  f = { open_chezmoi_files, "Find managed file" },
  e = { "<cmd>ChezmoiEdit<space>", "Edit target" },
  l = { "<cmd>ChezmoiList<cr>", "List files" },
}

do
  local alpha = lvim.builtin.alpha
  if alpha and alpha.dashboard and alpha.dashboard.section and alpha.dashboard.section.buttons then
    local entries = alpha.dashboard.section.buttons.entries or alpha.dashboard.section.buttons.val
    if entries then
      for _, entry in ipairs(entries) do
        if entry[1] == 'c' then
          entry[2] = lvim.icons.ui.Gear .. '  ChezMoi config'
          entry[3] = '<CMD>lua LVIM_OPEN_CHEZMOI_FILES()<CR>'
        end
      end
    end
  end
end

lvim.builtin.which_key.mappings["y"] = { "<cmd>YankBank<cr>", "YankBank" }

-- Source configuration files
require("plugins")
require("keymaps")
require("lsp")
require("treesitter")
require("filetypes")
require("pdf_handler")
require("luasnip-config")
require("smart-navigation").setup()
