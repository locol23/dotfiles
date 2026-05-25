---
paths:
  - "**/*.stories.tsx"
  - "**/*.stories.ts"
  - "**/*.stories.mdx"
---
> This file extends [common/testing.md](../common/testing.md) with Storybook-specific testing content.

# Storybook Rules

Scope: any file matching `**/*.stories.{ts,tsx,mdx}`.

## Testing Strategy

- Component behavior is tested via the **`play` function**, not via a sibling `*.test.tsx`.
- Do **not** create new `*.test.tsx` for components — behavior coverage lives in `play`.
- Pure utilities and custom hooks are out of scope and may still use `*.test.ts`.
- CI is expected to execute play functions via Storybook Test Runner (`test-storybook`).

## Story Shape (latest CSF / Storybook 10.x)

Use the latest CSF — the **CSF Next factory format**: `definePreview()` in `preview.ts`, and `preview.meta()` + `meta.story()` in story files.

- In `preview.ts`, configure globals via `definePreview({ ... })` (or the framework-specific re-export).
- In story files, import the preview default export, define meta via `preview.meta({ ... })`, and build individual stories via `meta.story({ ... })`. Component prop types are inferred automatically — do not hand-annotate `Meta<typeof Component>` / `StoryObj<typeof meta>`.
- Do **not** use the legacy `Meta` / `StoryObj` annotation style (`export const Foo: Story = { ... }`) in new files. Existing CSF3 files may keep that style during maintenance only.
- Add `tags: ['autodocs']` by default.
- Implement `play` whenever the story requires interaction.
- Story exports use **PascalCase** — display names are derived automatically.
- Avoid `storyName` unless truly necessary.

## File Layout

- **Co-locate** the story file with the component (`Button.tsx` next to `Button.stories.tsx`).
- One component per story file.
- Do **not** set `title` manually — let CSF4 derive it from the file path. Writing it by hand creates a double source of truth with the path.

## Args / ArgTypes / Controls

- Declare props as **args** so Controls can drive them.
- Use `argTypes` to declare type, control kind, and description.
- Pass mock callbacks via `fn()` from `storybook/test`. Do **not** use `argTypes.action`.
- Override `render` only when args cannot express the case (e.g. compositions with multiple children).

## States Coverage

Cover the meaningful states as separate stories where applicable:

- `Default`
- `Loading`
- `Error`
- `Empty`
- `Disabled`
- `ReadOnly`
- `Focused`
- `LongContent` (overflow)

## Decorators & Providers

- Inject Theme / Router / QueryClient / i18n / Auth via **decorators** — either a global decorator in `preview.ts` or a per-component decorator.
- Wrap **real** providers, not mocks.
- Never add story-only branching to the component source.

## Mocking Policy

**Avoid mocks as much as possible.** Follow the project-wide "Sociable over Solitary" principle (see [common/local.md](../common/local.md)): use real implementations or dependency injection via decorators wherever possible.

- **API calls must be stubbed via MSW** (`msw-storybook-addon`) by declaring `parameters.msw.handlers`. Do not hand-write `fetch` / `axios` / SDK stubs. **Exception:** see "RSC / Server Action exception" below.
- **Do not use `vi.mock` / `jest.mock` or any form of module replacement** inside stories or play functions.
- When a callback spy is genuinely necessary (asserting a prop callback was invoked), use `fn()` from `storybook/test`. This is the **only** acceptable mock primitive.
- Provide Theme / Router / QueryClient / i18n / Auth via decorators that wrap real providers.
- For non-deterministic dependencies that MSW cannot cover (localStorage, dates, randomness), inject deterministic values via a decorator rather than mocking the module.

### RSC / Server Action exception

In React Server Components or Server Action architectures, API clients (e.g. an `openapi-fetch` instance) are invoked only from server-side modules (`'use server'`, `'server-only'`). The production browser never issues those HTTP requests directly; only the Next.js server process does. In this setting:

- **Prefer mocking the SDK client at the module boundary** via `sb.mock(import('.../fetchClient.ts'), { spy: true })` plus per-story `mocked(fetchClient.POST).mockResolvedValue({ data, error, response })`.
- **Do not introduce `msw-storybook-addon`** for the sole purpose of intercepting these server-only HTTP calls in Storybook.

Rationale: MSW would exist purely as a Storybook-environment artifact, not as a reflection of production behavior. Mocking at the SDK boundary mirrors production's Server Action boundary, removes an extra dependency, and avoids hand-maintained handler/resolver scaffolding.

For browser-originating API calls (in non-RSC components, or client-side libraries that fetch directly from the browser), the standard MSW rule above still applies.

## Play Function

Use `userEvent`, `expect`, `within`, and `fn` from `storybook/test` (renamed from `@storybook/test` in Storybook 9).

- Follow **AAA (Arrange / Act / Assert)** with one comment per phase.
- Keep stories small — one scenario per story.
- For async assertions use `findBy*` queries; avoid timer-based `waitFor`.

```ts
import { expect, fn, userEvent, within } from 'storybook/test';
import preview from '../../.storybook/preview';
import { Button } from './Button';

const meta = preview.meta({
  component: Button,
  args: { onClick: fn() },
  tags: ['autodocs'],
});

export const ClickedOnce = meta.story({
  args: { children: 'Submit' },
  play: async ({ args, canvasElement }) => {
    // Arrange
    const canvas = within(canvasElement);

    // Act
    await userEvent.click(canvas.getByRole('button', { name: /submit/i }));

    // Assert
    await expect(args.onClick).toHaveBeenCalledOnce();
  },
});
```

## Accessibility

- `@storybook/addon-a11y` is assumed installed. Override `parameters.a11y` per story when a specific story needs different rules.
- Important forms, buttons, and modals should run through a11y checks.

## Viewports / Responsive

For components whose layout changes by breakpoint, add stories that set `parameters.viewport` for representative sizes (mobile / tablet / desktop).

## Chromatic Visual Regression

Snapshot by default. Separate **disable** from **stabilize**.

### A. Use `disableSnapshot: true` only when UI duplicates another story

```ts
parameters: { chromatic: { disableSnapshot: true } }
```

Apply this when:

- A derived story's rendered output is identical to an existing one (args differ but rendering matches).
- A `play`-function end state matches another story's static state.
- The story exists purely to verify interaction (no new visual to capture).

Use **`disableSnapshot: true`**, not the legacy `disable: true`. The legacy form removes the story from Chromatic entirely and also stops interactions tests from running.

### B. Stabilize animation and keep the snapshot

Do not throw away snapshots that have visual regression value. Stabilize them according to the animation's nature:

- **Finite animation** (modal / toast / open-close transition — has an endpoint): set `parameters.chromatic.pauseAnimationAtEnd: true` to capture the final frame. This is the preferred approach.
- **Infinite animation** (Spinner / progress / skeleton shimmer): **do not stop the animation**. Stopping infinite animations can make the element disappear, render a broken intermediate frame, or land on a transparent keyframe. Instead, use `parameters.chromatic.delay` with a small value (e.g. `100`–`300` ms) to capture an arbitrary settled frame. Accept minor rotation / phase differences; raise `diffThreshold` conservatively if needed.
- **Async data load**: prefer `findBy*` in `play` to wait for the rendered state. Fall back to `delay` only when initial paint timing cannot be solved that way.

### C. Notes

- Raise `diffThreshold` sparingly, only when pixel-level noise causes false positives.

## Anti-patterns

- A `*.test.tsx` coexisting with the story for the same component.
- Indiscriminate Chromatic snapshots on every story.
- Oversized `play` functions that bundle multiple scenarios.
- Story-only branching inside the component source.
- `vi.mock` / `jest.mock` / module replacement for dependencies that MSW + real-provider decorators could cover.
- Hand-written `fetch` / `axios` / SDK stubs (except SDK clients invoked only from server-side modules in RSC apps — see "RSC / Server Action exception").
- Introducing MSW solely to intercept HTTP calls that, in production, only run server-side (RSC / Server Action). Mock the SDK client at the module boundary instead.
- Gratuitous `storyName` usage.
- Mixing legacy CSF3 annotation style into new files.
- Stopping a Spinner / infinite animation to "stabilize" Chromatic — use `delay` instead.

## Pre-merge Checklist

- [ ] `play` function present where the component has behavior to verify
- [ ] No `*.test.tsx` duplicating story coverage
- [ ] Duplicate-UI stories marked `parameters.chromatic.disableSnapshot: true`
- [ ] Animated stories stabilized (`pauseAnimationAtEnd` for finite, `delay` for infinite)
- [ ] `autodocs` tag present
- [ ] Dependencies (theme, router, query client, i18n) injected via decorators
- [ ] Main component states covered (Default / Loading / Error / Empty / etc.)
- [ ] CSF4 format (`config.define()` + `meta.story()`), not CSF3 annotations
- [ ] No `vi.mock` / `jest.mock` / module replacement; APIs stubbed via MSW (or, for server-only SDK clients in RSC apps, mocked at the SDK module boundary per the RSC / Server Action exception)
