#!/bin/zsh
# Demo 18: View Order & Misc Features
# Demonstrates: --vieworder, --helpmessage, --helpimage, --infotext, --infobox,
#               --infobutton, --quitoninfo, --quitkey, --sound, --showsoundcontrols,
#               --displaylog, --loghistory, --debug, --eula,
#               --loginwindow (explained), --key/--checksum (explained),
#               --listfonts, --alwaysreturninput, --verbose

DIALOG="/usr/local/bin/dialog"

# --- Help message ---
"$DIALOG" \
    --title "Help Message" \
    --message "Click the **?** help icon next to the OK button to see a help popover.\n\nThe \`--helpmessage\` option supports markdown formatting." \
    --icon "SF=questionmark.circle,colour=#007AFF" \
    --helpmessage "### Getting Help\n\nThis is a **help popover** triggered by clicking the help icon.\n\nIt supports:\n- Markdown formatting\n- Links\n- Lists\n\nUse \`--helpimage\` to add an image alongside the text." \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json || exit 0

# --- Info text ---
"$DIALOG" \
    --title "Info Text" \
    --message "The \`--infotext\` option replaces the info button with static text in the bottom-left.\n\nLook at the bottom-left of this window! ↙" \
    --icon "SF=info.circle,colour=#5856D6" \
    --infotext "swiftDialog v$("$DIALOG" --version 2>/dev/null || echo '?.?.?') • Demo Suite" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json || exit 0

# --- Info box ---
"$DIALOG" \
    --title "Info Box" \
    --message "The \`--infobox\` displays markdown content underneath the icon (when icon is on the left).\n\nLook below the icon for additional context." \
    --icon "SF=sidebar.left,colour=#FF9500" \
    --infobox "### Device Info\n\n**Model:** MacBook Pro\n**Serial:** C02X1234\n**macOS:** 15.0\n**Storage:** 512GB" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 700 \
    --height 450 \
    --json || exit 0

# --- View order ---
result=$("$DIALOG" \
    --title "Custom View Order" \
    --message "The \`--vieworder\` option rearranges content display order.\n\nNormally checkboxes appear before text fields. Here they're reversed:" \
    --icon "SF=arrow.up.arrow.down,colour=#00C7BE" \
    --textfield "This text field appears FIRST" \
    --checkbox "This checkbox appears SECOND" \
    --selecttitle "This dropdown appears THIRD" \
    --selectvalues "Option A,Option B,Option C" \
    --vieworder "textfield,checkbox,dropdown" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 700 \
    --height 450 \
    --json 2>/dev/null) || exit 0

# --- Quit key ---
"$DIALOG" \
    --title "Custom Quit Key" \
    --message "The default quit shortcut is **⌘Q**.\n\nWith \`--quitkey x\`, it becomes **⌘X** instead.\n\nTry **⌘X** to close this dialog (or just click the button)." \
    --icon "SF=keyboard,colour=#AF52DE" \
    --quitkey "x" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json || exit 0

# --- Sound playback ---
SOUND_FILE="/System/Library/Sounds/Glass.aiff"
if [[ -f "$SOUND_FILE" ]]; then
    "$DIALOG" \
        --title "Sound Playback" \
        --message "swiftDialog can play audio on launch with \`--sound\`.\n\nThis demo plays the system Glass sound.\n\nAdd \`--showsoundcontrols\` for play/pause, mute, and timeline controls (shown below)." \
        --icon "SF=speaker.wave.3,colour=#FF2D55" \
        --sound "$SOUND_FILE" \
        --showsoundcontrols \
        --button1text "Next →" \
        --button2text "Skip" \
        --moveable \
        --width 650 \
        --json || exit 0
fi

# --- Log file tailing ---
LOG_DEMO_FILE="/tmp/swiftdialog_demo_log.txt"
rm -f "$LOG_DEMO_FILE"

# Pre-populate with some history
for i in {1..5}; do
    echo "[$(date '+%H:%M:%S')] Historical log line $i" >> "$LOG_DEMO_FILE"
done

"$DIALOG" \
    --title "Log File Viewer" \
    --message "" \
    --icon "SF=doc.text.magnifyingglass,colour=#34C759" \
    --displaylog "$LOG_DEMO_FILE" \
    --loghistory 5 \
    --button1text "Done viewing" \
    --moveable \
    --width 750 \
    --height 450 &

DIALOG_PID=$!
sleep 2

# Append new lines while dialog is open
for i in {1..8}; do
    echo "[$(date '+%H:%M:%S')] New live log entry #$i — watching file in real-time" >> "$LOG_DEMO_FILE"
    sleep 1
done

wait $DIALOG_PID 2>/dev/null || true
rm -f "$LOG_DEMO_FILE"

# --- Debug mode ---
"$DIALOG" \
    --title "Debug Mode" \
    --message "The \`--debug\` flag shows extra window info in the title bar area.\n\nOptionally supply a colour to highlight content boundaries.\n\nThis is useful for layout testing, especially with \`--resizable\`." \
    --icon "SF=ladybug,colour=#FF3B30" \
    --debug "#FF000033" \
    --resizable \
    --button1text "Next →" \
    --button2text "Skip" \
    --width 700 \
    --height 400 \
    --json || exit 0

# --- Always return input ---
result=$("$DIALOG" \
    --title "Always Return Input" \
    --message "Normally, input is only returned on exit code 0 (Button 1).\n\nWith \`--alwaysreturninput\`, input is returned regardless of which button is pressed.\n\nTry pressing **Cancel** — you'll still get the textfield value!" \
    --icon "SF=arrow.uturn.backward,colour=#FF9500" \
    --textfield "Type something here" \
    --alwaysreturninput \
    --button1text "OK" \
    --button2text "Cancel" \
    --moveable \
    --width 650 \
    --json 2>/dev/null)

exit_code=$?
echo "Exit code: $exit_code"
echo "Output (even on cancel):"
echo "$result" | jq '.'

# --- EULA mode ---
"$DIALOG" \
    --title "EULA Mode" \
    --message "# End User License Agreement\n\nThis is a demonstration of \`--eula\` mode.\n\nIn EULA mode, the dialog is designed for license agreement acceptance workflows.\n\n## Terms\n\n1. You agree to use swiftDialog responsibly\n2. You acknowledge this is a demo\n3. You promise to have fun with it\n\n---\n\n*Last updated: 2024*" \
    --icon "SF=doc.text,colour=#5856D6" \
    --eula \
    --button1text "Accept" \
    --button2text "Decline" \
    --moveable \
    --width 700 \
    --height 500 \
    --json || true

# --- Auth key explanation ---
"$DIALOG" \
    --style alert \
    --title "Auth Key & Checksum" \
    --message "swiftDialog supports an **authentication key** system:\n\n• \`--key <passphrase>\` — SHA256 verified against a stored hash\n• \`--checksum <string>\` — Generates SHA256 hashes\n\nThis prevents unauthorised use of swiftDialog.\n\n_These are not demonstrated live to avoid modifying system preferences._" \
    --icon "SF=lock.shield.fill,colour=#FF3B30" \
    --button1text "Next →" \
    --button2text "Skip" \
    --json || exit 0

# --- List fonts ---
font_list=$("$DIALOG" --listfonts 2>/dev/null || echo "Unable to retrieve font list")
"$DIALOG" \
    --title "Available Fonts" \
    --message "The \`--listfonts\` flag outputs all font names available to swiftDialog for use with \`titlefont:\`, \`messagefont:\`, and other font parameters." \
    --icon "SF=textformat,colour=#5856D6" \
    --infobox "$font_list" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --height 500 \
    --json || exit 0

# --- Verbose mode ---
"$DIALOG" \
    --style alert \
    --title "Verbose Mode" \
    --message "The \`--verbose\` flag enables detailed diagnostic output written to **stderr**.\n\nIt is intended for development and troubleshooting, not user-facing dialogs.\n\nRun any dialog with \`--verbose 2>&1 | less\` in a terminal to see the full output." \
    --icon "SF=megaphone,colour=#FF9500" \
    --button1text "Done ✓" \
    --json || true
