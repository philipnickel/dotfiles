-- Language Server Protocol configurations

-- Configure LSP hover window to be scrollable and navigable
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",
    max_width = 80,
    max_height = 30,
    focusable = true,  -- Makes the hover window focusable/scrollable
  }
)

-- Fix position encoding warnings in Neovim 0.10+
local function get_offset_encoding(bufnr)
  if type(bufnr) ~= "number" or bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then
    return "utf-16"
  end
  
  local encoding = clients[1].offset_encoding or "utf-16"
  for _, client in ipairs(clients) do
    if client.offset_encoding and client.offset_encoding ~= encoding then
      return "utf-16" -- Default to utf-16 if clients have different encodings
    end
  end
  
  return encoding
end

-- Override make_position_params to always provide encoding
local original_make_position_params = vim.lsp.util.make_position_params
vim.lsp.util.make_position_params = function(win, arg2, arg3)
  local bufnr = nil
  local encoding = nil

  if type(arg2) == "number" or arg2 == nil then
    bufnr = arg2
    encoding = arg3
  else
    encoding = arg2
  end

  if type(bufnr) ~= "number" or bufnr == 0 then
    bufnr = vim.api.nvim_win_get_buf(win or 0)
  end

  if type(encoding) ~= "string" then
    encoding = get_offset_encoding(bufnr)
  end

  return original_make_position_params(win, encoding)
end

-- Use Shift+I for hover (I = Info)
vim.keymap.set("n", "<S-i>", vim.lsp.buf.hover, { desc = "Show hover documentation" })
