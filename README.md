# Hoppscotch — Railway Deployment Template

> **Self-hosted API development platform.** Open-source Postman alternative with GraphQL, REST, WebSocket, SSE, Socket.IO, and MQTT support.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/hoppscotch-1)

[![GitHub Repo](https://img.shields.io/badge/GitHub-INAPP--Mobile%2Frailmobile--hoppscotch-181717?style=flat-square&logo=github)](https://github.com/INAPP-Mobile/railway-hoppscotch)
[![Hoppscotch](https://img.shields.io/badge/Hoppscotch-79.7K%E2%98%85-3ab795?style=flat-square)](https://github.com/hoppscotch/hoppscotch)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](https://github.com/hoppscotch/hoppscotch/blob/main/LICENSE)

---

# Deploy and Host

Deploy Hoppscotch on Railway in one click. This template provisions a container running the Hoppscotch all-in-one image (Caddy reverse proxy, NestJS backend, and webapp frontend) with an attached PostgreSQL database. SSL is handled automatically by Railway.

## About Hosting

This template runs Hoppscotch v2026.5.0 inside a single Railway container with three internal services:

- **Caddy** serves the frontend SPA on port 3000, admin dashboard on port 3100, and reverse-proxies API requests to the backend on port 3170
- **NestJS Backend** provides REST + GraphQL APIs on port 8080 (internal)
- **Webapp Server** serves the built frontend assets

PostgreSQL is provisioned as a Railway plugin — no manual database setup required.

## Why Deploy

Hoppscotch is the leading open-source Postman alternative with 79.7K GitHub stars. Self-hosting gives you full control over your API development data, no third-party dependency, and unlimited team collaboration without per-seat pricing. Railway's one-click deploy makes it accessible to any team in under a minute.

## Common Use Cases

- **API Development & Testing** — REST, GraphQL, WebSocket, Socket.IO, SSE, MQTT
- **Team Collaboration** — Share collections and environments with your team
- **API Documentation** — Auto-generate and publish API docs
- **Postman Migration** — Import existing Postman collections seamlessly
- **CI/CD Integration** — Use Hoppscotch as part of your API testing pipeline

## Dependencies for Hoppscotch

### Runtime

| Dependency    | Version/Type | Purpose                                 |
|---------------|--------------|-----------------------------------------|
| Node.js       | 20+          | Application runtime                     |
| Caddy         | 2.x          | Reverse proxy and static file serving   |
| PostgreSQL    | 15+          | Primary database (via Railway plugin)   |
| Prisma        | —            | ORM and database migrations             |
| NestJS        | —            | Backend framework                       |

### Deployment Dependencies

| Tool              | Purpose                                         |
|-------------------|-------------------------------------------------|
| Docker            | Container runtime (managed by Railway)          |
| Railway           | Hosting platform                                |
| Railway PostgreSQL | Managed PostgreSQL database                    |

---

## ✨ Features

- **Request Composer** — REST, GraphQL, WebSocket, SSE, Socket.IO, MQTT
- **Collections** — Organise, share, and sync your API requests
- **Environment Variables** — Manage multi-environment configs
- **Team Collaboration** — Share collections and environments with your team
- **History & Sync** — Review past requests and responses
- **Admin Dashboard** — User management, infra tokens, usage insights
- **Postman Import** — Seamless migration from Postman collections
- **Self-hosted** — Full data ownership, no third-party dependency

---

## 🚀 Quick Start

### One-click Deploy

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/hoppscotch-1)

### Manual Deploy

```bash
git clone https://github.com/INAPP-Mobile/railway-hoppscotch.git
cd railway-hoppscotch
railway up
```

---

## ⚙️ Environment Variables

| Variable                  | Required | Description                                                    |
|---------------------------|----------|----------------------------------------------------------------|
| `DATABASE_URL`            | ✅ Yes   | PostgreSQL connection string (auto by Railway plugin)          |
| `DATA_ENCRYPTION_KEY`     | ✅ Yes   | 32-char hex key. Generate: `openssl rand -hex 16`              |
| `VITE_BASE_URL`           | ✅ Yes   | Your Railway deployment URL (e.g., `https://app.up.railway.app`)|
| `WHITELISTED_ORIGINS`     | ⬜ No    | Comma-separated CORS origins. Include your Railway URL.        |
| `SECRET_KEY`              | ⬜ No    | JWT signing secret. Generate: `openssl rand -base64 32`        |
| `TRUST_PROXY`             | ⬜ No    | Set `true` when behind Railway proxy                           |

### Quick Setup

```bash
railway add postgres
openssl rand -hex 16  # → set as DATA_ENCRYPTION_KEY
```

---

## 🛠️ Architecture

```
┌─────────────────────────────────────────────────────┐
│  Caddy (:3000 frontend / :3100 admin / :3170 API)   │
│        ├── Self-Host Webapp (Frontend SPA)           │
│        ├── Admin Dashboard SPA                       │
│        └── Backend API (NestJS + GraphQL, :8080)    │
│                     │                                │
│              ┌──────▼──────┐                         │
│              │ PostgreSQL  │                         │
│              └─────────────┘                         │
└─────────────────────────────────────────────────────┘
```

### Port Mapping

| Port | Service             | Description                |
|------|---------------------|----------------------------|
| 3000 | Webapp (Frontend)   | Main Hoppscotch UI         |
| 3100 | Admin Dashboard     | Self-host admin panel      |
| 3170 | Backend API         | GraphQL + REST API         |

---

## 🔐 Security

- **No hardcoded secrets** — all credentials via environment variables
- **Pinned version** — `hoppscotch/hoppscotch:2026.5.0` (not `:latest`)
- **Encryption at rest** — sensitive data encrypted with `DATA_ENCRYPTION_KEY`
- **CORS configurable** — restrict origins via `WHITELISTED_ORIGINS`
- **Non-root** — container runs as non-privileged user

---

## 🧪 Troubleshooting

| Problem                          | Likely Cause                         | Solution                                      |
|----------------------------------|--------------------------------------|-----------------------------------------------|
| `ECONNREFUSED` on startup        | PostgreSQL not ready                 | Add Railway PostgreSQL and check DATABASE_URL |
| Prisma migration fails           | Wrong database credentials           | Check DATABASE_URL format                     |
| CORS errors in browser           | WHITELISTED_ORIGINS missing your URL | Add your Railway domain                       |
| 502 Bad Gateway                  | Backend not ready after migration    | Wait 30-60s; check logs                       |
| Login redirects to wrong URL     | VITE_BASE_URL not set correctly      | Set to your Railway URL                       |

---

## 📄 License

This template is distributed under the **MIT License**. Hoppscotch itself is also MIT-licensed.

## Resources

- [Hoppscotch Documentation](https://docs.hoppscotch.io)
- [Hoppscotch GitHub](https://github.com/hoppscotch/hoppscotch)
- [Railway Documentation](https://docs.railway.app)
- [INAPP-Mobile Templates](https://github.com/INAPP-Mobile)
