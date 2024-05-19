#!/usr/bin/bash

set -oue pipefail

curl -Lo /usr/bin/installcab https://raw.githubusercontent.com/KyleGospo/steam-proton-mf-wmv/master/installcab.py
chmod +x /usr/bin/installcab
curl -Lo /usr/bin/install-mf-wmv https://raw.githubusercontent.com/KyleGospo/steam-proton-mf-wmv/master/install-mf-wmv.sh
chmod +x /usr/bin/install-mf-wmv
curl -Lo /usr/share/thumbnailers/exe-thumbnailer.thumbnailer https://raw.githubusercontent.com/jlu5/icoextract/master/exe-thumbnailer.thumbnailer

sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/fedora-updates.repo

rpm-ostree install mesa-vulkan-drivers.i686 \
  mesa-va-drivers-freeworld.i686 \
  mesa-vdpau-drivers-freeworld.i686

sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree.repo
sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo
sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-updates-testing.repo

rpm-ostree install steam

sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree.repo
sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo
sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-updates-testing.repo
sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/fedora-updates.repo