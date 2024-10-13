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
mkdir -p /usr/etc/skel/.config/Kvantum

cp -r gtk/assets /usr/etc/skel/.config/
cp gtk/gtk-4.0/gtk.css /usr/etc/xdg/gtk-4.0/
cp gtk/gtk-4.0/gtk-dark.css /usr/etc/xdg/gtk-4.0/
mv gtk/kde/plasma/desktoptheme/* /usr/share/plasma/desktoptheme/ 
mv gtk/kde/plasma/look-and-feel/Plasma6/Dracula /usr/share/plasma/look-and-feel/
mv gtk/kde/cursors/Dracula-cursors /usr/share/icons/
mv gtk/kde/aurorae/* /usr/share/aurorae/themes/
mv gtk/kde/color-schemes/* /usr/share/color-schemes/
mv gtk/kde/kvantum/* /usr/etc/skel/.config/Kvantum

rm -R gtk/src gtk/unity gtk/xfwm4 gtk/kde gtk/cinnamon gtk/Art gtk/*.json gtk/*.md gtk/*.js gtk/LICENSE

mv gtk /usr/share/themes/Dracula