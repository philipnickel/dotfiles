-- Real SymPy Test - This will actually test the configuration
-- Run this in Neovim with: :lua require('test_sympy_real').test()

local M = {}

function M.test()
  print("=== Real SymPy Test ===")
  
  -- Test 1: Load SymPy configuration
  print("\n1. Loading SymPy configuration...")
  local success, sympy_config = pcall(require, "sympy-config")
  if not success then
    print("✗ Failed to load SymPy configuration:", sympy_config)
    return false
  end
  print("✓ SymPy configuration loaded")
  
  -- Test 2: Find Python installation
  print("\n2. Finding Python installation...")
  local python = sympy_config.find_python()
  if not python then
    print("✗ No working Python installation found")
    print("  Install SymPy with: pipx install sympy")
    print("  Or with: python3 -m pip install --user sympy")
    return false
  end
  print("✓ Found Python installation:", python)
  
  -- Test 3: Check SymPy installation
  print("\n3. Checking SymPy installation...")
  local success, message = sympy_config.check_sympy_installation()
  if not success then
    print("✗ SymPy installation issue:", message)
    print("  Install SymPy with: pipx install sympy")
    return false
  end
  print("✓ SymPy is properly installed:", message)
  
  -- Test 4: Test actual SymPy evaluation
  print("\n4. Testing SymPy evaluation...")
  local cmd = sympy_config.get_python_command()
  print("Using command:", cmd)
  
  -- Test simple evaluation
  local python_code = [[
from sympy import *
x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)
init_printing()

# Test basic arithmetic
result1 = eval('1 + 1')
print("1 + 1 =", latex(result1))

# Test LaTeX conversion
result2 = eval('x**2')
print("x^2 =", latex(result2))

# Test fractions
result3 = eval('1/2')
print("1/2 =", latex(result3))
]]
  
  local handle = io.popen(cmd .. " '" .. python_code:gsub("'", "'\\''") .. "'")
  if handle then
    local result = handle:read("*a")
    handle:close()
    
    if result and not result:match("Error:") and result ~= "" then
      print("✓ SymPy evaluation successful!")
      print("Results:")
      for line in result:gmatch("[^\r\n]+") do
        if line ~= "" then
          print("  " .. line)
        end
      end
    else
      print("✗ SymPy evaluation failed:", result)
      return false
    end
  else
    print("✗ Failed to execute Python command")
    return false
  end
  
  -- Test 5: Test snippet functionality
  print("\n5. Testing snippet functionality...")
  local snippet_file = vim.fn.stdpath('config') .. '/luasnippets/tex/sympy.lua'
  if vim.fn.filereadable(snippet_file) == 1 then
    print("✓ SymPy snippet file exists")
    
    -- Check if LuaSnip is available
    local luasnip_available = pcall(require, "luasnip")
    if luasnip_available then
      print("✓ LuaSnip is available")
    else
      print("⚠ LuaSnip not available (snippets won't work)")
    end
  else
    print("✗ SymPy snippet file not found")
    return false
  end
  
  -- Test 6: Test guide access
  print("\n6. Testing guide access...")
  local guide_file = vim.fn.stdpath('config') .. '/SYMPY_GUIDE.md'
  if vim.fn.filereadable(guide_file) == 1 then
    print("✓ SymPy guide file exists")
  else
    print("✗ SymPy guide file not found")
    return false
  end
  
  print("\n=== All Tests Passed! ===")
  print("🎉 SymPy is working correctly!")
  print("\nReady to use:")
  print("1. Open a LaTeX file (.tex or .latex)")
  print("2. Type 'sympy 1 + 1 sympy' to test")
  print("3. Press <leader>sp to open SymPy guide")
  
  return true
end

-- Install SymPy function
function M.install_sympy()
  print("=== SymPy Installation ===")
  print("Installing SymPy globally...")
  
  -- Try pipx first
  local pipx_cmd = "pipx install sympy"
  local handle = io.popen(pipx_cmd)
  if handle then
    local result = handle:read("*a")
    handle:close()
    print("pipx result:", result)
  end
  
  -- Try pip as fallback
  local pip_cmd = "python3 -m pip install --user sympy"
  local handle2 = io.popen(pip_cmd)
  if handle2 then
    local result2 = handle2:read("*a")
    handle2:close()
    print("pip result:", result2)
  end
  
  print("Installation complete. Run the test again to verify.")
end

return M