#!/usr/bin/env bash
set -euo pipefail

APPDIR="${HOME}/.local/share/applications"
mkdir -p "${APPDIR}"

DST="${APPDIR}/discord.desktop"

if [[ -f /usr/share/applications/discord.desktop ]]; then
  cp /usr/share/applications/discord.desktop "${DST}"
else
  cat > "${DST}" <<'EOF'
[Desktop Entry]
Name=Discord
Comment=Chat for Communities and Friends
Type=Application
Categories=Network;Chat;InstantMessaging;
StartupWMClass=discord
Icon=discord
EOF
fi

sed -i \
  -e 's|^Exec=.*|Exec=/usr/local/bin/discord %U|' \
  -e 's|^TryExec=.*|TryExec=/usr/local/bin/discord|' \
  "${DST}" || true

grep -q '^Exec=' "${DST}"    || echo 'Exec=/usr/local/bin/discord %U' >> "${DST}"
grep -q '^TryExec=' "${DST}" || echo 'TryExec=/usr/local/bin/discord' >> "${DST}"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "${APPDIR}" || true
fi