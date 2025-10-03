-- Plugin configurations for LunarVim
-- This file contains all plugin definitions and their configurations

-- which-key is handled by LunarVim's built-in system

-- Load SymPy configuration
require('sympy-config')

-- Nordic colorscheme
table.insert(lvim.plugins, {
  "AlexvZyl/nordic.nvim",
  priority = 1000,
  lazy = false,
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
    })
    require('nordic').load()

    local palette = require('nordic.colors')
    local function set_hl(name, opts)
      vim.api.nvim_set_hl(0, name, opts)
    end

    set_hl('BufferLineDiagError', { fg = '#BF616A', bg = 'NONE' })
    set_hl('BufferLineDiagWarn', { fg = '#EBCB8B', bg = 'NONE' })
    set_hl('BufferLineDiagInfo', { fg = '#88C0D0', bg = 'NONE' })
    set_hl('BufferLineDiagHint', { fg = '#8FBCBB', bg = 'NONE' })
    set_hl('BufferLineCloseButton', { fg = '#2E3440', bg = '#2E3440' })
    set_hl('BufferLineCloseButtonVisible', { fg = '#2E3440', bg = '#2E3440' })
    set_hl('BufferLineCloseButtonSelected', { fg = palette.bg or '#2E3440', bg = palette.bg or '#2E3440' })

    if lvim.builtin and lvim.builtin.bufferline then
      local ok_bufferline, bufferline = pcall(require, 'bufferline')
      if ok_bufferline then
        lvim.builtin.bufferline.options.style_preset = bufferline.style_preset.minimal
        lvim.builtin.bufferline.options.separator_style = 'none'
        lvim.builtin.bufferline.options.indicator = {
          style = 'none',
        }
        lvim.builtin.bufferline.options.close_command = function(bufnum)
          require('lvim.core.bufferline').buf_kill('bd', bufnum, false)
        end
        lvim.builtin.bufferline.options.buffer_close_icon = ''
        lvim.builtin.bufferline.options.close_icon = ''
        lvim.builtin.bufferline.options.show_buffer_close_icons = false
        lvim.builtin.bufferline.options.show_close_icon = false
        lvim.builtin.bufferline.options.show_tab_indicators = false
        lvim.builtin.bufferline.options.modified_icon = ''
        lvim.builtin.bufferline.options.diagnostics = false
        lvim.builtin.bufferline.highlights = {}
        bufferline.setup {
          options = lvim.builtin.bufferline.options,
          highlights = lvim.builtin.bufferline.highlights,
        }
      end
    end
  end,
})

table.insert(lvim.plugins, {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      config = function()
        local ok, notify = pcall(require, 'notify')
        if not ok then
          return
        end
        notify.setup({
          background_colour = '#2E3440',
          stages = 'fade',
          timeout = 2000,
        })
        vim.notify = notify
      end,
    },
  },
  config = function()
    local ok, noice = pcall(require, 'noice')
    if not ok then
      return
    end

    noice.setup({
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
      views = {
        notify = {
          backend = 'notify',
        },
      },
    })
  end,
})

table.insert(lvim.plugins, {
  "AckslD/nvim-neoclip.lua",
  lazy = false,
  dependencies = {
    {
      "kkharji/sqlite.lua",
      lazy = true,
    },
    {
      "nvim-telescope/telescope.nvim",
      lazy = true,
    },
  },
  config = function()
    local ok, neoclip = pcall(require, 'neoclip')
    if not ok then
      return
    end

    neoclip.setup({
      history = 1000,
      enable_persistent_history = true,
      length_limit = 1048576,
      continuous_sync = false,
      db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
      filter = nil,
      preview = true,
      prompt = nil,
      default_register = '"',
      default_register_macros = 'q',
      enable_macro_history = true,
      content_spec_column = false,
      disable_keycodes_parsing = false,
      dedent_picker_display = false,
      initial_mode = 'insert',
      on_select = {
        move_to_front = false,
        close_telescope = true,
      },
      on_paste = {
        set_reg = false,
        move_to_front = false,
        close_telescope = true,
      },
      on_replay = {
        set_reg = false,
        move_to_front = false,
        close_telescope = true,
      },
      on_custom_action = {
        close_telescope = true,
      },
      keys = {
        telescope = {
          i = {
            select = '<cr>',
            paste = '<c-p>',
            paste_behind = '<c-k>',
            replay = '<c-q>',
            delete = '<c-d>',
            edit = '<c-e>',
            custom = {},
          },
          n = {
            select = '<cr>',
            paste = 'p',
            paste_behind = 'P',
            replay = 'q',
            delete = 'd',
            edit = 'e',
            custom = {},
          },
        },
      },
    })

    -- Keybindings for neoclip
    vim.keymap.set('n', '<leader>y', '<cmd>Telescope neoclip<cr>', {
      desc = 'Open Neoclip (clipboard history)',
      silent = true,
    })
    
    vim.keymap.set('n', '<leader>ym', '<cmd>Telescope macroscope<cr>', {
      desc = 'Open Macroscope (macro history)',
      silent = true,
    })
  end,
})

table.insert(lvim.plugins, {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      search = {
        enabled = true,
      },
    },
  },
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash Jump',
    },
    {
      'S',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter',
    },
    {
      'r',
      mode = 'o',
      function()
        require('flash').remote()
      end,
      desc = 'Flash Remote',
    },
    {
      'R',
      mode = { 'o', 'x' },
      function()
        require('flash').treesitter_search()
      end,
      desc = 'Flash Treesitter Search',
    },
    {
      '<c-s>',
      mode = 'c',
      function()
        require('flash').toggle()
      end,
      desc = 'Toggle Flash Search',
    },
  },
})

table.insert(lvim.plugins, {
  "kylechui/nvim-surround",
  version = "^3.0.0",
  event = "VeryLazy",
  config = function()
    require('nvim-surround').setup({})
  end,
})

table.insert(lvim.plugins, {
  'xvzc/chezmoi.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'ChezmoiEdit', 'ChezmoiList' },
  config = function()
    local home = vim.fn.expand('~')
    local source_path = home .. '/.local/share/chezmoi/'
    require('chezmoi').setup({
      edit = {
        watch = true,
        force = false,
        ignore_patterns = {
          'run_onchange_.*',
          'run_once_.*',
          '%.chezmoiignore',
          '%.chezmoitemplate',
        },
      },
    })

    local has_telescope, telescope = pcall(require, 'telescope')
    if has_telescope and telescope.load_extension then
      pcall(telescope.load_extension, 'chezmoi')
    end

    vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
      pattern = { source_path .. '*' },
      callback = function(args)
        vim.schedule(function()
          require('chezmoi.commands.__edit').watch(args.buf)
        end)
      end,
    })

    if has_telescope and telescope.extensions and telescope.extensions.chezmoi then
      vim.keymap.set('n', '<leader>Cf', telescope.extensions.chezmoi.find_files, {
        desc = 'ChezMoi managed files',
        silent = true,
      })
    end
  end,
})

-- Copilot integration
table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    vim.defer_fn(function()
      require("copilot").setup() -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
      require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
    end, 100)
  end,
})

-- Markdown preview
table.insert(lvim.plugins, {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function() vim.fn["mkdp#util#install"]() end,
})

-- REPL functionality handled by LunarVim's built-in features

-- Telescope is handled by LunarVim's built-in system

-- Tmux navigation
table.insert(lvim.plugins, {
  "christoomey/vim-tmux-navigator",
  config = function()
    -- Configure tmux navigator without defining keys
    -- LunarVim will handle key conflicts automatically
  end,
})

-- VimTeX for LaTeX support
table.insert(lvim.plugins, {
  "lervag/vimtex",
  ft = { "tex", "latex" },
  config = function()
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_view_zathura_options = "--synctex-forward @line:@col:@file"
    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-pdf",
        "-interaction=nonstopmode",
        "-file-line-error",
        "-synctex=1",
        "-verbose",
      },
    }
    
    -- VimTeX native spell checking configuration
    vim.g.vimtex_syntax_enabled = 1
    vim.g.vimtex_syntax_conceal = {
      accents = 1,
      ligatures = 1,
      it = 1,
      bold = 1,
      italic = 1,
      math_bounds = 1,
      math_delimiters = 1,
      math_fracs = 1,
      math_super_sub = 1,
      math_symbols = 1,
      sections = 0,
      spacing = 0,
      greek = 1,
      math_rm = 1,
    }
    
    -- Enable spell checking for LaTeX files
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = { "tex", "latex" },
      callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us,nl"
        
        -- Quick spell correction: Ctrl+L corrects previous spelling mistake
        vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", {
          desc = "Correct previous spelling mistake",
          silent = true,
          buffer = true,
        })
      end,
    })
  end,
})

-- Spell checking handled by VimTeX natively

-- Quarto support
table.insert(lvim.plugins, {
  "quarto-dev/quarto-nvim",
  ft = { "quarto", "markdown" },
  dependencies = {
    "jmbuhr/otter.nvim",
  },
  opts = {
    lspFeatures = {
      enabled = true,
      chunks = "curly",
      languages = { "r", "python", "julia", "bash", "lua", "html" },
      diagnostics = {
        enabled = true,
        triggers = { "BufWritePost" },
      },
      completion = {
        enabled = true,
      },
    },
    codeRunner = {
      enabled = true,
      default_method = "slime",
    },
  },
})

-- Vim-slime for REPL integration
table.insert(lvim.plugins, {
  "jpalardy/vim-slime",
  init = function()
    vim.b['quarto_is_python_chunk'] = false
    Quarto_is_in_python_chunk = function()
      require('otter.tools.functions').is_otter_language_context('python')
    end

    vim.cmd([[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
      return [a:text, "\n"]
      else
      return [a:text]
      end
      end
      endfunction
    ]])

    -- Default to tmux (send code to tmux pane)
    vim.g.slime_target = "tmux"
    vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
    vim.g.slime_no_mappings = true
    vim.g.slime_python_ipython = 1
  end,
  config = function()
    vim.g.slime_input_pid = false
    vim.g.slime_suggest_default = true
    vim.g.slime_menu_config = false
    vim.g.slime_dont_ask_default = 1  -- Don't ask for confirmation, use default pane

    local function mark_terminal()
      local job_id = vim.b.terminal_job_id
      vim.print('job_id: ' .. job_id)
    end

    local function set_terminal()
      vim.fn.call('slime#config', {})
    end

    local function toggle_slime_tmux_neovim()
      if vim.g.slime_target == "tmux" then
        vim.g.slime_target = "neovim"
        vim.print("Slime target: neovim")
      else
        vim.g.slime_target = "tmux"
        vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
        vim.print("Slime target: tmux")
      end
    end

    vim.keymap.set('n', '<leader>cm', mark_terminal, { desc = '[m]ark terminal' })
    vim.keymap.set('n', '<leader>cs', set_terminal, { desc = '[s]et terminal' })
    vim.keymap.set('n', '<leader>ct', toggle_slime_tmux_neovim, { desc = '[t]oggle slime tmux/neovim' })
  end,
})

-- Jupytext for opening ipynb files as quarto
table.insert(lvim.plugins, {
  "GCBallesteros/jupytext.nvim",
  opts = {
    custom_language_formatting = {
      python = {
        extension = "qmd",
        style = "quarto",
        force_ft = "quarto",
      },
      r = {
        extension = "qmd",
        style = "quarto",
        force_ft = "quarto",
      },
    },
  },
})

-- Nabla for math preview
table.insert(lvim.plugins, {
  "jbyuki/nabla.nvim",
  keys = {
    { "<leader>qm", ":lua require('nabla').toggle_virt()<cr>", desc = "toggle [m]ath equations" },
  },
})

-- Image clipboard support
table.insert(lvim.plugins, {
  "HakonHarnes/img-clip.nvim",
  event = "BufEnter",
  ft = { "markdown", "quarto", "latex" },
  opts = {
    default = {
      dir_path = "img",
    },
    filetypes = {
      markdown = {
        url_encode_path = true,
        template = "![$CURSOR]($FILE_PATH)",
        drag_and_drop = {
          download_images = false,
        },
      },
      quarto = {
        url_encode_path = true,
        template = "![$CURSOR]($FILE_PATH)",
        drag_and_drop = {
          download_images = false,
        },
      },
    },
  },
  config = function(_, opts)
    require("img-clip").setup(opts)
    vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
  end,
})

-- Image support for Molten
table.insert(lvim.plugins, {
  "3rd/image.nvim",
  dependencies = {
    "luarocks.nvim",
  },
  -- Only load in GUI or compatible terminals
  cond = function()
    return vim.fn.has('gui_running') == 1 or vim.env.DISPLAY or vim.env.TERM_PROGRAM == 'kitty'
  end,
  opts = {
    backend = "kitty",  -- or "ueberzug" or "auto"
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki", "quarto" },
      },
      neorg = {
        enabled = false,
      },
      html = {
        enabled = false,
      },
      css = {
        enabled = false,
      },
    },
    max_width = 100,
    max_height = 12,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = false,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    editor_only_render_when_focused = false,
    tmux_show_only_in_active_window = false,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
  },
  config = function(_, opts)
    require("image").setup(opts)
  end,
})

-- Luarocks for image.nvim
table.insert(lvim.plugins, {
  "vhyrro/luarocks.nvim",
  priority = 1001,
  opts = {
    rocks = { "magick" },
  },
})

-- Molten for Jupyter kernel integration
table.insert(lvim.plugins, {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  build = ":UpdateRemotePlugins",
  enabled = true,
  dependencies = {
    "3rd/image.nvim",
  },
  init = function()
    -- Set image provider based on environment
    if vim.fn.has('gui_running') == 1 or vim.env.DISPLAY or vim.env.TERM_PROGRAM == 'kitty' then
      vim.g.molten_image_provider = "image.nvim"
    else
      vim.g.molten_image_provider = "none"
    end
    vim.g.molten_auto_open_output = true
    vim.g.molten_auto_open_html_in_browser = true
    vim.g.molten_tick_rate = 200
  end,
  config = function()
    local function molten_init()
      local quarto_cfg = require("quarto.config").config
      quarto_cfg.codeRunner.default_method = "molten"
      vim.cmd([[MoltenInit]])
      vim.g.molten_initialized = true
      vim.print("Molten initialized - using Molten for cell execution")
    end
    local function molten_deinit()
      local quarto_cfg = require("quarto.config").config
      quarto_cfg.codeRunner.default_method = "slime"
      vim.cmd([[MoltenDeinit]])
      vim.g.molten_initialized = false
      vim.print("Molten stopped - using Slime for cell execution")
    end
    vim.keymap.set("n", "<localleader>mi", molten_init, { silent = true, desc = "Initialize molten" })
    vim.keymap.set("n", "<localleader>md", molten_deinit, { silent = true, desc = "Stop molten" })
    vim.keymap.set("n", "<localleader>mp", ":MoltenImagePopup<CR>", { silent = true, desc = "molten image popup" })
    vim.keymap.set("n", "<localleader>mb", ":MoltenOpenInBrowser<CR>", { silent = true, desc = "molten open in browser" })
    vim.keymap.set("n", "<localleader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "hide output" })
    vim.keymap.set("n", "<localleader>ms", ":noautocmd MoltenEnterOutput<CR>", { silent = true, desc = "show/enter output" })
  end,
})

-- Sidekick.nvim - AI sidekick with Copilot LSP integration
table.insert(lvim.plugins, {
  "folke/sidekick.nvim",
  opts = {
    -- CLI configuration
    cli = {
      mux = {
        backend = "tmux", -- or "zellij"
        enabled = true,
      },
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function()
        require("sidekick.cli").focus()
      end,
      desc = "Sidekick Switch Focus",
      mode = { "n", "v" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle({ focus = true })
      end,
      desc = "Sidekick Toggle CLI",
      mode = { "n", "v" },
    },
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Sidekick Claude Toggle",
      mode = { "n", "v" },
    },
    {
      "<leader>ag",
      function()
        require("sidekick.cli").toggle({ name = "grok", focus = true })
      end,
      desc = "Sidekick Grok Toggle",
      mode = { "n", "v" },
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").select_prompt()
      end,
      desc = "Sidekick Ask Prompt",
      mode = { "n", "v" },
    },
  },
})

-- nvim-peekup for register management
table.insert(lvim.plugins, {
  "gennaro-tedesco/nvim-peekup",
  init = function()
    -- Don't override the default "" binding, let the plugin use it
    -- Only set the paste variants
    vim.g.peekup_paste_before = '<leader>"P'
    vim.g.peekup_paste_after = '<leader>"p'
  end,
  config = function()
    -- Customize the peekup window appearance
    require('nvim-peekup.config').geometry["height"] = 0.6
    require('nvim-peekup.config').geometry["width"] = 0.6
    require('nvim-peekup.config').geometry["title"] = ' Registers '
    require('nvim-peekup.config').geometry["wrap"] = true

    -- Behavior configuration - this is critical for making paste work correctly
    require('nvim-peekup.config').on_keystroke["delay"] = ''  -- No delay
    require('nvim-peekup.config').on_keystroke["autoclose"] = true
    -- Use * register (system clipboard) - this is the default
    require('nvim-peekup.config').on_keystroke["paste_reg"] = '*'
  end,
})

-- render-markdown.nvim for better markdown rendering
table.insert(lvim.plugins, {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ft = { 'markdown', 'quarto' },
  opts = {
    file_types = { 'markdown', 'quarto' },
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
})
