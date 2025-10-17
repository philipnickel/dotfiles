-- Molten for Jupyter kernel integration

return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  build = ":UpdateRemotePlugins",
  enabled = true,
  dependencies = {
    "3rd/image.nvim",
  },
  init = function()
    -- Set image provider based on environment
    if vim.fn.has('gui_running') == 1 or vim.env.DISPLAY or vim.env.TERM_PROGRAM == 'kitty' then
      vim.g.molten_image_provider = "image.nvim"
    else
      vim.g.molten_image_provider = "none"
    end
    vim.g.molten_auto_open_output = true
    vim.g.molten_auto_open_html_in_browser = true
    vim.g.molten_tick_rate = 200
  end,
  config = function()
    local function molten_init()
      local quarto_cfg = require("quarto.config").config
      quarto_cfg.codeRunner.default_method = "molten"
      vim.cmd([[MoltenInit]])
      vim.g.molten_initialized = true
      vim.print("Molten initialized - using Molten for cell execution")
    end
    local function molten_deinit()
      local quarto_cfg = require("quarto.config").config
      quarto_cfg.codeRunner.default_method = "toggleterm"
      vim.cmd([[MoltenDeinit]])
      vim.g.molten_initialized = false
      vim.print("Molten stopped - using ToggleTerm for cell execution")
    end
    vim.keymap.set("n", "<localleader>mi", molten_init, { silent = true, desc = "Initialize molten" })
    vim.keymap.set("n", "<localleader>md", molten_deinit, { silent = true, desc = "Stop molten" })
    vim.keymap.set("n", "<localleader>mp", ":MoltenImagePopup<CR>", { silent = true, desc = "molten image popup" })
    vim.keymap.set("n", "<localleader>mb", ":MoltenOpenInBrowser<CR>", { silent = true, desc = "molten open in browser" })
    vim.keymap.set("n", "<localleader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "hide output" })
    vim.keymap.set("n", "<localleader>ms", ":noautocmd MoltenEnterOutput<CR>", { silent = true, desc = "show/enter output" })
  end,
}