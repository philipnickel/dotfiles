-- Vim-slime REPL integration configuration

return {
  "jpalardy/vim-slime",
  init = function()
    vim.b['quarto_is_python_chunk'] = false
    Quarto_is_in_python_chunk = function()
      require('otter.tools.functions').is_otter_language_context('python')
    end

    vim.cmd([[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
      return [a:text, "\n"]
      endif
      return [a:text]
      endfunction
    ]])

    -- Configure for WezTerm
    vim.g.slime_target = "wezterm"
    vim.g.slime_wezterm_pane_id = nil  -- Will be auto-detected
    vim.g.slime_no_mappings = true
    vim.g.slime_python_ipython = 0  -- Disable IPython magic (euporie doesn't need %cpaste)
    vim.g.slime_dont_ask_default = 1
    vim.g.slime_default_config = {}
    
    -- Bracketed paste for multiline code (works with euporie and IPython)
    vim.g.slime_bracketed_paste = 1
    
    -- Set cell delimiters based on filetype
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"python"},
      callback = function()
        -- Support both #%% and # %% (with space)
        vim.b.slime_cell_delimiter = "# %%"
      end,
    })
    
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"quarto", "markdown", "rmd"},
      callback = function()
        vim.b.slime_cell_delimiter = "```"
      end,
    })
  end,
  config = function()
    vim.g.slime_input_pid = false
    vim.g.slime_suggest_default = true
    vim.g.slime_menu_config = false

    -- Global variable to track REPL pane
    _G.repl_pane_id = nil

    -- Function to send entire file
    local function send_file()
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local text = table.concat(lines, "\n")
      vim.fn['slime#send'](text .. "\n")
    end

    -- Start euporie/REPL in tmux pane (1/3 width on right)
    local function start_repl()
      local cwd = vim.fn.getcwd()
      local ft = vim.bo.filetype
      
      if not os.getenv("TMUX") then
        vim.notify("Start this in tmux", vim.log.levels.WARN)
        return
      end
      
      -- Determine what to launch based on filetype
      local start_cmd
      local is_python = ft == "python" or ft == "quarto"
      local is_r = ft == "r" or ft == "rmd"
      
      if is_python then
        if vim.fn.executable("uv") ~= 1 then
          vim.notify("uv not found. Install: curl -LsSf https://astral.sh/uv/install.sh | sh", vim.log.levels.ERROR)
          return
        end
        
        -- Ensure euporie is installed as a global tool (once)
        if vim.fn.executable("euporie-console") ~= 1 then
          vim.notify("Installing euporie as uv tool...", vim.log.levels.INFO)
          vim.fn.system("uv tool install --with 'catppuccin[pygments]' euporie 2>&1")
        end
        
        -- Only install ipykernel in the project
        vim.notify("Ensuring ipykernel in project...", vim.log.levels.INFO)
        vim.fn.system("cd '" .. cwd .. "' && uv add --quiet ipykernel 2>&1")
        -- Ensure kernel is installed and available
        vim.fn.system("cd '" .. cwd .. "' && uv run python -m ipykernel install --user --name python3 2>&1")
        
        -- Run euporie as a tool, it will auto-detect the project's kernel
        start_cmd = "euporie-console"
      elseif is_r then
        local has_radian = vim.fn.executable("radian") == 1
        start_cmd = has_radian and "radian" or "R"
      else
        vim.notify("Unsupported filetype: " .. ft, vim.log.levels.WARN)
        return
      end
      
      -- Split tmux pane at 40% width on the right
      vim.fn.system("tmux split-window -h -p 40 -c '" .. cwd .. "'")
      local pane_id = vim.fn.system("tmux display-message -p '#{pane_id}'"):gsub("\n", "")
      vim.fn.system("tmux send-keys -t " .. pane_id .. " '" .. start_cmd .. "' C-m")
      
      -- Store pane ID globally
      _G.repl_pane_id = pane_id
      
      vim.g.slime_target = "tmux"
      vim.g.slime_default_config = {socket_name = "default", target_pane = pane_id}
      vim.b.slime_config = {socket_name = "default", target_pane = pane_id}
      vim.notify("REPL started", vim.log.levels.INFO)
    end
    
    -- Kill the tmux REPL pane
    local function kill_repl()
      if not os.getenv("TMUX") then
        vim.notify("Not in tmux", vim.log.levels.WARN)
        return
      end
      
      if _G.repl_pane_id then
        vim.fn.system("tmux kill-pane -t " .. _G.repl_pane_id)
        _G.repl_pane_id = nil
        vim.notify("REPL pane killed", vim.log.levels.INFO)
      else
        vim.notify("No REPL pane to kill", vim.log.levels.WARN)
      end
    end
    
    -- Toggle floating terminal (toggleterm)
    local function toggle_float_term()
      local Terminal = require('toggleterm.terminal').Terminal
      if not _G.float_term then
        _G.float_term = Terminal:new({
          direction = "float",
          on_open = function(term)
            vim.cmd("startinsert!")
          end,
        })
      end
      _G.float_term:toggle()
    end
    
    -- Restart floating terminal
    local function restart_float_term()
      if _G.float_term then
        _G.float_term:shutdown()
        _G.float_term = nil
      end
      toggle_float_term()
    end

    -- Keybindings
    vim.keymap.set('n', '<leader>re', start_repl, { desc = 'Open REPL' })
    vim.keymap.set('n', '<leader>rr', '<Plug>SlimeSendCell', { desc = 'Run cell/block' })
    vim.keymap.set('n', '<leader>rs', toggle_float_term, { desc = 'Toggle shell' })
    vim.keymap.set('n', '<leader>rS', restart_float_term, { desc = 'Restart shell' })
    vim.keymap.set('n', '<leader>rx', kill_repl, { desc = 'Kill REPL pane' })
    
    -- Send code keybindings
    vim.keymap.set('n', '<leader>rl', '<Plug>SlimeLineSend', { desc = 'Run line' })
    vim.keymap.set('x', '<leader>rv', '<Plug>SlimeRegionSend', { desc = 'Run selection' })
    vim.keymap.set('n', '<leader>rf', send_file, { desc = 'Run file' })
  end,
}
