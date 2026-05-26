# ai/

Configuración centralizada de asistentes AI. El humano dirige, la AI ejecuta.

## Filosofía

- **Plan before code** — La AI analiza y propone antes de implementar. Solo codea con confirmación explícita.
- **Personalidad consistente** — Misma voz y reglas sin importar la plataforma.
- **Skills reutilizables** — Workflows compartidos entre plataformas (brainstorming, debugging, TDD).
- **La AI no se atribuye crédito** — Sin `Co-Authored-By`, sin menciones en README ni package.json.

## Estructura

```
ai/
├── agents/          → Personalidades de agentes
│   └── opencode/    → Agentes para OpenCode CLI (LucasG.md)
├── claude/          → Config global de Claude Code (CLAUDE.md)
├── opencode/        → Config de OpenCode CLI (opencode.json, plugins, MCPs)
└── skills/          → Sistema Superpowers
    ├── opencode/    → Skills específicas de OpenCode
    └── shared/      → Skills compartidas entre plataformas
```

## Plataformas soportadas

| Plataforma | Config | Agentes |
|------------|--------|---------|
| Claude Code | `claude/CLAUDE.md` | Personalidad embebida en CLAUDE.md |
| OpenCode CLI | `opencode/opencode.json` | `agents/opencode/*.md` |

## Skills (Superpowers)

Sistema de workflows reutilizables para tareas no triviales. Se activan cuando la tarea tiene 3+ pasos, decisiones de arquitectura, o cambios multi-archivo.

- `skills/shared/` — Skills agnósticas a plataforma (handoff, brainstorming, etc.)
- `skills/opencode/` — Skills específicas de OpenCode

### Cuándo se activan

- Arquitectura, features complejas, debugging, refactoring.
- Si hay duda, se activan.

### Cuándo NO

- Fixes de una línea, config simple, preguntas rápidas.

## Cómo agregar

### Nuevo agente (OpenCode)

Crear `agents/opencode/NombreAgente.md` con frontmatter:

```yaml
---
description: "Descripción corta"
mode: primary
tools:
  write: true
  edit: true
---
```

### Nueva skill compartida

Crear directorio en `skills/shared/nombre-skill/` con el contenido del workflow.

### Nueva plataforma

1. Crear directorio `plataforma/` con su config principal.
2. Agregar directorio en `agents/plataforma/` si soporta agentes.
3. Agregar directorio en `skills/plataforma/` si necesita skills específicas.
