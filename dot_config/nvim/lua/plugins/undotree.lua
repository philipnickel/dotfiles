-- Undotree configuration

return {
  "mbbill/undotree",
  keys = {
    { "<leader>hu", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
  },
  config = function()
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}
