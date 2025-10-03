# VimTeX Character Mappings Customization

This document shows how to customize VimTeX's automatic character mappings in math mode.

## Default Mappings

VimTeX automatically converts these characters in math mode:

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

## Customization Options

### Option 1: Disable All Mappings

Add this to your VimTeX configuration:

```lua
-- Disable all VimTeX character mappings
vim.g.vimtex_imaps_enabled = 0
```

### Option 2: Disable Specific Mappings

To disable only the `;` mapping (subscript), add this to your VimTeX configuration:

```lua
-- Disable specific mappings
vim.g.vimtex_imaps_list = {
  [';'] = '',  -- Disable ; -> _ mapping
  -- Keep other mappings like ':' -> '}' and '8' -> '\infty'
}
```

### Option 3: Customize Individual Mappings

```lua
-- Customize specific mappings
vim.g.vimtex_imaps_list = {
  [';'] = '',           -- Disable ; -> _ mapping
  ['8'] = '\\infty',   -- Keep 8 -> \infty
  ['0'] = '\\emptyset', -- Keep 0 -> \emptyset
  ['6'] = '\\partial', -- Keep 6 -> \partial
  ['*'] = '\\cdot',    -- Keep * -> \cdot
  ['+'] = '\\pm',      -- Keep + -> \pm
  ['-'] = '\\mp',      -- Keep - -> \mp
  ['='] = '\\equiv',   -- Keep = -> \equiv
  ['<'] = '\\leq',     -- Keep < -> \leq
  ['>'] = '\\geq',     -- Keep > -> \geq
  ['!'] = '\\neq',     -- Keep ! -> \neq
  ['('] = '\\left(',   -- Keep ( -> \left(
  [')'] = '\\right)',  -- Keep ) -> \right)
  ['['] = '\\left[',   -- Keep [ -> \left[
  [']'] = '\\right]',  -- Keep ] -> \right]
  ['{'] = '\\left{',   -- Keep { -> \left{
  ['}'] = '\\right}',  -- Keep } -> \right}
}
```

### Option 4: Add New Mappings

```lua
-- Add new mappings
vim.g.vimtex_imaps_list = {
  [';'] = '',           -- Disable ; -> _ mapping
  ['@'] = '\\alpha',    -- Add @ -> \alpha mapping
  ['#'] = '\\beta',     -- Add # -> \beta mapping
  ['$'] = '\\gamma',    -- Add $ -> \gamma mapping
  -- ... other mappings
}
```

## Where to Add Configuration

Add the configuration to your VimTeX setup. In LunarVim, this would typically go in:

```lua
-- In your VimTeX configuration file
vim.g.vimtex_imaps_enabled = 1  -- Enable mappings (default)

-- Customize specific mappings
vim.g.vimtex_imaps_list = {
  [';'] = '',  -- Disable ; -> _ mapping
  -- Keep other mappings as default
}
```

## Toggle Functionality

Use `<leader>sm` to toggle VimTeX character mappings on/off:

- **Enabled**: Characters like `8`, `0`, `6`, etc. automatically convert to LaTeX commands
- **Disabled**: All characters type literally

**Note**: The toggle may require switching to another buffer and back, or reloading the file (`:e`) to take full effect, as VimTeX mappings are buffer-specific.

## Examples

### With Mappings Enabled (Default)
- Type `8` → `\infty`
- Type `0` → `\emptyset`
- Type `;` → `_` (subscript)

### With Mappings Disabled
- Type `8` → `8` (literal)
- Type `0` → `0` (literal)
- Type `;` → `;` (literal)

### With Custom Mappings (; disabled)
- Type `8` → `\infty`
- Type `0` → `\emptyset`
- Type `;` → `;` (literal - no subscript)

## Tips

1. **Test Changes**: Restart Neovim after changing VimTeX configuration
2. **Math Mode Only**: Mappings only work inside math environments (`$...$`, `\[...\]`, etc.)
3. **Literal Characters**: Use `\` prefix or `{}` prefix to type literal characters when mappings are enabled
4. **Toggle On/Off**: Use `<leader>sm` to quickly enable/disable all mappings
5. **Customize Selectively**: You can disable specific mappings while keeping others

## Troubleshooting

If mappings don't work:

1. **Check VimTeX**: Ensure VimTeX is properly installed and configured
2. **Check Math Mode**: Mappings only work in math mode
3. **Check Configuration**: Ensure your configuration is in the right place
4. **Restart Neovim**: Some changes require a restart to take effect