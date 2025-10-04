-- Iron.nvim configuration for interactive REPLs

return {
  "Vigemus/iron.nvim",
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")

    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            command = {"zsh"}
          },
          python = {
            command = {"ipython", "--no-autoindent"},
            format = require("iron.fts.common").bracketed_paste_python,
            block_dividers = { "# %%", "#%%" },
            env = {PYTHON_BASIC_REPL = "1"}
          },
          r = {
            command = {"R"}
          },
          julia = {
            command = {"julia"}
          },
          lua = {
            command = {"lua"}
          },
          -- Support for Quarto/Markdown files
          quarto = {
            command = {"ipython", "--no-autoindent"}
          },
          markdown = {
            command = {"ipython", "--no-autoindent"}
          },
        },
        
        -- Repl window will be displayed as a vertical split (40% width)
        repl_open_cmd = view.split.vertical.botright("40%"),
        
        -- Set the file type of the newly created repl to ft
        repl_filetype = function(bufnr, ft)
          -- For Quarto/Markdown files, detect the language in the current chunk
          if ft == "quarto" or ft == "markdown" then
            local ok_otter, otter_keeper = pcall(require, 'otter.keeper')
            if ok_otter then
              local current = otter_keeper.get_current_language_context()
              if current and current ~= "" then
                return current
              end
            end
            -- Fallback to python for Quarto/Markdown
            return "python"
          end
          return ft
        end,
      },
      
      -- Iron doesn't set keymaps by default anymore
      keymaps = {
        toggle_repl = "<leader>rr",
        restart_repl = "<leader>rR",
        send_motion = "<leader>rs",
        visual_send = "<leader>rv",
        send_file = "<leader>rf",
        send_line = "<leader>rl",
        send_paragraph = "<leader>rp",
        send_until_cursor = "<leader>ru",
        send_mark = "<leader>rm",
        mark_motion = "<leader>rm",
        mark_visual = "<leader>rm",
        remove_mark = "<leader>rm",
        cr = "<leader>rs<cr>",
        clear = "<leader>rc",
        -- Additional keymaps for code blocks
        send_code_block = "<leader>rb",
        send_code_block_and_move = "<leader>rn",
      },
      
      -- If the highlight is on, you can change how it looks
      highlight = {
        italic = true
      },
      
      -- Ignore blank lines when sending visual select lines
      ignore_blank_lines = true,
    })

    -- Additional keymaps for iron focus and hide
    vim.keymap.set('n', '<leader>rF', '<cmd>IronFocus<cr>', { desc = 'Focus REPL' })
    vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>', { desc = 'Hide REPL' })
  end,
}