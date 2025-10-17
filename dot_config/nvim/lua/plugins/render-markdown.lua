-- Render Markdown plugin
-- Renders markdown in neovim with treesitter
-- Requires Neovim 0.10+ (uses vim.wins API)

return {
  'MeanderingProgrammer/render-markdown.nvim',
  -- Only load on Neovim 0.10+ which has the required APIs
  enabled = function()
    return vim.fn.has('nvim-0.10') == 1
  end,
  dependencies = { 
    'nvim-treesitter/nvim-treesitter',
    'echasnovski/mini.icons',
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
  ft = { 'markdown', 'quarto', 'python' },
  config = function()
    require('render-markdown').setup({
      heading = {
        backgrounds = {},  -- Disable background bars on headings
      },
    })
    
    -- Catppuccin Frappé surface0 for code blocks (subtle background)
    vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = '#414559' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { bg = '#414559' })
  end,
}
