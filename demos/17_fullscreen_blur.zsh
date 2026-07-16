#!/bin/zsh
# Demo 17: Full Screen & Blur
# Demonstrates: --fullscreen, --blurscreen, --hideotherapps

DIALOG="${DIALOG:-/usr/local/bin/dialog}"

# --- Explain what's coming ---
"$DIALOG" \
    --title "Full Screen & Blur Demos" \
    --message "The next demonstrations will take over the display:\n\n1. **Blur Screen** — Blurs everything behind the dialog\n2. **Hide Other Apps** — Hides all other apps while dialog runs\n3. **Full Screen** — Takes over the entire screen\n\n⚠️ These are immersive and may briefly obscure your work.\n\nPress **Start** when ready." \
    --icon "SF=display,colour=#FF9500" \
    --button1text "Start →" \
    --button2text "Skip All" \
    --moveable \
    --width 650 \
    --json || exit 0

# --- Blur screen ---
"$DIALOG" \
    --title "Blur Screen" \
    --message "The \`--blurscreen\` option blurs the entire screen behind the dialog.\n\nThe user cannot interact with other apps until the dialog is closed.\n\nUseful for **security-critical prompts** like password resets." \
    --icon "SF=eye.trianglebadge.exclamationmark,colour=#FF3B30" \
    --blurscreen \
    --button1text "Next →" \
    --button2text "Skip" \
    --width 650 \
    --json || exit 0

# --- Hide other apps ---
"$DIALOG" \
    --title "Hide Other Apps" \
    --message "The \`--hideotherapps\` flag hides all other applications when the dialog launches.\n\nApps will reappear when the dialog closes.\n\n_Note: previously hidden apps may become visible._" \
    --icon "SF=eye.slash.circle,colour=#8E8E93" \
    --hideotherapps \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json || exit 0

# --- Full screen ---
"$DIALOG" \
    --fullscreen \
    --title "Full Screen Mode" \
    --message "This is **full screen** mode.\n\nOnly the banner, title, icon, and message are visible.\nNo buttons are shown.\n\nPress **Enter** to dismiss, **Esc** to cancel, or **⌘Q** to quit." \
    --icon "SF=arrow.up.left.and.arrow.down.right,colour=#5856D6" \
    --iconsize 200 || true
