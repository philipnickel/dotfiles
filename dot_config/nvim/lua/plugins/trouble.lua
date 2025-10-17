-- Trouble.nvim configuration for diagnostics and references

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({
      -- Auto-open/close trouble windows
      auto_open = false,
      auto_close = false,
      auto_preview = true,
      auto_fold = false,
      
      -- Extra icons
      use_diagnostic_signs = true,
      
      -- Action keys
      action_keys = {
        -- Close the list
        close = "q",
        -- Cancel the preview and get back to your last window / buffer / cursor
        cancel = "<esc>",
        -- Refresh the list
        refresh = "r",
        -- Jump to the diagnostic or open / close folds
        jump = { "<cr>", "<tab>" },
        -- Open the diagnostic in a floating window
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" },
        -- Jump to the diagnostic and close the list
        jump_close = { "o" },
        -- Toggle auto preview
        toggle_mode = "m",
        -- Toggle auto fold
        toggle_preview = "P",
        -- Preview the diagnostic
        hover = "K",
        -- Close folds
        close_folds = { "zM", "zc" },
        -- Open folds
        open_folds = { "zR", "zo" },
        -- Toggle fold
        toggle_fold = { "zA", "za" },
        -- Previous item
        previous = "k",
        -- Next item
        next = "j"
      },
      
      -- Window configuration
      win = {
        type = "split",
        position = "right", -- position of the list can be: bottom, top, left, right
        width = 50, -- width of the list when position is left or right
        height = 8, -- smaller height to fit below aerial
        zindex = 1, -- stack priority of the list window
        border = "single", -- border style of the list window
        padding = 1, -- padding of the list window
        winblend = 0, -- window blend value
        indent_lines = true, -- add an indent guide below the fold icons
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        signs = {
          -- icons / text used for a diagnostic
          error = "",
          warning = "",
          hint = "",
          information = "",
          other = "",
        },
      },
      
      -- Preview configuration
      preview = {
        type = "split",
        relative = "editor",
        border = "single",
        title = "Preview",
        zindex = 1,
        position = { 0, 0 },
        size = { width = 0.3, height = 0.3 },
        winblend = 0,
      },
      
      -- Fold configuration
      fold = {
        auto = true,
        fold_closed = "",
        fold_open = "",
        indent = 1,
      },
      
      -- Group configuration
      groups = {
        -- group by filetype
        filetype = true,
        -- group by severity
        severity = true,
        -- group by severity and filetype
        severity_filetype = true,
        -- group by severity and filetype and then by filename
        severity_filetype_filename = true,
      },
      
      -- Filter configuration
      filter = {
        -- Current buffer
        buf = 0,
        -- Current filetype
        ftype = {},
        -- Current line
        line = 0,
        -- Current column
        col = 0,
        -- Current word
        word = "",
        -- Current word under cursor
        cursor = false,
        -- Current quickfix list
        qflist = false,
        -- Current location list
        loclist = false,
        -- Current buffer diagnostics
        diagnostics = true,
        -- Current buffer references
        references = true,
        -- Current buffer implementations
        implementations = true,
        -- Current buffer definitions
        definitions = true,
        -- Current buffer type definitions
        type_definitions = true,
        -- Current buffer incoming calls
        incoming_calls = true,
        -- Current buffer outgoing calls
        outgoing_calls = true,
      },
      
      -- Format configuration
      format = {
        -- Format function for diagnostics
        format = function(diagnostic)
          return string.format("%s: %s", diagnostic.source, diagnostic.message)
        end,
        -- Format function for references
        format_references = function(reference)
          return string.format("%s:%s", reference.filename, reference.lnum)
        end,
      },
      
      -- Sort configuration
      sort = {
        -- Sort by severity
        severity = true,
        -- Sort by filename
        filename = true,
        -- Sort by line number
        lnum = true,
      },
    })
  end,
}