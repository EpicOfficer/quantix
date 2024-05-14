#!/usr/bin/bash

set -oue pipefail

# Branding
sed -i '/^PRETTY_NAME/s/Bazzite/Quantix/' /usr/lib/os-release
sed -i 's/bazzite_logo.svgz/quantix_logo.svgz/g' /usr/share/plasma/look-and-feel/com.valve.vapor.desktop/contents/splash/Splash.qml
sed -i 's/bazzite_logo.svgz/quantix_logo.svgz/g' /usr/share/plasma/look-and-feel/com.valve.vgui.desktop/contents/splash/Splash.qml

# Disable repos
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/vscode.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/docker-ce.repo