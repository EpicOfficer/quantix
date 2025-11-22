#!/usr/bin/env bash
set -euo pipefail

echo "[quantix] Installing Discord wrapper in /usr/local/bin..."

mkdir -p /usr/local/bin

cat >/usr/local/bin/discord <<'EOF'
#!/usr/bin/env bash
exec /opt/discord/Discord "$@"
EOF

chmod +x /usr/local/bin/discord

echo "[quantix] Wrapper installed: /usr/local/bin/discord -> /opt/discord/Discord"
