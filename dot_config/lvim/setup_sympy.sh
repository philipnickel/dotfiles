#!/bin/bash

# SymPy Global Installation and Setup Script
# This script installs SymPy globally and tests the configuration

echo "=== SymPy Global Setup ==="

# Check if pipx is installed
if command -v pipx &> /dev/null; then
    echo "✓ pipx is installed"
    
    # Install SymPy globally with pipx
    echo "Installing SymPy globally with pipx..."
    pipx install sympy
    
    if [ $? -eq 0 ]; then
        echo "✓ SymPy installed successfully with pipx"
    else
        echo "✗ Failed to install SymPy with pipx"
        exit 1
    fi
else
    echo "pipx not found. Installing pipx first..."
    
    # Install pipx
    if command -v brew &> /dev/null; then
        brew install pipx
    elif command -v apt &> /dev/null; then
        sudo apt install pipx
    else
        echo "Please install pipx manually: https://pipx.pypa.io/"
        exit 1
    fi
    
    # Install SymPy with pipx
    pipx install sympy
fi

# Test the installation
echo ""
echo "Testing SymPy installation..."

# Test with pipx Python
PIPX_PYTHON="$HOME/.local/bin/python"
if [ -f "$PIPX_PYTHON" ]; then
    echo "Testing with pipx Python: $PIPX_PYTHON"
    $PIPX_PYTHON -c "import sympy; print('✓ SymPy version:', sympy.__version__)"
    
    if [ $? -eq 0 ]; then
        echo "✓ SymPy is working with pipx Python"
    else
        echo "✗ SymPy test failed with pipx Python"
    fi
else
    echo "✗ pipx Python not found at $PIPX_PYTHON"
fi

# Test with system Python
echo "Testing with system Python..."
python3 -c "import sympy; print('✓ SymPy version:', sympy.__version__)" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ SymPy is also available with system Python"
else
    echo "⚠ SymPy not available with system Python (this is expected with pipx)"
fi

echo ""
echo "=== Setup Complete ==="
echo "SymPy is now installed globally and ready to use!"
echo ""
echo "Next steps:"
echo "1. Restart LunarVim"
echo "2. Open a LaTeX file"
echo "3. Test with: sympy 1 + 1 sympy"
echo "4. Press <leader>sp to open SymPy guide"