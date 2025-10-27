-- lua/plugins/snacks-scroll.lua
return {
  -- Smooth scrolling via Snacks
  "folke/snacks.nvim",
  -- If you already use Snacks for other features, this merges in `scroll` opts.
  opts = function(_, opts)
    opts = opts or {}

    -- Keep anything you already configured on Snacks
    local scroll_cfg = opts.scroll or {}

    -- Defaults from the docs, tweak if you like
    scroll_cfg.animate = scroll_cfg.animate or {
      duration = { step = 15, total = 250 },
      easing = "linear",
    }

    -- Faster animation when repeating (e.g. holding <C-d>/<C-u>)
    scroll_cfg.animate_repeat = scroll_cfg.animate_repeat or {
      delay = 100, -- ms before "repeat" animation kicks in
      duration = { step = 5, total = 50 },
      easing = "linear",
    }

    -- Only animate in normal buffers; allow global/buffer toggles
    scroll_cfg.filter = scroll_cfg.filter or function(buf)
      return vim.g.snacks_scroll ~= false
        and vim.b[buf].snacks_scroll ~= false
        and vim.bo[buf].buftype ~= "terminal"
    end

    opts.scroll = scroll_cfg
    return opts
  end,

  keys = {
    -- Toggle smooth scrolling globally (uses the filter above)
    {
      "<leader>uS",
      function()
        vim.g.snacks_scroll = vim.g.snacks_scroll == false and true or false
        vim.notify(
          ("Snacks scroll: %s"):format(vim.g.snacks_scroll == false and "OFF" or "ON"),
          vim.g.snacks_scroll == false and vim.log.levels.WARN or vim.log.levels.INFO
        )
      end,
      desc = "Toggle Smooth Scroll (Snacks)",
    },
  },

  -- If you also have other scrolling plugins, disable them to avoid double animations.
  -- Example (uncomment if applicable):
  -- dependencies = { { "karb94/neoscroll.nvim", enabled = false }, { "echasnovski/mini.animate", enabled = false } },
}
