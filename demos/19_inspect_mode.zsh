#!/bin/zsh
# Demo 19: Inspect Mode v3.1.0b4
# Demonstrates: --inspect-mode, --inspect-config, --published-sessions-dir,
#               stepType "cadence", cadenceStyle "carousel", cadence IPC,
#               preset 3 redesign, persistent footer logo, forced appearance,
#               per-item descriptions, cacheExtensions with aria2,
#               resultFile/readinessFile/eventFile publishing

DIALOG="/usr/local/bin/dialog"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SAMPLE_JSON="${SCRIPT_DIR}/19_inspect_mode_managedpref_sample.json"
INSPECT_ROOT=""
PUBLISHED_SESSIONS_DIR=""
CADENCE_CONFIG=""
CADENCE_TRIGGER_FILE=""
CADENCE_RESULT_FILE=""
CADENCE_READINESS_FILE=""
CADENCE_EVENT_FILE=""
CADENCE_MARKER_FILE=""
PRESET3_CONFIG=""
PRESET3_TRIGGER_FILE=""
PRESET3_RESULT_FILE=""
PRESET3_READINESS_FILE=""
PRESET3_EVENT_FILE=""
PRESET3_CACHE_ROOT=""
PRESET3_ARIA2_FILE=""
PRESET3_BROWSER_APP=""
PRESET3_PROFILE_MARKER=""
PRESET3_REPORT_MARKER=""

# Preset 3 footer branding expects a real on-disk image file.
BRAND_ICON="/System/Applications/Utilities/Console.app/Contents/Resources/AppIcon.icns"
LIGHT_LOGO="$BRAND_ICON"
DARK_LOGO="$BRAND_ICON"
PHASE_A_SESSION_FILE=""
PHASE_A_SESSION_SUMMARY=""

set_demo_paths() {
    INSPECT_ROOT=$(mktemp -d "/tmp/swiftdialog_inspect_mode_v310b4_demo.XXXXXX") || exit 1
    PUBLISHED_SESSIONS_DIR=$(mktemp -d "/private/tmp/swiftdialog_demo_sessions.XXXXXX") || exit 1

    CADENCE_CONFIG="${INSPECT_ROOT}/cadence_config.json"
    CADENCE_TRIGGER_FILE="${INSPECT_ROOT}/cadence.trigger"
    CADENCE_RESULT_FILE="${INSPECT_ROOT}/cadence.result.json"
    CADENCE_READINESS_FILE="${INSPECT_ROOT}/cadence.readiness.json"
    CADENCE_EVENT_FILE="${INSPECT_ROOT}/cadence.events.jsonl"
    CADENCE_MARKER_FILE="${INSPECT_ROOT}/cadence.marker"

    PRESET3_CONFIG="${INSPECT_ROOT}/preset3_config.json"
    PRESET3_TRIGGER_FILE="${INSPECT_ROOT}/preset3.trigger"
    PRESET3_RESULT_FILE="${INSPECT_ROOT}/preset3.result.json"
    PRESET3_READINESS_FILE="${INSPECT_ROOT}/preset3.readiness.json"
    PRESET3_EVENT_FILE="${INSPECT_ROOT}/preset3.events.jsonl"
    PRESET3_CACHE_ROOT="${INSPECT_ROOT}/cache"
    PRESET3_ARIA2_FILE="${PRESET3_CACHE_ROOT}/browserkit.pkg.aria2"
    PRESET3_BROWSER_APP="${INSPECT_ROOT}/BrowserKit.app"
    PRESET3_PROFILE_MARKER="${INSPECT_ROOT}/profiledrop.mobileconfig"
    PRESET3_REPORT_MARKER="${INSPECT_ROOT}/reportsync.done"
}

set_demo_paths

cleanup() {
    [[ -n "$INSPECT_ROOT" ]] && rm -rf "$INSPECT_ROOT"
    [[ -n "$PUBLISHED_SESSIONS_DIR" ]] && rm -rf "$PUBLISHED_SESSIONS_DIR"
}
trap cleanup EXIT

dialog_version() {
    "$DIALOG" --version 2>/dev/null || echo ""
}

dialog_build_number() {
    local version_string
    version_string=$(dialog_version)

    if [[ "$version_string" =~ ([0-9]{4,})$ ]]; then
        echo "${match[1]}"
    else
        echo "0"
    fi
}

require_dialog_beta() {
    local version_string build_number
    version_string=$(dialog_version)
    build_number=$(dialog_build_number)

    [[ -n "$version_string" ]] || return 1

    if [[ "$version_string" == 3.1.0* ]]; then
        [[ "$build_number" -eq 0 || "$build_number" -ge 4990 ]]
        return $?
    fi

    return 1
}

wait_for_path() {
    local target_path="$1"
    local attempts="$2"
    local count=0

    while [[ $count -lt $attempts ]]; do
        [[ -e "$target_path" ]] && return 0
        sleep 0.2
        count=$((count + 1))
    done

    return 1
}

capture_session_file() {
    local -a session_files

    setopt local_options null_glob
    session_files=("${PUBLISHED_SESSIONS_DIR}"/*.json(N))
    PHASE_A_SESSION_FILE="${session_files[1]:-}"

    if [[ -n "$PHASE_A_SESSION_FILE" && -f "$PHASE_A_SESSION_FILE" ]]; then
        PHASE_A_SESSION_SUMMARY=$(jq -r '"resultFile: \(.resultFile)\nreadinessFile: \(.readinessFile)\neventFile: \(.eventFile)' "$PHASE_A_SESSION_FILE" 2>/dev/null)
    else
        PHASE_A_SESSION_SUMMARY="Session file not found in ${PUBLISHED_SESSIONS_DIR}"
    fi
}

validate_generated_json() {
    local json_path="$1"
    local friendly_name="$2"

    if ! jq empty "$json_path" 2>/dev/null; then
        "$DIALOG" \
            --style alert \
            --title "${friendly_name} Error" \
            --message "The generated JSON for **${friendly_name}** is invalid.\n\nCheck \`${json_path}\` and run the demo again." \
            --button1text "Close" \
            --json || true
        exit 0
    fi
}

prepare_demo_state() {
    rm -rf "$INSPECT_ROOT" "$PUBLISHED_SESSIONS_DIR"
    set_demo_paths
    mkdir -p "$PRESET3_CACHE_ROOT"

    rm -f \
        "$CADENCE_CONFIG" \
        "$CADENCE_TRIGGER_FILE" \
        "$CADENCE_RESULT_FILE" \
        "$CADENCE_READINESS_FILE" \
        "$CADENCE_EVENT_FILE" \
        "$CADENCE_MARKER_FILE" \
        "$PRESET3_CONFIG" \
        "$PRESET3_TRIGGER_FILE" \
        "$PRESET3_RESULT_FILE" \
        "$PRESET3_READINESS_FILE" \
        "$PRESET3_EVENT_FILE" \
        "$PRESET3_ARIA2_FILE" \
        "$PRESET3_PROFILE_MARKER" \
        "$PRESET3_REPORT_MARKER"

    rm -rf "$PRESET3_BROWSER_APP"
    touch "$CADENCE_TRIGGER_FILE" "$PRESET3_TRIGGER_FILE"
}

write_cadence_config() {
    cat > "$CADENCE_CONFIG" <<EOF
{
    "preset": "5",
    "title": "Inspect Mode v3.1.0b4",
    "highlightColor": "#FF9500",
    "accentBorderColor": "#FF9500",
    "showAccentBorder": true,
    "appearance": "dark",
    "footerBackgroundColor": "#111827",
    "footerTextColor": "#F9FAFB",
    "footerText": "swiftDialog v3.1.0b4 inspect demo",
    "logoConfig": {
        "imagePath": "${LIGHT_LOGO}",
        "imagePathDark": "${DARK_LOGO}",
        "position": "topright",
        "maxHeight": 26,
        "opacity": 0.95,
        "showOnIntro": true,
        "showOnMain": true,
        "showOnSummary": true
    },
    "resultFile": "${CADENCE_RESULT_FILE}",
    "readinessFile": "${CADENCE_READINESS_FILE}",
    "eventFile": "${CADENCE_EVENT_FILE}",
    "triggerFile": "${CADENCE_TRIGGER_FILE}",
    "introSteps": [
        {
            "id": "cadence-demo",
            "stepType": "cadence",
            "title": "Cadence Carousel",
            "subtitle": "New gated cadence engine with carousel style and hybrid IPC.",
            "continueButtonText": "Watching...",
            "cadenceStyle": "carousel",
            "cadenceInterval": 0.5,
            "cadenceMinDwell": 0.8,
            "autoAdvance": true,
            "cadence": [
                {
                    "id": "calculator",
                    "message": "Reading a real app attribute (app).",
                    "sfSymbol": "app.badge.fill",
                    "attribute": {
                        "type": "app",
                        "bundleId": "com.apple.calculator"
                    },
                    "timeout": 12
                },
                {
                    "id": "marker",
                    "message": "Waiting for deterministic marker file (file).",
                    "sfSymbol": "doc.badge.gearshape.fill",
                    "attribute": {
                        "type": "file",
                        "path": "${CADENCE_MARKER_FILE}"
                    },
                    "timeout": 20
                },
                {
                    "id": "manual-review",
                    "message": "Manual review entry skipped with cadence:advance.",
                    "sfSymbol": "hand.raised.fill",
                    "attribute": {
                        "source": "ipc"
                    },
                    "timeout": 20
                },
                {
                    "id": "compliance",
                    "message": "External compliance signal uses cadence:satisfy.",
                    "sfSymbol": "checkmark.seal.fill",
                    "attribute": {
                        "source": "ipc"
                    },
                    "timeout": 20
                }
            ]
        },
        {
            "id": "cadence-summary",
            "stepType": "intro",
            "title": "Cadence Phase Complete",
            "subtitle": "This preset 5 flow moved without a callback script.",
            "buttonText": "Close",
            "content": [
                {
                    "type": "text",
                    "content": "This step used stepType: cadence plus cadenceStyle: carousel."
                },
                {
                    "type": "bullets",
                    "items": [
                        "cadence:goto:1 jumped directly to the file-backed entry",
                        "cadence:advance skipped the manual review entry",
                        "cadence:satisfy:compliance completed the last IPC-backed entry"
                    ]
                }
            ]
        }
    ]
}
EOF
}

write_preset3_config() {
    cat > "$PRESET3_CONFIG" <<EOF
{
    "preset": "3",
    "title": "Inspect Compact Redesign",
    "subtitle": "Preset 3 redesign + footer logo + aria2 cacheExtensions",
    "message": "Compact preset 3 can now carry richer descriptions, footer branding, and forced appearance.",
    "highlightColor": "#007AFF",
    "accentBorderColor": "#FF9500",
    "showAccentBorder": true,
    "appearance": "light",
    "footerBackgroundColor": "#FFF7ED",
    "footerTextColor": "#9A3412",
    "footerText": "swiftDialog demo suite | preset 3 footer branding",
    "copyrightText": "swiftDialog v3.1.0b4 compact branding sample",
    "supportText": "Self-contained inspect config with published session files",
    "logoConfig": {
        "imagePath": "${LIGHT_LOGO}",
        "imagePathDark": "${DARK_LOGO}",
        "position": "bottomleft",
        "maxHeight": 26,
        "opacity": 0.95,
        "showOnIntro": true,
        "showOnMain": true,
        "showOnSummary": true
    },
    "button1text": "Close",
    "button1disabled": true,
    "autoEnableButton": true,
    "autoEnableButtonText": "Close",
    "cachePaths": [
        "${PRESET3_CACHE_ROOT}"
    ],
    "cacheExtensions": [
        "download",
        "pkg",
        "dmg",
        "aria2"
    ],
    "resultFile": "${PRESET3_RESULT_FILE}",
    "readinessFile": "${PRESET3_READINESS_FILE}",
    "eventFile": "${PRESET3_EVENT_FILE}",
    "triggerFile": "${PRESET3_TRIGGER_FILE}",
    "sideMessage": [
        "Preset 3 keeps the footer logo visible during the whole run.",
        "This phase forces light appearance regardless of the current macOS setting.",
        "The browserkit.pkg.aria2 partial file keeps BrowserKit in a downloading state until the payload lands."
    ],
    "sideInterval": 4,
    "items": [
        {
            "id": "browserkit",
            "displayName": "BrowserKit",
            "subtitle": "Per-item description plus .aria2 partial-file detection in cachePaths.",
            "guiIndex": 0,
            "paths": [
                "${PRESET3_BROWSER_APP}"
            ],
            "icon": "SF=safari.fill"
        },
        {
            "id": "profiledrop",
            "displayName": "ProfileDrop",
            "subtitle": "Static marker file completes this row after the package lands.",
            "guiIndex": 1,
            "paths": [
                "${PRESET3_PROFILE_MARKER}"
            ],
            "icon": "SF=gear.badge.checkmark"
        },
        {
            "id": "reportsync",
            "displayName": "ReportSync",
            "subtitle": "Final marker highlights the redesigned compact spacing and footer bar.",
            "guiIndex": 2,
            "paths": [
                "${PRESET3_REPORT_MARKER}"
            ],
            "icon": "SF=chart.bar.doc.horizontal.fill"
        }
    ]
}
EOF
}

run_phase_a() {
    write_cadence_config
    validate_generated_json "$CADENCE_CONFIG" "Cadence Config"

    DIALOG_INSPECT_CONFIG="$CADENCE_CONFIG" "$DIALOG" \
        --inspect-mode \
        --inspect-config "$CADENCE_CONFIG" \
        --published-sessions-dir "$PUBLISHED_SESSIONS_DIR" &
    DIALOG_PID=$!

    wait_for_path "$CADENCE_READINESS_FILE" 100 || true
    capture_session_file

    sleep 1
    printf '%s\n' "cadence:goto:1" >> "$CADENCE_TRIGGER_FILE"
    sleep 1
    touch "$CADENCE_MARKER_FILE"
    sleep 1
    printf '%s\n' "cadence:advance" >> "$CADENCE_TRIGGER_FILE"
    sleep 1
    printf '%s\n' "cadence:satisfy:compliance" >> "$CADENCE_TRIGGER_FILE"

    wait $DIALOG_PID 2>/dev/null || true
}

run_phase_b() {
    touch "$PRESET3_ARIA2_FILE"
    write_preset3_config
    validate_generated_json "$PRESET3_CONFIG" "Preset 3 Config"

    DIALOG_INSPECT_CONFIG="$PRESET3_CONFIG" "$DIALOG" \
        --inspect-mode \
        --inspect-config "$PRESET3_CONFIG" \
        --published-sessions-dir "$PUBLISHED_SESSIONS_DIR" &
    DIALOG_PID=$!

    wait_for_path "$PRESET3_READINESS_FILE" 100 || true

    sleep 2
    mkdir -p "$PRESET3_BROWSER_APP"
    rm -f "$PRESET3_ARIA2_FILE"
    sleep 1
    touch "$PRESET3_PROFILE_MARKER"
    sleep 1
    touch "$PRESET3_REPORT_MARKER"

    wait $DIALOG_PID 2>/dev/null || true
}

if [[ ! -x "$DIALOG" ]]; then
    echo "ERROR: swiftDialog not found at ${DIALOG}" >&2
    exit 1
fi

if ! require_dialog_beta; then
    detected_version=$(dialog_version)
    [[ -n "$detected_version" ]] || detected_version="unknown"

    "$DIALOG" \
        --style alert \
        --title "swiftDialog v3.1.0b4 Required" \
        --message "Demo 19 now uses **v3.1.0b4** features such as \`stepType: \"cadence\"\`, \`cadenceStyle: \"carousel\"\`, and \`--published-sessions-dir\`.\n\nDetected version: \`${detected_version}\`\n\nInstall **swiftDialog v3.1.0b4 or newer** to run this demo." \
        --button1text "Close" \
        --width 700 \
        --json || true
    exit 0
fi

prepare_demo_state

"$DIALOG" \
    --title "Inspect Mode v3.1.0b4" \
    --message "This refresh keeps Inspect Mode focused on **two new v3.1.0b4 themes**.\n\n**Phase A** adapts the closest repo patterns from \`19_inspect_mode.zsh\`, \`06_progress_timer.zsh\`, and \`12_command_file.zsh\` to show a preset 5 cadence carousel with hybrid IPC.\n\n**Phase B** switches to redesigned preset 3 with footer branding, forced appearance, per-item descriptions, and \`cacheExtensions\` support for \`.aria2\` partial files.\n\nManaged preference coverage is included as a committed sample JSON instead of writing into \`/Library/Managed Preferences\` live." \
    --icon "SF=list.bullet.clipboard,colour=#007AFF" \
    --button1text "Start Demo ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --json || exit 0

run_phase_a
run_phase_b

"$DIALOG" \
    --title "Inspect Mode Complete" \
    --message "Phase A published session metadata under:\n\n\`${PUBLISHED_SESSIONS_DIR}\`\n\nSession summary:\n\n\`${PHASE_A_SESSION_SUMMARY}\`\n\nCompanion sample JSON:\n\n\`${SAMPLE_JSON}\`\n\nThat sample shows \`managedpref\`, \`cadenceRef\`, \`ManagedValueRef\`, device scope, user scope, and forced appearance without trying to modify live managed preferences." \
    --icon "SF=checkmark.seal.fill,colour=#34C759" \
    --button1text "Done" \
    --moveable \
    --width 760 \
    --json || true
