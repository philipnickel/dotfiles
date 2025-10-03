-- Chezmoi integration configuration

return {
  'xvzc/chezmoi.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  cmd = { 'ChezmoiEdit', 'ChezmoiList' },
  config = function()
    local home = vim.fn.expand('~')
    local source_path = home .. '/.local/share/chezmoi/'
    require('chezmoi').setup({
      edit = {
        watch = true,
        force = false,
        ignore_patterns = {
          'run_onchange_.*',
          'run_once_.*',
          '%.chezmoiignore',
          '%.chezmoitemplate',
        },
      },
      telescope = {
        select = { '<CR>', '<C-v>' },
      },
    })

    vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
      pattern = { source_path .. '*' },
      callback = function(args)
        vim.schedule(function()
          require('chezmoi.commands.__edit').watch(args.buf)
        end)
      end,
    })
  end,
}
