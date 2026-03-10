#!/data/data/com.termux/files/usr/bin/bash
# Run this script inside Termux to set up SSH access to your n8n server.
# Usage: bash setup-termux.sh <server-ip-or-hostname> [ssh-user]

set -e

SERVER="${1:?Usage: bash setup-termux.sh <server-ip> [user]}"
USER="${2:-root}"

echo "==> Updating Termux packages..."
pkg update -y && pkg install -y openssh mosh tmux

if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "==> Generating SSH key..."
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
else
    echo "==> SSH key already exists, skipping generation."
fi

echo "==> Copying SSH key to ${USER}@${SERVER}..."
echo "    You will be prompted for the server password one time."
ssh-copy-id "${USER}@${SERVER}"

# Add alias to bashrc
ALIAS_LINE="alias n8n-server='ssh ${USER}@${SERVER}'"
if ! grep -qF "n8n-server" ~/.bashrc 2>/dev/null; then
    echo "$ALIAS_LINE" >> ~/.bashrc
    echo "==> Added 'n8n-server' alias to ~/.bashrc"
else
    echo "==> Alias 'n8n-server' already exists in ~/.bashrc"
fi

echo ""
echo "Done! You can now connect with:"
echo "  ssh ${USER}@${SERVER}"
echo "  -- or just type --"
echo "  n8n-server"
