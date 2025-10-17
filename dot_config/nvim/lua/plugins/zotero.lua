-- Telescope Zotero integration with smarter bibliography discovery

local function trim_value(value)
  if not value then
    return nil
  end
  value = value:gsub("#.*$", "")
  value = value:gsub("[%[%],]", " ")
  value = value:gsub([["]], "")
  value = value:gsub("[']", "")
  value = value:match("^%s*(.-)%s*$")
  if value == "" then
    return nil
  end
  return value
end

local function resolve_path(path, base_dir)
  path = trim_value(path)
  if not path then
    return nil
  end
  if path:match("^~") or path:match("^/") or path:match("^%a:[/\\]") then
    return path
  end
  base_dir = base_dir or vim.loop.cwd()
  local joined = base_dir .. "/" .. path
  return vim.fn.fnamemodify(joined, ":p")
end

local function scan_lines_for_bibliography(lines, base_dir)
  local collecting_list = false
  for _, raw in ipairs(lines) do
    local line = raw:gsub("#.*$", "")

    if collecting_list then
      local list_item = line:match("^%s*%-%s*(.+)")
      if list_item then
        local resolved = resolve_path(list_item, base_dir)
        if resolved then
          return resolved
        end
      elseif not line:match("^%s*$") then
        collecting_list = false
      end
    end

    local value = line:match("bibliography:%s*(.+)")
    if value then
      local candidate = value:match("%[?%s*[\"']?([^\"'%,%]]+)")
      local resolved = resolve_path(candidate, base_dir)
      if resolved then
        return resolved
      end

      if value == "" or value:match("^%s*%[?%s*$") or not candidate then
        collecting_list = true
      end
    end
  end
  return nil
end

local function project_root()
  local ok, cwd = pcall(vim.fn.getcwd)
  if ok and cwd and cwd ~= "" then
    return cwd
  end
  return vim.loop.cwd()
end

local function find_bibliography_path()
  local base_dir = project_root()
  local line_count = vim.api.nvim_buf_line_count(0)
  local lines = vim.api.nvim_buf_get_lines(0, 0, math.min(line_count, 400), false)

  -- TeX / LaTeX commands (\addbibresource, \bibliography) including comma-separated values
  for _, raw in ipairs(lines) do
    if raw:match("^%s*%%") then
      goto continue
    end
    local addbib = raw:match("\\addbibresource%s*%b[]%s*%{([^}]*)%}") or raw:match("\\addbibresource%s*%{([^}]*)%}")
    if addbib then
      for entry in addbib:gmatch("[^,%s]+") do
        local candidate = entry
        if not candidate:match("%.bib$") then
          candidate = candidate .. ".bib"
        end
        local resolved = resolve_path(candidate, base_dir)
        if resolved then
          return resolved
        end
      end
    end

    local bibcmd = raw:match("\\bibliography%s*%{([^}]*)%}")
    if bibcmd then
      for entry in bibcmd:gmatch("[^,%s]+") do
        local candidate = entry
        if not candidate:match("%.bib$") then
          candidate = candidate .. ".bib"
        end
        local resolved = resolve_path(candidate, base_dir)
        if resolved then
          return resolved
        end
      end
    end
    ::continue::
  end

  local resolved = scan_lines_for_bibliography(lines, base_dir)
  if resolved then
    return resolved
  end

  local root_config = vim.fs.find({ "_quarto.yml", "_quarto.yaml" }, {
    upward = true,
    path = base_dir,
    limit = 1,
  })[1]
  if root_config then
    local root_lines = vim.fn.readfile(root_config)
    resolved = scan_lines_for_bibliography(root_lines, vim.fs.dirname(root_config))
    if resolved then
      return resolved
    end
  end

  local fallback = vim.fs.find({ "references.bib" }, {
    upward = true,
    path = base_dir,
    limit = 1,
  })
  if fallback[1] then
    return fallback[1]
  end

  local any_bib = vim.fs.find(function(name, path)
    return name:match("%.bib$")
  end, {
    path = base_dir,
    limit = 1,
    type = "file",
  })
  if any_bib[1] then
    return any_bib[1]
  end

  return nil
end

return {
  "jmbuhr/telescope-zotero.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "kkharji/sqlite.lua",
  },
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    opts = opts or {}

    local ok_zotero, zotero = pcall(require, "zotero")
    if not ok_zotero then
      vim.notify("zotero module not available", vim.log.levels.ERROR, { title = "zotero" })
      return
    end

    local bib = require("zotero.bib")

    opts.ft = vim.tbl_deep_extend("force", opts.ft or {}, {
      default = {
        locate_bib = find_bibliography_path,
      },
      quarto = {
        locate_bib = find_bibliography_path,
      },
      rmd = {
        insert_key_formatter = function(citekey)
          return "@" .. citekey
        end,
        locate_bib = find_bibliography_path,
      },
      markdown = {
        insert_key_formatter = function(citekey)
          return "@" .. citekey
        end,
        locate_bib = find_bibliography_path,
      },
      tex = {
        locate_bib = function()
          local base_dir = project_root()
          local from_tex = bib.locate_tex_bib()
          if from_tex then
            local resolved = resolve_path(from_tex, base_dir)
            if resolved then
              return resolved
            end
          end
          return find_bibliography_path()
        end,
      },
      plaintex = {
        locate_bib = function()
          local base_dir = project_root()
          local from_tex = bib.locate_tex_bib()
          if from_tex then
            local resolved = resolve_path(from_tex, base_dir)
            if resolved then
              return resolved
            end
          end
          return find_bibliography_path()
        end,
      },
      typst = {
        locate_bib = function()
          local base_dir = project_root()
          local from_typst = bib.locate_typst_bib()
          if from_typst then
            local resolved = resolve_path(from_typst, base_dir)
            if resolved then
              return resolved
            end
          end
          return find_bibliography_path()
        end,
      },
      org = {
        locate_bib = function()
          local base_dir = project_root()
          local from_org = bib.locate_org_bib()
          if from_org then
            local resolved = resolve_path(from_org, base_dir)
            if resolved then
              return resolved
            end
          end
          return find_bibliography_path()
        end,
      },
    })

    zotero.setup(opts)

    local telescope_ok, telescope = pcall(require, "telescope")
    if not telescope_ok then
      vim.notify("telescope not available", vim.log.levels.ERROR, { title = "zotero" })
      return
    end

    telescope.load_extension("zotero")

    local function open_citations()
      local ok, err = pcall(telescope.extensions.zotero.zotero)
      if not ok then
        vim.notify("Failed to open Zotero picker: " .. err, vim.log.levels.ERROR, { title = "zotero" })
      end
    end

    vim.keymap.set("n", "<leader>fz", open_citations, {
      desc = "Zotero: find citation",
      silent = true,
    })

    local ok_wk, wk = pcall(require, "which-key")
    if ok_wk then
      wk.add({ { "<leader>fz", desc = "Zotero: find citation" } })
      wk.add({ { "<leader>z", group = "Zotero" } })
    end
  end,
}
