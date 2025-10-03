return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = { "Neotree" },
  opts = {
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      use_libuv_file_watcher = true,
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, source = "filesystem" })
      end,
      desc = "Toggle Neo-tree",
    },
  },
}
