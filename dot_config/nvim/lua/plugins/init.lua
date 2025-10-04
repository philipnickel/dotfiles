-- Plugin manager initialization
-- Using lazy.nvim as the plugin manager

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Import all plugin configurations
  { import = "plugins.nordic" },
  { import = "plugins.noice" },
  { import = "plugins.neoclip" },
  { import = "plugins.flash" },
  { import = "plugins.surround" },
  { import = "plugins.chezmoi" },
  { import = "plugins.copilot" },
  { import = "plugins.markdown" },
  { import = "plugins.tmux" },
  { import = "plugins.vimtex" },
  { import = "plugins.quarto" },
  { import = "plugins.slime" },
  { import = "plugins.jupytext" },
  { import = "plugins.nabla" },
  { import = "plugins.img-clip" },
  { import = "plugins.image" },
  { import = "plugins.avante" },
  { import = "plugins.lazygit" },
  { import = "plugins.peekup" },
  { import = "plugins.render-markdown" },
  { import = "plugins.luasnip" },
  { import = "plugins.luasnip-latex" },
  { import = "plugins.dashboard" },
  { import = "plugins.neo-tree" },
  { import = "plugins.lsp" },
  { import = "plugins.cmp" },
  { import = "plugins.treesitter" },
  { import = "plugins.undotree" },
  { import = "plugins.gitsigns" },
        { import = "plugins.indent-blankline" },
        { import = "plugins.lualine" },
        { import = "plugins.toggleterm" },
        { import = "plugins.aerial" },
  
  -- Telescope (essential for navigation)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
      })
    end,
  },
  
  -- Import which-key configuration
  { import = "plugins.which-key" },
  
  -- Undotree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  
}, {
  install = { colorscheme = { "nordic" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
