# Testing Requirements

> Testing philosophy: Kent C. Dodds' Testing Trophy — "write tests, not too many, mostly integration." Focus on behavior, not implementation details. Prefer sociable tests (using real collaborators) over solitary tests (heavy mocking) so refactors do not invalidate the suite.

## Minimum Test Coverage: 80%

Test Types (ALL required):
1. **Unit Tests** - Individual functions, utilities, components — fast and focused
2. **Integration Tests** - How components and modules work together — **highest priority** per Testing Trophy
3. **E2E Tests** - Critical user flows — use sparingly due to cost (framework chosen per language)

Static analysis (TypeScript/ESLint, mypy, gopls, etc.) is the implicit "0th" tier and should always be on.

## Test-Driven Development

MANDATORY workflow:
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)

## Troubleshooting Test Failures

1. Use **tdd-guide** agent
2. Check test isolation
3. Verify mocks are correct
4. Fix implementation, not tests (unless tests are wrong)

## Agent Support

- **tdd-guide** - Use PROACTIVELY for new features, enforces write-tests-first

## Test Structure (AAA Pattern)

Prefer Arrange-Act-Assert structure for tests:

```typescript
test('calculates similarity correctly', () => {
  // Arrange
  const vector1 = [1, 0, 0]
  const vector2 = [0, 1, 0]

  // Act
  const similarity = calculateCosineSimilarity(vector1, vector2)

  // Assert
  expect(similarity).toBe(0)
})
```

### Test Naming

Use descriptive names that explain the behavior under test:

```typescript
test('returns empty array when no markets match query', () => {})
test('throws error when API key is missing', () => {})
test('falls back to substring search when Redis is unavailable', () => {})
```
