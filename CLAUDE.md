# AGENTS.md

## Git, Github

- Use `gh` cli for all github interactions.
- Safe by default: `git status/diff/log`. Push only when user asks.
- Destructive ops forbidden unless explicit (`reset --hard`, `clean`, `restore`, `rm`, …).
- Whenever you open a pull request with `gh pr`, write a concise, well-written description. Keep it tight — no fluff. Use bullet points, Mermaid diagrams, or sequence diagrams when they explain complex ideas better than prose. If the repository you're working has a PR description template, follow it, otherwise, be creative.

## Critical Thinking

- Fix root cause (not band-aid).
- Unsure: read more code; if still stuck, ask w/ short options.
- Conflicts: call out; pick safer path.
- Unrecognized changes: assume other agent; keep going; focus your changes. If it causes issues, stop + ask user.
- Leave breadcrumb notes in thread.

## Testing Principles

- Never test the type or shape of return values. Tests should verify behavior, not implementation details or data structures.
- Each public method should have a test for its default return value with no setup.
- When testing that a method returns the same value as its default, first establish setup that would make it return the opposite without your intervention. Otherwise the test is meaningless.
- Keep variables as close as possible to where they're used. Don't put them in setup or as constants at the top of the test class.
