#!/bin/zsh
# Demo 02: Title & Message Formatting
# Demonstrates: --title, --titlefont, --message, --messagefont,
#               --messagealignment, --messageposition, --bannertitle, --bannertext,
#               inline colour syntax :colour[text]

DIALOG="${DIALOG:-/usr/local/bin/dialog}"

# --- Title font customization ---
"$DIALOG" \
    --title "Custom Title Font" \
    --titlefont "colour=#FF2D55,size=32,weight=light" \
    --message "This title uses:\n- **colour** = #FF2D55 (pink)\n- **size** = 32\n- **weight** = light\n\nThe \`--titlefont\` option accepts colour, size, weight, name, and alignment." \
    --icon "SF=textformat.size,colour=#FF2D55" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Title alignment ---
"$DIALOG" \
    --title "Right-Aligned Title" \
    --titlefont "alignment=right,colour=#5856D6,weight=bold,size=24" \
    --message "The title above is right-aligned using \`--titlefont \"alignment=right\"\`.\n\nLeft alignment is also available." \
    --icon "SF=text.alignright,colour=#5856D6" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Title "none" ---
"$DIALOG" \
    --title "none" \
    --message "### No Title Area\n\nWhen \`--title none\` is used, the entire title area is removed, giving more space to the message content.\n\nThis is useful for information-dense dialogs." \
    --icon "SF=rectangle.slash,colour=#FF9500" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Message with Markdown ---
"$DIALOG" \
    --title "Markdown Message" \
    --message "swiftDialog supports **GitHub Flavored Markdown**:\n\n## Heading\n\n- Bullet list item 1\n- Bullet list item 2\n\n| Column A | Column B |\n|----------|----------|\n| Cell 1   | Cell 2   |\n| Cell 3   | Cell 4   |\n\n> Blockquotes work too!\n\n\`inline code\` and:\n\n\`\`\`\ncode blocks\n\`\`\`\n\n**Bold**, *italic*, and [links](https://github.com/swiftDialog/swiftDialog)." \
    --icon "SF=doc.richtext,colour=#34C759" \
    --button1text "Next →" \
    --button2text "Skip" \
    --width 700 \
    --height 550 \
    --moveable \
    --json || exit 0

# --- Inline colour syntax ---
"$DIALOG" \
    --title "Inline Colour Syntax" \
    --message ":blue[Named colours] are applied with the **\`:colour[text]\`** syntax.\n\n:red[Red]  :orange[Orange]  :yellow[Yellow]  :green[Green]  :blue[Blue]  :purple[Purple]\n\nHex codes work the same way:\n\n:FF2D55[Hot pink]  :5856D6[Indigo]  :34C759[Mint]  :FF9500[Amber]\n\nHex colours can target :F[i]:F5[n]:FA[d]:FF[i]:FF5[v]:FF55[i]:FF5500[dual] letters to create gradients or highlights." \
    --icon "SF=paintpalette,colour=#FF9500" \
    --button1text "Next →" \
    --button2text "Skip" \
    --width 680 \
    --moveable \
    --json || exit 0

# --- Message alignment ---
"$DIALOG" \
    --title "Message Alignment" \
    --messagealignment center \
    --message "This message is **center-aligned**.\n\nUse \`--messagealignment\` with left, centre, or right." \
    --icon "SF=text.aligncenter,colour=#007AFF" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Message vertical position ---
"$DIALOG" \
    --title "Message Position" \
    --messageposition bottom \
    --message "This message is vertically positioned at the **bottom** of the content area.\n\nUse \`--messageposition\` with top, centre, or bottom." \
    --icon "SF=arrow.down.to.line,colour=#FF9500" \
    --height 400 \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --json || exit 0

# --- Custom message font ---
"$DIALOG" \
    --title "Custom Message Font" \
    --message "This message uses a custom font size and colour.\n\nThe \`--messagefont\` option supports colour and size properties." \
    --messagefont "colour=#00C7BE,size=18" \
    --icon "SF=paintbrush.pointed,colour=#00C7BE" \
    --button1text "Done ✓" \
    --moveable \
    --json || true
