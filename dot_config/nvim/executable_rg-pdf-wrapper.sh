#!/bin/bash
# Wrapper to make ripgrep search PDF contents
if [[ "$1" == *.pdf ]]; then
  pdftotext "$1" - 2>/dev/null || echo ""
else
  cat "$1"
fi
