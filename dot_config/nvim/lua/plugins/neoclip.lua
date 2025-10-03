-- Neoclip clipboard history configuration

return {
  "AckslD/nvim-neoclip.lua",
  lazy = false,
  dependencies = {
    {
      "kkharji/sqlite.lua",
      lazy = true,
    },
    {
      "nvim-telescope/telescope.nvim",
      lazy = true,
    },
  },
  config = function()
    local ok, neoclip = pcall(require, 'neoclip')
    if not ok then
      return
    end

    neoclip.setup({
      history = 1000,
      enable_persistent_history = true,
      length_limit = 1048576,
      continuous_sync = false,
      db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
      filter = nil,
      preview = true,
      prompt = nil,
      default_register = '"',
      default_register_macros = 'q',
      enable_macro_history = true,
      content_spec_column = false,
      disable_keycodes_parsing = false,
      dedent_picker_display = false,
      initial_mode = 'insert',
      on_select = {
        move_to_front = false,
        close_telescope = true,
      },
      on_paste = {
        set_reg = false,
        move_to_front = false,
        close_telescope = true,
      },
      on_replay = {
        set_reg = false,
        move_to_front = false,
        close_telescope = true,
      },
      on_custom_action = {
        close_telescope = true,
      },
      keys = {
        telescope = {
          i = {
            select = '<cr>',
            paste = '<c-p>',
            paste_behind = '<c-k>',
            replay = '<c-q>',
            delete = '<c-d>',
            edit = '<c-e>',
            custom = {},
          },
          n = {
            select = '<cr>',
            paste = 'p',
            paste_behind = 'P',
            replay = 'q',
            delete = 'd',
            edit = 'e',
            custom = {},
          },
        },
      },
    })

    local telescope_ok, telescope = pcall(require, 'telescope')
    if telescope_ok and telescope.load_extension then
      pcall(telescope.load_extension, 'neoclip')
      pcall(telescope.load_extension, 'macroscope')
    end

    -- Keybindings for neoclip
    vim.keymap.set('n', '<leader>yy', '<cmd>Telescope neoclip<cr>', {
      desc = 'Open Neoclip (clipboard history)',
      silent = true,
    })

    vim.keymap.set('n', '<leader>ym', '<cmd>Telescope macroscope<cr>', {
      desc = 'Open Macroscope (macro history)',
      silent = true,
    })
  end,
}
