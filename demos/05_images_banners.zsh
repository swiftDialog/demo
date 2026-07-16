#!/bin/zsh
# Demo 05: Images, Banners & Backgrounds
# Demonstrates: --image, --imagecaption, --bannerimage, --bannertitle, --bannertext,
#               --bannerheight, --background, --bgalpha, --bgposition, --bgfill, --bgscale,
#               image carousel (multiple --image), markdown inline images (local & web)

DIALOG="${DIALOG:-/usr/local/bin/dialog}"

# We'll use system images that are guaranteed to exist on macOS
SYSTEM_IMG="/System/Library/Desktop Pictures"
BANNER_IMG="/System/Library/CoreServices/DefaultDesktop.heic"

# Find a suitable background image
BG_IMG=""
for img in "$SYSTEM_IMG"/*.heic; do
    if [[ -f "$img" ]]; then
        BG_IMG="$img"
        break
    fi
done

# --- Image display ---
"$DIALOG" \
    --title "Image Display" \
    --message "Use \`--image\` to display images from files or URLs.\n\nImages are resized to fit the display area.\n\nThis shows the Finder app icon as an image." \
    --image "/System/Library/CoreServices/Finder.app" \
    --imagecaption "The Finder icon displayed as an image" \
    --icon "SF=photo,colour=#007AFF" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 700 \
    --height 500 \
    --json || exit 0

# --- Image carousel (multiple --image arguments) ---
"$DIALOG" \
    --title "Image Carousel" \
    --message "Passing multiple \`--image\` arguments creates a **carousel** that the user can swipe or click through.\n\nEach \`--imagecaption\` corresponds to the preceding \`--image\` in order." \
    --image "/System/Library/CoreServices/Finder.app" \
    --imagecaption "Finder" \
    --image "/System/Applications/Calculator.app" \
    --imagecaption "Calculator" \
    --image "/System/Applications/Calendar.app" \
    --imagecaption "Calendar" \
    --image "/System/Applications/Photos.app" \
    --imagecaption "Photos" \
    --icon "SF=photo.on.rectangle.angled,colour=#007AFF" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 700 \
    --height 520 \
    --json || exit 0

# --- Markdown inline images ---
"$DIALOG" \
    --title "Markdown Inline Images" \
    --message "Images can be embedded directly in the message using standard Markdown syntax:\n\n\`![caption](path-or-url)\`\n\n**Local file:**\n\n![macOS Desktop](file:///System/Library/Desktop\ Pictures/Big\ Sur\ Graphic.heic)\n\n**Web URL:**\n\n![Placeholder image](https://picsum.photos/seed/swiftdialog/560/200)\n\nInline images render inline with the text flow, unlike \`--image\` which uses the dedicated image area." \
    --icon "SF=photo.badge.plus,colour=#34C759" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 700 \
    --height 620 \
    --json || exit 0

# --- Banner image ---
if [[ -f "$BANNER_IMG" ]]; then
    "$DIALOG" \
        --bannerimage "$BANNER_IMG" \
        --bannertitle \
        --title "Banner Image" \
        --titlefont "colour=white,weight=bold,size=28,shadow=true" \
        --message "The \`--bannerimage\` fills the top of the dialog window.\n\nCombined with \`--bannertitle\` the title overlays the banner with a drop shadow.\n\nBanner images span the full width. An ideal size is **850×150** for the default window." \
        --button1text "Next →" \
        --button2text "Skip" \
        --moveable \
        --width 750 \
        --height 450 \
        --json || exit 0
else
    "$DIALOG" \
        --title "Banner Image (Skipped)" \
        --message "No suitable system image found to demonstrate banners.\n\nIn practice, use \`--bannerimage /path/to/image\` with your own banner graphic." \
        --icon "SF=photo.badge.exclamationmark,colour=#FF9500" \
        --button1text "Next →" \
        --button2text "Skip" \
        --moveable \
        --json || exit 0
fi

# --- Banner text shortcut ---
"$DIALOG" \
    --bannerimage "${BANNER_IMG:-/System/Library/CoreServices/DefaultDesktop.heic}" \
    --bannertext "Banner Text Shortcut" \
    --titlefont "colour=white,weight=bold,size=24,shadow=true" \
    --message "\`--bannertext\` is a shortcut that combines \`--bannertitle\` and \`--title\` in one argument." \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 700 \
    --json || exit 0

# --- Background image ---
if [[ -n "$BG_IMG" ]]; then
    "$DIALOG" \
        --title "Background Image" \
        --message "Use \`--background\` to set a dialog background image.\n\nThis example uses:\n- \`--bgalpha 0.3\` (30% opacity)\n- \`--bgposition center\`\n- \`--bgfill fill\`\n\nThe background sits behind all content." \
        --background "$BG_IMG" \
        --bgalpha 0.3 \
        --bgposition center \
        --bgfill fill \
        --icon "SF=photo.artframe,colour=#5856D6" \
        --button1text "Next →" \
        --button2text "Skip" \
        --moveable \
        --width 700 \
        --height 400 \
        --json || exit 0

    # --- Background with fit ---
    "$DIALOG" \
        --title "Background — Fit Mode" \
        --message "With \`--bgfill fit\`, the image is scaled to fit inside the window without cropping.\n\n\`--bgposition topleft\` anchors it to the top-left." \
        --background "$BG_IMG" \
        --bgalpha 0.2 \
        --bgposition topleft \
        --bgfill fit \
        --icon "SF=arrow.down.right.and.arrow.up.left,colour=#FF9500" \
        --button1text "Done ✓" \
        --moveable \
        --width 700 \
        --height 400 \
        --json || true
else
    "$DIALOG" \
        --title "Background Demo Complete" \
        --message "Background image demo uses system desktop pictures.\n\nUse \`--background\`, \`--bgalpha\`, \`--bgposition\`, and \`--bgfill\` to customise." \
        --icon "SF=photo.artframe,colour=#5856D6" \
        --button1text "Done ✓" \
        --moveable \
        --json || true
fi
