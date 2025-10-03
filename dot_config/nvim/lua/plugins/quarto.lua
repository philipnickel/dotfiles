-- Quarto support configuration

return {
  "quarto-dev/quarto-nvim",
  ft = { "quarto", "markdown" },
  dependencies = {
    "jmbuhr/otter.nvim",
  },
  opts = {
    lspFeatures = {
      enabled = true,
      chunks = "curly",
      languages = { "r", "python", "julia", "bash", "lua", "html" },
      diagnostics = {
        enabled = true,
        triggers = { "BufWritePost" },
      },
      completion = {
        enabled = true,
      },
    },
    codeRunner = {
      enabled = true,
      default_method = "toggleterm",
    },
  },
}