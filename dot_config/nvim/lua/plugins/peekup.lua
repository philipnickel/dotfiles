-- nvim-peekup for register management

return {
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
}