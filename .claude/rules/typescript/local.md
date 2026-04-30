---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---
# Local TypeScript Additions

> Local overlay on top of ECC `typescript/`. Survives `install.sh` ECC sync.

## Result Type for Explicit Errors

For domain operations with predictable failure modes (validation, business-rule rejection, expected lookup misses), prefer a `Result` discriminated union over throwing exceptions. Reserve `throw` for unrecoverable bugs.

```typescript
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E }

async function findUser(id: string): Promise<Result<User, 'not_found' | 'db_error'>> {
  const row = await db.users.findById(id)
  if (!row) return { ok: false, error: 'not_found' }
  return { ok: true, value: row }
}

const result = await findUser(id)
if (!result.ok) {
  return handle(result.error) // exhaustive narrowing forces every failure mode to be handled
}
use(result.value)
```
