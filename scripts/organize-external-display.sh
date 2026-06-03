#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Display: Apply Favorite Layout
# @raycast.mode compact
# @raycast.icon :desktop_computer:
# @raycast.packageName Display

set -e

LOG="$HOME/Library/Logs/organize-external-display.log"
mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1
echo "$(date -Iseconds) trigger"

PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

if ! command -v displayplacer >/dev/null; then
  echo "displayplacer not installed, skipping"
  exit 0
fi

# Persistent IDs rotate on this hardware between reconnects (displayplacer
# warns this can happen). Resolve IDs at runtime by Type instead:
#   - built-in:  Type == "MacBook built in screen"
#   - external:  any other Type (first one wins)
LIST=$(displayplacer list)

resolve_id() {
  local match=$1
  awk -v m="$match" '
    /^Persistent screen id:/ { id=$NF; next }
    /^Type:/ {
      sub(/^Type: /, "")
      if ((m == "builtin" && /MacBook built in screen/) ||
          (m == "external" && !/MacBook built in screen/)) {
        print id; exit
      }
    }
  ' <<<"$LIST"
}

EXT_ID=$(resolve_id external)
BUILTIN_ID=$(resolve_id builtin)

if [ -z "$EXT_ID" ]; then
  echo "no external display detected, skipping"
  exit 0
fi
if [ -z "$BUILTIN_ID" ]; then
  echo "no built-in display detected, skipping"
  exit 0
fi

displayplacer \
  "id:${EXT_ID} res:3008x1692 hz:60 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" \
  "id:${BUILTIN_ID} res:1710x1112 hz:60 color_depth:8 enabled:true scaling:on origin:(-1710,736) degree:0"

echo "$(date -Iseconds) applied ext:${EXT_ID} builtin:${BUILTIN_ID}"
