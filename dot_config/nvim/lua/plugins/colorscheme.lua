-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  -- Use Blink as the main completion engine (not nvim-cmp)
  -- Catppuccin: frappe + full transparency
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "frappe",
      transparent_background = true,
      term_colors = true,
      float = {
        transparent = true,
      },
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        blink = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        snacks = true,
        telescope = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      vim.opt.termguicolors = true
      vim.o.winblend = 0
      vim.o.pumblend = 0
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-frappe")
    end,
  },

  -- Tell LazyVim the exact variant
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin-frappe" },
  },
  -- (Optional) Lualine & Bufferline transparent-friendly settings
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = {
      options = {
        theme = "catppuccin",
        component_separators = "",
        section_separators = "",
        globalstatus = true,
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    optional = true,
    dependencies = { "catppuccin/nvim" },
    opts = function(_, opts)
      opts = opts or {}
      opts.options = opts.options or {}

      -- Try both Catppuccin integration paths; fallback safe
      local catpp_buf_get
      do
        local ok, mod = pcall(require, "catppuccin.groups.integrations.bufferline")
        if ok and type(mod.get) == "function" then
          catpp_buf_get = mod.get
        end
        if not catpp_buf_get then
          ok, mod = pcall(require, "catppuccin.integrations.bufferline")
          if ok and type(mod.get) == "function" then
            catpp_buf_get = mod.get
          end
        end
      end

      local hl = catpp_buf_get and catpp_buf_get() or opts.highlights
      local function add_transparent_fill(hl_val)
        if type(hl_val) == "function" then
          return function(...)
            local base = hl_val(...)
            base.fill = vim.tbl_extend("force", base.fill or {}, { bg = "NONE" })
            return base
          end
        elseif type(hl_val) == "table" then
          hl_val.fill = vim.tbl_extend("force", hl_val.fill or {}, { bg = "NONE" })
          return hl_val
        else
          return { fill = { bg = "NONE" } }
        end
      end

      opts.highlights = add_transparent_fill(hl)
      opts.options.separator_style = opts.options.separator_style or "thin"
      return opts
    end,
  },
}
