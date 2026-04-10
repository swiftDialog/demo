# Demo Map

Use the smallest demo set that covers the request.

## Tier 1: Basic Dialogs

- **`01_basic_styles.zsh`**: alert, caution, warning, centered, compact confirmation flows
- **`02_title_message.zsh`**: title/message formatting, banner title, markdown-heavy copy
- **`04_buttons.zsh`**: button labels, symbols, disabled states, info button actions
- **`11_window_options.zsh`**: size, position, appearance, dock behavior when window chrome matters

**Common use cases:**
- Welcome messages
- Confirmation prompts
- Warning or caution alerts
- Simple button-driven actions

---

## Tier 2: Input Collection

- **`07_text_fields.zsh`**: required fields, secure input, regex validation, confirm, file select, named JSON keys
- **`08_dropdowns.zsh`**: dropdowns, radio mode, searchable lists, multiselect, named output
- **`09_checkboxes.zsh`**: checkbox and switch collections, named output
- **`16_json_input.zsh`**: `--jsonstring` and `--jsonfile` when form configuration is easier in JSON

**Common use cases:**
- User onboarding forms
- Configuration collection
- Validated input (email, hostname, etc.)
- Multi-field forms with dropdowns and checkboxes

---

## Tier 3: Live Progress and Status

- **`06_progress_timer.zsh`**: progress bars, progress text, timers, command-file updates
- **`10_list_items.zsh`**: list items, status transitions, dynamic add/delete, selectable lists
- **`12_command_file.zsh`**: broad live-update coverage for titles, messages, icons, buttons, window updates, and quit flows
- **`14_mini_presentation.zsh`**: compact progress UI and staged presentation-style status flows

**Common use cases:**
- Installation progress tracking
- Multi-step onboarding workflows
- Long-running background tasks with status updates
- Step-by-step presentations with live updates

---

## Tier 4: Advanced Config-Driven Flows

- **`16_json_input.zsh`**: dialog configuration authored in JSON (also listed in Tier 2)
- **`19_inspect_mode.zsh`**: inspect-mode monitoring with config JSON, log monitoring, side messages, and item path completion

**Common use cases:**
- Log file monitoring during installs
- Path-based completion workflows (wait for apps to appear)
- Config-driven dialogs with complex field groups
- Workflows where JSON config is easier than CLI arguments

---

## Supporting Demos

These demos provide additional context for specific features across all tiers:

- **`03_icons.zsh`**: icon and overlay treatments (SF Symbols, custom images, built-in icons)
- **`05_images_banners.zsh`**: images, banners, backgrounds
- **`17_fullscreen_blur.zsh`**: fullscreen or blur for blocking/security-sensitive prompts
- **`18_misc_features.zsh`**: info areas, help text, view order, logs, debug, always-return-input

---

## Quick Reference: Tier Selection

| Request Type | Tier | Key Demos |
|-------------|------|----------|
| Simple message or confirmation | 1 | 01, 02, 04 |
| Input form with validation | 2 | 07, 08, 09 |
| Live progress updates | 3 | 06, 10, 12, 14 |
| Log monitoring or JSON config | 4 | 16, 19 |

Choose the lowest tier that satisfies the request. Only escalate when lower tiers cannot meet the requirements.
