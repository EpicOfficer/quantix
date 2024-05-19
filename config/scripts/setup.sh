#!/usr/bin/bash

set -oue pipefail

FEDORA_MAJOR_VERSION="40"
IMAGE_VENDOR="epicofficer"
IMAGE_NAME="quantix-os"
IMAGE_INFO="/usr/share/quantix-os/image-info.json"
IMAGE_REF="ostree-image-signed:docker://ghcr.io/$IMAGE_VENDOR/$IMAGE_NAME"
IMAGE_BRANCH_NORMALIZED="stable"
IMAGE_TAG="stable"

# Setup COPR repos
curl -Lo /usr/bin/copr https://raw.githubusercontent.com/ublue-os/COPR-command/main/copr
chmod +x /usr/bin/copr
curl -Lo /etc/yum.repos.d/_copr_kylegospo-bazzite.repo https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-bazzite-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite-multilib/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-bazzite-multilib-fedora-"${FEDORA_MAJOR_VERSION}".repo?arch=x86_64
curl -Lo /etc/yum.repos.d/_copr_ublue-os-staging.repo https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-"${FEDORA_MAJOR_VERSION}"/ublue-os-staging-fedora-"${FEDORA_MAJOR_VERSION}".repo?arch=x86_64
curl -Lo /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-system76-scheduler-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_kylegospo-latencyflex.repo https://copr.fedorainfracloud.org/coprs/kylegospo/LatencyFleX/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-LatencyFleX-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo https://copr.fedorainfracloud.org/coprs/kylegospo/obs-vkcapture/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-obs-vkcapture-fedora-"${FEDORA_MAJOR_VERSION}".repo?arch=x86_64
curl -Lo /etc/yum.repos.d/_copr_ycollet-audinux.repo https://copr.fedorainfracloud.org/coprs/ycollet/audinux/repo/fedora-"${FEDORA_MAJOR_VERSION}"/ycollet-audinux-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_kylegospo-rom-properties.repo https://copr.fedorainfracloud.org/coprs/kylegospo/rom-properties/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-rom-properties-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_kylegospo-joycond.repo https://copr.fedorainfracloud.org/coprs/kylegospo/joycond/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-joycond-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_kylegospo-webapp-manager.repo https://copr.fedorainfracloud.org/coprs/kylegospo/webapp-manager/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-webapp-manager-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_hhd-dev-hhd.repo https://copr.fedorainfracloud.org/coprs/hhd-dev/hhd/repo/fedora-"${FEDORA_MAJOR_VERSION}"/hhd-dev-hhd-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_che-nerd-fonts.repo https://copr.fedorainfracloud.org/coprs/che/nerd-fonts/repo/fedora-"${FEDORA_MAJOR_VERSION}"/che-nerd-fonts-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_sentry-switcheroo-control_discrete.repo https://copr.fedorainfracloud.org/coprs/sentry/switcheroo-control_discrete/repo/fedora-"${FEDORA_MAJOR_VERSION}"/sentry-switcheroo-control_discrete-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_hikariknight-looking-glass-kvmfr.repo https://copr.fedorainfracloud.org/coprs/hikariknight/looking-glass-kvmfr/repo/fedora-"${FEDORA_MAJOR_VERSION}"/hikariknight-looking-glass-kvmfr-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_matte-schwartz-sunshine.repo https://copr.fedorainfracloud.org/coprs/matte-schwartz/sunshine/repo/fedora-"${FEDORA_MAJOR_VERSION}"/matte-schwartz-sunshine-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_rok-cdemu.repo https://copr.fedorainfracloud.org/coprs/rok/cdemu/repo/fedora-"${FEDORA_MAJOR_VERSION}"/rok-cdemu-fedora-"${FEDORA_MAJOR_VERSION}".rep
curl -Lo /etc/yum.repos.d/_copr_rodoma92-kde-cdemu-manager.repo https://copr.fedorainfracloud.org/coprs/rodoma92/kde-cdemu-manager/repo/fedora-"${FEDORA_MAJOR_VERSION}"/rodoma92-kde-cdemu-manager-fedora-"${FEDORA_MAJOR_VERSION}".repo
curl -Lo /etc/yum.repos.d/_copr_rodoma92-rmlint.repo https://copr.fedorainfracloud.org/coprs/rodoma92/rmlint/repo/fedora-"${FEDORA_MAJOR_VERSION}"/rodoma92-rmlint-fedora-"${FEDORA_MAJOR_VERSION}".repo

# Install kernel-fsync
rpm-ostree cliwrap install-to-root /
curl -Lo /etc/yum.repos.d/_copr_sentry-kernel-fsync.repo https://copr.fedorainfracloud.org/coprs/sentry/kernel-fsync/repo/fedora-$(rpm -E %fedora)/sentry-kernel-fsync-fedora-$(rpm -E %fedora).repo
rpm-ostree override replace \
  --experimental \
  --from repo=copr:copr.fedorainfracloud.org:sentry:kernel-fsync \
    kernel \
    kernel-core \
    kernel-modules \
    kernel-modules-core \
    kernel-modules-extra \
    kernel-uki-virt \
    kernel-headers \
    kernel-devel

cat > $IMAGE_INFO <<EOF
{
  "image-name": "$IMAGE_NAME",
  "image-flavor": "Developer Edition",
  "image-vendor": "$IMAGE_VENDOR",
  "image-ref": "$IMAGE_REF",
  "image-tag": "$IMAGE_TAG",
  "image-branch": "$IMAGE_BRANCH_NORMALIZED",
  "base-image-name": "Kinoite",
  "fedora-version": "$FEDORA_MAJOR_VERSION"
}
EOF

sysctl -p