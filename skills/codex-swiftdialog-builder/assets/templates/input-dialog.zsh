#!/bin/zsh
# Starter: Input collection dialog

DIALOG="/usr/local/bin/dialog"

result=$("$DIALOG" \
    --title "Device Setup" \
    --message "Collect the fields your workflow needs, then adapt the output handling below." \
    --icon "SF=slider.horizontal.3,colour=#007AFF" \
    --textfield "Hostname,required,name=hostname,prompt=mac-001" \
    --textfield "Email,required,name=email,prompt=user@example.com" \
    --selecttitle "Department,required,name=department" \
    --selectvalues "Engineering,Design,Marketing,Sales,Finance" \
    --selectdefault "Engineering" \
    --checkbox "Enable FileVault,checked,name=enable_filevault" \
    --button1text "Submit" \
    --button2text "Cancel" \
    --moveable \
    --width 700 \
    --json 2>/dev/null) || exit 0

echo "$result" | jq '.'
