#!/bin/zsh
# Internal: Homebrew Uninstall Confirmation (Jamf/root-run)

DIALOG="/usr/local/bin/dialog"
UNINSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh"
EXPECTED_SHA256="58e8ea576b9f9682c4740c0e4c286dfea8d15271f33d8504006132a634f25b01"
HOMEBREW_DIRECTORY="/opt/homebrew"
BREW=""
LOGGED_IN_USER=""
FONT_SIZE="14"
CMD_FILE=""
TEMP_SCRIPT=""
LOG_FILE=""
DIALOG_PID=""

cleanup() {
    if [[ -n "$CMD_FILE" ]]; then
        rm -f "$CMD_FILE"
    fi

    if [[ -n "$TEMP_SCRIPT" ]]; then
        rm -f "$TEMP_SCRIPT"
    fi
}
trap cleanup EXIT

# --- Guard: this workflow is intended for Jamf/root-run execution ---
if [[ "$EUID" -ne 0 ]]; then
    echo "Error: This script is intended to be launched as root so swiftDialog updates can be handed off to the logged-in GUI user." >&2
    exit 1
fi

send_command() {
    printf '%s\n' "$1" >> "$CMD_FILE"
}

set_step_status() {
    local title="$1"
    local item_status="$2"
    local status_text="$3"

    send_command "listitem: title: $title, status: $item_status, statustext: $status_text"
}

calculate_sha256() {
    local target_file="$1"
    local hash_output=""

    if command -v openssl &>/dev/null; then
        hash_output=$(openssl sha256 "$target_file" 2>>"$LOG_FILE") || return 1
        printf '%s\n' "${hash_output##*= }"
        return 0
    fi

    if command -v shasum &>/dev/null; then
        hash_output=$(shasum -a 256 "$target_file" 2>>"$LOG_FILE") || return 1
        printf '%s\n' "${hash_output%% *}"
        return 0
    fi

    return 1
}

detect_homebrew_binary() {
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
        printf '%s\n' "/opt/homebrew/bin/brew"
        return 0
    fi

    if [[ -x "/usr/local/bin/brew" ]]; then
        printf '%s\n' "/usr/local/bin/brew"
        return 0
    fi

    if command -v brew &>/dev/null; then
        command -v brew
        return 0
    fi

    return 1
}

current_logged_in_user() {
    LOGGED_IN_USER=$(/bin/echo "show State:/Users/ConsoleUser" | /usr/sbin/scutil | /usr/bin/awk '/Name :/ { print $3 }')

    if [[ -z "$LOGGED_IN_USER" || "$LOGGED_IN_USER" == "loginwindow" ]]; then
        LOGGED_IN_USER=""
        return 1
    fi

    if ! /usr/bin/id -u "$LOGGED_IN_USER" >/dev/null 2>&1; then
        LOGGED_IN_USER=""
        return 1
    fi

    return 0
}

prepare_file_for_dialog_user() {
    local target_file="$1"
    local current_owner=""

    if [[ -z "$target_file" || ! -e "$target_file" ]]; then
        return 1
    fi

    if ! current_logged_in_user; then
        return 1
    fi

    current_owner=$(/usr/bin/stat -f %Su "$target_file" 2>/dev/null)
    if [[ "$current_owner" != "$LOGGED_IN_USER" ]]; then
        if ! /usr/sbin/chown "$LOGGED_IN_USER" "$target_file" 2>/dev/null; then
            return 1
        fi
    fi

    if ! /bin/chmod 600 "$target_file" 2>/dev/null; then
        return 1
    fi

    return 0
}

prepare_log_file() {
    local target_file="$1"

    if [[ -z "$target_file" || ! -e "$target_file" ]]; then
        return 1
    fi

    if ! /bin/chmod 644 "$target_file" 2>/dev/null; then
        return 1
    fi

    return 0
}

reveal_log_file() {
    local logged_in_user_id=""

    if [[ -n "$LOG_FILE" && -e "$LOG_FILE" ]]; then
        /bin/rm -f "/var/tmp/dialog.log"

        if current_logged_in_user; then
            logged_in_user_id=$(/usr/bin/id -u "$LOGGED_IN_USER" 2>/dev/null)

            if [[ "$logged_in_user_id" =~ ^[0-9]+$ ]]; then
                /bin/launchctl asuser "$logged_in_user_id" /usr/bin/sudo -u "$LOGGED_IN_USER" /usr/bin/open -R "$LOG_FILE" >/dev/null 2>&1 || \
                /usr/bin/sudo -u "$LOGGED_IN_USER" /usr/bin/open -R "$LOG_FILE" >/dev/null 2>&1 || \
                true
                return 0
            fi
        fi

        /usr/bin/open -R "$LOG_FILE" >/dev/null 2>&1 || true
    fi
}

create_log_file() {
    local temp_log_file=""

    temp_log_file=$(mktemp "/var/tmp/brew-uninstall-log.XXXXXX") || return 1
    LOG_FILE="${temp_log_file}.log"

    if ! /bin/mv "$temp_log_file" "$LOG_FILE" 2>/dev/null; then
        /bin/rm -f "$temp_log_file"
        LOG_FILE=""
        return 1
    fi

    if ! prepare_log_file "$LOG_FILE"; then
        /bin/rm -f "$LOG_FILE"
        LOG_FILE=""
        return 1
    fi

    return 0
}

format_item_list() {
    local -a items=("$@")
    local output=""
    local item=""

    if [[ ${#items[@]} -eq 0 ]]; then
        printf '%s\n' "None detected."
        return 0
    fi

    for item in "${items[@]}"; do
        output+="- \`$item\`\n"
    done

    printf '%b' "$output"
}

finish_with_error() {
    local step_title="$1"
    local status_text="$2"
    local progress_text="$3"
    local dialog_message="$4"

    set_step_status "$step_title" "error" "$status_text"
    send_command "icon: SF=xmark.octagon.fill,colour=#FF3B30"
    send_command "progresstext: $progress_text"
    send_command "message: Homebrew removal failed. Review the log after closing this window."
    send_command "button1text: Close"
    send_command "button1: enable"

    wait $DIALOG_PID 2>/dev/null || true

    "$DIALOG" \
        --title "Homebrew Uninstall Failed" \
        --messagefont "size=${FONT_SIZE}" \
        --message "$dialog_message" \
        --icon "SF=xmark.octagon.fill,colour=#FF3B30" \
        --overlayicon "https://usw2.ics.services.jamfcloud.com/icon/hash_9edff3eb98482a1aaf17f8560488f7b500cc7dc64955b8a9027b3801cab0fd82" \
        --button1text "Close" \
        --moveable \
        --width 700 || true

    reveal_log_file
    exit 1
}

# --- Guard: swiftDialog must be installed ---
if ! command -v "$DIALOG" &>/dev/null; then
    echo "Error: swiftDialog not found at $DIALOG" >&2
    exit 1
fi

# --- Guard: Homebrew must be present ---
BREW=$(detect_homebrew_binary)
if [[ -z "$BREW" ]]; then
    "$DIALOG" \
        --title "Homebrew Not Installed" \
        --messagefont "size=${FONT_SIZE}" \
        --message "#### Homebrew is not installed on this Mac.\n\nNo changes were made.\n\nPlease click **OK**." \
        --icon "https://usw2.ics.services.jamfcloud.com/icon/hash_34e1725356c642ed6a3a5586eafc02af65fe193712a9f12294242dcf7d3a4353" \
        --button1text "OK" \
        --moveable \
        --width 500 || true
    exit 0
fi

# --- Inventory installed Homebrew content ---
FORMULAE_RAW=$("$BREW" list 2>/dev/null || true)
CASKS_RAW=$("$BREW" list --cask 2>/dev/null || true)
FORMULAE=()
CASKS=()

while IFS= read -r item; do
    if [[ -n "$item" ]]; then
        FORMULAE+=("$item")
    fi
done <<< "$FORMULAE_RAW"

while IFS= read -r item; do
    if [[ -n "$item" ]]; then
        CASKS+=("$item")
    fi
done <<< "$CASKS_RAW"

FORMULAE_LIST=$(format_item_list "${FORMULAE[@]}")
CASKS_LIST=$(format_item_list "${CASKS[@]}")
WARNING_MESSAGE=$(cat <<EOF
**This action is destructive and cannot be undone.**

Running the official Homebrew uninstaller will remove all installed formulae, casks, the Cellar, taps, caches, logs, and related Homebrew-managed files from this Mac.

After the official uninstall completes, this script will also recursively delete \`$HOMEBREW_DIRECTORY\` if it still exists.

**Installed Formulae**
${FORMULAE_LIST}

**Installed Casks**
${CASKS_LIST}

If you continue, the official uninstall script will be downloaded, its SHA256 hash will be verified, and removal will begin immediately.
EOF
)

# --- Explicit destructive-action acknowledgment ---
result=$("$DIALOG" \
    --title "Remove Homebrew from this Mac?" \
    --messagefont "size=${FONT_SIZE}" \
    --message "$WARNING_MESSAGE" \
    --icon "SF=exclamationmark.triangle, weight=bold, colour1=red" \
    --overlayicon "https://usw2.ics.services.jamfcloud.com/icon/hash_9edff3eb98482a1aaf17f8560488f7b500cc7dc64955b8a9027b3801cab0fd82" \
    --checkbox "I understand this will permanently remove Homebrew and the items listed above,name=acknowledged,enableButton1" \
    --button1text "Uninstall Homebrew" \
    --button1disabled \
    --button2text "Cancel" \
    --moveable \
    --width 860 \
    --height 760 \
    --json 2>/dev/null) || exit 0

# --- Progress and status dialog (root-run with GUI command-file handoff) ---
CMD_FILE=$(mktemp "/var/tmp/dialog.XXXXXX")
TEMP_SCRIPT=$(mktemp "/var/tmp/brew-uninstall.XXXXXX")

if ! prepare_file_for_dialog_user "$CMD_FILE"; then
    echo "Error: Unable to prepare the swiftDialog command file for the logged-in user." >&2
    exit 1
fi

if ! create_log_file; then
    echo "Error: Unable to prepare the uninstall log file." >&2
    exit 1
fi

"$DIALOG" \
    --title "Removing Homebrew" \
    --messagefont "size=${FONT_SIZE}" \
    --message "The official Homebrew uninstall workflow is running. After it completes, this script will also delete \`$HOMEBREW_DIRECTORY\` if it remains. Do not close Terminal, log out, or shut down this Mac until the process finishes." \
    --icon "SF=trash.slash.fill,colour=#FF6B35" \
    --overlayicon "https://usw2.ics.services.jamfcloud.com/icon/hash_9edff3eb98482a1aaf17f8560488f7b500cc7dc64955b8a9027b3801cab0fd82" \
    --progress 5 \
    --progresstext "Preparing..." \
    --listitem "Download official uninstall script,status=pending" \
    --listitem "Verify SHA256,status=pending" \
    --listitem "Run Homebrew uninstall,status=pending" \
    --listitem "Delete /opt/homebrew directory,status=pending" \
    --listitem "Finalize and report results,status=pending" \
    --button1text "Please wait..." \
    --button1disabled \
    --commandfile "$CMD_FILE" \
    --moveable \
    --width 760 \
    --height 420 &

DIALOG_PID=$!
sleep 1

# --- Step 1: Download official uninstall script ---
send_command "progress: 1"
send_command "progresstext: Step 1/5: Downloading official uninstall script..."
set_step_status "Download official uninstall script" "wait" "Downloading..."

if ! curl -fsSL "$UNINSTALL_URL" -o "$TEMP_SCRIPT" >>"$LOG_FILE" 2>&1; then
    finish_with_error \
        "Download official uninstall script" \
        "Download failed" \
        "Download failed" \
        "The official Homebrew uninstall script could not be downloaded from:\n\n\`$UNINSTALL_URL\`\n\nNo uninstall was performed. Review the log for details:\n\n\`$LOG_FILE\`"
fi

set_step_status "Download official uninstall script" "success" "Downloaded"

# --- Step 2: Verify SHA256 hash ---
send_command "progress: 2"
send_command "progresstext: Step 2/5: Verifying SHA256 hash..."
set_step_status "Verify SHA256" "wait" "Verifying..."

ACTUAL_SHA256=$(calculate_sha256 "$TEMP_SCRIPT")
if [[ -z "$ACTUAL_SHA256" ]]; then
    finish_with_error \
        "Verify SHA256" \
        "Hash check failed" \
        "Verification failed" \
        "The SHA256 hash could not be calculated for the downloaded uninstall script.\n\nNo uninstall was performed. Review the log for details:\n\n\`$LOG_FILE\`"
fi

if [[ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]]; then
    finish_with_error \
        "Verify SHA256" \
        "Hash mismatch" \
        "Verification failed" \
        "SHA256 verification failed. The downloaded script does not match the expected Homebrew uninstall script.\n\nExpected:\n\`$EXPECTED_SHA256\`\n\nActual:\n\`$ACTUAL_SHA256\`\n\nNo uninstall was performed."
fi

set_step_status "Verify SHA256" "success" "Verified"

# --- Step 3: Run Homebrew uninstall ---
send_command "progress: 3"
send_command "progresstext: Step 3/5: Running Homebrew uninstall..."
set_step_status "Run Homebrew uninstall" "wait" "Removing Homebrew..."

if ! NONINTERACTIVE=1 /bin/bash "$TEMP_SCRIPT" >>"$LOG_FILE" 2>&1; then
    finish_with_error \
        "Run Homebrew uninstall" \
        "Uninstall failed" \
        "Uninstall failed" \
        "The official Homebrew uninstall script exited with an error.\n\nHomebrew may be partially removed. Review the log for details:\n\n\`$LOG_FILE\`"
fi

set_step_status "Run Homebrew uninstall" "success" "Completed"

# --- Step 4: Remove /opt/homebrew if it remains ---
send_command "progress: 4"
send_command "progresstext: Step 4/5: Removing /opt/homebrew..."
set_step_status "Delete /opt/homebrew directory" "wait" "Removing..."

if [[ -e "$HOMEBREW_DIRECTORY" ]]; then
    if ! /bin/rm -rfv "$HOMEBREW_DIRECTORY" >>"$LOG_FILE" 2>&1; then
        finish_with_error \
            "Delete /opt/homebrew directory" \
            "Removal failed" \
            "Cleanup failed" \
            "The script could not recursively delete:\n\n\`$HOMEBREW_DIRECTORY\`\n\nHomebrew may be partially removed. Review the log for details:\n\n\`$LOG_FILE\`"
    fi
fi

if [[ -e "$HOMEBREW_DIRECTORY" ]]; then
    finish_with_error \
        "Delete /opt/homebrew directory" \
        "Still present" \
        "Cleanup incomplete" \
        "The script finished the official uninstall, but \`$HOMEBREW_DIRECTORY\` still exists.\n\nHomebrew may be partially removed. Review the log for details:\n\n\`$LOG_FILE\`"
fi

set_step_status "Delete /opt/homebrew directory" "success" "Removed"

# --- Step 5: Finalize and report results ---
send_command "progress: 5"
send_command "progresstext: Step 5/5: Finalizing..."
set_step_status "Finalize and report results" "wait" "Preparing summary..."
sleep 1
set_step_status "Finalize and report results" "success" "Done"
send_command "icon: SF=checkmark.circle.fill,weight=bold,colour1=#63CA56,colour2=#2D7D2B"
send_command "progresstext: Complete"
send_command "message: Homebrew removal completed, including deletion of /opt/homebrew. Review the log path in the confirmation dialog if you need a record of the run."
send_command "button1text: Done"
send_command "button1: enable"

wait $DIALOG_PID 2>/dev/null || true

"$DIALOG" \
    --title "Homebrew Removed" \
    --messagefont "size=${FONT_SIZE}" \
    --message "Homebrew uninstall completed, and \`$HOMEBREW_DIRECTORY\` was removed.\n\nA log was written to:\n\n\`$LOG_FILE\`" \
    --icon "SF=checkmark.circle.fill,weight=bold,colour1=#63CA56,colour2=#2D7D2B" \
    --overlayicon "https://usw2.ics.services.jamfcloud.com/icon/hash_9edff3eb98482a1aaf17f8560488f7b500cc7dc64955b8a9027b3801cab0fd82" \
    --button1text "Done" \
    --moveable \
    --width 560 || true

reveal_log_file

# Notes:
# - Tier 1 acknowledgment pattern adapted from the checkbox-gated button guidance in SKILL.md and authoring-patterns.md.
# - Tier 3 progress and list-item status updates use the Jamf/root-run command-file handoff pattern described in the skill references, alongside demos 06_progress_timer.zsh and 10_list_items.zsh.
# - Assumes package counts are moderate enough for a fixed-size warning dialog and keeps uninstall output in a temp log rather than streaming it live.
# - The downloaded Homebrew uninstaller is invoked with /bin/bash because the official script requires Bash.
