-- Quarto filetype specific settings
local api = vim.api

-- Set comment string for Quarto files (using HTML comments)
vim.bo.commentstring = '<!-- %s -->'

-- Word wrap settings for better reading
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.breakindent = true
vim.wo.showbreak = '|'

-- Don't run vim ftplugin on top of this
api.nvim_buf_set_var(0, 'did_ftplugin', true)

-- Markdown/Quarto highlight customizations
local ns = api.nvim_create_namespace('QuartoHighlight')
api.nvim_set_hl(ns, '@markup.strikethrough', { strikethrough = false })
api.nvim_set_hl(ns, '@markup.doublestrikethrough', { strikethrough = true })
api.nvim_win_set_hl_ns(0, ns)

-- Highlight code cells
api.nvim_set_hl(0, '@markup.codecell', {
  link = 'CursorLine',
})
