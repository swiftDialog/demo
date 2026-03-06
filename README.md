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

## Demo Index

| # | Script | Features Demonstrated |
|---|--------|---------------------|
| 01 | `basic_styles.zsh` | `--style` (alert, caution, warning, centered), style overrides |
| 02 | `title_message.zsh` | `--title`, `--titlefont`, `--message`, `--messagefont`, `--messagealignment`, `--messageposition`, `--bannertitle`, title "none" |
| 03 | `icons.zsh` | `--icon` (SF Symbols, apps, builtins, QR, palette, auto colour, weight), `--iconsize`, `--iconalpha`, `--centreicon`, `--overlayicon`, `--hideicon` |
| 04 | `buttons.zsh` | `--button1text`, `--button1symbol`, `--button1disabled`, `--button2text`, `--button2symbol`, `--infobuttontext`, `--infobuttonsymbol`, `--infobuttonaction`, `--buttonstyle` (center, stack), `--buttonsize`, `--buttontextsize`, `--hidedefaultkeyboardaction` |
| 05 | `images_banners.zsh` | `--image`, `--imagecaption`, `--bannerimage`, `--bannertitle`, `--bannertext`, `--background`, `--bgalpha`, `--bgposition`, `--bgfill` |
| 06 | `progress_timer.zsh` | `--progress` (absolute, increment, reset, complete), `--progresstext`, `--progresstextalignment`, `--timer`, `--hidetimerbar`, command file progress updates |
| 07 | `text_fields.zsh` | `--textfield` (required, secure, prompt, value, regex, regexerror, confirm, fileselect, filetype, path, name), `--textfieldlivevalidation` |
| 08 | `dropdowns.zsh` | `--selecttitle`, `--selectvalues`, `--selectdefault`, modifiers (required, radio, searchable, multiselect, name), dividers |
| 09 | `checkboxes.zsh` | `--checkbox` (name modifier), `--checkboxstyle` (checkbox, switch, sizes) |
| 10 | `list_items.zsh` | `--listitem` (status, statustext, custom SF symbols), `--liststyle`, `--enablelistselect`, command file (list:, listitem:, add, delete, index) |
| 11 | `window_options.zsh` | `--width`, `--height`, `--big`, `--small`, `--position`, `--positionoffset`, `--moveable`, `--ontop`, `--resizable`, `--windowbuttons`, `--appearance`, `--showdockicon`, `--dockiconbadge` |
| 12 | `command_file.zsh` | Full command file tour: title:, titlefont:, message: (+append), alignment:, icon:, overlayicon:, iconalpha:, button1text:, button1:, infotext:, infobox:, icon: centre/left |
| 13 | `notifications.zsh` | `--notification`, `--subtitle`, `--identifier`, `--remove` |
| 14 | `mini_presentation.zsh` | `--mini` (with progress), `--presentation` (with listitem, infobox, progress) |
| 15 | `web_video.zsh` | `--webcontent`, `--video` (youtube= shortcut), `--videocaption`, `--autoplay` |
| 16 | `json_input.zsh` | `--jsonstring`, `--jsonfile`, JSON arrays for checkboxes, selectitems, textfields, images |
| 17 | `fullscreen_blur.zsh` | `--fullscreen`, `--blurscreen`, `--hideotherapps` |
| 18 | `misc_features.zsh` | `--helpmessage`, `--infotext`, `--infobox`, `--vieworder`, `--quitkey`, `--sound`, `--showsoundcontrols`, `--displaylog`, `--loghistory`, `--debug`, `--eula`, `--alwaysreturninput`, auth key/checksum explanation |
| 19 | `inspect_mode.zsh` | `--inspect-mode`, `--inspect-config`, `DIALOG_INSPECT_CONFIG`, inspect JSON (`preset`, `logMonitor`, `sideMessage`, `items`, `autoEnableButton`) |

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
- Demo 19 covers `--inspect-mode` and config-driven usage with a deterministic local simulation.
- See the [Inspect Mode](https://swiftdialog.app/advanced/inspect-mode/) documentation for additional presets and options.
