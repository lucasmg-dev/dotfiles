---
name: flow
description: "Run the full 8-phase SSD (Specification-Driven Development) workflow: explore → propose → specify → design → plan → implement → verify → archive"
disable-model-invocation: true
argument-hint: "<goal description>"
---

# SSD Full Workflow

You are now running a **Specification-Driven Development (SSD)** pipeline. Execute the following 8 phases in strict order for this goal:

**Goal:** $ARGUMENTS

---

## Execution Rules

1. **One phase at a time.** Complete each phase before starting the next.
2. **Use the designated subagent** for each phase via the Agent tool. Pass the goal AND all relevant previous artifacts as context.
3. **Validate JSON output.** Every subagent MUST return strict JSON with `agent`, `artifacts[0].kind`, and `artifacts[0].content`. If the output is malformed or missing required fields, re-invoke the same subagent with a correction message.
4. **USER GATES.** At phases marked 🚧, stop and present a summary to the user. Wait for explicit approval before continuing. If the user requests changes, re-run that phase's subagent with the feedback.
5. **Keep summaries short.** Between phases, show a 2-3 line summary of what the subagent produced. Do NOT repeat the full JSON to the user.
6. **Pass artifacts forward.** Each subagent needs the previous artifacts as input context. Include the raw JSON from previous phases in your prompt to the next subagent.
7. **Never do phase work yourself.** You orchestrate. The subagents do the work.

---

## Phases

### Phase 1: Exploration
Invoke **@explorer** with the goal.
Expected artifact: `analysis` (current_state, change_surface, unknowns, risks).
→ Show brief summary, then proceed.

### Phase 2: Proposal 🚧 USER GATE
Invoke **@proposer** with the goal + analysis artifact.
Expected artifact: `proposal` (options, recommendation, non_goals).
→ Present the recommended option and alternatives to the user.
→ **STOP and wait for user approval before continuing.**

### Phase 3: Specification
Invoke **@spec-writer** with the goal + approved proposal.
Expected artifact: `spec` (requirements, acceptance_criteria, edge_cases, constraints).
→ Show brief summary, then proceed.

### Phase 4: Design
Invoke **@designer** with the spec artifact.
Expected artifact: `design` (architecture, data_flow, interfaces, error_handling).
→ Show brief summary, then proceed.

### Phase 5: Task Planning 🚧 USER GATE
Invoke **@task-planner** with the spec + design artifacts.
Expected artifact: `tasks` (milestones with ordered tasks, test_plan, rollback_plan).
→ Present the milestone/task summary to the user.
→ **STOP and wait for user approval before implementing.**

### Phase 6: Implementation
Invoke **@implementer** with the tasks artifact + repo context.
Expected artifact: `patch` (changes, how_to_run, tests, migration_notes).
→ Show brief summary of files changed, then proceed.

### Phase 7: Verification
Invoke **@verifier** with the spec + patch artifacts.
Expected artifact: `verification` (checks with pass/fail, issues_found, recommendations).
→ Show verification results summary, then proceed.

### Phase 8: Closure
Invoke **@archiver** with all previous artifacts.
Expected artifact: `closure` (change_summary, files_touched, risk_review, release_notes).
→ Present the final closure report to the user.

---

## Completion

After Phase 8, present the closure report and confirm the workflow is complete. If the verifier found critical issues, flag them prominently and ask the user if they want to re-run implementation.
