#!/bin/zsh
# Demo 16: JSON Input Demo
# Demonstrates: --jsonfile, --jsonstring, JSON format for complex inputs
#               including checkbox arrays, image arrays, textfield arrays,
#               selectitems arrays

DIALOG="${DIALOG:-/usr/local/bin/dialog}"
JSON_FILE="/tmp/swiftdialog_demo.json"

# --- JSON string input ---
result=$("$DIALOG" --jsonstring '{
    "title" : "JSON String Input",
    "titlefont" : "colour=#5856D6,weight=bold,size=26",
    "message" : "This entire dialog was configured using `--jsonstring` with a JSON object.\n\nJSON input supports all the same options as command line arguments, using the long-form names as keys.",
    "icon" : "SF=doc.text,colour=#5856D6",
    "button1text" : "Next →",
    "button2text" : "Skip",
    "moveable" : true,
    "width" : "700",
    "json" : true
}' 2>/dev/null) || exit 0

# --- JSON file with checkboxes array ---
cat > "$JSON_FILE" <<'JSONEOF'
{
    "title" : "JSON File — Checkboxes",
    "message" : "Checkboxes can be defined as a JSON array with **label**, **checked**, and **disabled** properties.\n\nThis was loaded from a `.json` file via `--jsonfile`.",
    "icon" : "SF=checkmark.square,colour=#34C759",
    "checkbox" : [
        {"label" : "Pre-checked option", "checked" : true},
        {"label" : "Disabled option", "disabled" : true},
        {"label" : "Checked and disabled", "checked" : true, "disabled" : true},
        {"label" : "Normal option"}
    ],
    "button1text" : "Next →",
    "button2text" : "Skip",
    "moveable" : true,
    "width" : "700",
    "json" : true
}
JSONEOF

result=$("$DIALOG" --jsonfile "$JSON_FILE" 2>/dev/null) || exit 0
echo "Checkbox JSON output:"
echo "$result" | jq '.'

# --- JSON with selectitems ---
cat > "$JSON_FILE" <<'JSONEOF'
{
    "title" : "JSON File — Select Items",
    "message" : "Select items (dropdowns) can be fully configured in JSON with **title**, **values**, **default**, and **required** properties.",
    "icon" : "SF=list.bullet,colour=#FF9500",
    "selectitems" : [
        {
            "title" : "Deployment Ring",
            "values" : ["Canary", "Early Adopters", "General Availability"],
            "default" : "General Availability"
        },
        {
            "title" : "Priority",
            "values" : ["Critical", "High", "Medium", "Low"],
            "default" : "Medium",
            "required" : true
        }
    ],
    "button1text" : "Next →",
    "button2text" : "Skip",
    "moveable" : true,
    "width" : "700",
    "json" : true
}
JSONEOF

result=$("$DIALOG" --jsonfile "$JSON_FILE" 2>/dev/null) || exit 0
echo "Select items JSON output:"
echo "$result" | jq '.'

# --- JSON with textfields array ---
cat > "$JSON_FILE" <<'JSONEOF'
{
    "title" : "JSON File — Text Fields",
    "message" : "Text fields can be specified as a simple array of strings in JSON.",
    "icon" : "SF=text.cursor,colour=#AF52DE",
    "textfield" : [
        "Computer Name",
        "Asset Tag",
        "Location"
    ],
    "button1text" : "Next →",
    "button2text" : "Skip",
    "moveable" : true,
    "width" : "700",
    "json" : true
}
JSONEOF

result=$("$DIALOG" --jsonfile "$JSON_FILE" 2>/dev/null) || exit 0
echo "Textfield JSON output:"
echo "$result" | jq '.'

# --- JSON with images array ---
cat > "$JSON_FILE" <<'JSONEOF'
{
    "title" : "JSON File — Image Carousel",
    "message" : "",
    "icon" : "SF=photo.stack,colour=#00C7BE",
    "image" : [
        {
            "imagename" : "/System/Library/CoreServices/Finder.app",
            "caption" : "Finder"
        },
        {
            "imagename" : "/Applications/Safari.app",
            "caption" : "Safari"
        },
        {
            "imagename" : "/System/Applications/App Store.app",
            "caption" : "App Store"
        }
    ],
    "button1text" : "Next →",
    "button2text" : "Skip",
    "moveable" : true,
    "width" : "700",
    "height" : "500",
    "json" : true
}
JSONEOF

"$DIALOG" --jsonfile "$JSON_FILE" || exit 0

# --- Complex combined JSON ---
cat > "$JSON_FILE" <<'JSONEOF'
{
    "title" : "Complete JSON Example",
    "titlefont" : "colour=#007AFF,weight=bold,size=24",
    "message" : "This dialog combines **multiple input types** in a single JSON configuration.\n\nFill out all fields and click Submit.",
    "icon" : "SF=doc.badge.gearshape,colour=#007AFF",
    "textfield" : [
        "Hostname",
        "Serial Number"
    ],
    "selectitems" : [
        {
            "title" : "Department",
            "values" : ["Engineering", "Design", "Marketing", "Sales", "HR"],
            "required" : true
        }
    ],
    "checkbox" : [
        {"label" : "Enrol in MDM", "checked" : true},
        {"label" : "Install Office 365"},
        {"label" : "Enable FileVault", "checked" : true}
    ],
    "button1text" : "Submit",
    "button2text" : "Cancel",
    "moveable" : true,
    "width" : "700",
    "height" : "550",
    "json" : true
}
JSONEOF

result=$("$DIALOG" --jsonfile "$JSON_FILE" 2>/dev/null) || true
echo "Combined JSON output:"
echo "$result" | jq '.'

# Cleanup
rm -f "$JSON_FILE"
