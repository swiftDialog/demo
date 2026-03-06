#!/bin/zsh
# Demo 12: Command File Live Updates
# Demonstrates the full range of command file operations:
#   title:, titlefont:, message: (including append with +), alignment:,
#   icon:, icon: size:, icon: centre/left, iconalpha:, overlayicon:,
#   button1text:, button1:, button2text:, button2:, buttonsize:,
#   infobuttontext:, infotext:, infobox:,
#   width:, height:, position:, activate:, hide:, show:,
#   blurscreen:, showdockicon:, dockicon:, dockiconbadge:, bounce:,
#   bannerimage:, bannertext:, webcontent:, video:, quit:

DIALOG="/usr/local/bin/dialog"
CMD_FILE="/var/tmp/dialog.log"
BANNER_IMAGE="/System/Library/CoreServices/DefaultDesktop.heic"

rm -f "$CMD_FILE"

# Launch the dialog
"$DIALOG" \
    --title "Command File Demo" \
    --message "This dialog will update itself in real-time using the command file.\n\nWatch as properties change!" \
    --icon "SF=terminal,colour=#007AFF" \
    --iconsize 100 \
    --progress 19 \
    --progresstext "Starting demo..." \
    --infotext "Step 0 of 19" \
    --button1text "Please watch..." \
    --button1disabled \
    --button2text "Demo running..." \
    --button2disabled \
    --commandfile "$CMD_FILE" \
    --moveable \
    --width 700 \
    --height 450 &

DIALOG_PID=$!
sleep 1.5

# Step 1: Update title
echo "progress: 1" >> "$CMD_FILE"
echo "progresstext: Updating title..." >> "$CMD_FILE"
echo "infotext: Step 1 of 19" >> "$CMD_FILE"
echo "title: Title Changed!" >> "$CMD_FILE"
sleep 2

# Step 2: Update title font
echo "progress: 2" >> "$CMD_FILE"
echo "progresstext: Changing title font..." >> "$CMD_FILE"
echo "infotext: Step 2 of 19" >> "$CMD_FILE"
echo "titlefont: size=28 weight=light colour=#FF2D55" >> "$CMD_FILE"
sleep 2

# Step 3: Update message
echo "progress: 3" >> "$CMD_FILE"
echo "progresstext: Updating message..." >> "$CMD_FILE"
echo "infotext: Step 3 of 19" >> "$CMD_FILE"
echo "alignment: left" >> "$CMD_FILE"
echo "message: The message has been completely replaced!\n\nThis is a **new message** with markdown support." >> "$CMD_FILE"
sleep 2

# Step 4: Append to message
echo "progress: 4" >> "$CMD_FILE"
echo "progresstext: Appending to message..." >> "$CMD_FILE"
echo "infotext: Step 4 of 19" >> "$CMD_FILE"
echo "message: + \n\n_This line was appended using the \`+\` prefix._" >> "$CMD_FILE"
sleep 2

# Step 5: Change message alignment
echo "progress: 5" >> "$CMD_FILE"
echo "progresstext: Centering message..." >> "$CMD_FILE"
echo "infotext: Step 5 of 19" >> "$CMD_FILE"
echo "alignment: center" >> "$CMD_FILE"
sleep 2

# Step 6: Change icon
echo "progress: 6" >> "$CMD_FILE"
echo "progresstext: Changing icon..." >> "$CMD_FILE"
echo "infotext: Step 6 of 19" >> "$CMD_FILE"
echo "icon: SF=globe.americas.fill,colour=#34C759" >> "$CMD_FILE"
sleep 2

# Step 7: Add overlay icon
echo "progress: 7" >> "$CMD_FILE"
echo "progresstext: Adding overlay icon..." >> "$CMD_FILE"
echo "infotext: Step 7 of 19" >> "$CMD_FILE"
echo "overlayicon: SF=checkmark.circle.fill,colour=#FFD60A" >> "$CMD_FILE"
sleep 2

# Step 8: Change icon transparency
echo "progress: 8" >> "$CMD_FILE"
echo "progresstext: Adjusting icon alpha..." >> "$CMD_FILE"
echo "infotext: Step 8 of 19" >> "$CMD_FILE"
echo "iconalpha: 0.4" >> "$CMD_FILE"
sleep 1.5
echo "iconalpha: 1.0" >> "$CMD_FILE"
sleep 2

# Step 9: Resize icon via command file
echo "progress: 9" >> "$CMD_FILE"
echo "progresstext: Resizing icon..." >> "$CMD_FILE"
echo "infotext: Step 9 of 19" >> "$CMD_FILE"
echo "message: Icon size can be changed live!\n\nUsing \`icon: size: 180\` via the command file." >> "$CMD_FILE"
echo "alignment: left" >> "$CMD_FILE"
echo "icon: size: 180" >> "$CMD_FILE"
sleep 2
echo "icon: size: 100" >> "$CMD_FILE"
sleep 2

# Step 10: Update button text and enable/disable
echo "progress: 10" >> "$CMD_FILE"
echo "progresstext: Toggling buttons..." >> "$CMD_FILE"
echo "infotext: Step 10 of 19" >> "$CMD_FILE"
echo "message: Both button labels and enabled state can be toggled live.\n\nButton 2 is now enabled." >> "$CMD_FILE"
echo "button1text: Almost done..." >> "$CMD_FILE"
echo "button2text: Button 2 is live!" >> "$CMD_FILE"
echo "button2: enable" >> "$CMD_FILE"
sleep 2
echo "button2: disable" >> "$CMD_FILE"
echo "button2text: Demo running..." >> "$CMD_FILE"
sleep 2

# Step 11: Update info text and info box
echo "progress: 11" >> "$CMD_FILE"
echo "progresstext: Updating info areas..." >> "$CMD_FILE"
echo "infotext: Step 11 of 19 — Info text updated!" >> "$CMD_FILE"
echo "infobox: **Info Box**\n\nThis area sits below the icon.\n\nIt supports markdown!" >> "$CMD_FILE"
sleep 2

# Step 12: Resize the window
echo "progress: 12" >> "$CMD_FILE"
echo "progresstext: Resizing window..." >> "$CMD_FILE"
echo "infotext: Step 12 of 19" >> "$CMD_FILE"
echo "message: Window dimensions can be changed live!\n\nUsing \`width:\` and \`height:\` via the command file." >> "$CMD_FILE"
echo "width: 900" >> "$CMD_FILE"
echo "height: 300" >> "$CMD_FILE"
sleep 2
echo "width: 700" >> "$CMD_FILE"
echo "height: 450" >> "$CMD_FILE"
sleep 2

# Step 13: Reposition the window
echo "progress: 13" >> "$CMD_FILE"
echo "progresstext: Repositioning window..." >> "$CMD_FILE"
echo "infotext: Step 13 of 19" >> "$CMD_FILE"
echo "message: The window position can be changed live.\n\nMoving to **topright**, then back to **center**." >> "$CMD_FILE"
echo "position: topright" >> "$CMD_FILE"
sleep 2
echo "position: center" >> "$CMD_FILE"
sleep 2

# Step 14: Centre the icon
echo "progress: 14" >> "$CMD_FILE"
echo "progresstext: Centering icon..." >> "$CMD_FILE"
echo "infotext: Step 14 of 19" >> "$CMD_FILE"
echo "icon: centre" >> "$CMD_FILE"
echo "message: The icon moved to the centre!\n\nUsing \`icon: centre\` via the command file." >> "$CMD_FILE"
echo "alignment: center" >> "$CMD_FILE"
sleep 2

# Step 15: Reset icon position
echo "progress: 15" >> "$CMD_FILE"
echo "progresstext: Restoring icon position..." >> "$CMD_FILE"
echo "infotext: Step 15 of 19" >> "$CMD_FILE"
echo "icon: left" >> "$CMD_FILE"
echo "icon: SF=safari,colour=#007AFF" >> "$CMD_FILE"
echo "overlayicon: none" >> "$CMD_FILE"
echo "alignment: left" >> "$CMD_FILE"
echo "message: Icon restored to the left.\n\nNext: \`bannerimage:\` and \`bannertext:\` updates." >> "$CMD_FILE"
sleep 2

# Step 16: Banner image and text
echo "progress: 16" >> "$CMD_FILE"
echo "progresstext: Adding banner..." >> "$CMD_FILE"
echo "infotext: Step 16 of 19" >> "$CMD_FILE"
echo "bannerimage: $BANNER_IMAGE" >> "$CMD_FILE"
echo "bannertext: Live Banner Text" >> "$CMD_FILE"
sleep 2

# Step 17: Activate (bring window to front)
echo "progress: 17" >> "$CMD_FILE"
echo "progresstext: Activating window..." >> "$CMD_FILE"
echo "infotext: Step 17 of 19" >> "$CMD_FILE"
echo "message: The \`activate:\` command brings the dialog to the foreground if it was pushed behind other windows.\n\nSwitch to another app, then watch the dialog come forward." >> "$CMD_FILE"
sleep 3
echo "activate:" >> "$CMD_FILE"
sleep 2

# Step 18: Reset and prepare for quit
echo "progress: 18" >> "$CMD_FILE"
echo "progresstext: Preparing to close..." >> "$CMD_FILE"
echo "infotext: Step 18 of 19" >> "$CMD_FILE"
echo "icon: SF=checkmark.seal.fill,colour=#34C759" >> "$CMD_FILE"
echo "title: Command File Demo Complete" >> "$CMD_FILE"
echo "titlefont: size=24 weight=bold colour=#34C759" >> "$CMD_FILE"
echo "message: All key command file operations demonstrated!\n\nClosing in 3 seconds via the \`quit:\` command..." >> "$CMD_FILE"
sleep 2

# Step 19: Close with quit: command
echo "progress: 19" >> "$CMD_FILE"
echo "progresstext: ✅ Demo complete — closing via quit:" >> "$CMD_FILE"
echo "infotext: Step 19 of 19 — Done!" >> "$CMD_FILE"
sleep 3
echo "quit:" >> "$CMD_FILE"

wait $DIALOG_PID 2>/dev/null || true
rm -f "$CMD_FILE"
