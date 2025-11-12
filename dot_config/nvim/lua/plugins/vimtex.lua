-- Simplified VimTeX config
return {
  -- VimTeX: LaTeX compilation & viewing
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      -- Viewer: OpusReader (Sioyek)
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_view_sioyek_exe = "opusreader"

      -- Compiler: latexmk with build directory
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "build",
        options = {
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-quiet",
        },
      }

      -- Disable quickfix auto-open
      vim.g.vimtex_quickfix_mode = 0

      -- Disable folding (performance)
      vim.g.vimtex_fold_enabled = 0

      -- Disable conceal (performance)
      vim.g.vimtex_syntax_conceal_disable = 1

      -- Don't override K
      vim.g.vimtex_mappings_disable = { n = { "K" } }

      -- Spell checking for .tex files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us"
        end,
      })
    end,
  },
}
