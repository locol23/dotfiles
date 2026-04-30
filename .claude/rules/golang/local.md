---
paths:
  - "**/*.go"
  - "**/go.mod"
  - "**/go.sum"
---
# Local Go Additions

> Local overlay on top of ECC `golang/`. Survives `install.sh` ECC sync.

## Error Handling Discipline

Treat errors as values — always check `if err != nil`, **never ignore them**. (Wrapping with `%w` is covered in `coding-style.md`.)

## Zero Values

Design structs so the zero value is useful. Avoid mandatory constructors when a `var x T` is sufficient.

## Concurrency

- Pass `context.Context` as the first parameter for any function that may block, do I/O, or spawn goroutines
- Use `ctx.Done()` for cancellation — never rely on goroutines exiting on their own
- Every goroutine must have a documented exit condition (cancellation, channel close, or completion)

## Package Design

- Avoid circular dependencies; reorganize types or extract interfaces if cycles appear
- Keep package names short, lowercase, single-word — the name is part of every identifier inside it
