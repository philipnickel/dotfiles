-- ToggleTerm configuration for native Neovim terminals

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "vertical" then
          return vim.o.columns * 0.4  -- 40% of screen width
        elseif term.direction == "horizontal" then
          return vim.o.lines * 0.3     -- 30% of screen height
        else
          return 20
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "vertical",  -- Changed to vertical split
      close_on_exit = false,   -- Don't auto-close on exit
      shell = vim.o.shell,
      -- Enable window navigation
      winbar = {
        enabled = false,
      },
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })

    -- Custom terminal configurations
    local Terminal = require("toggleterm.terminal").Terminal

    -- Python/IPython terminal
    local python_term = Terminal:new({
      cmd = function()
        local has_uv = vim.fn.executable("uv") == 1
        local function ensure_ipython_with_uv()
          local ok = vim.fn.system("uv run python -c \"import IPython\"")
          if vim.v.shell_error ~= 0 then
            vim.notify("Installing ipython via uv...", vim.log.levels.INFO)
            vim.fn.system("uv add ipython")
          end
        end

        if has_uv then
          ensure_ipython_with_uv()
          -- Use PYTHONUNBUFFERED for immediate image display
          return "PYTHONUNBUFFERED=1 uv run ipython --no-confirm-exit --no-autoindent"
        end

        if vim.fn.executable("ipython") == 1 then
          return "PYTHONUNBUFFERED=1 ipython --no-confirm-exit --no-autoindent"
        end

        return "PYTHONUNBUFFERED=1 python"
      end,
      hidden = true,
      direction = "vertical",
      size = function() return vim.o.columns * 0.4 end,
      env = {
        PYTHONUNBUFFERED = "1",
      },
    })

    -- R/Radian terminal
    local r_term = Terminal:new({
      cmd = function()
        if vim.fn.executable("radian") == 1 then
          return "radian"
        else
          return "R --no-save"
        end
      end,
      hidden = true,
      direction = "vertical",
      size = function() return vim.o.columns * 0.4 end,
    })

    -- Julia terminal
    local julia_term = Terminal:new({
      cmd = "julia",
      hidden = true,
      direction = "vertical",
      size = function() return vim.o.columns * 0.4 end,
    })

    -- Shell terminal
    local shell_term = Terminal:new({
      cmd = vim.env.SHELL or "$SHELL",
      hidden = true,
      direction = "vertical",
      size = function() return vim.o.columns * 0.4 end,
    })

    -- Floating terminal for quick tasks
    local float_term = Terminal:new({
      direction = "float",
      hidden = true,
      size = 80,
    })

    -- Terminal management functions
    local function close_all_terminals()
      python_term:close()
      r_term:close()
      julia_term:close()
      shell_term:close()
      float_term:close()
      vim.notify("All terminals closed", vim.log.levels.INFO)
    end

    local function kill_terminal_process()
      -- Send Ctrl+C to kill the current process
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "t", true)
    end

    local function exit_terminal()
      -- Send exit command
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("exit<CR>", true, false, true), "t", true)
    end

    local function toggle_terminal(term, enter_insert)
      term:toggle()
      if enter_insert then
        vim.cmd("startinsert")
      end
    end

    -- Terminal control keymaps
    vim.keymap.set("n", "<leader>rp", function() toggle_terminal(python_term, true) end, { desc = "Python REPL" })
    vim.keymap.set("n", "<leader>rr", function() toggle_terminal(r_term, true) end, { desc = "R REPL" })
    vim.keymap.set("n", "<leader>rj", function() toggle_terminal(julia_term, true) end, { desc = "Julia REPL" })
    vim.keymap.set("n", "<leader>rs", function() toggle_terminal(shell_term, true) end, { desc = "Shell terminal" })
    vim.keymap.set("n", "<leader>rf", function() toggle_terminal(float_term, true) end, { desc = "Floating terminal" })
    vim.keymap.set("n", "<leader>ra", close_all_terminals, { desc = "Close all terminals" })
    vim.keymap.set("n", "<leader>rk", kill_terminal_process, { desc = "Send <C-c> to terminal" })
    vim.keymap.set("n", "<leader>rx", exit_terminal, { desc = "Send exit to terminal" })
    vim.keymap.set("t", "<C-c>", kill_terminal_process, { desc = "Kill terminal process" })
    vim.keymap.set("t", "<C-d>", exit_terminal, { desc = "Exit terminal" })
    
    -- Window navigation for terminals
    vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Navigate left from terminal" })
    vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Navigate down from terminal" })
    vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Navigate up from terminal" })
    vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Navigate right from terminal" })
    
    -- Navigate to terminal windows
    vim.keymap.set("n", "<leader>rw", function()
      -- Find terminal windows and cycle through them
      local term_wins = {}
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if string.match(buf_name, "term://") then
          table.insert(term_wins, win)
        end
      end
      
      if #term_wins > 0 then
        vim.api.nvim_set_current_win(term_wins[1])
        vim.cmd("startinsert")
      else
        vim.notify("No terminal windows found", vim.log.levels.WARN)
      end
    end, { desc = "Navigate to terminal window" })
    
    -- Toggle terminal insert/normal mode
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal insert mode" })
    
    -- Make terminals globally accessible
    _G.python_term = python_term
    _G.r_term = r_term
    _G.julia_term = julia_term
    _G.shell_term = shell_term
    _G.float_term = float_term
  end,
}
