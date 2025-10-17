-- LSP configuration

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    -- Setup Mason
    mason.setup({
      ui = {
        border = "rounded",
      },
      -- Prevent auto-installation of problematic packages
      registries = {
        "github:mason-org/mason-registry",
      },
    })

    -- Setup Mason LSPConfig
    mason_lspconfig.setup({
      ensure_installed = {
        "lua_ls",
        "pyright",
        "texlab",
        "r_language_server",
        "julials",
        "bashls",
      },
      -- Explicitly exclude stylua from LSP configuration
      handlers = {
        -- Default handler for all servers
        function(server_name)
          if server_name == "stylua" then
            -- Skip stylua as it's not an LSP server
            return
          end
          require("lspconfig")[server_name].setup({})
        end,
      },
    })

    -- Global LSP keymaps
    vim.keymap.set("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Open floating diagnostic" })
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
    vim.keymap.set("n", "<leader>lp", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
    vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "Hover documentation" })
    vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, { desc = "Signature help" })
    vim.keymap.set("n", "<leader>lg", vim.lsp.buf.definition, { desc = "Go to definition" })
    vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
    vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "Go to implementation" })
    vim.keymap.set("n", "<leader>lR", vim.lsp.buf.references, { desc = "References" })
  end,
}