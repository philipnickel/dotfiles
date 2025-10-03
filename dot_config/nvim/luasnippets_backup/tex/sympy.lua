-- SymPy evaluation snippets for LaTeX
-- Allows evaluation of mathematical expressions using SymPy

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

-- Load SymPy configuration
local sympy_config = require("sympy-config")

-- Load helper functions for math zone detection
local helpers = require("utils.luasnip-helper-funcs")

-- Helper function to evaluate SymPy expressions
local function evaluate_sympy(expr)
  -- Clean up the expression for Python evaluation
  local cleaned_expr = expr
    :gsub("\\", "")  -- Remove backslashes
    :gsub("%^", "**")  -- Convert ^ to ** for Python
    :gsub("{", "(")  -- Convert { to (
    :gsub("}", ")")  -- Convert } to )
    :gsub("\\frac%s*%(%s*([^,]+)%s*,%s*([^)]+)%)", "(%1)/(%2)")  -- Convert \frac{a,b} to (a)/(b)
    :gsub("\\sqrt%s*%(%s*([^)]+)%)", "sqrt(%1)")  -- Convert \sqrt{a} to sqrt(a)
    :gsub("\\pi", "pi")  -- Convert \pi to pi
    :gsub("\\e", "E")  -- Convert \e to E
    :gsub("\\infty", "oo")  -- Convert \infty to oo
  
  -- Python code to evaluate the expression
  local python_code = string.format([[
import subprocess
import sys

try:
    # Import sympy with rational division
    from sympy import *
    from sympy.parsing.latex import parse_latex

    # Set up symbols
    x, y, z, t = symbols('x y z t')
    k, m, n = symbols('k m n', integer=True)
    f, g, h = symbols('f g h', cls=Function)

    # Initialize printing
    init_printing()

    # Try to evaluate the expression
    try:
        # Use sympify for symbolic evaluation (preserves fractions)
        result = sympify('%s', rational=True)
        latex_result = latex(result)
    except:
        # If that fails, try direct eval
        try:
            result = eval('%s')
            latex_result = latex(result)
        except:
            # Last resort: try parsing as LaTeX
            result = parse_latex('%s')
            latex_result = latex(result)

    print(latex_result)

except Exception as e:
    print("Error: " + str(e))
]], cleaned_expr, cleaned_expr, cleaned_expr)
  
  -- Get the best Python command from configuration
  local python_cmd = sympy_config.get_python_command()
  
  local result = ""
  local success = false
  
  -- Try the configured Python command
  local handle = io.popen(python_cmd .. " '" .. python_code:gsub("'", "'\\''") .. "'")
  if handle then
    result = handle:read("*a")
    handle:close()
    
    -- Check if we got a valid result (not an error)
    if result and not result:match("Error:") and result ~= "" then
      success = true
    end
  end
  
  -- If configured command failed, try fallback paths
  if not success then
    for _, path in ipairs(sympy_config.config.python_paths) do
      local cmd = path .. " -c"
      local handle = io.popen(cmd .. " '" .. python_code:gsub("'", "'\\''") .. "'")
      if handle then
        result = handle:read("*a")
        handle:close()
        
        if result and not result:match("Error:") and result ~= "" then
          success = true
          break
        end
      end
    end
  end
  
  -- Clean up the result
  result = result:gsub("\n", ""):gsub("\r", "")
  
  -- Return the result or the original expression if there was an error
  if not success or result:match("Error:") or result == "" then
    return expr  -- Return original if evaluation failed
  else
    return result
  end
end

return {
-- SymPy block snippet - ONLY autosnippet with ; prefix
s({trig = ";sy", name = "SymPy block", snippetType = "autosnippet"},
  fmta("sympy <> sympy", { i(1) }),
  { condition = function() return true end }  -- Always available (has ; prefix)
),

-- SymPy evaluation snippet (regex trigger) - manual snippet, press Tab after typing "sympy ... sympy"
s({trig = "sympy(.*)sympy", name = "Evaluate SymPy", regTrig = true},
  f(function(_, snip)
    local expr = snip.captures[1]
    if expr and expr ~= "" then
      return evaluate_sympy(expr)
    else
      return "sympy expression sympy"
    end
  end),
  { condition = function() return true end }  -- Always available
),

-- Common mathematical expressions (manual snippets - require Tab to trigger)
-- Only trigger in math mode
s({trig = "eval", name = "Evaluate expression"},
  fmta("sympy <> sympy", { i(1, "1 + 1") }),
  { condition = helpers.in_mathzone }
),

-- Derivative evaluation - math mode only
s({trig = "sydi", name = "Derivative"},
  fmta("sympy diff(<>, <>) sympy", { i(1, "x**2"), i(2, "x") }),
  { condition = helpers.in_mathzone }
),

-- Integral evaluation - math mode only
s({trig = "syin", name = "Integral"},
  fmta("sympy integrate(<>, <>) sympy", { i(1, "x**2"), i(2, "x") }),
  { condition = helpers.in_mathzone }
),

-- Limit evaluation - math mode only
s({trig = "syli", name = "Limit"},
  fmta("sympy limit(<>, <>, <>) sympy", { i(1, "sin(x)/x"), i(2, "x"), i(3, "0") }),
  { condition = helpers.in_mathzone }
),

-- Sum evaluation - math mode only
s({trig = "sysu", name = "Sum"},
  fmta("sympy Sum(<>, (<>, <>, <>)) sympy", { i(1, "k"), i(2, "k"), i(3, "1"), i(4, "n") }),
  { condition = helpers.in_mathzone }
),

-- Matrix operations - math mode only
s({trig = "syma", name = "Matrix"},
  fmta("sympy Matrix([<>, <>], [<>, <>]) sympy", { i(1, "1"), i(2, "2"), i(3, "3"), i(4, "4") }),
  { condition = helpers.in_mathzone }
),

-- Solve equations - math mode only
s({trig = "syso", name = "Solve equation"},
  fmta("sympy solve(<>, <>) sympy", { i(1, "x**2 - 1"), i(2, "x") }),
  { condition = helpers.in_mathzone }
),

-- Visual selection snippets - select LaTeX, press Tab, then type trigger
-- These work in math mode only
s({trig = "sysi", name = "Simplify (visual or manual)"},
  f(function(_, snip)
    local selected = snip.env.SELECT_RAW or snip.env.TM_SELECTED_TEXT or ""
    if selected and selected ~= "" then
      -- Clean LaTeX syntax
      local cleaned = selected
        :gsub("\\frac{([^}]+)}{([^}]+)}", "(%1)/(%2)")
        :gsub("\\sqrt{([^}]+)}", "sqrt(%1)")
        :gsub("\\left%(", "("):gsub("\\right%)", ")")
        :gsub("\\left%[", "["):gsub("\\right%]", "]")
        :gsub("\\cdot", "*"):gsub("\\times", "*")
        :gsub("%^{([^}]+)}", "**(%1)")
        :gsub("\\pi", "pi"):gsub("\\sin", "sin"):gsub("\\cos", "cos")
        :gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

      return evaluate_sympy("simplify(" .. cleaned .. ")")
    end
    return "sympy simplify() sympy"
  end),
  { condition = helpers.in_mathzone }
),

s({trig = "syex", name = "Expand (visual or manual)"},
  f(function(_, snip)
    local selected = snip.env.SELECT_RAW or snip.env.TM_SELECTED_TEXT or ""
    if selected and selected ~= "" then
      local cleaned = selected
        :gsub("\\frac{([^}]+)}{([^}]+)}", "(%1)/(%2)")
        :gsub("\\left%(", "("):gsub("\\right%)", ")")
        :gsub("%^{([^}]+)}", "**(%1)")
        :gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

      return evaluate_sympy("expand(" .. cleaned .. ")")
    end
    return "sympy expand() sympy"
  end),
  { condition = helpers.in_mathzone }
),

s({trig = "syfa", name = "Factor (visual or manual)"},
  f(function(_, snip)
    local selected = snip.env.SELECT_RAW or snip.env.TM_SELECTED_TEXT or ""
    if selected and selected ~= "" then
      local cleaned = selected
        :gsub("\\frac{([^}]+)}{([^}]+)}", "(%1)/(%2)")
        :gsub("\\left%(", "("):gsub("\\right%)", ")")
        :gsub("%^{([^}]+)}", "**(%1)")
        :gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

      return evaluate_sympy("factor(" .. cleaned .. ")")
    end
    return "sympy factor() sympy"
  end),
  { condition = helpers.in_mathzone }
),

}