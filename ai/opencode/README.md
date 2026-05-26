# OpenCode — Configuration

Configuration for [OpenCode CLI](https://opencode.ai).

---

## Directory Structure

```
opencode/
├── opencode.json       # Main config (default agent, MCP servers, permissions)
├── package.json        # Dependencies (@opencode-ai/plugin SDK)
├── package-lock.json   # Locked dependency versions
└── skills/             # (empty — shared skills live in ai/skills/shared/)
```

---

## MCP Integrations

| Server  | Purpose                              |
|---------|--------------------------------------|
| Jira    | Issue and project management         |
| Datadog | Metrics, monitors, logs, dashboards  |

---

## Shared Skills

Skills shared across tools (OpenCode, Claude) live in `ai/skills/shared/`:

| Skill    | Description                                       |
|----------|---------------------------------------------------|
| handoff  | Isolate a topic for continuation in a new session |
