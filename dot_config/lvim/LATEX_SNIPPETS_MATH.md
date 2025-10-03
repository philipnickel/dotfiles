# Math Snippets (Inside Math)

This document provides a reference for LaTeX snippets that work inside math mode.

## Greek Letters

| Trigger | Output | Description |
|---------|--------|-------------|
| `;a` | `\alpha` | Alpha |
| `;b` | `\beta` | Beta |
| `;g` | `\gamma` | Gamma |
| `;d` | `\delta` | Delta |
| `;e` | `\epsilon` | Epsilon |
| `;z` | `\zeta` | Zeta |
| `;h` | `\eta` | Eta |
| `;t` | `\theta` | Theta |
| `;i` | `\iota` | Iota |
| `;k` | `\kappa` | Kappa |
| `;l` | `\lambda` | Lambda |
| `;m` | `\mu` | Mu |
| `;n` | `\nu` | Nu |
| `;x` | `\xi` | Xi |
| `;o` | `\omicron` | Omicron |
| `;p` | `\pi` | Pi |
| `;r` | `\rho` | Rho |
| `;s` | `\sigma` | Sigma |
| `;u` | `\upsilon` | Upsilon |
| `;f` | `\phi` | Phi |
| `;c` | `\chi` | Chi |
| `;y` | `\psi` | Psi |
| `;w` | `\omega` | Omega |

## Capital Greek Letters

| Trigger | Output | Description |
|---------|--------|-------------|
| `;A` | `\Alpha` | Capital Alpha |
| `;B` | `\Beta` | Capital Beta |
| `;G` | `\Gamma` | Capital Gamma |
| `;D` | `\Delta` | Capital Delta |
| `;E` | `\Epsilon` | Capital Epsilon |
| `;Z` | `\Zeta` | Capital Zeta |
| `;H` | `\Eta` | Capital Eta |
| `;T` | `\Theta` | Capital Theta |
| `;I` | `\Iota` | Capital Iota |
| `;K` | `\Kappa` | Capital Kappa |
| `;L` | `\Lambda` | Capital Lambda |
| `;M` | `\Mu` | Capital Mu |
| `;N` | `\Nu` | Capital Nu |
| `;X` | `\Xi` | Capital Xi |
| `;O` | `\Omicron` | Capital Omicron |
| `;P` | `\Pi` | Capital Pi |
| `;R` | `\Rho` | Capital Rho |
| `;S` | `\Sigma` | Capital Sigma |
| `;U` | `\Upsilon` | Capital Upsilon |
| `;F` | `\Phi` | Capital Phi |
| `;C` | `\Chi` | Capital Chi |
| `;Y` | `\Psi` | Capital Psi |
| `;W` | `\Omega` | Capital Omega |

## Math Symbols

| Trigger | Output | Description |
|---------|--------|-------------|
| `ff` | `\frac{}{}` | Fraction |
| `sum` | `\sum_{}^{}` | Summation |
| `int` | `\int_{}^{}` | Integral |
| `lim` | `\lim_{}` | Limit |
| `prod` | `\prod_{}^{}` | Product |
| `sqrt` | `\sqrt{}` | Square root |
| `nth` | `\sqrt[n]{}` | nth root |
| `oo` | `\infty` | Infinity |
| `partial` | `\partial` | Partial derivative |
| `nabla` | `\nabla` | Nabla |
| `cdot` | `\cdot` | Dot product |
| `times` | `\times` | Times |
| `div` | `\div` | Division |
| `pm` | `\pm` | Plus/minus |
| `mp` | `\mp` | Minus/plus |
| `leq` | `\leq` | Less than or equal |
| `geq` | `\geq` | Greater than or equal |
| `neq` | `\neq` | Not equal |
| `approx` | `\approx` | Approximately equal |
| `equiv` | `\equiv` | Equivalent |
| `propto` | `\propto` | Proportional to |
| `in` | `\in` | Element of |
| `notin` | `\notin` | Not element of |
| `subset` | `\subset` | Subset |
| `supset` | `\supset` | Superset |
| `cap` | `\cap` | Intersection |
| `cup` | `\cup` | Union |
| `emptyset` | `\emptyset` | Empty set |
| `forall` | `\forall` | For all |
| `exists` | `\exists` | There exists |
| `rightarrow` | `\rightarrow` | Right arrow |
| `leftarrow` | `\leftarrow` | Left arrow |
| `leftrightarrow` | `\leftrightarrow` | Left-right arrow |
| `Rightarrow` | `\Rightarrow` | Double right arrow |
| `Leftarrow` | `\Leftarrow` | Double left arrow |
| `Leftrightarrow` | `\Leftrightarrow` | Double left-right arrow |

## Math Environments

| Trigger | Output | Description |
|---------|--------|-------------|
| `align` | `\begin{align}...\end{align}` | Align equations |
| `alignat` | `\begin{alignat}{}...\end{alignat}` | Align at equations |
| `eqnarray` | `\begin{eqnarray}...\end{eqnarray}` | Equation array |
| `gather` | `\begin{gather}...\end{gather}` | Gather equations |
| `multline` | `\begin{multline}...\end{multline}` | Multiline equation |
| `split` | `\begin{split}...\end{split}` | Split equation |
| `cases` | `\begin{cases}...\end{cases}` | Cases environment |
| `matrix` | `\begin{matrix}...\end{matrix}` | Matrix |
| `pmatrix` | `\begin{pmatrix}...\end{pmatrix}` | Parentheses matrix |
| `bmatrix` | `\begin{bmatrix}...\end{bmatrix}` | Brackets matrix |
| `vmatrix` | `\begin{vmatrix}...\end{vmatrix}` | Vertical bars matrix |
| `Vmatrix` | `\begin{Vmatrix}...\end{Vmatrix}` | Double vertical bars matrix |

## Usage Tips

1. **Math Mode Only**: These snippets only work inside math mode (`$...$`, `\[...\]`, etc.)
2. **Autosnippets**: Most snippets expand automatically when you type the trigger
3. **Context Detection**: Uses VimTeX to detect math mode automatically
4. **Visual Selection**: Select text and press `<Tab>` to store it for use in snippets

## Keybindings

- `<Tab>` - Expand snippet or jump to next tabstop
- `<Shift-Tab>` - Jump to previous tabstop
- `<Ctrl-l>` - Cycle through choice nodes