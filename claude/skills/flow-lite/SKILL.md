---
name: flow-lite
description: "Run a lighter 6-phase SSD workflow (skip spec and design): explore → propose → plan → implement → verify → archive"
disable-model-invocation: true
argument-hint: "<goal description>"
---

# SSD Lite Workflow

You are now running a **lightweight Specification-Driven Development (SSD)** pipeline. This skips the specification and design phases — use it for well-understood changes, bug fixes, or tasks where detailed spec/design isn't needed.

**Goal:** $ARGUMENTS

---

## Execution Rules

1. **One phase at a time.** Complete each phase before starting the next.
2. **Use the designated subagent** for each phase via the Agent tool. Pass the goal AND all relevant previous artifacts as context.
3. **Validate JSON output.** Every subagent MUST return strict JSON with `agent`, `artifacts[0].kind`, and `artifacts[0].content`. If malformed, re-invoke with a correction message.
4. **USER GATES.** At phases marked 🚧, stop and present a summary. Wait for explicit approval. If the user requests changes, re-run that subagent.
5. **Keep summaries short.** 2-3 lines between phases. Do NOT dump full JSON to the user.
6. **Pass artifacts forward.** Include previous artifacts as context for the next subagent.
7. **Never do phase work yourself.** You orchestrate. The subagents do the work.

---

## Phases

### Phase 1: Exploration
Invoke **@explorer** with the goal.
Expected artifact: `analysis`.
→ Show brief summary, then proceed.

### Phase 2: Proposal 🚧 USER GATE
Invoke **@proposer** with the goal + analysis artifact.
Expected artifact: `proposal`.
→ Present the recommended option and alternatives.
→ **STOP and wait for user approval.**

### Phase 3: Task Planning 🚧 USER GATE
Invoke **@task-planner** with the goal + proposal (recommendation as lightweight spec/design input).
Expected artifact: `tasks`.
→ Present milestone/task summary.
→ **STOP and wait for user approval.**

### Phase 4: Implementation
Invoke **@implementer** with the tasks artifact + repo context.
Expected artifact: `patch`.
→ Show files changed summary, then proceed.

### Phase 5: Verification
Invoke **@verifier** with the proposal (as lightweight acceptance criteria) + patch artifacts.
Expected artifact: `verification`.
→ Show verification results, then proceed.

### Phase 6: Closure
Invoke **@archiver** with all previous artifacts.
Expected artifact: `closure`.
→ Present the final closure report.

---

## Completion

After Phase 6, present the closure report and confirm the workflow is complete. Flag critical issues from verification prominently.
