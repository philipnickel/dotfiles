return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    {
      "<leader>gG",
      function()
        local ok, telescope = pcall(require, 'telescope')
        if ok and telescope.extensions and telescope.extensions.lazygit then
          telescope.extensions.lazygit.lazygit()
        else
          vim.notify('Telescope lazygit extension not available', vim.log.levels.WARN)
        end
      end,
      desc = "LazyGit Repos",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local ok, telescope = pcall(require, 'telescope')
    if ok then
      pcall(telescope.load_extension, 'lazygit')
    end

    local augroup = vim.api.nvim_create_augroup('LazyGitTrackProjects', { clear = true })
    vim.api.nvim_create_autocmd('BufEnter', {
      group = augroup,
      callback = function()
        pcall(function()
          require('lazygit.utils').project_root_dir()
        end)
      end,
    })
  end,
}
