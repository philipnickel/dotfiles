-- Leader keys
vim.g.maplocalleader = "-"

-- Boot LazyVim
require("config.lazy")

-- Neovide-specific config (only runs when inside Neovide)
if vim.g.neovide then
  -- Visuals: transparency + macOS blur/vibrancy
  -- Use 'neovide_transparency' (current) instead of the old 'opacity' knobs.
  vim.g.neovide_opacity = 0.70         -- 0.0 transparent .. 1.0 opaque
  vim.g.neovide_window_blurred = true       -- macOS background blur/vibrancy
  vim.g.neovide_show_border = false         -- hide border for frameless look

  -- (Optional) If you use floating windows heavily and want extra blur:
  -- vim.g.neovide_floating_blur_amount_x = 60
  -- vim.g.neovide_floating_blur_amount_y = 60

  -- Make ⌘ (Command) behave as “logo” modifier in Neovide
  vim.g.neovide_input_use_logo = true

  -- macOS-like clipboard shortcuts:
  local opts = { noremap = true, silent = true }

  -- Normal mode: ⌘V = paste from system clipboard
  vim.keymap.set("n", "<D-v>", '"+p', opts)

  -- Visual mode: ⌘C/⌘X copy/cut to system clipboard
  vim.keymap.set("v", "<D-c>", '"+y', opts)
  vim.keymap.set("v", "<D-x>", '"+d', opts)

  -- Insert & Cmdline mode: ⌘V = paste from system clipboard
  vim.keymap.set({ "i", "c" }, "<D-v>", "<C-r>+", opts)

  -- Terminal mode: ⌘V paste safely (exit to normal, paste, re-enter insert)
  vim.keymap.set("t", "<D-v>", function()
    local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>\"+pi", true, false, true)
    vim.api.nvim_feedkeys(keys, "n", true)
  end, opts)
end
