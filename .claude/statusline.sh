#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
short_model=$(echo "$model" | sed 's/Claude //' | sed 's/ (.*//')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
monthly_cost=$(npx ccusage@16.2.0 monthly --json --order desc 2>/dev/null \
  | jq -r '.monthly[0].totalCost * 100 | round / 100')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // empty')
cwd=$(echo "$input" | jq -r '.cwd // empty')

project=""
if [ -n "$cwd" ]; then
  project=$(basename "$cwd")
fi

branch=""
if [ -n "$cwd" ] && [ -d "$cwd/.git" ]; then
  branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
fi

line="\033[36m[$short_model]\033[0m"
if [ -n "$project" ]; then
  line="$line 📁 $project"
fi
if [ -n "$branch" ]; then
  line="$line/$branch"
fi

if [ -n "$used" ]; then
  pct=$(printf "%.0f" "$used")
  line="$line | ${pct}% context"
else
  line="$line | --% context"
fi

if [ -n "$monthly_cost" ] && [ "$monthly_cost" != "null" ]; then
  line="$line | 💰 \033[32m\$${monthly_cost}\033[0m monthly"
fi

if [ -n "$duration_ms" ] && [ "$duration_ms" != "null" ]; then
  total_sec=$((duration_ms / 1000))
  mins=$((total_sec / 60))
  secs=$((total_sec % 60))
  if [ $mins -gt 0 ]; then
    line="$line | ⏱ ${mins}m ${secs}s"
  else
    line="$line | ⏱ ${secs}s"
  fi
fi

printf '%b\n' "$line"
