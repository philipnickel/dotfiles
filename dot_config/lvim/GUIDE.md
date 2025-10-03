# LaTeX Snippets Smart Features Guide

This guide explains the advanced features and smart navigation capabilities of your LaTeX snippets.

## Smart Tab Navigation

### Fractions (`ff`)
- **Type `ff`** → Creates `\frac{}{}` with **two tab stops**
- **Press `<Tab>`** → Jumps to numerator
- **Press `<Tab>`** → Jumps to denominator  
- **Press `<Tab>`** → Exits snippet
- **Choice nodes**: You can cycle through `\frac`, `\dfrac`, `\tfrac` with `<Ctrl-l>`

### Matrices (e.g., `p3x4`)
- **Type `p3x4`** → Creates a 3×4 matrix with **all tab stops**
- **Press `<Tab>`** → Jumps through each matrix element
- **Smart navigation**: Goes row by row, column by column
- **Different types**: 
  - `p` = parentheses `\begin{pmatrix}`
  - `b` = brackets `\begin{bmatrix}`
  - `v` = vertical bars `\begin{vmatrix}`
  - `V` = double bars `\begin{Vmatrix}`

### Visual Selection
- **Select text** → Press `<Tab>` → Use snippets that support visual selection
- **Example**: Select `x^2` → Type `ff` → Creates `\frac{x^2}{}`

## Advanced Features

### Dynamic Nodes
- **Matrices auto-generate** based on dimensions (`p3x4` creates exactly 3×4)
- **Smart placeholders** for each element
- **Proper LaTeX formatting** with `&` and `\\`

### Choice Nodes
- **Multiple options** (like different fraction styles)
- **Cycle with `<Ctrl-l>`** to choose between options

### Context Awareness
- **Math mode detection** - snippets only work in math environments
- **Different behavior** inside vs outside math mode

## Keybindings for Navigation

- **`<Tab>`** - Jump to next tabstop
- **`<Shift-Tab>`** - Jump to previous tabstop  
- **`<Ctrl-l>`** - Cycle through choice nodes
- **Visual selection** - Select text first, then use snippets

## Practical Examples

### Fast Matrix Creation
1. **Type `p3x4`** → Creates 3×4 matrix with parentheses
2. **Press `<Tab>`** → Jumps to first element
3. **Type `a`** → Press `<Tab>` → Jumps to next element
4. **Continue tabbing** through all elements

### Smart Fractions
1. **Type `ff`** → Creates fraction
2. **Type numerator** → Press `<Tab>` → Jumps to denominator
3. **Type denominator** → Press `<Tab>` → Exits snippet

### Visual Selection Workflow
1. **Select text** (e.g., `x^2`)
2. **Press `<Tab>`** to store selection
3. **Type snippet trigger** (e.g., `ff`)
4. **Selected text** appears in the first tabstop

## Matrix Types and Examples

| Type | Trigger | Output | Description |
|------|---------|--------|-------------|
| `p` | `p3x4` | `\begin{pmatrix}...\end{pmatrix}` | Parentheses matrix |
| `b` | `b2x3` | `\begin{bmatrix}...\end{bmatrix}` | Brackets matrix |
| `v` | `v4x4` | `\begin{vmatrix}...\end{vmatrix}` | Vertical bars matrix |
| `V` | `V2x2` | `\begin{Vmatrix}...\end{Vmatrix}` | Double vertical bars matrix |

## Fraction Types

| Trigger | Options | Description |
|---------|---------|-------------|
| `ff` | `\frac`, `\dfrac`, `\tfrac` | Standard, display, and text fractions |

## Smart Features Summary

### Tab Navigation
- **Sequential jumping** through all placeholder positions
- **Visual feedback** showing current tabstop
- **Automatic exit** when reaching the end

### Visual Selection
- **Pre-select text** before using snippets
- **Automatic insertion** into first tabstop
- **Works with any snippet** that supports visual selection

### Dynamic Generation
- **Matrix dimensions** automatically calculated
- **Proper LaTeX syntax** generated
- **Smart formatting** with correct spacing

### Context Awareness
- **Math mode detection** using VimTeX
- **Conditional expansion** based on context
- **Different snippets** for different environments

## Tips and Tricks

1. **Use visual selection** for complex expressions
2. **Tab through matrices** systematically (row by row)
3. **Cycle through choices** with `<Ctrl-l>` for different styles
4. **Combine snippets** - use fractions inside matrices, etc.
5. **Practice tab navigation** to become efficient

## Troubleshooting

### Tab Navigation Not Working
- Ensure you're in insert mode
- Check that snippet has tabstops (`i(1)`, `i(2)`, etc.)
- Try `<Shift-Tab>` to go backward

### Visual Selection Not Working
- Select text first, then press `<Tab>`
- Make sure snippet supports visual selection
- Check that you're in the right context (math mode, etc.)

### Choice Nodes Not Cycling
- Use `<Ctrl-l>` to cycle through options
- Some snippets have multiple variants
- Check snippet definition for available choices

## Advanced Usage

### Nested Snippets
- Use snippets inside other snippets
- Example: fraction inside matrix element
- Tab navigation works through nested structures

### Custom Snippets
- Add your own snippets to `luasnippets/tex/`
- Use `i(1)`, `i(2)` for tabstops
- Use `d(1, function)` for dynamic content

### Performance Tips
- Snippets load lazily for better performance
- Use autosnippets for common patterns
- Reload snippets with `<leader>sr` after changes