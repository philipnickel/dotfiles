-- PDF Handler configuration for Neovim
-- This file handles PDF opening with OpusReader from anywhere in Neovim

local function detect_opusreader()
  -- Try common paths for OpusReader
  local paths = {
    "opusreader",
    "/usr/local/bin/opusreader",
    "/opt/homebrew/bin/opusreader",
    "/usr/bin/opusreader",
    "/Applications/OpusReader.app/Contents/MacOS/OpusReader"
  }
  
  for _, path in ipairs(paths) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  return nil
end

-- Function to open PDF using OpusReader directly
local function open_pdf_with_opusreader(pdf_path)
  local opusreader_path = detect_opusreader()
  if not opusreader_path then
    vim.notify("OpusReader not found in PATH. Install it or adjust your viewer settings.", vim.log.levels.WARN)
    return
  end

  -- Launch OpusReader with new window for proper Aerospace integration
  local cmd = { opusreader_path, "--new-window", "--inverse-search", "nvim +%2 \"%1\"", pdf_path }
  vim.fn.jobstart(cmd, {
    detach = true,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify("Failed to open PDF with OpusReader (exit code: " .. exit_code .. ")", vim.log.levels.ERROR)
      end
    end,
  })
end

-- Configure filetree (neo-tree) to open PDFs with shell command
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = { "NeoTreeBufferEnter" },
  callback = function(args)
    local manager = require("neo-tree.sources.manager")
    local state = manager.get_state("filesystem")
    if not state or not state.tree then
      return
    end

    local buf = args.buf
    -- Add custom keybinding for PDF files in neo-tree
    vim.keymap.set("n", "<leader>v", function()
      local node = state.tree:get_node()
      if node and node.path and node.path:match("%.pdf$") then
        open_pdf_with_opusreader(node.path)
      end
    end, { desc = "Open PDF with OpusReader", buffer = buf })
  end,
})

-- Intercept PDF file opening before buffer is created
vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
  pattern = { "*.pdf" },
  callback = function(args)
    vim.schedule(function()
      open_pdf_with_opusreader(args.file)
      vim.cmd("bwipeout")
    end)
  end,
})

-- Configure VimTeX to use OpusReader (for proper LaTeX integration with SyncTeX)
vim.g.vimtex_view_method = "sioyek"
vim.g.vimtex_view_sioyek_exe = "opusreader"
vim.g.vimtex_view_sioyek_options = "--reuse-window"

-- Function to open any PDF file with OpusReader (can be called from anywhere)
_G.open_pdf_with_opusreader = open_pdf_with_opusreader
_G.detect_opusreader = detect_opusreader
