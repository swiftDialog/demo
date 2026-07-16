#!/bin/zsh
# Demo 03: Icon Showcase
# Demonstrates: --icon (SF Symbols, apps, builtins, QR, colours, palette, weight,
#               animation), --iconsize, --iconalpha, --centreicon,
#               --overlayicon, --hideicon

DIALOG="${DIALOG:-/usr/local/bin/dialog}"

# --- SF Symbol with colour ---
"$DIALOG" \
    --title "SF Symbol Icon" \
    --message "Icons can be **SF Symbols** with custom colour and weight.\n\nThis uses:\n\`--icon \"SF=bolt.circle.fill,colour=#FF9500,weight=regular\"\`\n\nVisit [SF Symbols](https://developer.apple.com/sf-symbols/) for 3,100+ symbols." \
    --icon "SF=bolt.circle.fill,colour=#FF9500,weight=regular" \
    --iconsize 130 \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- SF Symbol with palette ---
"$DIALOG" \
    --title "SF Symbol Palette" \
    --message "SF Symbols support **multi-colour palettes**.\n\nThis uses:\n\`--icon \"SF=person.crop.circle.badge.checkmark,palette=#007AFF,#34C759,#FF3B30\"\`\n\nUp to three palette colours are supported." \
    --icon "SF=person.crop.circle.badge.checkmark,palette=#007AFF,#34C759,#FF3B30" \
    --iconsize 130 \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- SF Symbol with auto colour ---
"$DIALOG" \
    --title "SF Symbol Auto Colour" \
    --message "Use \`colour=auto\` to let multicolour SF Symbols use their default colour scheme." \
    --icon "SF=externaldrive.fill.badge.wifi,colour=auto" \
    --iconsize 130 \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- App icon ---
"$DIALOG" \
    --title "Application Icon" \
    --message "You can use any installed **.app** bundle as an icon source.\n\n\`--icon /Applications/Safari.app\`" \
    --icon "/Applications/Safari.app" \
    --iconsize 130 \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Built-in icons ---
"$DIALOG" \
    --title "Built-in Icons" \
    --message "swiftDialog includes built-in keywords:\n\n- \`info\`\n- \`caution\`\n- \`warning\`\n\nThis dialog uses \`--icon caution\`." \
    --icon "caution" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- QR Code ---
"$DIALOG" \
    --title "QR Code Icon" \
    --message "Generate QR codes on the fly!\n\n\`--icon \"qr=https://github.com/swiftDialog/swiftDialog\"\`\n\nScan the icon to visit the swiftDialog repo." \
    --icon "qr=https://github.com/swiftDialog/swiftDialog" \
    --iconsize 180 \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json || exit 0

# --- Icon size ---
"$DIALOG" \
    --title "Icon Size" \
    --message "The \`--iconsize\` argument controls icon dimensions.\n\nThis icon is set to **200** (default is 150)." \
    --icon "SF=star.circle.fill,colour=#FFD60A" \
    --iconsize 200 \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --height 400 \
    --json || exit 0

# --- Icon alpha ---
"$DIALOG" \
    --title "Icon Transparency" \
    --message "The \`--iconalpha\` argument controls icon opacity.\n\nThis icon uses \`--iconalpha 0.3\` (30% opaque)." \
    --icon "SF=shield.lefthalf.filled,colour=#007AFF" \
    --iconalpha 0.3 \
    --iconsize 150 \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Centred icon ---
"$DIALOG" \
    --title "Centred Icon" \
    --message "Use \`--centreicon\` to position the icon between the title and message areas." \
    --icon "SF=globe.americas.fill,colour=#34C759" \
    --centreicon \
    --iconsize 120 \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --height 420 \
    --json || exit 0

# --- Overlay icon ---
"$DIALOG" \
    --title "Overlay Icon" \
    --message "The \`--overlayicon\` places a smaller icon on top of the main icon.\n\nMain: Safari.app\nOverlay: SF=checkmark.circle.fill (green)" \
    --icon "/Applications/Safari.app" \
    --overlayicon "SF=checkmark.circle.fill,colour=#34C759" \
    --iconsize 150 \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Hidden icon ---
"$DIALOG" \
    --title "Hidden Icon" \
    --message "The \`--hideicon\` flag removes the icon entirely and gives more room to the message area.\n\nNotice how this text stretches further to the left compared to dialogs with an icon." \
    --hideicon \
    --button1text "Done ✓" \
    --moveable \
    --json || true
