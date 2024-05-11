#!/usr/bin/bash

set -oue pipefail

FEDORA_MAJOR_VERSION="40"
IMAGE_VENDOR="epicofficer"
IMAGE_NAME="quantix-os"
IMAGE_INFO="/usr/share/quantix-os/image-info.json"
IMAGE_REF="ostree-image-signed:docker://ghcr.io/$IMAGE_VENDOR/$IMAGE_NAME"
IMAGE_BRANCH_NORMALIZED="stable"

case $FEDORA_MAJOR_VERSION in
  39|40)
    IMAGE_TAG="stable"
    ;;
  *)
    IMAGE_TAG="$FEDORA_MAJOR_VERSION"
    ;;
esac

cat > $IMAGE_INFO <<EOF
{
  "image-name": "$IMAGE_NAME",
  "image-flavor": "Developer Edition",
  "image-vendor": "$IMAGE_VENDOR",
  "image-ref": "$IMAGE_REF",
  "image-tag": "$IMAGE_TAG",
  "image-branch": "$IMAGE_BRANCH_NORMALIZED",
  "base-image-name": "Bazzite",
  "fedora-version": "$FEDORA_MAJOR_VERSION"
}
EOF