-- Nordic colorscheme configuration

return {
  "AlexvZyl/nordic.nvim",
  priority = 1000,
  lazy = false,
  dependencies = {
    {
      "akinsho/bufferline.nvim",
      version = "*",
      dependencies = "nvim-tree/nvim-web-devicons",
    },
  },
  config = function()
    local frost = {
      sea_green = '#8FBCBB',
      frost_blue = '#88C0D0',
      steel_blue = '#81A1C1',
      deep_blue = '#5E81AC',
    }

    require('nordic').setup({
      transparent = {
        bg = false,
        float = false,
      },
      bold_keywords = true,
      italic_comments = true,
      underline_option = 'none',
      cursorline = {
        theme = 'dark',
        bold = false,
      },
      noice = {
        style = 'classic',
      },
      telescope = {
        style = 'classic',
      },
      leap = {
        dim_backdrop = false,
        dim_support = false,
      },
      ts_context = {
        dark_background = true,
      },
    })
    require('nordic').load()

    local palette = require('nordic.colors')
    local function set_hl(name, opts)
      vim.api.nvim_set_hl(0, name, opts)
    end

    -- Nord color palette for consistency
    local nord_colors = {
      -- Polar Night
      nord0 = '#2E3440',  -- Darkest
      nord1 = '#3B4252',  -- Dark
      nord2 = '#434C5E',   -- Medium dark
      nord3 = '#4C566A',   -- Medium light
      
      -- Snow Storm
      nord4 = '#D8DEE9',  -- Light
      nord5 = '#E5E9F0',  -- Lighter
      nord6 = '#ECEFF4',  -- Lightest
      
      -- Frost
      nord7 = '#8FBCBB',  -- Sea green
      nord8 = '#88C0D0',  -- Frost blue
      nord9 = '#81A1C1',  -- Steel blue
      nord10 = '#5E81AC', -- Deep blue
      
      -- Aurora
      nord11 = '#BF616A', -- Red
      nord12 = '#D08770', -- Orange
      nord13 = '#EBCB8B', -- Yellow
      nord14 = '#A3BE8C', -- Green
      nord15 = '#B48EAD', -- Purple
    }

    -- Bufferline colors
    set_hl('BufferLineDiagError', { fg = nord_colors.nord11, bg = 'NONE' })
    set_hl('BufferLineDiagWarn', { fg = nord_colors.nord13, bg = 'NONE' })
    set_hl('BufferLineDiagInfo', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('BufferLineDiagHint', { fg = nord_colors.nord7, bg = 'NONE' })
    set_hl('BufferLineCloseButton', { fg = nord_colors.nord0, bg = nord_colors.nord0 })
    set_hl('BufferLineCloseButtonVisible', { fg = nord_colors.nord0, bg = nord_colors.nord0 })
    set_hl('BufferLineCloseButtonSelected', { fg = palette.bg or nord_colors.nord0, bg = palette.bg or nord_colors.nord0 })

    -- Enhanced UI colors to match terminal
    set_hl('NormalFloat', { bg = nord_colors.nord0, fg = nord_colors.nord4 })
    set_hl('FloatBorder', { bg = nord_colors.nord0, fg = nord_colors.nord3 })
    set_hl('LspInfoBorder', { bg = nord_colors.nord0, fg = nord_colors.nord3 })
    
    -- Telescope colors
    set_hl('TelescopeNormal', { bg = nord_colors.nord0, fg = nord_colors.nord4 })
    set_hl('TelescopeBorder', { bg = nord_colors.nord0, fg = nord_colors.nord3 })
    set_hl('TelescopePromptNormal', { bg = nord_colors.nord1, fg = nord_colors.nord4 })
    set_hl('TelescopePromptBorder', { bg = nord_colors.nord1, fg = nord_colors.nord3 })
    set_hl('TelescopeResultsNormal', { bg = nord_colors.nord0, fg = nord_colors.nord4 })
    set_hl('TelescopeResultsBorder', { bg = nord_colors.nord0, fg = nord_colors.nord3 })
    set_hl('TelescopePreviewNormal', { bg = nord_colors.nord0, fg = nord_colors.nord4 })
    set_hl('TelescopePreviewBorder', { bg = nord_colors.nord0, fg = nord_colors.nord3 })
    
    -- Neo-tree colors
    set_hl('NeoTreeNormal', { bg = nord_colors.nord0, fg = nord_colors.nord4 })
    set_hl('NeoTreeNormalNC', { bg = nord_colors.nord0, fg = nord_colors.nord4 })
    set_hl('NeoTreeFloatBorder', { bg = nord_colors.nord0, fg = nord_colors.nord3 })
    
    -- Indent blankline colors
    set_hl('IblIndent', { fg = nord_colors.nord2, bg = 'NONE' })
    set_hl('IblScope', { fg = nord_colors.nord3, bg = 'NONE' })
    
    -- Toggleterm colors
    set_hl('ToggleTerm', { bg = nord_colors.nord0, fg = nord_colors.nord4 })
    set_hl('ToggleTermBorder', { bg = nord_colors.nord0, fg = nord_colors.nord3 })
    
    -- Which-key colors
    set_hl('WhichKeyFloat', { bg = nord_colors.nord0, fg = nord_colors.nord4 })
    
    -- Lualine colors (ensure they match Nord)
    set_hl('LualineNormal', { bg = nord_colors.nord0, fg = nord_colors.nord4 })
    set_hl('LualineInsert', { bg = nord_colors.nord0, fg = nord_colors.nord14 })
    set_hl('LualineVisual', { bg = nord_colors.nord0, fg = nord_colors.nord12 })
    set_hl('LualineReplace', { bg = nord_colors.nord0, fg = nord_colors.nord11 })
    
    -- Diagnostic colors
    set_hl('DiagnosticError', { fg = nord_colors.nord11, bg = 'NONE' })
    set_hl('DiagnosticWarn', { fg = nord_colors.nord13, bg = 'NONE' })
    set_hl('DiagnosticInfo', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('DiagnosticHint', { fg = nord_colors.nord7, bg = 'NONE' })
    
    -- Search and selection colors
    set_hl('Search', { fg = nord_colors.nord0, bg = nord_colors.nord13 })
    set_hl('IncSearch', { fg = nord_colors.nord0, bg = nord_colors.nord12 })
    set_hl('Visual', { bg = nord_colors.nord2 })
    set_hl('VisualNOS', { bg = nord_colors.nord2 })
    
    -- Cursor and line colors
    set_hl('CursorLine', { bg = nord_colors.nord1 })
    set_hl('CursorLineNr', { fg = nord_colors.nord8, bg = nord_colors.nord1 })
    set_hl('LineNr', { fg = nord_colors.nord3, bg = 'NONE' })
    set_hl('CursorColumn', { bg = nord_colors.nord1 })
    
    -- Status line colors
    set_hl('StatusLine', { bg = nord_colors.nord0, fg = nord_colors.nord4 })
    set_hl('StatusLineNC', { bg = nord_colors.nord1, fg = nord_colors.nord3 })
    
    -- Tab line colors
    set_hl('TabLine', { bg = nord_colors.nord1, fg = nord_colors.nord3 })
    set_hl('TabLineFill', { bg = nord_colors.nord0 })
    set_hl('TabLineSel', { bg = nord_colors.nord10, fg = nord_colors.nord6 })

    -- Bufferline configuration with Nord colors
    local ok_bufferline, bufferline = pcall(require, 'bufferline')
    if ok_bufferline then
      bufferline.setup {
        options = {
          style_preset = bufferline.style_preset.minimal,
          separator_style = 'none',
          indicator = {
            style = 'none',
          },
          close_command = function(bufnum)
            require('bufferline').buf_kill('bd', bufnum, false)
          end,
          buffer_close_icon = '',
          close_icon = '',
          show_buffer_close_icons = false,
          show_close_icon = false,
          show_tab_indicators = false,
          modified_icon = '',
          diagnostics = false,
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
            },
          },
        },
        highlights = {
          fill = {
            bg = nord_colors.nord0,
          },
          background = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord3,
          },
          tab = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord3,
          },
          tab_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord6,
          },
          tab_close = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord3,
          },
          close_button = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord3,
          },
          close_button_visible = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord3,
          },
          close_button_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord6,
          },
          buffer_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord6,
            bold = true,
          },
          buffer_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord4,
          },
          numbers = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord3,
          },
          numbers_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord3,
          },
          numbers_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord6,
          },
          diagnostic = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord3,
          },
          diagnostic_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord3,
          },
          diagnostic_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord6,
          },
          hint = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord7,
          },
          hint_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord7,
          },
          hint_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord7,
          },
          hint_diagnostic = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord7,
          },
          hint_diagnostic_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord7,
          },
          hint_diagnostic_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord7,
          },
          info = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord8,
          },
          info_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord8,
          },
          info_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord8,
          },
          info_diagnostic = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord8,
          },
          info_diagnostic_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord8,
          },
          info_diagnostic_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord8,
          },
          warning = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord13,
          },
          warning_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord13,
          },
          warning_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord13,
          },
          warning_diagnostic = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord13,
          },
          warning_diagnostic_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord13,
          },
          warning_diagnostic_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord13,
          },
          error = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord11,
          },
          error_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord11,
          },
          error_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord11,
          },
          error_diagnostic = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord11,
          },
          error_diagnostic_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord11,
          },
          error_diagnostic_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord11,
          },
          modified = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord12,
          },
          modified_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord12,
          },
          modified_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord12,
          },
          separator = {
            bg = nord_colors.nord0,
            fg = nord_colors.nord0,
          },
          separator_visible = {
            bg = nord_colors.nord1,
            fg = nord_colors.nord1,
          },
          separator_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord10,
          },
          indicator_selected = {
            bg = nord_colors.nord10,
            fg = nord_colors.nord6,
          },
        },
      }
    end
  end,
}
