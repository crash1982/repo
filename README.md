# n8n Mobile Access

Run n8n behind Caddy for secure HTTPS access from your phone.

## Prerequisites

- A server with Docker and Docker Compose installed
- A domain name (e.g. `n8n.yourdomain.com`) with DNS pointing to your server
- Ports 80 and 443 open on your server/firewall

## Setup

1. Clone this repo to your server:

   ```bash
   git clone <repo-url> && cd repo
   ```

2. Create your `.env` file:

   ```bash
   cp .env.example .env
   ```

3. Edit `.env` and set your domain:

   ```
   N8N_HOST=n8n.yourdomain.com
   ```

4. Start the stack:

   ```bash
   docker compose up -d
   ```

Caddy automatically obtains and renews HTTPS certificates via Let's Encrypt.

## Accessing from Your Phone

Once running, open `https://n8n.yourdomain.com` in your mobile browser.

### Add to Home Screen (recommended)

n8n works as a Progressive Web App. Adding it to your home screen gives you an app-like experience:

- **iOS Safari**: Tap the share button > "Add to Home Screen"
- **Android Chrome**: Tap the menu (three dots) > "Add to Home screen" or "Install app"

## Managing

```bash
# View logs
docker compose logs -f

# Stop
docker compose down

# Update n8n to latest version
docker compose pull && docker compose up -d
```
