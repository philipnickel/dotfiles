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
                },
                latex = {
                    insert_key_formatter = function(citekey)
                        return "\\cite{" .. citekey .. "}"
                    end,
                },
                
                -- Markdown and Pandoc
                markdown = {
                    insert_key_formatter = function(citekey)
                        return "[@" .. citekey .. "]"
                    end,
                    locate_bib = function()
                        -- Look for bibliography in YAML frontmatter or references.bib
                        local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
                        for _, line in ipairs(lines) do
                            local bib_match = line:match("bibliography:%s*(.+)")
                            if bib_match then
                                return vim.trim(bib_match:gsub("['\"]", ""))
                            end
                        end
                        return "references.bib"
                    end,
                },

                -- Quarto
                quarto = {
                    insert_key_formatter = function(citekey)
                        return "[@" .. citekey .. "]"
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
                                return bib_match
                            end
                        end
                        return "references.bib"
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
                                return vim.trim(bib_match)
                            end
                        end
                        return "references.bib"
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
                local opts = { buffer = true, silent = true }
                vim.keymap.set("n", "<leader>zz", "<cmd>Telescope zotero<cr>", opts, { desc = "Search Zotero references" })
                vim.keymap.set("n", "<leader>zi", "<cmd>Telescope zotero insert<cr>", opts, { desc = "Insert Zotero reference" })
                
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