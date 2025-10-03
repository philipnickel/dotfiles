# SymPy Snippets Test Instructions

## Features

### 1. Snippet-Based Evaluation
Type expressions with sympy delimiters and evaluate them.

### 2. Visual Selection Operations (NEW!)
Visually select LaTeX expressions and transform them with SymPy operations.

## Fix Applied
- Added `return {` at the beginning of the snippet list
- Added closing `}` at the end
- Made evaluation snippet manual (not autosnippet)
- Added visual selection support for LaTeX transformations
- Using `sympify()` with `rational=True` for proper LaTeX output

## How to Test in LunarVim

### Step 1: Reload Snippets
In LunarVim, press `<Leader>L` to reload snippets, or restart LunarVim.

### Step 2: Open a LaTeX File
```bash
lvim /tmp/test.tex
```

### Step 3: Test the ;sy Snippet
In the LaTeX file, in insert mode:

1. Type: `;sy`
2. Press: `<Tab>`
3. Expected result: Text expands to `sympy | sympy` with cursor in the middle (at |)
4. Type an expression: `1 + 1`
5. You should now see: `sympy 1 + 1 sympy`
6. Press: `<Tab>` again
7. Expected result: The text evaluates to `2`

## Quick Command Line Test

Run this in your terminal to test if snippets load:

```bash
cd /Users/philipnickel/Documents/GitHub/dotfiles/dot_config/lvim
lua -e 'assert(loadfile("luasnippets/tex/sympy.lua")); print("✓ Syntax OK")'
```

## In Neovim Test (Headless)

```bash
lvim --headless +'lua require("luasnip.loaders.from_lua").load({paths = vim.fn.stdpath("config") .. "/luasnippets/"}); print("Snippets loaded")' +quit
```

## Manual Visual Test

1. Open LunarVim: `lvim`
2. Create new LaTeX file: `:e /tmp/test.tex`
3. Enter insert mode: `i`
4. Type minimal document:
   ```latex
   \documentclass{article}
   \begin{document}


   \end{document}
   ```
5. Position cursor between `\begin{document}` and `\end{document}`
6. Type: `;sy` then `<Tab>`
7. If it works, you'll see: `sympy | sympy` (cursor at |)
8. Type: `2 + 3`
9. Press: `<Tab>`
10. Should evaluate to: `5`

## Example Expressions to Try

Once `;sy<Tab>` works:

| Type this | Get this |
|-----------|----------|
| `;sy<Tab>1 + 1<Tab>` | `2` |
| `;sy<Tab>x**2<Tab>` | `x^{2}` |
| `;sy<Tab>diff(x**2, x)<Tab>` | `2 x` |
| `;sy<Tab>integrate(x**2, x)<Tab>` | `\frac{x^{3}}{3}` |
| `;sy<Tab>sqrt(16)<Tab>` | `4` |

## Other SymPy Snippets Available

All these work as autosnippets (no Tab needed to trigger, just type and they expand):

- `diff` → Creates derivative template
- `int` → Creates integral template
- `lim` → Creates limit template
- `sum` → Creates sum template
- `solve` → Creates equation solver template
- `simp` → Creates simplify template
- `exp` → Creates expand template
- `fact` → Creates factor template

## Troubleshooting

If snippets don't appear:

1. **Reload snippets**: `<Leader>L` in LunarVim
2. **Check file location**: File must be at `~/.config/lvim/luasnippets/tex/sympy.lua`
3. **Check filetype**: Run `:set ft?` in vim - should show `filetype=tex`
4. **Check LuaSnip**: Run `:lua print(vim.inspect(require('luasnip').get_snippets('tex')))` to see loaded snippets
5. **Check sympy installation**: Run `:lua require('sympy-config').validate_config()`

## Visual Selection Operations (LaTeX Files Only)

In LaTeX files, you can visually select expressions and transform them using the Tab workflow:

### Available Operations

| Workflow | Operation | Example |
|----------|-----------|---------|
| Select + `Tab` + `sysi` + `Tab` | Simplify | `\frac{x^2+2x+1}{x+1}` → `x + 1` |
| Select + `Tab` + `syex` + `Tab` | Expand | `(x+1)^2` → `x^{2} + 2 x + 1` |
| Select + `Tab` + `syfa` + `Tab` | Factor | `x^2 - 1` → `\left(x - 1\right) \left(x + 1\right)` |

### Usage Example

1. In a `.tex` file, write: `\frac{x^{2} + 2x + 1}{x + 1}`
2. Visually select it: `v` then motion to select
3. Press `Tab` to store selection
4. Type `sysi` (for simplify)
5. Press `Tab` to expand snippet
6. Result: `x + 1`

### Complex Example - Trig Identity

1. Write: `\sin^{2}{x} + \cos^{2}{x}`
2. Visually select it
3. Press `Tab` to store
4. Type `sysi` and press `Tab`
5. Result: `1`

### Step-by-Step Visual Workflow

```
1. Write expression:    \frac{x^{2} + 2x + 1}{x + 1}
2. Visual select:       v + select text
3. Store in snippet:    Tab
4. Type trigger:        sysi
5. Expand snippet:      Tab
6. Result:              x + 1
```

## Complete End-to-End Tests

### Test snippet evaluation:
```vim
:lua require('test_sympy_e2e').test()
```

### Quick test:
```vim
:lua require('test_sympy_e2e').quick_test()
```

### Test visual operations:
```vim
:lua require('test_sympy_visual').test()
```
