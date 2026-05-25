---
description: "Verify an existing change against acceptance criteria (spec+patch if available)"
agent: orchestrator
---

Goal: $ARGUMENTS

Process:
- If no spec exists, ask @spec-writer to draft a minimal spec from goal.
- Ask @verifier to verify current repo state against acceptance criteria.
- Ask @archiver to produce a short closure report.

Strict JSON only.
