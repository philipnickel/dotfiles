-- Jupytext configuration for native # %% cell support

return {
  "goerz/jupytext.vim",
  ft = { "python", "julia", "r" }, -- Remove markdown to avoid conflicts with quarto
  config = function()
    -- Configure jupytext to use percent format for Python files
    vim.g.jupytext_fmt = "py:percent"
    
    -- Enable automatic pairing
    vim.g.jupytext_enable = 1
    
    -- Set default format
    vim.g.jupytext_filetype_map = {
      python = "py:percent",
      julia = "jl:percent", 
      r = "R:percent"
    }
    
    -- Keymaps for jupytext (using different prefixes to avoid conflicts)
    vim.keymap.set("n", "<leader>yt", "<cmd>Jupytext<cr>", { desc = "Jupytext: pair notebook" })
    vim.keymap.set("n", "<leader>ys", "<cmd>JupytextSync<cr>", { desc = "Jupytext: sync notebook" })
    vim.keymap.set("n", "<leader>yu", "<cmd>JupytextUnpair<cr>", { desc = "Jupytext: unpair notebook" })
  end,
}