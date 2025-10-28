-- lua/plugins/snacks-dashboard.lua
return {
  "folke/snacks.nvim",
  -- If you already use Snacks elsewhere, this will merge opts.
  event = "VimEnter",
  opts = function(_, opts)
    opts = opts or {}

    -- Helper: check external tools
    local function has(exe)
      return vim.fn.executable(exe) == 1
    end

    -- ---------- Dashboard ----------
    local db = opts.dashboard or {}

    -- Layout / formatting defaults
    db.width = db.width or 60
    db.pane_gap = db.pane_gap or 4
    db.preset = db.preset or {}

    -- Header (feel free to swap the ASCII)
    db.preset.header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]

    -- Default keys on the board (works with fzf-lua/telescope/mini.pick)
    db.preset.keys = db.preset.keys or {
      { icon = " ", key = "f", desc = "Find File",  action = ":lua Snacks.dashboard.pick('files')" },
      { icon = " ", key = "n", desc = "New File",   action = ":ene | startinsert" },
      { icon = " ", key = "g", desc = "Find Text",  action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = " ", key = "r", desc = "Recent",     action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = " ", key = "c", desc = "Config",     action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
      { icon = "󰒲 ", key = "L", desc = "Lazy",       action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "q", desc = "Quit",       action = ":qa" },
    }

    -- GitHub/Git panes (enabled only inside a git repo)
    local function github_sections()
      local in_git = require("snacks").git.get_root() ~= nil
      local items = {
        {
          title = "Notifications",
          icon = " ",
          key = "n",
          height = 5,
          cmd = "gh notify -s -a -n5",
          action = function()
            vim.ui.open("https://github.com/notifications")
          end,
          enabled = in_git and has("gh"),
        },
        {
          title = "Open Issues",
          icon = " ",
          key = "i",
          height = 7,
          cmd = "gh issue list -L 3",
          action = function()
            vim.fn.jobstart("gh issue list --web", { detach = true })
          end,
          enabled = in_git and has("gh"),
        },
        {
          title = "Open PRs",
          icon = " ",
          key = "P",
          height = 7,
          cmd = "gh pr list -L 3",
          action = function()
            vim.fn.jobstart("gh pr list --web", { detach = true })
          end,
          enabled = in_git and has("gh"),
        },
        {
          title = "Git Status",
          icon = " ",
          height = 10,
          cmd = "git --no-pager diff --stat -B -M -C",
          enabled = in_git and has("git"),
        },
      }
      -- decorate as terminal sections in pane 2
      return vim.tbl_map(function(it)
        return vim.tbl_extend("force", {
          pane = 2,
          section = "terminal",
          padding = 1,
          indent = 3,
          ttl = 5 * 60,
        }, it)
      end, items)
    end

    -- Nice color splash (optional; guarded if not installed)
    local colorscript = {
      pane = 2,
      section = "terminal",
      cmd = "colorscript -e square",
      height = 5,
      padding = 1,
      enabled = has("colorscript"),
    }

    -- Final dashboard sections (header, keys, GH panes, startup)
    db.sections = db.sections or {
      { section = "header" },
      colorscript,
      { section = "keys", gap = 1, padding = 1 },
      {
        pane = 2,
        icon = " ",
        desc = "Browse Repo",
        padding = 1,
        key = "b",
        action = function()
          require("snacks").gitbrowse()
        end,
        enabled = function()
          return require("snacks").git.get_root() ~= nil
        end,
      },
      github_sections,
      { section = "startup" },
    }

    -- Open dashboard on empty start
    db.enabled = db.enabled ~= false
    opts.dashboard = db

    -- ---------- Optional: style tweaks ----------
    local styles = opts.styles or {}
    styles.dashboard = styles.dashboard or {
      zindex = 10,
      bo = { filetype = "snacks_dashboard" },
      wo = {
        number = false,
        relativenumber = false,
        signcolumn = "no",
        list = false,
        wrap = false,
        cursorline = false,
        statusline = "",
        winbar = "",
      },
    }
    opts.styles = styles

    return opts
  end,

  keys = {
    -- Manual open / refresh
    { "<leader>ud", function() require("snacks").dashboard.open() end, desc = "Open Dashboard" },
    { "<leader>uD", function() require("snacks").dashboard.update() end, desc = "Refresh Dashboard" },
  },

  init = function()
    -- Open dashboard only when starting with no file and no stdin
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc(-1) == 0 and vim.fn.line2byte("$") == -1 then
          require("snacks").dashboard.setup()
        end
      end,
    })
  end,
}
