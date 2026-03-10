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

3. Edit `.env` and set your domain and terminal password:

   ```
   N8N_HOST=n8n.yourdomain.com
   TTYD_USER=admin
   TTYD_PASSWORD=your-secure-password
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

## Web Terminal (works on any device including iPhone)

A browser-based terminal is included so you can run commands (including Claude Code) from any device — no app install needed.

### Setup

1. Add a terminal password to your `.env` file:

   ```
   TTYD_USER=admin
   TTYD_PASSWORD=your-secure-password
   ```

2. Restart the stack:

   ```bash
   docker compose up -d
   ```

3. Open `https://n8n.yourdomain.com/terminal` in Safari (or any browser) and log in.

You now have a full terminal in your browser. Install Claude Code with:

```bash
npm install -g @anthropic-ai/claude-code
claude
```

### Add to Home Screen (iPhone)

In Safari, go to `https://n8n.yourdomain.com/terminal`, then tap Share > "Add to Home Screen". This gives you one-tap access to your terminal.

## Accessing from Termux (Android)

[Termux](https://termux.dev) gives you a full Linux terminal on your phone. You can SSH into your server to manage n8n and run commands directly.

### One-time Termux setup

Open Termux on your phone and run:

```bash
# Install SSH client
pkg update && pkg install openssh

# Generate an SSH key (press Enter to accept defaults)
ssh-keygen -t ed25519

# Copy your public key to the server (replace with your server details)
ssh-copy-id user@your-server-ip
```

### Connect to your server

```bash
ssh user@your-server-ip
```

### Recommended: Create a quick alias

Add this to your Termux shell config (`~/.bashrc` or `~/.zshrc`):

```bash
alias n8n-server='ssh user@your-server-ip'
```

Then just type `n8n-server` to connect.

### Useful commands once connected

```bash
# Check n8n status
docker compose ps

# View live logs
docker compose logs -f n8n

# Restart n8n
docker compose restart n8n

# Update n8n
docker compose pull && docker compose up -d
```

### Tips for Termux

- **Swipe left from the edge** to open the session drawer (multiple terminals)
- **Volume Up + Q** shows an extra keys row with Ctrl, Alt, Tab, etc.
- Install `tmux` (`pkg install tmux`) to keep sessions alive if you disconnect
- Install `mosh` (`pkg install mosh`) for a connection that survives network switches (Wi-Fi to mobile data)

## Managing

```bash
# View logs
docker compose logs -f

# Stop
docker compose down

# Update n8n to latest version
docker compose pull && docker compose up -d
```
