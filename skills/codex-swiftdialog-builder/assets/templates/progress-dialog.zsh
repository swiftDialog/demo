#!/bin/zsh
# Starter: Progress and live status dialog

DIALOG="/usr/local/bin/dialog"
CMD_FILE="/var/tmp/dialog.log"

cleanup() {
    rm -f "$CMD_FILE"
}
trap cleanup EXIT

# --- Launch dialog ---
rm -f "$CMD_FILE"

"$DIALOG" \
    --title "Installing Components" \
    --message "Replace the steps below with your real workflow." \
    --icon "SF=arrow.down.app,colour=#007AFF" \
    --progress 4 \
    --progresstext "Starting..." \
    --listitem "Download package,status=pending" \
    --listitem "Verify package,status=pending" \
    --listitem "Install package,status=pending" \
    --listitem "Finalize,status=pending" \
    --button1text "Please wait..." \
    --button1disabled \
    --commandfile "$CMD_FILE" \
    --moveable \
    --width 700 \
    --height 450 &

DIALOG_PID=$!
sleep 1

STEPS=("Download package" "Verify package" "Install package" "Finalize")

for i in {1..4}; do
    echo "progress: $i" >> "$CMD_FILE"
    echo "progresstext: Step $i/4: ${STEPS[$i]}" >> "$CMD_FILE"
    echo "listitem: title: ${STEPS[$i]}, status: wait, statustext: Working..." >> "$CMD_FILE"
    sleep 1
    echo "listitem: title: ${STEPS[$i]}, status: success, statustext: Done" >> "$CMD_FILE"
done

echo "progresstext: Complete" >> "$CMD_FILE"
echo "button1text: Done" >> "$CMD_FILE"
echo "button1: enable" >> "$CMD_FILE"

wait $DIALOG_PID 2>/dev/null || true
