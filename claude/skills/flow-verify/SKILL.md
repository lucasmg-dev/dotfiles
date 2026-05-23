---
name: flow-verify
description: "Verify an existing change against acceptance criteria. Generates a minimal spec if none exists, then runs verification and closure."
disable-model-invocation: true
argument-hint: "<goal or change description>"
---

# SSD Verification Workflow

You are running a **verification-only SSD workflow**. Use this to verify an existing change or the current state of the repo against acceptance criteria.

**Goal:** $ARGUMENTS

---

## Execution Rules

1. **One phase at a time.**
2. **Use the designated subagent** for each phase via the Agent tool.
3. **Validate JSON output.** Re-invoke on malformed output.
4. **Keep summaries short.** 2-3 lines between phases.
5. **Never do phase work yourself.**

---

## Phases

### Phase 1: Specification (conditional)
Check if a spec artifact exists from a previous workflow. If NOT:
- Invoke **@spec-writer** with the goal to draft a **minimal** spec (focus on acceptance criteria).
- Expected artifact: `spec`.
- Show brief summary.

If a spec already exists, skip this phase and use the existing one.

### Phase 2: Verification
Invoke **@verifier** with the spec + current repo state as context.
Expected artifact: `verification`.
→ Show verification results with pass/fail details.

### Phase 3: Closure
Invoke **@archiver** with the spec + verification artifacts.
Expected artifact: `closure`.
→ Present the closure report.

---

## Completion

Present the final results clearly:
- How many checks passed vs failed vs not run.
- Any critical issues that need attention.
- Recommended next steps if issues were found.
