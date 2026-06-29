FROM docker.io/hoppscotch/hoppscotch:2026.5.0

# ── Metadata ──────────────────────────────────────────────────────────────
LABEL org.opencontainers.image.source="https://github.com/INAPP-Mobile/railway-hoppscotch"
LABEL org.opencontainers.image.description="Hoppscotch — self-hosted API development platform. Railway template."
LABEL org.opencontainers.image.licenses="MIT"

# ── Production defaults ───────────────────────────────────────────────────
ENV PRODUCTION=true

# ── Entrypoint wrapper ────────────────────────────────────────────────────
#   Runs `prisma migrate deploy` before handing off to the upstream entrypoint.
#   The base image uses `tini -- node /usr/src/app/aio_run.mjs` as its CMD.
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# ── Port ──────────────────────────────────────────────────────────────────
#   Caddy listens on :3000 (frontend), :3100 (admin), :3170 (backend API).
#   Railway health-checks whichever port you set in PORT.
EXPOSE 3000 3100 3170

# Default runtime configuration
ENV PRODUCTION=true
ENV PORT=3000
ENV WHITELISTED_ORIGINS=

ENTRYPOINT ["/docker-entrypoint.sh"]