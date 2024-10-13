#!/usr/bin/env bash

set -oue pipefail

cd /tmp 
git clone https://github.com/dracula/gtk.git

mkdir -p /usr/share/plasma/desktoptheme
mkdir -p /usr/share/plasma/look-and-feel
mkdir -p /usr/share/aurorae/themes
mkdir -p /usr/share/sddm/themes
mkdir -p /usr/share/color-schemes
mkdir -p /usr/share/themes
mkdir -p /usr/share/icons

mv gtk/kde/plasma/desktoptheme/* /usr/share/plasma/desktoptheme/ 
mv gtk/kde/plasma/look-and-feel/Plasma6/Dracula /usr/share/plasma/look-and-feel/
mv gtk/kde/sddm/Dracula /usr/share/sddm/themes/
mv gtk/kde/cursors/Dracula-cursors /usr/share/icons/
mv gtk/kde/aurorae/* /usr/share/aurorae/themes/
mv gtk/kde/color-schemes/* /usr/share/color-schemes/

mv gtk /usr/share/themes/Dracula