#!/bin/bash
# Intentionally NOT using `set -e`: config delivery (the `ln -sf` calls) is
# spread throughout this script and interleaved with fallible external commands
# (brew, mise, go install, network clones, sudo). Under `set -e` a single
# non-zero exit aborts the run and every symlink below it is skipped, leaving
# configs undelivered. Instead we continue on error and `warn`, while keeping
# hard prerequisites (Xcode CLT, git clone) explicitly fatal.

warn() { echo "⚠️  $*" >&2; }

not_installed() {
  if type "$1" >/dev/null 2>&1; then
    return 1
  fi

  return 0
}

if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "After installing CLT, please rerun this script."
  exit 1
fi

export DOTFILES_HOME=~/.dotfiles

# State markers for genuinely once-only operations. Kept OUT of the repo (there
# is no repo .gitignore) under the machine's existing convention ~/.local/state.
DOTFILES_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
mkdir -p "$DOTFILES_STATE"

is_done() { [ -f "$DOTFILES_STATE/$1.done" ]; }
mark_done() { : >"$DOTFILES_STATE/$1.done"; }

# (a) Clone the repo only when absent (naturally idempotent). A failed clone is
# fatal — nothing downstream can run without the repo.
if [ ! -d "$DOTFILES_HOME" ]; then
  git clone https://github.com/locol23/dotfiles.git "$DOTFILES_HOME" ||
    {
      echo "fatal: failed to clone dotfiles"
      exit 1
    }
  (cd "$DOTFILES_HOME" && git remote set-url origin git@github.com:locol23/dotfiles.git)
fi

# (b) dotfiles command — created every run (idempotent `ln -sf`), so a partial
# first run that aborted before this point still gets it on the next run.
sudo mkdir -p /usr/local/bin
sudo ln -sf "$DOTFILES_HOME/install.sh" /usr/local/bin/dotfiles || warn "could not link dotfiles command"

# (c) Dock reset is destructive (empties the Dock) — run exactly once, gated by a
# dedicated marker decoupled from the clone guard. Survives a partial first run
# and never re-fires on an established machine.
if ! is_done dock-reset; then
  defaults write com.apple.dock persistent-apps -array
  mark_done dock-reset
fi

# Mac
# Language
defaults write NSGlobalDomain AppleLanguages -array "en-US" "ja-JP"
# Appearance
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.7
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock mru-spaces -bool "false"
defaults write com.apple.dock show-recents -bool "false"
defaults write com.apple.dock tilesize -int 55
killall Dock
# Keyboard
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1
# Spotlight (disable Cmd+Space to use Raycast instead)
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
# Raycast
defaults write com.raycast.macos raycastGlobalHotkey "Command-49"
# Trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool "true"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool "true"
defaults -currentHost write -g com.apple.mouse.tapBehavior -bool "true"
defaults write -g com.apple.trackpad.scaling 3
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.dock showMissionControlGestureEnabled -boolean true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
# Battery (show icon + percentage in menu bar via Control Center)
defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool true
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
# Clock (show seconds)
defaults write com.apple.menuextra.clock ShowSeconds -bool true
defaults write com.apple.menuextra.clock IsAnalog -bool false
killall SystemUIServer 2>/dev/null || true
# Finder
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Terminal
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Homebrew and Formula
if not_installed brew; then
  export PATH=$PATH:/opt/homebrew/bin
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || warn "Homebrew install failed"
fi
if ! brew bundle --file "$DOTFILES_HOME/Brewfile" --verbose; then
  echo "⚠️  brew bundle reported failures (often a transient download or an"
  echo "    upstream cask checksum change). Continuing with the rest of setup."
  echo "    Re-run 'brew update && brew bundle --file \"$DOTFILES_HOME/Brewfile\"' later to retry."
fi
# brew bundle can upgrade the Ghostty cask while you're running this script
# inside Ghostty. Replacing the running .app bundle leaves the window visible
# but unresponsive to clicks/input until Ghostty is fully relaunched.
if [ "$TERM_PROGRAM" = "ghostty" ]; then
  echo "ℹ️  If Ghostty stops responding to clicks after this run, it was likely"
  echo "    updated by brew. Fully quit (Cmd-Q) and reopen Ghostty to restore input."
fi
open -a Ollama

# Japanese input (Google IME)
# Replace Apple Kotoeri with Google Japanese Input as the enabled/selected IME.
# These prefs are read by HIToolbox at LOGIN — the live session won't switch the
# active source mid-run (macOS rejects it), so a logout/login is required to apply.
# Launch the app first so it registers with the input system.
if [ -d "/Library/Input Methods/GoogleJapaneseInput.app" ]; then
  open "/Library/Input Methods/GoogleJapaneseInput.app"
  sleep 2
  defaults write com.apple.HIToolbox AppleEnabledInputSources '(
    { InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 252; "KeyboardLayout Name" = ABC; },
    { "Bundle ID" = "com.google.inputmethod.Japanese"; "Input Mode" = "com.google.inputmethod.Japanese.base"; InputSourceKind = "Input Mode"; },
    { "Bundle ID" = "com.google.inputmethod.Japanese"; InputSourceKind = "Keyboard Input Method"; },
    { "Bundle ID" = "com.apple.CharacterPaletteIM"; InputSourceKind = "Non Keyboard Input Method"; },
    { "Bundle ID" = "com.apple.50onPaletteIM"; InputSourceKind = "Non Keyboard Input Method"; },
    { "Bundle ID" = "com.apple.PressAndHold"; InputSourceKind = "Non Keyboard Input Method"; }
  )'
  defaults write com.apple.HIToolbox AppleSelectedInputSources '(
    { "Bundle ID" = "com.apple.PressAndHold"; InputSourceKind = "Non Keyboard Input Method"; },
    { "Bundle ID" = "com.google.inputmethod.Japanese"; "Input Mode" = "com.google.inputmethod.Japanese.base"; InputSourceKind = "Input Mode"; }
  )'
  killall cfprefsd 2>/dev/null || true
  echo "Google IME seeded as Japanese input — LOG OUT/IN (or restart) to apply."
fi

# Ghostty
echo
echo "Install Ghostty"
echo
mkdir -p ~/.config/ghostty
ln -sf $DOTFILES_HOME/ghostty.config ~/.config/ghostty/config

# Git
ln -sf $DOTFILES_HOME/.gitconfig ~/
ln -sf $DOTFILES_HOME/.gitignore_global ~/
[ ! -f ~/.gitconfig.local ] && cp $DOTFILES_HOME/.gitconfig.local ~/

# Mise
echo
echo "Install Mise"
echo
mkdir -p ~/.config/mise
ln -sf $DOTFILES_HOME/mise.config ~/.config/mise/config.toml
mise install || warn "mise install failed"

# Zsh
if ! grep -q '/opt/homebrew/bin/zsh' /etc/shells 2>/dev/null; then
  echo
  echo "Install Zsh"
  echo
  sudo sh -c "echo '/opt/homebrew/bin/zsh' >> /etc/shells" || warn "could not add zsh to /etc/shells"
  sudo chsh -s '/opt/homebrew/bin/zsh' "$USER" || warn "could not change login shell to zsh"
fi
ln -sfn $DOTFILES_HOME/.zsh/ ~/
ln -sf $DOTFILES_HOME/.zshenv ~/
ln -sf $DOTFILES_HOME/.zshrc ~/
ln -sf $DOTFILES_HOME/.zprofile ~/
ln -sf $DOTFILES_HOME/.p10k.zsh ~/
[ ! -f ~/.zshrc.local ] && cp $DOTFILES_HOME/.zshrc.local ~/

# Neovim
echo
echo "Install Vim"
echo
mkdir -p ~/.config
ln -sfn $DOTFILES_HOME/nvim ~/.config/nvim

# VS Code
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false

# AtCoder
if not_installed oj; then
  uv tool install online-judge-tools --force || warn "online-judge-tools install failed"
fi

# Golang
eval "$(/opt/homebrew/bin/mise activate bash)"
if ! not_installed go; then
  echo
  echo "Install golang tools"
  echo

  go install github.com/bufbuild/buf/cmd/buf@latest || warn "go install buf failed"
  go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest || warn "go install grpcurl failed"
  go install google.golang.org/protobuf/cmd/protoc-gen-go@latest || warn "go install protoc-gen-go failed"
  go install github.com/bufbuild/connect-go/cmd/protoc-gen-connect-go@latest || warn "go install protoc-gen-connect-go failed"
fi

# Direnv
ln -sf $DOTFILES_HOME/.direnvrc ~/

# Prettier
ln -sf $DOTFILES_HOME/.prettierrc.js ~/

# Tig
ln -sf $DOTFILES_HOME/.tigrc ~/

# Tmux
ln -sf $DOTFILES_HOME/.tmux.conf ~/
tmux source-file ~/.tmux.conf 2>/dev/null || true

# BTT
ln -sf $DOTFILES_HOME/bttconfig.json ~/bttconfig.json

# Claude Code
mkdir -p ~/.claude
ln -sf $DOTFILES_HOME/.claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf $DOTFILES_HOME/.claude/settings.json ~/.claude/settings.json
ln -sfn $DOTFILES_HOME/.claude/agents ~/.claude/agents
ln -sfn $DOTFILES_HOME/.claude/commands ~/.claude/commands
ln -sfn $DOTFILES_HOME/.claude/skills ~/.claude/skills
ln -sfn $DOTFILES_HOME/.claude/rules ~/.claude/rules
ln -sf $DOTFILES_HOME/.claude/statusline.sh ~/.claude/statusline.sh

# Serena
mkdir -p ~/.serena
ln -sf $DOTFILES_HOME/serena/serena_config.yml ~/.serena/serena_config.yml

# Everything Claude Code rules — sync canonical subdir layout from ECC main.
# IMPORTANT: copy entire subdirectories, never flatten — ECC's common/ and
# language/ trees contain files with the same name (coding-style.md etc.).
# Local overlays in each rules/<lang>/local.md are not present in ECC and
# therefore survive the sync; do NOT add custom edits to ECC-managed files
# (e.g. golang/coding-style.md), as they will be overwritten on next run.
ECC_TMPDIR=$(mktemp -d)
trap 'rm -rf "$ECC_TMPDIR"' EXIT
git clone --depth 1 https://github.com/affaan-m/everything-claude-code.git "$ECC_TMPDIR" || warn "ECC clone failed; rules not synced this run"

for ECC_DIR in common golang typescript web; do
  if [ -d "$ECC_TMPDIR/rules/$ECC_DIR" ]; then
    mkdir -p "$DOTFILES_HOME/.claude/rules/$ECC_DIR"
    cp -R "$ECC_TMPDIR/rules/$ECC_DIR/." "$DOTFILES_HOME/.claude/rules/$ECC_DIR/"
  fi
done

rm -rf "$ECC_TMPDIR"
trap - EXIT

# mattpocock/skills — vendor selected skills (clone, copy, discard).
# Source: https://github.com/mattpocock/skills
# Skills are listed as "<category>/<name>" pairs; only the name becomes the
# destination directory under .claude/skills/.
MP_TMPDIR=$(mktemp -d)
trap 'rm -rf "$MP_TMPDIR"' EXIT
git clone --depth 1 https://github.com/mattpocock/skills.git "$MP_TMPDIR" || warn "mattpocock/skills clone failed; skills not synced this run"

for MP_SPEC in \
  "engineering/grill-with-docs" \
  "engineering/diagnose" \
  "productivity/grill-me" \
  "productivity/handoff" \
  "productivity/write-a-skill"; do
  MP_NAME="${MP_SPEC##*/}"
  MP_SRC="$MP_TMPDIR/skills/$MP_SPEC"
  MP_DEST="$DOTFILES_HOME/.claude/skills/$MP_NAME"
  if [ -d "$MP_SRC" ]; then
    mkdir -p "$MP_DEST"
    cp -R "$MP_SRC/." "$MP_DEST/"
  fi
done

rm -rf "$MP_TMPDIR"
trap - EXIT

# Karabiner-Elements
mkdir -p ~/.config/karabiner
cp -f $DOTFILES_HOME/karabiner.json ~/.config/karabiner/karabiner.json

# Built-in display — set the MacBook screen to "More Space" (the rightmost
# notch of the Displays "Larger Text ←→ More Space" slider). That is the
# largest HiDPI (scaling:on) mode; on this hardware it is 1710x1112. Persistent
# screen IDs rotate between reboots (see organize-external-display.sh), so
# resolve the built-in ID at runtime by Type instead of hardcoding it.
if command -v displayplacer >/dev/null; then
  BUILTIN_ID=$(displayplacer list | awk '
    /^Persistent screen id:/ { id=$NF; next }
    /^Type:/ && /MacBook built in screen/ { print id; exit }
  ')
  if [ -n "$BUILTIN_ID" ]; then
    displayplacer "id:${BUILTIN_ID} res:1710x1112 hz:60 color_depth:8 scaling:on" ||
      warn "could not set built-in display to More Space"
  else
    warn "built-in display not found; skipping More Space resolution"
  fi
fi

# Display layout — auto-apply favorite arrangement on display connect
mkdir -p ~/Library/LaunchAgents ~/Library/Logs
sed "s|__HOME__|$HOME|g" "$DOTFILES_HOME/launchd/com.locol23.display-organizer.plist" \
  >~/Library/LaunchAgents/com.locol23.display-organizer.plist
launchctl unload ~/Library/LaunchAgents/com.locol23.display-organizer.plist 2>/dev/null || true
launchctl load ~/Library/LaunchAgents/com.locol23.display-organizer.plist || warn "could not load display-organizer launch agent"

# SSH
mkdir -p ~/.ssh
ln -sf $DOTFILES_HOME/.ssh/config ~/.ssh/
[ ! -f ~/.ssh/config.local ] && cp $DOTFILES_HOME/.ssh/config.local ~/.ssh/

# espanso
mkdir -p ~/Library/Application\ Support/espanso/match
ln -sf "$DOTFILES_HOME"/espanso/*.yml ~/Library/Application\ Support/espanso/match/
espanso service register 2>/dev/null
echo
echo "espanso: Grant Accessibility permissions in System Settings, then run 'espanso service start'."

# Verify config delivery — warn (don't fail) if any key symlink is missing so a
# partial run is visible at a glance. Re-running `dotfiles` re-applies them.
echo
missing=0
for target in \
  ~/.gitconfig \
  ~/.zshrc \
  ~/.config/nvim \
  ~/.config/ghostty/config \
  ~/.claude/CLAUDE.md \
  ~/.claude/settings.json \
  ~/.ssh/config; do
  if [ ! -e "$target" ]; then
    warn "missing config: $target (re-run 'dotfiles' to retry)"
    missing=1
  fi
done
[ "$missing" -eq 0 ] && echo "✅ key config symlinks delivered."

# killall Dock / killall SystemUIServer above can drop Ghostty (the terminal
# this script runs in) from the WindowServer's "active app" state, leaving it
# unable to receive clicks until refocused. Re-activate it so the session ends
# in a clickable state. `open -a` refocuses the running instance without an
# Apple Events permission prompt.
if [ "$TERM_PROGRAM" = "ghostty" ]; then
  open -a Ghostty 2>/dev/null || true
fi

exec /opt/homebrew/bin/zsh -l
