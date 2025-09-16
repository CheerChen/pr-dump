#!/bin/bash

# Simple installer for pr-dump
# Usage: ./install.sh [--uninstall]

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="pr-dump"

if [ "$1" = "--uninstall" ]; then
    sudo rm "$INSTALL_DIR/$SCRIPT_NAME" 2>/dev/null && echo "✅ pr-dump uninstalled" || echo "❌ pr-dump not found"
    exit 0
fi

if [ ! -f "pr-dump.sh" ]; then
    echo "❌ pr-dump.sh not found in current directory"
    exit 1
fi

sudo cp pr-dump.sh "$INSTALL_DIR/$SCRIPT_NAME" && sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "✅ pr-dump installed to $INSTALL_DIR/$SCRIPT_NAME"
echo "   Use: pr-dump --help"