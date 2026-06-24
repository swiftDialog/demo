# swiftDialog Comprehensive Demo Suite

A collection of zsh scripts that demonstrate every major feature of [swiftDialog](https://github.com/swiftDialog/swiftDialog) through an interactive, self-guided tour.

## Requirements

- **macOS 15 or newer**
- [**swiftDialog 3 or newer**](https://github.com/swiftDialog/swiftDialog/releases)

## Quick Start

```zsh
# clone this repo
git clone https://github.com/swiftDialog/demo.git swiftDialog-demo

# or download the zip
curl -sL "https://github.com/swiftDialog/demo/archive/refs/heads/main.zip" -o swiftDialog-demo.zip && unzip swiftDialog-demo.zip -d swiftDialog-demo

cd swiftDialog-demo
./run_demos.zsh
```

The main controller uses swiftDialog itself — pick demos with checkboxes, then step through each one.

## AI Skills for swiftDialog Authoring

**New to swiftDialog?** Start with the official [swiftDialog Builder page](https://swiftdialog.app/builder/builder/) for orientation and visual prototyping, then use one of the repo-contained skill packs to turn that understanding into repo-style shell scripts. Builder is useful, but it is not comprehensive and it does not replace final sizing, cleanup, and workflow decisions.

### Available Skills

**[`codex-swiftdialog-builder`](skills/codex-swiftdialog-builder/)** — For GitHub Copilot / OpenAI Codex

- [`SKILL.md`](skills/codex-swiftdialog-builder/SKILL.md) — Codex workflow and tier selection
- [`references/`](skills/codex-swiftdialog-builder/references/) — Demo mapping and authoring guidance
- [`assets/templates/`](skills/codex-swiftdialog-builder/assets/templates/) — Starter shell scripts
- Includes a Jamf/root-run `/var/tmp` plus ownership-handoff pattern for command-file workflows launched as `root`

**[`claude-swiftdialog-builder`](skills/claude-swiftdialog-builder/)** — For Claude Sonnet

- [`CLAUDE.md`](skills/claude-swiftdialog-builder/CLAUDE.md) — Claude workflow and tier selection
- [`references/`](skills/claude-swiftdialog-builder/references/) — Demo mapping and authoring guidance
- [`templates/`](skills/claude-swiftdialog-builder/templates/) — Starter shell scripts
- Includes a Jamf/root-run `/var/tmp` plus ownership-handoff pattern for command-file workflows launched as `root`

Both skills follow the same repo conventions and produce identical script output — choose the one that matches your AI platform. See [`skills/README.md`](skills/README.md) for detailed usage instructions.

These are skill packs for AI assistants, not runnable demos in the suite.

## AI-Assisted Development Playground

After exploring the demo suite and understanding swiftDialog's capabilities, use the [`playground/`](playground/) directory to create your own custom scripts with AI assistance. The playground includes a comprehensive step-by-step guide that shows you how to:

- Work with AI assistants (Claude, Copilot) using the bundled skills
- Choose the right tier for your workflow (basic dialogs → forms → progress updates → inspect mode)
- Follow detailed real-world scenarios with exact prompts and expected AI interactions
- Build production-ready scripts for Mac Admin tasks (onboarding, compliance, deployment, monitoring)

**Start here:** [`playground/README.md`](playground/README.md) — Your workspace for AI-assisted swiftDialog script development.

## Demo Index

| # | Script | Features Demonstrated |
|---|--------|---------------------|
| 01 | `01_basic_styles.zsh` | `--style` (alert, caution, warning, centered), style overrides |
| 02 | `02_title_message.zsh` | `--title`, `--titlefont`, `--message`, `--messagefont`, `--messagealignment`, `--messageposition`, `--bannertitle`, title "none" |
| 03 | `03_icons.zsh` | `--icon` (SF Symbols, apps, builtins, QR, palette, auto colour, weight), `--iconsize`, `--iconalpha`, `--centreicon`, `--overlayicon`, `--hideicon` |
| 04 | `04_buttons.zsh` | `--button1text`, `--button1symbol`, `--button1disabled`, `--button2text`, `--button2symbol`, `--infobuttontext`, `--infobuttonsymbol`, `--infobuttonaction`, `--buttonstyle` (center, stack), `--buttonsize`, `--buttontextsize`, `--hidedefaultkeyboardaction` |
| 05 | `05_images_banners.zsh` | `--image`, `--imagecaption`, `--bannerimage`, `--bannertitle`, `--bannertext`, `--background`, `--bgalpha`, `--bgposition`, `--bgfill` |
| 06 | `06_progress_timer.zsh` | `--progress` (absolute, increment, reset, complete), `--progresstext`, `--progresstextalignment`, `--timer`, `--hidetimerbar`, command file progress updates |
| 07 | `07_text_fields.zsh` | `--textfield` (required, secure, prompt, value, regex, regexerror, confirm, fileselect, filetype, path, name), `--textfieldlivevalidation` |
| 08 | `08_dropdowns.zsh` | `--selecttitle`, `--selectvalues`, `--selectdefault`, modifiers (required, radio, searchable, multiselect, name), dividers |
| 09 | `09_checkboxes.zsh` | `--checkbox` (name modifier), `--checkboxstyle` (checkbox, switch, sizes) |
| 10 | `10_list_items.zsh` | `--listitem` (status, statustext, custom SF symbols), `--liststyle`, `--enablelistselect`, command file (list:, listitem:, add, delete, index) |
| 11 | `11_window_options.zsh` | `--width`, `--height`, `--big`, `--small`, `--position`, `--positionoffset`, `--moveable`, `--ontop`, `--resizable`, `--windowbuttons`, `--appearance`, `--showdockicon`, `--dockiconbadge` |
| 12 | `12_command_file.zsh` | Full command file tour: title:, titlefont:, message: (+append), alignment:, icon:, overlayicon:, iconalpha:, button1text:, button1:, infotext:, infobox:, icon: centre/left |
| 13 | `13_notifications.zsh` | `--notification`, `--subtitle`, `--identifier`, `--remove` |
| 14 | `14_mini_presentation.zsh` | `--mini` (with progress), `--presentation` (with listitem, infobox, progress) |
| 15 | `15_web_video.zsh` | `--webcontent`, `--video` (youtube= shortcut), `--videocaption`, `--autoplay` |
| 16 | `16_json_input.zsh` | `--jsonstring`, `--jsonfile`, JSON arrays for checkboxes, selectitems, textfields, images |
| 17 | `17_fullscreen_blur.zsh` | `--fullscreen`, `--blurscreen`, `--hideotherapps` |
| 18 | `18_misc_features.zsh` | `--helpmessage`, `--infotext`, `--infobox`, `--vieworder`, `--quitkey`, `--sound`, `--showsoundcontrols`, `--displaylog`, `--loghistory`, `--debug`, `--eula`, `--alwaysreturninput`, auth key/checksum explanation |
| 19 | `19_inspect_mode.zsh` | `--inspect-mode`, `--inspect-config`, `--published-sessions-dir`, `stepType: "cadence"`, `cadenceStyle: "carousel"`, cadence IPC (`cadence:satisfy`, `cadence:advance`, `cadence:goto`), preset 3 redesign, footer logo, forced `appearance`, `cacheExtensions` with `aria2` |
| 20 | `20_branched_workflows.zsh` | top-level `workflow` array, `branch.map`, `branch.default`, `branch.ifTrue`, `branch.ifFalse`, `nextpage`, `finalpage`, history-aware Previous |

## Running Individual Demos

Each demo script is self-contained:

```zsh
./demos/06_progress_timer.zsh
./demos/12_command_file.zsh
```

## Notes

- Demos that use `--blurscreen` or `--fullscreen` will briefly take over the display
- Notification demos require notification permissions for swiftDialog
- Some image demos use system desktop pictures which may vary by macOS version
- Demo 19 now focuses on the v3.1.0b4 inspect refresh, including cadence carousel, preset 3 compact redesign, session publishing, and a companion managed-preference sample JSON.
- Demos 19 and 20 require **swiftDialog v3.1.0b4 or newer** for cadence and branched workflow support.
- See the [swiftDialog v3.1.0b4 release notes](https://github.com/swiftDialog/swiftDialog/releases/tag/v3.1.0b4) for the exact feature set covered here.
