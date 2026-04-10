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

## Tier 3: Live progress and status

- `06_progress_timer.zsh`: progress bars, progress text, timers, command-file updates
- `10_list_items.zsh`: list items, status transitions, dynamic add/delete, selectable lists
- `12_command_file.zsh`: broad live-update coverage for titles, messages, icons, buttons, window updates, and quit flows
- `14_mini_presentation.zsh`: compact progress UI and staged presentation-style status flows

## Tier 4: Advanced config-driven flows

- `16_json_input.zsh`: dialog configuration authored in JSON
- `19_inspect_mode.zsh`: inspect-mode monitoring with config JSON, log monitoring, side messages, and item path completion

## Supporting demos

- `03_icons.zsh`: icon and overlay treatments
- `05_images_banners.zsh`: images, banners, backgrounds
- `17_fullscreen_blur.zsh`: fullscreen or blur for blocking/security-sensitive prompts
- `18_misc_features.zsh`: info areas, help text, view order, logs, debug, always-return-input
