-- render-markdown.nvim for better markdown rendering

return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ft = { 'markdown', 'quarto', 'Avante' },
  opts = {
    file_types = { 'markdown', 'quarto', 'Avante' },
    code = {
      enabled = true,
      sign = true,
      style = 'language',
      -- The language_border character (default '█') fills the space around the language label
      language_border = '█',
    },
  },
  config = function(_, opts)
    require('render-markdown').setup(opts)

    -- Nord Frost palette colors
    local nord_frost = {
      bg = '#2E3440',      -- nord0
      text = '#D8DEE9',    -- nord4
      sea_green = '#8FBCBB',   -- nord7
      frost_blue = '#88C0D0',  -- nord8
      steel_blue = '#81A1C1',  -- nord9
      deep_blue = '#5E81AC',   -- nord10
    }

    local function blend(foreground, background, alpha)
      local function channel(color, index)
        return tonumber(color:sub(index, index + 1), 16)
      end

      local function mix(one, two)
        return math.floor(one * alpha + two * (1 - alpha) + 0.5)
      end

      local blended = {
        mix(channel(foreground, 2), channel(background, 2)),
        mix(channel(foreground, 4), channel(background, 4)),
        mix(channel(foreground, 6), channel(background, 6)),
      }

      return string.format('#%02x%02x%02x', blended[1], blended[2], blended[3])
    end

    -- Transparent background for code block
    vim.api.nvim_set_hl(0, 'RenderMarkdownCode', {
      bg = 'NONE',
    })

    -- RenderMarkdownCodeBorder: This is the key highlight group for the language border
    -- The bg color gets converted to fg via bg_as_fg() for rendering the language_border character
    vim.api.nvim_set_hl(0, 'RenderMarkdownCodeBorder', {
      fg = nord_frost.deep_blue,    -- Deep blue for border
      bg = nord_frost.steel_blue,    -- Steel blue becomes the foreground color of the border
    })

    local accents = {
      nord_frost.sea_green,
      nord_frost.frost_blue,
      nord_frost.steel_blue,
      nord_frost.deep_blue,
      nord_frost.sea_green,
      nord_frost.frost_blue,
    }

    for index, accent in ipairs(accents) do
      local fg = blend(accent, nord_frost.text, 0.35)
      local bg = blend(accent, nord_frost.bg, 0.12)

      vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. index, {
        fg = fg,
        bold = true,
      })

      vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. index .. 'Bg', {
        bg = bg,
      })
    end
  end,
}
