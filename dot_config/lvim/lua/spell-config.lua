-- Spell checking configuration for LunarVim
-- Provides automatic spell checking and quick correction features

-- ============================================================================
-- Spell Check Settings
-- ============================================================================

-- Enable spell checking for text files (excluding LaTeX to avoid conflicts)
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us,nl"  -- English (US) and Dutch
  end,
})

-- Note: LaTeX spell checking disabled to avoid conflicts with VimTeX
-- VimTeX has its own spell checking system that works better with LaTeX syntax

-- ============================================================================
-- Spell Correction Keybindings
-- ============================================================================

-- Quick spell correction: Ctrl+L corrects previous spelling mistake
vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", {
  desc = "Correct previous spelling mistake",
  silent = true,
})

-- Spell check navigation and correction
vim.keymap.set("n", "]s", "]s", { desc = "Next spelling mistake" })
vim.keymap.set("n", "[s", "[s", { desc = "Previous spelling mistake" })
vim.keymap.set("n", "]S", "]S", { desc = "Next spelling mistake (end of word)" })
vim.keymap.set("n", "[S", "[S", { desc = "Previous spelling mistake (end of word)" })

-- Quick spell correction commands
vim.keymap.set("n", "z=", "z=", { desc = "Show spelling suggestions" })
vim.keymap.set("n", "zg", "zg", { desc = "Add word to spell list" })
vim.keymap.set("n", "zw", "zw", { desc = "Add word to bad spell list" })
vim.keymap.set("n", "zG", "zG", { desc = "Add word to spell list (session)" })
vim.keymap.set("n", "zW", "zW", { desc = "Add word to bad spell list (session)" })

-- ============================================================================
-- Spell Check Functions
-- ============================================================================

-- Function to toggle spell checking
local function toggle_spell()
  if vim.opt_local.spell:get() then
    vim.opt_local.spell = false
    vim.notify("Spell checking: DISABLED", vim.log.levels.INFO)
  else
    vim.opt_local.spell = true
    vim.notify("Spell checking: ENABLED", vim.log.levels.INFO)
  end
end

-- Function to cycle through spell languages
local function cycle_spell_lang()
  local languages = { "en_us", "en_us,nl", "nl", "nl,en_us" }
  local current = vim.opt_local.spelllang:get()
  local current_index = 1
  
  -- Find current language in the list
  for i, lang in ipairs(languages) do
    if lang == current then
      current_index = i
      break
    end
  end
  
  -- Cycle to next language
  local next_index = (current_index % #languages) + 1
  vim.opt_local.spelllang = languages[next_index]
  vim.notify("Spell language: " .. languages[next_index], vim.log.levels.INFO)
end

-- Function to correct all spelling mistakes in current line
local function correct_line_spelling()
  local line = vim.api.nvim_get_current_line()
  local corrected_line = line
  
  -- Simple approach: use Vim's built-in spell correction
  vim.cmd("normal! 0")
  local col = 0
  while col < #line do
    vim.cmd("normal! l")
    col = vim.fn.col(".")
    if vim.fn.spellbadword(line:sub(col, col + 10))[1] ~= "" then
      vim.cmd("normal! [s")
      vim.cmd("normal! 1z=")
    end
  end
end

-- ============================================================================
-- Which-Key Mappings for Spell Check
-- ============================================================================

-- Add spell check mappings to which-key
lvim.builtin.which_key.mappings["z"] = {
  name = "Spell Check",
  s = { toggle_spell, "Toggle spell checking" },
  l = { cycle_spell_lang, "Cycle spell language" },
  c = { correct_line_spelling, "Correct line spelling" },
  ["="] = { "z=", "Show spelling suggestions" },
  g = { "zg", "Add word to spell list" },
  w = { "zw", "Add word to bad spell list" },
  G = { "zG", "Add word to spell list (session)" },
  W = { "zW", "Add word to bad spell list (session)" },
  ["]"] = { "]s", "Next spelling mistake" },
  ["["] = { "[s", "Previous spelling mistake" },
}

-- ============================================================================
-- Spell Check Status Line Integration
-- ============================================================================

-- Note: Status line integration removed to avoid conflicts with VimTeX

-- ============================================================================
-- Spell Check Configuration
-- ============================================================================

-- Spell check options
vim.opt.spelloptions = "camel"  -- Treat camelCase as separate words
vim.opt.spellsuggest = "best,9"  -- Show up to 9 suggestions, best first

-- Custom spell check words (add your own words here)
-- Note: VimTeX handles its own spell checking regions

-- ============================================================================
-- Spell Check Help Text
-- ============================================================================

local spell_help = {
  "# Spell Check Configuration",
  "",
  "## Quick Correction",
  "- **Ctrl+L** (in insert mode) - Correct previous spelling mistake",
  "",
  "## Navigation",
  "- **]s** - Next spelling mistake",
  "- **[s** - Previous spelling mistake", 
  "- **]S** - Next spelling mistake (end of word)",
  "- **[S** - Previous spelling mistake (end of word)",
  "",
  "## Correction Commands",
  "- **z=** - Show spelling suggestions",
  "- **zg** - Add word to spell list",
  "- **zw** - Add word to bad spell list",
  "- **zG** - Add word to spell list (session)",
  "- **zW** - Add word to bad spell list (session)",
  "",
  "## Which-Key Mappings (<leader>z)",
  "- **s** - Toggle spell checking",
  "- **l** - Cycle spell language",
  "- **c** - Correct line spelling",
  "",
  "## Languages",
  "- **en_us** - English (US)",
  "- **nl** - Dutch",
  "- **en_us,nl** - Both languages",
  "",
  "## Auto-Enable",
  "Spell checking is automatically enabled for:",
  "- Markdown files",
  "- Text files", 
  "- Git commit messages",
  "- LaTeX files",
  "",
  "## Tips",
  "- Use **Ctrl+L** while typing for quick corrections",
  "- Add technical terms with **zg**",
  "- Cycle languages with **<leader>zl**",
  "- Undo corrections with **u** (thanks to <c-g>u)",
}

-- Function to show spell check help
local function show_spell_help()
  open_markdown_float(spell_help, " Spell Check Help ")
end

-- Add help to which-key
lvim.builtin.which_key.mappings["z"]["h"] = { show_spell_help, "Spell check help" }