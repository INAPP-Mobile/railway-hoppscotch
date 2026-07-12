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
# NOTE: Do NOT override PORT here. The upstream aio_run.mjs supervises
# Caddy (:3000) + Admin (:3100) + Backend (:8080 internal) as children.
# Railway health-checks the container's PORT (3000 from template), which Caddy
# binds to. The NestJS backend listens on 8080 internally regardless.
# Forcing PORT=8080 previously broke Caddy's bind and caused the
# supervisor to exit cleanly after onboarding -> 502 on all routes.
exec tini -- node /usr/src/app/aio_run.mjs
