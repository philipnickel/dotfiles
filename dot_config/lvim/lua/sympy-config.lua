-- SymPy Configuration
-- Configure global SymPy installation for mathematical evaluation

local M = {}

-- Configuration options
M.config = {
  -- Python executable paths (in order of preference)
  python_paths = {
    "python3",                    -- System Python 3
    "python",                     -- System Python
    "/usr/bin/python3",          -- Explicit system path
    "/usr/local/bin/python3",    -- Homebrew Python (Intel)
    "/opt/homebrew/bin/python3", -- Homebrew Python (Apple Silicon)
    "/usr/local/bin/python",     -- Alternative Homebrew path
    "/opt/homebrew/bin/python",  -- Alternative Apple Silicon path
  },
  
  -- Pipx installation paths (for global SymPy)
  pipx_paths = {
    os.getenv("HOME") .. "/.local/bin/python",  -- User pipx Python
    "/usr/local/bin/python",                     -- System pipx Python
    "/opt/homebrew/bin/python",                  -- Homebrew pipx Python
  },
  
  -- SymPy installation check command
  sympy_check_cmd = "python3 -m pip show sympy > /dev/null 2>&1",
  
  -- Fallback behavior
  fallback_to_original = true,  -- Return original expression if SymPy fails
  
  -- Debug mode (set to true to see error messages)
  debug = false,
}

-- Function to find working Python installation
function M.find_python()
  -- First try pipx installations (global SymPy)
  for _, path in ipairs(M.config.pipx_paths) do
    -- Test if Python exists and can import SymPy
    local test_cmd = path .. " -c 'import sympy; print(\"OK\")' 2>/dev/null"
    local handle = io.popen(test_cmd)
    if handle then
      local result = handle:read("*a")
      handle:close()
      if result and result:match("OK") then
        return path
      end
    end
  end
  
  -- Then try regular Python installations
  for _, path in ipairs(M.config.python_paths) do
    -- Test if Python exists and can import SymPy
    local test_cmd = path .. " -c 'import sympy; print(\"OK\")' 2>/dev/null"
    local handle = io.popen(test_cmd)
    if handle then
      local result = handle:read("*a")
      handle:close()
      if result and result:match("OK") then
        return path
      end
    end
  end
  return nil
end

-- Function to check if SymPy is installed
function M.check_sympy_installation()
  local python = M.find_python()
  if not python then
    return false, "No working Python installation found"
  end
  
  local check_cmd = python .. " -c 'import sympy; print(\"SymPy version:\", sympy.__version__)' 2>/dev/null"
  local handle = io.popen(check_cmd)
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and result:match("SymPy version:") then
      return true, result:gsub("\n", "")
    end
  end
  
  return false, "SymPy not installed. Install with: pip install sympy"
end

-- Function to get the best Python command for SymPy
function M.get_python_command()
  local python = M.find_python()
  if python then
    return python .. " -c"
  else
    -- Fallback to system python3
    return "python3 -c"
  end
end

-- Function to validate configuration
function M.validate_config()
  local success, message = M.check_sympy_installation()
  if success then
    vim.notify("SymPy configuration validated: " .. message, vim.log.levels.INFO)
  else
    vim.notify("SymPy configuration issue: " .. message, vim.log.levels.WARN)
  end
  return success
end

-- Function to setup SymPy (call this in your config)
function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", M.config, opts)
  
  -- Validate configuration on setup
  M.validate_config()
  
  return M
end

-- Export the module
return M