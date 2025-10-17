-- Unified navigation configuration combining Trouble and Aerial

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")

    -- Define unified navigation groups
    wk.register({
      -- Unified Navigation (Aerial + Trouble) group
      n = {
        name = "Navigation (Aerial + Trouble)",
        -- Aerial commands
        a = { "<cmd>AerialToggle!<cr>", "Toggle aerial outline" },
        o = { "<cmd>AerialOpen<cr>", "Open aerial outline" },
        c = { "<cmd>AerialClose<cr>", "Close aerial outline" },
        n = { "<cmd>AerialNavToggle<cr>", "Toggle aerial navigation" },
        i = { "<cmd>AerialInfo<cr>", "Show aerial info" },
        s = { "<cmd>Telescope aerial<cr>", "Telescope aerial symbols" },
        -- Trouble diagnostics
        x = { "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)" },
        X = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics (Trouble)" },
        L = { "<cmd>Trouble loclist toggle<cr>", "Location List (Trouble)" },
        Q = { "<cmd>Trouble qflist toggle<cr>", "Quickfix List (Trouble)" },
        -- Trouble LSP
        R = { "<cmd>Trouble lsp_references toggle<cr>", "LSP References (Trouble)" },
        D = { "<cmd>Trouble lsp_definitions toggle<cr>", "LSP Definitions (Trouble)" },
        I = { "<cmd>Trouble lsp_implementations toggle<cr>", "LSP Implementations (Trouble)" },
        T = { "<cmd>Trouble lsp_type_definitions toggle<cr>", "LSP Type Definitions (Trouble)" },
        O = { "<cmd>Trouble lsp_outgoing_calls toggle<cr>", "LSP Outgoing Calls (Trouble)" },
        C = { "<cmd>Trouble lsp_incoming_calls toggle<cr>", "LSP Incoming Calls (Trouble)" },
        -- Combined symbols
        S = { "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols (Trouble)" },
        l = { "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "LSP Definitions / references / ... (Trouble)" },
      },

      -- Terminal group (existing)
      c = {
        name = "Terminal",
        i = { function()
          if _G.python_term then
            _G.python_term:toggle()
          end
        end, "Open Python terminal" },
        r = { function()
          if _G.r_term then
            _G.r_term:toggle()
          end
        end, "Open R terminal" },
        j = { function()
          if _G.julia_term then
            _G.julia_term:toggle()
          end
        end, "Open Julia terminal" },
        n = { function()
          if _G.shell_term then
            _G.shell_term:toggle()
          end
        end, "Open Shell terminal" },
        f = { function()
          if _G.float_term then
            _G.float_term:toggle()
          end
        end, "Open floating terminal" },
        c = { function()
          require('toggleterm').close_all_terminals()
        end, "Close all terminals" },
      },

      -- Symbol navigation (Aerial)
      ["]"] = {
        name = "Next Symbol",
        s = { "<cmd>AerialNext<cr>", "Next symbol" },
        S = { "<cmd>AerialNextUp<cr>", "Next symbol up" },
      },
      ["["] = {
        name = "Previous Symbol", 
        s = { "<cmd>AerialPrev<cr>", "Previous symbol" },
        S = { "<cmd>AerialPrevUp<cr>", "Previous symbol up" },
      },

      -- LSP group (existing)
      l = {
        name = "LSP",
        f = { vim.diagnostic.open_float, "Open floating diagnostic" },
        d = { vim.diagnostic.goto_next, "Next diagnostic" },
        p = { vim.diagnostic.goto_prev, "Previous diagnostic" },
        a = { vim.lsp.buf.code_action, "Code action" },
        r = { vim.lsp.buf.rename, "Rename symbol" },
        h = { vim.lsp.buf.hover, "Hover documentation" },
        s = { vim.lsp.buf.signature_help, "Signature help" },
        g = { vim.lsp.buf.definition, "Go to definition" },
        t = { vim.lsp.buf.type_definition, "Go to type definition" },
        i = { vim.lsp.buf.implementation, "Go to implementation" },
        R = { vim.lsp.buf.references, "References" },
      },

      -- Terminal group (existing)
      c = {
        name = "Terminal",
        i = { function()
          if _G.python_term then
            _G.python_term:toggle()
          end
        end, "Open Python terminal" },
        r = { function()
          if _G.r_term then
            _G.r_term:toggle()
          end
        end, "Open R terminal" },
        j = { function()
          if _G.julia_term then
            _G.julia_term:toggle()
          end
        end, "Open Julia terminal" },
        n = { function()
          if _G.shell_term then
            _G.shell_term:toggle()
          end
        end, "Open Shell terminal" },
        f = { function()
          if _G.float_term then
            _G.float_term:toggle()
          end
        end, "Open floating terminal" },
        c = { function()
          require('toggleterm').close_all_terminals()
        end, "Close all terminals" },
      },

      -- Run group (existing)
      r = {
        name = "Run Code",
        r = { function()
          if vim.bo.filetype == 'python' then
            -- Use toggleterm for Python execution
            local mode = vim.fn.mode()
            if mode == 'v' or mode == 'V' or mode == '\22' then
              -- We're in visual mode, execute the selection
              local start_line = vim.fn.getpos("'<")[2]
              local end_line = vim.fn.getpos("'>")[2]
              local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
              local text = table.concat(lines, '\n')
              if _G.python_term then
                _G.python_term:send(text)
              end
            else
              -- Not in visual mode, try to detect current cell
              local current_line = vim.fn.line('.')
              local cell_start = vim.fn.search([[^#\s*%%]], 'bcnW')
              local cell_end = vim.fn.search([[^#\s*%%]], 'nW')
              
              if cell_start > 0 then
                local start_line = cell_start
                local end_line = cell_end > 0 and cell_end - 1 or vim.fn.line('$')
                local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
                local text = table.concat(lines, '\n')
                if _G.python_term then
                  _G.python_term:send(text)
                end
              else
                -- No cell markers, execute current line
                local line = vim.fn.getline('.')
                if _G.python_term then
                  _G.python_term:send(line)
                end
              end
            end
          else
            local ok, runner = pcall(require, 'quarto.runner')
            if ok then
              runner.run_cell()
            end
          end
        end, "Run cell" },
        a = { function()
          if vim.bo.filetype == 'python' then
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            if _G.python_term then
              _G.python_term:send(table.concat(lines, '\n'))
            end
          else
            local ok, runner = pcall(require, 'quarto.runner')
            if ok then
              runner.run_all(true)
            end
          end
        end, "Run all cells" },
        l = { function()
          if vim.bo.filetype == 'python' then
            local line = vim.fn.getline('.')
            if _G.python_term then
              _G.python_term:send(line)
            end
          else
            local ok, runner = pcall(require, 'quarto.runner')
            if ok then
              runner.run_line()
            end
          end
        end, "Run line" },
        u = { function()
          if vim.bo.filetype == 'python' then
            local current_line = vim.fn.line('.')
            local cell_start = vim.fn.search([[^#\s*%%]], 'bcnW')
            
            if cell_start > 0 then
              local end_line = vim.fn.search([[^#\s*%%]], 'nW')
              end_line = end_line > 0 and end_line - 1 or vim.fn.line('$')
              local lines = vim.api.nvim_buf_get_lines(0, 1, end_line, false)
              if _G.python_term then
                _G.python_term:send(table.concat(lines, '\n'))
              end
            else
              local lines = vim.api.nvim_buf_get_lines(0, 1, current_line, false)
              if _G.python_term then
                _G.python_term:send(table.concat(lines, '\n'))
              end
            end
          else
            local ok, runner = pcall(require, 'quarto.runner')
            if ok then
              runner.run_above()
            end
          end
        end, "Run cell and above" },
        d = { function()
          if vim.bo.filetype == 'python' then
            local current_line = vim.fn.line('.')
            local cell_start = vim.fn.search([[^#\s*%%]], 'bcnW')
            
            if cell_start > 0 then
              local lines = vim.api.nvim_buf_get_lines(0, cell_start, -1, false)
              if _G.python_term then
                _G.python_term:send(table.concat(lines, '\n'))
              end
            else
              local lines = vim.api.nvim_buf_get_lines(0, current_line, -1, false)
              if _G.python_term then
                _G.python_term:send(table.concat(lines, '\n'))
              end
            end
          else
            local ok, runner = pcall(require, 'quarto.runner')
            if ok then
              runner.run_below()
            end
          end
        end, "Run cell and below" },
        j = { function()
          local cell_end = vim.fn.search([[^#\s*%%]], 'nW')
          if cell_end > 0 then
            vim.fn.cursor(cell_end, 1)
          end
        end, "Next cell" },
        k = { function()
          local cell_start = vim.fn.search([[^#\s*%%]], 'bcnW')
          if cell_start > 0 then
            vim.fn.cursor(cell_start, 1)
          end
        end, "Previous cell" },
        x = { function()
          local cell_start = vim.fn.search([[^#\s*%%]], 'bcnW')
          local cell_end = vim.fn.search([[^#\s*%%]], 'nW')
          
          if cell_start > 0 then
            local start_line = cell_start
            local end_line = cell_end > 0 and cell_end - 1 or vim.fn.line('$')
            vim.api.nvim_buf_set_lines(0, start_line, end_line, false, {})
          end
        end, "Delete cell" },
        s = { function()
          local cell_start = vim.fn.search([[^#\s*%%]], 'bcnW')
          local cell_end = vim.fn.search([[^#\s*%%]], 'nW')
          
          if cell_start > 0 then
            local start_line = cell_start
            local end_line = cell_end > 0 and cell_end - 1 or vim.fn.line('$')
            
            vim.fn.cursor(start_line, 1)
            vim.cmd('normal! V')
            vim.fn.cursor(end_line, 1)
            vim.cmd('normal! $')
            
            vim.notify('Cell selected - use <leader>rr to execute', vim.log.levels.INFO)
          else
            vim.notify('No cell found at current position', vim.log.levels.WARN)
          end
        end, "Select current cell" },
      },
    }, { prefix = "<leader>" })

    -- Visual mode keymaps
    wk.register({
      r = { function()
        local start_line = vim.fn.getpos("'<")[2]
        local end_line = vim.fn.getpos("'>")[2]
        local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
        local text = table.concat(lines, '\n')
        if _G.python_term then
          _G.python_term:send(text)
        end
      end, "Run selection" },
    }, { prefix = "<leader>", mode = "v" })

    -- Setup which-key
    wk.setup({
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = true,
          g = true,
        },
      },
      operators = { gc = "Comments" },
      key_labels = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      popup_mappings = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      window = {
        border = "rounded",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 2, 2, 2, 2 },
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      ignore_missing = true,
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
      show_help = true,
      triggers = "auto",
      triggers_blacklist = {
        i = { "j", "k" },
        v = { "j", "k" },
      },
    })
  end,
}