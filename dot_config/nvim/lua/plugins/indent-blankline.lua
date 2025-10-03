-- Indent blankline configuration
-- Adds indentation guides to Neovim using virtual text

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    -- Basic configuration
    indent = {
      char = "│", -- Character used for indentation guides
      tab_char = "│", -- Character used for tab indentation
    },
    scope = {
      enabled = true, -- Enable scope highlighting (requires treesitter)
      char = "│", -- Character used for scope guides
      show_start = true, -- Show start of scope
      show_end = true, -- Show end of scope
      show_exact_scope = false, -- Show exact scope boundaries
      injected_languages = true, -- Show scope for injected languages
      -- highlight = "IblScopeChar", -- Use default highlight group
    },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
  end,
}