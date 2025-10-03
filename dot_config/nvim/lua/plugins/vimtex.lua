-- VimTeX configuration for LaTeX editing

return {
  "lervag/vimtex",
  version = "v2.15", -- Pin to last release supporting older Vim/Neovim
  lazy = false, -- Load immediately for LaTeX snippets (required for inverse search)
  init = function()
    -- VimTeX configuration
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_view_zathura_options = '--synctex-forward @line:@col:@file'
    
    -- Enable VimTeX features
    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_compiler_latexmk = {
      build_dir = 'build',
      options = {
        '-pdf',
        '-interaction=nonstopmode',
        '-file-line-error',
        '-synctex=1',
        '-verbose',
      },
    }
    
    -- Additional useful settings
    vim.g.vimtex_compiler_method = 'latexmk' -- Use latexmk (recommended)
    vim.g.vimtex_quickfix_ignore_filters = {
      'Overfull \\hbox',
      'Underfull \\hbox',
      'Overfull \\vbox',
      'Underfull \\vbox',
    }
    
    -- Enable folding
    vim.g.vimtex_fold_enabled = 1
    vim.g.vimtex_fold_manual = 1
    
    -- Enable conceal for better readability
    vim.g.vimtex_syntax_conceal = {
      accents = 1,
      ligatures = 1,
      cites = 1,
      greek = 1,
      math_bounds = 1,
      math_delimiters = 1,
      math_fracs = 1,
      math_super_sub = 1,
      math_symbols = 1,
      sections = 1,
      spacing = 0,
      styles = 1,
    }
    
  end,
}
