-- Avante.nvim - AI coding assistant similar to Cursor

return {
  "yetone/avante.nvim",
  build = vim.fn.has("win32") ~= 0
    and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  event = "VeryLazy",
  version = false,
  opts = {
    instructions_file = "avante.md",
    provider = "copilot",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "stevearc/dressing.nvim",
    {
      "HakonHarnes/img-clip.nvim",
      optional = true,
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      optional = true,
    },
    {
      "ibhagwan/fzf-lua",
      optional = true,
    },
    {
      "nvim-mini/mini.pick",
      optional = true,
    },
  },
  config = function(_, opts)
    local ok, avante = pcall(require, "avante")
    if not ok then
      vim.notify("avante.nvim not available", vim.log.levels.ERROR)
      return
    end
    avante.setup(opts)
  end,
}
