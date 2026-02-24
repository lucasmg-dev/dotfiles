---
description: "Run a lighter workflow (analysis -> proposal -> tasks -> implement -> verify -> close)"
agent: orchestrator
---

Goal: $ARGUMENTS

Run phases:
1) @explorer -> analysis
2) @proposer -> proposal (GATE approval)
3) @task-planner -> tasks (GATE approval)
4) @implementer -> patch
5) @verifier -> verification
6) @archiver -> closure

Same strict JSON rules.

