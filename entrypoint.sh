#!/bin/sh
set -e

/app/bin/prestamos eval "Prestamos.Release.migrate()"

exec /app/bin/prestamos start
