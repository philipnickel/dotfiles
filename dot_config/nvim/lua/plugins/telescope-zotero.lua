-- telescope-zotero.nvim - Telescope extension for Zotero references

return {
    "jmbuhr/telescope-zotero.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "kkharji/sqlite.lua",
    },
    ft = { "tex", "latex", "markdown", "quarto", "typst", "org", "asciidoc" },
    config = function()
        -- Check if Better BibTeX database exists
        local better_bibtex_db = vim.fn.expand("~/Zotero/better-bibtex.sqlite")
        local use_better_bibtex = vim.fn.filereadable(better_bibtex_db) == 1
        local zotero_bib = require("zotero.bib")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local entry_display = require("telescope.pickers.entry_display")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local conf = require("telescope.config").values
        local default_bib_name = "Bibliography.bib"

        local function resolve_bib_path(path)
            if not path or path == "" then
                return path
            end
            if path:sub(1, 1) == "~" then
                return vim.fn.expand(path)
            end
            if path:match("^/") then
                return path
            end
            local buf_name = vim.api.nvim_buf_get_name(0)
            if buf_name == "" then
                return path
            end
            local buf_dir = vim.fn.fnamemodify(buf_name, ":p:h")
            return vim.fn.fnamemodify(buf_dir .. "/" .. path, ":p")
        end

        local function locate_tex_bib()
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            for _, line in ipairs(lines) do
                if not line:match("^%%") then
                    local add_resource = line:match([[\addbibresource%s*{(.-)}]])
                    if add_resource and add_resource ~= "" then
                        add_resource = vim.trim(add_resource)
                        if not add_resource:lower():match("%.bib$") then
                            add_resource = add_resource .. ".bib"
                        end
                        return resolve_bib_path(add_resource)
                    end
                    local bibliography = line:match([[\bibliography%s*{(.-)}]])
                    if bibliography and bibliography ~= "" then
                        local entries = vim.split(bibliography, ",", { trimempty = true })
                        local first = vim.trim(entries[1] or "")
                        if first ~= "" then
                            if not first:lower():match("%.bib$") then
                                first = first .. ".bib"
                            end
                            return resolve_bib_path(first)
                        end
                    end
                end
            end
            return resolve_bib_path(default_bib_name)
        end

        local function count_char(str, pattern)
            return select(2, str:gsub(pattern, ""))
        end

        local function parse_bib_entries(bib_path)
            local entries = {}
            local current_key = nil
            local current_title = nil
            local brace_depth = 0

            for line in io.lines(bib_path) do
                local start_key = line:match("^@[%w%-%_]+%s*{%s*([^,]+)")
                if start_key then
                    if current_key then
                        table.insert(entries, {
                            key = vim.trim(current_key),
                            title = current_title and vim.trim(current_title) or nil,
                        })
                    end
                    current_key = vim.trim(start_key)
                    current_title = nil
                    brace_depth = count_char(line, "{") - count_char(line, "}")
                elseif current_key then
                    brace_depth = brace_depth + count_char(line, "{") - count_char(line, "}")
                end

                if current_key and not current_title then
                    local title_match = line:match("[Tt]itle%s*=%s*[{\"](.-)[}\"]")
                    if title_match and title_match ~= "" then
                        current_title = title_match
                    end
                end

                if current_key and brace_depth <= 0 then
                    table.insert(entries, {
                        key = vim.trim(current_key),
                        title = current_title and vim.trim(current_title) or nil,
                    })
                    current_key = nil
                    current_title = nil
                    brace_depth = 0
                end
            end

            if current_key then
                table.insert(entries, {
                    key = vim.trim(current_key),
                    title = current_title and vim.trim(current_title) or nil,
                })
            end

            return entries
        end

        local function open_existing_bib_picker()
            local zotero = require("zotero")
            local ft_config = zotero.config.ft[vim.bo.filetype] or zotero.config.ft.default
            if not ft_config then
                vim.notify("[zotero] No filetype configuration found", vim.log.levels.WARN)
                return
            end

            local locate_bib = ft_config.locate_bib
            local bib_path = nil
            if type(locate_bib) == "function" then
                bib_path = locate_bib()
            else
                bib_path = locate_bib
            end

            if not bib_path or bib_path == "" then
                vim.notify("[zotero] Could not determine bibliography file", vim.log.levels.WARN)
                return
            end

            bib_path = vim.fn.expand(bib_path)
            if vim.fn.filereadable(bib_path) ~= 1 then
                vim.notify("[zotero] Bibliography file not found: " .. bib_path, vim.log.levels.WARN)
                return
            end

            local entries = parse_bib_entries(bib_path)
            if vim.tbl_isempty(entries) then
                vim.notify("[zotero] No entries found in " .. bib_path, vim.log.levels.INFO)
                return
            end

            local displayer = entry_display.create({
                separator = " ",
                items = {
                    { width = 30 },
                    { remaining = true },
                },
            })

            pickers.new({}, {
                prompt_title = "Bibliography (" .. vim.fn.fnamemodify(bib_path, ":t") .. ")",
                finder = finders.new_table({
                    results = entries,
                    entry_maker = function(item)
                        local display = displayer({
                            { item.key },
                            { item.title or "" },
                        })
                        return {
                            value = item,
                            display = display,
                            ordinal = item.key .. " " .. (item.title or ""),
                        }
                    end,
                }),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        if not selection then
                            return
                        end
                        local citekey = selection.value.key
                        local formatter = ft_config.insert_key_formatter or function(key)
                            return key
                        end
                        local insert_text = formatter(citekey)
                        vim.api.nvim_put({ insert_text }, "", false, true)
                    end)
                    return true
                end,
            }):find()
        end

        require("zotero").setup({
            -- File system options
            zotero_db_path = "~/Zotero/zotero.sqlite",
            better_bibtex_db_path = use_better_bibtex and "~/Zotero/better-bibtex.sqlite" or nil,
            zotero_storage_path = "~/Zotero/storage",
            pdf_opener = "open", -- macOS default opener

            -- Picker options
            picker = {
                with_icons = true,
                hlgroups = {
                    icons = "SpecialChar",
                    author_date = "Comment",
                    title = "Title",
                },
            },

            -- Filetype configurations
            ft = {
                -- LaTeX/TeX
                tex = {
                    insert_key_formatter = function(citekey)
                        return "\\cite{" .. citekey .. "}"
                    end,
                    locate_bib = locate_tex_bib,
                },
                latex = {
                    insert_key_formatter = function(citekey)
                        return "\\cite{" .. citekey .. "}"
                    end,
                    locate_bib = locate_tex_bib,
                },
                
                -- Markdown and Pandoc
                markdown = {
                    insert_key_formatter = function(citekey)
                        return "[@" .. citekey .. "]"
                    end,
                    locate_bib = function()
                        -- Look for bibliography in YAML frontmatter or use default
                        local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
                        for _, line in ipairs(lines) do
                            local bib_match = line:match("bibliography:%s*(.+)")
                            if bib_match then
                                local resolved = vim.trim(bib_match:gsub("['\"]", ""))
                                return resolve_bib_path(resolved)
                            end
                        end
                        return resolve_bib_path(default_bib_name)
                    end,
                },

                -- Quarto
                quarto = {
                    insert_key_formatter = function(citekey)
                        return "[@" .. citekey .. "]"
                    end,
                    locate_bib = function()
                        local resolved = zotero_bib.locate_quarto_bib() or default_bib_name
                        return resolve_bib_path(resolved)
                    end,
                },

                -- Typst
                typst = {
                    insert_key_formatter = function(citekey)
                        return "@" .. citekey
                    end,
                    locate_bib = function()
                        local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
                        for _, line in ipairs(lines) do
                            local bib_match = line:match("#bibliography%(\"(.+)\"")
                            if bib_match then
                                return resolve_bib_path(bib_match)
                            end
                        end
                        return resolve_bib_path(default_bib_name)
                    end,
                },

                -- Org mode
                org = {
                    insert_key_formatter = function(citekey)
                        return "[[cite:&" .. citekey .. "]]"
                    end,
                    locate_bib = function()
                        local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
                        for _, line in ipairs(lines) do
                            local bib_match = line:match("#%+[Bb][Ii][Bb][Ll][Ii][Oo][Gg][Rr][Aa][Pp][Hh][Yy]:%s*(.+)")
                            if bib_match then
                                return resolve_bib_path(vim.trim(bib_match))
                            end
                        end
                        return resolve_bib_path(default_bib_name)
                    end,
                },
            },
        })

        -- Load the telescope extension
        require("telescope").load_extension("zotero")

        -- Set up keybindings
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "tex", "latex", "markdown", "quarto", "typst", "org", "asciidoc" },
            callback = function()
                local keymap_opts = { buffer = true, silent = true, desc = "Search Zotero references" }
                vim.keymap.set("n", "<leader>zz", function()
                    require("telescope").extensions.zotero.zotero()
                end, keymap_opts)

                keymap_opts = { buffer = true, silent = true, desc = "Insert Zotero reference" }
                vim.keymap.set("n", "<leader>zi", function()
                    open_existing_bib_picker()
                end, keymap_opts)
                
                -- Show status message about Better BibTeX
                if not use_better_bibtex then
                    vim.notify(
                        "Using basic Zotero database. Install Better BibTeX for improved citation keys.", 
                        vim.log.levels.INFO,
                        { title = "Zotero" }
                    )
                end
            end,
        })
    end,
}
