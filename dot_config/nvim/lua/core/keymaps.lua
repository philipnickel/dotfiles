-- Core keymaps configuration

-- Optional ChezMoi helpers
local ok_chezmoi, chezmoi_utils = pcall(require, 'utils.chezmoi')

local function open_chezmoi_files()
  if ok_chezmoi then
    chezmoi_utils.open_files()
  else
    vim.notify('chezmoi utils unavailable', vim.log.levels.ERROR)
  end
end

local function edit_with_chezmoi()
  if ok_chezmoi then
    chezmoi_utils.edit_current()
  else
    vim.notify('chezmoi utils unavailable', vim.log.levels.ERROR)
  end
end

_G.OPEN_CHEZMOI_FILES = open_chezmoi_files
vim.api.nvim_create_user_command('ChezmoiFiles', open_chezmoi_files, { desc = 'Browse chezmoi managed files' })

-- Helper utilities ---------------------------------------------------------

local function is_code_chunk()
  local ok_otter, otter_keeper = pcall(require, 'otter.keeper')
  if not ok_otter then
    return false
  end
  local current = otter_keeper.get_current_language_context()
  return current ~= nil
end

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

-- Terminal management functions (fallback for when iron.nvim is not available)
local function get_terminal_for_filetype()
  if vim.bo.filetype == "python" then
    return _G.python_term
  elseif vim.bo.filetype == "r" or vim.bo.filetype == "rmd" then
    return _G.r_term
  elseif vim.bo.filetype == "julia" then
    return _G.julia_term
  else
    return _G.shell_term
  end
end

local function send_to_terminal(text, show_terminal)
  local term = get_terminal_for_filetype()
  if term then
    term:send(text)
    if show_terminal then
      -- Only open terminal if it's not already visible
      if not term:is_open() then
        term:toggle()
      end
      -- Don't focus terminal - let user stay in code window
    end
  else
    vim.notify("No terminal available for current filetype", vim.log.levels.WARN)
  end
end

-- Native code block detection functions
local function find_cell_boundaries()
  local ft = vim.bo.filetype
  local current_line = vim.fn.line('.')
  
  if ft == 'python' then
    -- Look for #%% or # %% markers (more flexible regex)
    local cell_start = vim.fn.search([[^#\s*%%]], 'bcnW')
    local cell_end = vim.fn.search([[^#\s*%%]], 'nW')
    return cell_start, cell_end
  elseif ft == 'quarto' or ft == 'markdown' then
    -- Look for ``` code blocks
    local cell_start = vim.fn.search('^```', 'bcnW')
    local cell_end = vim.fn.search('^```', 'nW')
    return cell_start, cell_end
  elseif ft == 'r' or ft == 'rmd' then
    -- Look for ```{r} or similar chunks
    local cell_start = vim.fn.search('^```{', 'bcnW')
    local cell_end = vim.fn.search('^```', 'nW')
    return cell_start, cell_end
  end
  
  return nil, nil
end

local function get_current_cell_lines()
  local cell_start, cell_end = find_cell_boundaries()
  
  if cell_start and cell_start > 0 then
    local start_line = cell_start
    local end_line = cell_end and cell_end > 0 and cell_end - 1 or vim.fn.line('$')
    return vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  end
  
  return nil
end

-- Native selection-based execution
local function execute_selection()
  local mode = vim.fn.mode()
  
  if mode == 'v' or mode == 'V' or mode == '' then
    -- We're in visual mode, execute the selection
    local start_line = vim.fn.getpos("'<")[2]
    local end_line = vim.fn.getpos("'>")[2]
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local text = table.concat(lines, '\n')
    send_to_terminal(text, true)
  else
    -- Not in visual mode, try to detect current cell
    local cell_lines = get_current_cell_lines()
    if cell_lines then
      local text = table.concat(cell_lines, '\n')
      send_to_terminal(text, true)
    else
      -- No cell found, execute current line
      send_to_terminal(vim.fn.getline('.'), true)
    end
  end
end

-- Select current cell for manual execution
local function select_current_cell()
  local cell_start, cell_end = find_cell_boundaries()
  
  if cell_start and cell_start > 0 then
    local start_line = cell_start
    local end_line = cell_end and cell_end > 0 and cell_end - 1 or vim.fn.line('$')
    
    -- Set visual selection to the cell
    vim.fn.cursor(start_line, 1)
    vim.cmd('normal! V')
    vim.fn.cursor(end_line, 1)
    vim.cmd('normal! $')
    
    vim.notify('Cell selected - use <leader>cs to execute', vim.log.levels.INFO)
  else
    vim.notify('No cell found at current position', vim.log.levels.WARN)
  end
end

local function delete_cell()
  local ft = vim.bo.filetype
  if ft == 'python' then
    local current_line = vim.fn.line('.')
    vim.fn.cursor(current_line, 1)
    local cell_start = vim.fn.search('^#%%', 'bcnW')
    vim.fn.cursor(current_line, 1)
    local cell_end = vim.fn.search('^#%%', 'nW')
    if cell_start > 0 then
      if cell_end > 0 then
        vim.cmd(string.format('%d,%dd', cell_start, cell_end - 1))
      else
        vim.cmd(string.format('%d,$d', cell_start))
      end
    end
  else
    vim.fn.cursor(vim.fn.line('.'), 1)
    local cell_start = vim.fn.search('^```', 'bcnW')
    if cell_start > 0 then
      vim.fn.cursor(cell_start, 1)
      local cell_end = vim.fn.search('^```', 'W')
      if cell_end > 0 then
        vim.cmd(string.format('%d,%dd', cell_start, cell_end))
      else
        vim.cmd(string.format('%d,$d', cell_start))
      end
    end
  end
end

local function next_cell()
  local ft = vim.bo.filetype
  local found = 0
  
  if ft == 'python' then
    found = vim.fn.search([[^#\s*%%]], 'W')
  elseif ft == 'quarto' or ft == 'markdown' then
    found = vim.fn.search('^```', 'W')
  elseif ft == 'r' or ft == 'rmd' then
    found = vim.fn.search('^```{', 'W')
  end
  
  if found > 0 then
    vim.cmd('normal! j')
  end
end

local function prev_cell()
  local ft = vim.bo.filetype
  local current_line = vim.fn.line('.')
  vim.fn.cursor(current_line - 1, 1)
  local found = 0
  
  if ft == 'python' then
    found = vim.fn.search([[^#\s*%%]], 'bW')
  elseif ft == 'quarto' or ft == 'markdown' then
    found = vim.fn.search('^```', 'bW')
  elseif ft == 'r' or ft == 'rmd' then
    found = vim.fn.search('^```{', 'bW')
  end
  
  if found > 0 then
    vim.cmd('normal! j')
  end
end


local function run_cell_smart()
  if vim.bo.filetype == 'python' then
    -- Use toggleterm for Python execution
    execute_selection()
  else
    local ok, runner = pcall(require, 'quarto.runner')
    if ok then
      runner.run_cell()
    end
  end
end

local function run_all_smart()
  if vim.bo.filetype == 'python' then
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    send_to_terminal(table.concat(lines, '\n'), true)  -- Show terminal for run all
  else
    local ok, runner = pcall(require, 'quarto.runner')
    if ok then
      runner.run_all(true)
    end
  end
end

local function run_line_smart()
  if vim.bo.filetype == 'python' then
    send_to_terminal(vim.fn.getline('.'), true)  -- Show terminal for line execution
  else
    local ok, runner = pcall(require, 'quarto.runner')
    if ok then
      runner.run_line()
    end
  end
end

local function run_cell_above()
  if vim.bo.filetype == 'python' then
    -- Find current cell and run it plus all cells above
    local current_line = vim.fn.line('.')
    local cell_start = vim.fn.search([[^#\s*%%]], 'bcnW')
    
    if cell_start > 0 then
      -- Run from beginning of file to end of current cell
      local end_line = vim.fn.search([[^#\s*%%]], 'nW')
      end_line = end_line > 0 and end_line - 1 or vim.fn.line('$')
      local lines = vim.api.nvim_buf_get_lines(0, 1, end_line, false)
      local text = table.concat(lines, '\n')
      send_to_terminal(text, true)  -- Show terminal for run above
    else
      -- No cell markers, run from beginning to current line
      local lines = vim.api.nvim_buf_get_lines(0, 1, current_line, false)
      local text = table.concat(lines, '\n')
      send_to_terminal(text, true)  -- Show terminal for run above
    end
  else
    local ok, runner = pcall(require, 'quarto.runner')
    if ok then
      runner.run_above()
    end
  end
end

local function run_cell_below()
  if vim.bo.filetype == 'python' then
    -- Find current cell and run it plus all cells below
    local current_line = vim.fn.line('.')
    local cell_start = vim.fn.search([[^#\s*%%]], 'bcnW')
    
    if cell_start > 0 then
      -- Run from current cell to end of file
      local lines = vim.api.nvim_buf_get_lines(0, cell_start, -1, false)
      local text = table.concat(lines, '\n')
      send_to_terminal(text, true)  -- Show terminal for run below
    else
      -- No cell markers, run from current line to end
      local lines = vim.api.nvim_buf_get_lines(0, current_line, -1, false)
      local text = table.concat(lines, '\n')
      send_to_terminal(text, true)  -- Show terminal for run below
    end
  else
    local ok, runner = pcall(require, 'quarto.runner')
    if ok then
      runner.run_below()
    end
  end
end

local function clean_quarto_outputs()
  local file = vim.fn.expand('%:p')
  if file == '' then
    vim.notify('Open a Quarto file first', vim.log.levels.WARN)
    return
  end
  local dir = vim.fn.fnamemodify(file, ':h')
  local basename = vim.fn.fnamemodify(file, ':t:r')
  vim.fn.system({ 'rm', '-f', dir .. '/' .. basename .. '.html' })
  vim.fn.system({ 'rm', '-rf', dir .. '/' .. basename .. '_files' })
  vim.notify('Cleaned Quarto outputs for ' .. basename)
end

local function open_markdown_float(filepath_or_lines, title)
  local content
  if type(filepath_or_lines) == 'string' then
    content = vim.fn.readfile(filepath_or_lines)
  else
    content = filepath_or_lines
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = title,
    title_pos = 'center',
  })

  vim.api.nvim_win_set_option(win, 'wrap', true)
  vim.api.nvim_win_set_option(win, 'linebreak', true)
  vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, silent = true })
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
end

local function show_snippet_docs()
  local snippet_dir = vim.fn.stdpath('config') .. '/luasnippets/tex/'
  local files = vim.fn.glob(snippet_dir .. '*.lua', false, true)
  local snippets = {}
  for _, file in ipairs(files) do
    local content = vim.fn.readfile(file)
    local filename = vim.fn.fnamemodify(file, ':t:r')
    for _, line in ipairs(content) do
      local trig = line:match('trig%s*=%s*"([^"]+)"')
      if trig then
        table.insert(snippets, {
          file = filename,
          trigger = trig,
          name = line:match('name%s*=%s*"([^"]*)"') or '',
          description = line:match('dscr%s*=%s*"([^"]*)"') or '',
        })
      end
    end
  end

  local grouped = {}
  for _, snip in ipairs(snippets) do
    grouped[snip.file] = grouped[snip.file] or {}
    table.insert(grouped[snip.file], snip)
  end

  local content = { '# LaTeX Snippets Documentation', '' }
  for file, snips in pairs(grouped) do
    table.insert(content, '## ' .. file:gsub('^%l', string.upper))
    table.insert(content, '')
    table.insert(content, '| Trigger | Name | Description |')
    table.insert(content, '|---------|------|-------------|')
    table.sort(snips, function(a, b) return a.trigger < b.trigger end)
    for _, snip in ipairs(snips) do
      table.insert(content, string.format('| `%s` | %s | %s |', snip.trigger, snip.name ~= '' and snip.name or '-', snip.description ~= '' and snip.description or '-'))
    end
    table.insert(content, '')
  end

  open_markdown_float(content, ' LaTeX Snippets Documentation ')
end

-- Basic keymaps ------------------------------------------------------------

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle undo tree' })
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { silent = true, desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', { silent = true, desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { silent = true, desc = 'LazyGit' })
vim.keymap.set('n', '<leader>x', '<cmd>bdelete<cr>', { silent = true, desc = 'Close buffer' })

-- Telescope
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { desc = 'Recent files' })
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope commands<cr>', { desc = 'Commands' })

-- Chezmoi operations -------------------------------------------------------
vim.keymap.set('n', '<leader>Cf', open_chezmoi_files, { desc = 'Find managed file' })
vim.keymap.set('n', '<leader>Ce', edit_with_chezmoi, { desc = 'Edit chezmoi target' })
vim.keymap.set('n', '<leader>Cl', '<cmd>ChezmoiList<cr>', { desc = 'List chezmoi files' })

-- Avante AI assistant ------------------------------------------------------
vim.keymap.set('n', '<leader>aa', '<cmd>AvanteToggle<cr>', { desc = 'Avante toggle sidebar' })
vim.keymap.set('n', '<leader>an', '<cmd>AvanteAsk<cr>', { desc = 'Avante ask' })
vim.keymap.set('n', '<leader>ar', '<cmd>AvanteRefresh<cr>', { desc = 'Avante refresh' })
vim.keymap.set('n', '<leader>af', '<cmd>AvanteFocus<cr>', { desc = 'Avante focus' })
vim.keymap.set('n', '<leader>as', '<cmd>AvanteStop<cr>', { desc = 'Avante stop request' })
vim.keymap.set('n', '<leader>a?', '<cmd>AvanteModels<cr>', { desc = 'Avante models' })

-- LaTeX / VimTeX ----------------------------------------------------------
vim.keymap.set('n', '<leader>ll', '<cmd>VimtexCompile<cr>', { desc = 'Compile LaTeX' })
vim.keymap.set('n', '<leader>lv', '<cmd>VimtexView<cr>', { desc = 'View PDF' })
vim.keymap.set('n', '<leader>lk', '<cmd>VimtexStop<cr>', { desc = 'Stop compilation' })
vim.keymap.set('n', '<leader>le', '<cmd>VimtexErrors<cr>', { desc = 'Show errors' })
vim.keymap.set('n', '<leader>lo', '<cmd>VimtexCompileOutput<cr>', { desc = 'Show output' })
vim.keymap.set('n', '<leader>lS', '<cmd>VimtexStatus<cr>', { desc = 'Status' })
vim.keymap.set('n', '<leader>lG', '<cmd>VimtexStatusAll<cr>', { desc = 'Status all' })
vim.keymap.set('n', '<leader>lc', '<cmd>VimtexClean<cr>', { desc = 'Clean aux files' })
vim.keymap.set('n', '<leader>lC', '<cmd>VimtexClean!<cr>', { desc = 'Clean all aux files' })
vim.keymap.set('n', '<leader>lm', '<cmd>VimtexImapsList<cr>', { desc = 'Imaps list' })
vim.keymap.set('n', '<leader>lx', '<cmd>VimtexReload<cr>', { desc = 'Reload VimTeX' })
vim.keymap.set('n', '<leader>ls', '<cmd>VimtexToggleMain<cr>', { desc = 'Toggle main file' })
vim.keymap.set('n', '<leader>lt', '<cmd>VimtexTocToggle<cr>', { desc = 'Toggle TOC' })
vim.keymap.set('n', '<leader>lT', '<cmd>VimtexLabelsToggle<cr>', { desc = 'Toggle labels' })
vim.keymap.set('n', '<leader>lw', '<cmd>VimtexCountWords<cr>', { desc = 'Word count' })
vim.keymap.set('n', '<leader>li', '<cmd>VimtexInfo<cr>', { desc = 'VimTeX info' })
vim.keymap.set('n', '<leader>lI', '<cmd>VimtexInfoAll<cr>', { desc = 'VimTeX info all' })
vim.keymap.set('n', '<leader>ld', '<cmd>VimtexDocPackage<cr>', { desc = 'Package docs' })
vim.keymap.set('n', '<leader>lD', '<cmd>VimtexDocPackagePrompt<cr>', { desc = 'Package docs (prompt)' })

-- Run / Quarto / Python ----------------------------------------------------
vim.keymap.set('n', '<leader>rr', run_cell_smart, { desc = 'Run cell' })
vim.keymap.set('n', '<leader>ra', run_all_smart, { desc = 'Run all cells' })
vim.keymap.set('n', '<leader>rl', run_line_smart, { desc = 'Run line' })
vim.keymap.set('n', '<leader>ru', run_cell_above, { desc = 'Run cell and above' })
vim.keymap.set('n', '<leader>rd', run_cell_below, { desc = 'Run cell and below' })
vim.keymap.set('n', '<leader>rj', next_cell, { desc = 'Next cell' })
vim.keymap.set('n', '<leader>rk', prev_cell, { desc = 'Previous cell' })
vim.keymap.set('n', '<leader>rx', delete_cell, { desc = 'Delete cell' })

-- Selection-based execution
vim.keymap.set('n', '<leader>rs', select_current_cell, { desc = 'Select current cell' })
vim.keymap.set('v', '<leader>rr', execute_selection, { desc = 'Run selection' })


-- Otter helpers -----------------------------------------------------------
vim.keymap.set('n', '<leader>oa', function() pcall(require('otter').activate) end, { desc = 'Otter activate' })
vim.keymap.set('n', '<leader>od', function() pcall(require('otter').deactivate) end, { desc = 'Otter deactivate' })
vim.keymap.set('n', '<leader>or', function() insert_code_chunk('r') end, { desc = 'Insert R chunk' })
vim.keymap.set('n', '<leader>op', function() insert_code_chunk('python') end, { desc = 'Insert python chunk' })
vim.keymap.set('n', '<leader>oj', function() insert_code_chunk('julia') end, { desc = 'Insert julia chunk' })
vim.keymap.set('n', '<leader>ob', function() insert_code_chunk('bash') end, { desc = 'Insert bash chunk' })
vim.keymap.set('n', '<leader>ol', function() insert_code_chunk('lua') end, { desc = 'Insert lua chunk' })


-- Quarto utilities --------------------------------------------------------
vim.keymap.set('n', '<leader>qa', '<cmd>QuartoActivate<cr>', { desc = 'Activate Quarto' })
vim.keymap.set('n', '<leader>qp', function()
  local ok, quarto = pcall(require, 'quarto')
  if ok then quarto.quartoPreview() end
end, { desc = 'HTML preview' })
vim.keymap.set('n', '<leader>qq', function()
  local ok, quarto = pcall(require, 'quarto')
  if ok then quarto.quartoClosePreview() end
end, { desc = 'Close preview' })
vim.keymap.set('n', '<leader>qh', '<cmd>QuartoHelp<cr>', { desc = 'Quarto help' })
vim.keymap.set('n', '<leader>qm', function()
  local ok, nabla = pcall(require, 'nabla')
  if ok then nabla.toggle_virt() end
end, { desc = 'Toggle math' })
vim.keymap.set('n', '<leader>qc', clean_quarto_outputs, { desc = 'Clean output files' })

-- Snippet & guides --------------------------------------------------------
vim.keymap.set('n', '<leader>se', function()
  pcall(require('luasnip.loaders').edit_snippet_files)
end, { desc = 'Edit snippets' })
vim.keymap.set('n', '<leader>sr', function()
  pcall(require('luasnip.loaders.from_lua').load, { paths = vim.fn.stdpath('config') .. '/luasnippets/' })
  vim.notify('Snippets reloaded')
end, { desc = 'Reload snippets' })
vim.keymap.set('n', '<leader>ss', show_snippet_docs, { desc = 'Snippet documentation' })
vim.keymap.set('n', '<leader>sg', function()
  open_markdown_float(vim.fn.stdpath('config') .. '/GUIDE.md', ' LaTeX Smart Features Guide ')
end, { desc = 'Smart features guide' })
vim.keymap.set('n', '<leader>sy', function()
  open_markdown_float(vim.fn.stdpath('config') .. '/SYMPY_GUIDE.md', ' SymPy Evaluation Guide ')
end, { desc = 'SymPy guide' })
vim.keymap.set('n', '<leader>sp', function()
  open_markdown_float(vim.fn.stdpath('config') .. '/SYMPY_GUIDE.md', ' SymPy Evaluation Guide ')
end, { desc = 'SymPy guide' })
vim.keymap.set('n', '<leader>sm', function()
  local state = vim.g.vimtex_imaps_enabled or 0
  vim.g.vimtex_imaps_enabled = state == 0 and 1 or 0
  vim.cmd('VimtexReload')
  vim.notify('VimTeX mappings ' .. (vim.g.vimtex_imaps_enabled == 1 and 'ENABLED' or 'DISABLED'))
end, { desc = 'Toggle VimTeX mappings' })

-- Markdown preview --------------------------------------------------------
vim.keymap.set('n', '<leader>pp', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Toggle Render Markdown' })
