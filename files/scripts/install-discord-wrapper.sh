#!/usr/bin/env bash
set -euo pipefail

echo "Installing Discord wrapper into /usr/local/bin..."

mkdir -p /usr/local/bin

cat >/usr/local/bin/discord <<'EOF'
#!/usr/bin/env bash
exec /opt/discord/Discord "$@"
EOF

chmod +x /usr/local/bin/discord
