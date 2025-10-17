-- Python filetype specific settings for code cells

-- Keybindings for toggleterm integration
vim.keymap.set('n', '<localleader>ci', function()
  if _G.python_term then
    _G.python_term:toggle()
  end
end, { buffer = true, silent = true, desc = 'Open Python terminal' })
vim.keymap.set('n', '<localleader>rr', function()
  local line = vim.fn.getline('.')
  if _G.python_term then
    _G.python_term:send(line)
  end
end, { buffer = true, silent = true, desc = 'Send current line' })
vim.keymap.set('v', '<localleader>rr', function()
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, '\n')
  if _G.python_term then
    _G.python_term:send(text)
  end
end, { buffer = true, silent = true, desc = 'Send selection' })
