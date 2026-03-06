#!/bin/zsh
# Demo 10: List Items & Status Updates
# Demonstrates: --listitem (simple, with status, with action, with statustext),
#               --liststyle, --enablelistselect, command file list updates
#               (list:, listitem:, add, delete, index, status keywords)

DIALOG="/usr/local/bin/dialog"
CMD_FILE="/var/tmp/dialog.log"

# --- Simple list ---
"$DIALOG" \
    --title "Simple List" \
    --message "Lists display items with optional status indicators:" \
    --icon "SF=list.bullet.rectangle,colour=#007AFF" \
    --listitem "Xcode Command Line Tools" \
    --listitem "Homebrew" \
    --listitem "Python 3.12" \
    --listitem "Node.js LTS" \
    --listitem "Docker Desktop" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --height 400 \
    --json || exit 0

# --- List with live status updates via command file ---
rm -f "$CMD_FILE"

"$DIALOG" \
    --title "Installation Progress" \
    --message "List items update in real-time via the command file.\n\nStatus keywords: **wait**, **success**, **fail**, **error**, **pending**" \
    --icon "SF=arrow.down.app,colour=#34C759" \
    --listitem "Xcode Command Line Tools,status=pending" \
    --listitem "Homebrew,status=pending" \
    --listitem "Python 3.12,status=pending" \
    --listitem "Node.js LTS,status=pending" \
    --listitem "Docker Desktop,status=pending" \
    --liststyle expanded \
    --button1text "Please wait..." \
    --button1disabled \
    --commandfile "$CMD_FILE" \
    --moveable \
    --width 700 \
    --height 480 &

DIALOG_PID=$!
sleep 1

# Simulate installation with status updates
items=("Xcode Command Line Tools" "Homebrew" "Python 3.12" "Node.js LTS" "Docker Desktop")

for item in "${items[@]}"; do
    echo "listitem: title: $item, status: wait, statustext: Installing..." >> "$CMD_FILE"
    sleep 1.5

    # Simulate a failure for one item
    if [[ "$item" == "Docker Desktop" ]]; then
        echo "listitem: title: $item, status: fail, statustext: Requires restart" >> "$CMD_FILE"
    else
        echo "listitem: title: $item, status: success, statustext: Installed" >> "$CMD_FILE"
    fi
    sleep 0.3
done

echo "button1text: Next →" >> "$CMD_FILE"
echo "button1: enable" >> "$CMD_FILE"
echo "message: Installation complete. Docker Desktop requires a restart." >> "$CMD_FILE"

wait $DIALOG_PID 2>/dev/null || true
rm -f "$CMD_FILE"

# --- List with add/delete via command file ---
rm -f "$CMD_FILE"

"$DIALOG" \
    --title "Dynamic List Management" \
    --message "Items can be **added** and **deleted** from lists dynamically." \
    --icon "SF=list.bullet.clipboard,colour=#5856D6" \
    --listitem "Initial Item 1,status=success" \
    --listitem "Initial Item 2,status=success" \
    --button1text "Please wait..." \
    --button1disabled \
    --commandfile "$CMD_FILE" \
    --moveable \
    --width 700 \
    --height 420 &

DIALOG_PID=$!
sleep 1

# Add items
echo "listitem: add, title: Added Item 3, status: wait, statustext: Processing" >> "$CMD_FILE"
sleep 1
echo "listitem: add, title: Added Item 4, status: wait, statustext: Processing" >> "$CMD_FILE"
sleep 1
echo "listitem: add, title: Added Item 5, status: pending" >> "$CMD_FILE"
sleep 1

# Update added items
echo "listitem: title: Added Item 3, status: success, statustext: Done" >> "$CMD_FILE"
sleep 0.5
echo "listitem: title: Added Item 4, status: success, statustext: Done" >> "$CMD_FILE"
sleep 0.5
echo "listitem: title: Added Item 5, status: success, statustext: Done" >> "$CMD_FILE"
sleep 1

# Delete by title
echo "message: Removing 'Initial Item 1' by title..." >> "$CMD_FILE"
sleep 1
echo "listitem: title: Initial Item 1, delete:" >> "$CMD_FILE"
sleep 1

# Delete by index
echo "message: Removing item at index 0..." >> "$CMD_FILE"
sleep 1
echo "listitem: index: 0, delete:" >> "$CMD_FILE"
sleep 1

echo "message: Dynamic list management complete!" >> "$CMD_FILE"
echo "button1text: Next →" >> "$CMD_FILE"
echo "button1: enable" >> "$CMD_FILE"

wait $DIALOG_PID 2>/dev/null || true
rm -f "$CMD_FILE"

# --- Custom SF Symbol status ---
"$DIALOG" \
    --title "Custom Status Icons" \
    --message "List items can use custom SF Symbols with colours for status.\n\nSyntax: \`status=sf.symbol.name-colour\`" \
    --icon "SF=paintpalette,colour=#FF9500" \
    --listitem "Firewall,status=lock.shield.fill-green" \
    --listitem "FileVault,status=lock.fill-blue" \
    --listitem "Gatekeeper,status=checkmark.shield.fill-green" \
    --listitem "SIP,status=exclamationmark.shield.fill-orange" \
    --listitem "Remote Login,status=xmark.shield.fill-red" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 700 \
    --height 420 \
    --json || exit 0

# --- Selectable list ---
result=$("$DIALOG" \
    --title "Selectable List" \
    --message "With \`--enablelistselect\`, list items become selectable.\n\nClick items to toggle their selection:" \
    --icon "SF=hand.point.up.left,colour=#00C7BE" \
    --listitem "macOS Sequoia" \
    --listitem "macOS Sonoma" \
    --listitem "macOS Ventura" \
    --listitem "macOS Monterey" \
    --listitem "macOS Big Sur" \
    --enablelistselect \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --height 420 \
    --json 2>/dev/null) || exit 0

echo "List selection output:"
echo "$result" | jq '.'

# --- List item with action ---
"$DIALOG" \
    --title "List Item Actions" \
    --message "The \`action\` modifier opens a URL when its list item is clicked.\n\nTry clicking any item below — it will open the linked URL in your browser." \
    --icon "SF=link.circle.fill,colour=#007AFF" \
    --listitem "swiftDialog GitHub,action=https://github.com/swiftDialog/swiftDialog" \
    --listitem "SF Symbols,action=https://developer.apple.com/sf-symbols/" \
    --listitem "swiftDialog Wiki,action=https://github.com/swiftDialog/swiftDialog/wiki" \
    --button1text "Done ✓" \
    --moveable \
    --width 700 \
    --height 350 \
    --json || true
