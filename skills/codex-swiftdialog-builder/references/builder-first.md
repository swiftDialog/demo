# Builder-First Onboarding

Send newcomers to the official [swiftDialog Builder page](https://swiftdialog.app/builder/builder/) before generating code when the request is broad, exploratory, or clearly from someone new to swiftDialog.

Use Builder-first when the user says things like:

- "I want to learn how swiftDialog works."
- "Help me build my first swiftDialog script."
- "What flags should I use for this dialog?"

Do not force Builder-first when the user already has:

- An existing shell script to revise
- A concrete prompt with specific fields, buttons, or workflow steps
- A request that clearly needs command files, JSON, or inspect mode

## What Builder Is Good For

- Rapid orientation to swiftDialog capabilities
- Visual prototyping and rough argument discovery
- Quick experimentation before writing a real script

## What Builder Does Not Cover Well

- It is not comprehensive and does not represent every swiftDialog feature
- Its output is not production-ready when workflows need repo-style cleanup or error handling
- It does not replace command-file, JSON, or inspect-mode patterns grounded in these demos
- It does not size windows for you; `--width` and `--height` are static and still need to fit the real content being shown

Move beyond Builder mode once the user is ready for repo-grounded implementation.
