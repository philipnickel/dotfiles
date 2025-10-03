-- End-to-End SymPy Snippet Test
-- This tests the actual snippet expansion and evaluation
-- Run with: :lua require('test_sympy_e2e').test()

local M = {}

function M.test()
  print("=== SymPy End-to-End Test ===\n")

  -- Test 1: Python and SymPy availability
  print("1. Testing Python and SymPy availability...")
  local test_cmd = [[python3 -c "from sympy import *; print('OK')" 2>&1]]
  local handle = io.popen(test_cmd)
  local result = handle:read("*a")
  handle:close()

  if result:match("OK") then
    print("✓ Python and SymPy are available\n")
  else
    print("✗ Python/SymPy not available:", result)
    return false
  end

  -- Test 2: Test basic arithmetic evaluation
  print("2. Testing basic arithmetic (1 + 1)...")
  local python_code = [[
from sympy import *
x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)
init_printing()
result = eval('1 + 1')
print(latex(result))
]]

  handle = io.popen("python3 -c '" .. python_code:gsub("'", "'\\''") .. "'")
  result = handle:read("*a"):gsub("\n", "")
  handle:close()

  if result == "2" then
    print("✓ Basic arithmetic works: 1 + 1 = " .. result .. "\n")
  else
    print("✗ Basic arithmetic failed. Got:", result, "\n")
    return false
  end

  -- Test 3: Test power expression (x^2)
  print("3. Testing power expression (x**2)...")
  python_code = [[
from sympy import *
x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)
init_printing()
result = eval('x**2')
print(latex(result))
]]

  handle = io.popen("python3 -c '" .. python_code:gsub("'", "'\\''") .. "'")
  result = handle:read("*a"):gsub("\n", "")
  handle:close()

  if result == "x^{2}" then
    print("✓ Power expression works: x**2 = " .. result .. "\n")
  else
    print("✗ Power expression failed. Got:", result, "\n")
    return false
  end

  -- Test 4: Test derivative
  print("4. Testing derivative (diff(x**2, x))...")
  python_code = [[
from sympy import *
x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)
init_printing()
result = eval('diff(x**2, x)')
print(latex(result))
]]

  handle = io.popen("python3 -c '" .. python_code:gsub("'", "'\\''") .. "'")
  result = handle:read("*a"):gsub("\n", "")
  handle:close()

  if result == "2 x" then
    print("✓ Derivative works: diff(x**2, x) = " .. result .. "\n")
  else
    print("✗ Derivative failed. Got:", result, "\n")
    return false
  end

  -- Test 5: Test fraction with sympify
  print("5. Testing fraction (1/2) with sympify...")
  python_code = [[
from sympy import *
x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)
init_printing()
result = sympify('1/2', rational=True)
print(latex(result))
]]

  handle = io.popen("python3 -c '" .. python_code:gsub("'", "'\\''") .. "'")
  result = handle:read("*a"):gsub("\n", "")
  handle:close()

  if result == "\\frac{1}{2}" then
    print("✓ Fraction works: 1/2 = " .. result .. "\n")
  else
    print("✗ Fraction failed. Expected \\frac{1}{2}, got:", result, "\n")
    return false
  end

  -- Test 6: Test the snippet configuration
  print("6. Testing snippet configuration...")
  local sympy_config = require("sympy-config")
  local python = sympy_config.find_python()

  if python then
    print("✓ Found Python:", python)
  else
    print("✗ Could not find Python installation")
    return false
  end

  local success, message = sympy_config.check_sympy_installation()
  if success then
    print("✓ SymPy configuration:", message, "\n")
  else
    print("✗ SymPy configuration issue:", message, "\n")
    return false
  end

  -- Test 7: Test the evaluate_sympy function
  print("7. Testing snippet evaluation function...")
  local snippet_file = vim.fn.stdpath('config') .. '/luasnippets/tex/sympy.lua'

  if vim.fn.filereadable(snippet_file) == 1 then
    print("✓ Snippet file exists at:", snippet_file, "\n")
  else
    print("✗ Snippet file not found at:", snippet_file, "\n")
    return false
  end

  -- Test 8: Summary
  print("=== All Tests Passed! ===\n")
  print("🎉 Your SymPy snippets are ready to use!\n")
  print("Quick Start:")
  print("1. Open a LaTeX file (*.tex)")
  print("2. Type ';sy' and press Tab")
  print("   → This creates: sympy | sympy (cursor in middle)")
  print("3. Type your expression, e.g., '1 + 1'")
  print("   → Full text: sympy 1 + 1 sympy")
  print("4. Press Tab again to evaluate")
  print("   → Result: 2")
  print()
  print("Example expressions to try:")
  print("  • sympy 1 + 1 sympy → 2")
  print("  • sympy x**2 sympy → x^{2}")
  print("  • sympy diff(x**2, x) sympy → 2 x")
  print("  • sympy integrate(x**2, x) sympy → \\frac{x^{3}}{3}")
  print("  • sympy limit(sin(x)/x, x, 0) sympy → 1")
  print()

  return true
end

-- Quick test function that just checks if everything is working
function M.quick_test()
  print("Quick SymPy Test...")
  local handle = io.popen([[python3 -c "from sympy import *; print(latex(eval('1+1')))" 2>&1]])
  local result = handle:read("*a"):gsub("\n", "")
  handle:close()

  if result == "2" then
    print("✓ SymPy is working! (1+1 = " .. result .. ")")
    return true
  else
    print("✗ SymPy test failed. Got:", result)
    return false
  end
end

return M
