#!/bin/zsh
# Demo 04: Buttons & Actions
# Demonstrates: --button1text, --button1disabled, --button1action, --button1symbol,
#               --button2, --button2text, --button2disabled, --button2symbol,
#               --infobutton, --infobuttontext, --infobuttonaction, --infobuttonsymbol,
#               --buttonstyle (center, stack), --buttonsize, --buttontextsize,
#               --quitoninfo, --helpmessage, --hidedefaultkeyboardaction

DIALOG="/usr/local/bin/dialog"

# --- Button 1 with symbol ---
"$DIALOG" \
    --title "Button 1 with Symbol" \
    --message "Buttons can include **SF Symbols** alongside their text.\n\nButton 1 uses:\n\`--button1symbol \"checkmark.circle.fill,position=leading,color=#34C759\"\`\n\nSymbols support position (leading/trailing/top/bottom), colour, size, and rendering mode." \
    --icon "SF=hand.tap,colour=#007AFF" \
    --button1text "Accept" \
    --button1symbol "checkmark.circle.fill,position=leading,color=#34C759" \
    --button2text "Next →" \
    --moveable \
    --json || exit 0

# --- Button 2 with symbol ---
"$DIALOG" \
    --title "Button 2 with Symbol" \
    --message "Button 2 also supports symbols.\n\nHere both buttons have icons:\n- Button 1: trailing arrow\n- Button 2: xmark in leading position" \
    --icon "SF=hand.tap,colour=#007AFF" \
    --button1text "Continue" \
    --button1symbol "arrow.right,position=trailing" \
    --button2text "Cancel" \
    --button2symbol "xmark.circle,position=leading,color=#FF3B30" \
    --moveable \
    --json || exit 0

# --- Info button with action ---
"$DIALOG" \
    --title "Info Button" \
    --message "The **info button** appears in the bottom-left corner.\n\nWith \`--infobuttonaction\`, clicking it opens a URL instead of closing the dialog.\n\nTry clicking **More Info** below!" \
    --icon "SF=info.circle.fill,colour=#5856D6" \
    --button1text "Next →" \
    --infobuttontext "More Info" \
    --infobuttonsymbol "safari,position=leading,color=#007AFF" \
    --infobuttonaction "https://github.com/swiftDialog/swiftDialog/wiki" \
    --moveable \
    --json || exit 0

# --- Centered button style ---
"$DIALOG" \
    --title "Centered Buttons" \
    --message "Use \`--buttonstyle center\` to center the buttons at the bottom of the window." \
    --icon "SF=rectangle.center.inset.filled,colour=#FF9500" \
    --button1text "Primary" \
    --button2text "Secondary" \
    --buttonstyle center \
    --moveable \
    --json || exit 0

# --- Stacked button style ---
"$DIALOG" \
    --title "Stacked Buttons" \
    --message "Use \`--buttonstyle stack\` for full-width vertically stacked buttons.\n\nThis is useful for dialogs with many choices or on smaller screens." \
    --icon "SF=rectangle.stack,colour=#AF52DE" \
    --button1text "Option A — Install and Continue" \
    --button2text "Option B — Skip This Step" \
    --buttonstyle stack \
    --moveable \
    --width 500 \
    --json || exit 0

# --- Button sizes ---
"$DIALOG" \
    --title "Button Sizes" \
    --message "Buttons can be resized with \`--buttonsize\`.\n\nThis dialog uses **large** buttons.\n\nAvailable sizes: mini, small, regular, large." \
    --icon "SF=arrow.up.left.and.arrow.down.right,colour=#00C7BE" \
    --button1text "Large Button" \
    --button2text "Also Large" \
    --buttonsize large \
    --moveable \
    --json || exit 0

# --- Button text size ---
"$DIALOG" \
    --title "Button Text Size" \
    --message "The \`--buttontextsize\` option lets you change the font size of button labels.\n\nThis uses \`--buttontextsize 20\`." \
    --icon "SF=textformat.size,colour=#FF2D55" \
    --button1text "Big Text" \
    --button2text "Big Text Too" \
    --buttontextsize 20 \
    --moveable \
    --json || exit 0

# --- Hide default keyboard action ---
"$DIALOG" \
    --title "Hidden Keyboard Action" \
    --message "The \`--hidedefaultkeyboardaction\` flag requires **⌘⇧** modifier keys to activate Return ↵ or Esc ⎋.\n\nThis prevents accidental dismissal.\n\nTry pressing Enter alone — nothing happens. Use **⌘⇧Enter** instead." \
    --icon "SF=keyboard.badge.ellipsis,colour=#FF9500" \
    --button1text "Next →" \
    --button2text "Also works with ⌘⇧Esc" \
    --hidedefaultkeyboardaction \
    --moveable \
    --json || exit 0

# --- Help message ---
"$DIALOG" \
    --title "Help Button" \
    --message "The \`--helpmessage\` option enables the **(?)** help button in the bottom-right corner.\n\nClick it to see the help popover." \
    --icon "SF=questionmark.circle,colour=#5856D6" \
    --helpmessage "### How to use this dialog\n\nThis is the **help popover** triggered by the \`--helpmessage\` option.\n\nYou can put any **markdown content** here, including:\n- Lists\n- Code blocks\n- Links" \
    --button1text "Next →" \
    --moveable \
    --json || exit 0

# --- Disabled buttons ---
"$DIALOG" \
    --title "Disabled Buttons" \
    --message "Button 1 is **disabled** at launch with \`--button1disabled\`.\n\nButton 2 is active. In a real workflow, you'd re-enable Button 1 via the command file after some condition is met.\n\nPress Button 2 to continue." \
    --icon "SF=hand.raised.slash,colour=#8E8E93" \
    --button1text "Disabled" \
    --button1disabled \
    --button2text "Done ✓" \
    --moveable \
    --json || exit 0
