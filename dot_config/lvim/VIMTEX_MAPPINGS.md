# VimTeX Character Mappings

This document explains VimTeX's automatic character mappings in math mode.

## Overview

VimTeX automatically converts certain characters in math mode to make LaTeX typing faster. These mappings only work inside math environments (`$...$`, `\[...\]`, etc.).

## Character Mappings

| Character | VimTeX Mapping | Description |
|-----------|----------------|-------------|
| `;` | `_` | Subscript |
| `:` | `}` | Closing brace |
| `8` | `\infty` | Infinity |
| `0` | `\emptyset` | Empty set |
| `6` | `\partial` | Partial derivative |
| `*` | `\cdot` | Dot product |
| `+` | `\pm` | Plus/minus |
| `-` | `\mp` | Minus/plus |
| `=` | `\equiv` | Equivalent |
| `<` | `\leq` | Less than or equal |
| `>` | `\geq` | Greater than or equal |
| `!` | `\neq` | Not equal |
| `(` | `\left(` | Left parenthesis |
| `)` | `\right)` | Right parenthesis |
| `[` | `\left[` | Left bracket |
| `]` | `\right]` | Right bracket |
| `{` | `\left{` | Left brace |
| `}` | `\right}` | Right brace |

## How to Type Literal Characters

If you want to type the actual character instead of the LaTeX command, use these workarounds:

### Method 1: Use Backslash
Type `\` before the character:
- `\8` → literal `8`
- `\0` → literal `0`
- `\;` → literal `;`
- `\:` → literal `:`

### Method 2: Use Empty Braces
Type `{}` before the character:
- `{}8` → literal `8`
- `{}0` → literal `0`
- `{};` → literal `;`
- `{}:` → literal `:`

## Examples

### Subscripts and Superscripts
- Type `x;1` → `x_1`
- Type `x;1:2` → `x_{12}`
- Type `x^2;1` → `x^2_1`

### Math Symbols
- Type `8` → `\infty`
- Type `0` → `\emptyset`
- Type `6` → `\partial`
- Type `*` → `\cdot`

### Comparisons
- Type `<` → `\leq`
- Type `>` → `\geq`
- Type `!` → `\neq`
- Type `=` → `\equiv`

### Delimiters
- Type `(` → `\left(`
- Type `)` → `\right)`
- Type `[` → `\left[`
- Type `]` → `\right]`

## Disabling Mappings

If you want to disable these mappings, add this to your VimTeX configuration:

```lua
vim.g.vimtex_imaps_enabled = 0  -- Disable all imaps
```

Or disable specific mappings:

```lua
vim.g.vimtex_imaps_list = {
  ['8'] = '',  -- Disable 8 -> \infty mapping
  ['0'] = '',  -- Disable 0 -> \emptyset mapping
  -- Keep other mappings like ';' -> '_' and ':' -> '}'
}
```

## Tips

1. **Context Matters**: These mappings only work in math mode
2. **Speed**: Much faster than typing `\infty`, `\emptyset`, etc.
3. **Convenience**: Automatic subscript/superscript handling
4. **Workarounds**: Use `\` or `{}` prefix for literal characters
5. **Customizable**: You can modify or disable specific mappings

## Common Use Cases

### Fractions
- Type `ff` → `\frac{}{}` (from luasnip-latex-snippets)
- Type `1/2` → `\frac{1}{2}` (with VimTeX mappings)

### Summations
- Type `sum` → `\sum_{}^{}` (from luasnip-latex-snippets)
- Type `sum;1:n` → `\sum_{1}^{n}` (with VimTeX mappings)

### Integrals
- Type `int` → `\int_{}^{}` (from luasnip-latex-snippets)
- Type `int;a:b` → `\int_{a}^{b}` (with VimTeX mappings)