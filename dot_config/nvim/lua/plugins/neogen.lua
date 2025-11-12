
return {
  "danymat/neogen",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- Keymaps: generate for current node, or force class
  keys = {
    { "<leader>cn", function() require("neogen").generate() end, desc = "Neogen: Generate annotation" },
    { "<leader>cN", function() require("neogen").generate({ type = "class" }) end, desc = "Neogen: Class annotation" },
  },
  opts = function()
    -- Pick a snippet engine if you have one; fall back to built-in jumps
    local engine = (pcall(require, "luasnip") and "luasnip")
      or (pcall(require, "mini.snippets") and "mini")
      or (pcall(require, "snippy") and "snippy")
      or (vim.fn.exists("*vsnip#anonymous") == 1 and "vsnip")
      or "nvim"

    return {
      enabled = true,
      input_after_comment = true,
      snippet_engine = engine, -- lets you <Tab> through fields if your engine supports it
      languages = {
        python = {
          template = {
            -- 🔧 This is the important bit: use NumPy-style docstrings
            annotation_convention = "numpydoc",
          },
        },
      },
    }
  end,
}
