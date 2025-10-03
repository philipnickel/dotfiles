-- SymPy Visual Selection Operations
-- Allows you to visually select LaTeX and transform it with SymPy

local M = {}
local sympy_config = require("sympy-config")

-- Helper function to clean LaTeX for SymPy
local function latex_to_sympy(latex_expr)
  local cleaned = latex_expr
    :gsub("\\frac{([^}]+)}{([^}]+)}", "(%1)/(%2)")  -- \frac{a}{b} → (a)/(b)
    :gsub("\\sqrt{([^}]+)}", "sqrt(%1)")             -- \sqrt{a} → sqrt(a)
    :gsub("\\left%(", "(")                           -- \left( → (
    :gsub("\\right%)", ")")                          -- \right) → )
    :gsub("\\left%[", "[")                           -- \left[ → [
    :gsub("\\right%]", "]")                          -- \right] → ]
    :gsub("\\left\\{", "{")                          -- \left\{ → {
    :gsub("\\right\\}", "}")                         -- \right\} → }
    :gsub("\\cdot", "*")                             -- \cdot → *
    :gsub("\\times", "*")                            -- \times → *
    :gsub("%^{([^}]+)}", "**(%1)")                   -- ^{n} → **(n)
    :gsub("\\pi", "pi")                              -- \pi → pi
    :gsub("\\infty", "oo")                           -- \infty → oo
    :gsub("\\sin", "sin")                            -- \sin → sin
    :gsub("\\cos", "cos")                            -- \cos → cos
    :gsub("\\tan", "tan")                            -- \tan → tan
    :gsub("\\log", "log")                            -- \log → log
    :gsub("\\ln", "ln")                              -- \ln → ln
    :gsub("\\exp", "exp")                            -- \exp → exp
    :gsub("%s+", " ")                                -- Normalize whitespace
    :gsub("^%s+", "")                                -- Trim leading
    :gsub("%s+$", "")                                -- Trim trailing

  return cleaned
end

-- Execute SymPy operation on expression
local function execute_sympy(expr, operation)
  local python_code = string.format([[
from sympy import *
x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)
init_printing()

try:
    expr = sympify('%s', rational=True)
    result = %s(expr)
    print(latex(result))
except Exception as e:
    print("Error: " + str(e))
]], expr, operation)

  local python_cmd = sympy_config.get_python_command()
  local handle = io.popen(python_cmd .. " '" .. python_code:gsub("'", "'\\''") .. "'")

  if handle then
    local result = handle:read("*a")
    handle:close()
    result = result:gsub("\n", ""):gsub("\r", "")

    if result and not result:match("Error:") and result ~= "" then
      return result
    else
      vim.notify("SymPy error: " .. (result or "unknown"), vim.log.levels.ERROR)
      return nil
    end
  end

  return nil
end

-- Get visually selected text
local function get_visual_selection()
  -- Save current register
  local save_reg = vim.fn.getreg('"')
  local save_regtype = vim.fn.getregtype('"')

  -- Yank visual selection to " register
  vim.cmd('noau normal! "vy')
  local selection = vim.fn.getreg('v')

  -- Restore register
  vim.fn.setreg('"', save_reg, save_regtype)

  return selection
end

-- Replace visual selection with result
local function replace_visual_selection(text)
  -- Delete selection and insert new text
  vim.cmd('noau normal! gv"_c' .. text)
  vim.cmd('noau normal! `<')
end

-- Main function to transform visual selection
function M.transform_selection(operation)
  local latex_expr = get_visual_selection()

  if not latex_expr or latex_expr == "" then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  -- Convert LaTeX to SymPy syntax
  local sympy_expr = latex_to_sympy(latex_expr)

  -- Execute operation
  local result = execute_sympy(sympy_expr, operation)

  if result then
    -- Replace selection with result
    replace_visual_selection(result)
    vim.notify("SymPy " .. operation .. " applied", vim.log.levels.INFO)
  end
end

-- Convenience functions for common operations
function M.simplify_selection()
  M.transform_selection("simplify")
end

function M.expand_selection()
  M.transform_selection("expand")
end

function M.factor_selection()
  M.transform_selection("factor")
end

function M.diff_selection()
  -- Prompt for variable
  local var = vim.fn.input("Differentiate with respect to (default: x): ")
  if var == "" then var = "x" end

  local latex_expr = get_visual_selection()
  local sympy_expr = latex_to_sympy(latex_expr)

  local python_code = string.format([[
from sympy import *
x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
init_printing()

try:
    expr = sympify('%s', rational=True)
    result = diff(expr, %s)
    print(latex(result))
except Exception as e:
    print("Error: " + str(e))
]], sympy_expr, var)

  local python_cmd = sympy_config.get_python_command()
  local handle = io.popen(python_cmd .. " '" .. python_code:gsub("'", "'\\''") .. "'")

  if handle then
    local result = handle:read("*a")
    handle:close()
    result = result:gsub("\n", ""):gsub("\r", "")

    if result and not result:match("Error:") and result ~= "" then
      replace_visual_selection(result)
      vim.notify("Derivative computed", vim.log.levels.INFO)
    end
  end
end

function M.integrate_selection()
  -- Prompt for variable
  local var = vim.fn.input("Integrate with respect to (default: x): ")
  if var == "" then var = "x" end

  local latex_expr = get_visual_selection()
  local sympy_expr = latex_to_sympy(latex_expr)

  local python_code = string.format([[
from sympy import *
x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
init_printing()

try:
    expr = sympify('%s', rational=True)
    result = integrate(expr, %s)
    print(latex(result))
except Exception as e:
    print("Error: " + str(e))
]], sympy_expr, var)

  local python_cmd = sympy_config.get_python_command()
  local handle = io.popen(python_cmd .. " '" .. python_code:gsub("'", "'\\''") .. "'")

  if handle then
    local result = handle:read("*a")
    handle:close()
    result = result:gsub("\n", ""):gsub("\r", "")

    if result and not result:match("Error:") and result ~= "" then
      replace_visual_selection(result)
      vim.notify("Integral computed", vim.log.levels.INFO)
    end
  end
end

return M
