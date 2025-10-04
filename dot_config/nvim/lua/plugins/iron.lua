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
            command = {"ipython", "--no-autoindent"}
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
        },
        
        -- Repl window will be displayed as a vertical split (40% width)
        repl_open_cmd = view.split.vertical.botright("40%"),
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
      },
      
      -- If the highlight is on, you can change how it looks
      highlight = {
        italic = true
      },
      
      -- Ignore blank lines when sending visual select lines
      ignore_blank_lines = true,
    })

    -- Additional keymaps for iron focus and hide
    vim.keymap.set('n', '<leader>rf', '<cmd>IronFocus<cr>', { desc = 'Focus REPL' })
    vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>', { desc = 'Hide REPL' })
  end,
}