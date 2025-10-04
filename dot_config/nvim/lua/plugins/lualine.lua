-- Lualine statusline configuration

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Custom component to show active Python environment
    local function get_python_env()
      local venv = os.getenv("VIRTUAL_ENV")
      local conda_env = os.getenv("CONDA_DEFAULT_ENV")
      
      if venv then
        -- Extract just the environment name from the full path
        local env_name = venv:match("([^/\\]+)$")
        return "🐍 " .. env_name
      elseif conda_env then
        return "🐍 " .. conda_env
      else
        return nil -- Don't show anything if no environment is active
      end
    end

    -- Custom Nord theme for lualine to match tmux status line exactly
    local nord_theme = {
      normal = {
        a = { fg = '#2E3440', bg = '#5E81AC', gui = 'bold' },
        b = { fg = '#D8DEE9', bg = '#3B4252' },
        c = { fg = '#D8DEE9', bg = '#2E3440' },
        x = { fg = '#D8DEE9', bg = '#2E3440' },
        y = { fg = '#D8DEE9', bg = '#3B4252' },
        z = { fg = '#2E3440', bg = '#5E81AC', gui = 'bold' }
      },
      insert = {
        a = { fg = '#2E3440', bg = '#A3BE8C', gui = 'bold' },
        b = { fg = '#D8DEE9', bg = '#3B4252' },
        c = { fg = '#D8DEE9', bg = '#2E3440' },
        x = { fg = '#D8DEE9', bg = '#2E3440' },
        y = { fg = '#D8DEE9', bg = '#3B4252' },
        z = { fg = '#2E3440', bg = '#A3BE8C', gui = 'bold' }
      },
      visual = {
        a = { fg = '#2E3440', bg = '#D08770', gui = 'bold' },
        b = { fg = '#D8DEE9', bg = '#3B4252' },
        c = { fg = '#D8DEE9', bg = '#2E3440' },
        x = { fg = '#D8DEE9', bg = '#2E3440' },
        y = { fg = '#D8DEE9', bg = '#3B4252' },
        z = { fg = '#2E3440', bg = '#D08770', gui = 'bold' }
      },
      replace = {
        a = { fg = '#2E3440', bg = '#BF616A', gui = 'bold' },
        b = { fg = '#D8DEE9', bg = '#3B4252' },
        c = { fg = '#D8DEE9', bg = '#2E3440' },
        x = { fg = '#D8DEE9', bg = '#2E3440' },
        y = { fg = '#D8DEE9', bg = '#3B4252' },
        z = { fg = '#2E3440', bg = '#BF616A', gui = 'bold' }
      },
      command = {
        a = { fg = '#2E3440', bg = '#B48EAD', gui = 'bold' },
        b = { fg = '#D8DEE9', bg = '#3B4252' },
        c = { fg = '#D8DEE9', bg = '#2E3440' },
        x = { fg = '#D8DEE9', bg = '#2E3440' },
        y = { fg = '#D8DEE9', bg = '#3B4252' },
        z = { fg = '#2E3440', bg = '#B48EAD', gui = 'bold' }
      },
      inactive = {
        a = { fg = '#4C566A', bg = '#3B4252', gui = 'bold' },
        b = { fg = '#4C566A', bg = '#3B4252' },
        c = { fg = '#4C566A', bg = '#2E3440' },
        x = { fg = '#4C566A', bg = '#2E3440' },
        y = { fg = '#4C566A', bg = '#3B4252' },
        z = { fg = '#4C566A', bg = '#3B4252' }
      }
    }

           require("lualine").setup({
             options = {
               icons_enabled = true,
               theme = nord_theme, -- Use custom Nord theme to match terminal colors
               component_separators = { left = "│", right = "│" },
               section_separators = { left = "", right = "" },
               disabled_filetypes = {
                 statusline = { "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
                 winbar = {},
               },
               ignore_focus = { "neo-tree", "Trouble", "lazy", "mason" },
               always_divide_middle = true,
               globalstatus = true, -- Use global statusline
               refresh = {
                 statusline = 1000,
                 tabline = 1000,
                 winbar = 1000,
               },
             },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { 
          { get_python_env, color = { fg = "#88C0D0" } }, -- Nord frost blue color
          "encoding", 
          "fileformat", 
          "filetype" 
        },
        lualine_y = { 
          {
            "aerial",
            sep = " ) ",
            depth = 2,
            dense = false,
            dense_sep = ".",
            colored = true,
          },
          "progress" 
        },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })

    -- Force lualine highlight groups to match tmux status line exactly
    vim.api.nvim_set_hl(0, 'LualineNormal', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineInsert', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineVisual', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineReplace', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineCommand', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineInactive', { bg = '#2E3440', fg = '#4C566A' })
    
    -- Mode-specific highlight groups (matching tmux status line)
    vim.api.nvim_set_hl(0, 'LualineANormal', { bg = '#5E81AC', fg = '#2E3440', bold = true })
    vim.api.nvim_set_hl(0, 'LualineAInsert', { bg = '#A3BE8C', fg = '#2E3440', bold = true })
    vim.api.nvim_set_hl(0, 'LualineAVisual', { bg = '#D08770', fg = '#2E3440', bold = true })
    vim.api.nvim_set_hl(0, 'LualineAReplace', { bg = '#BF616A', fg = '#2E3440', bold = true })
    vim.api.nvim_set_hl(0, 'LualineACommand', { bg = '#B48EAD', fg = '#2E3440', bold = true })
    vim.api.nvim_set_hl(0, 'LualineAInactive', { bg = '#3B4252', fg = '#4C566A', bold = true })
    
    vim.api.nvim_set_hl(0, 'LualineZNormal', { bg = '#5E81AC', fg = '#2E3440', bold = true })
    vim.api.nvim_set_hl(0, 'LualineZInsert', { bg = '#A3BE8C', fg = '#2E3440', bold = true })
    vim.api.nvim_set_hl(0, 'LualineZVisual', { bg = '#D08770', fg = '#2E3440', bold = true })
    vim.api.nvim_set_hl(0, 'LualineZReplace', { bg = '#BF616A', fg = '#2E3440', bold = true })
    vim.api.nvim_set_hl(0, 'LualineZCommand', { bg = '#B48EAD', fg = '#2E3440', bold = true })
    vim.api.nvim_set_hl(0, 'LualineZInactive', { bg = '#3B4252', fg = '#4C566A', bold = true })
    
    -- Section-specific highlight groups (matching tmux status line)
    vim.api.nvim_set_hl(0, 'LualineBNormal', { bg = '#3B4252', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineCNormal', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineXNormal', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineYNormal', { bg = '#3B4252', fg = '#D8DEE9' })
    
    vim.api.nvim_set_hl(0, 'LualineBInsert', { bg = '#3B4252', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineCInsert', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineXInsert', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineYInsert', { bg = '#3B4252', fg = '#D8DEE9' })
    
    vim.api.nvim_set_hl(0, 'LualineBVisual', { bg = '#3B4252', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineCVisual', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineXVisual', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineYVisual', { bg = '#3B4252', fg = '#D8DEE9' })
    
    vim.api.nvim_set_hl(0, 'LualineBReplace', { bg = '#3B4252', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineCReplace', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineXReplace', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineYReplace', { bg = '#3B4252', fg = '#D8DEE9' })
    
    vim.api.nvim_set_hl(0, 'LualineBCommand', { bg = '#3B4252', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineCCommand', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineXCommand', { bg = '#2E3440', fg = '#D8DEE9' })
    vim.api.nvim_set_hl(0, 'LualineYCommand', { bg = '#3B4252', fg = '#D8DEE9' })
    
    vim.api.nvim_set_hl(0, 'LualineBInactive', { bg = '#3B4252', fg = '#4C566A' })
    vim.api.nvim_set_hl(0, 'LualineCInactive', { bg = '#2E3440', fg = '#4C566A' })
    vim.api.nvim_set_hl(0, 'LualineXInactive', { bg = '#2E3440', fg = '#4C566A' })
    vim.api.nvim_set_hl(0, 'LualineYInactive', { bg = '#3B4252', fg = '#4C566A' })
  end,
}