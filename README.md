# claude-agents

Personal Claude Code subagent suite. Clone on any machine, run `setup.sh`, and all agents are available globally.

## Quick Start

```bash
git clone https://github.com/ReubenRich16/claude-agents.git ~/claude-agents
cd ~/claude-agents
chmod +x setup.sh teardown.sh
./setup.sh
```

Restart your Claude Code session. Done.

## What's Inside

```
agents/
├── code-reviewer.md      # Deep code quality review (logic, patterns, readability, performance)
├── security-reviewer.md  # Security audit (auth, injection, data exposure, dependencies)
├── test-writer.md        # Generate tests matching project conventions
├── pr-reviewer.md        # Review branch changes vs main with merge verdict
├── docs-generator.md     # Living documentation (architecture, file map, API ref, setup)
└── codebase-auditor.md   # Full codebase health audit with scored report
```

## Security Model

Every agent is hardened against codebase exfiltration:

- `WebFetch` and `MCP` blocked via `disallowedTools` on all agents
- Network CLI tools (`curl`, `wget`, `nc`, `ssh`) forbidden in system prompts
- Secrets found in code are always redacted as `[REDACTED]`
- Four of six agents are fully read-only (no `Write` or `Edit` access)
- The two with write access are scoped: `test-writer` → test directories, `docs-generator` → `docs/`

## Usage

In any Claude Code session:

```
Use the code-reviewer agent to review src/
Use the security-reviewer agent on the auth module
Use the test-writer agent to write tests for src/utils/
Use the pr-reviewer agent to review this branch
Use the docs-generator agent to document the project
Use the codebase-auditor agent for a full health check
```

Claude can also auto-delegate based on the agent descriptions.

## New Machine Setup

```bash
git clone https://github.com/YOUR_USERNAME/claude-agents.git ~/claude-agents
cd ~/claude-agents
./setup.sh
```

The setup script creates symlinks from `~/.claude/agents/` back to this repo. That means:
- Pulling updates (`git pull`) applies everywhere immediately — no re-copying
- Your agents are version-controlled with full history
- `./teardown.sh` cleanly removes everything without touching other agents

## Adding New Agents

1. Create a new `.md` file in `agents/` following the frontmatter format
2. Commit and push
3. Run `./setup.sh` again (it's idempotent — skips existing links)
4. On other machines: `git pull` and the symlink picks it up automatically

## Customisation

Each agent file is standard Claude Code subagent format (Markdown + YAML frontmatter). Common tweaks:

- **`model: sonnet`** → change to `opus` for deeper analysis (more tokens)
- **`maxTurns: 30`** → increase for larger codebases
- **`tools:`** → add or remove tool access
- **`skills:`** → preload project-specific skills into the agent's context

## Uninstall

```bash
cd ~/claude-agents
./teardown.sh
```

Only removes symlinks that point to this repo. Other agents in `~/.claude/agents/` are left untouched.
