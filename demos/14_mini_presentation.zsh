#!/bin/zsh
# Demo 14: Mini & Presentation Mode
# Demonstrates: --mini (with --progress), --presentation (with --listitem,
#               --image, --infobox, --autoplay, --webcontent)

DIALOG="/usr/local/bin/dialog"
CMD_FILE=""

cleanup() {
    if [[ -n "$CMD_FILE" ]]; then
        rm -f "$CMD_FILE"
    fi
}
trap cleanup EXIT

# --- Mini mode basic ---
"$DIALOG" \
    --mini \
    --title "Mini Mode" \
    --message "A compact notification-style dialog. Limited to two lines." \
    --icon "SF=rectangle.compress.vertical,colour=#007AFF" \
    --button1text "Next →" \
    --button2text "Skip" \
    --json || exit 0

# --- Mini mode with progress ---
cleanup
CMD_FILE=$(mktemp -t dialog.XXXXXX)

"$DIALOG" \
    --mini \
    --title "Mini Mode + Progress" \
    --message "Buttons are replaced by a progress bar in mini mode." \
    --icon "SF=arrow.down.circle.fill,colour=#34C759" \
    --progress 10 \
    --progresstext "Downloading..." \
    --commandfile "$CMD_FILE" &

DIALOG_PID=$!
sleep 1

for i in {1..10}; do
    echo "progress: $i" >> "$CMD_FILE"
    echo "progresstext: Step $i of 10" >> "$CMD_FILE"
    sleep 0.6
done

sleep 0.5
echo "quit:" >> "$CMD_FILE"

wait $DIALOG_PID 2>/dev/null || true
cleanup

# --- Presentation mode with list ---
cleanup
CMD_FILE=$(mktemp -t dialog.XXXXXX)

"$DIALOG" \
    --presentation \
    --title "Presentation Mode" \
    --icon "SF=desktopcomputer,colour=white" \
    --iconsize 80 \
    --infobox "### System Setup\n\nConfiguring your new Mac with required software and settings.\n\n**Department:** Engineering\n**Asset:** MAC-2024-001" \
    --listitem "System Preferences,status=pending" \
    --listitem "Security Configuration,status=pending" \
    --listitem "Software Installation,status=pending" \
    --listitem "Network Setup,status=pending" \
    --listitem "User Profile,status=pending" \
    --listitem "Final Verification,status=pending" \
    --progress 6 \
    --progresstext "Initializing..." \
    --button1text "Please wait..." \
    --button1disabled \
    --commandfile "$CMD_FILE" &

DIALOG_PID=$!
sleep 2

# Simulate a deployment workflow
steps=(
    "System Preferences"
    "Security Configuration"
    "Software Installation"
    "Network Setup"
    "User Profile"
    "Final Verification"
)

status_messages=(
    "Applying system preferences..."
    "Configuring FileVault and Firewall..."
    "Installing required applications..."
    "Joining corporate network..."
    "Creating user profile..."
    "Running verification checks..."
)

for i in {1..6}; do
    echo "listitem: title: ${steps[$i]}, status: wait, statustext: ${status_messages[$i]}" >> "$CMD_FILE"
    echo "progress: $((i - 1))" >> "$CMD_FILE"
    echo "progresstext: ${status_messages[$i]}" >> "$CMD_FILE"
    sleep 2

    echo "listitem: title: ${steps[$i]}, status: success, statustext: Complete" >> "$CMD_FILE"
    echo "progress: $i" >> "$CMD_FILE"
    sleep 0.5
done

echo "progresstext: ✅ Setup complete!" >> "$CMD_FILE"
echo "button1text: Finish" >> "$CMD_FILE"
echo "button1: enable" >> "$CMD_FILE"

wait $DIALOG_PID 2>/dev/null || true
cleanup
