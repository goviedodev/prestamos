# MEMORY.md - Memoria del Proyecto

## Contexto

Aplicación de gestión de préstamos personales construida con Elixir, Phoenix LiveView, SQLite y Docker.

## Stack Tecnológico

| Componente | Tecnología | Versión |
|-----------|-----------|---------|
| Lenguaje | Elixir | 1.18.2 |
| Framework | Phoenix | 1.8.4 |
| Frontend | Phoenix LiveView | 1.1 |
| Base de datos | SQLite | via ecto_sqlite3 |
| ORM | Ecto | con adapter SQLite3 |
| Contenedor | Docker | 29.2.1 |
| Servidor web | Bandit | 1.5 |

## Decisiones técnicas

1. **SQLite en lugar de PostgreSQL**: Se eligió SQLite por simplicidad - no requiere servidor de base de datos separado, perfecto para una app local en notebook.
2. **LiveView sin JavaScript**: Toda la interactividad (CRUD, toggle pagado) se maneja con LiveView, sin escribir JS.
3. **Docker multi-stage**: La imagen de producción es liviana (~50MB) separando build de runtime.
4. **Volumen Docker**: La base de datos SQLite persiste en un volumen Docker separado.

## Estructura del proyecto

```
prestamos/
├── lib/
│   ├── prestamos/
│   │   ├── application.ex    # OTP Application
│   │   ├── repo.ex           # Ecto Repo (SQLite)
│   │   └── loans/
│   │       └── loan.ex       # Schema Loan
│   ├── prestamos_web/
│   │   ├── router.ex          # Rutas LiveView
│   │   ├── endpoint.ex        # Endpoint Phoenix
│   │   ├── live/loan_live/    # LiveView CRUD
│   │   └── components/        # Layouts y componentes
│   └── prestamos_web.ex
├── config/                    # Config por entorno
├── Dockerfile                 # Multi-stage build
├── docker-compose.yml         # Orquestación Docker
├── AGENTS.md
├── MEMORY.md
└── LEARNINGS.md
```
