-- lua/plugins/tmux-navigation.lua
return {
  "alexghergh/nvim-tmux-navigation",
  opts = {
    disable_when_zoomed = true, -- defaults to false
  },
  keys = {
    {
      "<C-h>",
      function()
        require("nvim-tmux-navigation").NvimTmuxNavigateLeft()
      end,
      desc = "Tmux left",
    },
    {
      "<C-j>",
      function()
        require("nvim-tmux-navigation").NvimTmuxNavigateDown()
      end,
      desc = "Tmux down",
    },
    {
      "<C-k>",
      function()
        require("nvim-tmux-navigation").NvimTmuxNavigateUp()
      end,
      desc = "Tmux up",
    },
    {
      "<C-l>",
      function()
        require("nvim-tmux-navigation").NvimTmuxNavigateRight()
      end,
      desc = "Tmux right",
    },
    {
      "<C-\\>",
      function()
        require("nvim-tmux-navigation").NvimTmuxNavigateLastActive()
      end,
      desc = "Tmux last",
    },
    {
      "<C-Space>",
      function()
        require("nvim-tmux-navigation").NvimTmuxNavigateNext()
      end,
      desc = "Tmux next",
    },
  },
  config = function(_, opts)
    require("nvim-tmux-navigation").setup(opts)
  end,
}
