#!/bin/zsh
# Demo 11: Window Options
# Demonstrates: --width, --height, --big, --small, --position, --positionoffset,
#               --moveable, --ontop, --resizable, --windowbuttons, --appearance,
#               --showonallscreens, --showdockicon, --dockicon, --dockiconbadge

DIALOG="/usr/local/bin/dialog"

# --- Small window ---
"$DIALOG" \
    --title "Small Window" \
    --message "The \`--small\` flag reduces the default window size by 25%." \
    --icon "SF=arrow.down.right.and.arrow.up.left,colour=#007AFF" \
    --small \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Big window ---
"$DIALOG" \
    --title "Big Window" \
    --message "The \`--big\` flag increases the default window size by 25%.\n\nThis gives more room for content." \
    --icon "SF=arrow.up.left.and.arrow.down.right,colour=#5856D6" \
    --big \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Custom dimensions ---
"$DIALOG" \
    --title "Custom Dimensions" \
    --message "Use \`--width\` and \`--height\` for precise control.\n\nThese values are static, so choose dimensions that fit the content you plan to show.\n\nThis window is **900 × 300** points." \
    --icon "SF=ruler,colour=#FF9500" \
    --width 900 \
    --height 300 \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Window positioning ---
"$DIALOG" \
    --title "Window Position: Top Right" \
    --message "Use \`--position\` with keywords like topleft, top, topright, left, center, right, bottomleft, bottom, bottomright.\n\nThis window is at **topright**." \
    --icon "SF=arrow.up.right,colour=#34C759" \
    --position topright \
    --button1text "Next →" \
    --button2text "Skip" \
    --width 500 \
    --height 300 \
    --json || exit 0

"$DIALOG" \
    --title "Window Position: Bottom Left" \
    --message "Now positioned at **bottomleft** with a custom offset of 50 pixels." \
    --icon "SF=arrow.down.left,colour=#FF3B30" \
    --position bottomleft \
    --positionoffset 50 \
    --button1text "Next →" \
    --button2text "Skip" \
    --width 500 \
    --height 300 \
    --json || exit 0

# --- Resizable window ---
"$DIALOG" \
    --title "Resizable Window" \
    --message "The \`--resizable\` flag lets you drag window edges to resize.\n\nThis also implies \`--moveable\`.\n\nTry resizing this window!" \
    --icon "SF=arrow.up.left.and.down.right.and.arrow.up.right.and.down.left,colour=#AF52DE" \
    --resizable \
    --button1text "Next →" \
    --button2text "Skip" \
    --json || exit 0

# --- Window buttons ---
"$DIALOG" \
    --title "Window Buttons" \
    --message "The \`--windowbuttons\` flag enables macOS window controls.\n\nYou can enable specific buttons: close, min, max.\n\nThis window has **close** and **min** enabled." \
    --icon "SF=macwindow,colour=#00C7BE" \
    --windowbuttons close,min \
    --moveable \
    --button1text "Next →" \
    --button2text "Skip" \
    --json || exit 0

# --- Dark appearance ---
"$DIALOG" \
    --title "Dark Mode" \
    --message "Force a specific appearance with \`--appearance dark\` or \`--appearance light\`.\n\nThis window uses **dark** mode regardless of your system setting." \
    --icon "SF=moon.fill,colour=#FFD60A" \
    --appearance dark \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Light appearance ---
"$DIALOG" \
    --title "Light Mode" \
    --message "This window forces **light** mode.\n\nUseful for ensuring consistent branding." \
    --icon "SF=sun.max.fill,colour=#FF9500" \
    --appearance light \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- On top ---
"$DIALOG" \
    --title "Always On Top" \
    --message "The \`--ontop\` flag keeps the dialog above all other windows.\n\nThis also implies \`--showonallscreens\`." \
    --icon "SF=pin.fill,colour=#FF2D55" \
    --ontop \
    --moveable \
    --button1text "Next →" \
    --button2text "Skip" \
    --json || exit 0

# --- Dock icon with badge ---
"$DIALOG" \
    --title "Dock Icon & Badge" \
    --message "Use \`--showdockicon\` to show the app in the Dock.\n\nAdd \`--dockiconbadge\` to display a badge.\n\nCheck the Dock — you should see a badge of **3**!" \
    --icon "SF=dock.rectangle,colour=#007AFF" \
    --showdockicon \
    --dockiconbadge "3" \
    --button1text "Done ✓" \
    --moveable \
    --json || true
