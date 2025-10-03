-- Language Server Protocol configurations for LunarVim
-- This file contains LSP server configurations

-- Configure LSP hover window to be scrollable and navigable
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",
    max_width = 80,
    max_height = 30,
    focusable = true,  -- Makes the hover window focusable/scrollable
  }
)

-- Silence the noisy warning about missing position encodings on 0.10
do
  local util = vim.lsp.util
  local make_position_params = util.make_position_params
  local get_offset_encoding = util._get_offset_encoding

  local function pick_offset_encoding(buf)
    local resolved
    if type(buf) == "number" then
      resolved = buf
    elseif type(buf) == "string" then
      local maybe = tonumber(buf)
      if maybe then
        resolved = maybe
      end
    end

    if resolved == nil or resolved < 0 then
      resolved = vim.api.nvim_get_current_buf()
    end

    local lookup = resolved and { bufnr = resolved } or {}
    local encoding

    for _, client in ipairs(vim.lsp.get_clients(lookup)) do
      local client_encoding = client.offset_encoding or "utf-16"
      if not encoding then
        encoding = client_encoding
      elseif encoding ~= client_encoding then
        encoding = "utf-16"
        break
      end
    end

    return encoding or "utf-16"
  end

  util.make_position_params = function(win, buf, encoding)
    if not encoding then
      encoding = pick_offset_encoding(buf)
    end

    return make_position_params(win, buf, encoding)
  end

  util._get_offset_encoding = function(buf)
    if buf then
      return pick_offset_encoding(buf)
    end
    return get_offset_encoding(buf)
  end
end

-- Disable the default K mapping for LSP hover (conflicts with navigation)
lvim.lsp.buffer_mappings.normal_mode["K"] = nil

-- Use Shift+I for hover (I = Info)
lvim.lsp.buffer_mappings.normal_mode["<S-i>"] = {
  vim.lsp.buf.hover,
  "Show hover documentation"
}

-- No other custom LSP configurations needed for current setup
-- LunarVim handles most LSP servers automatically
