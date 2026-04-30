# Local Common Additions

> Local overlay on top of ECC `common/`. Survives `install.sh` ECC sync.
> Add cross-language preferences here that ECC does not cover.

## Influences

- t_wada (TDD discipline)
- Kent C. Dodds (testing philosophy)
- Martin Fowler (refactoring & design)

## Composition over Inheritance

- Prefer composing behavior from small focused units over class inheritance hierarchies
- Easier to change, easier to test, avoids fragile base class problems
- In languages without inheritance (e.g. Go) this is the default; in OO languages, choose composition unless inheritance is clearly the right tool

## SOLID Principles

- **SRP (Single Responsibility):** a module/class should have one reason to change
- **OCP (Open/Closed):** open for extension, closed for modification — add behavior via new code, not by editing battle-tested code
- **LSP (Liskov Substitution):** subtypes must be usable wherever the base type is expected without surprising behavior
- **ISP (Interface Segregation):** prefer many small focused interfaces over one large general-purpose one
- **DIP (Dependency Inversion):** depend on abstractions, not concrete implementations; inject dependencies rather than construct them inline

## Testing Trophy Emphasis

Kent C. Dodds' Testing Trophy: "write tests, not too many, mostly integration."

- Static analysis (TypeScript/ESLint, mypy, gopls, etc.) is the implicit "0th" tier and should always be on
- **Integration tests are the highest-priority tier** — they catch the bugs unit tests miss while staying fast enough to keep on every commit
- Unit tests stay fast and focused on pure logic
- E2E tests cover critical user flows but are used sparingly due to cost

## Sociable over Solitary Tests

- Prefer real collaborators (in-memory DB, real HTTP via testcontainers, etc.) over mocks
- Mocking implementation details makes tests brittle to refactor
- Tests should resemble how users (or upstream code) interact with the unit under test
