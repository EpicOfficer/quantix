#!/usr/bin/env bash

set -Eeuo pipefail

DRACULA_REPO="https://github.com/dracula/gtk.git"
DRACULA_REF="${DRACULA_REF:-master}"

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

src="$workdir/gtk"

git clone --depth=1 "$DRACULA_REPO" "$src"

if [[ "$DRACULA_REF" != "master" ]]; then
  git -C "$src" fetch --depth=1 origin "$DRACULA_REF"
  git -C "$src" checkout --detach FETCH_HEAD
fi

install_tree() {
  local from="$1"
  local to="$2"

  if [[ ! -e "$from" ]]; then
    echo "Missing expected Dracula path: $from" >&2
    exit 1
  fi

  rm -rf "$to"
  install -d "$(dirname "$to")"
  cp -a "$from" "$to"
}

install_file() {
  local from="$1"
  local to="$2"

  if [[ ! -f "$from" ]]; then
    echo "Missing expected Dracula file: $from" >&2
    exit 1
  fi

  install -Dm0644 "$from" "$to"
}

# Plasma / KDE assets.
for theme in "$src"/kde/plasma/desktoptheme/*; do
  install_tree "$theme" "/usr/share/plasma/desktoptheme/$(basename "$theme")"
done

install_tree "$src/kde/plasma/look-and-feel/Plasma6/Dracula" \
  "/usr/share/plasma/look-and-feel/Dracula"

for theme in "$src"/kde/aurorae/*; do
  install_tree "$theme" "/usr/share/aurorae/themes/$(basename "$theme")"
done

for scheme in "$src"/kde/color-schemes/*.colors; do
  install_file "$scheme" "/usr/share/color-schemes/$(basename "$scheme")"
done

for theme in "$src"/kde/kvantum/*; do
  install_tree "$theme" "/usr/share/Kvantum/$(basename "$theme")"
done

install_tree "$src/kde/cursors/Dracula-cursors" \
  "/usr/share/icons/Dracula-cursors"

install_tree "$src/kde/sddm/Dracula" \
  "/usr/share/sddm/themes/Dracula"

# GTK / GNOME fallback theme.
install_tree "$src" "/usr/share/themes/Dracula"

# Remove source and desktop-environment bundles that are installed elsewhere.
rm -rf \
  /usr/share/themes/Dracula/.git \
  /usr/share/themes/Dracula/.github \
  /usr/share/themes/Dracula/kde \
  /usr/share/themes/Dracula/src \
  /usr/share/themes/Dracula/Art

# GTK 2/3/4 defaults.
install -d /usr/etc/xdg/gtk-2.0 /usr/etc/xdg/gtk-3.0 /usr/etc/xdg/gtk-4.0

cat > /usr/etc/xdg/gtk-2.0/gtkrc <<'GTKRC'
gtk-theme-name="Dracula"
gtk-icon-theme-name="Papirus"
gtk-cursor-theme-name="Dracula-cursors"
gtk-cursor-theme-size=24
GTKRC

for gtkver in 3.0 4.0; do
  cat > "/usr/etc/xdg/gtk-${gtkver}/settings.ini" <<'SETTINGS'
[Settings]
gtk-application-prefer-dark-theme=true
gtk-theme-name=Dracula
gtk-icon-theme-name=Papirus
gtk-cursor-theme-name=Dracula-cursors
gtk-cursor-theme-size=24
gtk-font-name=Noto Sans, 10
gtk-decoration-layout=close,minimize,maximize:
gtk-enable-animations=true
gtk-primary-button-warps-slider=true
gtk-sound-theme-name=ocean
SETTINGS
done

install_file "$src/gtk-4.0/gtk.css" "/usr/etc/xdg/gtk-4.0/gtk.css"
install_file "$src/gtk-4.0/gtk-dark.css" "/usr/etc/xdg/gtk-4.0/gtk-dark.css"

# Kvantum defaults. KDE reads this through XDG_CONFIG_DIRS before users have local config.
install -d /usr/etc/xdg/Kvantum
cat > /usr/etc/xdg/Kvantum/kvantum.kvconfig <<'KVANTUM'
[General]
theme=Dracula
KVANTUM

# GNOME/dconf fallback defaults.
install -d /usr/etc/dconf/profile /usr/etc/dconf/db/local.d
cat > /usr/etc/dconf/profile/user <<'PROFILE'
user-db:user
system-db:local
PROFILE

cat > /usr/etc/dconf/db/local.d/12-quantix-theme <<'DCONF'
[org/gnome/desktop/interface]
color-scheme='prefer-dark'
cursor-size=24
cursor-theme='Dracula-cursors'
enable-animations=true
font-name='Noto Sans, 10'
gtk-theme='Dracula'
icon-theme='Papirus'
text-scaling-factor=1.0

[org/gnome/desktop/sound]
theme-name='ocean'

[org/gnome/desktop/wm/preferences]
button-layout='close,minimize,maximize:'
DCONF

# SDDM defaults.
install -d /usr/etc/sddm.conf.d
cat > /usr/etc/sddm.conf.d/10-quantix-theme.conf <<'SDDM'
[Theme]
Current=Dracula
CursorTheme=Dracula-cursors
Font=Noto Sans,10,-1,5,50,0,0,0,0,0
SDDM

# Cursor fallback for Wayland/XWayland apps that read env before KDE settings.
install -d /usr/etc/environment.d
cat > /usr/etc/environment.d/90-quantix-theme.conf <<'ENV'
XCURSOR_THEME=Dracula-cursors
XCURSOR_SIZE=24
ENV

echo "Dracula theme assets and fallback defaults installed."
