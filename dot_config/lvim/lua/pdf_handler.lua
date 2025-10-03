-- PDF Handler configuration for LunarVim
-- This file handles PDF opening with Zathura from anywhere in Neovim

-- Function to open PDF using zathura directly
local function open_pdf_with_zathura(pdf_path)
  -- Use zathura directly to open PDFs
  local zathura_path = vim.fn.executable("zathura") == 1 and "zathura" or "/opt/homebrew/bin/zathura"
  vim.fn.jobstart({zathura_path, pdf_path}, {
    detach = true,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify("Failed to open PDF with Zathura", vim.log.levels.ERROR)
      end
    end
  })
end

-- Create a wrapper script for ripgrep to search PDFs
local rg_pdf_wrapper = vim.fn.stdpath("config") .. "/rg-pdf-wrapper.sh"
local wrapper_content = {
  "#!/bin/bash",
  "# Wrapper to make ripgrep search PDF contents",
  'if [[ "$1" == *.pdf ]]; then',
  '  pdftotext "$1" - 2>/dev/null || echo ""',
  "else",
  '  cat "$1"',
  "fi",
}

vim.fn.writefile(wrapper_content, rg_pdf_wrapper)
vim.fn.setfperm(rg_pdf_wrapper, "rwxr-xr-x")

-- Extend LunarVim's Telescope configuration for PDF support
lvim.builtin.telescope.on_config_done = function(telescope)
  local previewers = require("telescope.previewers")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values
  local putils = require("telescope.previewers.utils")

  -- Custom action to open PDFs in Zathura
  local function open_pdf_in_zathura(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    if not entry then
      return actions.select_default(prompt_bufnr)
    end

    local path = entry.path or entry.value or entry.filename
    if path and type(path) == "string" and path:match("%.pdf$") then
      actions.close(prompt_bufnr)
      open_pdf_with_zathura(path)
    else
      actions.select_default(prompt_bufnr)
    end
  end

  -- Custom buffer previewer maker that handles PDFs
  local original_maker = conf.buffer_previewer_maker
  conf.buffer_previewer_maker = function(filepath, bufnr, opts)
    if filepath:match("%.pdf$") then
      -- For PDFs, use pdftotext to extract text
      vim.fn.jobstart({"pdftotext", "-layout", "-nopgbrk", filepath, "-"}, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data and bufnr and vim.api.nvim_buf_is_valid(bufnr) then
            vim.schedule(function()
              vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
              vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
              vim.api.nvim_buf_set_option(bufnr, "filetype", "text")
              putils.highlighter(bufnr, "text", opts)
            end)
          end
        end,
      })
    else
      original_maker(filepath, bufnr, opts)
    end
  end

  -- Configure pickers with PDF support
  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<S-j>"] = actions.move_selection_next,
          ["<S-k>"] = actions.move_selection_previous,
          ["<CR>"] = open_pdf_in_zathura,
        },
        n = {
          ["<S-j>"] = actions.move_selection_next,
          ["<S-k>"] = actions.move_selection_previous,
          ["<CR>"] = open_pdf_in_zathura,
        },
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "-g", "!.git",
        "--type-add=pdf:*.pdf",
        "--pre=" .. rg_pdf_wrapper,
        "--pre-glob=*.pdf",
      },
    },
    pickers = {
      find_files = {
        hidden = true,
        find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
      },
      live_grep = {
        additional_args = function()
          return { "--hidden", "-g", "!.git" }
        end,
      },
    },
  })

  pcall(telescope.load_extension, "fzf")
end

-- Configure filetree (neo-tree) to open PDFs with shell command
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = { "NeoTreeBufferEnter" },
  callback = function()
    -- Add custom keybinding for PDF files in neo-tree
    vim.keymap.set("n", "<leader>v", function()
      local node = require("neo-tree.sources.manager").get_state("filesystem").tree:get_node()
      if node and node.path:match("%.pdf$") then
        open_pdf_with_zathura(node.path)
      end
    end, { desc = "Open PDF with shell command" })
  end,
})

-- Global keybinding to open PDFs with shell command
lvim.keys.normal_mode["<leader>pv"] = function()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file:match("%.pdf$") then
    open_pdf_with_zathura(current_file)
  else
    vim.notify("Current file is not a PDF", vim.log.levels.WARN)
  end
end

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
