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

vim.keymap.set('c', '<C-j>', '<Down>', { noremap = true, desc = 'Command-line down' })
vim.keymap.set('c', '<C-k>', '<Up>', { noremap = true, desc = 'Command-line up' })

vim.keymap.set('n', '<leader>hu', vim.cmd.UndotreeToggle, { desc = 'Toggle undo tree' })
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
