# SymPy Visual Selection Quick Reference

## Two Ways to Use SymPy

### 1. Inline Evaluation with `;sy` (Works Everywhere)
```
Type:     ;sy<Tab>1+1<Tab>
Result:   2
Location: Anywhere in LaTeX file
```

### 2. Visual Selection (Math Mode Only)
```
Select:   x^{2} + 2x + 1
Action:   Tab → syfa → Tab
Result:   \left(x + 1\right)^{2}
Location: Must be in math mode ($...$, $$...$$, \begin{equation}, etc.)
```

## Math Mode Requirement

**Important:** All SymPy snippets (except `;sy`) only trigger in math mode:
- Inline math: `$...$`
- Display math: `$$...$$`
- Equation environments: `\begin{equation}...\end{equation}`
- Align environments: `\begin{align}...\end{align}`

**Exception:** `;sy` with semicolon prefix works everywhere!

## Visual Selection Snippets

These snippets work with visual selection using the Tab workflow:

| Trigger | Operation | Use Case |
|---------|-----------|----------|
| `sysi` | Simplify | Simplify complex expressions |
| `syex` | Expand | Expand polynomials |
| `syfa` | Factor | Factor polynomials |

## Visual Selection Workflow

1. **Write** your LaTeX expression
2. **Select** it visually (`v` + motion)
3. **Store** with `Tab`
4. **Type** snippet trigger (`sysi`, `syex`, or `syfa`)
5. **Expand** with `Tab`
6. **Result** appears in place

## Examples

### Example 1: Simplify Rational Expression
```latex
Original:  \frac{x^{2} + 2x + 1}{x + 1}
Select:    v + select
Action:    Tab → sysi → Tab
Result:    x + 1
```

### Example 2: Expand Polynomial
```latex
Original:  \left(x + 1\right)^{2}
Select:    v + select
Action:    Tab → syex → Tab
Result:    x^{2} + 2 x + 1
```

### Example 3: Factor Polynomial
```latex
Original:  x^{2} - 1
Select:    v + select
Action:    Tab → syfa → Tab
Result:    \left(x - 1\right) \left(x + 1\right)
```

### Example 4: Simplify Trig Identity
```latex
Original:  \sin^{2}{x} + \cos^{2}{x}
Select:    v + select
Action:    Tab → sysi → Tab
Result:    1
```

## Other SymPy Snippets (Manual Entry)

These require typing the full `sympy ... sympy` wrapper:

| Trigger | Expands To |
|---------|------------|
| `sydi` | `sympy diff(x**2, x) sympy` |
| `syin` | `sympy integrate(x**2, x) sympy` |
| `syli` | `sympy limit(sin(x)/x, x, 0) sympy` |
| `sysu` | `sympy Sum(k, (k, 1, n)) sympy` |
| `syso` | `sympy solve(x**2 - 1, x) sympy` |

Then press `Tab` to evaluate.

## Tips

- Visual selection uses the **same Tab key** you use for snippets
- The snippets auto-detect if you have a visual selection
- Without selection, they return a template `sympy ... sympy`
- All operations output proper LaTeX format
- Reload snippets after changes: `<Leader>L`

## Supported LaTeX Syntax

The visual snippets understand these LaTeX commands:
- `\frac{a}{b}` → fractions
- `\sqrt{x}` → square roots
- `x^{n}` → exponents
- `\left(` / `\right)` → parentheses
- `\sin`, `\cos`, `\tan` → trig functions
- `\pi` → pi constant
- `\cdot`, `\times` → multiplication

## Quick Access

Press `<leader>sy` in any LaTeX file to see this guide!
