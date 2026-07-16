#!/bin/zsh
# Demo 13: Notification Demo
# Demonstrates: --notification, --title, --subtitle, --message, --icon,
#               --identifier, --remove

DIALOG="${DIALOG:-/usr/local/bin/dialog}"

# --- Explain notifications ---
"$DIALOG" \
    --title "Notification Demo" \
    --message "swiftDialog can send **macOS system notifications**.\n\nThe next steps will:\n1. Send a notification with a custom identifier\n2. Send a second notification\n3. Remove notifications by identifier\n\n⚠️ You may need to allow notifications for swiftDialog in System Settings." \
    --icon "SF=bell.badge,colour=#FF9500" \
    --button1text "Send Notification →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Send a notification with identifier ---
"$DIALOG" \
    --notification \
    --title "swiftDialog Notification" \
    --subtitle "Demo Notification #1" \
    --message "This notification was sent with --identifier demo-notify-1" \
    --icon "/Applications/Utilities/Terminal.app" \
    --identifier "demo-notify-1"

sleep 1

# --- Send a second notification ---
"$DIALOG" \
    --notification \
    --title "Second Notification" \
    --subtitle "Demo Notification #2" \
    --message "Multiple notifications can coexist.\nNewlines work with \\n in notification messages." \
    --icon "SF=bell.fill" \
    --identifier "demo-notify-2"

# --- Let user see them ---
"$DIALOG" \
    --title "Notifications Sent" \
    --message "Two notifications were sent:\n\n1. **demo-notify-1** — with an app icon\n2. **demo-notify-2** — with an SF Symbol\n\nCheck your Notification Centre!\n\nClick **Remove** to clean them up." \
    --icon "SF=bell.badge.fill,colour=#34C759" \
    --button1text "Remove & Continue" \
    --button2text "Leave & Continue" \
    --moveable \
    --json

local exit_code=$?

if [[ $exit_code -eq 0 ]]; then
    # Remove specific notification
    "$DIALOG" --notification --remove --identifier "demo-notify-1"
    "$DIALOG" --notification --remove --identifier "demo-notify-2"
fi

# --- Remove all notifications ---
"$DIALOG" \
    --style alert \
    --title "Remove All" \
    --message "You can also remove **all** notifications at once using \`--notification --remove\` without an identifier." \
    --icon "SF=bell.slash,colour=#8E8E93" \
    --button1text "Done ✓" \
    --json || true
