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

sudo_keepalive_stop() {
  [ -n "${SUDO_KEEPALIVE_PID:-}" ] && kill "$SUDO_KEEPALIVE_PID" 2>/dev/null
  SUDO_KEEPALIVE_PID=
}

sudo_keepalive_start() {
  sudo_keepalive_stop
  if sudo -v; then
    while true; do
      sudo -n true
      sleep 60
      kill -0 "$$" || exit
    done 2>/dev/null &
    SUDO_KEEPALIVE_PID=$!
  else
    warn "sudo authentication failed; sudo steps below may prompt or fail"
  fi
}

trap 'sudo_keepalive_stop; sudo -k 2>/dev/null' INT TERM

sudo_keepalive_start

export DOTFILES_HOME=~/.dotfiles

# State markers for genuinely once-only operations, kept out of the repo.
DOTFILES_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
mkdir -p "$DOTFILES_STATE"

is_done() { [ -f "$DOTFILES_STATE/$1.done" ]; }
mark_done() { : >"$DOTFILES_STATE/$1.done"; }

# (a) Clone the repo only when absent. A failed clone is fatal.
if [ ! -d "$DOTFILES_HOME" ]; then
  git clone https://github.com/locol23/dotfiles.git "$DOTFILES_HOME" ||
    {
      echo "fatal: failed to clone dotfiles"
      exit 1
    }
  (cd "$DOTFILES_HOME" && git remote set-url origin git@github.com:locol23/dotfiles.git)
fi

# (b) dotfiles command — (re)created every run so a partial first run recovers.
sudo mkdir -p /usr/local/bin
sudo ln -sf "$DOTFILES_HOME/install.sh" /usr/local/bin/dotfiles || warn "could not link dotfiles command"

# (c) Dock reset is destructive (empties the Dock) — gate it behind a dedicated
# marker so it runs exactly once and never re-fires on an established machine.
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
# brew bundle may upgrade the running Ghostty cask, leaving it unresponsive until
# relaunched (see CLAUDE.md).
if [ "$TERM_PROGRAM" = "ghostty" ]; then
  echo "ℹ️  If Ghostty stops responding to clicks after this run, it was likely"
  echo "    updated by brew. Fully quit (Cmd-Q) and reopen Ghostty to restore input."
fi
open -a Ollama

# Japanese input (Google IME) — seed Google Japanese Input over Apple Kotoeri.
# Both the Roman (英数) and Hiragana modes must be enabled: the 英数 key only
# toggles a mode the OS remembers if that mode is an enabled input source.
# Otherwise every app switch reinitializes the context back to Hiragana.
# "Input Mode" takes the mode key, not the com.google.* TISInputSourceID. The 英数
# mode key is "com.apple.inputmethod.Roman" — it is NOT under the Japanese.*
# namespace, and HIToolbox silently drops entries with an unknown mode key.
# Authoritative list: ComponentInputModeDict.tsInputModeListKey in
# /Library/Input Methods/GoogleJapaneseInput.app/Contents/Info.plist.
# Google's Roman mode (smRoman) is the ASCII source, so no ABC layout is needed.
# defaults write = login-time seed (HIToolbox rereads prefs at login);
# TISEnableInputSource below = immediate effect via the supported API.
if [ -d "/Library/Input Methods/GoogleJapaneseInput.app" ]; then
  open "/Library/Input Methods/GoogleJapaneseInput.app"
  sleep 2
  defaults write com.apple.HIToolbox AppleEnabledInputSources '(
    { "Bundle ID" = "com.google.inputmethod.Japanese"; "Input Mode" = "com.apple.inputmethod.Roman"; InputSourceKind = "Input Mode"; },
    { "Bundle ID" = "com.google.inputmethod.Japanese"; "Input Mode" = "com.apple.inputmethod.Japanese"; InputSourceKind = "Input Mode"; },
    { "Bundle ID" = "com.google.inputmethod.Japanese"; InputSourceKind = "Keyboard Input Method"; },
    { "Bundle ID" = "com.apple.CharacterPaletteIM"; InputSourceKind = "Non Keyboard Input Method"; },
    { "Bundle ID" = "com.apple.50onPaletteIM"; InputSourceKind = "Non Keyboard Input Method"; },
    { "Bundle ID" = "com.apple.PressAndHold"; InputSourceKind = "Non Keyboard Input Method"; }
  )'
  defaults write com.apple.HIToolbox AppleSelectedInputSources '(
    { "Bundle ID" = "com.apple.PressAndHold"; InputSourceKind = "Non Keyboard Input Method"; },
    { "Bundle ID" = "com.google.inputmethod.Japanese"; "Input Mode" = "com.apple.inputmethod.Roman"; InputSourceKind = "Input Mode"; }
  )'
  killall cfprefsd 2>/dev/null || true
  # Live-enable via TIS so this run takes effect without logout. Exit 2 = IME
  # not yet registered with TIS (first-ever install); other non-zero = hard fail.
  if /usr/bin/python3 - <<'PY'
import ctypes
import sys
from ctypes import c_bool, c_char_p, c_int32, c_long, c_void_p

cf = ctypes.CDLL("/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation")
carbon = ctypes.CDLL("/System/Library/Frameworks/Carbon.framework/Carbon")

carbon.TISCreateInputSourceList.restype = c_void_p
carbon.TISCreateInputSourceList.argtypes = [c_void_p, c_bool]
carbon.TISGetInputSourceProperty.restype = c_void_p
carbon.TISGetInputSourceProperty.argtypes = [c_void_p, c_void_p]
carbon.TISEnableInputSource.restype = c_int32
carbon.TISEnableInputSource.argtypes = [c_void_p]
carbon.TISSelectInputSource.restype = c_int32
carbon.TISSelectInputSource.argtypes = [c_void_p]

cf.CFArrayGetCount.restype = c_long
cf.CFArrayGetCount.argtypes = [c_void_p]
cf.CFArrayGetValueAtIndex.restype = c_void_p
cf.CFArrayGetValueAtIndex.argtypes = [c_void_p, c_long]
cf.CFStringGetCString.restype = c_bool
cf.CFStringGetCString.argtypes = [c_void_p, c_char_p, c_long, c_int32]
cf.CFRelease.argtypes = [c_void_p]

kID = c_void_p.in_dll(carbon, "kTISPropertyInputSourceID")
ROMAN = "com.google.inputmethod.Japanese.Roman"
BASE = "com.google.inputmethod.Japanese.base"


def cfstr(ptr):
    if not ptr:
        return None
    buf = ctypes.create_string_buffer(512)
    if not cf.CFStringGetCString(ptr, buf, 512, 0x08000100):
        return None
    return buf.value.decode("utf-8")


def source_id(src):
    return cfstr(carbon.TISGetInputSourceProperty(src, kID))


def find_sources(include_all, wanted):
    lst = carbon.TISCreateInputSourceList(None, include_all)
    found = {}
    for i in range(cf.CFArrayGetCount(lst)):
        src = c_void_p(cf.CFArrayGetValueAtIndex(lst, i))
        sid = source_id(src)
        if sid in wanted and sid not in found:
            found[sid] = src
    return lst, found


lst, found = find_sources(True, {ROMAN, BASE})
missing = [s for s in (ROMAN, BASE) if s not in found]
if missing:
    cf.CFRelease(lst)
    print("TIS sources not registered yet: " + ", ".join(missing), file=sys.stderr)
    sys.exit(2)

for sid in (ROMAN, BASE):
    st = carbon.TISEnableInputSource(found[sid])
    if st != 0:
        cf.CFRelease(lst)
        print("TISEnableInputSource(%s) -> OSStatus %d" % (sid, st), file=sys.stderr)
        sys.exit(1)
cf.CFRelease(lst)

# Select from the selectable list — the includeAllInstalled handle can return
# paramErr (-50) immediately after enable.
lst2, found2 = find_sources(False, {ROMAN})
if ROMAN not in found2:
    cf.CFRelease(lst2)
    print("TISSelectInputSource: %s not in selectable list" % ROMAN, file=sys.stderr)
    sys.exit(1)
st = carbon.TISSelectInputSource(found2[ROMAN])
cf.CFRelease(lst2)
if st != 0:
    print("TISSelectInputSource(%s) -> OSStatus %d" % (ROMAN, st), file=sys.stderr)
    sys.exit(1)
print("Google IME Roman + Hiragana enabled via TIS")
PY
  then
    echo "Google IME active now (Roman + Hiragana) — no logout needed."
  else
    _tis_status=$?
    if [ "$_tis_status" -eq 2 ]; then
      warn "Google IME live TIS apply skipped (IME not registered yet); seeded prefs apply at next login."
    else
      warn "Google IME live TIS apply failed (exit $_tis_status); seeded prefs apply at next login."
    fi
    echo "Google IME seeded as Japanese input — LOG OUT/IN (or restart) to apply."
  fi
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
  sudo_keepalive_start
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
if tmux info >/dev/null 2>&1; then
  tmux source-file ~/.tmux.conf || warn "tmux source-file reported an error (check ~/.tmux.conf)"
fi

# herdr (agent-aware multiplexer; migrating from tmux — see docs/adr/0001)
mkdir -p ~/.config/herdr
ln -sf $DOTFILES_HOME/herdr/config.toml ~/.config/herdr/config.toml
# Claude Code integration hook (reports Claude's session to herdr for agent
# state + conversation resume). Tracked and symlinked here instead of running
# `herdr integration install claude`, which rewrites ~/.claude/settings.json
# through its own schema and can drop keys it doesn't recognize. The matching
# SessionStart hook entry lives in .claude/settings.json.
mkdir -p ~/.claude/hooks
ln -sf $DOTFILES_HOME/.claude/hooks/herdr-agent-state.sh ~/.claude/hooks/herdr-agent-state.sh
if herdr status 2>/dev/null | grep -q "status: running"; then
  herdr server reload-config >/dev/null 2>&1 || warn "herdr server reload-config reported an error (check herdr/config.toml)"
fi

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

# Cursor Agent reads ~/.claude/skills and ~/.claude/agents directly (documented
# at cursor.com/docs/skills), so the symlinks above already cover it. Do NOT add
# ~/.cursor/{skills,agents} pointing at the same tree: skills are not deduped by
# realpath, so every extra root re-lists all of them in the agent's context.
# .cursor/ is only needed for Cursor-only config (rules/*.mdc, mcp.json).

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

# Built-in display — set the MacBook screen to "More Space" (largest HiDPI mode,
# 1710x1112 here). Screen IDs rotate between reboots, so resolve it by Type.
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

# Verify config delivery — warn (don't fail) on any missing key symlink.
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

# The killall Dock/SystemUIServer calls above can drop Ghostty from the active-app
# state; re-activate it so the session ends clickable.
if [ "$TERM_PROGRAM" = "ghostty" ]; then
  open -a Ghostty 2>/dev/null || true
fi

sudo_keepalive_stop
sudo -k

exec /opt/homebrew/bin/zsh -l
