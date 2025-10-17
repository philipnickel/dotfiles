-- Noice.nvim configuration for better UI

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      config = function()
        local ok, notify = pcall(require, 'notify')
        if not ok then
          return
        end
        notify.setup({
          background_colour = '#2E3440',
          stages = 'fade',
          timeout = 2000,
        })
        vim.notify = notify
      end,
    },
  },
  config = function()
    local ok, noice = pcall(require, 'noice')
    if not ok then
      return
    end

    noice.setup({
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
      views = {
        notify = {
          backend = 'notify',
        },
      },
    })
  end,
}