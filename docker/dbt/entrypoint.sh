#!/usr/bin/env bash
# Build the local warehouse, then stop. The dashboard starts only after this exits 0.
set -euo pipefail

cd /usr/app/ae_prototype

echo "dbt target: ${DBT_TARGET:-local}"
echo "warehouse: ${POSTGRES_HOST:-localhost}:${POSTGRES_PORT:-5432}/${POSTGRES_DB:-northwind}"

python - << 'PY'
import os
import socket
import sys
import time

host = os.environ.get("POSTGRES_HOST", "localhost")
port = int(os.environ.get("POSTGRES_PORT", "5432"))
for attempt in range(30):
    try:
        socket.create_connection((host, port), 2).close()
        break
    except OSError:
        time.sleep(1)
else:
    sys.exit(f"warehouse at {host}:{port} did not accept connections")
PY

dbt run --target "${DBT_TARGET:-local}"
dbt test --target "${DBT_TARGET:-local}"

echo "dbt run and dbt test finished."
