#!/bin/zsh
# Starter: Progress and live status dialog

DIALOG="/usr/local/bin/dialog"
LOGGED_IN_USER=""
CMD_FILE=""

cleanup() {
    if [[ -n "$CMD_FILE" ]]; then
        rm -f "$CMD_FILE"
    fi
}
trap cleanup EXIT

current_logged_in_user() {
    LOGGED_IN_USER=$(/bin/echo "show State:/Users/ConsoleUser" | /usr/sbin/scutil | /usr/bin/awk '/Name :/ { print $3 }')

    if [[ -z "$LOGGED_IN_USER" || "$LOGGED_IN_USER" == "loginwindow" ]]; then
        LOGGED_IN_USER=""
        return 1
    fi

    if ! /usr/bin/id -u "$LOGGED_IN_USER" >/dev/null 2>&1; then
        LOGGED_IN_USER=""
        return 1
    fi

    return 0
}

prepare_file_for_dialog_user() {
    local target_file="$1"

    [[ -n "$target_file" && -e "$target_file" ]] || return 1
    current_logged_in_user || return 1
    /usr/sbin/chown "$LOGGED_IN_USER" "$target_file" || return 1
    /bin/chmod 600 "$target_file" || return 1
}

# --- Launch dialog ---
CMD_FILE=$(mktemp "/var/tmp/dialog.XXXXXX")
prepare_file_for_dialog_user "$CMD_FILE" || exit 1
# Adjust these static dimensions to fit your real message and list items.

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
