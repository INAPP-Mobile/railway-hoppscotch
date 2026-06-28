# Deploy and Host Hoppscotch — Railway Deployment Template

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/hoppscotch-1)

[![GitHub Repo](https://img.shields.io/badge/GitHub-INAPP--Mobile%2Frailmobile--hoppscotch-181717?style=flat-square&logo=github)](https://github.com/INAPP-Mobile/railway-hoppscotch)
[![Hoppscotch](https://img.shields.io/badge/Hoppscotch-79.7K%E2%98%85-3ab795?style=flat-square)](https://github.com/hoppscotch/hoppscotch)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](https://github.com/hoppscotch/hoppscotch/blob/main/LICENSE)

> **Self-hosted API development platform.** Open-source Postman alternative with GraphQL, REST, WebSocket, SSE, Socket.IO, and MQTT support.

## About Hosting

Hoppscotch is an open-source API development ecosystem featuring a full-stack architecture with three services running in a single container:

| Port | Service          | Description               |
|------|------------------|---------------------------|
| 3000 | Webapp (Frontend) | Main Hoppscotch UI        |
| 3100 | Admin Dashboard   | Self-host admin panel     |
| 3170 | Backend API      | GraphQL + REST API        |

The template uses the official `hoppscotch/hoppscotch:2026.5.0` Docker image with an entrypoint wrapper that runs Prisma database migrations on first startup, ensuring the database schema is always current without manual intervention.

### Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Railway Container                  │
│                                                      │
│  ┌──────────┐   :3000   ┌────────────────────────┐  │
│  │  Caddy   │◄─────────►│   Self-Host Webapp     │  │
│  │  Reverse │           │   (Frontend SPA)        │  │
│  │  Proxy   │◄─────────►│                        │  │
│  │          │   :3100   │   Admin Dashboard       │  │
│  │          │           │   (Admin SPA)           │  │
│  │          │◄─────────►│                        │  │
│  │          │   :3170   │   Backend API           │  │
│  │          │           │   (NestJS + GraphQL)    │  │
│  └──────────┘           └───────────┬────────────┘  │
│                                     │                │
│                           ┌─────────▼──────────┐    │
│                           │  PostgreSQL         │    │
│                           │  (Railway Plugin)   │    │
│                           └────────────────────┘    │
└─────────────────────────────────────────────────────┘
```

## Why Deploy

- **Full Data Ownership** — Your API requests, collections, and team data stay on your infrastructure
- **No Rate Limits** — Self-hosted means no third-party API call quotas
- **Team Collaboration** — Built-in team management with role-based access control
- **All Protocols** — REST, GraphQL, WebSocket, SSE, Socket.IO, and MQTT in one tool
- **Postman Compatible** — Import your existing Postman collections seamlessly
- **MIT Licensed** — Free to use, modify, and distribute
- **Active Community** — 79.7K GitHub stars, frequent releases

## Common Use Cases

| Use Case                          | Description                                              |
|-----------------------------------|----------------------------------------------------------|
| API Development Teams             | Collaborative request building with collections & envs   |
| DevOps & SRE                      | Monitor API endpoints, test webhooks, debug integrations |
| Education & Training              | Teach API concepts with a practical, hands-on tool       |
| Internal Tool Building            | Prototype and test APIs before production deployment     |
| API Documentation                 | Generate and share API documentation from collections    |
| Security Testing                  | Test authentication flows and API endpoint security      |
| Microservices Debugging           | Debug inter-service communication in real-time           |
| GraphQL API Development           | Interactive GraphQL query builder with schema explorer   |

## Dependencies for Hoppscotch

### Runtime Dependencies

| Dependency    | Version/Type | Purpose                                 |
|---------------|--------------|-----------------------------------------|
| Node.js       | 20+          | Application runtime                     |
| Caddy         | 2.x          | Reverse proxy and static file serving   |
| PostgreSQL    | 15+          | Primary database (via Railway plugin)   |
| Prisma        | —            | ORM and database migrations             |
| NestJS        | —            | Backend framework                       |

### Deployment Dependencies

| Tool          | Purpose                                         |
|---------------|-------------------------------------------------|
| Docker        | Container runtime (managed by Railway)          |
| Railway PostgreSQL | Managed PostgreSQL database               |

---

## 🚀 Quick Start

### One-click Deploy

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/hoppscotch-1)

### Manual Deploy

```bash
# Clone the template
git clone https://github.com/INAPP-Mobile/railway-hoppscotch.git
cd railway-hoppscotch

# Deploy to Railway
railway up
```

---

## ⚙️ Environment Variables

| Variable                  | Required | Default                                                | Description                                                     |
|---------------------------|----------|--------------------------------------------------------|-----------------------------------------------------------------|
| `DATABASE_URL`            | ✅ Yes   | —                                                      | PostgreSQL connection string (auto-provided by Railway plugin)  |
| `DATA_ENCRYPTION_KEY`     | ✅ Yes   | —                                                      | 32-char encryption key for DB secrets. Generate: `openssl rand -hex 16` |
| `VITE_BASE_URL`           | ✅ Yes   | —                                                      | Public URL of your deployment (e.g., `https://your-app.up.railway.app`) |
| `WHITELISTED_ORIGINS`     | ⬜ No    | `http://localhost:3170,http://localhost:3000,…`        | Comma-separated CORS origins. Include your Railway URL.         |
| `SECRET_KEY`              | ⬜ No    | Auto-generated on first boot                           | JWT signing secret. Generate: `openssl rand -base64 32`         |
| `PROXY_APP_URL`           | ⬜ No    | `https://proxy.hoppscotch.io`                          | Default proxy URL for proxied requests                          |
| `TRUST_PROXY`             | ⬜ No    | `false`                                                | Set `true` when behind Railway proxy                             |
| `ENABLE_SUBPATH_BASED_ACCESS` | ⬜ No | `false`                                                | Serve all services on a single port with path-based routing     |
| `INFRA_TOKEN`             | ⬜ No    | —                                                      | Admin API access token                                          |

### Required Add-ons

This template requires a **PostgreSQL database**. Add it from the Railway dashboard or CLI:

```bash
railway add postgres
```

The `DATABASE_URL` variable is automatically injected into your service. No manual configuration needed.

### Quick Setup

```bash
# 1. Add a PostgreSQL database
railway add postgres

# 2. Generate a secure encryption key
openssl rand -hex 16

# 3. Set the key in Railway
railway variables set DATA_ENCRYPTION_KEY=$(openssl rand -hex 16)
```

---

## 🔐 Security

- **No hardcoded secrets** — all credentials are passed via environment variables
- **Pinned version** — uses `hoppscotch/hoppscotch:2026.5.0` (not `:latest`)
- **Encryption at rest** — sensitive data encrypted with `DATA_ENCRYPTION_KEY`
- **CORS configurable** — restrict origins via `WHITELISTED_ORIGINS`
- **Non-root** — the container runs as a non-privileged user

---

## 🧪 Troubleshooting

| Problem                          | Likely Cause                           | Solution                                                           |
|----------------------------------|----------------------------------------|--------------------------------------------------------------------|
| `ECONNREFUSED` on startup        | PostgreSQL not ready                   | Ensure Railway PostgreSQL add-on is added and `DATABASE_URL` is set |
| Prisma migration fails           | Database credentials wrong             | Check `DATABASE_URL` format                                        |
| CORS errors in browser           | `WHITELISTED_ORIGINS` missing your URL | Add your Railway domain to the variable                            |
| 502 Bad Gateway                  | Backend not ready after DB migration   | Wait 30–60s; check logs for migration status                       |
| `1146: Table doesn't exist`      | Migration incomplete                   | Restart the service to trigger auto-migration                       |
| Login/register redirects to wrong URL | `VITE_BASE_URL` not set correctly   | Set `VITE_BASE_URL` to your Railway URL                            |
| Slow first load                  | Cold start, DB connection              | Normal for free tier. Upgrade for better performance.              |

### Logs

View container logs in the Railway dashboard under **Deployments** → **View Logs**:

```
==> Running database migrations...
...
1 migration found, applying...
==> Migrations complete.
==> Starting Hoppscotch...
Running in production: true
Backend Server | Port: 8080
```

---

## 📄 License

This template is distributed under the **MIT License**. Hoppscotch itself is also MIT-licensed.

---

## 🤝 Contributing

[Open an issue](https://github.com/INAPP-Mobile/railway-hoppscotch/issues) or submit a PR.

---

## Resources

- [Hoppscotch Documentation](https://docs.hoppscotch.io)
- [Hoppscotch GitHub](https://github.com/hoppscotch/hoppscotch)
- [Railway Documentation](https://docs.railway.app)
- [INAPP-Mobile Templates](https://github.com/INAPP-Mobile)
