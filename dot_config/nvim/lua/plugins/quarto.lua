-- Quarto support configuration (following official maintainer's setup)

return {
  { -- Quarto nvim main plugin
    'quarto-dev/quarto-nvim',
    dev = false,
    opts = {
      lspFeatures = {
        enabled = true,
        chunks = 'curly',
      },
      codeRunner = {
        enabled = false,
      },
    },
    dependencies = {
      'jmbuhr/otter.nvim',
    },
  },

  { -- automatically convert ipynb files to quarto documents
    'GCBallesteros/jupytext.nvim',
    opts = {
      custom_language_formatting = {
        python = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto',
        },
        r = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto',
        },
        julia = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto',
        },
      },
    },
  },
}
