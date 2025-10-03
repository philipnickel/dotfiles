local M = {}

local patterns = {
  '.git',
  '.hg',
  '.svn',
  'pyproject.toml',
  'package.json',
  'go.mod',
  'Cargo.toml',
  'Makefile',
  '.project-root',
}

local ignore_filetypes = {
  dashboard = true,
  lazy = true,
  mason = true,
  ['neo-tree'] = true,
  ['lazygit'] = true,
}

local function dirname(path)
  return vim.fs.dirname(path)
end

local function find_root(startpath)
  if not startpath or startpath == '' then
    return nil
  end

  local root = vim.fs.find(patterns, { upward = true, path = startpath })[1]
  if root then
    local dir = dirname(root)
    if dir and dir ~= '' then
      return dir
    end
  end
  return startpath
end

function M.setup()
  local augroup = vim.api.nvim_create_augroup('AutoProjectRoot', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    group = augroup,
    callback = function(args)
      local buf = args.buf
      if vim.bo[buf].buftype ~= '' then
        return
      end

      local ft = vim.bo[buf].filetype
      if ignore_filetypes[ft] then
        return
      end

      local path = vim.api.nvim_buf_get_name(buf)
      if path == '' then
        return
      end

      local file_dir = dirname(path)
      if not file_dir or file_dir == '' then
        return
      end

      local root = find_root(file_dir)
      if root and root ~= '' then
        local normalized = vim.fs.normalize(root)
        if normalized ~= '' and normalized ~= vim.loop.cwd() then
          pcall(vim.fn.chdir, normalized)
        end
      end
    end,
  })
end

return M
