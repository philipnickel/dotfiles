-- Which-key configuration with modern layout
-- Provides keymap discovery and help

return {
  "folke/which-key.nvim",
  lazy = false,
  dependencies = {
    "echasnovski/mini.icons",
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- Use modern layout
    preset = "modern",
    
    -- Delay before showing popup
    delay = function(ctx)
      return ctx.plugin and 0 or 200
    end,
    
    -- Filter mappings (show all for now)
    filter = function(mapping)
      return true
    end,
    
    -- Show warnings for mapping issues
    notify = true,
    
    -- Auto triggers for all modes
    triggers = {
      { "<auto>", mode = "nxso" },
    },
    
    -- Defer for visual mode and some operators
    defer = function(ctx)
      return ctx.mode == "V" or ctx.mode == "<C-V>"
    end,
    
    -- Plugin configurations
    plugins = {
      marks = true, -- shows marks on ' and `
      registers = true, -- shows registers on " in NORMAL or <C-r> in INSERT
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true, -- d, y, etc.
        motions = true, -- hjkl, etc.
        text_objects = true, -- aw, iw, etc.
        windows = true, -- <c-w>
        nav = true, -- misc window bindings
        z = true, -- folds, spelling, etc.
        g = true, -- g bindings
      },
    },
    
    -- Window configuration
    win = {
      no_overlap = true,
      padding = { 1, 2 },
      title = true,
      title_pos = "center",
      zindex = 1000,
      wo = {
        -- winblend = 10, -- transparency if desired
      },
    },
    
    -- Layout configuration
    layout = {
      width = { min = 20 },
      spacing = 3,
    },
    
    -- Scroll keys
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    
    -- Sorting
    sort = { "local", "order", "group", "alphanum", "mod" },
    
    -- Expand groups when <= 0 mappings (show all)
    expand = 0,
    
    -- Icon configuration
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
      ellipsis = "…",
      mappings = true,
      colors = true,
      keys = {
        Up = "↑",
        Down = "↓",
        Left = "←",
        Right = "→",
        C = "⌃",
        M = "⌘",
        D = "⌫",
        S = "⇧",
        CR = "↵",
        Esc = "⎋",
        Space = "␣",
        Tab = "⇥",
      },
    },
    
    -- Show help and keys
    show_help = true,
    show_keys = true,
    
    -- Disable for certain file types
    disable = {
      ft = {},
      bt = {},
    },
    
    -- Debug mode
    debug = false,
    
    -- Custom keymap groups and descriptions
    spec = {
      -- File operations
      { "<leader>f", group = "File", icon = "📁" },
      { "<leader>ff", desc = "Find files", icon = "🔍" },
      { "<leader>fg", desc = "Live grep", icon = "🔍" },
      { "<leader>fb", desc = "Find buffers", icon = "📄" },
      { "<leader>fh", desc = "Help tags", icon = "❓" },
      { "<leader>fr", desc = "Recent files", icon = "🕒" },
      { "<leader>fc", desc = "Commands", icon = "⚡" },

      -- Buffer operations
      { "<leader>b", group = "Buffer", icon = "📄" },
      { "<leader>x", desc = "Close buffer", icon = "❌" },

      -- Chezmoi operations
      -- Git operations
      { "<leader>g", group = "Git", icon = "" },
      { "<leader>gg", desc = "LazyGit", icon = "" },
      { "<leader>gG", desc = "LazyGit Repos", icon = "" },
      { "<leader>gs", desc = "Stage hunk", icon = "✅" },
      { "<leader>gr", desc = "Reset hunk", icon = "↩️" },
      { "<leader>gS", desc = "Stage buffer", icon = "📄" },
      { "<leader>gu", desc = "Undo stage hunk", icon = "↶" },
      { "<leader>gR", desc = "Reset buffer", icon = "🔄" },
      { "<leader>gp", desc = "Preview hunk", icon = "👁️" },
      { "<leader>gb", desc = "Blame line", icon = "👤" },
      { "<leader>gtb", desc = "Toggle blame", icon = "🔄" },
      { "<leader>gd", desc = "Diff this", icon = "📊" },
      { "<leader>gD", desc = "Diff this ~", icon = "📊" },
      { "<leader>gtd", desc = "Toggle deleted", icon = "🗑️" },

      { "<leader>C", group = "Chezmoi", icon = "🏠" },
      { "<leader>Cf", desc = "Find managed file", icon = "🔍" },
      { "<leader>Ce", desc = "Edit target", icon = "✏️" },
      { "<leader>Cl", desc = "List files", icon = "📋" },

      -- Avante AI operations
      { "<leader>a", group = "Avante", icon = "🤖" },
      { "<leader>aa", desc = "Toggle sidebar", icon = "🪄" },
      { "<leader>an", desc = "Ask question", icon = "❓" },
      { "<leader>ar", desc = "Refresh", icon = "🔄" },
      { "<leader>af", desc = "Focus sidebar", icon = "🎯" },
      { "<leader>as", desc = "Stop request", icon = "⏹️" },
      { "<leader>a?", desc = "Select model", icon = "⚙️" },

      -- LaTeX operations
      { "<leader>l", group = "LaTeX", icon = "📝" },
      { "<leader>ll", desc = "Compile", icon = "⚙️" },
      { "<leader>lv", desc = "View PDF", icon = "👁️" },
      { "<leader>lk", desc = "Stop compilation", icon = "⏹️" },
      { "<leader>le", desc = "Show errors", icon = "❌" },
      { "<leader>lo", desc = "Show output", icon = "📤" },
      { "<leader>lS", desc = "Status", icon = "📊" },
      { "<leader>lG", desc = "Status all", icon = "📊" },
      { "<leader>lc", desc = "Clean", icon = "🧹" },
      { "<leader>lC", desc = "Clean!", icon = "🧹" },
      { "<leader>lm", desc = "Imaps list", icon = "📋" },
      { "<leader>lx", desc = "Reload", icon = "🔄" },
      { "<leader>ls", desc = "Toggle main", icon = "🔄" },

      -- Run/Execute operations (Iron)
      { "<leader>r", group = "Run", icon = "▶️" },
      { "<leader>rr", "<cmd>IronRepl<cr>", desc = "Toggle REPL", icon = "🔄" },
      { "<leader>rR", "<cmd>IronRestart<cr>", desc = "Restart REPL", icon = "🔄" },
      { "<leader>rs", desc = "Send motion", icon = "📤" },
      { "<leader>rv", desc = "Send visual selection", icon = "📤" },
      { "<leader>rf", desc = "Send entire file", icon = "📄" },
      { "<leader>rl", desc = "Send current line", icon = "➡️" },
      { "<leader>rp", desc = "Send paragraph", icon = "📝" },
      { "<leader>ru", desc = "Send until cursor", icon = "⬆️" },
      { "<leader>rb", desc = "Send code block (# %%)", icon = "📦" },
      { "<leader>rn", desc = "Send code block & move", icon = "📦➡️" },
      { "<leader>rm", desc = "Send mark", icon = "📍" },
      { "<leader>rc", desc = "Clear REPL", icon = "🧹" },
      { "<leader>rF", "<cmd>IronFocus<cr>", desc = "Focus REPL", icon = "🎯" },
      { "<leader>rh", "<cmd>IronHide<cr>", desc = "Hide REPL", icon = "👁️" },

      -- Otter operations
      { "<leader>o", group = "Otter", icon = "🦦" },
      { "<leader>oa", desc = "Activate", icon = "✅" },
      { "<leader>od", desc = "Deactivate", icon = "❌" },
      { "<leader>or", desc = "R chunk", icon = "📊" },
      { "<leader>op", desc = "Python chunk", icon = "🐍" },
      { "<leader>oj", desc = "Julia chunk", icon = "🔢" },
      { "<leader>ob", desc = "Bash chunk", icon = "💻" },
      { "<leader>ol", desc = "Lua chunk", icon = "🌙" },


      -- Quarto operations
      { "<leader>q", group = "Quarto", icon = "📚" },
      { "<leader>qa", desc = "Activate", icon = "✅" },
      { "<leader>qp", desc = "HTML Preview", icon = "👁️" },
      { "<leader>qq", desc = "Close Preview", icon = "❌" },
      { "<leader>qh", desc = "Help", icon = "❓" },
      { "<leader>qm", desc = "Toggle Math", icon = "🧮" },
      { "<leader>qc", desc = "Clean output files", icon = "🧹" },

      -- Snippet operations
      { "<leader>s", group = "Snippets", icon = "📝" },
      { "<leader>se", desc = "Edit snippets", icon = "✏️" },
      { "<leader>sr", desc = "Reload snippets", icon = "🔄" },
      { "<leader>ss", desc = "Show snippet documentation", icon = "📖" },
      { "<leader>sg", desc = "Smart features guide", icon = "📖" },
      { "<leader>sy", desc = "SymPy evaluation guide", icon = "📖" },
      { "<leader>sp", desc = "SymPy guide", icon = "📖" },
      { "<leader>sm", desc = "Toggle VimTeX mappings", icon = "🔄" },

      -- Preview operations
      { "<leader>p", group = "Preview", icon = "👁️" },
      { "<leader>pp", desc = "Toggle Render Markdown", icon = "📄" },

      -- Navigation operations (Aerial + Trouble)
      { "<leader>n", group = "Navigation", icon = "🧭" },
      { "<leader>na", "<cmd>AerialToggle!<cr>", desc = "Toggle aerial tree", icon = "📋" },
      { "<leader>nn", "<cmd>AerialNavOpen<cr>", desc = "Open aerial navigation", icon = "🧭" },
      { "<leader>nt", function()
        vim.cmd("AerialOpen!")
        vim.cmd("Trouble symbols toggle focus=false win.position=right")
      end, desc = "Open both trees (Aerial + Trouble)", icon = "🌳" },
      { "<leader>nx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)", icon = "⚠️" },
      { "<leader>nX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)", icon = "📄" },
      { "<leader>nL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)", icon = "📍" },
      { "<leader>nQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)", icon = "🔧" },
      { "<leader>nR", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP References (Trouble)", icon = "🔗" },
      { "<leader>nD", "<cmd>Trouble lsp_definitions toggle<cr>", desc = "LSP Definitions (Trouble)", icon = "📖" },
      { "<leader>nI", "<cmd>Trouble lsp_implementations toggle<cr>", desc = "LSP Implementations (Trouble)", icon = "⚡" },
      { "<leader>nT", "<cmd>Trouble lsp_type_definitions toggle<cr>", desc = "LSP Type Definitions (Trouble)", icon = "🏷️" },
      { "<leader>nO", "<cmd>Trouble lsp_outgoing_calls toggle<cr>", desc = "LSP Outgoing Calls (Trouble)", icon = "📤" },
      { "<leader>nC", "<cmd>Trouble lsp_incoming_calls toggle<cr>", desc = "LSP Incoming Calls (Trouble)", icon = "📥" },
      { "<leader>nS", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)", icon = "🔣" },

      -- Utility operations
      { "<leader>u", desc = "Toggle undo tree", icon = "🌳" },
      { "<leader>pv", desc = "Open file explorer", icon = "📁" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
