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

### 5. Despliegue en FreeBSD Jail (`iocage`)
- `DATABASE_PATH` debe leerse en `config/runtime.exs` para que los releases (`mix release`) usen la ruta de base de datos en tiempo de ejecución y no la de compilación.
- En jails sin IPv6 asignado (`ip6=-`), Bandit debe escuchar en IPv4 `{0, 0, 0, 0}` en lugar de `{0, 0, 0, 0, 0, 0, 0, 0}`.
- En jails no-VNET cuando el host usa `local_unbound` (`127.0.0.1`), es necesario configurar `resolver="nameserver 192.168.100.1;nameserver 8.8.8.8"` en `iocage`.
- Cuando el pool ZFS de `iocage` (`goljailpool`) reside en un archivo (`mdconfig -a -t vnode -f /home/goviedo/iocage_storage`), se requiere un servicio `rc.d` previo a `iocage` para adjuntar el `md` e importar el pool al iniciar el host.
- Para exponer el jail a la red Tailscale de `gonzalo-asus` (`gonzalo-asus:14000`) mediante `ssh -L`, es necesario especificar `0.0.0.0:14000:prestamos:14000` (para que no escuche solo en `127.0.0.1`) y definir `192.168.100.101 prestamos` también en `/etc/hosts` del servidor SSH remoto (`goacer`), ya que `ssh -L` resuelve el host destino desde el servidor SSH.

## Mejoras futuras
- Agregar autenticación básica
- Agregar búsqueda/filtros
- Agregar exportación a CSV
- Usar Litestream para backups automáticos
