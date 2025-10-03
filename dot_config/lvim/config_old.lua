-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
--
--
--
lvim.transparent_window = true

vim.opt.relativenumber = false
vim.opt.wrap = true

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

table.insert(lvim.plugins, {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function() vim.fn["mkdp#util#install"]() end,
})


-- REPL integration with vim-slime
table.insert(lvim.plugins, {
  "jpalardy/vim-slime",
  config = function()
    vim.g.slime_target = "tmux"
    vim.g.slime_default_config = {
      socket_name = "default",
      target_pane = "{last}",
    }
    vim.g.slime_dont_ask_default = 1
    vim.g.slime_no_mappings = 1
  end,
})

-- Enhanced Telescope extensions for better search
table.insert(lvim.plugins, {
  "nvim-telescope/telescope-live-grep-args.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    vim.defer_fn(function()
      local telescope = require("telescope")
      if telescope and telescope.load_extension then
        telescope.load_extension("live_grep_args")
      end
    end, 100)
  end,
})

table.insert(lvim.plugins, {
  "nvim-telescope/telescope-fzf-native.nvim",
  build = "make",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    vim.defer_fn(function()
      local telescope = require("telescope")
      if telescope and telescope.load_extension then
        telescope.load_extension("fzf")
      end
    end, 100)
  end,
})


table.insert(lvim.plugins, {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
})




-- Markdown preview key binding
lvim.keys.normal_mode["<leader>mp"] = "<cmd>MarkdownPreviewToggle<cr>"


-- vim-slime keybindings for REPL interaction
lvim.keys.normal_mode["<leader>ss"] = "<Plug>SlimeLineSend"
lvim.keys.visual_mode["<leader>ss"] = "<Plug>SlimeRegionSend"
lvim.keys.normal_mode["<leader>sp"] = "<Plug>SlimeParagraphSend"
lvim.keys.normal_mode["<leader>sc"] = "<Plug>SlimeConfig"

-- Which-key descriptions for better discoverability
lvim.builtin.which_key.mappings["m"] = {
  name = "Markdown",
  p = { "<cmd>MarkdownPreviewToggle<cr>", "Toggle Preview" },
}


lvim.builtin.which_key.mappings["s"] = {
  name = "REPL/Slime",
  s = { "<Plug>SlimeLineSend", "Send Line/Selection" },
  p = { "<Plug>SlimeParagraphSend", "Send Paragraph" },
  c = { "<Plug>SlimeConfig", "Configure Slime" },
}

-- LaTeX/VimTeX keybindings (using local leader, which is '\' by default)
lvim.builtin.which_key.mappings["l"] = {
  name = "LaTeX",
  l = { "<cmd>VimtexCompile<cr>", "Compile" },
  v = { "<cmd>VimtexView<cr>", "View PDF" },
  k = { "<cmd>VimtexStop<cr>", "Stop" },
  c = { "<cmd>VimtexClean<cr>", "Clean" },
  C = { "<cmd>VimtexClean!<cr>", "Clean All" },
  s = { "<cmd>VimtexStatus<cr>", "Status" },
  i = { "<cmd>VimtexInfo<cr>", "Info" },
  t = { "<cmd>VimtexTocToggle<cr>", "Toggle TOC" },
  T = { "<cmd>VimtexTocOpen<cr>", "Open TOC" },
  w = { "<cmd>VimtexCountWords<cr>", "Count Words" },
  e = { "<cmd>VimtexErrors<cr>", "Show Errors" },
}

-- Code block creation helpers
local function insert_code_block(lang)
  local lines = {
    "```{" .. lang .. "}",
    "",
    "```"
  }
  vim.api.nvim_put(lines, "l", true, true)
  vim.api.nvim_feedkeys("k", "n", false)
end

lvim.builtin.which_key.mappings["c"] = {
  name = "Code Blocks",
  r = { function() insert_code_block("r") end, "R Block" },
  p = { function() insert_code_block("python") end, "Python Block" },
  j = { function() insert_code_block("julia") end, "Julia Block" },
  b = { function() insert_code_block("bash") end, "Bash Block" },
  s = { function() insert_code_block("sql") end, "SQL Block" },
  m = { function() insert_code_block("mermaid") end, "Mermaid Block" },
  c = { function()
    local lang = vim.fn.input("Language: ")
    if lang ~= "" then
      insert_code_block(lang)
    end
  end, "Custom Block" },
}

-- Enhanced Find menu - override default <leader>f
lvim.builtin.which_key.mappings["f"] = {
  name = "Find",
  f = { "<cmd>Telescope find_files<cr>", "Files" },
  g = { function() require("telescope").extensions.live_grep_args.live_grep_args() end, "Grep" },
  w = { "<cmd>Telescope grep_string<cr>", "Word under cursor" },
  b = { "<cmd>Telescope buffers<cr>", "Buffers" },
  r = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
  G = { "<cmd>Telescope git_files<cr>", "Git files" },
  h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
  c = { "<cmd>Telescope commands<cr>", "Commands" },
  s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
  S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace symbols" },
  d = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
  k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
  m = { "<cmd>Telescope marks<cr>", "Marks" },
  j = { "<cmd>Telescope jumplist<cr>", "Jump list" },
  q = { "<cmd>Telescope quickfix<cr>", "Quickfix" },
  l = { "<cmd>Telescope loclist<cr>", "Location list" },
}

-- Filetype detection
vim.filetype.add({
  extension = {
    tex = "tex",
    latex = "tex",
  },
  pattern = {
    ["*.tex"] = "tex",
    ["*.latex"] = "tex",
  },
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tex", "*.latex" },
  callback = function(args)
    vim.api.nvim_buf_set_option(args.buf, "filetype", "tex")
  end,
})

-- Enhanced telescope configuration
lvim.builtin.telescope.defaults.file_ignore_patterns = {
  "%.git/",
  "node_modules/",
  "%.npm/",
  "%.next/",
  "%.DS_Store",
}

-- Ensure our find menu overrides the default
vim.api.nvim_create_autocmd("User", {
  pattern = "LunarVimColorSchemeLoaded",
  callback = function()
    -- Remove default find_files binding to avoid conflicts
    lvim.keys.normal_mode["<leader>f"] = nil
  end,
})

-- Configure nvim-tree to open PDFs with Zathura
lvim.builtin.nvimtree.setup.system_open = {
  cmd = "open", -- This will be overridden by our custom function
}

-- Configure nvim-tree the LunarVim way using on_config_done callback
lvim.builtin.nvimtree.on_config_done = function()
  -- Custom function to handle PDF files in nvim-tree
  local function nvim_tree_on_attach(bufnr)
    local api = require("nvim-tree.api")

    -- First, apply default nvim-tree keybindings
    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Apply all default nvim-tree keybindings
    require("nvim-tree.api").config.mappings.default_on_attach(bufnr)

    local function open_file_with_system()
      local node = api.tree.get_node_under_cursor()
      if node and node.absolute_path then
        -- Handle PDFs with Zathura
        if node.absolute_path:match("%.pdf$") then
          vim.fn.jobstart({ "zathura", node.absolute_path }, { detach = true })
        -- Handle images with Preview (via 'open' command)
        elseif node.absolute_path:match("%.png$") or
               node.absolute_path:match("%.jpe?g$") or
               node.absolute_path:match("%.gif$") or
               node.absolute_path:match("%.bmp$") or
               node.absolute_path:match("%.tiff?$") or
               node.absolute_path:match("%.webp$") then
          vim.fn.jobstart({ "open", node.absolute_path }, { detach = true })
        else
          api.node.open.edit()
        end
      end
    end

    -- Override only the specific keybindings for Enter and 'o' for PDF/image handling
    vim.keymap.set('n', '<CR>', open_file_with_system, opts('Open: PDFs with Zathura, Images with Preview'))
    vim.keymap.set('n', 'o', open_file_with_system, opts('Open: PDFs with Zathura, Images with Preview'))
  end

  require("nvim-tree").setup({
    filters = {
      dotfiles = false,
      custom = {
        "__pycache__",
        "*.pyc",
        ".DS_Store",
        "^\\.git$"
      }
    },
    filesystem_watchers = {
      enable = true,
    },
    actions = {
      use_system_clipboard = true,
      change_dir = {
        enable = true,
        global = false,
      },
      open_file = {
        quit_on_open = false,
        resize_window = false,
      },
      remove_file = {
        close_window = true,
      },
    },
    on_attach = nvim_tree_on_attach,
  })
end

-- Treesitter configuration for LaTeX
vim.list_extend(lvim.builtin.treesitter.ensure_installed, {
  "markdown",
  "markdown_inline",
  "yaml",
  "html",
  "css",
  "javascript",
  "typescript",
  "lua",
  "latex",
  "bibtex",
})

-- Pick a PDF viewer that is available on the system
local function pick_vimtex_viewer()
  if vim.fn.executable("zathura") == 1 then
    if vim.env.DBUS_SESSION_BUS_ADDRESS and vim.env.DBUS_SESSION_BUS_ADDRESS ~= "" then
      return "zathura"
    end
    return "zathura_simple"
  end

  if vim.fn.executable("sioyek") == 1 then
    return "sioyek"
  end

  local uname = vim.loop.os_uname().sysname
  if uname == "Darwin" and vim.fn.executable("open") == 1 then
    vim.g.vimtex_view_general_viewer = "open"
    vim.g.vimtex_view_general_options = "-a Preview"
    return "general"
  end

  if vim.fn.executable("xdg-open") == 1 then
    vim.g.vimtex_view_general_viewer = "xdg-open"
    vim.g.vimtex_view_general_options = ""
    return "general"
  end

  return nil -- fall back to VimTeX defaults if nothing sensible found
end

local vimtex_view_method = pick_vimtex_viewer()
if vimtex_view_method then
  vim.g.vimtex_view_method = vimtex_view_method

  if vimtex_view_method == "zathura" then
    vim.g.vimtex_view_zathura_use_synctex = 1
  elseif vimtex_view_method == "zathura_simple" then
    vim.g.vimtex_view_zathura_use_synctex = 0
  end
end
vim.g.tex_flavor = 'latex'
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_compiler_progname = 'nvr'
vim.g.vimtex_compiler_latexmk = {
  build_dir = '',
  callback = 1,
  continuous = 1,
  executable = 'latexmk',
  hooks = {},
  options = {
    '-verbose',
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode',
  },
}

-- VimTeX plugin installation
table.insert(lvim.plugins, {
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  config = function()
    -- VimTeX is now loaded - no additional config needed
    -- since we set the global variables above
  end
})

-- Load custom LuaSnip snippets
local ok_luasnip, luasnip_loader = pcall(require, 'luasnip.loaders.from_lua')
if ok_luasnip then
  local snippet_path = vim.fn.stdpath('config') .. '/luasnippets'
  luasnip_loader.lazy_load({ paths = snippet_path })
end

-- Configure Telescope to open PDFs with Zathura and images with Preview
local function open_with_system_app(prompt_bufnr)
  local selection = require("telescope.actions.state").get_selected_entry()
  require("telescope.actions").close(prompt_bufnr)
  if selection and selection.path then
    -- Handle PDFs with Zathura
    if selection.path:match("%.pdf$") then
      vim.fn.jobstart({ "zathura", selection.path }, { detach = true })
    -- Handle images with Preview
    elseif selection.path:match("%.png$") or
           selection.path:match("%.jpe?g$") or
           selection.path:match("%.gif$") or
           selection.path:match("%.bmp$") or
           selection.path:match("%.tiff?$") or
           selection.path:match("%.webp$") then
      vim.fn.jobstart({ "open", selection.path }, { detach = true })
    else
      vim.cmd("edit " .. selection.path)
    end
  end
end

-- Override default file open action for telescope
lvim.builtin.telescope.defaults.mappings = {
  i = {
    ["<CR>"] = function(prompt_bufnr)
      local selection = require("telescope.actions.state").get_selected_entry()
      if selection and selection.path and (
        selection.path:match("%.pdf$") or
        selection.path:match("%.png$") or
        selection.path:match("%.jpe?g$") or
        selection.path:match("%.gif$") or
        selection.path:match("%.bmp$") or
        selection.path:match("%.tiff?$") or
        selection.path:match("%.webp$")
      ) then
        open_with_system_app(prompt_bufnr)
      else
        require("telescope.actions").select_default(prompt_bufnr)
      end
    end,
  },
  n = {
    ["<CR>"] = function(prompt_bufnr)
      local selection = require("telescope.actions.state").get_selected_entry()
      if selection and selection.path and (
        selection.path:match("%.pdf$") or
        selection.path:match("%.png$") or
        selection.path:match("%.jpe?g$") or
        selection.path:match("%.gif$") or
        selection.path:match("%.bmp$") or
        selection.path:match("%.tiff?$") or
        selection.path:match("%.webp$")
      ) then
        open_with_system_app(prompt_bufnr)
      else
        require("telescope.actions").select_default(prompt_bufnr)
      end
    end,
  },
}
