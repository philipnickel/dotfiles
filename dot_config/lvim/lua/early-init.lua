-- Early initialization to suppress deprecation warnings
-- This file is loaded before any other configuration

-- Override the deprecated function to prevent warnings
vim.tbl_add_reverse_lookup = function(tbl)
  -- Create reverse lookup table without deprecation warning
  local reverse = {}
  for k, v in pairs(tbl) do
    reverse[v] = k
  end
  return reverse
end

-- Suppress deprecation warnings
vim.deprecate = function() end