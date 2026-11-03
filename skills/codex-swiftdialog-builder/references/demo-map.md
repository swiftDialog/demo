# Demo Map

Use the smallest demo set that covers the request.

## Tier 1: Basic dialogs

- `01_basic_styles.zsh`: alert, caution, warning, centered, compact confirmation flows
- `02_title_message.zsh`: title/message formatting, banner title, markdown-heavy copy
- `04_buttons.zsh`: button labels, symbols, disabled states, info button actions
- `11_window_options.zsh`: size, position, appearance, dock behavior when window chrome matters

## Tier 2: Input collection

- `07_text_fields.zsh`: required fields, secure input, regex validation, confirm, file select, named JSON keys
- `08_dropdowns.zsh`: dropdowns, radio mode, searchable lists, multiselect, named output
- `09_checkboxes.zsh`: checkbox and switch collections, named output
- `16_json_input.zsh`: `--jsonstring` and `--jsonfile` when form configuration is easier in JSON
- `22_vieworder_groups.zsh`: `--vieworder` titled groups (CSV `[Title]` or JSON `groups` with `description` / `footer`), mixed input types per group, `detail` subtext
- `23_sliders_steppers.zsh`: `--slider` and `--stepper` numeric inputs with units, labels, and numeric `--json` output
- `24_page_buttons.zsh`: page buttons that act immediately (`url`, `shell`, `sheet`), selectable swatch rows, colour wells, info rows, `clicked` / `exitcode` output
- `25_control_dependencies.zsh`: `enabledif` / `visibleif` conditions, reset-to-default, required checks skipped while unavailable

Demos 22–25 require the swiftDialog 3.2.0 preview (build 5001 or newer).

## Tier 3: Live progress and status

- `06_progress_timer.zsh`: progress bars, progress text, timers, command-file updates
- `10_list_items.zsh`: list items, status transitions, dynamic add/delete, selectable lists
- `12_command_file.zsh`: broad live-update coverage for titles, messages, icons, buttons, window updates, and quit flows
- `14_mini_presentation.zsh`: compact progress UI and staged presentation-style status flows

## Tier 4: Advanced config-driven flows

- `16_json_input.zsh`: dialog configuration authored in JSON
- `19_inspect_mode.zsh`: v3.1.0b4 inspect-mode monitoring with cadence carousel, hybrid IPC, preset 3 redesign, footer branding, and published session files
- `20_branched_workflows.zsh`: workflow-card routing with `branch`, `nextpage`, `finalpage`, and history-aware Previous navigation
- `21_navigation_sidebar.zsh`: `"cardstyle": "navigation"` sidebar pages with sections, page warnings, blocked Done, and `{field}` substitution
- `26_settings_pane.zsh`: capstone settings pane combining navigation, groups, numeric inputs, page buttons, and dependencies

Demos 21 and 26 require the swiftDialog 3.2.0 preview (build 5001 or newer). Navigation dialogs should always use `--json`.

## Supporting demos

- `03_icons.zsh`: icon and overlay treatments
- `05_images_banners.zsh`: images, banners, backgrounds
- `17_fullscreen_blur.zsh`: fullscreen or blur for blocking/security-sensitive prompts
- `18_misc_features.zsh`: info areas, help text, view order, logs, debug, always-return-input
