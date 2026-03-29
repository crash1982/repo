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

---

# Owner Context — Kyle (Global)

## Who I Am
- Owner/operator of **Clubhouse on Main (CHOM)** — sports bar & entertainment venue at 2866 Main St, Glastonbury, CT (axe throwing, golf simulators, dining, bar)
- Actively building **Clubhouse on Pratt (CHOP)** — second location in Hartford, CT targeting mid-2026 opening
- Running a **two-AI coordination system**: Claude handles strategic/creative work; **AI-Karl** (OpenClaw agent) manages daily technical operations and automation

## Infrastructure
- Ubuntu server: `192.168.86.25` / Tailscale: `100.116.172.80`
- n8n dashboard: SSH tunnel at `localhost:18789`
- Staff dashboard (Daily Briefing v6): nginx port `9999` via Tailscale Funnel
- Karl's email: `aikarl111923@gmail.com`
- Coordination Google Drive folder: `drive.google.com/drive/folders/10k3ibnHe8DcZrgd_XfZTUx0uSXRZb6xI`
  - Subfolders: AI-Karl-Reports, Session-Summaries, Work-Products
- Master Todo Tracker (Google Doc): `1-ANinedv5zW_DNK5bcDVxkTn_q6UigRrUBihQBLn76s`

## Tech Stack
- **Automation**: n8n (self-hosted), OpenClaw agent framework
- **POS**: Toast (note: known bug — totals include tax/tips, use net sales only)
- **Scheduling**: 7Shifts (note: pagination returns ~70% of staff — use full fetch)
- **Server**: Ubuntu 24, nginx, Python, ReportLab for PDF generation
- **Languages**: Python preferred for scripting; Node.js for n8n integrations

## Key People
- **Sarah** — GM (CHOM)
- **Nate (FOH)** — Front of House manager
- **Maddy** — Bar Manager
- **Nate (BOH)** — Kitchen Manager
- **Hans Hansen** — Architect on CHOP build-out

## Operational Context
- **CHOM revenue targets**: Bar 50%, Food 25%, Sims 20%, Events 5%
- **Labor targets**: Toast <20%, Total <30%
- **COGS targets**: Kitchen 27%, Bar 15%; Net Profit: 35%
- **Core values**: Own the Experience · Be Active Not Passive · Find the Yes · Play to Win
- Running EOS/Traction methodology (L10 meetings, scorecards, rocks, IDS)

## Todo Tracker Protocol
- ID format: `[SCOPE]-[YYYY-MM-DD]-[###]`
- Scopes: L10, CHOP, Automation, OpenClaw (keep personal items separate)
- Claude cannot write directly to the tracker — create markdown handoff files at `/mnt/user-data/outputs/` with human-readable tables + JSON blocks for Karl to process

## Session End Protocol
At end of each session, create a handoff summary with:
1. Work completed
2. Files created
3. AI-Karl technical tasks
4. Next session planning

Upload to Session-Summaries folder in coordination drive.

## Working Style Preferences
- Prefer **iterative, targeted fixes** over full rebuilds
- Direct communication — skip preamble, get to the point
- Practical over elaborate solutions
- Strong preference for automation and scalable infrastructure
- Mobile-readable responses when possible (iPhone + desktop usage)

## Active Projects (as of early 2026)
- CHOP build-out (MEP/hood quotes, electrical load ~168A on 208V 3-phase, architectural review)
- n8n: Daily Briefing v6, Weekly Scheduling Engine, Invoice Monitor v2
- Manager Bot (Claude Haiku, reactive Q&A for management team)
- Automation Roadmap Phases 3–5 (advanced scheduling, HR automation, predictive analytics)
