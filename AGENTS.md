# AGENTS.md - Agentes del Proyecto Préstamos

## Agentes involucrados en la construcción

| Agente | Rol | Herramientas |
|--------|-----|-------------|
| **Buffy** | Orquestador principal | spawn_agents, read_files, str_replace, write_file |
| **Basher** | Ejecución de comandos de terminal | bash, mix, docker |
| **Researcher Web** | Investigación de dependencias y guías | búsqueda web |
| **File Picker** | Exploración de estructura del proyecto | fuzzy finder |
| **Code Searcher** | Búsqueda de patrones en código | ripgrep |
| **Code Reviewer** | Revisión de calidad del código | análisis de cambios |

## Flujo de trabajo

1. **Planificación** → Investigación de stack y dependencias
2. **Generación** → Creación del proyecto Phoenix
3. **Configuración** → SQLite, Ecto, Repo
4. **Implementación** → Schema, LiveView CRUD, Docker
5. **Revisión** → Code review y validación
6. **Documentación** → AGENTS.md, MEMORY.md, LEARNINGS.md
