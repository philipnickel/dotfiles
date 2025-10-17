-- Jupyter-vim configuration for qtconsole integration

return {
  "jupyter-vim/jupyter-vim",
  ft = { "python", "julia", "r" },
  dependencies = {
    "goerz/jupytext.vim",
  },
  config = function()
    -- Configure jupyter-vim
    vim.g.jupyter_mapkeys = 0  -- Disable default keymaps, we'll set our own
    
    -- Set up keymaps for jupyter-vim
    vim.keymap.set("n", "<leader>jc", "<cmd>JupyterConnect<cr>", { desc = "Jupyter: connect to kernel" })
    vim.keymap.set("n", "<leader>jd", "<cmd>JupyterDisconnect<cr>", { desc = "Jupyter: disconnect from kernel" })
    vim.keymap.set("n", "<leader>jk", "<cmd>JupyterKernel<cr>", { desc = "Jupyter: select kernel" })
    
    -- Cell execution keymaps
    vim.keymap.set("n", "<leader>jx", "<cmd>JupyterSendCell<cr>", { desc = "Jupyter: send current cell" })
    vim.keymap.set("n", "<leader>ja", "<cmd>JupyterSendAll<cr>", { desc = "Jupyter: send all cells" })
    vim.keymap.set("n", "<leader>jl", "<cmd>JupyterSendLine<cr>", { desc = "Jupyter: send current line" })
    
    -- Visual selection keymaps
    vim.keymap.set("v", "<leader>jx", "<cmd>JupyterSendRange<cr>", { desc = "Jupyter: send selection" })
    vim.keymap.set("v", "<leader>je", "<cmd>JupyterSendRange<cr>", { desc = "Jupyter: send selection" })
    
    -- Cell navigation
    vim.keymap.set("n", "<leader>jn", "<cmd>JupyterNextCell<cr>", { desc = "Jupyter: next cell" })
    vim.keymap.set("n", "<leader>jp", "<cmd>JupyterPrevCell<cr>", { desc = "Jupyter: previous cell" })
    
    -- Cell management
    vim.keymap.set("n", "<leader>ji", "<cmd>JupyterInsertCell<cr>", { desc = "Jupyter: insert cell" })
    vim.keymap.set("n", "<leader>jd", "<cmd>JupyterDeleteCell<cr>", { desc = "Jupyter: delete cell" })
    vim.keymap.set("n", "<leader>js", "<cmd>JupyterSplitCell<cr>", { desc = "Jupyter: split cell" })
    
    -- Variable inspection
    vim.keymap.set("n", "<leader>jv", "<cmd>JupyterInspect<cr>", { desc = "Jupyter: inspect variable" })
    vim.keymap.set("n", "<leader>jh", "<cmd>JupyterHelp<cr>", { desc = "Jupyter: help" })
    
    -- Clear output
    vim.keymap.set("n", "<leader>jC", "<cmd>JupyterClear<cr>", { desc = "Jupyter: clear output" })
  end,
}