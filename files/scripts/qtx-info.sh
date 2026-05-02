#!/usr/bin/env bash

set -oue pipefail

sed -i 's/plasma.svgz/quantix_logo.svgz/g' /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/Splash.qml

cat > /usr/share/quantix-os/image-info.json <<EOF
{
  "image-name": "quantix",
  "image-flavor": "main",
  "image-vendor": "joshcollis",
  "image-ref": "ostree-image-signed:docker://ghcr.io/joshcollis/quantix",
  "image-tag": "stable",
  "image-branch": "main",
  "base-image-name": "Bazzite",
  "fedora-version": "44"
}
EOF
