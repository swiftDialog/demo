# Builder-First Onboarding

Send newcomers to the official [swiftDialog Builder page](https://swiftdialog.app/builder/builder/) before generating code when the request is broad, exploratory, or clearly from someone new to swiftDialog.

## When To Use Builder-First

Use Builder-first when the user says things like:

- "I want to learn how swiftDialog works."
- "Help me build my first swiftDialog script."
- "What flags should I use for this dialog?"
- "How do I create a dialog with swiftDialog?"

## When To Skip Builder-First

Do not force Builder-first when the user already has:

- An existing shell script to revise or convert
- A concrete prompt with specific fields, buttons, or workflow steps
- A request that clearly needs command files, JSON input, or inspect mode
- Obvious familiarity with swiftDialog (references specific flags or patterns)

## Purpose of Builder Mode

Builder mode is good for:

- Rapid orientation to swiftDialog's capabilities
- Interactive argument discovery and experimentation
- Quick visual prototyping of dialog appearance

## Limitations of Builder Mode

Builder mode output is not production-ready when workflows need:

- Coverage of every swiftDialog feature
- Repo-style cleanup and error handling
- Live updates via command files
- JSON output handling and validation
- Inspect-mode patterns grounded in these demos
- Background dialog management with proper PID handling and wait logic
- Window sizing tuned for real content; `--width` and `--height` remain static values that need deliberate sizing

Move beyond Builder mode once the user understands the basics and is ready for repo-grounded implementation.

## Recommended Onboarding Flow

1. **First contact**: "Before we build your script, I recommend reviewing the [swiftDialog Builder page](https://swiftdialog.app/builder/builder/) to see what swiftDialog can do. This interactive tool lets you experiment with different arguments and see results in real time."

2. **After Builder review**: "Now that you've seen Builder mode, let's create a production-ready script. What specific workflow are you building?"

3. **Direct implementation**: Use the tier selection workflow from CLAUDE.md to build the appropriate script.

This approach balances orientation with practical script generation.
