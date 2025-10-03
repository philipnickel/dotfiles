# LaTeX Snippets Reference

Complete reference for all LaTeX snippets available through `luasnip-latex-snippets.nvim`.

---

## Quick Lookup - All Snippets

### Text Formatting
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
| `sl` | `\textsl{}` | Slanted text |
| `md` | `\textmd{}` | Medium weight text |
| `bfseries` | `\bfseries` | Bold series |
| `itshape` | `\itshape` | Italic shape |
| `ttfamily` | `\ttfamily` | Typewriter family |
| `sffamily` | `\sffamily` | Sans serif family |
| `rmfamily` | `\rmfamily` | Roman family |
| `scshape` | `\scshape` | Small caps shape |
| `upshape` | `\upshape` | Upright shape |
| `slshape` | `\slshape` | Slanted shape |
| `mdseries` | `\mdseries` | Medium series |
| `lfseries` | `\lfseries` | Light series |

### Greek Letters (Lowercase)
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

### Greek Letters (Uppercase)
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

### Math Symbols
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
| `mapsto` | `\mapsto` | Maps to |
| `to` | `\to` | To |
| `gets` | `\gets` | Gets |
| `land` | `\land` | Logical and |
| `lor` | `\lor` | Logical or |
| `lnot` | `\lnot` | Logical not |
| `implies` | `\implies` | Implies |
| `iff` | `\iff` | If and only if |
| `sim` | `\sim` | Similar to |
| `simeq` | `\simeq` | Asymptotically equal |
| `cong` | `\cong` | Congruent |
| `perp` | `\perp` | Perpendicular |
| `parallel` | `\parallel` | Parallel |
| `diamond` | `\diamond` | Diamond |
| `bullet` | `\bullet` | Bullet |
| `circ` | `\circ` | Circle |
| `star` | `\star` | Star |
| `ast` | `\ast` | Asterisk |
| `oplus` | `\oplus` | Direct sum |
| `ominus` | `\ominus` | Direct difference |
| `otimes` | `\otimes` | Tensor product |
| `odot` | `\odot` | Hadamard product |
| `wedge` | `\wedge` | Wedge |
| `vee` | `\vee` | Vee |
| `bigcap` | `\bigcap` | Big intersection |
| `bigcup` | `\bigcup` | Big union |
| `bigwedge` | `\bigwedge` | Big wedge |
| `bigvee` | `\bigvee` | Big vee |
| `bigoplus` | `\bigoplus` | Big direct sum |
| `bigotimes` | `\bigotimes` | Big tensor product |
| `bigodot` | `\bigodot` | Big Hadamard product |

### Math Environments
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
| `smallmatrix` | `\begin{smallmatrix}...\end{smallmatrix}` | Small matrix |

### Text Environments (Line Begin)
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
| `quotation` | `\begin{quotation}...\end{quotation}` | Quotation environment |
| `verse` | `\begin{verse}...\end{verse}` | Verse environment |
| `verbatim` | `\begin{verbatim}...\end{verbatim}` | Verbatim environment |
| `abstract` | `\begin{abstract}...\end{abstract}` | Abstract environment |
| `proof` | `\begin{proof}...\end{proof}` | Proof environment |
| `theorem` | `\begin{theorem}...\end{theorem}` | Theorem environment |
| `lemma` | `\begin{lemma}...\end{lemma}` | Lemma environment |
| `corollary` | `\begin{corollary}...\end{corollary}` | Corollary environment |
| `definition` | `\begin{definition}...\end{definition}` | Definition environment |
| `example` | `\begin{example}...\end{example}` | Example environment |
| `remark` | `\begin{remark}...\end{remark}` | Remark environment |
| `note` | `\begin{note}...\end{note}` | Note environment |
| `warning` | `\begin{warning}...\end{warning}` | Warning environment |
| `exercise` | `\begin{exercise}...\end{exercise}` | Exercise environment |
| `solution` | `\begin{solution}...\end{solution}` | Solution environment |

### Common Commands
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
| `cleardoublepage` | `\cleardoublepage` | Clear double page |
| `today` | `\today` | Today's date |
| `thanks` | `\thanks{}` | Thanks |
| `and` | `\and` | Author separator |
| `thanks` | `\thanks{}` | Thanks |
| `thanks` | `\thanks{}` | Thanks |

### Document Structure
| Trigger | Output | Description |
|---------|--------|-------------|
| `section` | `\section{}` | Section |
| `subsection` | `\subsection{}` | Subsection |
| `subsubsection` | `\subsubsection{}` | Subsubsection |
| `paragraph` | `\paragraph{}` | Paragraph |
| `subparagraph` | `\subparagraph{}` | Subparagraph |
| `part` | `\part{}` | Part |
| `chapter` | `\chapter{}` | Chapter |
| `appendix` | `\appendix` | Appendix |
| `frontmatter` | `\frontmatter` | Front matter |
| `mainmatter` | `\mainmatter` | Main matter |
| `backmatter` | `\backmatter` | Back matter |

### Spacing and Sizing
| Trigger | Output | Description |
|---------|--------|-------------|
| `quad` | `\quad` | Quad space |
| `qquad` | `\qquad` | Double quad space |
| `hspace` | `\hspace{}` | Horizontal space |
| `vspace` | `\vspace{}` | Vertical space |
| `hfill` | `\hfill` | Horizontal fill |
| `vfill` | `\vfill` | Vertical fill |
| `small` | `\small` | Small text |
| `large` | `\large` | Large text |
| `Large` | `\Large` | Larger text |
| `LARGE` | `\LARGE` | Very large text |
| `huge` | `\huge` | Huge text |
| `Huge` | `\Huge` | Very huge text |
| `tiny` | `\tiny` | Tiny text |
| `scriptsize` | `\scriptsize` | Script size text |
| `footnotesize` | `\footnotesize` | Footnote size text |
| `normalsize` | `\normalsize` | Normal size text |

### Lists and Tables
| Trigger | Output | Description |
|---------|--------|-------------|
| `itemize` | `\begin{itemize}...\end{itemize}` | Itemize list |
| `enumerate` | `\begin{enumerate}...\end{enumerate}` | Enumerate list |
| `description` | `\begin{description}...\end{description}` | Description list |
| `item` | `\item` | List item |
| `item[]` | `\item[]` | List item with label |
| `table` | `\begin{table}...\end{table}` | Table environment |
| `tabular` | `\begin{tabular}...\end{tabular}` | Tabular environment |
| `array` | `\begin{array}...\end{array}` | Array environment |
| `hline` | `\hline` | Horizontal line |
| `cline` | `\cline{}` | Partial horizontal line |
| `vline` | `\vline` | Vertical line |
| `&` | `&` | Column separator |
| `\\` | `\\` | Row separator |
| `hline` | `\hline` | Horizontal line |

### VimTeX Character Mappings

VimTeX automatically converts certain characters in math mode:

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

**Toggle Mappings**: Use `<leader>sm` to enable/disable VimTeX character mappings

*Note: Toggle may require buffer reload (`:e`) to take full effect*

---

## Usage Guide

### How Snippets Work

1. **Autosnippets**: Most snippets expand automatically when you type the trigger
2. **Math Mode Detection**: Snippets automatically detect if you're in math mode using VimTeX
3. **Context Awareness**: Some snippets only work in specific contexts (math mode, text mode, etc.)
4. **Visual Selection**: Select text and press `<Tab>` to store it, then use snippets that support visual selection
5. **Line-Begin Snippets**: Environment snippets only work at the start of a line

### Keybindings

- `<Tab>` - Expand snippet or jump to next tabstop
- `<Shift-Tab>` - Jump to previous tabstop
- `<Ctrl-l>` - Cycle through choice nodes
- `<leader>sr` - Reload snippets
- `<leader>sm` - Toggle VimTeX character mappings

### Typing Literal Characters in Math Mode

To type the actual character instead of the LaTeX command, use these workarounds:

**Method 1: Use Backslash**
- `\8` → literal `8`
- `\0` → literal `0`
- `\;` → literal `;`
- `\:` → literal `:`

**Method 2: Use Empty Braces**
- `{}8` → literal `8`
- `{}0` → literal `0`
- `{};` → literal `;`
- `{}:` → literal `:`

### Common Examples

**Text Formatting:**
- Type `bf` → `\textbf{}`
- Type `it` → `\textit{}`
- Type `tt` → `\texttt{}`

**Math Symbols:**
- Type `ff` → `\frac{}{}`
- Type `sum` → `\sum_{}^{}`
- Type `int` → `\int_{}^{}`

**Environments:**
- Type `eq` at start of line → creates equation environment
- Type `item` at start of line → creates itemize environment
- Type `figure` at start of line → creates figure environment

**VimTeX Mappings:**
- Type `x;1` → `x_1`
- Type `8` → `\infty`
- Type `<` → `\leq`

### Tips and Tricks

1. **Greek Letters**: Use `;` prefix for Greek letters (e.g., `;a` for `\alpha`)
2. **Capital Greek**: Use `;` prefix with capital letters (e.g., `;A` for `\Alpha`)
3. **Math Environments**: Use at start of line for proper formatting
4. **Visual Selection**: Select text first, then use snippets that support it
5. **Context Matters**: Some snippets only work in math mode, others only in text mode

### Resources

- [luasnip-latex-snippets GitHub](https://github.com/iurimateus/luasnip-latex-snippets.nvim)
- [Original UltiSnips snippets](https://github.com/gillescastel/ultisnips)
- [LuaSnip Documentation](https://github.com/L3MON4D3/LuaSnip)