#!/bin/zsh
# Demo 07: Text Fields & Input Validation
# Demonstrates: --textfield with modifiers (required, secure, prompt, value,
#               regex, regexerror, confirm, fileselect, filetype, path, name),
#               --textfieldlivevalidation

DIALOG="/usr/local/bin/dialog"

# --- Basic text fields ---
result=$("$DIALOG" \
    --title "Text Field Basics" \
    --message "Multiple text fields with different modifiers:" \
    --icon "SF=text.cursor,colour=#007AFF" \
    --textfield "Your Name" \
    --textfield "Email,prompt=user@example.com" \
    --textfield "Password,secure" \
    --textfield "Pre-filled,value=Hello World" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || exit 0

echo "Basic fields output:"
echo "$result" | jq '.'

# --- Required fields ---
result=$("$DIALOG" \
    --title "Required Fields" \
    --message "Fields marked **required** must be filled before the dialog can be dismissed.\n\nTry clicking Submit with empty fields!" \
    --icon "SF=exclamationmark.triangle,colour=#FF3B30" \
    --textfield "Full Name,required" \
    --textfield "Employee ID,required,prompt=E0000" \
    --button1text "Submit" \
    --button2text "Skip Demo" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || exit 0

echo "Required fields output:"
echo "$result" | jq '.'

# --- Regex validation with live feedback ---
result=$("$DIALOG" \
    --title "Regex Validation" \
    --message "Text fields support **regex validation** with live feedback.\n\nGreen = valid, Red = invalid.\n\nTry entering values that match (or don't match) the patterns:" \
    --icon "SF=checkmark.shield,colour=#34C759" \
    --textfield "Phone (10 digits),required,regex=^\d{10}$,regexerror=Enter exactly 10 digits,prompt=0400000000" \
    --textfield "Postcode (4 digits),required,regex=^\d{4}$,regexerror=Enter a 4-digit postcode,prompt=2600" \
    --textfield "Email,required,regex=^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z][a-zA-Z]+$,regexerror=Enter a valid email" \
    --textfieldlivevalidation \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 700 \
    --height 420 \
    --json 2>/dev/null) || exit 0

echo "Regex fields output:"
echo "$result" | jq '.'

# --- Password confirmation ---
result=$("$DIALOG" \
    --title "Password Confirmation" \
    --message "The **confirm** modifier creates a duplicate field that must match.\n\nBoth fields must contain the same value to proceed." \
    --icon "SF=lock.shield,colour=#5856D6" \
    --textfield "New Password,secure,required,confirm" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || exit 0

# --- File select ---
result=$("$DIALOG" \
    --title "File Selection" \
    --message "The **fileselect** modifier adds a file picker button.\n\nYou can limit file types with \`filetype\` and set an initial path with \`path\`." \
    --icon "SF=folder,colour=#FF9500" \
    --textfield "Select a file,fileselect,filetype=pdf txt md,path=/Users" \
    --textfield "Any file,fileselect" \
    --button1text "Next →" \
    --button2text "Skip" \
    --moveable \
    --width 700 \
    --json 2>/dev/null) || exit 0

echo "File select output:"
echo "$result" | jq '.'

# --- Named fields ---
result=$("$DIALOG" \
    --title "Named Output Fields" \
    --message "The **name** modifier changes the JSON key in the output.\n\nField title: \"Enter Hostname\"\nOutput key: \"hostname\" (via \`name=\"hostname\"\`)" \
    --icon "SF=tag,colour=#00C7BE" \
    --textfield "Enter Hostname,name=hostname,prompt=mac-001" \
    --textfield "Enter Department,name=department,prompt=Engineering" \
    --button1text "Done ✓" \
    --moveable \
    --width 650 \
    --json 2>/dev/null) || true

echo "Named fields output:"
echo "$result" | jq '.'
