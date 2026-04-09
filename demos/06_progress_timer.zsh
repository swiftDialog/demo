#!/bin/zsh
# Demo 06: Progress Bar & Timer
# Demonstrates: --progress, --progresstext, --progresstextalignment,
#               --timer, --hidetimerbar, --hidetimer, command file updates

DIALOG="/usr/local/bin/dialog"
CMD_FILE=""

cleanup() {
    if [[ -n "$CMD_FILE" ]]; then
        rm -f "$CMD_FILE"
    fi
}
trap cleanup EXIT

# --- Interactive progress bar (command file driven) ---
cleanup
CMD_FILE=$(mktemp -t dialog.XXXXXX)

"$DIALOG" \
    --title "Interactive Progress Bar" \
    --message "Watch the progress bar update in real-time via the **command file**.\n\nThis simulates a multi-step installation process." \
    --icon "SF=arrow.down.circle,colour=#007AFF" \
    --progress 10 \
    --progresstext "Initializing..." \
    --button1text "Please wait..." \
    --button1disabled \
    --commandfile "$CMD_FILE" \
    --moveable \
    --width 650 \
    --height 350 &

DIALOG_PID=$!
sleep 1

# Simulate a multi-step process
steps=(
    "Downloading components..."
    "Verifying checksums..."
    "Extracting files..."
    "Installing core framework..."
    "Configuring preferences..."
    "Setting up services..."
    "Applying security policies..."
    "Registering components..."
    "Running post-install scripts..."
    "Finalizing installation..."
)

for i in {1..10}; do
    echo "progress: $i" >> "$CMD_FILE"
    echo "progresstext: Step $i/10: ${steps[$i]}" >> "$CMD_FILE"
    sleep 0.8
done

echo "progresstext: ✅ Installation complete!" >> "$CMD_FILE"
echo "button1text: Done ✓" >> "$CMD_FILE"
echo "button1: enable" >> "$CMD_FILE"
echo "icon: SF=checkmark.circle.fill,colour=#34C759" >> "$CMD_FILE"

wait $DIALOG_PID 2>/dev/null || true
cleanup

# --- Progress with increment ---
cleanup
CMD_FILE=$(mktemp -t dialog.XXXXXX)

"$DIALOG" \
    --title "Progress Increment" \
    --message "Progress can also be **incremented** rather than set to absolute values.\n\nSending \`progress: increment 5\` adds 5 to the current value." \
    --icon "SF=plusminus.circle,colour=#5856D6" \
    --progress 100 \
    --progresstext "Starting..." \
    --button1text "Please wait..." \
    --button1disabled \
    --commandfile "$CMD_FILE" \
    --moveable \
    --width 650 &

DIALOG_PID=$!
sleep 1

for i in {1..20}; do
    echo "progress: increment 5" >> "$CMD_FILE"
    echo "progresstext: Increment #$i (+5 each time, total: $((i * 5))%)" >> "$CMD_FILE"
    sleep 0.4
done

echo "progresstext: Complete!" >> "$CMD_FILE"
echo "button1text: Next →" >> "$CMD_FILE"
echo "button1: enable" >> "$CMD_FILE"

wait $DIALOG_PID 2>/dev/null || true
cleanup

# --- Timer bar ---
"$DIALOG" \
    --title "Countdown Timer" \
    --message "The \`--timer\` option shows a countdown bar.\n\nThis dialog will auto-close after **8 seconds**, or you can click the button early.\n\nNote: the button is disabled for the first 3 seconds." \
    --icon "SF=timer,colour=#FF9500" \
    --timer 8 \
    --button1text "Dismiss Early" \
    --moveable \
    --width 600

# --- Hidden timer ---
"$DIALOG" \
    --title "Hidden Timer" \
    --message "With \`--hidetimerbar\`, the countdown still runs but the bar is invisible.\n\nThis dialog closes automatically in **5 seconds**.\n\nThe OK button is always shown to prevent unclosable dialogs." \
    --icon "SF=eye.slash,colour=#8E8E93" \
    --timer 5 \
    --hidetimerbar \
    --button1text "OK" \
    --moveable \
    --width 600 || true

# --- Progress text alignment ---
cleanup
CMD_FILE=$(mktemp -t dialog.XXXXXX)

"$DIALOG" \
    --title "Progress Text Alignment" \
    --message "Progress text can be aligned with \`--progresstextalignment\`.\n\nThis example uses **right** alignment." \
    --icon "SF=text.alignright,colour=#00C7BE" \
    --progress 5 \
    --progresstext "Right-aligned progress text →" \
    --progresstextalignment right \
    --button1text "Done ✓" \
    --commandfile "$CMD_FILE" \
    --moveable \
    --width 650 &

DIALOG_PID=$!
sleep 1

for i in {1..5}; do
    echo "progress: $i" >> "$CMD_FILE"
    echo "progresstext: Step $i of 5 →" >> "$CMD_FILE"
    sleep 1
done

echo "progresstext: All done! →" >> "$CMD_FILE"

wait $DIALOG_PID 2>/dev/null || true
cleanup
