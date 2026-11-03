#!/bin/zsh
# Demo 25: Control Dependencies
# Demonstrates: enabledif, visibleif, operators (= != > < >= <= && || !),
#               reset to default while unavailable, required and regex checks
#               skipped while a control is disabled or hidden

DIALOG="${DIALOG:-/usr/local/bin/dialog}"

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
        --message "Demo 25 uses the new **control dependencies** added in the **swiftDialog 3.2.0 preview (build 5001)**.\n\nDetected version: \`${detected_version}\`\n\nInstall **swiftDialog 3.2.0 build 5001 or newer** to run this demo." \
        --button1text "Close" \
        --width 700 \
        --json || true
    exit 0
fi

"$DIALOG" \
    --title "Control Dependencies" \
    --message "This demo frames dependent controls as a **remote access request** and a **hardware service request**.\n\n\`enabledif\` disables a control and \`visibleif\` hides it, based on other inputs on the same page.\n\nThe requests show:\n- A bare name: a checkbox is on, a field has text, a number is not 0\n- Operators \`=\` \`!=\` \`>\` \`<\` \`>=\` \`<=\` \`&&\` \`||\` \`!\`\n- A disabled or hidden control resetting to its default\n- \`required\` and \`regex\` checks skipped while a control is unavailable" \
    --icon "SF=point.3.connected.trianglepath.dotted,colour=#007AFF" \
    --button1text "Start Demo ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 500 \
    --json || exit 0

# --- Command-line conditions ---
# Text fields whose condition or detail contains "=" use the JSON form:
# the comma-separated --textfield parser treats any "word=" as a new key
result=$("$DIALOG" \
    --title "Remote Access Request" \
    --message "Things to try:\n\n- Tick **Request VPN access** to enable the username and reason fields (\`enabledif=needvpn\`).\n- Type a username, then untick the box: the field resets to its default, and the output shows that default.\n- **Business reason** is required only while it is enabled. With VPN access off, **Next** isn't blocked.\n- Choose **Phone** to show the phone number field (\`visibleif=channel=Phone\`)." \
    --icon "SF=network.badge.shield.half.filled,colour=#007AFF" \
    --checkbox "Request VPN access,name=needvpn" \
    --textfield "VPN username,name=vpnuser,enabledif=needvpn,detail=Usually your email address" \
    --textfield "Business reason,name=justification,required,enabledif=needvpn,detail=Required only while VPN access is on" \
    --selecttitle "Contact me by,name=channel" \
    --selectvalues "Email,Chat,Phone" \
    --selectdefault "Email" \
    --textfield '{"title":"Phone number","name":"phone","visibleif":"channel=Phone"}' \
    --button1text "Next ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 720 \
    --json 2>/dev/null) || exit 0

echo "Command-line conditions output:"
echo "$result" | jq '.'

# --- Comparisons and combinations ---
result=$("$DIALOG" \
    --title "Hardware Service Request" \
    --message "Pick an **Action** and watch the form change. Each control's subtext shows the condition that drives it.\n\nRequired fields are only checked while they are visible." \
    --icon "SF=wrench.adjustable.fill,colour=#FF9500" \
    --checkboxstyle "switch" \
    --selecttitle "Action,name=action,radio" \
    --selectvalues "Repair,Reassign,Retire" \
    --selectdefault "Repair" \
    --textfield '{"title":"Describe the fault","name":"fault","required":true,"visibleif":"action=Repair","detail":"Shown when action=Repair"}' \
    --textfield '{"title":"New owner email","name":"newowner","required":true,"regex":".+@.+","regexerror":"Enter a valid email address","visibleif":"action=Reassign","detail":"Shown when action=Reassign"}' \
    --checkbox "Erase this Mac,name=wipe,enabledif=action!=Repair,detail=Enabled when action!=Repair" \
    --checkbox "Keep the current user account,name=keepaccount,enabledif=!wipe,detail=Enabled when !wipe" \
    --checkbox "Ship a loaner Mac,name=loaner,visibleif=action=Repair || action=Retire,detail=Shown when action=Repair || action=Retire" \
    --stepper "Loaner needed for,name=loanerdays,min=1,max=30,value=5,unit=days,enabledif=loaner && action=Repair,detail=Enabled when loaner && action=Repair" \
    --vieworder "[Request],action,fault,newowner,[Data],wipe,keepaccount,[Loaner],loaner,loanerdays" \
    --button1text "Next ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 760 \
    --json 2>/dev/null) || exit 0

echo "Comparison conditions output:"
echo "$result" | jq '.'

# --- Numeric conditions and reset to default ---
result=$("$DIALOG" \
    --title "Service Priority" \
    --message "Numbers drive these conditions.\n\nRaise **Urgency** to 4, turn on **Escalate**, and type a callback number. Then lower urgency again: Escalate and the callback number both reset to their defaults." \
    --icon "SF=flag.fill,colour=#FF3B30" \
    --checkboxstyle "switch" \
    --slider "Urgency,name=urgency,min=1,max=5,step=1,value=2,minlabel=Low,maxlabel=Critical" \
    --stepper "People affected,name=affected,min=1,max=50,value=1,unit=people" \
    --checkbox "Escalate to on-call engineer,name=escalate,enabledif=urgency>=4 || affected>10,detail=Enabled when urgency>=4 || affected>10" \
    --textfield "Callback number,name=callback,required,prompt=+1 555 0100,visibleif=escalate,detail=Shown when escalate is on" \
    --checkbox "Batch with next on-site visit,name=batchvisit,enabledif=urgency<3 && affected<=5,detail=Enabled when urgency<3 && affected<=5" \
    --vieworder "[Impact],urgency,affected,[Response],escalate,callback,batchvisit" \
    --button1text "Done" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 660 \
    --json 2>/dev/null) || exit 0

echo "Numeric conditions output:"
echo "$result" | jq '.'
