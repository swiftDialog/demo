#!/bin/zsh
# Demo 21: Navigation Sidebar
# Demonstrates: "cardstyle": "navigation", section, sidebartitle, sidebaricon,
#               sidebarwidth, required-field page warnings, blocked Done with a
#               summary sheet, {field} substitution, --resizable

DIALOG="${DIALOG:-/usr/local/bin/dialog}"
ONBOARDING_JSON=""

cleanup() {
    [[ -n "$ONBOARDING_JSON" ]] && rm -f "$ONBOARDING_JSON"
}
trap cleanup EXIT

# Dialog always runs as the console user, even when this script runs as root,
# so temp files live in /var/tmp and are handed to that user
dialog_user() {
    stat -f %Su /dev/console
}

hand_to_dialog_user() {
    [[ "$EUID" -eq 0 ]] || return 0
    chown -R "$(dialog_user)" "$@"
}

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

require_dialog_preview() {
    local version_string build_number
    version_string=$(dialog_version)
    build_number=$(dialog_build_number)

    [[ -n "$version_string" ]] || return 1

    if [[ "$version_string" == 3.2.0* ]]; then
        [[ "$build_number" -eq 0 || "$build_number" -ge 5001 ]]
        return $?
    fi

    return 1
}

if [[ ! -x "$DIALOG" ]]; then
    echo "ERROR: swiftDialog not found at ${DIALOG}" >&2
    exit 1
fi

if ! require_dialog_preview; then
    detected_version=$(dialog_version)
    [[ -n "$detected_version" ]] || detected_version="unknown"

    "$DIALOG" \
        --style alert \
        --title "swiftDialog 3.2.0 Preview Required" \
        --message "Demo 21 uses the new **navigation card style** added in the **swiftDialog 3.2.0 preview (build 5001)**.\n\nDetected version: \`${detected_version}\`\n\nInstall **swiftDialog 3.2.0 build 5001 or newer** to run this demo." \
        --button1text "Close" \
        --width 700 \
        --json || true
    exit 0
fi

"$DIALOG" \
    --title "Navigation Sidebar" \
    --message "This demo frames \`\"cardstyle\": \"navigation\"\` as a **new-hire onboarding** window. Each card becomes a page in a sidebar, and pages can be completed in any order.\n\nThe onboarding window shows:\n- \`section\` headers that group pages in the sidebar\n- \`sidebartitle\` / \`sidebaricon\` overriding a page's own title and icon\n- \`sidebarwidth\` setting the sidebar width in points\n- Required fields: leave a page unfinished and its row gets a warning\n- **Done** blocked while any page is incomplete, with a summary sheet\n- \`{field}\` substitution from values entered on other pages\n- \`--resizable\` window (minimum 600 x 400)" \
    --icon "SF=sidebar.left,colour=#007AFF" \
    --button1text "Start Demo ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 660 \
    --json || exit 0

ONBOARDING_JSON=$(mktemp /var/tmp/swiftdialog_navigation_sidebar_demo.XXXXXX) || exit 1
hand_to_dialog_user "$ONBOARDING_JSON" || exit 1

cat > "$ONBOARDING_JSON" <<'EOF'
{
  "cardstyle": "navigation",
  "title": "Onboarding",
  "icon": "SF=person.badge.plus,colour=#007AFF",
  "sidebarwidth": 220,
  "width": 900,
  "height": 600,
  "resizable": true,
  "button1text": "Done",
  "button2text": "Cancel",
  "checkboxstyle": {
    "style": "switch",
    "size": "regular"
  },
  "cards": [
    {
      "cardId": "welcome",
      "section": "Getting Started",
      "title": "Welcome",
      "icon": "SF=hand.wave.fill,colour=#FF9500",
      "message": "Welcome to your new Mac. Work through the pages in the sidebar, in any order.\n\n- Pages with required fields start out **incomplete**.\n- Leave a page without finishing it and its sidebar row and section header get a warning.\n- **Done** stays blocked until every page is complete. Try it now: the first incomplete page opens with a summary sheet.\n- Drag a window edge: this window is resizable."
    },
    {
      "cardId": "account",
      "section": "Getting Started",
      "title": "Your Account",
      "sidebartitle": "Account",
      "icon": "SF=person.crop.circle.fill,colour=#007AFF",
      "message": "Tell us who you are. Both fields are required, and the email must look like an address.",
      "textfield": [
        {
          "title": "Full Name",
          "name": "fullname",
          "required": true,
          "detail": "As it should appear in the company directory"
        },
        {
          "title": "Work Email",
          "name": "email",
          "required": true,
          "prompt": "first.last@example.com",
          "regex": ".+@.+",
          "regexerror": "Enter a valid email address"
        }
      ]
    },
    {
      "cardId": "team",
      "section": "Getting Started",
      "title": "Your Team",
      "sidebartitle": "Team",
      "icon": "SF=person.3.fill,colour=#5856D6",
      "message": "Hi **{fullname}**, which team are you joining?\n\nThe name above is filled in from the **Account** page by field substitution.",
      "selectitems": [
        {
          "title": "Department",
          "name": "department",
          "values": [
            "Engineering",
            "Finance",
            "Marketing",
            "Sales",
            "Support"
          ],
          "required": true,
          "detail": "Sets your default apps and shared drives"
        }
      ],
      "textfield": [
        {
          "title": "Manager",
          "name": "manager",
          "prompt": "Optional",
          "detail": "Who you report to"
        }
      ]
    },
    {
      "cardId": "apps",
      "section": "Your Mac",
      "title": "Optional Apps",
      "sidebartitle": "Apps",
      "icon": "SF=square.grid.2x2.fill,colour=#AF52DE",
      "message": "Turn on any extra apps for your **{department}** setup. Nothing here is required, so this page never shows a warning.",
      "checkbox": [
        {
          "label": "Slack",
          "name": "app_slack",
          "checked": true,
          "detail": "Company chat"
        },
        {
          "label": "Zoom",
          "name": "app_zoom",
          "checked": true,
          "detail": "Video meetings"
        },
        {
          "label": "Microsoft Office",
          "name": "app_office",
          "checked": false,
          "detail": "Word, Excel, PowerPoint and Outlook"
        }
      ]
    },
    {
      "cardId": "security",
      "section": "Your Mac",
      "title": "Security Baseline",
      "sidebartitle": "Security",
      "icon": "SF=lock.shield.fill,colour=#34C759",
      "sidebaricon": "SF=lock.fill",
      "message": "FileVault, the firewall and automatic updates are turned on for you.\n\nThis page sets **sidebaricon**, so the sidebar shows a plain lock instead of the page icon."
    },
    {
      "cardId": "policy",
      "section": "Policies",
      "title": "Acceptable Use",
      "sidebartitle": "Policy",
      "icon": "SF=doc.text.fill,colour=#FF9500",
      "message": "Enter your initials to confirm you have read the **Acceptable Use Policy** and agree to follow it.",
      "textfield": [
        {
          "title": "Initials",
          "name": "initials",
          "required": true,
          "prompt": "JA",
          "regex": "^[A-Za-z]{2,4}$",
          "regexerror": "Enter 2 to 4 letters"
        }
      ]
    },
    {
      "cardId": "summary",
      "section": "Finish",
      "title": "Summary",
      "icon": "SF=checkmark.seal.fill,colour=#34C759",
      "message": "Check your details, then press **Done**.\n\n- **Name:** {fullname}\n- **Email:** {email}\n- **Team:** {department}\n- **Manager:** {manager}\n- **Initials:** {initials}\n\nEach value is substituted from the page where it was entered. A blank value means that page hasn't been filled in yet."
    }
  ]
}
EOF

if ! jq empty "$ONBOARDING_JSON" 2>/dev/null; then
    "$DIALOG" \
        --style alert \
        --title "Onboarding JSON Error" \
        --message "The generated onboarding JSON is invalid.\n\nCheck \`${ONBOARDING_JSON}\` and run the demo again." \
        --button1text "Close" \
        --json || true
    exit 0
fi

result=$("$DIALOG" \
    --jsonfile "$ONBOARDING_JSON" \
    --json 2>/dev/null) || exit 0

echo "Navigation sidebar output:"
echo "$result" | jq '.'
