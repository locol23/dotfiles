# Adopt herdr over tmux as the terminal multiplexer

- Status: accepted

Migrated the terminal multiplexer from tmux to [herdr](https://herdr.dev) — an
agent-aware multiplexer — chiefly for per-pane agent-state awareness (a
blocked / working / done sidebar), a socket/CLI API that coding agents can drive,
and native session restore for Claude Code / Codex panes. The prior tmux config
was hand-written with zero plugins, so there was almost no ecosystem to lose.

## Considered options

- **Stay on tmux** — mature and stable, but has no notion of agent state and no
  agent-driveable API; the primary workflow here is running Claude Code across
  parallel panes.
- **Adopt herdr** (chosen) — purpose-built for agent workflows, and its default
  keybinds already match the previous muscle memory closely (prefix h/j/k/l pane
  focus, Solarized theme).

## Consequences

- Lose the custom tmux status line (wifi / battery / clock); Ghostty and the macOS
  menu bar already surface these.
- herdr is young and single-maintainer (Windows still beta; macOS/Linux stable).
  Mitigation: tmux stays installed and reachable, and `.zshrc` falls back when
  herdr isn't installed, during the trial period.
- Prefix stays herdr's default `ctrl+b` instead of the old tmux `C-t`, which frees
  the nvim `<C-t>` / nvim-tree collision.
