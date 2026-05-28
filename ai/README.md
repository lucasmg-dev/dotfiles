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

Usamos [Superpowers](https://github.com/obra/superpowers) como sistema de skills reutilizables para tareas no triviales. Se activan cuando la tarea tiene 3+ pasos, decisiones de arquitectura, o cambios multi-archivo.

- `skills/shared/` — Skills agnósticas a plataforma (handoff, brainstorming, etc.)
- `skills/opencode/` — Skills específicas de OpenCode

### Instalación por plataforma

**OpenCode CLI:**

1. Agregar el plugin en `opencode.json`:
   ```json
   {
     "plugin": [
       "superpowers@git+https://github.com/obra/superpowers.git"
     ]
   }
   ```
2. Skills custom se linkean individualmente a `~/.agents/skills/`:
   ```bash
   ln -s /path/to/dotfiles/ai/skills/shared/nombre-skill ~/.agents/skills/nombre-skill
   ```

**Claude Code:**

1. Instalar el plugin:
   ```bash
   claude mcp add superpowers -- npx -y @anthropic-ai/superpowers-cli
   ```
   O agregar manualmente en la config de Claude Code MCP.

2. Agregar la sección de Superpowers en `CLAUDE.md` (ya incluida en este repo).

**Antigravity CLI (agy):**

agy no tiene sistema de plugins, así que las skills van como archivos en disco en `~/.gemini/antigravity-cli/skills/`.

1. Skills de Superpowers — correr el script (clona upstream y las instala; re-correr actualiza a la última versión):
   ```bash
   ai/skills/install-superpowers-agy.sh
   ```
2. Skills custom (handoff, review-comments) — las symlinkea `./install.sh` automáticamente.
   Manual: `ln -s /path/to/dotfiles/ai/skills/shared/<skill> ~/.gemini/antigravity-cli/skills/<skill>`

> El dir `~/.gemini/antigravity-cli/skills/` debe ser una **carpeta real** (no un symlink al repo): ahí conviven las superpowers descargadas con los symlinks a tus skills custom. `install.sh` migra el symlink viejo automáticamente.

### UI/UX Pro Max (skill de terceros)

[ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) no se copia a mano: su CLI oficial (`uipro-cli`) **ensambla** la skill por plataforma (SKILL.md templado + scripts + data). El script la instala en los **3 agentes** a la vez (Claude, OpenCode, agy), ensamblando con el CLI y copiando a cada dir real. Re-correr actualiza:

```bash
ai/skills/install-ui-ux-pro-max.sh        # latest
UIPRO_VERSION=2.5.0 ai/skills/install-ui-ux-pro-max.sh   # pinneado
```

Requiere `npx` (Node.js).

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

1. Crear el directorio en `skills/shared/<nombre-skill>/` con su `SKILL.md` (y archivos de soporte si hace falta).
2. Re-correr `./install.sh` para **cascadear los symlinks** a los tres agentes: `~/.claude/skills/`, `~/.agents/skills/` (OpenCode) y `~/.gemini/antigravity-cli/skills/` (agy).

> Sin esos symlinks la skill vive en el repo pero **no llega a ningún agente**. `install.sh` los crea por vos; si agregás una skill a mano, acordate de linkearla en los tres lugares.

### Nueva plataforma

1. Crear directorio `plataforma/` con su config principal.
2. Agregar directorio en `agents/plataforma/` si soporta agentes.
3. Agregar directorio en `skills/plataforma/` si necesita skills específicas.
