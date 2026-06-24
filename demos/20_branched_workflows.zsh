#!/bin/zsh
# Demo 20: Branched Workflows
# Demonstrates: workflow cards, branch.map, branch.default, branch.ifTrue,
#               branch.ifFalse, nextpage, finalpage, history-aware Previous

DIALOG="/usr/local/bin/dialog"
WORKFLOW_JSON=""

cleanup() {
    [[ -n "$WORKFLOW_JSON" ]] && rm -f "$WORKFLOW_JSON"
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
        --message "Demo 20 uses the new **branched workflow** properties added in **v3.1.0b4**.\n\nDetected version: \`${detected_version}\`\n\nInstall **swiftDialog v3.1.0b4 or newer** to run this demo." \
        --button1text "Close" \
        --width 700 \
        --json || true
    exit 0
fi

"$DIALOG" \
    --title "Branched Workflows" \
    --message "This demo adapts the nearest local patterns from \`08_dropdowns.zsh\`, \`09_checkboxes.zsh\`, and \`16_json_input.zsh\` into a native **workflow** array.\n\nUse **Previous** after taking a branch so you can see the new history-aware navigation unwind the exact path you took.\n\nThe workflow shows:\n- \`branch.map\` and \`branch.default\` from a dropdown\n- \`branch.ifTrue\` / \`branch.ifFalse\` from a checkbox\n- \`nextpage\` static jumps\n- \`finalpage: true\` early termination" \
    --icon "SF=arrow.triangle.branch,colour=#5856D6" \
    --button1text "Start Demo ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --json || exit 0

WORKFLOW_JSON=$(mktemp -t swiftdialog_branched_workflow_demo.XXXXXX) || exit 1

cat > "$WORKFLOW_JSON" <<'EOF'
{
  "title": "Workflow Cards v3.1.0b4",
  "message": "Choose a route to see native branching.",
  "icon": "SF=arrow.triangle.branch,colour=#5856D6",
  "moveable": true,
  "width": 720,
  "height": 520,
  "json": true,
  "button1text": "Finish Workflow",
  "nextbuttontext": "Next ->",
  "previousbuttontext": "Previous",
  "workflow": [
    {
      "id": 10,
      "title": "Choose a Deployment Track",
      "message": "This first card uses **branch.map** on a named dropdown. Choose a path, continue, then use **Previous** later to confirm history-aware backtracking.",
      "selectitems": [
        {
          "title": "Deployment Track",
          "name": "deployment_track",
          "values": [
            "IT Admin",
            "Shared Mac",
            "Remote Hire"
          ],
          "default": "IT Admin",
          "required": true
        }
      ],
      "branch": {
        "field": "deployment_track",
        "map": {
          "IT Admin": 20,
          "Shared Mac": 30,
          "Remote Hire": 40
        },
        "default": 20
      }
    },
    {
      "id": 20,
      "title": "IT Admin Branch",
      "message": "This card uses a named checkbox and **branch.ifTrue / branch.ifFalse**. Toggle it, continue, then use **Previous** to revisit the exact path you took.",
      "checkboxstyle": {
        "style": "switch",
        "size": "regular"
      },
      "checkbox": [
        {
          "label": "Include VPN bootstrap tasks",
          "name": "needs_vpn"
        }
      ],
      "branch": {
        "field": "needs_vpn",
        "ifTrue": 22,
        "ifFalse": 24
      }
    },
    {
      "id": 22,
      "title": "VPN Bootstrap",
      "message": "This branch collects one extra value, then uses **nextpage** to jump over unrelated cards.",
      "textfield": [
        {
          "title": "Preferred VPN Region",
          "name": "vpn_region",
          "value": "us-east"
        }
      ],
      "nextpage": 50
    },
    {
      "id": 24,
      "title": "No VPN Tasks",
      "message": "The checkbox routed here with **ifFalse**. Continue to exercise **nextpage** and jump directly to the shared summary.",
      "nextpage": 50
    },
    {
      "id": 30,
      "title": "Shared Mac Branch",
      "message": "This branch does not need an extra decision. Continue to use **nextpage** and join the shared summary card.",
      "nextpage": 50
    },
    {
      "id": 40,
      "title": "Remote Hire Branch",
      "message": "Choose how the remote setup will happen. One route ends early with **finalpage: true**.",
      "checkboxstyle": {
        "style": "switch",
        "size": "regular"
      },
      "checkbox": [
        {
          "label": "Ship a company laptop kit",
          "name": "ship_kit"
        }
      ],
      "branch": {
        "field": "ship_kit",
        "ifTrue": 42,
        "ifFalse": 43
      }
    },
    {
      "id": 42,
      "title": "Kit Shipping Complete",
      "message": "This card sets **finalpage: true**. Even though more cards still exist in the workflow array, Button 1 becomes **Finish** and the workflow ends here.",
      "finalpage": true
    },
    {
      "id": 43,
      "title": "Bring Your Own Device",
      "message": "This remote branch continues to the common summary with **nextpage** instead of terminating early.",
      "nextpage": 50
    },
    {
      "id": 50,
      "title": "Shared Summary",
      "message": "This summary card is reached from the IT Admin and Shared Mac paths. The final output includes accumulated values from every visited card.",
      "textfield": [
        {
          "title": "Summary Note",
          "name": "summary_note",
          "value": "Review Previous button behavior before finishing."
        }
      ]
    }
  ]
}
EOF

if ! jq empty "$WORKFLOW_JSON" 2>/dev/null; then
    "$DIALOG" \
        --style alert \
        --title "Workflow JSON Error" \
        --message "The generated workflow JSON is invalid.\n\nCheck \`${WORKFLOW_JSON}\` and run the demo again." \
        --button1text "Close" \
        --json || true
    exit 0
fi

result=$("$DIALOG" --jsonfile "$WORKFLOW_JSON" 2>/dev/null) || exit 0
pretty_result=$(echo "$result" | jq '.')

echo "Branched workflow output:"
echo "$pretty_result"

"$DIALOG" \
    --title "Branched Workflow Output" \
    --message "The workflow finished with the accumulated JSON below.\n\nUse this output to verify which path you took through the **workflow** array.\n\n\`\`\`json\n$pretty_result\n\`\`\`" \
    --icon "SF=doc.text.magnifyingglass,colour=#34C759" \
    --button1text "Done" \
    --moveable \
    --width 760 \
    --height 560 \
    --json || true
