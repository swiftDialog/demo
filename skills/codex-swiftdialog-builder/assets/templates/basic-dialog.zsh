#!/bin/zsh
# Starter: Basic swiftDialog window

DIALOG="/usr/local/bin/dialog"

"$DIALOG" \
    --title "Welcome" \
    --message "Replace this message with your workflow-specific copy." \
    --icon "SF=sparkles,colour=#007AFF" \
    --button1text "Continue" \
    --button2text "Cancel" \
    --moveable \
    --width 650 \
    --json || exit 0
