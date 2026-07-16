#!/bin/zsh
# Demo 01: Basic Dialog Styles
# Demonstrates: --style (alert, caution, warning, centered, presentation, mini)

DIALOG="${DIALOG:-/usr/local/bin/dialog}"

# --- Alert style ---
"$DIALOG" \
    --style alert \
    --title "Alert Style" \
    --message "This is the **alert** style.\n\nIt sets a compact 300×300 window with centered content." \
    --button1text "Next →" \
    --button2text "Skip All" \
    --json || exit 0

# --- Caution style ---
"$DIALOG" \
    --style caution \
    --title "Caution Style" \
    --message "The **caution** style is like alert but with a built-in caution icon." \
    --button1text "Next →" \
    --button2text "Skip All" \
    --json || exit 0

# --- Warning style ---
"$DIALOG" \
    --style warning \
    --title "Warning Style" \
    --message "The **warning** style provides a built-in warning icon.\n\nUseful for destructive action confirmations." \
    --button1text "Next →" \
    --button2text "Skip All" \
    --json || exit 0

# --- Centered style ---
"$DIALOG" \
    --style centered \
    --title "Centered Style" \
    --message "The **centered** style sets all content options for centered layout." \
    --icon "SF=rectangle.center.inset.filled,colour=#007AFF" \
    --button1text "Next →" \
    --button2text "Skip All" \
    --json || exit 0

# --- Style override demo ---
"$DIALOG" \
    --style alert \
    --width 500 \
    --title "Style Override" \
    --message "Styles can be **overridden**.\n\nThis is an alert style but with \`--width 500\` applied, making it wider than the default 300." \
    --button1text "Done ✓" \
    --json || true
