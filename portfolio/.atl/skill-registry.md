# Skill Registry: vite_react_shadcn_ts

This file tracks available AI skills and project-specific conventions.

## Compact Rules

### React & TypeScript Standards
- Use functional components with arrow functions.
- Use `lucide-react` for icons.
- Prefer `TanStack Query` for data fetching.
- Use `Zod` for schema validation.
- Follow `shadcn/ui` patterns for components.
- Use `tailwind-merge` and `clsx` for dynamic classes.

### Testing Standards
- Use `Vitest` for unit and integration tests.
- Use `React Testing Library` for component tests.
- Mock external dependencies and APIs using `msw` (if installed) or manual mocks.
- Test files should be named `*.test.tsx` or `*.spec.tsx` in `src/`.

## User Skills

| Skill | Trigger | Path |
|-------|---------|------|
| branch-pr | Creating pull requests | `C:\Users\ADMIN\.gemini\antigravity\skills\branch-pr\SKILL.md` |
| go-testing | Writing Go tests | `C:\Users\ADMIN\.gemini\antigravity\skills\go-testing\SKILL.md` |
| issue-creation | Creating GitHub issues | `C:\Users\ADMIN\.gemini\antigravity\skills\issue-creation\SKILL.md` |
| judgment-day | Dual adversarial review | `C:\Users\ADMIN\.gemini\antigravity\skills\judgment-day\SKILL.md` |
| skill-creator | Creating new AI skills | `C:\Users\ADMIN\.gemini\antigravity\skills\skill-creator\SKILL.md` |

## Project Conventions

- No custom convention files detected in root (CLAUDE.md, etc.).
- Project uses `vite.config.ts`, `tsconfig.json`, and `eslint.config.js`.
