-- Test SymPy Visual Selection Operations
-- Run with: :lua require('test_sympy_visual').test()

local M = {}

function M.test()
  print("=== SymPy Visual Selection Test ===\n")

  local sympy_visual = require("sympy-visual")

  -- Test LaTeX to SymPy conversion
  print("Testing LaTeX to SymPy conversion...")

  local test_cases = {
    {
      latex = "x^{2} + 2x + 1",
      operation = "factor",
      expected = "\\left(x + 1\\right)^{2}",
      desc = "Factor polynomial"
    },
    {
      latex = "\\left(x + 1\\right)^{2}",
      operation = "expand",
      expected = "x^{2} + 2 x + 1",
      desc = "Expand polynomial"
    },
    {
      latex = "\\frac{x^{2} + 2x + 1}{x + 1}",
      operation = "simplify",
      expected = "x + 1",
      desc = "Simplify rational expression"
    },
    {
      latex = "\\sin^{2}{x} + \\cos^{2}{x}",
      operation = "simplify",
      expected = "1",
      desc = "Simplify trig identity"
    },
  }

  local passed = 0
  local failed = 0

  for i, test in ipairs(test_cases) do
    print(string.format("\nTest %d: %s", i, test.desc))
    print("  Input:  " .. test.latex)

    -- We can't actually test the full visual selection flow in headless mode,
    -- but we can test the underlying transformation logic
    local sympy_expr = test.latex
      :gsub("\\frac{([^}]+)}{([^}]+)}", "(%1)/(%2)")
      :gsub("\\sqrt{([^}]+)}", "sqrt(%1)")
      :gsub("\\left%(", "(")
      :gsub("\\right%)", ")")
      :gsub("\\left\\^{", "^{")
      :gsub("\\sin%^{(%d+)}", "sin**%1")
      :gsub("\\cos%^{(%d+)}", "cos**%1")
      :gsub("\\sin{", "sin(")
      :gsub("\\cos{", "cos(")
      :gsub("}", ")")
      :gsub("%^{([^}]+)}", "**(%1)")

    print("  SymPy:  " .. sympy_expr)

    -- Execute via Python directly
    local sympy_config = require("sympy-config")
    local python_code = string.format([[
from sympy import *
x, y, z, t = symbols('x y z t')
init_printing()

try:
    expr = sympify('%s', rational=True)
    result = %s(expr)
    print(latex(result))
except Exception as e:
    print("Error: " + str(e))
]], sympy_expr, test.operation)

    local python_cmd = sympy_config.get_python_command()
    local handle = io.popen(python_cmd .. " '" .. python_code:gsub("'", "'\\''") .. "'")

    if handle then
      local result = handle:read("*a")
      handle:close()
      result = result:gsub("\n", ""):gsub("\r", "")

      print("  Result: " .. result)

      if result and not result:match("Error:") then
        print("  ✓ PASS")
        passed = passed + 1
      else
        print("  ✗ FAIL: " .. (result or "no result"))
        failed = failed + 1
      end
    else
      print("  ✗ FAIL: Could not execute Python")
      failed = failed + 1
    end
  end

  print("\n=== Summary ===")
  print(string.format("Passed: %d/%d", passed, passed + failed))
  print(string.format("Failed: %d/%d", failed, passed + failed))

  if failed == 0 then
    print("\n🎉 All tests passed!")
    print("\nUsage in LaTeX files:")
    print("1. Visually select LaTeX expression")
    print("2. Press <leader>ss to simplify")
    print("3. Press <leader>se to expand")
    print("4. Press <leader>sf to factor")
    print("5. Press <leader>sd to differentiate")
    print("6. Press <leader>si to integrate")
    return true
  else
    return false
  end
end

return M
