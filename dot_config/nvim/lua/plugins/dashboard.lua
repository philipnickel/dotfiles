return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local dashboard = require('dashboard')
    dashboard.setup({
      theme = 'hyper',
      config = {
        week_header = {
          enable = false,
        },
        project = {
          enable = true,
          limit = 8,
          icon = ' ',
          action = 'Telescope find_files cwd=',
        },
        mru = {
          enable = true,
          limit = 10,
          icon = ' ',
        },
        shortcut = {
          { desc = 'Find File', group = '@variable', action = 'Telescope find_files', key = 'f' },
          { desc = 'Live Grep', group = '@string', action = 'Telescope live_grep', key = 'g' },
          { desc = 'Chezmoi', group = '@method', action = 'ChezmoiFiles', key = 'c' },
          { desc = 'Lazy', group = '@constant', action = 'Lazy sync', key = 'u' },
          { desc = 'Quit', group = '@macro', action = 'qa', key = 'q' },
        },
        footer = function()
          local stats = require('lazy').stats()
          return { string.format('Loaded %d/%d plugins', stats.loaded, stats.count) }
        end,
      },
    })
    local uv = vim.loop
    local cache_path = vim.fs.joinpath(vim.fn.stdpath('cache'), 'dashboard', 'cache')
    local function record_project(dir)
      if not dir or dir == '' then
        return
      end
      uv.fs_open(cache_path, 'a+', 438, function(err, fd)
        if err then
          return
        end
        uv.fs_fstat(fd, function(err_stat, stat)
          if err_stat then
            uv.fs_close(fd)
            return
          end
          uv.fs_read(fd, stat.size, 0, function(err_read, data)
            if err_read then
              uv.fs_close(fd)
              return
            end
            local list = {}
            if data and #data > 0 then
              local ok, dump = pcall(loadstring, data)
              if ok and type(dump) == 'function' then
                local ok_list, res = pcall(dump)
                if ok_list and type(res) == 'table' then
                  list = res
                end
              else
                -- If there's an error loading the cache, start fresh
                list = {}
              end
            end
            for i = #list, 1, -1 do
              if list[i] == dir then
                table.remove(list, i)
              end
            end
            table.insert(list, dir)
            local limit = 10
            if #list > limit then
              list = vim.list_slice(list, #list - limit + 1, #list)
            end
            local dump = 'return ' .. vim.inspect(list)
            uv.fs_write(fd, dump, 0, function(err_write, _)
              if err_write then
                uv.fs_close(fd)
                return
              end
              uv.fs_ftruncate(fd, #dump, function()
                uv.fs_close(fd)
              end)
            end)
          end)
        end)
      end)
    end

    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = vim.api.nvim_create_augroup('DashboardProjectHistory', { clear = true }),
      callback = function()
        local cwd = vim.loop.cwd()
        if cwd then
          record_project(vim.fs.normalize(cwd))
        end
      end,
    })
  end,
}
