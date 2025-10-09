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
    { "<leader>UU", mode = "n", desc = "UV command palette" },
    { "<leader>Ui", mode = "n", desc = "UV init project" },
    { "<leader>Ur", mode = "n", desc = "UV run file" },
    { "<leader>Us", mode = "v", desc = "UV run selection" },
    { "<leader>Uf", mode = "n", desc = "UV run function" },
    { "<leader>Ue", mode = "n", desc = "UV environments" },
    { "<leader>Ua", mode = "n", desc = "UV add package" },
    { "<leader>Ud", mode = "n", desc = "UV remove package" },
    { "<leader>Uc", mode = "n", desc = "UV sync packages" },
    { "<leader>UC", mode = "n", desc = "UV sync everything" },
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
    local uv = require("uv")
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

    map("n", "<leader>UU", open_uv_commands, "UV command palette")
    map("n", "<leader>Ui", "<cmd>UVInit<CR>", "UV init project")
    map("n", "<leader>Ur", "<cmd>UVRunFile<CR>", "UV run current file")
    map("v", "<leader>Us", ":<C-u>UVRunSelection<CR>", "UV run selection")
    map("n", "<leader>Uf", "<cmd>UVRunFunction<CR>", "UV run function")
    map("n", "<leader>Ue", open_uv_venvs, "UV virtual environments")
    map("n", "<leader>Ua", prompt_add_package, "UV add package")
    map("n", "<leader>Ud", prompt_remove_package, "UV remove package")
    map("n", "<leader>Uc", function()
      uv.run_command("uv sync")
    end, "UV sync packages")
    map("n", "<leader>UC", function()
      uv.run_command("uv sync --all-extras --all-packages --all-groups")
    end, "UV sync extras/groups")
  end,
}
