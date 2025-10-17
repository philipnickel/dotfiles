-- Filetype detection and configuration for Neovim
-- This file contains filetype mappings and autocmds

-- Filetype detection
vim.filetype.add({
  extension = {
    tex = "tex",
    latex = "tex",
  },
  pattern = {
    ["*.tex"] = "tex",
    ["*.latex"] = "tex",
  },
})

-- Auto-set filetype for LaTeX files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tex", "*.latex" },
  callback = function(args)
    vim.api.nvim_buf_set_option(args.buf, "filetype", "tex")
  end,
})


-- PDF handling is configured in pdf_handler.lua