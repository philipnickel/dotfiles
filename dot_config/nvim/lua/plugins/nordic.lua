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
    -- Nord Vim theme configuration variables (must be set before colorscheme activation)
    vim.g.nord_cursor_line_number_background = 1
    vim.g.nord_uniform_status_lines = 1
    vim.g.nord_bold_vertical_split_line = 1
    vim.g.nord_uniform_diff_background = 1
    vim.g.nord_bold = 1
    vim.g.nord_italic = 1
    vim.g.nord_italic_comments = 1
    vim.g.nord_underline = 1

    local frost = {
      sea_green = '#8FBCBB',
      frost_blue = '#88C0D0',
      steel_blue = '#81A1C1',
      deep_blue = '#5E81AC',
    }

    require('nordic').setup({
      transparent = {
        bg = true,   -- Main windows inherit terminal transparency
        float = true,
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

    local function make_transparent(groups)
      local attrs = {
        'fg',
        'ctermfg',
        'bold',
        'italic',
        'underline',
        'undercurl',
        'strikethrough',
        'reverse',
        'nocombine',
        'blend',
        'sp',
      }

      for _, group in ipairs(groups) do
        local opts = { bg = 'NONE', ctermbg = nil }
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })

        if ok and hl then
          for _, key in ipairs(attrs) do
            if hl[key] ~= nil then
              opts[key] = hl[key]
            end
          end
        end

        set_hl(group, opts)
      end
    end

    -- Nord color palette for consistency (exact colors from terminal)
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
      
      -- Frost (exact colors from your terminal)
      nord7 = '#8FBCBB',  -- Sea green
      nord8 = '#88C0D0',  -- Frost blue
      nord9 = '#81A1C1',  -- Steel blue
      nord10 = '#5E81AC', -- Deep blue
      
      -- Aurora (exact colors from your terminal)
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
    set_hl('BufferLineCloseButton', { fg = nord_colors.nord3, bg = 'NONE' })
    set_hl('BufferLineCloseButtonVisible', { fg = nord_colors.nord3, bg = 'NONE' })
    set_hl('BufferLineCloseButtonSelected', { fg = nord_colors.nord3, bg = 'NONE' })

    -- Enhanced UI colors to match terminal
    set_hl('NormalFloat', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('FloatBorder', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('LspInfoBorder', { bg = 'NONE', fg = nord_colors.nord3 })
    
    -- Telescope colors
    set_hl('TelescopeNormal', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('TelescopeBorder', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TelescopePromptNormal', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('TelescopePromptBorder', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TelescopeResultsNormal', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('TelescopeResultsBorder', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TelescopePreviewNormal', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('TelescopePreviewBorder', { bg = 'NONE', fg = nord_colors.nord3 })
    
    -- Neo-tree colors
    set_hl('NeoTreeNormal', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('NeoTreeNormalNC', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('NeoTreeFloatBorder', { bg = 'NONE', fg = nord_colors.nord3 })
    
    -- Indent blankline colors
    set_hl('IblIndent', { fg = nord_colors.nord2, bg = 'NONE' })
    set_hl('IblScope', { fg = nord_colors.nord3, bg = 'NONE' })
    
    -- Toggleterm colors
    set_hl('ToggleTerm', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('ToggleTermBorder', { bg = 'NONE', fg = nord_colors.nord3 })
    
    -- Which-key colors
    set_hl('WhichKeyFloat', { bg = 'NONE', fg = nord_colors.nord4 })
    
    -- Aerial colors
    set_hl('AerialNormal', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('AerialLine', { bg = 'NONE', fg = nord_colors.nord8, bold = true })
    set_hl('AerialLineNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('AerialGuide', { fg = nord_colors.nord3, bg = 'NONE' })
    set_hl('AerialGuide1', { fg = nord_colors.nord11, bg = 'NONE' })
    set_hl('AerialGuide2', { fg = nord_colors.nord10, bg = 'NONE' })
    set_hl('AerialGuide3', { fg = nord_colors.nord14, bg = 'NONE' })
    set_hl('AerialGuide4', { fg = nord_colors.nord12, bg = 'NONE' })
    
    -- Aerial symbol type colors
    set_hl('AerialClass', { fg = nord_colors.nord9, bg = 'NONE' })
    set_hl('AerialClassIcon', { fg = nord_colors.nord9, bg = 'NONE' })
    set_hl('AerialFunction', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('AerialFunctionIcon', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('AerialMethod', { fg = nord_colors.nord7, bg = 'NONE' })
    set_hl('AerialMethodIcon', { fg = nord_colors.nord7, bg = 'NONE' })
    set_hl('AerialVariable', { fg = nord_colors.nord4, bg = 'NONE' })
    set_hl('AerialVariableIcon', { fg = nord_colors.nord4, bg = 'NONE' })
    set_hl('AerialConstant', { fg = nord_colors.nord13, bg = 'NONE' })
    set_hl('AerialConstantIcon', { fg = nord_colors.nord13, bg = 'NONE' })
    set_hl('AerialProperty', { fg = nord_colors.nord14, bg = 'NONE' })
    set_hl('AerialPropertyIcon', { fg = nord_colors.nord14, bg = 'NONE' })
    set_hl('AerialInterface', { fg = nord_colors.nord15, bg = 'NONE' })
    set_hl('AerialInterfaceIcon', { fg = nord_colors.nord15, bg = 'NONE' })
    set_hl('AerialModule', { fg = nord_colors.nord10, bg = 'NONE' })
    set_hl('AerialModuleIcon', { fg = nord_colors.nord10, bg = 'NONE' })
    set_hl('AerialStruct', { fg = nord_colors.nord9, bg = 'NONE' })
    set_hl('AerialStructIcon', { fg = nord_colors.nord9, bg = 'NONE' })
    set_hl('AerialEnum', { fg = nord_colors.nord12, bg = 'NONE' })
    set_hl('AerialEnumIcon', { fg = nord_colors.nord12, bg = 'NONE' })
    set_hl('AerialConstructor', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('AerialConstructorIcon', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('AerialField', { fg = nord_colors.nord4, bg = 'NONE' })
    set_hl('AerialFieldIcon', { fg = nord_colors.nord4, bg = 'NONE' })
    set_hl('AerialEvent', { fg = nord_colors.nord11, bg = 'NONE' })
    set_hl('AerialEventIcon', { fg = nord_colors.nord11, bg = 'NONE' })
    set_hl('AerialOperator', { fg = nord_colors.nord3, bg = 'NONE' })
    set_hl('AerialOperatorIcon', { fg = nord_colors.nord3, bg = 'NONE' })
    set_hl('AerialTypeParameter', { fg = nord_colors.nord5, bg = 'NONE' })
    set_hl('AerialTypeParameterIcon', { fg = nord_colors.nord5, bg = 'NONE' })
    
    -- Lualine colors (ensure they match Nord)
    set_hl('LualineNormal', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('LualineInsert', { bg = 'NONE', fg = nord_colors.nord14 })
    set_hl('LualineVisual', { bg = 'NONE', fg = nord_colors.nord12 })
    set_hl('LualineReplace', { bg = 'NONE', fg = nord_colors.nord11 })
    
    -- Diagnostic colors (using Frost palette)
    set_hl('DiagnosticError', { fg = nord_colors.nord7, bg = 'NONE' })   -- Sea green
    set_hl('DiagnosticWarn', { fg = nord_colors.nord8, bg = 'NONE' })   -- Frost blue
    set_hl('DiagnosticInfo', { fg = nord_colors.nord9, bg = 'NONE' })   -- Steel blue
    set_hl('DiagnosticHint', { fg = nord_colors.nord10, bg = 'NONE' })  -- Deep blue
    
    -- Search and selection colors (using Frost palette)
    set_hl('Search', { fg = nord_colors.nord0, bg = nord_colors.nord8 })   -- Frost blue
    set_hl('IncSearch', { fg = nord_colors.nord0, bg = nord_colors.nord9 }) -- Steel blue
    set_hl('Visual', { bg = nord_colors.nord7 })   -- Sea green
    set_hl('VisualNOS', { bg = nord_colors.nord7 })
    
    -- Cursor and line colors (no highlighting)
    set_hl('CursorLine', { bg = 'NONE' })  -- No cursor line highlighting
    set_hl('CursorLineNr', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('LineNr', { fg = nord_colors.nord3, bg = 'NONE' })
    set_hl('CursorColumn', { bg = 'NONE' })
    
    -- Status line colors (transparent to show terminal background)
    set_hl('StatusLine', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('StatusLineNC', { bg = 'NONE', fg = nord_colors.nord3 })
    
    -- Tab line colors
    set_hl('TabLine', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TabLineFill', { bg = 'NONE' })
    set_hl('TabLineSel', { bg = 'NONE', fg = nord_colors.nord6, bold = true })
    
    -- Core UI elements to match terminal (transparent background)
    set_hl('Normal', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('NormalFloat', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('NormalNC', { bg = 'NONE', fg = nord_colors.nord3 })
    
    -- Window borders and separators
    set_hl('WinSeparator', { fg = nord_colors.nord3, bg = 'NONE' })
    set_hl('VertSplit', { fg = nord_colors.nord3, bg = 'NONE' })
    set_hl('WinBar', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('WinBarNC', { bg = 'NONE', fg = nord_colors.nord3 })
    
    -- Menu and popup colors
    set_hl('Pmenu', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('PmenuSel', { bg = nord_colors.nord10, fg = nord_colors.nord0 })
    set_hl('PmenuSbar', { bg = 'NONE' })
    set_hl('PmenuThumb', { bg = nord_colors.nord3 })
    set_hl('PmenuKind', { bg = 'NONE', fg = nord_colors.nord8 })
    set_hl('PmenuExtra', { bg = 'NONE', fg = nord_colors.nord3 })
    
    -- Completion menu
    set_hl('CmpItemAbbr', { fg = nord_colors.nord4, bg = 'NONE' })
    set_hl('CmpItemAbbrMatch', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('CmpItemAbbrMatchFuzzy', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('CmpItemKind', { fg = nord_colors.nord7, bg = 'NONE' })
    set_hl('CmpItemMenu', { fg = nord_colors.nord3, bg = 'NONE' })
    set_hl('CmpItemKindText', { fg = nord_colors.nord4, bg = 'NONE' })
    set_hl('CmpItemKindMethod', { fg = nord_colors.nord7, bg = 'NONE' })
    set_hl('CmpItemKindFunction', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('CmpItemKindConstructor', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('CmpItemKindField', { fg = nord_colors.nord4, bg = 'NONE' })
    set_hl('CmpItemKindVariable', { fg = nord_colors.nord4, bg = 'NONE' })
    set_hl('CmpItemKindClass', { fg = nord_colors.nord9, bg = 'NONE' })
    set_hl('CmpItemKindInterface', { fg = nord_colors.nord15, bg = 'NONE' })
    set_hl('CmpItemKindModule', { fg = nord_colors.nord10, bg = 'NONE' })
    set_hl('CmpItemKindProperty', { fg = nord_colors.nord14, bg = 'NONE' })
    set_hl('CmpItemKindUnit', { fg = nord_colors.nord13, bg = 'NONE' })
    set_hl('CmpItemKindValue', { fg = nord_colors.nord13, bg = 'NONE' })
    set_hl('CmpItemKindEnum', { fg = nord_colors.nord12, bg = 'NONE' })
    set_hl('CmpItemKindKeyword', { fg = nord_colors.nord11, bg = 'NONE' })
    set_hl('CmpItemKindSnippet', { fg = nord_colors.nord15, bg = 'NONE' })
    set_hl('CmpItemKindColor', { fg = nord_colors.nord11, bg = 'NONE' })
    set_hl('CmpItemKindFile', { fg = nord_colors.nord4, bg = 'NONE' })
    set_hl('CmpItemKindReference', { fg = nord_colors.nord11, bg = 'NONE' })
    set_hl('CmpItemKindFolder', { fg = nord_colors.nord4, bg = 'NONE' })
    set_hl('CmpItemKindEnumMember', { fg = nord_colors.nord12, bg = 'NONE' })
    set_hl('CmpItemKindConstant', { fg = nord_colors.nord13, bg = 'NONE' })
    set_hl('CmpItemKindStruct', { fg = nord_colors.nord9, bg = 'NONE' })
    set_hl('CmpItemKindEvent', { fg = nord_colors.nord11, bg = 'NONE' })
    set_hl('CmpItemKindOperator', { fg = nord_colors.nord3, bg = 'NONE' })
    set_hl('CmpItemKindTypeParameter', { fg = nord_colors.nord5, bg = 'NONE' })
    
    -- Fold colors
    set_hl('Folded', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('FoldColumn', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('SignColumn', { bg = 'NONE', fg = nord_colors.nord3 })
    
    -- Git signs (using Frost palette)
    set_hl('GitSignsAdd', { fg = nord_colors.nord7, bg = 'NONE' })   -- Sea green
    set_hl('GitSignsChange', { fg = nord_colors.nord8, bg = 'NONE' }) -- Frost blue
    set_hl('GitSignsDelete', { fg = nord_colors.nord9, bg = 'NONE' }) -- Steel blue
    set_hl('GitSignsAddNr', { fg = nord_colors.nord7, bg = 'NONE' })
    set_hl('GitSignsChangeNr', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('GitSignsDeleteNr', { fg = nord_colors.nord9, bg = 'NONE' })
    set_hl('GitSignsAddLn', { fg = nord_colors.nord7, bg = 'NONE' })
    set_hl('GitSignsChangeLn', { fg = nord_colors.nord8, bg = 'NONE' })
    set_hl('GitSignsDeleteLn', { fg = nord_colors.nord9, bg = 'NONE' })
    
    -- Diff colors (using Frost palette)
    set_hl('DiffAdd', { bg = 'NONE', fg = nord_colors.nord7 })   -- Sea green
    set_hl('DiffChange', { bg = 'NONE', fg = nord_colors.nord8 }) -- Frost blue
    set_hl('DiffDelete', { bg = 'NONE', fg = nord_colors.nord9 }) -- Steel blue
    set_hl('DiffText', { bg = 'NONE', fg = nord_colors.nord10 })  -- Deep blue
    
    -- Spell checking (using Frost palette)
    set_hl('SpellBad', { sp = nord_colors.nord7, undercurl = true })   -- Sea green
    set_hl('SpellCap', { sp = nord_colors.nord8, undercurl = true })   -- Frost blue
    set_hl('SpellLocal', { sp = nord_colors.nord9, undercurl = true }) -- Steel blue
    set_hl('SpellRare', { sp = nord_colors.nord10, undercurl = true }) -- Deep blue
    
    -- Whitespace and special characters
    set_hl('Whitespace', { fg = nord_colors.nord2 })
    set_hl('NonText', { fg = nord_colors.nord2 })
    set_hl('SpecialKey', { fg = nord_colors.nord2 })
    set_hl('EndOfBuffer', { fg = 'NONE' })
    
    -- Wild menu
    set_hl('WildMenu', { bg = nord_colors.nord10, fg = nord_colors.nord6 })
    
    -- Quickfix
    set_hl('QuickFixLine', { bg = 'NONE', fg = nord_colors.nord8 })
    set_hl('qfLineNr', { fg = nord_colors.nord3 })
    set_hl('qfFileName', { fg = nord_colors.nord8 })
    set_hl('qfSeparator', { fg = nord_colors.nord3 })
    
    -- Location list
    set_hl('LocationList', { bg = 'NONE', fg = nord_colors.nord4 })
    
    -- Command line
    set_hl('CmdLine', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('CmdLineIcon', { fg = nord_colors.nord8 })
    set_hl('CmdLineIconSearch', { fg = nord_colors.nord13 })
    set_hl('CmdLineIconPrompt', { fg = nord_colors.nord8 })
    set_hl('CmdLineIconHelp', { fg = nord_colors.nord7 })
    set_hl('CmdLineIconSubstitute', { fg = nord_colors.nord11 })
    set_hl('CmdLineIconTerminal', { fg = nord_colors.nord14 })
    set_hl('CmdLineIconShell', { fg = nord_colors.nord14 })
    set_hl('CmdLineIconFile', { fg = nord_colors.nord4 })
    set_hl('CmdLineIconLua', { fg = nord_colors.nord8 })
    set_hl('CmdLineIconVim', { fg = nord_colors.nord14 })
    
    -- Messages
    set_hl('MsgArea', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('MsgSeparator', { fg = nord_colors.nord3 })
    set_hl('MoreMsg', { fg = nord_colors.nord14 })
    set_hl('WarningMsg', { fg = nord_colors.nord13 })
    set_hl('ErrorMsg', { fg = nord_colors.nord11 })
    set_hl('ModeMsg', { fg = nord_colors.nord8 })
    set_hl('Title', { fg = nord_colors.nord8, bold = true })
    
    -- Conceal
    set_hl('Conceal', { fg = nord_colors.nord3, bg = 'NONE' })
    
    -- MatchParen
    set_hl('MatchParen', { bg = nord_colors.nord2, fg = nord_colors.nord8 })
    
    -- Substitute
    set_hl('Substitute', { bg = nord_colors.nord13, fg = nord_colors.nord0 })
    
    -- IncSearch
    set_hl('IncSearch', { bg = nord_colors.nord12, fg = nord_colors.nord0 })
    
    -- CurSearch
    set_hl('CurSearch', { bg = nord_colors.nord8, fg = nord_colors.nord0 })
    
    -- Substitute
    set_hl('Substitute', { bg = nord_colors.nord13, fg = nord_colors.nord0 })
    
    -- Sneak
    set_hl('Sneak', { bg = nord_colors.nord8, fg = nord_colors.nord0 })
    set_hl('SneakScope', { bg = 'NONE', fg = nord_colors.nord4 })
    
    -- Leap
    set_hl('LeapBackdrop', { fg = nord_colors.nord3 })
    set_hl('LeapMatch', { bg = nord_colors.nord8, fg = nord_colors.nord0, bold = true })
    set_hl('LeapLabelPrimary', { bg = nord_colors.nord11, fg = nord_colors.nord6, bold = true })
    set_hl('LeapLabelSecondary', { bg = nord_colors.nord7, fg = nord_colors.nord0, bold = true })
    set_hl('LeapLabelSelected', { bg = nord_colors.nord10, fg = nord_colors.nord6, bold = true })
    
    -- Trouble colors
    set_hl('TroubleNormal', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('TroubleSignColumn', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroublePreviewNormal', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('TroubleCount', { bg = 'NONE', fg = nord_colors.nord8 })
    set_hl('TroubleCode', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleSource', { bg = 'NONE', fg = nord_colors.nord7 })
    set_hl('TroubleLocation', { bg = 'NONE', fg = nord_colors.nord8 })
    set_hl('TroubleFoldIcon', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleIndent', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleText', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('TroubleTextInformation', { bg = 'NONE', fg = nord_colors.nord8 })
    set_hl('TroubleTextWarning', { bg = 'NONE', fg = nord_colors.nord13 })
    set_hl('TroubleTextError', { bg = 'NONE', fg = nord_colors.nord11 })
    set_hl('TroubleTextHint', { bg = 'NONE', fg = nord_colors.nord7 })
    set_hl('TroubleClose', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroublePreview', { bg = 'NONE', fg = nord_colors.nord4 })
    set_hl('TroubleNormalNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleSignColumnNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroublePreviewNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleCountNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleCodeNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleSourceNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleLocationNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleFoldIconNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleIndentNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleTextNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleTextInformationNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleTextWarningNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleTextErrorNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleTextHintNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroubleCloseNC', { bg = 'NONE', fg = nord_colors.nord3 })
    set_hl('TroublePreviewNC', { bg = 'NONE', fg = nord_colors.nord3 })

    -- Bufferline configuration with Nord colors
    local ok_bufferline, bufferline = pcall(require, 'bufferline')
    if ok_bufferline then
      local none = 'NONE'
      bufferline.setup {
        options = {
          style_preset = bufferline.style_preset.minimal,
          separator_style = 'none',
          indicator = {
            style = 'none',
          },
          themable = false,
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
          fill = { bg = none },
          background = { bg = none, fg = nord_colors.nord3 },
          tab = { bg = none, fg = nord_colors.nord3 },
          tab_selected = { bg = none, fg = nord_colors.nord6, bold = true },
          tab_close = { bg = none, fg = nord_colors.nord3 },
          close_button = { bg = none, fg = nord_colors.nord3 },
          close_button_visible = { bg = none, fg = nord_colors.nord3 },
          close_button_selected = { bg = none, fg = nord_colors.nord6 },
          buffer_selected = { bg = none, fg = nord_colors.nord6, bold = true },
          buffer_visible = { bg = none, fg = nord_colors.nord4 },
          numbers = { bg = none, fg = nord_colors.nord3 },
          numbers_visible = { bg = none, fg = nord_colors.nord3 },
          numbers_selected = { bg = none, fg = nord_colors.nord6 },
          diagnostic = { bg = none, fg = nord_colors.nord3 },
          diagnostic_visible = { bg = none, fg = nord_colors.nord3 },
          diagnostic_selected = { bg = none, fg = nord_colors.nord6 },
          hint = { bg = none, fg = nord_colors.nord7 },
          hint_visible = { bg = none, fg = nord_colors.nord7 },
          hint_selected = { bg = none, fg = nord_colors.nord7 },
          hint_diagnostic = { bg = none, fg = nord_colors.nord7 },
          hint_diagnostic_visible = { bg = none, fg = nord_colors.nord7 },
          hint_diagnostic_selected = { bg = none, fg = nord_colors.nord7 },
          info = { bg = none, fg = nord_colors.nord8 },
          info_visible = { bg = none, fg = nord_colors.nord8 },
          info_selected = { bg = none, fg = nord_colors.nord8 },
          info_diagnostic = { bg = none, fg = nord_colors.nord8 },
          info_diagnostic_visible = { bg = none, fg = nord_colors.nord8 },
          info_diagnostic_selected = { bg = none, fg = nord_colors.nord8 },
          warning = { bg = none, fg = nord_colors.nord13 },
          warning_visible = { bg = none, fg = nord_colors.nord13 },
          warning_selected = { bg = none, fg = nord_colors.nord13 },
          warning_diagnostic = { bg = none, fg = nord_colors.nord13 },
          warning_diagnostic_visible = { bg = none, fg = nord_colors.nord13 },
          warning_diagnostic_selected = { bg = none, fg = nord_colors.nord13 },
          error = { bg = none, fg = nord_colors.nord11 },
          error_visible = { bg = none, fg = nord_colors.nord11 },
          error_selected = { bg = none, fg = nord_colors.nord11 },
          error_diagnostic = { bg = none, fg = nord_colors.nord11 },
          error_diagnostic_visible = { bg = none, fg = nord_colors.nord11 },
          error_diagnostic_selected = { bg = none, fg = nord_colors.nord11 },
          modified = { bg = none, fg = nord_colors.nord12 },
          modified_visible = { bg = none, fg = nord_colors.nord12 },
          modified_selected = { bg = none, fg = nord_colors.nord12 },
          separator = { bg = none, fg = nord_colors.nord3 },
          separator_visible = { bg = none, fg = nord_colors.nord3 },
          separator_selected = { bg = none, fg = nord_colors.nord6 },
          indicator_selected = { bg = none, fg = nord_colors.nord6 },
        },
      }
    end

    local transparent_groups = {
      'Normal',
      'NormalNC',
      'NormalFloat',
      'NormalSB',
      'FloatBorder',
      'LspInfoBorder',
      'SignColumn',
      'LineNr',
      'FoldColumn',
      'CursorLine',
      'CursorLineNr',
      'CursorColumn',
      'StatusLine',
      'StatusLineNC',
      'WinSeparator',
      'VertSplit',
      'WinBar',
      'WinBarNC',
      'CmdLine',
      'MsgArea',
      'LocationList',
      'QuickFixLine',
      'TroubleNormal',
      'TroubleSignColumn',
      'TroublePreviewNormal',
      'TroubleCount',
      'TroubleCode',
      'TroubleSource',
      'TroubleLocation',
      'TroubleFoldIcon',
      'TroubleIndent',
      'TroubleText',
      'TroubleTextInformation',
      'TroubleTextWarning',
      'TroubleTextError',
      'TroubleTextHint',
      'TroubleClose',
      'TroublePreview',
      'TroubleNormalNC',
      'TroubleSignColumnNC',
      'TroublePreviewNC',
      'TroubleCountNC',
      'TroubleCodeNC',
      'TroubleSourceNC',
      'TroubleLocationNC',
      'TroubleFoldIconNC',
      'TroubleIndentNC',
      'TroubleTextNC',
      'TroubleTextInformationNC',
      'TroubleTextWarningNC',
      'TroubleTextErrorNC',
      'TroubleTextHintNC',
      'TroubleCloseNC',
      'BufferLineFill',
      'BufferLineBackground',
      'BufferLineBuffer',
      'BufferLineTab',
      'BufferLineTabSelected',
      'BufferLineTabClose',
      'BufferLineCloseButton',
      'BufferLineCloseButtonVisible',
      'BufferLineCloseButtonSelected',
      'BufferLineBufferVisible',
      'BufferLineBufferSelected',
      'BufferLineNumbers',
      'BufferLineNumbersVisible',
      'BufferLineNumbersSelected',
      'BufferLineDiagnostic',
      'BufferLineDiagnosticVisible',
      'BufferLineDiagnosticSelected',
      'BufferLineHint',
      'BufferLineHintVisible',
      'BufferLineHintSelected',
      'BufferLineHintDiagnostic',
      'BufferLineHintDiagnosticVisible',
      'BufferLineHintDiagnosticSelected',
      'BufferLineInfo',
      'BufferLineInfoVisible',
      'BufferLineInfoSelected',
      'BufferLineInfoDiagnostic',
      'BufferLineInfoDiagnosticVisible',
      'BufferLineInfoDiagnosticSelected',
      'BufferLineWarning',
      'BufferLineWarningVisible',
      'BufferLineWarningSelected',
      'BufferLineWarningDiagnostic',
      'BufferLineWarningDiagnosticVisible',
      'BufferLineWarningDiagnosticSelected',
      'BufferLineError',
      'BufferLineErrorVisible',
      'BufferLineErrorSelected',
      'BufferLineErrorDiagnostic',
      'BufferLineErrorDiagnosticVisible',
      'BufferLineErrorDiagnosticSelected',
      'BufferLineSeparator',
      'BufferLineSeparatorVisible',
      'BufferLineSeparatorSelected',
      'BufferLineIndicator',
      'BufferLineIndicatorVisible',
      'BufferLineIndicatorSelected',
      'BufferLineModified',
      'BufferLineModifiedVisible',
      'BufferLineModifiedSelected',
      'BufferLineDuplicate',
      'BufferLineDuplicateVisible',
      'BufferLineDuplicateSelected',
      'BufferLinePick',
      'BufferLinePickVisible',
      'BufferLinePickSelected',
      'BufferLineOffsetSeparator',
      'BufferLineGroupLabel',
      'BufferLineGroupSeparator',
      'BufferLineTruncMarker',
      'BufferLineTabSeparator',
      'BufferLineTabSeparatorVisible',
      'BufferLineTabSeparatorSelected',
      'BufferLineGroupSeparator',
      'BufferLineGroupSeparatorVisible',
      'BufferLineGroupSeparatorSelected',
      'TabLine',
      'TabLineFill',
      'TabLineSel',
      'TabLineSeparator',
      'TabLineSeparatorSel',
      'LualineNormal',
      'LualineInsert',
      'LualineVisual',
      'LualineReplace',
      'LualineCommand',
      'LualineInactive',
      'LualineANormal',
      'LualineBNormal',
      'LualineCNormal',
      'LualineXNormal',
      'LualineYNormal',
      'LualineZNormal',
      'LualineAInsert',
      'LualineBInsert',
      'LualineCInsert',
      'LualineXInsert',
      'LualineYInsert',
      'LualineZInsert',
      'LualineAVisual',
      'LualineBVisual',
      'LualineCVisual',
      'LualineXVisual',
      'LualineYVisual',
      'LualineZVisual',
      'LualineAReplace',
      'LualineBReplace',
      'LualineCReplace',
      'LualineXReplace',
      'LualineYReplace',
      'LualineZReplace',
      'LualineACommand',
      'LualineBCommand',
      'LualineCCommand',
      'LualineXCommand',
      'LualineYCommand',
      'LualineZCommand',
      'LualineAInactive',
      'LualineBInactive',
      'LualineCInactive',
      'LualineXInactive',
      'LualineYInactive',
      'LualineZInactive',
    }

    make_transparent(transparent_groups)

    vim.api.nvim_create_autocmd({ 'ColorScheme', 'BufEnter' }, {
      group = vim.api.nvim_create_augroup('NordicTransparent', { clear = true }),
      callback = function()
        make_transparent(transparent_groups)
      end,
    })
  end,
}
