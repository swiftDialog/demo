#!/bin/zsh
# ============================================================================
# swiftDialog Comprehensive Demo Suite
# ============================================================================
# A controller script that demonstrates swiftDialog capabilities by using
# swiftDialog itself to navigate between demonstrations.
#
# Requirements: macOS 15+, swiftDialog installed at /usr/local/bin/dialog, jq
# ============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
DIALOG="/usr/local/bin/dialog"
DEMO_DIR="$(cd "$(dirname "$0")/demos" && pwd)"
COMMAND_FILE="/var/tmp/dialog.log"
ICON_APP="/Applications/Utilities/Terminal.app"
DEMO_VERSION="1.0"

# Colours
BLUE="#007AFF"
GREEN="#34C759"
ORANGE="#FF9500"
RED="#FF3B30"
PURPLE="#AF52DE"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
cleanup() {
    rm -f "$COMMAND_FILE" 2>/dev/null
    # Kill any lingering dialog processes we may have spawned
    killall dialog 2>/dev/null || true
}
trap cleanup EXIT

dialog_version() {
    "$DIALOG" --version 2>/dev/null || echo "unknown"
}

# ---------------------------------------------------------------------------
# Splash / Welcome Screen
# ---------------------------------------------------------------------------
show_welcome() {
    "$DIALOG" \
        --title "swiftDialog Demo Suite" \
        --titlefont "size=28,weight=bold,colour=${BLUE}" \
        --message "Welcome to the **swiftDialog Comprehensive Demo Suite** (v${DEMO_VERSION}).\n\nThis suite demonstrates the wide range of capabilities available in swiftDialog **$(dialog_version)**.\n\nUse the checkboxes on the next screen to choose which demos to run, then press **Start** to begin.\n\n_Each demo is self-contained and will return here when finished._" \
        --icon "SF=sparkles,colour=${BLUE}" \
        --iconsize 120 \
        --button1text "Let's Go →" \
        --button2text "Quit" \
        --infotext "swiftDialog Demo Suite v${DEMO_VERSION}" \
        --ontop \
        --moveable \
        --width 700 \
        --height 450 \
        --messagefont "size=15" \
        --json

    return $?
}

# ---------------------------------------------------------------------------
# Demo Selector — uses checkboxes so the user can pick which demos to run
# ---------------------------------------------------------------------------
show_selector() {
    local result
    result=$("$DIALOG" \
        --title "Select Demonstrations" \
        --titlefont "size=24,weight=bold" \
        --message "Choose the demos you'd like to see. They will run in order.\n\nEach demo showcases different swiftDialog features." \
        --icon "SF=checklist,colour=${GREEN}" \
        --iconsize 80 \
        --checkbox "1. Basic Dialog Styles (alert - caution - warning - centered)" \
        --checkbox "2. Title & Message Formatting" \
        --checkbox "3. Icon Showcase (SF Symbols - overlays - animations)" \
        --checkbox "4. Buttons & Actions" \
        --checkbox "5. Images - Banners & Backgrounds" \
        --checkbox "6. Progress Bar & Timer" \
        --checkbox "7. Text Fields & Input Validation" \
        --checkbox "8. Dropdown Select Lists" \
        --checkbox "9. Checkboxes & Switches" \
        --checkbox "10. List Items & Status Updates" \
        --checkbox "11. Window Options (size - position - appearance)" \
        --checkbox "12. Command File Live Updates" \
        --checkbox "13. Notification Demo" \
        --checkbox "14. Mini & Presentation Mode" \
        --checkbox "15. Web Content & Video" \
        --checkbox "16. JSON Input Demo" \
        --checkbox "17. Full Screen & Blur" \
        --checkbox "18. View Order & Misc Features" \
        --checkbox "19. Inspect Mode (config presets - log monitor - item auto-complete)" \
        --button1text "▶ Start Demos" \
        --button2text "Back" \
        --infotext "Tip: check all for the full tour" \
        --ontop \
        --moveable \
        --width 720 \
        --height 690 \
        --resizable \
        --json 2>/dev/null) || return $?

    echo "$result"
}

# ---------------------------------------------------------------------------
# Run individual demo scripts
# ---------------------------------------------------------------------------
run_demo() {
    local demo_script="$1"
    if [[ -x "${DEMO_DIR}/${demo_script}" ]]; then
        echo "▶ Running ${demo_script}..."
        "${DEMO_DIR}/${demo_script}"
    else
        echo "⚠ Demo script not found or not executable: ${demo_script}"
    fi
}

# ---------------------------------------------------------------------------
# Completion screen
# ---------------------------------------------------------------------------
show_completion() {
    "$DIALOG" \
        --title "Demo Suite Complete" \
        --titlefont "size=26,weight=bold,colour=${GREEN}" \
        --message "All selected demonstrations have finished!\n\nFeel free to run the suite again to explore more features, or examine the individual scripts in the \`demos/\` directory." \
        --icon "SF=checkmark.seal.fill,colour=${GREEN}" \
        --iconsize 120 \
        --button1text "Run Again" \
        --button2text "Quit" \
        --infotext "Thanks for exploring swiftDialog!" \
        --ontop \
        --moveable \
        --width 600 \
        --height 350 \
        --json 2>/dev/null

    return $?
}

# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------
main() {
    # Check dialog is installed
    if [[ ! -x "$DIALOG" ]]; then
        echo "ERROR: swiftDialog not found at ${DIALOG}" >&2
        echo "Install from https://github.com/swiftDialog/swiftDialog/releases" >&2
        exit 1
    fi

    # Check jq is available
    if ! command -v jq &>/dev/null; then
        echo "ERROR: jq not found. Install with: brew install jq" >&2
        exit 1
    fi

    while true; do
        # Welcome
        show_welcome || exit 0

        # Selector
        local selector_output
        selector_output=$(show_selector) || continue  # "Back" returns to welcome

        # Parse which demos were selected
        local -a demos_to_run=()
        local -A demo_map=(
            ["1. Basic Dialog Styles (alert - caution - warning - centered)"]="01_basic_styles.zsh"
            ["2. Title & Message Formatting"]="02_title_message.zsh"
            ["3. Icon Showcase (SF Symbols - overlays - animations)"]="03_icons.zsh"
            ["4. Buttons & Actions"]="04_buttons.zsh"
            ["5. Images - Banners & Backgrounds"]="05_images_banners.zsh"
            ["6. Progress Bar & Timer"]="06_progress_timer.zsh"
            ["7. Text Fields & Input Validation"]="07_text_fields.zsh"
            ["8. Dropdown Select Lists"]="08_dropdowns.zsh"
            ["9. Checkboxes & Switches"]="09_checkboxes.zsh"
            ["10. List Items & Status Updates"]="10_list_items.zsh"
            ["11. Window Options (size - position - appearance)"]="11_window_options.zsh"
            ["12. Command File Live Updates"]="12_command_file.zsh"
            ["13. Notification Demo"]="13_notifications.zsh"
            ["14. Mini & Presentation Mode"]="14_mini_presentation.zsh"
            ["15. Web Content & Video"]="15_web_video.zsh"
            ["16. JSON Input Demo"]="16_json_input.zsh"
            ["17. Full Screen & Blur"]="17_fullscreen_blur.zsh"
            ["18. View Order & Misc Features"]="18_misc_features.zsh"
            ["19. Inspect Mode (config presets - log monitor - item auto-complete)"]="19_inspect_mode.zsh"
        )

        # Parse JSON output to find checked items
        for key in "${(@k)demo_map}"; do
            local checked
            checked=$(echo "$selector_output" | jq -r --arg k "$key" '.[$k] // "false"')
            if [[ "$checked" == "true" ]]; then
                demos_to_run+=("${demo_map[$key]}")
            fi
        done

        if [[ ${#demos_to_run[@]} -eq 0 ]]; then
            "$DIALOG" \
                --title "No Demos Selected" \
                --message "Please select at least one demo to run." \
                --icon "SF=exclamationmark.triangle,colour=${ORANGE}" \
                --button1text "OK" \
                --mini
            continue
        fi

        # Sort demos by filename (numeric prefix ensures order)
        local -a sorted_demos
        sorted_demos=(${(o)demos_to_run})

        # Run selected demos
        for demo in "${sorted_demos[@]}"; do
            run_demo "$demo"
        done

        # Completion
        show_completion || exit 0
    done
}

main "$@"
