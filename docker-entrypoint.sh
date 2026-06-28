#!/bin/sh
# Hoppscotch Railway Template — Entrypoint
# Runs Prisma migrations (best-effort), then hands off to the original entrypoint.
#
# PORT ENV VAR NOTE:
# The upstream hoppscotch image sets PORT=8080 by default. This is the port
# the NestJS backend listens on — Caddy:3170 reverse-proxies to localhost:8080.
# Railway overrides PORT for service health-check routing, which would make the
# backend conflict with Caddy on port 3000. We restore PORT=8080 here so the
# backend always listens on the correct internal port regardless of Railway's
# PORT override. Caddy and webapp-server use hardcoded ports (3000, 3100, 3170,
# 3200) from their own configs, so PORT doesn't affect them.

echo "==> Running database migrations..."
cd /dist/backend
if npx prisma migrate deploy 2>&1; then
  echo "==> Migrations complete."
else
  echo "==> WARNING: Migration failed. Check DATABASE_URL."
  echo "    The app will start but may not function correctly without a database."
fi

echo "==> Starting Hoppscotch..."
# Restore upstream PORT for NestJS backend (Caddy:3170 -> localhost:8080)
export PORT=8080
exec tini -- node /usr/src/app/aio_run.mjs
