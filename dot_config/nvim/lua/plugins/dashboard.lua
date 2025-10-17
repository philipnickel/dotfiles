return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local dashboard = require('dashboard')
    dashboard.setup({
      theme = 'hyper',
      config = {
        week_header = {
          enable = false,
        },
        project = {
          enable = false,
        },
        mru = {
          enable = true,
          limit = 10,
          icon = ' ',
        },
        shortcut = {
          { desc = 'Find File', group = '@variable', action = 'Telescope find_files', key = 'f' },
          { desc = 'Live Grep', group = '@string', action = 'Telescope live_grep', key = 'g' },
          { desc = 'Chezmoi', group = '@method', action = 'ChezmoiFiles', key = 'c' },
          {
            desc = 'Obsidian',
            group = '@type',
            action = function()
              require('telescope.builtin').find_files({
                cwd = '/Users/philipnickel/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian Noter',
              })
            end,
            key = 'o',
          },
          { desc = 'Lazy', group = '@constant', action = 'Lazy sync', key = 'u' },
          { desc = 'Quit', group = '@macro', action = 'qa', key = 'q' },
        },
        footer = function()
          local stats = require('lazy').stats()
          return { string.format('Loaded %d/%d plugins', stats.loaded, stats.count) }
        end,
      },
    })
  end,
}
