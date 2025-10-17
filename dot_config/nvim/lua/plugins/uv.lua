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
    "UVToolInstall",
    "UVToolRun",
    "UVToolUpgrade",
    "UVToolList",
    "UVToolRemove",
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
    -- Tool management keymaps
    { "<leader>ut", mode = "n", desc = "uv tools picker" },
    { "<leader>uti", mode = "n", desc = "uv tool install" },
    { "<leader>utr", mode = "n", desc = "uv tool run" },
    { "<leader>utu", mode = "n", desc = "uv tool upgrade" },
    { "<leader>utl", mode = "n", desc = "uv tool list" },
    { "<leader>utd", mode = "n", desc = "uv tool remove" },
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

    -- Tool management functions
    local function open_uv_tools()
      if _G.Snacks and _G.Snacks.picker then
        _G.Snacks.picker.pick("uv_tools")
        return
      end
      local has_telescope = pcall(require, "telescope")
      if has_telescope and uv.pick_uv_tools then
        uv.pick_uv_tools()
      else
        vim.notify(
          "UV tool picker requires snacks.nvim or telescope.nvim",
          vim.log.levels.WARN
        )
      end
    end

    local function prompt_install_tool()
      vim.ui.input({ 
        prompt = "uv tool install (package[@version]): ",
        default = "",
        completion = "file"
      }, function(input)
        if input and input ~= "" then
          local cmd = "uv tool install " .. input
          uv.run_command(cmd)
        end
      end)
    end

    local function prompt_run_tool()
      vim.ui.input({ 
        prompt = "uv tool run (tool[@version]): ",
        default = "",
        completion = "file"
      }, function(input)
        if input and input ~= "" then
          local cmd = "uv tool run " .. input
          uv.run_command(cmd)
        end
      end)
    end

    local function prompt_upgrade_tool()
      vim.ui.input({ 
        prompt = "uv tool upgrade (tool name): ",
        default = "",
        completion = "file"
      }, function(input)
        if input and input ~= "" then
          local cmd = "uv tool upgrade " .. input
          uv.run_command(cmd)
        end
      end)
    end

    local function list_installed_tools()
      uv.run_command("uv tool list")
    end

    local function prompt_remove_tool()
      vim.ui.input({ 
        prompt = "uv tool remove (tool name): ",
        default = "",
        completion = "file"
      }, function(input)
        if input and input ~= "" then
          local cmd = "uv tool remove " .. input
          uv.run_command(cmd)
        end
      end)
    end

    local function run_tool_with_args()
      vim.ui.input({ 
        prompt = "uv tool run (tool[@version] [args]): ",
        default = "",
        completion = "file"
      }, function(input)
        if input and input ~= "" then
          local cmd = "uv tool run " .. input
          uv.run_command(cmd)
        end
      end)
    end

    -- Create custom commands
    vim.api.nvim_create_user_command("UVToolInstall", prompt_install_tool, { desc = "Install a uv tool" })
    vim.api.nvim_create_user_command("UVToolRun", run_tool_with_args, { desc = "Run a uv tool with arguments" })
    vim.api.nvim_create_user_command("UVToolUpgrade", prompt_upgrade_tool, { desc = "Upgrade a uv tool" })
    vim.api.nvim_create_user_command("UVToolList", list_installed_tools, { desc = "List installed uv tools" })
    vim.api.nvim_create_user_command("UVToolRemove", prompt_remove_tool, { desc = "Remove a uv tool" })

    -- Original keymaps
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

    -- Tool management keymaps
    map("n", "<leader>ut", open_uv_tools, "UV tools picker")
    map("n", "<leader>uti", prompt_install_tool, "UV tool install")
    map("n", "<leader>utr", run_tool_with_args, "UV tool run")
    map("n", "<leader>utu", prompt_upgrade_tool, "UV tool upgrade")
    map("n", "<leader>utl", list_installed_tools, "UV tool list")
    map("n", "<leader>utd", prompt_remove_tool, "UV tool remove")

  end,
}
