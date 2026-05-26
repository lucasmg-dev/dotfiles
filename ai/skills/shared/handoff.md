---
name: handoff
description: |
  Isolate a topic discovered during the current session into a standalone
  markdown file so it can be continued in a fresh session without polluting
  the current one. Use when asked to "handoff", "isolate topic", "spin off",
  or "park this for later". Supports `/handoff list` to view existing handoffs.
---

# /handoff — Isolate a Topic for a New Session

You are a **session curator**. Your job is to extract a topic that emerged during
the current session, package it with enough context to be self-contained, and
save it so the user can pick it up in a separate session.

**HARD GATE:** Do NOT implement code changes. This skill captures context only.

---

## Detect command

Parse the user's input:

- `/handoff` → **Create** (ask for topic)
- `/handoff <description>` → **Create** (use description as isolated topic)
- `/handoff list` → **List**

---

## Create flow

### Step 1: Determine the isolated topic

If the user provided a description after `/handoff`, use it as the isolated topic.

If not, ask:

> ¿Qué tema querés aislar de esta sesión?

Wait for the answer. Do NOT continue until you have it.

### Step 2: Determine the origin topic

Infer from conversation context what was being worked on before this subtopic
emerged. If it's not clear from context, ask briefly:

> ¿De qué tema principal surge esto?

### Step 3: Gather session context

```bash
echo "=== BRANCH ==="
git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown"
echo "=== CWD ==="
basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
```

### Step 4: Generate file path

```bash
mkdir -p ~/.lucasg-stack/docs/handoffs
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
# Pass the isolated topic as TITLE_RAW env var
RAW="${TITLE_RAW:-untitled}"
SLUG=$(printf '%s' "$RAW" | tr '[:upper:]' '[:lower:]' | tr -s ' \t' '-' | tr -cd 'a-z0-9.-' | cut -c1-60)
SLUG="${SLUG:-untitled}"
FILE="$HOME/.lucasg-stack/docs/handoffs/${TIMESTAMP}-${SLUG}.md"
if [ -e "$FILE" ]; then
  SUFFIX=$(LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom 2>/dev/null | head -c 4 || printf '%04x' "$$")
  FILE="$HOME/.lucasg-stack/docs/handoffs/${TIMESTAMP}-${SLUG}-${SUFFIX}.md"
fi
echo "FILE=$FILE"
```

### Step 5: Write the handoff file

Write to the `$FILE` path from Step 4. Format:

```markdown
---
origin_topic: "<tema original>"
isolated_topic: "<tema aislado>"
created: <ISO-8601 timestamp>
source_session: "<branch or workspace>"
---

## Context

<1-3 sentences: de dónde surge este tema, por qué se aisla de la sesión actual>

## Topic to Continue

<Descripción clara del tema aislado con suficiente contexto para que una sesión
nueva pueda arrancar sin conocer la sesión original>

## Relevant Decisions / Discoveries

- <Decisiones o descubrimientos hechos sobre este tema en la sesión actual>

## Suggested Next Steps

1. <Paso concreto>
2. <Paso concreto>
```

### Step 6: Confirm to user

```
HANDOFF CREATED
════════════════════════════════════════
Topic:    {isolated topic}
From:     {origin topic}
File:     {path to file}
════════════════════════════════════════

Podés levantar este handoff en una nueva sesión
apuntando al archivo generado.
```

---

## List flow

### Step 1: Gather handoffs

```bash
HANDOFF_DIR="$HOME/.lucasg-stack/docs/handoffs"
if [ -d "$HANDOFF_DIR" ]; then
  find "$HANDOFF_DIR" -maxdepth 1 -name "*.md" -type f 2>/dev/null | sort -r
else
  echo "NO_HANDOFFS"
fi
```

### Step 2: Display table

Read the frontmatter of each file to extract `isolated_topic`, `origin_topic`,
and `created`. Present as:

```
HANDOFFS
════════════════════════════════════════
#  Date        Isolated Topic           From
─  ──────────  ───────────────────────  ──────────────────
1  2026-05-26  feature-x-auth           migration-project
2  2026-05-25  cache-invalidation       api-redesign
════════════════════════════════════════
```

If no handoffs exist:

> No hay handoffs creados. Usá `/handoff` para aislar un tema de la sesión actual.

---

## Rules

- **Never modify code.** This skill only reads context and writes the handoff file.
- **Files are append-only.** Never overwrite or delete existing handoff files.
- **Tool-agnostic.** Do not suggest a specific CLI tool to open the new session.
  Just indicate the file path.
- **Ask if unclear.** If the user doesn't specify the topic to isolate, ask once.
  Do not interrogate further.
- **Self-contained output.** The generated markdown must have enough context for
  a fresh session to understand the topic without access to the original session.
