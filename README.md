# dotfiles

my dot files

## Getting Started

```bash
curl -fsSL https://raw.githubusercontent.com/locol23/dotfiles/main/install.sh | bash
```

## Display layout

`scripts/organize-external-display.sh` re-applies the favorite multi-display
arrangement via [`displayplacer`](https://github.com/jakehilborn/displayplacer).

Display IDs are resolved at runtime by Type (`MacBook built in screen` vs
anything else), because both the persistent and serial IDs reported by
displayplacer can rotate between reconnects on some hardware. Only the
resolution and the origin offsets are baked in — adjust those in the script
if you want a different arrangement.

To see what the current state looks like and confirm the IDs/positions you
want:

```bash
displayplacer list
```

### Auto-apply on display connect

`install.sh` installs a launchd agent (`com.locol23.display-organizer`) that
watches `/Library/Preferences/com.apple.windowserver.displays.plist`. When the
plist changes (every connect/disconnect), the script runs. If the favorite
external display isn't present, it exits cleanly.

Troubleshooting:

```bash
launchctl list | grep display-organizer
tail -f ~/Library/Logs/organize-external-display.log
```

### Manual trigger via Raycast

The script has Raycast Script Command headers. Register the directory once:

> Raycast → Extensions → Script Commands → Add Directory → `~/.dotfiles/scripts/`

The command "Display: Apply Favorite Layout" then runs from the Raycast launcher.

