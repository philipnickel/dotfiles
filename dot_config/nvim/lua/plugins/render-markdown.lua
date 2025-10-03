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

    local dracula = {
      bg = '#282a36',
      text = '#f8f8f2',
      yellow = '#f1fa8c',
      pink = '#ff79c6',
      purple = '#bd93f9',
      cyan = '#8be9fd',
      green = '#50fa7b',
      orange = '#ffb86c',
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
      fg = '#5E81AC',  -- Not used directly for the border line
      bg = '#434C5E',  -- This becomes the foreground color of the border via bg_as_fg()
    })

    local accents = {
      dracula.yellow,
      dracula.pink,
      dracula.purple,
      dracula.cyan,
      dracula.green,
      dracula.orange,
    }

    for index, accent in ipairs(accents) do
      local fg = blend(accent, dracula.text, 0.35)
      local bg = blend(accent, dracula.bg, 0.12)

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
