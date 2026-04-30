---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---
# TypeScript/JavaScript Patterns

> This file extends [common/patterns.md](../common/patterns.md) with TypeScript/JavaScript specific content.

## API Response Format

```typescript
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
  meta?: {
    total: number
    page: number
    limit: number
  }
}
```

## Custom Hooks Pattern

```typescript
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value)

  useEffect(() => {
    const handler = setTimeout(() => setDebouncedValue(value), delay)
    return () => clearTimeout(handler)
  }, [value, delay])

  return debouncedValue
}
```

## Repository Pattern

```typescript
interface Repository<T> {
  findAll(filters?: Filters): Promise<T[]>
  findById(id: string): Promise<T | null>
  create(data: CreateDto): Promise<T>
  update(id: string, data: UpdateDto): Promise<T>
  delete(id: string): Promise<void>
}
```

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
