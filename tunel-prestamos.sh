#!/usr/bin/env bash
set -euo pipefail

LOCAL_PORT=14000
REMOTE_HOST="prestamos"
REMOTE_PORT=14000
SSH_USER="goviedo"
SSH_KEY="${HOME}/.ssh/id_acer"

# Si el contenedor Docker local prestamos-app está ocupando el puerto 14000, detenerlo
if docker ps --format '{{.Names}}' 2>/dev/null | grep -qx "prestamos-app"; then
    echo "Deteniendo contenedor local prestamos-app para liberar el puerto ${LOCAL_PORT}..."
    docker stop prestamos-app >/dev/null
fi

# Si ya existe un túnel SSH previo en el puerto 14000, cerrarlo antes de abrir uno nuevo
pkill -f "ssh.*${LOCAL_PORT}:${REMOTE_HOST}:${REMOTE_PORT}" 2>/dev/null || true

echo "Abriendo túnel SSH: 0.0.0.0:${LOCAL_PORT} (gonzalo-asus:${LOCAL_PORT}) -> ${REMOTE_HOST}:${REMOTE_PORT}..."
ssh -f -N \
    -i "${SSH_KEY}" \
    -o ExitOnForwardFailure=yes \
    -o ServerAliveInterval=30 \
    -o ServerAliveCountMax=3 \
    -L "0.0.0.0:${LOCAL_PORT}:${REMOTE_HOST}:${REMOTE_PORT}" \
    "${SSH_USER}@${REMOTE_HOST}"

echo "✅ Túnel activo. Puedes acceder desde Tailscale en: http://gonzalo-asus:${LOCAL_PORT}"
