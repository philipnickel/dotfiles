-- uv.nvim integration for uv-based Python workflows

return {
  "benomahony/uv.nvim",
  event = "VeryLazy",
  cmd = {
    "UVInit",
    "UVRunFile",
    "UVRunSelection",
    "UVRunFunction",
    "UVAddPackage",
    "UVRemovePackage",
  },
  keys = {
    { "<leader>up", mode = "n", desc = "uv command palette" },
    { "<leader>ui", mode = "n", desc = "uv init project" },
    { "<leader>ur", mode = "n", desc = "uv run file" },
    { "<leader>us", mode = "v", desc = "uv run selection" },
    { "<leader>uf", mode = "n", desc = "uv run function" },
    { "<leader>ue", mode = "n", desc = "uv environments" },
    { "<leader>ua", mode = "n", desc = "uv add package" },
    { "<leader>ud", mode = "n", desc = "uv remove package" },
    { "<leader>uc", mode = "n", desc = "uv sync packages" },
  },
  opts = {
    picker_integration = true,
    auto_activate_venv = true,
    notify_activate_venv = true,
    auto_commands = true,
    keymaps = false,
    execution = {
      run_command = "uv run python",
      notify_output = true,
      notification_timeout = 10000,
    },
  },
  config = function(_, opts)
    local ok, uv = pcall(require, "uv")
    if not ok then
      vim.notify("uv.nvim failed to load module 'uv'. Please check the plugin installation.", vim.log.levels.ERROR)
      return
    end

    if vim.fn.executable("uv") ~= 1 then
      vim.notify("uv binary not found in PATH. Install uv to use uv.nvim features.", vim.log.levels.WARN)
    end

    uv.setup(opts)

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
    end

    local function open_uv_commands()
      if _G.Snacks and _G.Snacks.picker then
        _G.Snacks.picker.pick("uv_commands")
        return
      end
      local has_telescope = pcall(require, "telescope")
      if has_telescope and uv.pick_uv_commands then
        uv.pick_uv_commands()
      else
        vim.notify(
          "UV command picker requires snacks.nvim or telescope.nvim",
          vim.log.levels.WARN
        )
      end
    end

    local function open_uv_venvs()
      if _G.Snacks and _G.Snacks.picker then
        _G.Snacks.picker.pick("uv_venv")
        return
      end
      local has_telescope = pcall(require, "telescope")
      if has_telescope and uv.pick_uv_venv then
        uv.pick_uv_venv()
      else
        vim.notify(
          "UV environment picker requires snacks.nvim or telescope.nvim",
          vim.log.levels.WARN
        )
      end
    end

    local function prompt_add_package()
      vim.ui.input({ prompt = "uv add package: " }, function(input)
        if input and input ~= "" then
          uv.run_command("uv add " .. input)
        end
      end)
    end

    local function prompt_remove_package()
      vim.ui.input({ prompt = "uv remove package: " }, function(input)
        if input and input ~= "" then
          uv.run_command("uv remove " .. input)
        end
      end)
    end

    map("n", "<leader>up", open_uv_commands, "UV command palette")
    map("n", "<leader>ui", "<cmd>UVInit<CR>", "UV init project")
    map("n", "<leader>ur", "<cmd>UVRunFile<CR>", "UV run current file")
    map("v", "<leader>us", ":<C-u>UVRunSelection<CR>", "UV run selection")
    map("n", "<leader>uf", "<cmd>UVRunFunction<CR>", "UV run function")
    map("n", "<leader>ue", open_uv_venvs, "UV virtual environments")
    map("n", "<leader>ua", prompt_add_package, "UV add package")
    map("n", "<leader>ud", prompt_remove_package, "UV remove package")
    map("n", "<leader>uc", function()
      uv.run_command("uv sync")
    end, "UV sync packages")

  end,
}
