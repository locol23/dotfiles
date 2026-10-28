# Coding Guidelines

## General Notes

- Document architectural discoveries or configuration insights in this file.
- Add universally important findings that apply across projects here.
- Anything language- or stack-specific belongs in the corresponding
  `rules/<lang>/*.md` instead.

## Communication

- Always respond in natural concise English.

## Claude Code Settings

- Effort `max` persists only via `env.CLAUDE_CODE_EFFORT_LEVEL` in
  `settings.json`; the `effortLevel` and `modelSettings` keys reject `max`.
  The env var overrides `/effort` and `--effort`, so remove it to pick effort
  per session.
