-- LaTeX snippets configuration

return {
  "iurimateus/luasnip-latex-snippets.nvim",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "lervag/vimtex", -- Required for math mode detection
  },
  config = function()
    local latex_snippets = require("luasnip-latex-snippets")
    latex_snippets.setup({
      use_treesitter = false, -- Use vimtex for math mode detection
      allow_on_markdown = true, -- Allow snippets in markdown files
    })
  end,
}