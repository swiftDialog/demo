# Advanced Patterns

Use these patterns only when a simpler tier is insufficient.

## When to use a command file

Choose a command-file workflow when the dialog must stay open while the script updates:

- Progress values or progress text change over time
- List item statuses need live updates
- Buttons or messages must unlock after background work finishes
- The script needs one persistent window instead of many step dialogs

Reference demos:

- `06_progress_timer.zsh`
- `10_list_items.zsh`
- `12_command_file.zsh`
- `14_mini_presentation.zsh`

## When to use JSON input

Choose `--jsonstring` or `--jsonfile` when:

- The dialog definition is easier to manage as structured data
- There are repeated field groups or array-heavy controls
- The user already has configuration data to transform into a dialog

Do not use JSON just because it exists. For simple scripts, direct CLI flags are easier to read and maintain.

Reference demo:

- `16_json_input.zsh`

## When to use inspect mode

Choose inspect mode only for workflows that benefit from a config-driven monitor:

- A log file is being tailed for state changes
- Completion is tied to file or app path appearance
- Side messages and monitored items are easier to express in JSON

Inspect mode is not the default answer for ordinary install progress. Use Tier 3 first unless the workflow is clearly config-driven.

Reference demo:

- `19_inspect_mode.zsh`
