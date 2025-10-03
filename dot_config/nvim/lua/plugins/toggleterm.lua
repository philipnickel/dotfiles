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
        if vim.fn.executable("ipython") == 1 then
          return "ipython --no-confirm-exit --no-autoindent"
        else
          return "python"
        end
      end,
      hidden = true,
      direction = "vertical",
      size = function() return vim.o.columns * 0.4 end,
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

    -- Keymaps for terminal management
    vim.keymap.set("n", "<leader>ci", function() python_term:toggle() end, { desc = "Toggle Python terminal" })
    vim.keymap.set("n", "<leader>cr", function() r_term:toggle() end, { desc = "Toggle R terminal" })
    vim.keymap.set("n", "<leader>cj", function() julia_term:toggle() end, { desc = "Toggle Julia terminal" })
    vim.keymap.set("n", "<leader>cn", function() shell_term:toggle() end, { desc = "Toggle shell terminal" })
    vim.keymap.set("n", "<leader>cf", function() float_term:toggle() end, { desc = "Toggle floating terminal" })
    
    -- Terminal control keymaps
    vim.keymap.set("n", "<leader>cc", close_all_terminals, { desc = "Close all terminals" })
    vim.keymap.set("t", "<C-c>", kill_terminal_process, { desc = "Kill terminal process" })
    vim.keymap.set("t", "<C-d>", exit_terminal, { desc = "Exit terminal" })
    
    -- Window navigation for terminals
    vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Navigate left from terminal" })
    vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Navigate down from terminal" })
    vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Navigate up from terminal" })
    vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Navigate right from terminal" })
    
    -- Navigate to terminal windows
    vim.keymap.set("n", "<leader>tw", function()
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
    vim.keymap.set("n", "<leader>ti", function()
      -- Enter insert mode in current terminal
      vim.cmd("startinsert")
    end, { desc = "Enter terminal insert mode" })
    
    -- Quick terminal access
    vim.keymap.set("n", "<leader>tp", function() 
      python_term:toggle()
      vim.cmd("startinsert")
    end, { desc = "Toggle Python terminal and enter" })
    vim.keymap.set("n", "<leader>tr", function() 
      r_term:toggle()
      vim.cmd("startinsert")
    end, { desc = "Toggle R terminal and enter" })

    -- These keymaps are now handled in core/keymaps.lua
    -- Keeping them here for reference but they're overridden by the core keymaps

    -- Make terminals globally accessible
    _G.python_term = python_term
    _G.r_term = r_term
    _G.julia_term = julia_term
    _G.shell_term = shell_term
    _G.float_term = float_term
  end,
}