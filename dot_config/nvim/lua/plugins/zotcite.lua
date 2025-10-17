-- Zotcite configuration for Zotero integration

local function zotcli_available()
  return vim.fn.executable("zotcli") == 1
end

return {
  "jalvesaq/zotcite",
  branch = "master",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "jmbuhr/telescope-zotero.nvim",
      dependencies = { "kkharji/sqlite.lua" },
      opts = {},
      config = function()
        local ok, telescope = pcall(require, "telescope")
        if ok then
          telescope.load_extension("zotero")
        end
      end,
    },
  },
  config = function()
    local opts = {
      open_in_zotero = true,
      bib_and_vt = {
        markdown = true,
        quarto = true,
        rmd = true,
        typst = true,
      },
    }

    require("zotcite").setup(opts)

    local hl = require("zotcite.hl")
    local config_mod = require("zotcite.config")
    local supported_filetypes = {
      "latex",
      "markdown",
      "pandoc",
      "quarto",
      "rmd",
      "rnoweb",
      "typst",
      "vimwiki",
      "tex",
    }

    if not hl._citations_wrapped then
      hl._citations_wrapped = true
      local orig_citations = hl.citations
      hl.citations = function(...)
        local cfg = config_mod.get_config()
        if not (cfg and cfg.zrunning) then
          return
        end
        local ok, err = pcall(orig_citations, ...)
        if not ok then
          vim.notify(err, vim.log.levels.ERROR, { title = "zotcite" })
        end
      end
    end

    local function open_zotero_picker()
      local ok_telescope, telescope = pcall(require, "telescope")
      if not ok_telescope then
        vim.notify("telescope not available", vim.log.levels.ERROR, { title = "zotcite" })
        return
      end
      local ok_extension, err = pcall(telescope.extensions.zotero.citations)
      if not ok_extension then
        vim.notify("failed to open Zotero picker: " .. err, vim.log.levels.ERROR, { title = "zotcite" })
      end
    end

    local ok_wk, wk = pcall(require, "which-key")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = supported_filetypes,
      callback = function(event)
        vim.keymap.set(
          "n",
          "<leader>fz",
          open_zotero_picker,
          { buffer = event.buf, silent = true, desc = "Zotero: find citation" }
        )
        if ok_wk then
          wk.add({ { "<leader>fz", desc = "Zotero: find citation" } }, { buffer = event.buf })
        end
      end,
    })

    if ok_wk then
      wk.add({ { "<leader>z", group = "Zotcite" } })
    end

    if not zotcli_available() then
      return
    end

    local function run_zotcli(args, on_success)
      vim.system(vim.list_extend({ "zotcli" }, args), { text = true }, function(obj)
        if obj.code ~= 0 then
          local msg = "zotcli failed (exit code " .. obj.code .. ")"
          if obj.stderr and obj.stderr ~= "" then
            msg = msg .. "\n" .. obj.stderr
          end
          vim.schedule(function()
            vim.notify(msg, vim.log.levels.ERROR, { title = "zotcite" })
          end)
          return
        end
        if on_success then
          vim.schedule(function() on_success(obj.stdout or "") end)
        end
      end)
    end

    local function citation_key_or_prompt()
      local key = ""
      local ok_get, get = pcall(require, "zotcite.get")
      if ok_get then
        key = get.citation_key() or ""
      end
      if key ~= "" then
        return key
      end
      return vim.fn.input("Zotero query: ")
    end

    local function read_attachment(query)
      query = query or citation_key_or_prompt()
      if not query or query == "" then
        return
      end
      run_zotcli({ "read", query })
    end

    vim.api.nvim_create_user_command("ZotCliRead", function(cmd)
      read_attachment(cmd.args ~= "" and cmd.args or nil)
    end, {
      nargs = "?",
      desc = "Open Zotero attachment using zotcli",
    })

    vim.keymap.set("n", "<leader>zr", function()
      read_attachment()
    end, { desc = "Zotero CLI: open attachment", silent = true })

    vim.api.nvim_create_user_command("ZotCliQuery", function(cmd)
      local query = cmd.args
      if query == "" then
        query = vim.fn.input("Zotero query: ")
      end
      if query == "" then
        return
      end

      run_zotcli({ "query", query }, function(stdout)
        local entries = {}
        for line in stdout:gmatch("[^\r\n]+") do
          local key, title = line:match("%[([^%]]+)%]%s*(.+)")
          if key and title then
            table.insert(entries, { key = key, title = title, display = line })
          end
        end

        if #entries == 0 then
          vim.notify("No Zotero entries found for \"" .. query .. "\"", vim.log.levels.INFO, { title = "zotcite" })
          return
        end

        vim.ui.select(entries, {
          prompt = "Zotero results",
          format_item = function(item)
            return item.display
          end,
        }, function(item)
          if item then
            read_attachment(item.key)
          end
        end)
      end)
    end, {
      nargs = "?",
      desc = "Search library with zotcli",
    })
  end,
}
