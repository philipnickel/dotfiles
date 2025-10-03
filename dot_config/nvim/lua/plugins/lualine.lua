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

           require("lualine").setup({
             options = {
               icons_enabled = true,
               theme = "nordic", -- Use Nordic theme to match your colorscheme
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
          { get_python_env, color = { fg = "#88c0d0" } }, -- Nordic blue color
          "encoding", 
          "fileformat", 
          "filetype" 
        },
        lualine_y = { "progress" },
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