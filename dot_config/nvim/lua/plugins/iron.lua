-- Iron.nvim configuration for interactive REPLs

return {
  "Vigemus/iron.nvim",
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")

    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            command = {"zsh"}
          },
          python = {
            command = function()
              -- Try ipython first, fallback to python
              if vim.fn.executable("ipython") == 1 then
                return {"ipython", "--no-autoindent"}
              elseif vim.fn.executable("python3") == 1 then
                return {"python3"}
              elseif vim.fn.executable("python") == 1 then
                return {"python"}
              else
                vim.notify("No Python interpreter found. Please install Python or IPython.", vim.log.levels.ERROR)
                return {"python"} -- This will show a clear error
              end
            end,
            format = require("iron.fts.common").bracketed_paste_python,
            block_dividers = { "# %%", "#%%" },
            env = {PYTHON_BASIC_REPL = "1"}
          },
          r = {
            command = function()
              if vim.fn.executable("R") == 1 then
                return {"R"}
              else
                vim.notify("R is not installed or not in PATH", vim.log.levels.ERROR)
                return {"R"}
              end
            end
          },
          julia = {
            command = function()
              if vim.fn.executable("julia") == 1 then
                return {"julia"}
              else
                vim.notify("Julia is not installed or not in PATH", vim.log.levels.ERROR)
                return {"julia"}
              end
            end
          },
          lua = {
            command = {"lua"}
          },
          -- Support for Quarto/Markdown files
          quarto = {
            command = function()
              -- Try ipython first, fallback to python
              if vim.fn.executable("ipython") == 1 then
                return {"ipython", "--no-autoindent"}
              elseif vim.fn.executable("python3") == 1 then
                return {"python3"}
              elseif vim.fn.executable("python") == 1 then
                return {"python"}
              else
                vim.notify("No Python interpreter found for Quarto", vim.log.levels.ERROR)
                return {"python"}
              end
            end,
            format = require("iron.fts.common").bracketed_paste_python,
            block_dividers = { "```{python}", "```{r}", "```{julia}", "```{bash}", "```" },
            env = {PYTHON_BASIC_REPL = "1"}
          },
          markdown = {
            command = function()
              -- Try ipython first, fallback to python
              if vim.fn.executable("ipython") == 1 then
                return {"ipython", "--no-autoindent"}
              elseif vim.fn.executable("python3") == 1 then
                return {"python3"}
              elseif vim.fn.executable("python") == 1 then
                return {"python"}
              else
                vim.notify("No Python interpreter found for Markdown", vim.log.levels.ERROR)
                return {"python"}
              end
            end,
            format = require("iron.fts.common").bracketed_paste_python,
            block_dividers = { "```{python}", "```{r}", "```{julia}", "```{bash}", "```" },
            env = {PYTHON_BASIC_REPL = "1"}
          },
        },
        
        -- Repl window will be displayed as a vertical split (40% width)
        repl_open_cmd = view.split.vertical.botright("40%"),
        
        -- Set the file type of the newly created repl to ft
        repl_filetype = function(bufnr, ft)
          -- For Quarto/Markdown files, detect the language in the current chunk
          if ft == "quarto" or ft == "markdown" then
            local ok_otter, otter_keeper = pcall(require, 'otter.keeper')
            if ok_otter then
              local current = otter_keeper.get_current_language_context()
              if current and current ~= "" then
                return current
              end
            end
            -- Fallback to python for Quarto/Markdown
            return "python"
          end
          return ft
        end,
        
      },
      
      -- Iron doesn't set keymaps by default anymore
      keymaps = {
        toggle_repl = "<leader>rr",
        restart_repl = "<leader>rR",
        send_motion = "<leader>rs",
        visual_send = "<leader>rv",
        send_file = "<leader>rf",
        send_line = "<leader>rl",
        send_paragraph = "<leader>rp",
        send_until_cursor = "<leader>ru",
        send_mark = "<leader>rm",
        mark_motion = "<leader>rm",
        mark_visual = "<leader>rm",
        remove_mark = "<leader>rm",
        cr = "<leader>rs<cr>",
        clear = "<leader>rc",
        -- Additional keymaps for code blocks
        send_code_block = "<leader>rb",
        send_code_block_and_move = "<leader>rn",
      },
      
      -- If the highlight is on, you can change how it looks
      highlight = {
        italic = true
      },
      
      -- Ignore blank lines when sending visual select lines
      ignore_blank_lines = true,
    })

    -- Additional keymaps for iron focus and hide
    vim.keymap.set('n', '<leader>rF', '<cmd>IronFocus<cr>', { desc = 'Focus REPL' })
    vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>', { desc = 'Hide REPL' })

    -- Custom functions for Quarto/Markdown code chunks
    local function get_quarto_code_chunk()
      local current_line = vim.fn.line('.')
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      
      local start_line = nil
      local end_line = nil
      
      -- Find the start of the current code chunk
      for i = current_line, 1, -1 do
        if lines[i] and lines[i]:match('^```{') then
          start_line = i + 1
          break
        end
      end
      
      -- Find the end of the current code chunk
      for i = current_line, #lines do
        if lines[i] and lines[i] == '```' then
          end_line = i - 1
          break
        end
      end
      
      if start_line and end_line and start_line <= end_line then
        return vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
      end
      
      return nil
    end

    local function send_quarto_chunk()
      local start_line, end_line = nil, nil
      local current_line = vim.fn.line('.')
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

      -- Find the start of the current code chunk
      for i = current_line, 1, -1 do
        if lines[i] and lines[i]:match('^```{') then
          start_line = i + 1
          break
        end
      end

      -- Find the end of the current code chunk
      for i = current_line, #lines do
        if lines[i] and lines[i] == '```' then
          end_line = i - 1
          break
        end
      end

      if start_line and end_line and start_line <= end_line then
        -- Set visual selection to the code chunk
        vim.api.nvim_win_set_cursor(0, {start_line, 0})
        vim.cmd('normal! V')
        vim.api.nvim_win_set_cursor(0, {end_line, 0})
        
        -- Send the visual selection using Iron's visual send keymap
        vim.cmd('normal! <leader>rv')
      else
        vim.notify("No code chunk found at cursor position", vim.log.levels.WARN)
      end
    end

    -- Custom keymaps for Quarto code chunks
    vim.keymap.set('n', '<leader>rb', send_quarto_chunk, { desc = 'Send Quarto code chunk' })
  end,
}