-- PDF Handler configuration for Neovim
-- This file handles PDF opening with Zathura from anywhere in Neovim

local function detect_zathura()
  if vim.fn.executable("zathura") == 1 then
    return "zathura"
  end
  local brew_path = "/opt/homebrew/bin/zathura"
  if vim.fn.executable(brew_path) == 1 then
    return brew_path
  end
  return nil
end

-- Function to open PDF using zathura directly
local function open_pdf_with_zathura(pdf_path)
  local zathura_path = detect_zathura()
  if not zathura_path then
    vim.notify("Zathura not found in PATH. Install it or adjust your viewer settings.", vim.log.levels.WARN)
    return
  end

  vim.fn.jobstart({ zathura_path, pdf_path }, {
    detach = true,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify("Failed to open PDF with Zathura", vim.log.levels.ERROR)
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
        open_pdf_with_zathura(node.path)
      end
    end, { desc = "Open PDF with shell command", buffer = buf })
  end,
})

-- Intercept PDF file opening before buffer is created
vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
  pattern = { "*.pdf" },
  callback = function(args)
    vim.schedule(function()
      open_pdf_with_zathura(args.file)
      vim.cmd("bwipeout")
    end)
  end,
})

-- Configure VimTeX to use Zathura (for proper LaTeX integration with SyncTeX)
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_view_zathura_options = "--synctex-forward @line:@col:@file"

-- Function to open any PDF file with Zathura (can be called from anywhere)
_G.open_pdf_with_zathura = open_pdf_with_zathura
