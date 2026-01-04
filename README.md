# Claude Code Configuration

A structured configuration for [Claude Code](https://claude.ai/claude-code) that provides a complete development workflow with specialized agents, commands, and quality controls.

## What's Inside

```
~/.claude/
├── agents/           # Specialized review and research agents
├── commands/         # /dev.* workflow commands
├── skills/           # Reusable skill definitions
├── templates/        # Spec and plan templates
├── hooks/            # Auto-formatting hooks
├── constitution.md   # Guiding principles
├── statusline.sh     # Custom status line
└── settings.json     # Claude Code settings
```

## The /dev.\* Workflow

This config implements a structured development workflow:

```
/dev.spec  →  /dev.plan  →  /dev.tasks  →  /dev.work
   ↓             ↓              ↓             ↓
 WHAT/WHY       HOW          TODOs        Execute
```

| Command        | Purpose                                                                  |
| -------------- | ------------------------------------------------------------------------ |
| `/dev.spec`    | Define **what** you're building and **why** (user stories, requirements) |
| `/dev.plan`    | Design **how** to build it (architecture, implementation steps)          |
| `/dev.tasks`   | Generate TODO files from the plan                                        |
| `/dev.work`    | Execute work by delegating to specialized subagents                      |
| `/dev.triage`  | Review and prioritize pending TODOs                                      |
| `/dev.commits` | Intelligently group and commit changes                                   |

## Agents

Specialized agents for different review and research tasks:

| Agent                            | Purpose                               |
| -------------------------------- | ------------------------------------- |
| `python-reviewer`                | High-bar Python code review           |
| `typescript-reviewer`            | High-bar TypeScript code review       |
| `architecture-strategist`        | Architectural analysis and compliance |
| `pattern-recognition-specialist` | Design patterns and anti-patterns     |
| `code-simplicity-reviewer`       | YAGNI enforcement and simplification  |
| `prompt-specialist`              | LLM prompt writing and review         |
| `best-practices-researcher`      | External best practices research      |
| `framework-docs-researcher`      | Framework documentation gathering     |
| `docs-guardian`                  | Documentation accuracy review         |
| `plan-reviewer`                  | Implementation plan review            |

Agents are automatically invoked by Claude Code based on their descriptions, or you can request them explicitly (e.g., "use the python-reviewer agent to review this code").

## Constitution

The `constitution.md` defines advisory principles that guide all `/dev.*` commands:

1. **Test-First Development** - Write tests before implementation
2. **Measurable Outcomes** - Define quantifiable success criteria
3. **Simplicity** - Prefer the simplest solution
4. **Clarification Over Assumption** - Ask when unclear
5. **Interview-Driven Discovery** - Research before specifying
6. **Security by Design** - Address security during design

These are advisory - commands warn about violations but don't block progress.

## Hooks

Auto-formatting hooks that run after file edits:

- **format-markdown.sh** - Formats `.md` files with Prettier
- **format-python.sh** - Formats `.py` files with Ruff

Both hooks check for tool availability and skip silently if not installed.

## Templates

The `templates/` directory contains starter templates used by `/dev.*` commands:

- **spec-template.md** - Feature specification template (user stories, requirements, security considerations)
- **plan-template.md** - Technical plan template (architecture, implementation phases, test strategy)

## Skills

### file-todos

A file-based TODO tracking system organized by git branch:

```
todos/
├── feature-auth/
│   ├── 001-pending-p1-fix-login.md
│   └── 002-ready-p2-add-tests.md
└── bugfix-query/
    └── 001-ready-p1-optimize-sql.md
```

Each TODO is a markdown file with YAML frontmatter tracking status, priority, dependencies, and work logs.

---

## Installation

### Option 1: Clone and symlink (recommended)

```bash
# Clone to your preferred location
git clone https://github.com/BonJarber/claude-config.git ~/dotfiles/claude-config

# Symlink individual directories/files
ln -s ~/dotfiles/claude-config/agents ~/.claude/agents
ln -s ~/dotfiles/claude-config/commands ~/.claude/commands
ln -s ~/dotfiles/claude-config/skills ~/.claude/skills
ln -s ~/dotfiles/claude-config/templates ~/.claude/templates
ln -s ~/dotfiles/claude-config/hooks ~/.claude/hooks
ln -s ~/dotfiles/claude-config/constitution.md ~/.claude/constitution.md
ln -s ~/dotfiles/claude-config/statusline.sh ~/.claude/statusline.sh
```

### Option 2: Direct clone

```bash
# Backup existing config
mv ~/.claude ~/.claude.backup

# Clone directly
git clone https://github.com/BonJarber/claude-config.git ~/.claude
```

### Option 3: Cherry-pick what you want

Browse the repo and copy individual files/directories that interest you.

## Configuration

### settings.json

The included `settings.json` enables:

- Extended thinking mode
- Custom status line showing model + git branch
- Post-edit formatting hooks
- Frontend design plugin

Merge with your existing settings or use as-is:

```bash
# View current settings
cat ~/.claude/settings.json

# Or merge specific keys into your existing settings
```

### Hook Dependencies

The formatting hooks are optional and require:

- **Markdown formatting**: `npm install -g prettier`
- **Python formatting**: `uv tool install ruff` (or `pip install ruff`)

Hooks skip silently if tools aren't available.

## Customization

### Adding Agents

Create a new `.md` file in `agents/` with YAML frontmatter:

```markdown
---
name: my-agent
description: When to use this agent
model: inherit # or: sonnet, opus, haiku
color: blue # terminal color for agent output
tools: Read, Glob, Grep, Edit # optional: restrict available tools
permissionMode: default # or: acceptEdits (auto-accept file changes)
---

You are an expert in...
```

### Adding Commands

Create a new `.md` file in `commands/`:

```markdown
---
description: What this command does
argument-hint: "[optional argument description]"
skills: [skill-name] # optional: skills this command uses
allowed-tools: Bash(git:*) # optional: tool restrictions
---

# Command Name

Instructions for Claude...

Use $ARGUMENTS to reference user-provided arguments.
```

Commands are invoked with `/command-name` (filename without `.md`).

## Philosophy

This configuration emphasizes:

- **Structured thinking** - Spec before plan, plan before code
- **Quality gates** - Specialized reviewers catch issues early
- **Simplicity** - Solve current problems, not hypothetical ones
- **Transparency** - TODO tracking with full work logs
- **Flexibility** - Advisory principles, not rigid rules

## License

MIT - Use however you like.
