# ~/.claude

My Claude Code configuration. Skills, hooks, plugins, and coding conventions.

## Structure

```
├── CLAUDE.md          # Global instructions (coding style, git policy, tool prefs)
├── settings.json      # Permissions, plugins, hooks, status line
├── hooks/
│   └── deny-rm-rf.jq  # Safety hook: blocks rm -rf, suggests trash
├── skills/            # Domain-specific skills
│   ├── ast-grep/
│   ├── architecture-designer/
│   ├── deep-research/
│   ├── golang-pro/
│   ├── playwriter/     # Chrome automation via Playwriter extension
│   ├── humanizer/
│   ├── postgres-pro/
│   ├── psql/
│   └── python-pro/
└── plugins/           # Installed plugin registry and config
```

## Skills

Each skill lives in `skills/<name>/SKILL.md` with optional reference docs.

| Skill | Description | Source |
|-------|-------------|--------|
| `ast-grep` | Structural code search and rewriting using AST patterns | [ast-grep/agent-skill](https://github.com/ast-grep/agent-skill) |
| `architecture-designer` | High-level system design, ADRs, and trade-off evaluation | [claude-skills](https://github.com/Jeffallan/claude-skills) |
| `deep-research` | Multi-phase web research with parallel subagents, produces cited reports | [nateberkopec/dotfiles](https://github.com/nateberkopec/dotfiles/tree/main/files/home/.claude/skills/deep-research) |
| `golang-pro` | Go concurrency, generics, gRPC, and table-driven tests | [claude-skills](https://github.com/Jeffallan/claude-skills) |
| `humanizer` | Remove signs of AI-generated writing from text | [nateberkopec/dotfiles](https://github.com/nateberkopec/dotfiles/blob/main/files/home/.claude/skills/humanizer/SKILL.md) |
| `playwriter` | Automate your own Chrome via the Playwriter extension | [playwriter](https://github.com/remorses/playwriter) |
| `postgres-pro` | Query optimization, replication, JSONB, and VACUUM tuning | [claude-skills](https://github.com/Jeffallan/claude-skills) |
| `psql` | Connect to and inspect PostgreSQL databases via `psql` CLI | Custom |
| `python-pro` | Python 3.11+ type safety, async, and pytest patterns | [claude-skills](https://github.com/Jeffallan/claude-skills) |
