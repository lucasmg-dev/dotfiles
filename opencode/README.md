# OpenCode SSD - Specification-Driven Development

Multi-agent system for [OpenCode CLI](https://opencode.ai) that implements **Specification-Driven Development (SSD)**: a structured workflow where every code change flows through analysis, proposal, specification, design, planning, implementation, and verification — each phase handled by a specialized agent.

---

## Architecture Overview

The system has three layers:

```
┌─────────────────────────────────────────────────────────┐
│                  CONVERSATIONAL LAYER                    │
│                                                         │
│  LucasG (default agent)                                 │
│  Senior Architect mentor — plan-first, implement on ask │
└─────────────────────────────────────────────────────────┘
                          │
                    /flow commands
                          │
┌─────────────────────────────────────────────────────────┐
│                  ORCHESTRATION LAYER                     │
│                                                         │
│  orchestrator (no tools — pure coordination)            │
│  Invokes subagents, validates JSON, enforces gates      │
└─────────────────────────────────────────────────────────┘
                          │
              subagent invocations (@agent)
                          │
┌─────────────────────────────────────────────────────────┐
│                   EXECUTION LAYER                        │
│                                                         │
│  SSD Pipeline (7 agents):                               │
│  explorer → proposer → spec-writer → designer →         │
│  task-planner → implementer → verifier → archiver       │
│                                                         │
│  Domain Specialists (3 agents):                         │
│  SEO-Specialist · WordPress-Specialist · datadog-metrics│
└─────────────────────────────────────────────────────────┘
```

---

## Directory Structure

```
opencode/
├── opencode.json          # Main config (default agent, MCP servers, permissions)
├── package.json           # Dependencies (@opencode-ai/plugin SDK)
├── package-lock.json      # Locked dependency versions
├── agents/                # Agent definitions (13 agents)
│   ├── LucasG.md          # Primary — Senior Architect mentor
│   ├── orchestrator.md    # Primary — Delegate-only workflow coordinator
│   ├── explorer.md        # Subagent — Repo analysis & discovery
│   ├── proposer.md        # Subagent — Solution options & tradeoffs
│   ├── spec-writer.md     # Subagent — Implementable specification
│   ├── designer.md        # Subagent — Technical design & interfaces
│   ├── task-planner.md    # Subagent — Execution plan with DoD
│   ├── implementer.md     # Subagent — Code implementation
│   ├── verifier.md        # Subagent — Verification against criteria
│   ├── archiver.md        # Subagent — Closure & release notes
│   ├── datadog-metrics.md # Subagent — Datadog metrics & dashboards
│   ├── SEO-Specialist.md  # Subagent — SEO for media websites
│   └── WordPress-Specialist.md  # Subagent — WordPress development
└── skills/                # Slash commands (flow skills + 35+ gstack skills)
    ├── gstack/            # gstack core skill
    ├── gstack-*/          # gstack sub-skills (browse, qa, review, ship, etc.)
    ├── gstack-autoplan/
    ├── gstack-review/
    ├── gstack-ship/
    └── ...                # Full gstack suite — see gstack documentation
```

---

## Flows (Slash Commands)

### `/flow` — Full SSD Workflow (8 phases)

The complete specification-driven pipeline. Best for complex features, architectural changes, or anything that benefits from thorough design.

```
User Goal
    │
    ▼
┌─────────────┐
│ ORCHESTRATOR │
└──────┬──────┘
       │
       ├── 1. @explorer ──────► analysis artifact
       │
       ├── 2. @proposer ──────► proposal artifact
       │                        🚧 USER GATE (approve approach)
       │
       ├── 3. @spec-writer ───► spec artifact
       │
       ├── 4. @designer ──────► design artifact
       │
       ├── 5. @task-planner ──► tasks artifact
       │                        🚧 USER GATE (approve plan)
       │
       ├── 6. @implementer ───► patch artifact (writes code)
       │
       ├── 7. @verifier ──────► verification artifact (runs tests)
       │
       └── 8. @archiver ──────► closure artifact
```

**Usage:** `/flow <goal description>`

### `/flow-lite` — Lightweight Workflow (6 phases)

Skips `spec-writer` and `designer` phases. Good for well-understood changes, bug fixes, or tasks where detailed specification/design isn't needed.

| Phase | Subagent       | Gate? |
|-------|----------------|-------|
| 1     | `@explorer`    | No    |
| 2     | `@proposer`    | Yes   |
| 3     | `@task-planner`| Yes   |
| 4     | `@implementer` | No    |
| 5     | `@verifier`    | No    |
| 6     | `@archiver`    | No    |

**Usage:** `/flow-lite <goal description>`

### `/flow-verify` — Verification Only

Verifies an existing change against acceptance criteria. If no spec exists, one is generated first.

1. (Optional) `@spec-writer` drafts a minimal spec from the goal
2. `@verifier` checks the repo state against acceptance criteria
3. `@archiver` produces a closure report

**Usage:** `/flow-verify <goal or change description>`

---

## Agents

### Primary Agents

| Agent | Description | Tools |
|-------|-------------|-------|
| **LucasG** | Default conversational agent. Senior Architect mentor persona. Works in plan-first mode — never implements without explicit confirmation. Responds in user's language (Rioplatense Spanish / English). | `edit`, `write` |
| **orchestrator** | Delegate-only coordinator. Invokes subagents in sequence, validates JSON output, enforces user gates, tracks workflow state. Never does phase work itself. | None |

### SSD Pipeline Agents

Each agent produces a strict JSON artifact that feeds into the next phase.

| Agent | Role | Input | Output Artifact | Tools |
|-------|------|-------|-----------------|-------|
| **explorer** | Repo analysis & discovery | Goal | `analysis` — current state, change surface, unknowns, risks, recommended next inputs | None |
| **proposer** | Solution options | Goal + analysis | `proposal` — 2-4 options with pros/cons, recommendation, non-goals, open questions | None |
| **spec-writer** | Specification | Goal + proposal | `spec` — requirements, acceptance criteria, edge cases, constraints, observability, rollout | None |
| **designer** | Technical design | Spec | `design` — architecture overview, data flow, interfaces/contracts, data model, error handling, security | None |
| **task-planner** | Execution planning | Spec + design | `tasks` — milestones with ordered tasks, dependencies, DoD, test plan, rollback plan | None |
| **implementer** | Code implementation | Tasks + repo context | `patch` — changes list, how to run, tests added, migration notes, remaining work | `bash`, `edit`, `write` |
| **verifier** | Verification | Spec + patch | `verification` — checks with pass/fail/not_run, acceptance criteria coverage, issues, recommendations | `bash` |
| **archiver** | Closure | All artifacts | `closure` — change summary, files touched, risk review, follow-ups, release notes | None |

### Domain Specialist Agents

Standalone experts with full tool access, designed for domain-specific tasks. They follow a **skill-first** pattern: run project-specific skill commands before applying global knowledge.

| Agent | Domain | Tools | Skill |
|-------|--------|-------|-------|
| **SEO-Specialist** | Technical SEO, Core Web Vitals, Schema.org, metadata, international SEO, news SEO | `bash`, `edit`, `write`, `read` | `/seo` |
| **WordPress-Specialist** | Themes, plugins, Gutenberg, performance, security, WP-CLI, REST API, WPGraphQL | `bash`, `edit`, `write`, `read` | `/wordpress` |
| **datadog-metrics** | Datadog dashboards, monitors, metrics analysis, log queries, incident triage | `bash`, `read` | — |

---

## Tool Access Matrix

Follows strict **principle of least privilege**: only the implementer writes code, only the verifier runs tests, thinking agents have no tools.

| Agent | bash | edit | write | read |
|-------|:----:|:----:|:-----:|:----:|
| LucasG | — | yes | yes | — |
| orchestrator | no | no | no | — |
| explorer | no | no | no | — |
| proposer | no | no | no | — |
| spec-writer | no | no | no | — |
| designer | no | no | no | — |
| task-planner | no | no | no | — |
| **implementer** | **yes** | **yes** | **yes** | — |
| **verifier** | **yes** | no | no | — |
| archiver | no | no | no | — |
| **SEO-Specialist** | **yes** | **yes** | **yes** | **yes** |
| **WordPress-Specialist** | **yes** | **yes** | **yes** | **yes** |
| **datadog-metrics** | **yes** | no | no | **yes** |

---

## Artifact Schema Reference

Every subagent outputs strict JSON. Invalid JSON triggers a re-run of the subagent with corrections.

### analysis (explorer)

```json
{
  "agent": "EXPLORER",
  "artifacts": [{
    "kind": "analysis",
    "content": {
      "current_state": "...",
      "change_surface": "...",
      "unknowns": "...",
      "risks": "...",
      "recommended_next_inputs": "..."
    }
  }]
}
```

### proposal (proposer)

```json
{
  "agent": "PROPOSER",
  "artifacts": [{
    "kind": "proposal",
    "content": {
      "options": [{ "name": "", "approach": "", "pros": [], "cons": [], "risks": [] }],
      "recommendation": { "option": "", "why": "", "key_decisions": [] },
      "non_goals": [],
      "open_questions": []
    }
  }]
}
```

### spec (spec-writer)

```json
{
  "agent": "SPEC_WRITER",
  "artifacts": [{
    "kind": "spec",
    "content": {
      "requirements": [],
      "acceptance_criteria": [],
      "edge_cases": [],
      "constraints": {},
      "observability": {},
      "rollout": {}
    }
  }]
}
```

### design (designer)

```json
{
  "agent": "DESIGNER",
  "artifacts": [{
    "kind": "design",
    "content": {
      "architecture_overview": "...",
      "data_flow": "...",
      "interfaces": "...",
      "data_model": "...",
      "error_handling": "...",
      "security_considerations": "..."
    }
  }]
}
```

### tasks (task-planner)

```json
{
  "agent": "TASK_PLANNER",
  "artifacts": [{
    "kind": "tasks",
    "content": {
      "milestones": [{
        "name": "",
        "tasks": [{
          "id": "",
          "title": "",
          "description": "",
          "dependencies": [],
          "definition_of_done": ""
        }]
      }],
      "test_plan_outline": "...",
      "rollback_plan": "..."
    }
  }]
}
```

### patch (implementer)

```json
{
  "agent": "IMPLEMENTER",
  "artifacts": [{
    "kind": "patch",
    "content": {
      "changes": [{ "file": "", "summary": "" }],
      "how_to_run": "...",
      "tests_added_or_updated": [],
      "migration_notes": "...",
      "remaining_work": "..."
    }
  }]
}
```

### verification (verifier)

```json
{
  "agent": "VERIFIER",
  "artifacts": [{
    "kind": "verification",
    "content": {
      "checks": [{ "name": "", "result": "pass|fail|not_run", "evidence": "" }],
      "acceptance_criteria_coverage": {},
      "issues_found": [{ "severity": "", "description": "", "hint": "" }],
      "recommendations": []
    }
  }]
}
```

### closure (archiver)

```json
{
  "agent": "ARCHIVER",
  "artifacts": [{
    "kind": "closure",
    "content": {
      "change_summary": "...",
      "files_touched": [],
      "risk_review": "...",
      "follow_ups": [],
      "release_notes": "..."
    }
  }]
}
```

---

## Configuration

### opencode.json

```json
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "LucasG",
  "permission": {
    "skill": {
      "bolavip-platform": "allow",
      "seo": "allow",
      "*": "deny"
    }
  },
  "mcp": {
    "jira": {
      "type": "remote",
      "url": "https://mcp.atlassian.com/v1/mcp/authv2",
      "enabled": true
    },
    "datadog": {
      "type": "remote",
      "url": "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp"
    }
  }
}
```

- **Default agent**: `LucasG` — the conversational mentor agent
- **Skills**: Only `bolavip-platform` and `seo` are allowed by default; all others denied
- **MCP — Jira**: Atlassian remote MCP for issue and project management
- **MCP — Datadog**: Datadog remote MCP for metrics, monitors, logs, and dashboards

### Dependencies

- `@opencode-ai/plugin` v1.3.2 — OpenCode plugin SDK
- `zod` — Schema validation (transitive dependency)

---

## Design Principles

1. **Separation of concerns** — Each agent has a single responsibility. Thinking agents can't write code. The implementer can't verify. The orchestrator can't do phase work.

2. **Principle of least privilege** — Agents only get the tools they need. Most agents have zero tool access; only the implementer and verifier can interact with the file system.

3. **Strict contracts** — All inter-agent communication is strict JSON with defined schemas. Invalid output triggers automatic re-runs, not fallbacks.

4. **Human-in-the-loop** — User gates at proposal (approach approval) and task plan (implementation approval) ensure the human stays in control of key decisions.

5. **Progressive depth** — Three flow variants (`/flow`, `/flow-lite`, `/flow-verify`) let you choose the right level of rigor for the task at hand.

6. **Stack-agnostic thinking** — Spec, design, and planning phases are deliberately stack-agnostic. Implementation details only appear in the implementer phase.
