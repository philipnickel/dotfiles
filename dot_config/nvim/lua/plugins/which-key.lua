-- Which-key configuration with modern layout
-- Provides keymap discovery and help

return {
  "folke/which-key.nvim",
  lazy = false,
  dependencies = {
    "echasnovski/mini.icons",
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- Use modern layout
    preset = "modern",
    
    -- Delay before showing popup
    delay = function(ctx)
      return ctx.plugin and 0 or 200
    end,
    
    -- Filter mappings (show all for now)
    filter = function(mapping)
      return true
    end,
    
    -- Show warnings for mapping issues
    notify = true,
    
    -- Auto triggers for all modes
    triggers = {
      { "<auto>", mode = "nxso" },
    },
    
    -- Defer for visual mode and some operators
    defer = function(ctx)
      return ctx.mode == "V" or ctx.mode == "<C-V>"
    end,
    
    -- Plugin configurations
    plugins = {
      marks = true, -- shows marks on ' and `
      registers = true, -- shows registers on " in NORMAL or <C-r> in INSERT
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true, -- d, y, etc.
        motions = true, -- hjkl, etc.
        text_objects = true, -- aw, iw, etc.
        windows = true, -- <c-w>
        nav = true, -- misc window bindings
        z = true, -- folds, spelling, etc.
        g = true, -- g bindings
      },
    },
    
    -- Window configuration
    win = {
      no_overlap = true,
      padding = { 1, 2 },
      title = true,
      title_pos = "center",
      zindex = 1000,
      wo = {
        -- winblend = 10, -- transparency if desired
      },
    },
    
    -- Layout configuration
    layout = {
      width = { min = 20 },
      spacing = 3,
    },
    
    -- Scroll keys
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    
    -- Sorting
    sort = { "local", "order", "group", "alphanum", "mod" },
    
    -- Expand groups when <= 0 mappings (show all)
    expand = 0,
    
    -- Icon configuration
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
      ellipsis = "…",
      mappings = true,
      colors = true,
      keys = {
        Up = "↑",
        Down = "↓",
        Left = "←",
        Right = "→",
        C = "⌃",
        M = "⌘",
        D = "⌫",
        S = "⇧",
        CR = "↵",
        Esc = "⎋",
        Space = "␣",
        Tab = "⇥",
      },
    },
    
    -- Show help and keys
    show_help = true,
    show_keys = true,
    
    -- Disable for certain file types
    disable = {
      ft = {},
      bt = {},
    },
    
    -- Debug mode
    debug = false,
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>a", group = "avante" },
      { "<leader>h", group = "history" },
      { "<leader>d", hidden = true },
      { "<leader>l", group = "latex" },
      { "<leader>u", group = "uv" },
      { "<leader>o", group = "otter" },
      { "<leader>q", group = "quarto" },
      { "<leader>r", group = "run" },
      { "<leader>s", group = "snippets" },
      { "<leader>t", group = "terminals" },
    })
  end,
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
