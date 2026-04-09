# swiftDialog Playground: AI-Assisted Script Development

## Welcome to the swiftDialog Demo Playground!

This directory is your workspace for creating custom swiftDialog scripts using AI assistance.

After exploring the demo suite, this guide will help you leverage the bundled AI skills to build production-ready scripts for your Mac Admin workflows.

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Understanding the AI Skills](#2-understanding-the-ai-skills)
3. [AI Workflow Deep-Dive](#3-ai-workflow-deep-dive)
4. [Realistic Mac Admin Scenarios](#4-realistic-mac-admin-scenarios)
5. [Tips, Troubleshooting, and Next Steps](#5-tips-troubleshooting-and-next-steps)

---

## 1. Prerequisites

### 1.1 Complete the Quick Start

> Before using this playground, complete the steps outlined in [README.md Quick Start](../README.md#quick-start):

```zsh
git clone https://github.com/swiftDialog/demo.git swiftDialog-demo
cd swiftDialog-demo
./run_demos.zsh
```

Run the interactive demo controller and step through several demos to understand swiftDialog's capabilities.

### 1.2 Review the swiftDialog Builder (Recommended for Newcomers)

> **Experienced users can skip this step** if you're already familiar with swiftDialog flags and patterns.

If you're new to swiftDialog, start with the official [swiftDialog Builder](https://swiftdialog.app/builder/builder/). This interactive tool lets you:

- Experiment with different arguments
- See results in real-time
- Understand available features visually


### 1.3 Choose Your AI Platform

This repository includes skill packs for two AI platforms:

- **Claude Sonnet** → Use [`skills/claude-swiftdialog-builder/`](../skills/claude-swiftdialog-builder/)
- **GitHub Copilot / OpenAI Codex** → Use [`skills/codex-swiftdialog-builder/`](../skills/codex-swiftdialog-builder/)

Both produce identical script output following the same conventions. See [`skills/README.md`](../skills/README.md) for detailed usage instructions.

---

## 2. Understanding the AI Skills

### 2.1 What Are the Skills?

The AI skills are instruction packs that teach AI assistants (Claude, Codex, etc.) how to:

- Generate repo-aligned swiftDialog shell scripts
- Follow the same conventions used in the demo suite
- Choose appropriate patterns based on your requirements
- Produce production-ready code with proper error handling

> **These are not runnable scripts** — they are knowledge frameworks for AI assistants.

### 2.2 The Tier System

The skills organize swiftDialog workflows into four tiers, from simplest to most complex:

| Tier | Use Case | Example Demos | Key Features |
|------|----------|---------------|--------------|
| **Tier 1** | One-shot messaging, confirmations, alerts | [01](../demos/01_basic_styles.zsh), [02](../demos/02_title_message.zsh), [04](../demos/04_buttons.zsh) | Basic buttons, styled dialogs, simple messaging |
| **Tier 2** | Input forms with validation | [07](../demos/07_text_fields.zsh), [08](../demos/08_dropdowns.zsh), [09](../demos/09_checkboxes.zsh) | Text fields, dropdowns, checkboxes, JSON output |
| **Tier 3** | Live progress updates | [06](../demos/06_progress_timer.zsh), [10](../demos/10_list_items.zsh), [12](../demos/12_command_file.zsh), [14](../demos/14_mini_presentation.zsh) | Progress bars, command files, dynamic updates |
| **Tier 4** | Config-driven or log monitoring | [16](../demos/16_json_input.zsh), [19](../demos/19_inspect_mode.zsh) | JSON configuration, inspect mode, path monitoring |

> **Favor Simplicity:** Choose the smallest tier that satisfies your requirements; don't use _Tier 3_ progress updates if _Tier 1_ buttons are sufficient.

### 2.3 How the AI Will Work With You

When you ask an AI assistant to create a swiftDialog script using the skills, it will:

1. **Ask intake questions** to understand your requirements
2. **Select the appropriate tier** based on your answers
3. **Load relevant demo patterns** for reference
4. **Generate a production-ready script** following repo conventions

> **The AI won't just guess,** it will interview you to ensure the script matches your needs.

---

## 3. AI Workflow Deep-Dive

This section shows you the detailed workflow when working with AI assistants using the skills.

### 3.1 Invoking the Skills

#### For Claude Sonnet

[Upload the skill folder](../skills/claude-swiftdialog-builder/README.md#option-1-project-knowledge-recommended) or reference the instruction file directly:

```
Using the swiftDialog builder skill from skills/claude-swiftdialog-builder/,
create a dialog that collects employee information during onboarding.
```

Or simply reference the file:

```
Review CLAUDE.md in skills/claude-swiftdialog-builder/, then create a 
dialog for Mac setup.
```

#### For GitHub Copilot / Codex

Use the skill name token in your prompt:

```
Use $codex-swiftdialog-builder to create a progress dialog that shows
installation status for multiple applications.
```

### 3.2 The Intake Process

The AI will ask you questions before generating code. Here are the typical intake questions and what they mean:

#### Question 1: "What is the script trying to accomplish?"

**What the AI wants:** A clear, concise description of the script's purpose.

**Good answers:**
- "Collect employee information during Mac onboarding"
- "Show installation progress for company apps"
- "Prompt for macOS update compliance"

> **Avoid vague answers like:** "Make a dialog" or "Something for users"

#### Question 2: "Who is the script for, and when does it run?"

**What the AI wants:** Context about the user and timing.

**Good answers:**
- "Runs during DEP enrollment, seen by new employees"
- "Triggered by Jamf policy when macOS update is available"
- "Self Service item for existing users"

> **Avoid vague answers like:** "For everyone" or "When needed"

#### Question 3: "What inputs must be collected? Which are required?"

**What the AI wants:** Specific field names and validation rules.

**Good answers:**
- "Hostname (required), email (required, validated), department (dropdown)"
- "Just a confirmation — Continue or Cancel buttons"
- "None — this is a progress display only"

> **Avoid vague answers like:** "Some fields" or "Get user input"

#### Question 4: "Does the script need validation, named JSON output, or follow-on actions?"

**What the AI wants:** Post-dialog processing requirements.

**Good answers:**
- "Yes, output JSON with field names for use in a Jamf policy"
- "No JSON needed, just exit codes (0 = success, 2 = cancel)"
- "Validate email format before accepting"

> **Avoid vague answers like:** "Maybe" or "I'm not sure"

#### Question 5: "Does work continue after the first dialog? Does it need progress indicators or status updates?"

**What the AI wants:** Understanding if this is one-shot or needs live updates.

**Good answers:**
- "Yes, install apps in the background and update progress"
- "No, just show a message and exit when user clicks Continue"
- "Yes, show live status updates as each app installs"

> **Avoid vague answers like:** "It depends" or "Possibly"

#### Question 6: "What should success, failure, skip, or cancel do?"

**What the AI wants:** Exit behavior and error handling.

**Good answers:**
- "Success: return JSON and exit 0. Cancel: exit 2 without output."
- "Success: exit 0. Failure: show error and exit 1."
- "Always exit 0 (silent completion)"

> **Avoid vague answers like:** "Handle errors" or "Do something"

### 3.3 Tier Selection Reasoning

After intake, the AI will select a tier. Here's how the decision works:

**Tier 1 Decision Pattern:**
- ✅ No input collection needed
- ✅ Single dialog display
- ✅ Button-driven outcomes only
- ❌ No progress updates or live changes

**Tier 2 Decision Pattern:**
- ✅ Collecting user input (text, dropdowns, checkboxes)
- ✅ Needs validation or named JSON output
- ❌ Dialog appears once, then exits
- ❌ No live updates after display

**Tier 3 Decision Pattern:**
- ✅ Background work continues after dialog appears
- ✅ Needs progress bar or status indicators
- ✅ Live updates via command file
- ✅ Multi-step workflows with visual feedback

**Tier 4 Decision Pattern:**
- ✅ Configuration easier in JSON than shell arguments
- ✅ Log file monitoring required
- ✅ Path-based completion (wait for files to appear)
- ✅ Inspect mode genuinely fits the workflow

### 3.4 From Prompt to Script: Example Interaction

Here's a complete example showing the full workflow:

**Your initial prompt:**
```
Using the swiftDialog builder skill, create a script that collects
employee information during Mac onboarding.
```

**AI's intake questions:**
```
1. What specific information needs to be collected?
2. Are any fields required or need validation?
3. What should the script do with the collected data?
4. When and how is this script triggered?
```

**Your answers:**
```
1. Full name (required), email (required, must validate format), 
   department (dropdown: IT, HR, Sales, Marketing, Finance)
2. Name and email are required. Email must match standard format.
3. Output JSON with field names (full_name, email, department) for 
   use in a Jamf policy that provisions user account.
4. Runs during DEP enrollment as part of automated setup workflow.
```

**AI's tier selection reasoning:**
```
This request requires:
- Input collection (name, email, department)
- Validation (required fields, email format)
- Named JSON output for downstream processing

Tier 2 (Input Collection) is appropriate. Loading:
- demos/07_text_fields.zsh (required fields, validation)
- demos/08_dropdowns.zsh (department selection)
```

**Generated script structure:**
```zsh
#!/bin/zsh

DIALOG="/usr/local/bin/dialog"

# --- Collect Employee Information ---
result=$("$DIALOG" \
  --title "Employee Onboarding" \
  --message "Please provide your information to complete Mac setup." \
  --button1text "Continue" \
  --button2text "Cancel" \
  --textfield "Full Name,required" \
  --textfield "Email,required,regex=^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$,regexerror=Please enter a valid email address" \
  --selecttitle "Department,required" \
  --selectvalues "IT,HR,Sales,Marketing,Finance" \
  --json \
  2>/dev/null) || exit 2

# --- Output JSON ---
echo "$result" | jq '.'
exit 0
```

---

## 4. Realistic Mac Admin Scenarios

This section provides detailed, real-world scenarios with exact prompts, expected AI interactions, and tier reasoning.

### 4.1 Scenario: Employee Onboarding Form

**Context:** You need to collect basic employee information during Mac setup as part of your DEP enrollment workflow. The data will be used to provision user accounts and configure system settings.

#### Step 1: Your Initial Prompt

```
Using the swiftDialog builder skill, create a script that collects employee
onboarding information. I need to gather full name, email address, and 
department selection. Name and email are required and must be validated.
The output should be JSON for processing by a Jamf policy.
```

#### Step 2: Expected AI Intake Questions (if any)

The prompt is specific enough that the AI may proceed directly, but might ask:

```
Should the department list be a dropdown (single selection) or checkboxes
(multi-selection)? Should this script exit with a specific code on cancel?
```

**Your clarification:**
```
Dropdown with single selection. For departments: IT, HR, Sales, Marketing,
Finance. On cancel, exit with code 2. On success, exit with code 0.
```

#### Step 3: AI Tier Selection Reasoning

```
Analysis:
- Input collection required (name, email, department)
- Validation needed (required fields, email format)
- Named JSON output for downstream processing
- Single dialog interaction (user fills form, clicks Continue)
- No background work or live updates needed

Tier: 2 (Input Collection)

Loading for reference:
- demos/07_text_fields.zsh (required fields, regex validation, named output)
- demos/08_dropdowns.zsh (department dropdown with named key)
```

#### Step 4: Key Script Patterns

The generated script will include:

- `#!/bin/zsh` shebang
- `DIALOG="/usr/local/bin/dialog"` constant
- Required textfields with `required` modifier
- Email regex validation: `regex=^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$`
- Custom error message: `regexerror=Please enter a valid email address`
- Department dropdown: `--selecttitle "Department,required"`
- `--json` flag for structured output
- Error suppression: `2>/dev/null`
- Exit code handling: `|| exit 2` on cancel, `exit 0` on success
- JSON output via `jq '.'`

#### Step 5: Working With the Generated Script

The AI will create a complete, working script. Save it in this playground directory:

```zsh
# In playground/
vim employee_onboarding.zsh
chmod +x employee_onboarding.zsh
./employee_onboarding.zsh
```

Test the script, then integrate into your deployment workflow (Jamf Pro, Munki, etc.).

---

### 4.2 Scenario: macOS Update Compliance Prompt

**Context:** You need a blocking warning dialog that appears when users are overdue for macOS updates. It should explain the policy, provide a direct link to Software Update, and allow deferral with tracking.

#### Step 1: Your Initial Prompt

```
Using the swiftDialog builder skill, create a compliance prompt for overdue
macOS updates. Show a warning-style dialog that explains the update policy,
with two buttons: "Open Software Update" and "I'll Update Later". The dialog
should use caution styling to emphasize urgency.
```

#### Step 2: Expected AI Intake Questions

```
1. Should "Open Software Update" launch System Settings directly?
2. What should happen when the user clicks "I'll Update Later"?
3. Should this dialog be moveable, or lock position to ensure visibility?
```

**Your clarification:**
```
1. Yes, open System Settings to Software Update panel using:
   open "x-apple.systempreferences:com.apple.preferences.softwareupdate"
2. Log the deferral and exit with code 1 (so policy can track deferrals).
3. Keep it moveable — we don't want to frustrate users too much.
```

#### Step 3: AI Tier Selection Reasoning

```
Analysis:
- Simple two-button dialog with styled appearance
- No input collection needed
- Button actions: one launches System Settings, other exits with specific code
- Single display, no live updates or progress tracking
- Message display with urgency styling

Tier: 1 (Basic Dialog)

Loading for reference:
- demos/01_basic_styles.zsh (caution/warning styles)
- demos/04_buttons.zsh (button labels, actions, SF Symbols)
```

#### Step 4: Key Script Patterns

The generated script will include:

- `--style caution` for visual urgency
- `--icon SF=exclamationmark.triangle.fill` for warning symbol
- `--title "macOS Update Required"`
- Multi-line `--message` explaining policy with markdown formatting
- `--button1text "Open Software Update"` with action: `open "x-apple.systempreferences:com.apple.preferences.softwareupdate"`
- `--button2text "I'll Update Later"`
- Exit code 1 for deferral, exit code 0 for compliance action
- Logging deferral to file for policy tracking

#### Step 5: Extending the Script

After generating the basic script, you might ask:

```
Can you add a 60-second timer that auto-clicks "Open Software Update" 
if the user doesn't respond?
```

The AI will add `--timer 60` and `--hidetimerbar` (or show it, based on preference).

---

### 4.3 Scenario: App Installation with Progress Tracking

**Context:** You're deploying multiple company apps (FileVault setup, Rosetta 2, internal tools) and want users to see real-time installation progress with status updates for each app.

#### Step 1: Your Initial Prompt

```
Using the swiftDialog builder skill, create an installation progress dialog
that shows status for multiple apps. I need to install FileVault, Rosetta 2,
company VPN, and our internal toolset. Each app should show pending status
initially, then transition to "installing" and finally "complete" as the
install happens in the background. Include a progress bar that increments
with each completed app.
```

#### Step 2: Expected AI Intake Questions

```
1. Should the dialog block until all installations complete?
2. What should happen if an installation fails?
3. Should users see stdout/stderr from install commands, or just status updates?
```

**Your clarification:**
```
1. Yes, keep the dialog open until all apps are installed.
2. Mark failed items with an error status and continue with remaining apps.
   Exit with code 1 if any failures occur.
3. Just status updates in the dialog — log detailed output to a file.
```

#### Step 3: AI Tier Selection Reasoning

```
Analysis:
- Background installation work continues after dialog appears
- Live status updates needed as each app installs
- Progress bar incrementing from 0-100%
- List items transitioning through states (pending → wait → success/error)
- Command file required for live updates

Tier: 3 (Live Progress and Status Updates)

Loading for reference:
- demos/06_progress_timer.zsh (progress bar, progress text, incremental updates)
- demos/10_list_items.zsh (list item status transitions, SF symbols)
- demos/12_command_file.zsh (comprehensive command file patterns)
```

#### Step 4: Key Script Patterns

The generated script will include:

- `CMD_FILE="/var/tmp/dialog.log"` for live updates
- `rm -f "$CMD_FILE"` to clean up before use
- Background dialog launch: `"$DIALOG" ... &`
- Process ID capture: `DIALOG_PID=$!`
- Initial list items with `pending` status
- `trap cleanup EXIT` for automatic cleanup
- Progress tracking in increments (25% per app)
- Command file updates:
  ```zsh
  echo "listitem: Rosetta 2: wait" >> "$CMD_FILE"
  # install Rosetta 2 ...
  echo "listitem: Rosetta 2: success" >> "$CMD_FILE"
  echo "progress: increment 25" >> "$CMD_FILE"
  ```
- Wait for dialog completion: `wait $DIALOG_PID 2>/dev/null || true`
- Exit code based on success/failure count

#### Step 5: Testing and Iteration

After the AI generates the script, test it and refine:

```
The progress updates work great, but can you add a final confirmation
message when all apps are installed? Show a centered dialog with a
success message and a "Restart Now" button.
```

The AI will add a second dialog (Tier 1) that appears after the progress dialog completes.

---

### 4.4 Scenario: Policy Acknowledgment with EULA-Style Scroll

**Context:** Your organization requires employees to acknowledge a security policy before granting access to internal resources. The policy text is long and must be fully reviewable before acceptance.

#### Step 1: Your Initial Prompt

```
Using the swiftDialog builder skill, create a policy acknowledgment dialog.
Display our security policy text (about 500 lines) in a scrollable area,
with "I Acknowledge" and "Decline" buttons. Button 1 should be disabled
until the user scrolls to the bottom of the policy text.
```

#### Step 2: Expected AI Intake Questions

```
1. How should the policy text be loaded? From a file, or embedded in the script?
2. What happens when the user declines?
3. Should we track who acknowledged and when?
```

**Your clarification:**
```
1. Load from a file: /Library/Company/Policies/security-policy.txt
2. Decline exits with code 2 and logs the declination.
3. Yes, on acknowledgment, log username, timestamp, and policy version.
```

#### Step 3: AI Tier Selection Reasoning

```
Analysis:
- Single dialog with scrollable content
- Button state control (disabled until scroll completion)
- No input collection (just acknowledgment)
- No live updates or progress tracking
- Uses --eula or --message with markdown for long text

Tier: 1 (Basic Dialog)

Loading for reference:
- demos/02_title_message.zsh (message formatting, positioning)
- demos/04_buttons.zsh (button disabled state, button actions)
- demos/18_misc_features.zsh (--eula flag for scroll-to-enable)
```

#### Step 4: Key Script Patterns

The generated script will include:

- Policy text loaded from file: `POLICY_TEXT=$(cat /Library/Company/Policies/security-policy.txt)`
- `--eula` flag to enable scroll-to-activate behavior for button 1
- `--message "$POLICY_TEXT"` or `--eula` with file path
- `--button1text "I Acknowledge"`
- `--button1disabled` (automatically removed when user scrolls to bottom via `--eula`)
- `--button2text "Decline"`
- Logging acknowledgment:
  ```zsh
  if [[ $result -eq 0 ]]; then
    echo "$(date): $(whoami) acknowledged policy v2.1" >> /var/log/policy-ack.log
  else
    echo "$(date): $(whoami) declined policy v2.1" >> /var/log/policy-ack.log
  fi
  ```

#### Step 5: Integration With Identity Management

After generating the base script, you might extend it:

```
Can you modify this to send acknowledgment data to our API endpoint?
Post JSON with username, timestamp, policy version, and system serial number.
```

The AI will add a curl POST with proper JSON formatting and error handling.

---

### 4.5 Scenario: Inspect Mode — Monitor App Installation

**Context:** You're creating a Self Service item that monitors for specific applications to appear on disk. When all required apps are detected, automatically enable a "Continue" button. This provides visual feedback during long-running installs without requiring manual progress updates.

#### Step 1: Your Initial Prompt

```
Using the swiftDialog builder skill, create an inspect mode dialog that
monitors for app installations. Watch for Google Chrome.app, Slack.app,
and Microsoft Teams.app in /Applications/. Each app should show as pending
initially, then automatically change to success when detected on disk.
The Continue button should be disabled until all three apps are installed.
```

#### Step 2: Expected AI Intake Questions

```
1. How often should the script check for app presence?
2. What should happen after the user clicks Continue?
3. Should there be a timeout if apps never appear?
```

**Your clarification:**
```
1. Default inspect mode polling is fine (every 2 seconds or so).
2. Just exit with code 0 — this is monitoring only.
3. No timeout — the install policy will handle overall timeout.
```

#### Step 3: AI Tier Selection Reasoning

```
Analysis:
- Log/path monitoring for app presence
- Dynamic status updates based on file system state
- Auto-enable button when all items detected
- Inspect mode is the best fit for path-based completion
- No manual command file updates needed (inspect handles it)

Tier: 4 (Inspect Mode)

Loading for reference:
- demos/19_inspect_mode.zsh (inspect config JSON, path monitoring, auto-enable)
```

#### Step 4: Key Script Patterns

The generated script will include:

- Inspect mode config JSON:
  ```json
  {
    "preset": "filecheck",
    "logMonitor": {
      "path": "/var/log/install.log",
      "keywords": ["Install succeeded"]
    },
    "sideMessage": "Waiting for app installations to complete...",
    "items": [
      {"path": "/Applications/Google Chrome.app"},
      {"path": "/Applications/Slack.app"},
      {"path": "/Applications/Microsoft Teams.app"}
    ],
    "autoEnableButton": true
  }
  ```
- Config saved to temp file
- Dialog invocation with `--inspect-mode` and `--inspect-config "$CONFIG_FILE"`
- Cleanup for temp files via `trap cleanup EXIT`
- Button 1 disabled initially, auto-enabled when all paths exist

#### Step 5: Advanced Customization

After the base script works, you might ask:

```
Can you modify this to also monitor a log file for installation messages?
I want to show log excerpts in the side message area as installs progress.
```

The AI will enhance the `logMonitor` section in the inspect config to tail your log file and update the side message with relevant lines.

---

## 5. Tips, Troubleshooting, and Next Steps

### 5.1 Tips for Effective AI Collaboration

**Be specific in your initial prompt:**
- ❌ "Make a dialog for me"
- ✅ "Create a form that collects hostname, email, and department with JSON output"

**Provide context about your environment:**
- Mention if scripts run in DEP/ADE enrollment, Jamf policies, Self Service, or manual execution
- Specify macOS version requirements if relevant
- Note any organizational constraints (no internet access, specific log paths, etc.)

**Iterate incrementally:**
- Start with a basic version, test it, then ask for refinements
- It's easier to add features than debug a complex script all at once

**Reference specific demos when you know the pattern:**
```
Create a progress dialog similar to demos/06, but for installing
company apps instead of generic progress steps.
```

### 5.2 Common Troubleshooting

#### Issue: "The AI generated code that doesn't follow repo conventions"

**Solution:** Remind the AI about the conventions file:

```
This script doesn't match the conventions in AGENTS.md. Can you revise
it to use [[ ]] instead of [ ] for tests, quote all variable expansions,
and suppress stderr with 2>/dev/null?
```

#### Issue: "The AI chose the wrong tier"

**Solution:** Explicitly state the tier you want:

```
This should be a Tier 1 basic dialog, not Tier 3. I don't need live
updates — just a simple confirmation prompt.
```

#### Issue: "The script has syntax errors"

**Solution:** Ask the AI to validate:

```
Can you check this script for syntax errors? Run through the command
structure and ensure all quotes, brackets, and pipes are properly formed.
```

Then validate yourself:

```zsh
zsh -n your_script.zsh
```

#### Issue: "The dialog doesn't look right when I run it"

**Solution:** Check swiftDialog version and platform:

```zsh
dialog --version
```

Ensure you're running swiftDialog 3+ on macOS 15+. Some flags may not work on older versions.

#### Issue: "JSON output is malformed"

**Solution:** Always pipe JSON output through `jq` for validation:

```zsh
result=$("$DIALOG" ... --json 2>/dev/null) || exit 2
echo "$result" | jq '.' || { echo "Invalid JSON output"; exit 1; }
```

### 5.3 Testing Your Scripts

Create a testing checklist in this directory:

```zsh
# test_script.zsh
#!/bin/zsh

# Test script for validating your custom dialogs

echo "Testing: Basic Invocation"
./your_script.zsh

echo "Testing: Cancel Button"
# Programmatically test cancel behavior if possible

echo "Testing: JSON Output"
# Validate JSON structure with jq

echo "Testing: Error Conditions"
# Test with missing inputs, invalid data, etc.
```

### 5.4 Organizing Your Scripts

As you create more scripts, consider organizing them by function:

```
playground/
├── README.md (this file)
├── .gitignore
├── onboarding/
│   ├── employee_info.zsh
│   └── compliance_check.zsh
├── deployment/
│   ├── app_install_progress.zsh
│   └── policy_enforcement.zsh
└── utilities/
    ├── system_info_collector.zsh
    └── user_preference_dialog.zsh
```

### 5.5 Next Steps

#### Level Up Your Skills

1. **Study the demos:** Review the numbered demos in [`demos/`](../demos/) to see patterns in action
2. **Read the references:** Dive into [`skills/claude-swiftdialog-builder/references/`](../skills/claude-swiftdialog-builder/references/) for advanced patterns
3. **Explore inspect mode:** Demo [19_inspect_mode.zsh](../demos/19_inspect_mode.zsh) is powerful for complex monitoring workflows
4. **Experiment with command files:** Demo [12_command_file.zsh](../demos/12_command_file.zsh) shows the full range of live updates

#### Contribute Back

Found a useful pattern not covered in the demos? Consider contributing:

1. Fork this repository
2. Create a new demo or improve existing ones
3. Submit a pull request with your enhancements

#### Join the Community

- [swiftDialog GitHub](https://github.com/swiftDialog/swiftDialog) — Official repo, issues, discussions
- [swiftDialog Wiki](https://github.com/swiftDialog/swiftDialog/wiki) — Comprehensive documentation
- [Mac Admins Slack](https://macadmins.org/) — `#swiftdialog` channel

---

## Quick Reference Card

Save this for quick access while working:

| Task | Tier | Key Flags |
|------|------|-----------|
| Welcome message | 1 | `--title`, `--message`, `--button1text` |
| Update compliance prompt | 1 | `--style caution`, `--button1text`, `--button2text` |
| Collect user info | 2 | `--textfield`, `--selecttitle`, `--json` |
| Onboarding form | 2 | `--textfield "Name,required"`, `--json` |
| App install progress | 3 | `--progress`, `--listitem`, command file |
| Multi-step workflow | 3 | `--progress`, `--listitem`, background dialog |
| Policy acknowledgment | 1 | `--eula`, `--button1disabled` |
| Monitor app installs | 4 | `--inspect-mode`, `--inspect-config` |

**File paths in this repo:**
- Demos: [demos/](../demos/)
- Skills: [skills/README.md](../skills/README.md)
- Conventions: [AGENTS.md](../AGENTS.md)
- Templates: [skills/claude-swiftdialog-builder/templates/](../skills/claude-swiftdialog-builder/templates/)

**Validation command:**
```zsh
zsh -n your_script.zsh  # Check syntax before running
```