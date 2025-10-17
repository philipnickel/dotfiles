local M = {}

local source_dir

local function get_source_dir()
  if not source_dir then
    local handle = io.popen('chezmoi source-path')
    if handle then
      source_dir = handle:read('*l') or ''
      handle:close()
    end
  end
  return source_dir
end

function M.get_source_dir()
  return get_source_dir()
end

function M.edit_current()
  local bufnr = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' then
    vim.notify('no file associated with buffer', vim.log.levels.WARN)
    return
  end

  local ok, commands = pcall(require, 'chezmoi.commands')
  if not ok then
    vim.notify('chezmoi.nvim not available', vim.log.levels.ERROR)
    return
  end

  commands.edit({ targets = { path } })
  local dir = get_source_dir()
  if dir and dir ~= '' then
    vim.cmd('lcd ' .. vim.fn.fnameescape(dir))
  end
end

function M.open_tree()
  local dir = get_source_dir()
  if not dir or dir == '' then
    vim.notify('chezmoi source directory not found', vim.log.levels.ERROR)
    return false
  end

  local ok, command = pcall(require, 'neo-tree.command')
  if not ok then
    vim.notify('neo-tree not available', vim.log.levels.WARN)
    return false
  end

  command.execute({
    source = 'filesystem',
    position = 'left',
    action = 'focus',
    toggle = false,
    dir = dir,
    cwd = dir,
    reveal = false,
  })

  vim.cmd('lcd ' .. vim.fn.fnameescape(dir))
  return true
end

function M.open_picker()
  local ok_telescope, telescope = pcall(require, 'telescope')
  if not ok_telescope then
    vim.notify('telescope not available', vim.log.levels.ERROR)
    return
  end

  local ok_cmds, commands = pcall(require, 'chezmoi.commands')
  if not ok_cmds then
    vim.notify('chezmoi.commands unavailable', vim.log.levels.ERROR)
    return
  end

  local default_args = {
    '--path-style',
    'absolute',
    '--include',
    'files',
    '--exclude',
    'externals',
  }

  local list = commands.list({ args = default_args })
  if vim.tbl_isempty(list) then
    vim.notify('No chezmoi-managed files found', vim.log.levels.WARN)
    return
  end

  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local make_entry = require('telescope.make_entry')
  local config = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  local opts = {
    cwd = vim.loop.os_homedir(),
  }

  pickers
    .new(opts, {
      prompt_title = 'Chezmoi Files',
      finder = finders.new_table({
        results = list,
        entry_maker = make_entry.gen_from_file(opts),
      }),
      sorter = config.generic_sorter(opts),
      previewer = config.file_previewer(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          commands.edit({ targets = { selection.value } })
        end)
        return true
      end,
    })
    :find()
end

function M.open_files()
  M.open_tree()
  M.open_picker()
end

return M
