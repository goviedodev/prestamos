# LEARNINGS.md - Lecciones Aprendidas

## Lecciones técnicas

### 1. Phoenix con SQLite
- Usar `ecto_sqlite3` en lugar de `postgrex` requiere cambiar el adapter en la configuración del Repo.
- La migración inicial debe crearse manualmente (no hay `mix phx.gen.schema` que funcione out-of-the-box con SQLite sin configuración extra).
- SQLite no requiere servidor - la base de datos es solo un archivo.

### 2. LiveView CRUD
- LiveView con `live_action` (`:index`, `:new`, `:edit`) permite manejar toda la navegación CRUD en un solo módulo.
- `handle_params/3` se ejecuta después de `mount/3` y cuando cambia la URL.
- Para formularios, `to_form(changeset)` simplifica la integración con Ecto.

### 3. Docker para Elixir
- Build multi-stage: imagen de build con herramientas de compilación, imagen final solo con runtime.
- Necesario incluir `sqlite` como runtime dependency en Alpine.
- La aplicación debe configurarse con `DATABASE_PATH` para persistencia.

### 4. Renombrado de proyecto Phoenix
- Al generar con `mix phx.new`, el nombre se incrusta en múltiples archivos.
- Más eficiente usar `sed` para reemplazar todas las ocurrencias que renombrar manualmente.

## Mejoras futuras
- Agregar autenticación básica
- Agregar búsqueda/filtros
- Agregar exportación a CSV
- Usar Litestream para backups automáticos
