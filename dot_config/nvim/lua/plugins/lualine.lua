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

    local transparent = 'NONE'

    -- Custom Nord theme for lualine that keeps the statusline transparent
    local nord_theme = {
      normal = {
        a = { fg = '#5E81AC', bg = transparent, gui = 'bold' },
        b = { fg = '#D8DEE9', bg = transparent },
        c = { fg = '#D8DEE9', bg = transparent },
        x = { fg = '#D8DEE9', bg = transparent },
        y = { fg = '#D8DEE9', bg = transparent },
        z = { fg = '#5E81AC', bg = transparent, gui = 'bold' }
      },
      insert = {
        a = { fg = '#A3BE8C', bg = transparent, gui = 'bold' },
        b = { fg = '#D8DEE9', bg = transparent },
        c = { fg = '#D8DEE9', bg = transparent },
        x = { fg = '#D8DEE9', bg = transparent },
        y = { fg = '#D8DEE9', bg = transparent },
        z = { fg = '#A3BE8C', bg = transparent, gui = 'bold' }
      },
      visual = {
        a = { fg = '#D08770', bg = transparent, gui = 'bold' },
        b = { fg = '#D8DEE9', bg = transparent },
        c = { fg = '#D8DEE9', bg = transparent },
        x = { fg = '#D8DEE9', bg = transparent },
        y = { fg = '#D8DEE9', bg = transparent },
        z = { fg = '#D08770', bg = transparent, gui = 'bold' }
      },
      replace = {
        a = { fg = '#BF616A', bg = transparent, gui = 'bold' },
        b = { fg = '#D8DEE9', bg = transparent },
        c = { fg = '#D8DEE9', bg = transparent },
        x = { fg = '#D8DEE9', bg = transparent },
        y = { fg = '#D8DEE9', bg = transparent },
        z = { fg = '#BF616A', bg = transparent, gui = 'bold' }
      },
      command = {
        a = { fg = '#B48EAD', bg = transparent, gui = 'bold' },
        b = { fg = '#D8DEE9', bg = transparent },
        c = { fg = '#D8DEE9', bg = transparent },
        x = { fg = '#D8DEE9', bg = transparent },
        y = { fg = '#D8DEE9', bg = transparent },
        z = { fg = '#B48EAD', bg = transparent, gui = 'bold' }
      },
      inactive = {
        a = { fg = '#4C566A', bg = transparent, gui = 'bold' },
        b = { fg = '#4C566A', bg = transparent },
        c = { fg = '#4C566A', bg = transparent },
        x = { fg = '#4C566A', bg = transparent },
        y = { fg = '#4C566A', bg = transparent },
        z = { fg = '#4C566A', bg = transparent }
      }
    }

           require("lualine").setup({
             options = {
               icons_enabled = true,
               theme = "catppuccin", -- Use catppuccin theme to match colorscheme
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

  end,
}
