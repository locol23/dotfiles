---
paths:
  - "**/*.go"
  - "**/go.mod"
  - "**/go.sum"
---
# Go Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with Go specific content.

## Formatting

- **gofmt** and **goimports** are mandatory — no style debates

## Design Principles

- Accept interfaces, return structs
- Keep interfaces small (1-3 methods)

## Error Handling

Treat errors as values — always check `if err != nil`, never ignore them. Wrap with context using `%w`:

```go
if err != nil {
    return fmt.Errorf("failed to create user: %w", err)
}
```

## Zero Values

Design structs so the zero value is useful. Avoid mandatory constructors when a `var x T` is sufficient.

## Concurrency

- Pass `context.Context` as the first parameter for any function that may block, do I/O, or spawn goroutines
- Use `ctx.Done()` for cancellation — never rely on goroutines exiting on their own
- Every goroutine must have a documented exit condition (cancellation, channel close, or completion)

## Package Design

- Avoid circular dependencies; reorganize types or extract interfaces if cycles appear
- Keep package names short, lowercase, single-word — the name is part of every identifier inside it

## Reference

See skill: `golang-patterns` for comprehensive Go idioms and patterns.
