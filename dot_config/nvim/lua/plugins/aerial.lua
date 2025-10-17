-- Aerial.nvim configuration for code outline and navigation

return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- for icons
  },
  config = function()
    require("aerial").setup({
      -- Priority list of preferred backends for aerial
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },

      layout = {
        -- Control the width of the aerial window
        max_width = { 40, 0.2 },
        width = nil,
        min_width = 10,

        -- Window-local options for aerial window
        win_opts = {},

        -- Default direction to open the aerial window
        default_direction = "prefer_right",

        -- Where the aerial window will be opened
        placement = "window",

        -- Resize the aerial window to fit content
        resize_to_content = true,

        -- Preserve window size equality
        preserve_equality = false,
      },

      -- How the aerial window decides which buffer to display symbols for
      attach_mode = "window",

      -- Auto-close events
      close_automatic_events = {},

      -- Keymaps in aerial window
      keymaps = {
        ["?"] = "actions.show_help",
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.jump",
        ["<2-LeftMouse>"] = "actions.jump",
        ["<C-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
        ["p"] = "actions.scroll",
        ["<C-j>"] = "actions.down_and_scroll",
        ["<C-k>"] = "actions.up_and_scroll",
        ["{"] = "actions.prev",
        ["}"] = "actions.next",
        ["[["] = "actions.prev_up",
        ["]]"] = "actions.next_up",
        ["q"] = "actions.close",
        ["o"] = "actions.tree_toggle",
        ["za"] = "actions.tree_toggle",
        ["O"] = "actions.tree_toggle_recursive",
        ["zA"] = "actions.tree_toggle_recursive",
        ["l"] = "actions.tree_open",
        ["zo"] = "actions.tree_open",
        ["L"] = "actions.tree_open_recursive",
        ["zO"] = "actions.tree_open_recursive",
        ["h"] = "actions.tree_close",
        ["zc"] = "actions.tree_close",
        ["H"] = "actions.tree_close_recursive",
        ["zC"] = "actions.tree_close_recursive",
        ["zr"] = "actions.tree_increase_fold_level",
        ["zR"] = "actions.tree_open_all",
        ["zm"] = "actions.tree_decrease_fold_level",
        ["zM"] = "actions.tree_close_all",
        ["zx"] = "actions.tree_sync_folds",
        ["zX"] = "actions.tree_sync_folds",
      },

      -- When true, don't load aerial until a command or function is called
      lazy_load = true,

      -- Disable aerial on large files
      disable_max_lines = 10000,
      disable_max_size = 2000000, -- 2MB

      -- Symbols to display
      filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
      },

      -- Line highlighting mode when multiple splits are visible
      highlight_mode = "split_width",

      -- Highlight the closest symbol if cursor is not exactly on one
      highlight_closest = true,

      -- Highlight symbol in source buffer when cursor is in aerial window
      highlight_on_hover = false,

      -- Highlight line when jumping to symbol
      highlight_on_jump = 300,

      -- Jump to symbol in source window when cursor moves
      autojump = false,

      -- Use symbol tree for folding
      manage_folds = false,

      -- Update aerial tree when folding code
      link_folds_to_tree = false,

      -- Fold code when opening/collapsing symbols in tree
      link_tree_to_folds = true,

      -- Use patched font icons
      nerd_font = "auto",

      -- Callback when aerial attaches to a buffer
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,

      -- Automatically open aerial when entering supported buffers
      open_automatic = false,

      -- Command to run after jumping to a symbol
      post_jump_cmd = "normal! zz",

      -- Automatically close after jumping to a symbol
      close_on_select = false,

      -- Events that trigger symbols update
      update_events = "TextChanged,InsertLeave",

      -- Show box drawing characters for tree hierarchy
      show_guides = true,

      -- Customize guide characters
      guides = {
        mid_item = "├─",
        last_item = "└─",
        nested_top = "│ ",
        whitespace = "  ",
      },

      -- Options for floating window
      float = {
        border = "rounded",
        relative = "cursor",
        max_height = 0.9,
        height = nil,
        min_height = { 8, 0.1 },
        override = function(conf, source_winid)
          return conf
        end,
      },

      -- Options for floating nav windows
      nav = {
        border = "rounded",
        max_height = 0.9,
        min_height = { 10, 0.1 },
        max_width = 0.5,
        min_width = { 0.2, 20 },
        win_opts = {
          cursorline = true,
          winblend = 10,
        },
        autojump = false,
        preview = false,
        keymaps = {
          ["<CR>"] = "actions.jump",
          ["<2-LeftMouse>"] = "actions.jump",
          ["<C-v>"] = "actions.jump_vsplit",
          ["<C-s>"] = "actions.jump_split",
          ["h"] = "actions.left",
          ["l"] = "actions.right",
          ["<C-c>"] = "actions.close",
        },
      },

      -- LSP configuration
      lsp = {
        diagnostics_trigger_update = false,
        update_when_errors = true,
        update_delay = 300,
      },

      -- TreeSitter configuration
      treesitter = {
        update_delay = 300,
      },

      -- Markdown configuration
      markdown = {
        update_delay = 300,
      },

      -- AsciiDoc configuration
      asciidoc = {
        update_delay = 300,
      },

      -- Man page configuration
      man = {
        update_delay = 300,
      },
    })


    -- Symbol navigation keymaps (kept for direct access)
    vim.keymap.set("n", "]s", "<cmd>AerialNext<CR>", { desc = "Next symbol" })
    vim.keymap.set("n", "[s", "<cmd>AerialPrev<CR>", { desc = "Previous symbol" })
    vim.keymap.set("n", "]S", "<cmd>AerialNextUp<CR>", { desc = "Next symbol up" })
    vim.keymap.set("n", "[S", "<cmd>AerialPrevUp<CR>", { desc = "Previous symbol up" })

    -- Telescope integration
    local ok_telescope, telescope = pcall(require, 'telescope')
    if ok_telescope then
      telescope.setup({
        extensions = {
          aerial = {
            col1_width = 4,
            col2_width = 30,
            format_symbol = function(symbol_path, filetype)
              if filetype == "json" or filetype == "yaml" then
                return table.concat(symbol_path, ".")
              else
                return symbol_path[#symbol_path]
              end
            end,
            show_columns = "both",
          },
        },
      })
      telescope.load_extension("aerial")
    end
  end,
}