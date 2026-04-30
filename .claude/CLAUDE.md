# Coding Guidelines

Project-wide coding standards, language-specific guides, testing philosophy, and team workflow live under `~/.claude/rules/` (canonical [ECC](https://github.com/affaan-m/everything-claude-code) layout — `common/` always-on, `golang/` `typescript/` `web/` activated by `paths:` frontmatter). `install.sh` re-syncs the ECC subdirs on every run.

## General Notes

- Document architectural discoveries or configuration insights in this file.
- Add universally important findings that apply across projects here.
- Anything language- or stack-specific belongs in the corresponding `rules/<lang>/*.md` instead.
