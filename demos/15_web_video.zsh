#!/bin/zsh
# Demo 15: Web Content & Video
# Demonstrates: --webcontent, --video, --videocaption, --autoplay

DIALOG="/usr/local/bin/dialog"

# --- Web content ---
"$DIALOG" \
    --title "Web Content" \
    --message "Displaying webcontent from `https://github.com/swiftDialog/swiftDialog` below:" \
    --webcontent "https://github.com/swiftDialog/swiftDialog" \
    --icon "SF=globe,colour=#007AFF" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 900 \
    --height 650 \
    --json || exit 0

# --- Video from YouTube ---
"$DIALOG" \
    --title "Video Playback" \
    --message "swiftDialog can embed videos from files, URLs, YouTube, or Vimeo.\n\nThis example uses a YouTube video ID shortcut." \
    --video "youtubeid=R3GfuzLMPkA" \
    --videocaption "YouTube video embedded with youtube=<id> shortcut" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 800 \
    --height 600 \
    --json || exit 0

# --- Video from Vimeo ---
"$DIALOG" \
    --title "Vimeo Playback" \
    --message "Vimeo videos are embedded the same way using a \`vimeoid=\` shortcut.\n\nThis example uses a Vimeo video ID shortcut." \
    --video "vimeoid=76979871" \
    --videocaption "Vimeo video embedded with vimeoid=<id> shortcut" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 800 \
    --height 600 \
    --json || exit 0

# --- Video with autoplay ---
"$DIALOG" \
    --title "Video Autoplay" \
    --message "Add \`--autoplay\` to start video playback automatically." \
    --video "youtubeid=R3GfuzLMPkA" \
    --videocaption "Autoplay enabled for this video" \
    --autoplay \
    --button1text "Done ✓" \
    --moveable \
    --width 800 \
    --height 600 \
    --json || true
