# GitLab inline review comments

## Objetivo

Crear comentarios de review **anclados al diff** en GitLab, no notas generales.

## Flujo recomendado

1. Obtener metadata del MR:

```bash
glab api "projects/<project_id>/merge_requests/<iid>"
```

Tomar de ahí:

- `diff_refs.base_sha`
- `diff_refs.start_sha`
- `diff_refs.head_sha`

2. Obtener cambios del MR:

```bash
glab api "projects/<project_id>/merge_requests/<iid>/changes"
```

3. Confirmar archivo y línea del diff.

4. Crear discusión inline usando JSON body.

## Payload confiable

```json
{
  "body": "Comentario de review",
  "position": {
    "position_type": "text",
    "base_sha": "<base_sha>",
    "start_sha": "<start_sha>",
    "head_sha": "<head_sha>",
    "old_path": "src/server.ts",
    "new_path": "src/server.ts",
    "new_line": 61
  }
}
```

## Ejemplo con glab + JSON

```bash
python3 - <<'PY'
import json, subprocess, tempfile, os

payload = {
  'body': 'En `src/server.ts`, `startAll()` se ejecuta sin `await`...',
  'position': {
    'position_type': 'text',
    'base_sha': '<base_sha>',
    'start_sha': '<start_sha>',
    'head_sha': '<head_sha>',
    'old_path': 'src/server.ts',
    'new_path': 'src/server.ts',
    'new_line': 61,
  }
}

fd, path = tempfile.mkstemp(suffix='.json')
os.close(fd)
with open(path, 'w') as f:
    json.dump(payload, f)

try:
    out = subprocess.check_output([
        'glab', 'api', 'projects/<project_id>/merge_requests/<iid>/discussions',
        '--method', 'POST',
        '--input', path,
        '-H', 'Content-Type: application/json'
    ], text=True)
    print(out)
finally:
    os.unlink(path)
PY
```

## Cómo validar que quedó bien

La respuesta correcta debe incluir algo así:

```json
{
  "notes": [
    {
      "type": "DiffNote",
      "position": {
        "new_line": 61,
        "new_path": "src/server.ts"
      }
    }
  ]
}
```

Si la nota no tiene `type: DiffNote` y no tiene `position`, quedó como comentario general.

## Limpieza de comentarios mal creados

Borrar una nota general duplicada:

```bash
glab api "projects/<project_id>/merge_requests/<iid>/notes/<note_id>" --method DELETE
```

## Heurísticas útiles

- Para archivos nuevos, `old_path` y `new_path` pueden ser iguales en este flujo y GitLab igual ancla bien si la posición es válida.
- Si la línea exacta no existe en el diff actual, GitLab no la va a anclar.
- Si el comentario apunta a una idea que nace en varias líneas, anclar al punto más representativo del bloque.

## Plantilla de comentario

```md
En `<archivo>`, este cambio introduce <problema>. En <escenario>, eso podría causar <impacto real>.

**Sugerencia:** considerar <dirección de fix>.
```
