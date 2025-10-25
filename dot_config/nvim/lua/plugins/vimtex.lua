-- lua/plugins/vimtex.lua
return {
  {
    "lervag/vimtex",
    -- NOTE: inverse search breaks when lazy-loaded, so load immediately
    lazy = false,
    -- version = "v2.15", -- uncomment ONLY if you specifically need this older release
    init = function()
      -- --- Viewer: OpusReader (Sioyek) ---
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_view_sioyek_exe = "opusreader"

      -- Forward search options when opening Sioyek/OpusReader
      -- (new window + inverse-search command that calls Neovim)
      --vim.g.vimtex_view_sioyek_options =
      --  [[--new-window --inverse-search "nvim +%2 \"%1\""]]

      -- Inverse search command used by Sioyek -> Neovim
      -- Keep this in sync with your Sioyek/OpusReader config if you set it there.
      --vim.g.vimtex_view_sioyek_inverse_search = [[nvim +%2 "%1"]]

      -- --- Compiler ---
--      vim.g.vimtex_quickfix_mode = 0
 --     vim.g.vimtex_compiler_latexmk = {
--        build_dir = "build",
 --       options = {
--          "-pdf",
--          "-interaction=nonstopmode",
 --         "-file-line-error",
--        "-synctex=1",
 --         "-verbose",
  --      },
 --     }

      vim.g.vimtex_quickfix_mode = 0

      vim.g.vimtex_compiler_latexmk = {
        build_dir = "build",
        options = {
          "-pdf",
          "-file-line-error",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-use-make",
          "-quiet",
        },
      }


      -- --- Folding / Syntax / Conceal ---
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_fold_manual = 1

      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_syntax_conceal_disable = 0
      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        ligatures = 1,
        cites = 1,
        greek = 1,
        math_bounds = 1,
        math_delimiters = 1,
        math_fracs = 1,
        math_super_sub = 1,
        math_symbols = 1,
        sections = 1,
        spacing = 0,
        styles = 1,
      }

      -- Disable VimTeX's K (conflicts with LSP hover)
      vim.g.vimtex_mappings_disable = { n = { "K" } }

      -- Prefer pplatex quickfix parser if available (cleaner logs)
      vim.g.vimtex_quickfix_method =
        (vim.fn.executable("pplatex") == 1) and "pplatex" or "latexlog"

      -- --- FileType autocmds for TeX ---
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us"

          -- Spelling correction helpers (Normal & Insert)
          vim.keymap.set("n", "<C-c>", "z=", { buffer = true, desc = "Correct spelling" })
          vim.keymap.set(
            "i",
            "<C-c>",
            '<c-g>u<Esc>[s1z=`]a<c-g>u',
            { buffer = true, desc = "Correct last spelling mistake" }
          )
        end,
      })
    end,
    keys = {
      -- Which-key group label under <localleader>l (LazyVim sets <localleader> = "\\")
      { "<localleader>l", "", desc = "+vimtex", ft = "tex" },
      -- Add your favorite vimtex mappings here if you want explicit labels, e.g.:
      -- { "<localleader>ll", "<cmd>VimtexCompile<cr>", desc = "Compile", ft = "tex" },
      -- { "<localleader>lv", "<cmd>VimtexView<cr>",    desc = "View (OpusReader)", ft = "tex" },
    },
  },
}
