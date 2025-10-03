# SymPy Mathematical Evaluation Guide

This guide explains how to use SymPy snippets for mathematical calculations and LaTeX output.

## Quick Access

- **Press `<leader>sp`** to open this guide anytime
- **Press `<leader>sy`** for the full SymPy evaluation guide
- **Press `<leader>ss`** for general snippet documentation

## Basic Usage

### Simple Evaluation
- **Type `sympy`** → Creates `sympy expression sympy`
- **Type `sympy 1 + 1 sympy`** → Expands to `2`
- **Type `sympy 2^3 sympy`** → Expands to `8`

### General Pattern
```
sympy [mathematical expression] sympy
```

## Supported Operations

### Arithmetic
| Expression | Result |
|------------|--------|
| `sympy 1 + 1 sympy` | `2` |
| `sympy 2 * 3 sympy` | `6` |
| `sympy 10 / 2 sympy` | `5` |
| `sympy 2^3 sympy` | `8` |

### Functions
| Expression | Result |
|------------|--------|
| `sympy sin(pi/2) sympy` | `1` |
| `sympy cos(0) sympy` | `1` |
| `sympy sqrt(4) sympy` | `2` |
| `sympy log(e) sympy` | `1` |

### Constants
| Expression | Result |
|------------|--------|
| `sympy pi sympy` | `\pi` |
| `sympy e sympy` | `e` |
| `sympy oo sympy` | `\infty` |

## Advanced Operations

### Derivatives
- **Type `diff`** → Creates `sympy diff(x**2, x) sympy`
- **Expands to** → `2x`

### Integrals
- **Type `int`** → Creates `sympy integrate(x**2, x) sympy`
- **Expands to** → `\frac{x^{3}}{3}`

### Limits
- **Type `lim`** → Creates `sympy limit(sin(x)/x, x, 0) sympy`
- **Expands to** → `1`

### Sums
- **Type `sum`** → Creates `sympy Sum(k, (k, 1, n)) sympy`
- **Expands to** → `\frac{n \left(n + 1\right)}{2}`

### Matrices
- **Type `mat`** → Creates `sympy Matrix([1, 2], [3, 4]) sympy`
- **Expands to** → Matrix representation

### Solving Equations
- **Type `solve`** → Creates `sympy solve(x**2 - 1, x) sympy`
- **Expands to** → `\left[ -1, \ 1\right]`

### Simplification
- **Type `simp`** → Creates `sympy simplify((x + 1)**2) sympy`
- **Type `exp`** → Creates `sympy expand((x + 1)**2) sympy`
- **Type `fact`** → Creates `sympy factor(x**2 - 1) sympy`

## LaTeX Conversion

### Automatic LaTeX Output
All SymPy evaluations automatically output LaTeX format:
- **Fractions**: `1/2` → `\frac{1}{2}`
- **Powers**: `x^2` → `x^{2}`
- **Square roots**: `sqrt(x)` → `\sqrt{x}`
- **Greek letters**: `alpha` → `\alpha`

### Supported LaTeX Commands
- `\frac{a}{b}` → `(a)/(b)` (converted for evaluation)
- `\sqrt{a}` → `sqrt(a)` (converted for evaluation)
- `\pi` → `pi` (converted for evaluation)
- `\infty` → `oo` (converted for evaluation)

## Examples

### Basic Arithmetic
```
sympy 2 + 3 * 4 sympy
→ 14
```

### Fractions
```
sympy 1/2 + 1/3 sympy
→ \frac{5}{6}
```

### Powers and Roots
```
sympy sqrt(16) + 2^3 sympy
→ 12
```

### Trigonometric Functions
```
sympy sin(pi/2) + cos(0) sympy
→ 2
```

### Calculus
```
sympy diff(x**3, x) sympy
→ 3 x^{2}

sympy integrate(x**2, x) sympy
→ \frac{x^{3}}{3}
```

### Limits
```
sympy limit((1 + 1/x)**x, x, oo) sympy
→ e
```

### Sums
```
sympy Sum(k, (k, 1, 10)) sympy
→ 55
```

### Solving Equations
```
sympy solve(x**2 - 5*x + 6, x) sympy
→ \left[ 2, \ 3\right]
```

### Matrix Operations
```
sympy Matrix([[1, 2], [3, 4]])**2 sympy
→ Matrix with result
```

## Error Handling

### Common Issues
- **Syntax errors**: Check Python syntax in expressions
- **Undefined variables**: Use symbols like `x`, `y`, `z`
- **Division by zero**: SymPy handles this gracefully
- **Complex results**: SymPy outputs complex numbers in LaTeX

### Troubleshooting
- **Expression not evaluating**: Check for typos in LaTeX commands
- **Python not found**: Ensure Python 3 is installed with SymPy
- **SymPy not installed**: Install with `pip install sympy`

## Tips and Tricks

### Efficient Usage
1. **Use tab completion** for common operations
2. **Combine operations** in single expressions
3. **Use symbols** for algebraic manipulation
4. **Check results** before using in documents

### Best Practices
- **Test expressions** before using in important documents
- **Use parentheses** for complex expressions
- **Be explicit** with variable definitions
- **Check LaTeX output** for formatting issues

## Installation Requirements

### Python Dependencies

**Recommended: Global installation with pipx**
```bash
pipx install sympy
```

**Alternative: User installation**
```bash
python3 -m pip install --user sympy
```

**System-wide installation**
```bash
pip install sympy
```

### System Requirements
- Python 3.6 or higher
- SymPy library
- LuaSnip with regex support

### Global SymPy Configuration
The SymPy snippets are configured to use a global SymPy installation with automatic fallback to different Python installations:

**Supported Python Paths (in order of preference):**
- `python3` - System Python 3
- `python` - System Python
- `/usr/bin/python3` - Explicit system path
- `/usr/local/bin/python3` - Homebrew Python (Intel)
- `/opt/homebrew/bin/python3` - Homebrew Python (Apple Silicon)

**Configuration File:** `lua/sympy-config.lua`
- Automatically detects working Python installations
- Validates SymPy installation
- Provides fallback mechanisms
- Configurable Python paths

**Validation:** The configuration automatically validates your SymPy setup on startup and shows notifications about the status.

### Testing Your Installation

**Run comprehensive test in Neovim:**
```lua
:lua require('test_sympy_real').test()
```

**Manual testing steps:**
1. **Check startup notifications** - Look for SymPy validation messages when LunarVim starts
2. **Test basic evaluation** - Type `sympy 1 + 1 sympy` in a LaTeX file
3. **Test LaTeX conversion** - Type `sympy x^2 sympy` to see LaTeX output
4. **Check Python detection** - The configuration automatically finds your Python installation

**Install SymPy if needed:**
```lua
:lua require('test_sympy_real').install_sympy()
```

## Advanced Features

### Custom Symbols
SymPy automatically defines common symbols:
- `x, y, z, t` - Basic variables
- `k, m, n` - Integer variables
- `f, g, h` - Function symbols

### Function Definitions
```python
# These are automatically available:
x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)
```

### LaTeX Parsing
SymPy can parse LaTeX expressions:
- Converts `\frac{a}{b}` to `(a)/(b)`
- Converts `\sqrt{a}` to `sqrt(a)`
- Converts `\pi` to `pi`
- Converts `\infty` to `oo`

## Integration with LaTeX

### Inline Math
Use SymPy results directly in LaTeX:
```latex
The derivative of $x^2$ is $\sympy diff(x**2, x) sympy$.
```

### Display Math
Use SymPy for complex calculations:
```latex
\begin{equation}
  \sympy integrate(sin(x), x) sympy
\end{equation}
```

### Mixed Content
Combine SymPy with regular LaTeX:
```latex
The solution to $x^2 - 1 = 0$ is $\sympy solve(x**2 - 1, x) sympy$.
```