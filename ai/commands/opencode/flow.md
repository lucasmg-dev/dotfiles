---
description: "Run a generic multi-agent workflow (Agent Teams Lite)"
agent: orchestrator
---

Goal: $ARGUMENTS

Run phases in order:
1) @explorer -> analysis JSON
2) @proposer -> proposal JSON (ask user approval to continue)
3) @spec-writer -> spec JSON
4) @designer -> design JSON
5) @task-planner -> tasks JSON (ask user approval to implement)
6) @implementer -> patch JSON
7) @verifier -> verification JSON
8) @archiver -> closure JSON

Rules:
- Orchestrator must not do phase work itself.
- Subagents must output strict JSON only.
- If invalid JSON: re-run that subagent with corrections.
- Keep main thread minimal: phase summaries + approvals.

