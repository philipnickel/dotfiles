# All LaTeX Snippets

This document provides a comprehensive reference for all LaTeX snippets available through `luasnip-latex-snippets.nvim`.

## Text Formatting

| Trigger | Output | Description |
|---------|--------|-------------|
| `bf` | `\textbf{}` | Bold text |
| `it` | `\textit{}` | Italic text |
| `tt` | `\texttt{}` | Typewriter text |
| `em` | `\emph{}` | Emphasized text |
| `rm` | `\textrm{}` | Roman text |
| `sf` | `\textsf{}` | Sans serif text |
| `sc` | `\textsc{}` | Small caps text |
| `ul` | `\underline{}` | Underlined text |

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
| `leq` | `\leq` | Less than or equal |
| `geq` | `\geq` | Greater than or equal |
| `neq` | `\neq` | Not equal |
| `approx` | `\approx` | Approximately equal |
| `equiv` | `\equiv` | Equivalent |
| `in` | `\in` | Element of |
| `subset` | `\subset` | Subset |
| `cap` | `\cap` | Intersection |
| `cup` | `\cup` | Union |
| `emptyset` | `\emptyset` | Empty set |
| `forall` | `\forall` | For all |
| `exists` | `\exists` | There exists |
| `rightarrow` | `\rightarrow` | Right arrow |
| `leftarrow` | `\leftarrow` | Left arrow |

## Environments

| Trigger | Output | Description |
|---------|--------|-------------|
| `eq` | `\begin{equation}...\end{equation}` | Equation environment |
| `ali` | `\begin{align}...\end{align}` | Align environment |
| `item` | `\begin{itemize}...\end{itemize}` | Itemize environment |
| `enum` | `\begin{enumerate}...\end{enumerate}` | Enumerate environment |
| `desc` | `\begin{description}...\end{description}` | Description environment |
| `figure` | `\begin{figure}...\end{figure}` | Figure environment |
| `table` | `\begin{table}...\end{table}` | Table environment |
| `center` | `\begin{center}...\end{center}` | Center environment |
| `quote` | `\begin{quote}...\end{quote}` | Quote environment |
| `verbatim` | `\begin{verbatim}...\end{verbatim}` | Verbatim environment |

## Common Commands

| Trigger | Output | Description |
|---------|--------|-------------|
| `cite` | `\cite{}` | Citation |
| `ref` | `\ref{}` | Reference |
| `label` | `\label{}` | Label |
| `caption` | `\caption{}` | Caption |
| `footnote` | `\footnote{}` | Footnote |
| `url` | `\url{}` | URL |
| `href` | `\href{}{}` | Hyperlink |
| `includegraphics` | `\includegraphics{}` | Include graphics |
| `input` | `\input{}` | Input file |
| `include` | `\include{}` | Include file |
| `usepackage` | `\usepackage{}` | Use package |
| `documentclass` | `\documentclass{}` | Document class |
| `author` | `\author{}` | Author |
| `title` | `\title{}` | Title |
| `date` | `\date{}` | Date |
| `maketitle` | `\maketitle` | Make title |
| `tableofcontents` | `\tableofcontents` | Table of contents |
| `newpage` | `\newpage` | New page |
| `clearpage` | `\clearpage` | Clear page |

## Usage Tips

1. **Math Mode Detection**: Snippets automatically detect if you're in math mode using VimTeX
2. **Autosnippets**: Most snippets are autosnippets that expand automatically when you type the trigger
3. **Visual Selection**: Select text and press `<Tab>` to store it, then use snippets that support visual selection
4. **Line-Begin Snippets**: Environment snippets only work at the start of a line
5. **Context Awareness**: Some snippets only work in specific contexts (math mode, text mode, etc.)

## Keybindings

- `<Tab>` - Expand snippet or jump to next tabstop
- `<Shift-Tab>` - Jump to previous tabstop
- `<Ctrl-l>` - Cycle through choice nodes
- `<leader>sr` - Reload snippets

## Resources

- [luasnip-latex-snippets GitHub](https://github.com/iurimateus/luasnip-latex-snippets.nvim)
- [Original UltiSnips snippets](https://github.com/gillescastel/ultisnips)
- [LuaSnip Documentation](https://github.com/L3MON4D3/LuaSnip)