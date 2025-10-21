return {
  "benomahony/uv.nvim",
  -- Optional filetype to lazy load when you open a python file
  -- ft = { python }
  -- Optional dependency, but recommended:
  -- dependencies = {
  --   "folke/snacks.nvim"
  -- or
  --   "nvim-telescope/telescope.nvim"
  -- },
  dependencies = {
    {
      "folke/which-key.nvim",
      opts = function(_, opts)
        opts.spec = opts.spec or {}
        table.insert(opts.spec, {
          mode = { "n", "v" },
          { "<leader>U", group = "uv" },
          { "<leader>Ur", desc = "UV Run Current File", mode = "n" },
          { "<leader>Us", desc = "UV Run Selection", mode = "v" },
          { "<leader>Uf", desc = "UV Run Function", mode = "n" },
          { "<leader>Ue", desc = "UV Environment Picker", mode = "n" },
          { "<leader>Ui", desc = "UV Init Project", mode = "n" },
          { "<leader>Ua", desc = "UV Add Package", mode = "n" },
          { "<leader>Ud", desc = "UV Remove Package", mode = "n" },
          { "<leader>Uc", desc = "UV Sync Packages", mode = "n" },
          { "<leader>UC", desc = "UV Sync All Packages", mode = "n" },
        })
      end,
    },
  },
  opts = {
    picker_integration = true,
    keymaps = {
      prefix = "<leader>U",
    },
  },
}
