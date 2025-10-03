-- Python filetype specific settings for code cells

-- Set cell delimiter for vim-slime (VS Code style - no space)
vim.b.slime_cell_delimiter = '#%%'

-- Keybindings for Molten (inline Jupyter kernel with plots)
vim.keymap.set('n', '<localleader>mi', function()
  vim.cmd('MoltenInit python3')
  vim.g.molten_initialized = true
  vim.print('Molten initialized - plots will show inline')
end, { buffer = true, silent = true, desc = 'Initialize Molten (inline output)' })

vim.keymap.set('n', '<localleader>md', function()
  vim.cmd('MoltenDeinit')
  vim.g.molten_initialized = false
  vim.print('Molten stopped - back to slime mode')
end, { buffer = true, silent = true, desc = 'Stop Molten' })

vim.keymap.set('n', '<localleader>mo', ':MoltenEvaluateOperator<CR>', { buffer = true, silent = true, desc = 'Evaluate operator' })
vim.keymap.set('n', '<localleader>mr', ':MoltenReevaluateCell<CR>', { buffer = true, silent = true, desc = 'Re-evaluate cell' })
vim.keymap.set('v', '<localleader>m', ':<C-u>MoltenEvaluateVisual<CR>gv', { buffer = true, silent = true, desc = 'Evaluate visual selection' })