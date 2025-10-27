-- File: tiny-inline-diagnostic.lua
-- Drop this into: ~/.config/nvim/lua/plugins/ (LazyVim)
-- Provides: rachartier/tiny-inline-diagnostic.nvim with sensible defaults,
--           keymaps, diagnostic float override, and optional sidekick.nvim integration.

return {
  -- 🩺 Inline diagnostics (replaces built-in virtual_text)
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    opts = {
      -- Pick a style you like: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
      preset = "modern",

      -- Useful with transparent themes
      transparent_bg = true,
      transparent_cursorline = true,

      -- Colors: rely on existing Diagnostic* groups so it plays nice with your colorscheme
      hi = {
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
        arrow = "NonText",
        background = "CursorLine",
        mixing_color = "Normal",
      },

      -- Disable on specific filetypes if you like (empty = none)
      disabled_ft = {},

      options = {
        -- Show [source] (e.g. pyright, lua_ls). If you use many LSPs, turn on both.
        show_source = { enabled = true, if_many = true },

        -- If your diagnostic config defines icons you prefer, use them
        use_icons_from_diagnostic = false,

        -- Match arrow color to the most severe diag on the line
        set_arrow_to_diag_color = true,

        add_messages = {
          messages = true,            -- show messages (not just counts)
          display_count = false,      -- when cursor leaves line, show count instead of text
          use_max_severity = true,    -- for counts, only show max severity
          show_multiple_glyphs = true,
        },

        -- Performance / UX
        throttle = 20,                -- ms; set 0 for immediate updates if you prefer
        softwrap = 40,                -- wrap long messages after ~N chars

        multilines = {
          enabled = true,
          always_show = false,
          trim_whitespaces = true,
          tabstop = 4,
        },

        show_all_diags_on_cursorline = false,

        -- Show relatedInformation (e.g. "note: …") if server provides it
        show_related = { enabled = true, max_count = 3 },

        -- Show while typing / selecting (disable if flickery)
        enable_on_insert = false,
        enable_on_select = false,

        -- Long line handling
        overflow = { mode = "wrap", padding = 0 },

        -- Force line breaks in very long messages
        break_line = { enabled = false, after = 60 },

        -- Custom formatter (nil uses default)
        format = nil,

        -- Higher priority wins over other virtual texts (e.g. blame)
        virt_texts = { priority = 4096 },

        -- Which severities to show (order matters)
        severity = {
          vim.diagnostic.severity.ERROR,
          vim.diagnostic.severity.WARN,
          vim.diagnostic.severity.INFO,
          vim.diagnostic.severity.HINT,
        },

        -- Auto-disable inline diags when opening diagnostic floats (see config() hook below)
        override_open_float = true,
      },
    },
    config = function(_, opts)
      -- 1) Setup plugin
      require("tiny-inline-diagnostic").setup(opts)

      -- 2) Turn off built-in virtual_text to avoid duplicates
      local current = vim.diagnostic.config()
      vim.diagnostic.config(vim.tbl_deep_extend("force", current or {}, {
        virtual_text = false,
      }))

      -- 3) If requested, wrap diagnostic floats to avoid overlap with inlines
      if opts and opts.options and opts.options.override_open_float then
        vim.diagnostic.open_float = require("tiny-inline-diagnostic.override").open_float
      end

      -- 4) Keymaps
      local diag = require("tiny-inline-diagnostic")
      vim.keymap.set("n", "<leader>ud", diag.toggle, { desc = "Toggle Inline Diagnostics" })
      vim.keymap.set("n", "<leader>uD", function()
        local enabled = vim.diagnostic.is_enabled()
        vim.diagnostic.enable(not enabled)
      end, { desc = "Toggle Diagnostics (Global)" })
    end,
  },

  -- 🔌 Optional: Integrate with sidekick.nvim (auto-hide when NES appears)
  -- Remove this block if you don't use sidekick.nvim.
  {
    "folke/sidekick.nvim",
    -- Set to false to avoid installing; leave true to enable the integration.
    enabled = true,
    event = "VeryLazy",
    opts = {
      nes = { enabled = true },
    },
    config = function(_, opts)
      local ok = pcall(require, "sidekick")
      if not ok then
        return
      end
      require("sidekick").setup(opts)

      local disabled = false
      vim.api.nvim_create_autocmd("User", {
        pattern = "SidekickNesShow",
        callback = function()
          disabled = true
          pcall(require("tiny-inline-diagnostic").disable)
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "SidekickNesHide",
        callback = function()
          if disabled then
            disabled = false
            pcall(require("tiny-inline-diagnostic").enable)
          end
        end,
      })
    end,
  },
}
