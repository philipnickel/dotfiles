#!/bin/bash
# Helper script to start qtconsole with proper configuration

# Set JUPYTER_CONFIG_DIR to use our custom config
export JUPYTER_CONFIG_DIR="$HOME/.config/jupyter"

# Start qtconsole in background
jupyter qtconsole &

echo "QtConsole started! You can now connect from Neovim with :JupyterConnect"
echo "To stop qtconsole, use: pkill -f qtconsole"