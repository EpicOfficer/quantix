#!/usr/bin/bash

set -oue pipefail

sed -i~ -E 's/=.\$\(command -v (nft|ip6?tables-legacy).*/=/g' /usr/lib/waydroid/data/scripts/waydroid-net.sh

/usr/libexec/containerbuild/build-initramfs

rm -f /etc/profile.d/toolbox.sh
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/fish.desktop
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/nvtop.desktop
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/btop.desktop
rm -f /usr/share/vulkan/icd.d/lvp_icd.*.json
mkdir -p "/usr/etc/profile.d/"
mkdir -p "/usr/etc/xdg/autostart"

echo "import \"/usr/share/ublue-os/just/80-quantix.just\"" >> /usr/share/ublue-os/justfile
echo "import \"/usr/share/ublue-os/just/81-quantix-fixes.just\"" >> /usr/share/ublue-os/justfile
echo "import \"/usr/share/ublue-os/just/82-quantix-apps.just\"" >> /usr/share/ublue-os/justfile
echo "import \"/usr/share/ublue-os/just/82-quantix-cdemu.just\"" >> /usr/share/ublue-os/justfile
echo "import \"/usr/share/ublue-os/just/82-quantix-sunshine.just\"" >> /usr/share/ublue-os/justfile
echo "import \"/usr/share/ublue-os/just/82-quantix-waydroid.just\"" >> /usr/share/ublue-os/justfile
echo "import \"/usr/share/ublue-os/just/84-quantix-virt.just\"" >> /usr/share/ublue-os/justfile

sed -i 's/stage/none/g' /etc/rpm-ostreed.conf
sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /usr/lib/systemd/user.conf
sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /usr/lib/systemd/system.conf
mkdir -p /usr/etc/flatpak/remotes.d
curl -Lo /usr/etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

curl -Lo /usr/bin/waydroid-choose-gpu https://raw.githubusercontent.com/KyleGospo/waydroid-scripts/main/waydroid-choose-gpu.sh
chmod +x /usr/bin/waydroid-choose-gpu
ostree container commit

# Branding
sed -i '/^PRETTY_NAME/s/Kinoite/Quantix/' /usr/lib/os-release
sed -i 's/plasma.svgz/quantix_logo.svgz/g' /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/Splash.qml

# Disable repos
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/vscode.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/docker-ce.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_sentry-kernel-fsync.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-staging.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-latencyflex.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ycollet-audinux.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-rom-properties.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-webapp-manager.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_hhd-dev-hhd.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_che-nerd-fonts.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_hikariknight-looking-glass-kvmfr.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_sentry-switcheroo-control_discrete.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/charm.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/rpmfusion-nonfree.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/rpmfusion-nonfree-updates-testing.repo