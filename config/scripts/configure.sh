#!/usr/bin/bash

set -oue pipefail

sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/winetricks.desktop
curl -Lo /tmp/latencyflex.tar.xz $(curl https://api.github.com/repos/ishitatsuyuki/LatencyFleX/releases/latest | jq -r '.assets[] | select(.name| test(".*.tar.xz$")).browser_download_url')
mkdir -p /tmp/latencyflex
tar --no-same-owner --no-same-permissions --no-overwrite-dir --strip-components 1 -xvf /tmp/latencyflex.tar.xz -C /tmp/latencyflex
rm -f /tmp/latencyflex.tar.xz
cp -r /tmp/latencyflex/wine/usr/lib/wine/* /usr/lib64/wine/
rm -rf /tmp/latencyflex
curl -Lo /usr/bin/latencyflex https://raw.githubusercontent.com/KyleGospo/LatencyFleX-Installer/main/install.sh
chmod +x /usr/bin/latencyflex
sed -i 's@/usr/lib/wine/@/usr/lib64/wine/@g' /usr/bin/latencyflex
sed -i 's@"dxvk.conf"@"/usr/share/latencyflex/dxvk.conf"@g' /usr/bin/latencyflex
chmod +x /usr/bin/latencyflex

rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
    kf6-kio-doc \
    kf6-kio-widgets-libs \
    kf6-kio-core-libs \
    kf6-kio-widgets \
    kf6-kio-file-widgets \
    kf6-kio-core \
    kf6-kio-gui

rpm-ostree install \
    gamescope.x86_64 \
    gamescope-libs.i686 \
    gamescope-shaders \
    rocm-hip \
    rocm-opencl \
    rocm-clinfo \
    waydroid \
    cage \
    wlr-randr

mkdir -p /tmp/kwin-system76-scheduler-integration
curl -Lo /tmp/kwin-system76-scheduler-integration/archive.tar.gz https://github.com/maxiberta/kwin-system76-scheduler-integration/archive/refs/heads/main.tar.gz
tar --no-same-owner --no-same-permissions --no-overwrite-dir --strip-components 1 -xvf /tmp/kwin-system76-scheduler-integration/archive.tar.gz -C /tmp/kwin-system76-scheduler-integration
kpackagetool6 --type=KWin/Script --global --install /tmp/kwin-system76-scheduler-integration
rm -rf /tmp/kwin-system76-scheduler-integration
sed -i '/<entry name="launchers" type="StringList">/,/<\/entry>/ s/<default>[^<]*<\/default>/<default>preferred:\/\/browser,applications:steam.desktop,applications:net.lutris.Lutris.desktop,applications:org.kde.discover.desktop,preferred:\/\/filemanager<\/default>/' /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml
sed -i '/<entry name="favorites" type="StringList">/,/<\/entry>/ s/<default>[^<]*<\/default>/<default>preferred:\/\/browser,steam.desktop,net.lutris.Lutris.desktop,systemsettings.desktop,org.kde.dolphin.desktop,org.kde.kate.desktop<\/default>/' /usr/share/plasma/plasmoids/org.kde.plasma.kickoff/contents/config/main.xml
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/yad-icon-browser.desktop
rm -f /usr/share/kglobalaccel/org.kde.konsole.desktop

ostree container commit