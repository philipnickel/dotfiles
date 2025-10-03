-- Keymaps configuration for LunarVim
-- This file contains custom keybindings that are NOT part of which-key menus

local function is_code_chunk()
  local has_otter, otter_keeper = pcall(require, 'otter.keeper')
  if not has_otter then
    return false
  end
  local current, _ = otter_keeper.get_current_language_context()
  if current then
    return true
  else
    return false
  end
end

--- Insert code chunk of given language
local function insert_code_chunk(lang)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'n', true)
  local keys
  if is_code_chunk() then
    keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
  else
    keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
  end
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end

local function new_terminal(lang)
  -- Create a tmux split and launch the terminal
  vim.fn.system('tmux split-window -h "' .. lang .. '"')
  -- Switch back to the previous pane (nvim)
  vim.fn.system('tmux select-pane -t {last}')
  -- Configure slime to target tmux and the last pane
  vim.g.slime_target = "tmux"
  vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
  vim.print('Created tmux split with: ' .. lang)
end

local function new_terminal_smart_python()
  -- Check if ipython is available in current environment
  local has_ipython = vim.fn.executable('ipython') == 1
  if has_ipython then
    new_terminal('ipython --no-confirm-exit --no-autoindent')
  else
    new_terminal('python')
  end
end

local function close_tmux_repl()
  -- Kill the last tmux pane (the REPL)
  vim.fn.system('tmux kill-pane -t {last}')
  vim.print('Closed tmux REPL pane')
end

local function delete_cell()
  -- Find the current cell boundaries
  local current_line = vim.fn.line('.')
  local ft = vim.bo.filetype

  if ft == 'python' then
    -- For Python files with #%% delimiters
    vim.fn.cursor(current_line, 1)
    local cell_start = vim.fn.search('^#%%', 'bcnW')
    vim.fn.cursor(current_line, 1)
    local cell_end = vim.fn.search('^#%%', 'nW')

    if cell_start > 0 then
      if cell_end > 0 then
        -- Delete from #%% to line before next #%%
        vim.cmd(cell_start .. ',' .. (cell_end - 1) .. 'delete')
      else
        -- Delete from #%% to end of file
        vim.cmd(cell_start .. ',$delete')
      end
    end
  else
    -- For Quarto/markdown files with ``` delimiters
    vim.fn.cursor(current_line, 1)
    -- Find opening ``` delimiter
    local cell_start = vim.fn.search('^```', 'bcnW')

    if cell_start > 0 then
      vim.fn.cursor(cell_start, 1)
      -- Find closing ``` delimiter (next ``` after the opening)
      local cell_end = vim.fn.search('^```', 'W')

      if cell_end > 0 then
        -- Delete from opening ``` to closing ``` (inclusive)
        vim.cmd(cell_start .. ',' .. cell_end .. 'delete')
      else
        -- No closing delimiter found, delete to end of file
        vim.cmd(cell_start .. ',$delete')
      end
    end
  end
end

-- Cell navigation
local function next_cell()
  local ft = vim.bo.filetype
  if ft == 'python' then
    -- For Python, search for #%% and move to line below it
    local found = vim.fn.search('^#%%', 'W')
    if found > 0 then
      vim.cmd('normal! j')  -- Move to first line below #%%
    end
  else
    -- For Quarto, search for ``` and move to next line (inside the block)
    local found = vim.fn.search('^```{', 'W')
    if found > 0 then
      vim.cmd('normal! j')  -- Move to first line inside code block
    end
  end
end

local function prev_cell()
  local ft = vim.bo.filetype
  if ft == 'python' then
    -- For Python, move up one line first to avoid matching current cell, then search backwards
    local current_line = vim.fn.line('.')
    vim.fn.cursor(current_line - 1, 1)
    local found = vim.fn.search('^#%%', 'bW')
    if found > 0 then
      vim.cmd('normal! j')  -- Move to first line below #%%
    end
  else
    -- For Quarto, move up first then search backwards for ``` and move to next line
    local current_line = vim.fn.line('.')
    vim.fn.cursor(current_line - 1, 1)
    local found = vim.fn.search('^```{', 'bW')
    if found > 0 then
      vim.cmd('normal! j')  -- Move to first line inside code block
    end
  end
end

vim.keymap.set('n', ']c', next_cell, { silent = true, desc = 'next code cell' })
vim.keymap.set('n', '[c', prev_cell, { silent = true, desc = 'previous code cell' })

-- Visual mode: run selection
vim.keymap.set('v', '<cr>', function()
  local ft = vim.bo.filetype
  if ft == 'python' then
    vim.cmd("'<,'>SlimeSend")
  else
    require("quarto.runner").run_range()
  end
end, { silent = true, desc = 'run visual range' })

-- Buffer navigation shortcuts (override lazy.nvim default <Tab>)
local function set_buffer_keymaps()
  pcall(vim.keymap.del, 'n', '<Tab>')
  vim.keymap.set('n', '<Tab>', '<cmd>bnext<cr>', { silent = true, desc = 'next buffer' })
  vim.keymap.set('n', '<S-Tab>', '<cmd>bprevious<cr>', { silent = true, desc = 'previous buffer' })
  pcall(vim.keymap.del, 'n', '<leader>x')
  vim.keymap.set('n', '<leader>x', '<cmd>bdelete<cr>', { silent = true, desc = 'close buffer' })
end

set_buffer_keymaps()

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = set_buffer_keymaps,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyDone',
  callback = set_buffer_keymaps,
})

-- Insert mode shortcuts for code chunks
vim.keymap.set('i', '<m-i>', function() insert_code_chunk('r') end, { silent = true, desc = 'r code chunk' })
vim.keymap.set('i', '<m-I>', function() insert_code_chunk('python') end, { silent = true, desc = 'python code chunk' })


-- Which-key groups for Quarto
lvim.builtin.which_key.mappings["q"] = {
  name = "Quarto",
  a = { ":QuartoActivate<cr>", "Activate" },
  p = { ":lua require('quarto').quartoPreview()<cr>", "HTML Preview" },
  q = { ":lua require('quarto').quartoClosePreview()<cr>", "Close Preview" },
  h = { ":QuartoHelp ", "Help" },
  m = { ":lua require('nabla').toggle_virt()<cr>", "Toggle Math" },
  c = { function()
    local file = vim.fn.expand('%:p')
    local dir = vim.fn.expand('%:p:h')
    local basename = vim.fn.expand('%:t:r')
    -- Remove HTML output and _files folder
    vim.fn.system('rm -f ' .. dir .. '/' .. basename .. '.html')
    vim.fn.system('rm -rf ' .. dir .. '/' .. basename .. '_files')
    vim.print('Cleaned: ' .. basename .. '.html and ' .. basename .. '_files/')
  end, "Clean output files" },
  f = { function()
    -- PDF Preview with Zathura - similar to HTML preview workflow
    local file = vim.api.nvim_buf_get_name(0)
    
    -- If buffer has no name, try to get it from expand
    if file == '' or file == nil then
      file = vim.fn.expand('%:p')
    end
    
    if file == '' or file == nil then
      vim.print('Error: No file is open. Please open a Quarto file first.')
      return
    end
    
    -- Extract directory and basename from the file path
    local dir = vim.fn.fnamemodify(file, ':h')
    local basename = vim.fn.fnamemodify(file, ':t:r')
    local pdf_file = dir .. '/' .. basename .. '.pdf'
    
    vim.print('File: ' .. file)
    vim.print('PDF will be: ' .. pdf_file)
    
    -- Check if PDF already exists and is newer than the source file
    local source_time = vim.fn.getftime(file)
    local pdf_time = vim.fn.getftime(pdf_file)
    
    if pdf_time > 0 and pdf_time >= source_time then
      -- PDF exists and is up to date, just open it
      vim.print('Opening existing PDF in Zathura...')
      if _G.open_pdf_with_zathura then
        _G.open_pdf_with_zathura(pdf_file)
      else
        vim.fn.system('zathura "' .. pdf_file .. '" &')
      end
      vim.print('PDF opened in Zathura: ' .. basename .. '.pdf')
    else
      -- Need to render PDF first
      vim.print('Rendering PDF and opening in Zathura...')
      
      -- Use Quarto command line to render to PDF
      -- Make sure we use the same Python environment as LunarVim
      local python_path = vim.fn.exepath('python3')
      local cmd = 'quarto render "' .. file .. '" --to pdf'
      
      -- Check if we're in a virtual environment
      local venv_path = vim.env.VIRTUAL_ENV
      local conda_env = vim.env.CONDA_DEFAULT_ENV
      
      if venv_path and venv_path ~= '' then
        vim.print('Using virtual environment: ' .. venv_path)
        -- Activate virtual environment and run Quarto
        local venv_cmd = 'source "' .. venv_path .. '/bin/activate" && ' .. cmd
        vim.fn.system(venv_cmd)
      elseif conda_env and conda_env ~= '' then
        vim.print('Using conda environment: ' .. conda_env)
        -- Activate conda environment and run Quarto
        local conda_cmd = 'conda activate ' .. conda_env .. ' && ' .. cmd
        vim.fn.system(conda_cmd)
      elseif python_path and python_path ~= '' then
        vim.print('Using Python: ' .. python_path)
        -- Set PYTHON environment variable to ensure Quarto uses the same Python
        vim.fn.system('PYTHON="' .. python_path .. '" ' .. cmd)
      else
        vim.fn.system(cmd)
      end
      
      -- Wait for rendering to complete, then open
      vim.defer_fn(function()
        if vim.fn.filereadable(pdf_file) == 1 then
          if _G.open_pdf_with_zathura then
            _G.open_pdf_with_zathura(pdf_file)
          else
            vim.fn.system('zathura "' .. pdf_file .. '" &')
          end
          vim.print('PDF opened in Zathura: ' .. basename .. '.pdf')
        else
          vim.print('PDF not found. Make sure Quarto rendering completed successfully.')
        end
      end, 2000)
    end
  end, "PDF Preview (Zathura)" },
}


-- Helper functions for running code (works for both Quarto and Python files)
local function is_molten_active()
  -- Check if Molten is actually initialized by looking for the global variable
  return vim.g.molten_initialized == true
end

local function run_cell_smart()
  local ft = vim.bo.filetype
  if ft == 'python' then
    -- Check if Molten is active
    if is_molten_active() then
      vim.cmd('MoltenEvaluateOperator')
    else
      vim.fn['slime#send_cell']()
    end
  else
    require("quarto.runner").run_cell()
  end
end

local function run_all_smart()
  local ft = vim.bo.filetype
  if ft == 'python' then
    -- Send entire file to slime
    vim.fn['slime#send'](table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n') .. '\r')
  else
    require("quarto.runner").run_all(true)
  end
end

local function run_line_smart()
  local ft = vim.bo.filetype
  if ft == 'python' then
    vim.fn['slime#send'](vim.fn.getline('.') .. '\r')
  else
    require("quarto.runner").run_line()
  end
end

-- Run code keybindings (top-level for quick access)
lvim.builtin.which_key.mappings["r"] = {
  name = "Run",
  r = { run_cell_smart, "Run Cell" },
  a = { run_all_smart, "Run All Cells" },
  l = { run_line_smart, "Run Line" },
  u = { function()
    local ft = vim.bo.filetype
    if ft ~= 'python' then
      require("quarto.runner").run_above()
    end
  end, "Run Cell and Above" },
  d = { function()
    local ft = vim.bo.filetype
    if ft ~= 'python' then
      require("quarto.runner").run_below()
    end
  end, "Run Cell and Below" },
  j = { next_cell, "Next Cell" },
  k = { prev_cell, "Previous Cell" },
  x = { delete_cell, "Delete Cell" },
}


-- Override LunarVim's default <leader>c (close buffer) with code/chunks
lvim.builtin.which_key.mappings["c"] = {
  name = "Code/Chunks",
  m = { "<cmd>lua vim.fn.call('slime#config', {})<cr>", "Mark terminal" },
  s = { "<cmd>lua vim.fn.call('slime#config', {})<cr>", "Set terminal" },
  t = { "<cmd>lua vim.g.slime_target = vim.g.slime_target == 'tmux' and 'neovim' or 'tmux'; vim.print('Slime target: ' .. vim.g.slime_target)<cr>", "Toggle tmux/neovim" },
  c = { close_tmux_repl, "Close tmux REPL pane" },
  i = { new_terminal_smart_python, "New Python/IPython terminal" },
  r = { function()
    -- Use radian if available, otherwise fall back to R
    local has_radian = vim.fn.executable('radian') == 1
    if has_radian then
      new_terminal('radian')
    else
      new_terminal('R --no-save')
    end
  end, "New R/radian terminal" },
  j = { function() new_terminal('julia') end, "New Julia terminal" },
  n = { function() new_terminal('$SHELL') end, "New Shell terminal" },
}

lvim.builtin.which_key.mappings["o"] = {
  name = "Otter & Code",
  a = { function() require('otter').activate() end, "Otter Activate" },
  d = { function() require('otter').deactivate() end, "Otter Deactivate" },
  r = { function() insert_code_chunk('r') end, "R chunk" },
  p = { function() insert_code_chunk('python') end, "Python chunk" },
  j = { function() insert_code_chunk('julia') end, "Julia chunk" },
  b = { function() insert_code_chunk('bash') end, "Bash chunk" },
  l = { function() insert_code_chunk('lua') end, "Lua chunk" },
}

-- Molten (inline Jupyter output)
lvim.builtin.which_key.mappings["m"] = {
  name = "Molten",
  i = { function()
    -- Detect the active Python interpreter
    local python_path = vim.fn.exepath('python3')
    if python_path == '' then
      python_path = vim.fn.exepath('python')
    end

    if python_path == '' then
      vim.print('Error: No Python interpreter found')
      return
    end

    vim.print('Using Python: ' .. python_path)

    -- Initialize Molten with the detected Python
    local ok, err = pcall(vim.cmd, 'MoltenInit python3')
    if not ok then
      vim.print('Error: Molten not available. Run :UpdateRemotePlugins and restart LunarVim')
      vim.print('Make sure jupyter and ipykernel are installed in your active environment:')
      vim.print('  pip install jupyter ipykernel')
    else
      vim.g.molten_initialized = true
      vim.print('Molten initialized - plots will show inline')
    end
  end, "Initialize Molten" },
  d = { function()
    pcall(vim.cmd, 'MoltenDeinit')
    vim.g.molten_initialized = false
    vim.print('Molten stopped - back to slime mode')
  end, "Deinit Molten" },
  u = { ":UpdateRemotePlugins<cr>", "Update Remote Plugins (restart after)" },
  e = { ":MoltenEvaluateOperator<cr>", "Evaluate Operator" },
  r = { ":MoltenReevaluateCell<cr>", "Re-evaluate Cell" },
  h = { ":MoltenHideOutput<cr>", "Hide Output" },
  s = { ":noautocmd MoltenEnterOutput<cr>", "Show/Enter Output" },
  p = { ":MoltenImagePopup<cr>", "Image Popup" },
}

-- Sidekick AI Assistant
lvim.builtin.which_key.mappings["a"] = {
  name = "AI Assistant",
  a = { function() require("sidekick.cli").toggle({ focus = true }) end, "Toggle AI CLI" },
  c = { function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, "Toggle Claude CLI" },
  g = { function() require("sidekick.cli").toggle({ name = "grok", focus = true }) end, "Toggle Grok CLI" },
  p = { function() require("sidekick.cli").select_prompt() end, "Select Prompt" },
  f = { function() require("sidekick.cli").focus() end, "Focus AI CLI" },
  u = { function() require("sidekick.nes").update() end, "Update Suggestions" },
  j = { function() require("sidekick.nes").jump() end, "Jump to Edit" },
  s = { function() require("sidekick.nes").apply() end, "Apply Suggestions" },
  h = { function() require("sidekick.nes").have() end, "Check Suggestions" },
  x = { function() require("sidekick").clear() end, "Clear Suggestions" },
}

-- Register management with Peekup
-- The plugin provides "" by default, we just add which-key descriptions for discoverability
lvim.builtin.which_key.mappings['"'] = {
  name = "Registers",
  ['"'] = { '""', "View registers (default binding)" },
  p = { "<Plug>PeekupPasteAfter", "Paste after from register" },
  P = { "<Plug>PeekupPasteBefore", "Paste before from register" },
  x = { '"x', "Clear all registers (default binding)" },
}

-- Helper function to open markdown files in floating window
local function open_markdown_float(filepath_or_content, title)
  -- Handle both file paths and content tables
  local content
  if type(filepath_or_content) == "string" then
    -- It's a file path, read the file
    content = vim.fn.readfile(filepath_or_content)
  else
    -- It's already content (table of lines)
    content = filepath_or_content
  end

  -- Create a buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  -- Calculate window size (80% of screen)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Window options
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = title,
    title_pos = 'center',
  }

  -- Open the window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set window options
  vim.api.nvim_win_set_option(win, 'wrap', true)
  vim.api.nvim_win_set_option(win, 'linebreak', true)

  -- Map escape to close the window
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<cr>', { noremap = true, silent = true })
end

-- LuaSnip snippet management
lvim.builtin.which_key.mappings["s"] = {
  name = "Snippets",
  e = { "<cmd>lua require('luasnip.loaders').edit_snippet_files()<cr>", "Edit snippets" },
  r = { "<cmd>lua require('luasnip.loaders.from_lua').load({paths = vim.fn.stdpath('config') .. '/luasnippets/'})<cr>", "Reload snippets" },
  s = { function()
    -- Show snippet documentation by reading snippet files
    local function get_snippet_info()
      local snippets = {}
      local snippet_dir = vim.fn.stdpath('config') .. '/luasnippets/tex/'
      
      -- Read all snippet files
      local files = vim.fn.glob(snippet_dir .. '*.lua', false, true)
      for _, file in ipairs(files) do
        local content = vim.fn.readfile(file)
        local filename = vim.fn.fnamemodify(file, ':t:r')
        
        for _, line in ipairs(content) do
          local trig_match = line:match('trig%s*=%s*"([^"]*)"')
          local name_match = line:match('name%s*=%s*"([^"]*)"')
          local dscr_match = line:match('dscr%s*=%s*"([^"]*)"')
          
          if trig_match and trig_match ~= '' then
            table.insert(snippets, {
              trigger = trig_match,
              name = name_match or '',
              description = dscr_match or '',
              file = filename
            })
          end
        end
      end
      
      return snippets
    end
    
    local snippets = get_snippet_info()
    local content = {"# LaTeX Snippets Documentation", ""}
    
    -- Group by file
    local files = {}
    for _, snippet in ipairs(snippets) do
      if not files[snippet.file] then
        files[snippet.file] = {}
      end
      table.insert(files[snippet.file], snippet)
    end
    
    for filename, file_snippets in pairs(files) do
      table.insert(content, "## " .. filename:gsub("^%l", string.upper))
      table.insert(content, "")
      table.insert(content, "| Trigger | Name | Description |")
      table.insert(content, "|---------|------|-------------|")
      
      for _, snippet in ipairs(file_snippets) do
        local trigger = "`" .. snippet.trigger .. "`"
        local name = snippet.name ~= '' and snippet.name or '-'
        local description = snippet.description ~= '' and snippet.description or '-'
        table.insert(content, "| " .. trigger .. " | " .. name .. " | " .. description .. " |")
      end
      table.insert(content, "")
    end
    
    open_markdown_float(content, " LaTeX Snippets Documentation ")
  end, "Show snippet documentation" },
  g = { function()
    open_markdown_float(
      vim.fn.stdpath('config') .. "/GUIDE.md",
      " LaTeX Snippets Smart Features Guide "
    )
  end, "Smart features guide" },
  y = { function()
    open_markdown_float(
      vim.fn.stdpath('config') .. "/SYMPY_GUIDE.md",
      " SymPy Mathematical Evaluation Guide "
    )
  end, "SymPy evaluation guide" },
  p = { function()
    open_markdown_float(
      vim.fn.stdpath('config') .. "/SYMPY_GUIDE.md",
      " SymPy Mathematical Evaluation Guide "
    )
  end, "SymPy guide" },
  m = { function()
    -- Toggle VimTeX character mappings using native commands
    local current_state = vim.g.vimtex_imaps_enabled
    if current_state == 0 then
      vim.g.vimtex_imaps_enabled = 1
      vim.cmd("VimtexReload")
      vim.notify("VimTeX character mappings: ENABLED", vim.log.levels.INFO)
    else
      vim.g.vimtex_imaps_enabled = 0
      vim.cmd("VimtexReload")
      vim.notify("VimTeX character mappings: DISABLED", vim.log.levels.INFO)
    end
  end, "Toggle VimTeX mappings" },
}
