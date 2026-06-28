#!/bin/sh
# Hoppscotch Railway Template — Entrypoint
# Runs Prisma migrations (best-effort), then hands off to the original entrypoint.

echo "==> Running database migrations..."
cd /dist/backend
if npx prisma migrate deploy 2>&1; then
  echo "==> Migrations complete."
else
  echo "==> WARNING: Migration failed. Check DATABASE_URL."
  echo "    The app will start but may not function correctly without a database."
fi

echo "==> Starting Hoppscotch..."
exec tini -- node /usr/src/app/aio_run.mjs
