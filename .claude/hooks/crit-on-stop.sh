#!/usr/bin/env bash
# Stop hook: launch crit review loop if this session edited files this turn.
set -u

input=$(cat)
session_id=$(jq -r '.session_id // empty' <<<"$input")
[ -n "$session_id" ] || exit 0

marker="${TMPDIR:-/tmp}/claude-crit-pending-${session_id}"
[ -f "$marker" ] || exit 0
rm -f "$marker"

command -v crit >/dev/null 2>&1 || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
[ -n "$(git status --porcelain)" ] || exit 0

out=$(mktemp) err=$(mktemp)
trap 'rm -f "$out" "$err"' EXIT

crit -q >"$out" 2>"$err"   # blocks until the user clicks "Finish Review"

if grep -q 'approved: true' "$err"; then
  exit 0
fi

# Comments left → feed them back to Claude and keep the turn going
cat "$out" >&2
exit 2
