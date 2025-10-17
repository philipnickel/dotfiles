-- VimTeX configuration for LaTeX editing

return {
  "lervag/vimtex",
  version = "v2.15", -- Pin to last release supporting older Vim/Neovim
  lazy = false, -- Load immediately for LaTeX snippets (required for inverse search)
  init = function()
    -- VimTeX configuration with OpusReader (rebranded Sioyek)
    vim.g.vimtex_view_method = 'sioyek'
    vim.g.vimtex_view_sioyek_exe = 'opusreader'
    
    -- OpusReader configuration for synctex
    vim.g.vimtex_view_sioyek_options = '--new-window --inverse-search "nvim +%2 \\"%1\\""'
    
    -- Configure inverse search for OpusReader
    vim.g.vimtex_view_sioyek_inverse_search = 'nvim +%2 "%1"'
    
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
    
    -- Use VimTeX syntax highlighting instead of Treesitter
    vim.g.vimtex_syntax_enabled = 1
    vim.g.vimtex_syntax_conceal_disable = 0
    
    -- Enable spell checking for LaTeX files
    vim.g.vimtex_enabled = 1
    
    -- Auto-enable spell checking for LaTeX files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'tex',
      callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = 'en_us'
      end,
    })
    
    -- Ctrl+L to correct spelling errors
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'tex',
      callback = function()
        -- Normal mode: show spelling suggestions for word under cursor
        vim.keymap.set('n', '<C-l>', 'z=', { buffer = true, desc = 'Correct spelling' })
        
        -- Insert mode: automatically correct last spelling mistake
        -- This implements: <c-g>u<Esc>[s1z=`]a<c-g>u
        vim.keymap.set('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u', { buffer = true, desc = 'Correct last spelling mistake' })
        
      end,
    })
    
  end,
}
