# SymPy LaTeX Snippets - Setup Complete ✓

## What's Working

✅ **LaTeX Output** - All results properly formatted as LaTeX
✅ **Math Mode Only** - Snippets only trigger in math environments
✅ **Visual Selection** - Tab workflow for transforming expressions
✅ **Python Integration** - Using system Python with SymPy installed

## Current Snippet Behavior

### Only Autosnippet: `;sy`
- **Trigger:** `;sy` (automatic expansion)
- **Location:** Works anywhere in LaTeX file
- **Usage:** `;sy<Tab>` → type expression → `<Tab>` to evaluate

### All Other Snippets: Manual (Require Tab)
- **Location:** Only work in math mode (`$...$`, `$$...$$`, equations, etc.)
- **Usage:** Type trigger + `<Tab>` to expand

## Quick Reference

### Basic Evaluation
```latex
;sy<Tab>1 + 1<Tab>           → 2
;sy<Tab>1/2<Tab>             → \frac{1}{2}
;sy<Tab>x**2<Tab>            → x^{2}
;sy<Tab>diff(x**2, x)<Tab>   → 2 x
```

### Visual Selection (In Math Mode)
```latex
1. Write: \frac{x^{2} + 2x + 1}{x + 1}
2. Select: v + motion
3. Store: Tab
4. Type: sysi
5. Expand: Tab
6. Result: x + 1
```

### Available Snippets (Math Mode Only)

| Trigger | Description | Example |
|---------|-------------|---------|
| `sydi<Tab>` | Derivative template | `sympy diff(x**2, x) sympy` |
| `syin<Tab>` | Integral template | `sympy integrate(x**2, x) sympy` |
| `syli<Tab>` | Limit template | `sympy limit(sin(x)/x, x, 0) sympy` |
| `sysu<Tab>` | Sum template | `sympy Sum(k, (k, 1, n)) sympy` |
| `syso<Tab>` | Solve template | `sympy solve(x**2 - 1, x) sympy` |
| `sysi<Tab>` | Simplify (visual/manual) | Simplifies expression |
| `syex<Tab>` | Expand (visual/manual) | Expands polynomial |
| `syfa<Tab>` | Factor (visual/manual) | Factors polynomial |

## Examples with LaTeX Output

### Fractions
```
Input:  1/2
Output: \frac{1}{2}
```

### Polynomials
```
Input:  expand((x + 1)**2)
Output: x^{2} + 2 x + 1
```

### Derivatives
```
Input:  diff(sin(x**2), x)
Output: 2 x \cos{\left(x^{2} \right)}
```

### Integrals
```
Input:  integrate(x**2, x)
Output: \frac{x^{3}}{3}
```

### Solving Equations
```
Input:  solve(x**2 - 5*x + 6, x)
Output: \left[ 2, \ 3\right]
```

### Simplification
```
Input:  simplify((x**2 + 2*x + 1)/(x + 1))
Output: x + 1
```

## Visual Selection Examples

### Example 1: Simplify Fraction
```latex
Math mode: $\frac{x^{2} + 2x + 1}{x + 1}$

1. Visually select: \frac{x^{2} + 2x + 1}{x + 1}
2. Press Tab (stores selection)
3. Type: sysi
4. Press Tab (evaluates)
5. Result: x + 1
```

### Example 2: Expand Polynomial
```latex
Math mode: $(x + 1)^{2}$

1. Select: (x + 1)^{2}
2. Tab → syex → Tab
3. Result: x^{2} + 2 x + 1
```

### Example 3: Factor Expression
```latex
Math mode: $x^{2} - 1$

1. Select: x^{2} - 1
2. Tab → syfa → Tab
3. Result: \left(x - 1\right) \left(x + 1\right)
```

## Troubleshooting

### Snippets Not Triggering
1. **Reload snippets:** `<Leader>L` in LunarVim
2. **Check math mode:** Use `:lua print(vim.fn['vimtex#syntax#in_mathzone']())` (should return 1)
3. **Check filetype:** Run `:set ft?` (should show `filetype=tex`)

### Wrong Output Format
If you get `0.5` instead of `\frac{1}{2}`:
- The issue is with Python evaluation
- SymPy is using `sympify(expr, rational=True)` which should preserve fractions
- Test manually: `python3 -c "from sympy import *; print(latex(sympify('1/2', rational=True)))"`

### Visual Selection Not Working
1. Make sure you're in math mode
2. Press Tab after selecting (stores selection)
3. Type the snippet trigger (sysi, syex, syfa)
4. Press Tab again to expand

## Files Modified

- `luasnippets/tex/sympy.lua` - Snippet definitions
- `lua/sympy-config.lua` - Python/SymPy detection
- `lua/sympy-visual.lua` - Helper functions (optional)
- `lua/keymaps.lua` - No custom keymaps (using Tab workflow)

## Testing

Run comprehensive tests:
```vim
:lua require('test_sympy_e2e').test()
```

Quick test:
```vim
:lua require('test_sympy_e2e').quick_test()
```

## Python Requirements

SymPy must be installed:
```bash
python3 -m pip install --user --break-system-packages sympy
```

Verify:
```bash
python3 -c "from sympy import *; print('SymPy version:', __version__)"
```

## Summary

✅ SymPy evaluation works correctly
✅ Outputs proper LaTeX format
✅ Visual selection uses Tab workflow
✅ Only `;sy` is an autosnippet
✅ All other snippets work in math mode only
✅ No conflicts with existing snippets

**Ready to use!** Open a LaTeX file and try `;sy<Tab>1/2<Tab>` 🎉
