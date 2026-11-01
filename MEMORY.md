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
5. **Despliegue en FreeBSD Jail (`iocage`)**: La aplicación también corre de forma nativa en un jail `iocage` llamado `prestamos` (`192.168.100.101:14000`) en el servidor FreeBSD `goacer` (`192.168.100.97`), administrada mediante el servicio `/usr/local/etc/rc.d/prestamos` y con la base de datos en `/var/db/prestamos/prestamos.db`.

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
├── tunel-prestamos.sh         # Túnel SSH 0.0.0.0:14000 -> prestamos:14000
├── AGENTS.md
├── MEMORY.md
└── LEARNINGS.md
```

## Infraestructura y Despliegue Actual (FreeBSD Jail + Tailscale)

### 1. Servidor FreeBSD `goacer` (`192.168.100.97`)
- **Acceso SSH**: `/home/goviedo/.local/bin/acer` (`ssh -i ~/.ssh/id_acer goviedo@192.168.100.97` o `goviedo@prestamos`).
- **ZFS Pool de Jails**: `goljailpool` montado sobre imagen `/home/goviedo/iocage_storage` (`md0`) mediante el servicio `/usr/local/etc/rc.d/goljailpool` (`goljailpool_enable="YES"` e `iocage_enable="YES"` en `/etc/rc.conf`).
- **Jail `iocage`**:
  - **Nombre**: `prestamos` (`15.1-RELEASE-p6`, `boot=on`)
  - **IP**: `wlan0|192.168.100.101` (alias `prestamos` en `/etc/hosts` tanto en `gonzalo-asus` como en `goacer`)
  - **Release Elixir**: `/usr/local/prestamos` (código fuente en `/usr/local/src/prestamos`)
  - **Base de datos SQLite**: `/var/db/prestamos/prestamos.db`
  - **Servicio `rc.d`**: `/usr/local/etc/rc.d/prestamos` (`prestamos_enable="YES"`), logs en `/var/log/prestamos.log`
  - **Puerto**: `14000`

### 2. Acceso remoto vía Tailscale (`gonzalo-asus:14000`)
- El contenedor Docker local `prestamos-app` en `gonzalo-asus` (`192.168.100.14`) se mantiene detenido para liberar el puerto `14000`.
- El script `/home/goviedo/servicios/prestamos/tunel-prestamos.sh` abre un túnel SSH local (`ssh -L 0.0.0.0:14000:prestamos:14000 goviedo@prestamos`) en `gonzalo-asus`.
- Esto permite acceder desde internet por Tailscale usando `http://gonzalo-asus:14000` (IP Tailscale `100.107.71.126`), redirigiendo el tráfico transparente hacia el jail `prestamos` (`192.168.100.101:14000`).

### 3. Referencia Cloudflare (`limachelocales.cl`)
- **Cuenta**: `gonzalo.oviedo.dev@gmail.com` (Account ID: `0e7c015c16da16f0cebace036c8495c8`)
- **Tunnel ID (`limachelocales.cl`)**: `d06ffb23-e3c2-4356-bca7-07df8d928ccb`
- **Dominio histórico**: `prestamos.limachelocales.cl` (actualmente deshabilitado; el acceso activo es vía Tailscale `http://gonzalo-asus:14000` o LAN `http://192.168.100.101:14000`).
