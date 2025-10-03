-- Smart Navigation
-- Jump between comments, headings, and other semantic elements based on filetype

local M = {}

-- ============================================================================
-- Comment Detection by Filetype
-- ============================================================================

-- Get comment patterns for current filetype
local function get_comment_patterns()
  local ft = vim.bo.filetype

  -- Define comment patterns for each filetype
  local patterns = {
    python = { "^%s*#", "^%s*\"\"\"", "^%s*'''" },
    lua = { "^%s*%-%-", "^%s*%-%-%[%[" },
    vim = { "^%s*\"" },
    tex = { "^%s*%%" },
    latex = { "^%s*%%" },
    markdown = { "^%s*<!%-%-", "^#{1,6}%s" },  -- Also matches headings
    html = { "^%s*<!%-%-" },
    css = { "^%s*/%*" },
    javascript = { "^%s*//", "^%s*/%*" },
    typescript = { "^%s*//", "^%s*/%*" },
    rust = { "^%s*//", "^%s*/%*" },
    go = { "^%s*//" },
    c = { "^%s*//", "^%s*/%*" },
    cpp = { "^%s*//", "^%s*/%*" },
    java = { "^%s*//", "^%s*/%*" },
    sh = { "^%s*#" },
    bash = { "^%s*#" },
    zsh = { "^%s*#" },
    yaml = { "^%s*#" },
    toml = { "^%s*#" },
    conf = { "^%s*#" },
    r = { "^%s*#" },
  }

  return patterns[ft] or { "^%s*#" }  -- Default to # if filetype not found
end

-- Check if a line is a Python cell delimiter (#%% or # %%)
local function is_python_cell_delimiter(line_text)
  return line_text:match("^%s*#%s*%%%%") ~= nil
end

-- Check if a line matches any comment pattern (excluding Python cell delimiters)
local function is_comment_line(line_text, patterns)
  -- For Python, skip cell delimiters
  if vim.bo.filetype == "python" and is_python_cell_delimiter(line_text) then
    return false
  end

  for _, pattern in ipairs(patterns) do
    if line_text:match(pattern) then
      return true
    end
  end
  return false
end

-- ============================================================================
-- Navigation Functions
-- ============================================================================

-- Jump to next comment
function M.jump_to_next_comment()
  local patterns = get_comment_patterns()
  local current_line = vim.fn.line('.')
  local last_line = vim.fn.line('$')

  -- Search forward from current line + 1
  for line_num = current_line + 1, last_line do
    local line_text = vim.fn.getline(line_num)
    if is_comment_line(line_text, patterns) then
      vim.fn.cursor(line_num, 1)
      vim.cmd('normal! ^')  -- Move to first non-blank character
      return
    end
  end

  -- No comment found, notify user
  vim.notify("No more comments below", vim.log.levels.INFO)
end

-- Jump to previous comment
function M.jump_to_prev_comment()
  local patterns = get_comment_patterns()
  local current_line = vim.fn.line('.')

  -- Search backward from current line - 1
  for line_num = current_line - 1, 1, -1 do
    local line_text = vim.fn.getline(line_num)
    if is_comment_line(line_text, patterns) then
      vim.fn.cursor(line_num, 1)
      vim.cmd('normal! ^')  -- Move to first non-blank character
      return
    end
  end

  -- No comment found, notify user
  vim.notify("No more comments above", vim.log.levels.INFO)
end

-- ============================================================================
-- LaTeX-Specific Navigation
-- ============================================================================

-- Jump to next LaTeX section/subsection/etc.
function M.jump_to_next_section()
  local current_line = vim.fn.line('.')
  local last_line = vim.fn.line('$')

  -- Pattern matches \section, \subsection, \subsubsection, \chapter, etc.
  local section_pattern = "^%s*\\[a-z]*section"

  for line_num = current_line + 1, last_line do
    local line_text = vim.fn.getline(line_num)
    if line_text:match(section_pattern) then
      vim.fn.cursor(line_num, 1)
      vim.cmd('normal! ^')
      return
    end
  end

  vim.notify("No more sections below", vim.log.levels.INFO)
end

function M.jump_to_prev_section()
  local current_line = vim.fn.line('.')
  local section_pattern = "^%s*\\[a-z]*section"

  for line_num = current_line - 1, 1, -1 do
    local line_text = vim.fn.getline(line_num)
    if line_text:match(section_pattern) then
      vim.fn.cursor(line_num, 1)
      vim.cmd('normal! ^')
      return
    end
  end

  vim.notify("No more sections above", vim.log.levels.INFO)
end

-- ============================================================================
-- Markdown-Specific Navigation
-- ============================================================================

-- Jump to next markdown heading
function M.jump_to_next_heading()
  local current_line = vim.fn.line('.')
  local last_line = vim.fn.line('$')

  -- Pattern matches # headings (one or more # followed by space)
  local heading_pattern = "^#+ "

  for line_num = current_line + 1, last_line do
    local line_text = vim.fn.getline(line_num)
    if line_text:match(heading_pattern) then
      vim.fn.cursor(line_num, 1)
      vim.cmd('normal! ^')
      return
    end
  end

  vim.notify("No more headings below", vim.log.levels.INFO)
end

function M.jump_to_prev_heading()
  local current_line = vim.fn.line('.')
  local heading_pattern = "^#+ "

  for line_num = current_line - 1, 1, -1 do
    local line_text = vim.fn.getline(line_num)
    if line_text:match(heading_pattern) then
      vim.fn.cursor(line_num, 1)
      vim.cmd('normal! ^')
      return
    end
  end

  vim.notify("No more headings above", vim.log.levels.INFO)
end

-- ============================================================================
-- Quarto/Jupyter-Specific Navigation (code cells and headings)
-- ============================================================================

-- Jump to next code cell in Quarto/Jupyter files (ignores headings and comments)
function M.jump_to_next_cell()
  local current_line = vim.fn.line('.')
  local last_line = vim.fn.line('$')
  local ft = vim.bo.filetype

  -- Patterns for code cells only (no headings, no comments)
  local cell_open_pattern = "^```{.*}"  -- Opening fence with language spec (```{python})
  local cell_close_pattern = "^```%s*$"  -- Closing fence (just ``` followed by optional whitespace)
  local python_cell_pattern = "^%s*#%s*%%%%"  -- Python cell delimiter: #%% or # %% (with optional leading/between whitespace)

  for line_num = current_line + 1, last_line do
    local line_text = vim.fn.getline(line_num)

    -- Check if it's an opening code fence (```{python}, ```{r}, etc.)
    if line_text:match(cell_open_pattern) then
      -- Jump to the line AFTER the opening fence (inside the code block)
      vim.fn.cursor(line_num + 1, 1)
      vim.cmd('normal! ^')
      return
    -- Check if it's a closing fence (just ```) - skip it
    elseif line_text:match(cell_close_pattern) then
      -- Skip closing fences, continue searching
    -- Check for python cells (#%% or # %%)
    elseif line_text:match(python_cell_pattern) then
      vim.fn.cursor(line_num, 1)
      vim.cmd('normal! ^')
      return
    end
  end

  vim.notify("No more cells below", vim.log.levels.INFO)
end

function M.jump_to_prev_cell()
  local current_line = vim.fn.line('.')
  local ft = vim.bo.filetype

  local cell_open_pattern = "^```{.*}"  -- Opening fence with language spec (```{python})
  local cell_close_pattern = "^```%s*$"  -- Closing fence (just ``` followed by optional whitespace)
  local python_cell_pattern = "^%s*#%s*%%%%"  -- Python cell delimiter: #%% or # %% (with optional leading/between whitespace)

  -- First, check if we're currently inside a code block
  -- If so, find the opening fence and skip past it
  local in_code_block = false
  for line_num = current_line, 1, -1 do
    local line_text = vim.fn.getline(line_num)
    if line_text:match(cell_close_pattern) then
      in_code_block = true
    elseif line_text:match(cell_open_pattern) then
      -- Found the opening fence, start searching from before it
      current_line = line_num - 1
      in_code_block = false
      break
    end
  end

  -- Now search for the previous cell
  for line_num = current_line - 1, 1, -1 do
    local line_text = vim.fn.getline(line_num)

    -- Check if it's a closing fence (just ```) - skip it
    if line_text:match(cell_close_pattern) then
      -- Skip closing fences, continue searching
    -- Check if it's an opening code fence (```{python}, ```{r}, etc.)
    elseif line_text:match(cell_open_pattern) then
      -- Jump to the line AFTER the opening fence (inside the code block)
      vim.fn.cursor(line_num + 1, 1)
      vim.cmd('normal! ^')
      return
    -- Check for python cells (#%% or # %%)
    elseif line_text:match(python_cell_pattern) then
      vim.fn.cursor(line_num, 1)
      vim.cmd('normal! ^')
      return
    end
  end

  vim.notify("No more cells above", vim.log.levels.INFO)
end

-- ============================================================================
-- Smart Navigation (filetype-aware)
-- ============================================================================

-- Jump to next comment/heading (for Quarto/Markdown, jump to headings; otherwise comments)
function M.jump_to_next_semantic()
  local ft = vim.bo.filetype

  if ft == "quarto" or ft == "markdown" then
    M.jump_to_next_heading()
  else
    M.jump_to_next_comment()
  end
end

function M.jump_to_prev_semantic()
  local ft = vim.bo.filetype

  if ft == "quarto" or ft == "markdown" then
    M.jump_to_prev_heading()
  else
    M.jump_to_prev_comment()
  end
end

-- Jump to next cell/heading (for Quarto/Markdown/Jupyter)
function M.jump_to_next_structure()
  local ft = vim.bo.filetype

  if ft == "tex" or ft == "latex" then
    M.jump_to_next_section()
  elseif ft == "quarto" or ft == "markdown" then
    M.jump_to_next_cell()
  elseif ft == "python" then
    -- Check if it's actually a Jupyter notebook (has #%% or # %% cells)
    local has_cells = false
    for i = 1, vim.fn.line('$') do
      if vim.fn.getline(i):match("^%s*#%s*%%%%") then
        has_cells = true
        break
      end
    end
    if has_cells then
      M.jump_to_next_cell()
    else
      M.jump_to_next_comment()  -- Fallback to comments for regular Python
    end
  else
    M.jump_to_next_comment()  -- Fallback to comments
  end
end

function M.jump_to_prev_structure()
  local ft = vim.bo.filetype

  if ft == "tex" or ft == "latex" then
    M.jump_to_prev_section()
  elseif ft == "quarto" or ft == "markdown" then
    M.jump_to_prev_cell()
  elseif ft == "python" then
    -- Check if it's actually a Jupyter notebook (has #%% or # %% cells)
    local has_cells = false
    for i = 1, vim.fn.line('$') do
      if vim.fn.getline(i):match("^%s*#%s*%%%%") then
        has_cells = true
        break
      end
    end
    if has_cells then
      M.jump_to_prev_cell()
    else
      M.jump_to_prev_comment()  -- Fallback to comments for regular Python
    end
  else
    M.jump_to_prev_comment()  -- Fallback to comments
  end
end

-- ============================================================================
-- Setup Keymaps
-- ============================================================================

function M.setup()
  -- Shift+J/K: Jump between comments (all filetypes)
  vim.keymap.set({'n', 'v'}, '<S-j>', M.jump_to_next_semantic,
    { desc = "Jump to next comment", silent = true })
  vim.keymap.set({'n', 'v'}, '<S-k>', M.jump_to_prev_semantic,
    { desc = "Jump to previous comment", silent = true })

  -- Shift+H/L: Jump between code cells/sections/headings (filetype-aware)
  vim.keymap.set({'n', 'v'}, '<S-h>', M.jump_to_prev_structure,
    { desc = "Jump to previous cell/section/heading", silent = true })
  vim.keymap.set({'n', 'v'}, '<S-l>', M.jump_to_next_structure,
    { desc = "Jump to next cell/section/heading", silent = true })

  -- Alternative: use ]c and [c for comment navigation
  vim.keymap.set({'n', 'v'}, ']c', M.jump_to_next_comment,
    { desc = "Jump to next comment", silent = true })
  vim.keymap.set({'n', 'v'}, '[c', M.jump_to_prev_comment,
    { desc = "Jump to previous comment", silent = true })

  -- LaTeX-specific: ]s and [s for sections
  vim.keymap.set({'n', 'v'}, ']s', M.jump_to_next_section,
    { desc = "Jump to next section (LaTeX)", silent = true })
  vim.keymap.set({'n', 'v'}, '[s', M.jump_to_prev_section,
    { desc = "Jump to previous section (LaTeX)", silent = true })

  -- Markdown-specific: ]h and [h for headings
  vim.keymap.set({'n', 'v'}, ']h', M.jump_to_next_heading,
    { desc = "Jump to next heading (Markdown)", silent = true })
  vim.keymap.set({'n', 'v'}, '[h', M.jump_to_prev_heading,
    { desc = "Jump to previous heading (Markdown)", silent = true })
end

return M
