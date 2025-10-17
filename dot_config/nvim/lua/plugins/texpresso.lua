-- texpresso - live LaTeX preview

return {
    "let-def/texpresso.vim",
    ft = { "tex", "latex" },
    cmd = { "TeXpresso" },
    config = function()
        -- Set texpresso executable path
        vim.g.texpresso_executable = '/opt/homebrew/bin/texpresso'
        
        -- Set keybindings for texpresso
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "tex", "latex" },
            callback = function()
                local opts = { buffer = true, silent = true }
                vim.keymap.set('n', '<leader>tp', ':TeXpresso<CR>', opts, { desc = "Start TeXpresso live preview" })
                vim.keymap.set('n', '<leader>tq', ':TeXpressoStop<CR>', opts, { desc = "Stop TeXpresso preview" })
            end
        })
    end,
}
