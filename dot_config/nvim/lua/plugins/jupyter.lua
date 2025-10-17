-- Jupyter notebook support

return {
  "kana/vim-json",
  ft = { "json" },
  config = function()
    -- Enhanced JSON syntax for Jupyter notebooks
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { "*.ipynb" },
      callback = function(args)
        -- Set proper filetype and syntax
        vim.api.nvim_buf_set_option(args.buf, "filetype", "json")
        vim.api.nvim_buf_set_option(args.buf, "syntax", "json")
        
        -- Enable line wrapping for better readability
        vim.api.nvim_buf_set_option(args.buf, "wrap", true)
        vim.api.nvim_buf_set_option(args.buf, "linebreak", true)
        
        -- Set up keymaps for Jupyter notebook navigation
        local opts = { buffer = args.buf, silent = true }
        
        -- Navigate between cells
        vim.keymap.set('n', ']c', function()
          vim.fn.search('"cell_type"', 'W')
        end, vim.tbl_extend('force', opts, { desc = 'Next cell' }))
        
        vim.keymap.set('n', '[c', function()
          vim.fn.search('"cell_type"', 'bW')
        end, vim.tbl_extend('force', opts, { desc = 'Previous cell' }))
        
        -- Format JSON
        vim.keymap.set('n', '<leader>f', function()
          vim.cmd('%!python -m json.tool')
        end, vim.tbl_extend('force', opts, { desc = 'Format JSON' }))
      end,
    })
  end,
}