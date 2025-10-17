local M = {}

function M.check()
  local ok_lazy, lazy = pcall(require, "lazy")
  if ok_lazy and lazy then
    lazy.load({ plugins = { "which-key.nvim" } })
  end

  local ok, health = pcall(require, "which-key.health")
  if not ok then
    vim.health.error("could not load which-key.health: " .. health)
    return
  end

  health.check()
end

return M
