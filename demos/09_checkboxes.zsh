#!/bin/zsh
# Demo 09: Checkboxes & Switches
# Demonstrates: --checkbox (with name modifier), --checkboxstyle (checkbox, switch,
#               sizes, icon), JSON output

DIALOG="/usr/local/bin/dialog"

# --- Basic checkboxes ---
result=$("$DIALOG" \
    --title "Checkboxes" \
    --message "Basic checkboxes for boolean selections.\n\nOutput shows each label as true/false:" \
    --icon "SF=checkmark.square,colour=#007AFF" \
    --checkbox "Enable Wi-Fi" \
    --checkbox "Enable Bluetooth" \
    --checkbox "Enable Location Services" \
    --checkbox "Enable Automatic Updates" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || exit 0

echo "Checkbox output:"
echo "$result" | jq '.'

# --- Named checkboxes ---
result=$("$DIALOG" \
    --title "Named Checkboxes" \
    --message "Use the \`name\` modifier to customise output keys.\n\nDisplayed as \"Accept Terms\" but outputs as \`terms_accepted\`." \
    --icon "SF=tag,colour=#5856D6" \
    --checkbox "Accept Terms of Service,name=terms_accepted" \
    --checkbox "Subscribe to Newsletter,name=newsletter_opt_in" \
    --checkbox "Share Anonymous Usage Data,name=telemetry" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || exit 0

echo "Named checkbox output:"
echo "$result" | jq '.'

# --- Switch style ---
result=$("$DIALOG" \
    --title "Switch Style" \
    --message "Use \`--checkboxstyle switch\` to display iOS-style toggle switches." \
    --icon "SF=switch.2,colour=#34C759" \
    --checkboxstyle "switch" \
    --checkbox "Dark Mode" \
    --checkbox "Do Not Disturb" \
    --checkbox "AirDrop" \
    --checkbox "Handoff" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || exit 0

echo "Switch style output:"
echo "$result" | jq '.'

# --- Switch sizes ---
result=$("$DIALOG" \
    --title "Switch Sizes" \
    --message "Switch style supports size variants: **mini**, **small**, **regular**, **large**.\n\nThis demo uses **large** switches." \
    --icon "SF=arrow.up.left.and.arrow.down.right,colour=#FF9500" \
    --checkboxstyle "switch,large" \
    --checkbox "Feature A" \
    --checkbox "Feature B" \
    --checkbox "Feature C" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || exit 0

echo "Switch sizes output:"
echo "$result" | jq '.'

# --- Icon style ---
result=$("$DIALOG" \
    --title "Icon Checkbox Style" \
    --message "Use \`--checkboxstyle icon\` to display checkboxes as larger icon-based toggles." \
    --icon "SF=checklist,colour=#FF9500" \
    --checkboxstyle "icon" \
    --checkbox "iCloud Drive" \
    --checkbox "Find My Mac" \
    --checkbox "Screen Time" \
    --button1text "Done ✓" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || true

echo "Icon checkbox output:"
echo "$result" | jq '.'
