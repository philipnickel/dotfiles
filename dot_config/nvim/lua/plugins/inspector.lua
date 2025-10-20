return {
  {
    "catppuccin/nvim",
    opts = function(_, opts)
      vim.api.nvim_create_user_command("CatppuccinGlassCheck", function()
        local function group_bg(name)
          local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
          if not hl or not hl.bg then
            return "NONE"
          end
          return string.format("#%06x", hl.bg)
        end

        local lines = {
          "CmdLine:        " .. group_bg("CmdLine"),
          "WhichKeyFloat:  " .. group_bg("WhichKeyFloat"),
          "NeoTreeNormal:  " .. group_bg("NeoTreeNormal"),
          "NormalFloat:    " .. group_bg("NormalFloat"),
          "Pmenu:          " .. group_bg("Pmenu"),
        }

        local chunks = vim.tbl_map(function(line)
          return { line, "None" }
        end, lines)

        vim.api.nvim_echo(chunks, true, {})
      end, { desc = "Inspect Catppuccin float backgrounds" })
      return opts
    end,
  },
}
