# Claude Code SSD - Specification-Driven Development

Multi-agent system for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that implements **Specification-Driven Development (SSD)**: a structured workflow where every code change flows through analysis, proposal, specification, design, planning, implementation, and verification — each phase handled by a specialized subagent.

Ported from the [OpenCode SSD implementation](../opencode/README.md).

---

## Architecture

```
┌───────────────────────────────────────────────────────┐
│                    MAIN THREAD                         │
│                                                        │
│  /flow, /flow-lite, or /flow-verify                    │
│  (skill runs inline, orchestrates subagent calls)      │
└──────────────────────┬────────────────────────────────┘
                       │
           Agent tool (one at a time)
                       │
┌──────────────────────▼────────────────────────────────┐
│                   SUBAGENTS                            │
│                                                        │
│  explorer → proposer → spec-writer → designer →        │
│  task-planner → implementer → verifier → archiver      │
│                                                        │
│  Each runs in isolated context with restricted tools   │
└───────────────────────────────────────────────────────┘
```

**Key difference from OpenCode:** Claude Code subagents cannot spawn other subagents. The orchestration happens from the main thread via skills, not from a dedicated orchestrator agent.

---

## File Structure

All files are symlinked from the dotfiles repo to `~/.claude/`:

```
claude/
├── CLAUDE.md                          # Global Claude Code instructions
├── settings.json                      # Permissions, model config
├── agents/                            # SSD pipeline subagents (8)
│   ├── explorer.md                    # Phase 1: Repo analysis & discovery
│   ├── proposer.md                    # Phase 2: Solution options & tradeoffs
│   ├── spec-writer.md                 # Phase 3: Implementable specification
│   ├── designer.md                    # Phase 4: Technical design & interfaces
│   ├── task-planner.md                # Phase 5: Execution plan with DoD
│   ├── implementer.md                 # Phase 6: Code implementation
│   ├── verifier.md                    # Phase 7: Verification against criteria
│   └── archiver.md                    # Phase 8: Closure & release notes
└── skills/                            # Workflow definitions (slash commands)
    ├── flow/SKILL.md                  # Full 8-phase SSD workflow
    ├── flow-lite/SKILL.md             # Lighter 6-phase workflow
    └── flow-verify/SKILL.md           # Verification-only workflow
```

### Symlink Setup

The source of truth lives in `~/workspace/dotfiles/claude/`. Symlinks point from `~/.claude/` to the repo:

```bash
# Agents
~/.claude/agents/explorer.md → ~/workspace/dotfiles/claude/agents/explorer.md
# ... (same for all 8 agents)

# Skills
~/.claude/skills/flow/SKILL.md → ~/workspace/dotfiles/claude/skills/flow/SKILL.md
# ... (same for all 3 skills)
```

---

## Flows (Slash Commands)

### `/flow <goal>` — Full SSD Workflow (8 phases)

The complete specification-driven pipeline. Best for complex features, architectural changes, or anything that benefits from thorough design.

```
/flow <goal>
    │
    ├── 1. @explorer ──────► analysis
    │
    ├── 2. @proposer ──────► proposal
    │                        🚧 USER GATE
    │
    ├── 3. @spec-writer ───► spec
    │
    ├── 4. @designer ──────► design
    │
    ├── 5. @task-planner ──► tasks
    │                        🚧 USER GATE
    │
    ├── 6. @implementer ───► patch (writes code)
    │
    ├── 7. @verifier ──────► verification (runs tests)
    │
    └── 8. @archiver ──────► closure
```

### `/flow-lite <goal>` — Lightweight Workflow (6 phases)

Skips spec-writer and designer. Good for bug fixes, well-understood changes, or smaller tasks.

| Phase | Subagent       | Gate? |
|-------|----------------|-------|
| 1     | @explorer      | No    |
| 2     | @proposer      | Yes   |
| 3     | @task-planner  | Yes   |
| 4     | @implementer   | No    |
| 5     | @verifier      | No    |
| 6     | @archiver      | No    |

### `/flow-verify <goal>` — Verification Only

Verifies existing changes against acceptance criteria. Generates a minimal spec if needed.

1. (Conditional) @spec-writer drafts minimal spec
2. @verifier checks repo state
3. @archiver produces closure report

---

## Agents

### Tool Access Matrix

| Agent | Read | Grep/Glob | Bash | Edit | Write |
|-------|:----:|:---------:|:----:|:----:|:-----:|
| explorer | yes | yes | yes | **no** | **no** |
| proposer | yes | yes | **no** | **no** | **no** |
| spec-writer | yes | yes | **no** | **no** | **no** |
| designer | yes | yes | **no** | **no** | **no** |
| task-planner | yes | yes | **no** | **no** | **no** |
| **implementer** | **yes** | **yes** | **yes** | **yes** | **yes** |
| verifier | yes | yes | yes | **no** | **no** |
| archiver | yes | yes | **no** | **no** | **no** |

The **implementer** is the ONLY agent that can modify code. The **verifier** can run commands (tests) but not edit files. All other agents are read-only or have no filesystem access.

### Artifact Schema

Every subagent returns strict JSON. The artifacts flow forward through the pipeline:

| Phase | Agent | Artifact Kind | Key Fields |
|-------|-------|---------------|------------|
| 1 | explorer | `analysis` | current_state, change_surface, unknowns, risks |
| 2 | proposer | `proposal` | options, recommendation, non_goals |
| 3 | spec-writer | `spec` | requirements, acceptance_criteria, edge_cases, constraints |
| 4 | designer | `design` | architecture_overview, data_flow, interfaces, data_model |
| 5 | task-planner | `tasks` | milestones (with ordered tasks + DoD), test_plan, rollback_plan |
| 6 | implementer | `patch` | changes, how_to_run, tests_added, migration_notes |
| 7 | verifier | `verification` | checks (pass/fail/not_run), issues_found, recommendations |
| 8 | archiver | `closure` | change_summary, files_touched, risk_review, release_notes |

---

## Design Principles

1. **Separation of concerns** — Each agent has one job. Thinking agents can't write code. The implementer can't verify.

2. **Least privilege** — Agents only get the tools they need. Most are read-only.

3. **Strict contracts** — JSON artifacts with defined schemas. Malformed output triggers re-invocation.

4. **Human-in-the-loop** — User gates at proposal and task plan ensure control over key decisions.

5. **Progressive depth** — Three workflow variants for different levels of rigor.

6. **Stack-agnostic thinking** — Spec, design, and planning are framework-independent.

---

## Differences from OpenCode Implementation

| Aspect | OpenCode | Claude Code |
|--------|----------|-------------|
| Orchestration | Dedicated `orchestrator` agent (primary mode) | Main thread via skills |
| Subagent invocation | `@agent` from orchestrator | `Agent` tool from main thread |
| Subagent nesting | Supported (orchestrator → subagents) | **Not supported** (limitation) |
| Commands | `commands/*.md` | `skills/*/SKILL.md` |
| Tool restriction | `tools: bash: true/false` | `tools:` allowlist or `disallowedTools:` denylist |
| Domain specialists | SEO-Specialist, WordPress-Specialist | Not included (can be added) |
| Default agent persona | LucasG (custom persona) | Not included (uses CLAUDE.md) |
