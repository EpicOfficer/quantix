#!/usr/bin/env bash

set -oue pipefail

sed -i '/^PRETTY_NAME/s/Bazzite/Quantix/' /usr/lib/os-release
sed -i 's/plasma.svgz/quantix_logo.svgz/g' /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/Splash.qml

cat > /usr/share/quantix-os/image-info.json <<EOF
{
  "image-name": "quantix",
  "image-flavor": "main",
  "image-vendor": "epicofficer",
  "image-ref": "ostree-image-signed:docker://ghcr.io/epicofficer/quantix",
  "image-tag": "stable",
  "image-branch": "main",
  "base-image-name": "Bazzite",
  "fedora-version": "40"
}
EOF