# LaTeX Snippets (Outside Math)

This document provides a reference for LaTeX snippets that work outside of math mode.

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

## Environments (Line Begin)

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
| `cleardoublepage` | `\cleardoublepage` | Clear double page |

## Document Structure

| Trigger | Output | Description |
|---------|--------|-------------|
| `documentclass` | `\documentclass{}` | Document class |
| `usepackage` | `\usepackage{}` | Use package |
| `begin` | `\begin{}...\end{}` | Generic environment |
| `end` | `\end{}` | End environment |
| `section` | `\section{}` | Section |
| `subsection` | `\subsection{}` | Subsection |
| `subsubsection` | `\subsubsection{}` | Subsubsection |
| `paragraph` | `\paragraph{}` | Paragraph |
| `subparagraph` | `\subparagraph{}` | Subparagraph |

## Usage Tips

1. **Text Mode Only**: These snippets work outside of math mode
2. **Line-Begin Snippets**: Environment snippets only work at the start of a line
3. **Autosnippets**: Most snippets expand automatically when you type the trigger
4. **Visual Selection**: Select text and press `<Tab>` to store it for use in snippets
5. **Context Awareness**: Some snippets only work in specific contexts

## Keybindings

- `<Tab>` - Expand snippet or jump to next tabstop
- `<Shift-Tab>` - Jump to previous tabstop
- `<Ctrl-l>` - Cycle through choice nodes
- `<leader>sr` - Reload snippets

## Examples

### Text Formatting
- Type `bf` → `\textbf{}`
- Type `it` → `\textit{}`
- Type `tt` → `\texttt{}`

### Environments
- Type `eq` at start of line → creates equation environment
- Type `item` at start of line → creates itemize environment
- Type `figure` at start of line → creates figure environment

### Commands
- Type `cite` → `\cite{}`
- Type `ref` → `\ref{}`
- Type `label` → `\label{}`