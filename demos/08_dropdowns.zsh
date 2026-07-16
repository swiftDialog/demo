#!/bin/zsh
# Demo 08: Dropdown Select Lists
# Demonstrates: --selecttitle, --selectvalues, --selectdefault,
#               modifiers (required, radio, searchable, multiselect, name),
#               dividers (---), JSON input format

DIALOG="${DIALOG:-/usr/local/bin/dialog}"

# --- Basic dropdown ---
result=$("$DIALOG" \
    --title "Dropdown Select" \
    --message "A basic dropdown select list with a default value:" \
    --icon "SF=list.bullet,colour=#007AFF" \
    --selecttitle "Choose a Colour" \
    --selectvalues "Red,Orange,Yellow,Green,Blue,Purple" \
    --selectdefault "Green" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || exit 0

echo "Dropdown output:"
echo "$result" | jq '.'

# --- Multiple dropdowns ---
result=$("$DIALOG" \
    --title "Multiple Dropdowns" \
    --message "Multiple \`--selecttitle\` arguments create separate lists.\n\nRelated \`--selectvalues\` and \`--selectdefault\` are matched in order." \
    --icon "SF=list.bullet.indent,colour=#5856D6" \
    --selecttitle "Country" \
    --selectvalues "Australia,Canada,Germany,Japan,United Kingdom,United States" \
    --selectdefault "Australia" \
    --selecttitle "Department" \
    --selectvalues "Engineering,Marketing,Sales,---,HR,Finance,Legal" \
    --selectdefault "Engineering" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --height 400 \
    --json 2>/dev/null) || exit 0

echo "Multiple dropdowns output:"
echo "$result" | jq '.'

# --- Required dropdown ---
result=$("$DIALOG" \
    --title "Required Dropdown" \
    --message "Add the \`required\` modifier to force selection before dismissal.\n\nTry clicking Submit without selecting a value!" \
    --icon "SF=exclamationmark.triangle,colour=#FF3B30" \
    --selecttitle "Operating System,required" \
    --selectvalues "macOS Sequoia,macOS Sonoma,macOS Ventura,macOS Monterey" \
    --button1text "Submit" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || exit 0

# --- Radio buttons ---
result=$("$DIALOG" \
    --title "Radio Button Style" \
    --message "The \`radio\` modifier converts a dropdown into radio button group.\n\nThe first item becomes the default if none is specified." \
    --icon "SF=circle.inset.filled,colour=#34C759" \
    --selecttitle "Installation Type,radio" \
    --selectvalues "Standard (Recommended),Custom,Minimal" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || exit 0

echo "Radio output:"
echo "$result" | jq '.'

# --- Searchable dropdown ---
result=$("$DIALOG" \
    --title "Searchable Dropdown" \
    --message "The \`searchable\` modifier adds a text filter to the dropdown.\n\nType to filter the list — useful for long option lists." \
    --icon "SF=magnifyingglass,colour=#FF9500" \
    --selecttitle "Time Zone,searchable" \
    --selectvalues "Australia/Sydney,Australia/Melbourne,Australia/Brisbane,Australia/Perth,Australia/Adelaide,Australia/Hobart,Australia/Darwin,America/New_York,America/Chicago,America/Denver,America/Los_Angeles,Europe/London,Europe/Paris,Europe/Berlin,Europe/Tokyo,Asia/Shanghai,Asia/Mumbai" \
    --selectdefault "Australia/Sydney" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || exit 0

# --- Multiselect ---
result=$("$DIALOG" \
    --title "Multi-Select Dropdown" \
    --message "The \`multiselect\` modifier allows choosing multiple values." \
    --icon "SF=checklist,colour=#AF52DE" \
    --selecttitle "Installed Software,multiselect" \
    --selectvalues "Microsoft Office,Adobe Creative Suite,Slack,Zoom,Visual Studio Code,Xcode,Docker,Homebrew" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || exit 0

echo "Multiselect output:"
echo "$result" | jq '.'

# --- Named output ---
result=$("$DIALOG" \
    --title "Named Dropdown Output" \
    --message "Use the \`name\` modifier to customise the output JSON key.\n\nThe title displayed is \"Choose Building\" but the output key will be \`building_id\`." \
    --icon "SF=tag,colour=#00C7BE" \
    --selecttitle "Choose Building,name=building_id" \
    --selectvalues "HQ-001,Branch-002,Remote-003,Satellite-004" \
    --selectdefault "HQ-001" \
    --button1text "Done ✓" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || true

echo "Named dropdown output:"
echo "$result" | jq '.'
