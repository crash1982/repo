# CLAUDE.md

## Project Overview

This is a **Docker Compose deployment stack** for [n8n](https://n8n.io/) (workflow automation platform) behind a [Caddy](https://caddyserver.com/) reverse proxy. It provides secure HTTPS access to n8n from mobile devices with PWA (Progressive Web App) support.

**Tech stack:** Docker Compose, Caddy 2 (Alpine), n8n

## Repository Structure

```
.
├── .env.example          # Template for required environment variables
├── .gitignore            # Ignores .env (secrets)
├── Caddyfile             # Caddy reverse proxy configuration
├── docker-compose.yml    # Service orchestration (n8n + Caddy)
├── CLAUDE.md             # This file
└── README.md             # User-facing documentation
```

This is a small, infrastructure-only repository — no application code, no build steps, no tests.

## Services

| Service | Image | Role | Internal Port |
|---------|-------|------|---------------|
| `n8n` | `n8nio/n8n:latest` | Workflow automation engine | 5678 |
| `caddy` | `caddy:2-alpine` | Reverse proxy with automatic HTTPS | 80, 443 |

- Services communicate over the `n8n-net` Docker network.
- Caddy waits for n8n's health check (`/healthz`) before starting.

## Environment Variables

Configured via `.env` (copy from `.env.example`):

| Variable | Required | Description |
|----------|----------|-------------|
| `N8N_HOST` | Yes | Domain name for HTTPS (e.g., `n8n.example.com`) |
| `TIMEZONE` | No | Timezone, defaults to `UTC` |

**Important:** `.env` is gitignored — never commit secrets.

## Common Commands

```bash
# Start the stack
docker compose up -d

# View logs
docker compose logs -f

# Stop
docker compose down

# Update images
docker compose pull && docker compose up -d
```

## Key Conventions

### Configuration
- Environment variables use `UPPERCASE_WITH_UNDERSCORES`.
- Docker service names are lowercase (`n8n`, `caddy`).
- Network names follow `{service}-net` pattern.
- Caddy config uses the `Caddyfile` format (not JSON).

### Security
- HTTPS is enforced — Caddy auto-provisions Let's Encrypt certificates.
- Security headers are set in the Caddyfile: HSTS, X-Content-Type-Options, X-Frame-Options, Referrer-Policy.
- n8n runs with `N8N_SECURE_COOKIE=true` and `N8N_PROTOCOL=https`.
- The `.env` file must never be committed.

### Mobile / PWA
- `Service-Worker-Allowed: /` header enables PWA install.
- WebSocket proxying is configured for real-time workflow updates.
- Gzip and Zstd compression are enabled for faster mobile loading.

## Making Changes

- **Adding environment variables:** Add to `docker-compose.yml` under `n8n.environment`, document in `.env.example`, and update `README.md`.
- **Changing proxy behavior:** Edit `Caddyfile`. Caddy reloads config automatically on container restart.
- **Adding a new service:** Add to `docker-compose.yml`, attach to `n8n-net` network, and add any needed volumes.
- **Docker Compose version:** Uses version `3.8` syntax.

## Gotchas

- The `N8N_HOST` variable is used in both `docker-compose.yml` and `Caddyfile` — keep them in sync via the `.env` file.
- Caddy's `flush_interval -1` disables response buffering for streaming/SSE support.
- Ports 80 and 443 must be open on the host firewall for Caddy's ACME challenge and HTTPS.
- The n8n health check has a 30s interval with 3 retries — initial startup can take up to ~90s before Caddy starts.
