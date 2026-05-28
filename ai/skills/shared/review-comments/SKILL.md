---
name: review-comments
description: Crear y publicar comentarios de review para PRs/MRs con buenas prácticas, priorizando comentarios accionables anclados a líneas específicas; usar especialmente para GitLab con glab y discusiones inline tipo DiffNote.
metadata:
  short-description: Comentarios de review inline para PR/MR
---

# Review Comments

Usá esta skill para convertir hallazgos en comentarios de review **publicables** en PR/MR, especialmente en **GitLab con `glab`**.

## Reglas de oro

1. **Siempre comentar inline si el hallazgo pertenece a una línea o bloque del diff.**
   - No dejar comentarios generales si se puede anclar.
   - En GitLab, el objetivo es `DiffNote`, no nota general.

2. **Solo marcar problemas reales.**
   - No inventar edge cases.
   - No elevar preferencias de estilo a bugs.
   - Si no hay certeza, investigar o redactar como duda.

3. **Todo comentario debe incluir impacto.**
   - Qué se rompe.
   - En qué escenario.
   - Qué riesgo real introduce.

4. **Todo comentario debe incluir sugerencia.**
   - No hace falta resolverlo completo.
   - Sí hace falta orientar el fix.
   - La sugerencia debe ir en un **párrafo aparte**.
   - La redacción debe tener enfoque **colaborativo** ("propongo", "podríamos", "te sugiero"), sin fórmulas fijas.

5. **No dejar ruido.**
   - Si se creó una nota general por error y luego se crea la inline correcta, borrar la general.
   - Borrar notas de prueba.

6. **Ser concreto, sin exceso de formato.**
   - Priorizar comentarios breves y directos.
   - Evitar plantillas largas, secciones o encabezados innecesarios.
   - Escribir en texto corrido en 2-5 líneas.

## Formato recomendado del comentario

Comentario corto en texto corrido:

- Qué cambio genera el problema.
- Impacto real.
- Sugerencia en párrafo aparte y tono colaborativo.

Ejemplo:

En `foo.ts`, esta rama hace `continue` cuando falla la deserialización. El impacto es que ese evento puede quedar fuera del resultado y no reintentarse.

Podríamos acumular esos fallos y devolverlos explícitamente en el resultado del batch.

## Workflow recomendado

1. Revisar diff + archivo completo.
2. Confirmar que el problema está en código modificado.
3. Identificar archivo y línea exactos.
4. Redactar comentario breve, técnico y accionable.
5. Publicar inline.
6. Verificar que GitLab lo haya guardado como `DiffNote`.
7. Limpiar duplicados o pruebas.

## GitLab con glab: buenas prácticas

### Regla práctica

Con `glab api`, pasar `position[...]` por flags puede terminar creando una discusión **sin posición persistida**. El resultado: aparece como comentario general aunque “parezca” inline.

**Patrón confiable:** mandar un **JSON body completo** con `--input` y `Content-Type: application/json`.

Campos mínimos del payload:

- `body`
- `position.position_type = text`
- `position.base_sha`
- `position.start_sha`
- `position.head_sha`
- `position.old_path`
- `position.new_path`
- `position.new_line` o `position.old_line`

### Validación obligatoria

Después de crear el comentario, confirmar:

- `notes[0].type = "DiffNote"`
- `notes[0].position` presente
- `position.new_line` o `position.old_line` con valor

Si eso no aparece, **no quedó anclado**.

## Checklist rápido

- [ ] El comentario habla de un problema real y no de preferencia personal
- [ ] Está redactado en tono profesional
- [ ] Incluye impacto concreto
- [ ] Incluye sugerencia
- [ ] Está anclado al archivo/línea correctos
- [ ] La respuesta de GitLab confirma `DiffNote`
- [ ] No quedaron comentarios generales duplicados

## Cuándo dejar comentario general

Solo si el hallazgo:

- afecta varios archivos a la vez
- es sobre la estrategia del MR completo
- no se puede asociar honestamente a una línea puntual del diff

Si se puede asociar a una línea, se comenta inline. **Sin excepción práctica.**

## Referencias

- Para payloads y ejemplos concretos de GitLab inline comments, leer `references/gitlab-inline-comments.md`.
