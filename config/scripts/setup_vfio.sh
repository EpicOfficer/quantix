#!/usr/bin/env bash

set -oue pipefail

CPU_VENDOR=$(grep "vendor_id" "/proc/cpuinfo" | uniq | awk -F": " '{ print $2 }')
VENDOR_KARG="unset"

echo 'add_drivers+=" vfio vfio_iommu_type1 vfio-pci "' | sudo tee /etc/dracut.conf.d/vfio.conf
rpm-ostree initramfs --enable

if [[ ${CPU_VENDOR} == "AuthenticAMD" ]]; then
    VENDOR_KARG="amd_iommu=on"
elif [[ ${CPU_VENDOR} == "GenuineIntel" ]]; then
    VENDOR_KARG="intel_iommu=on"  
fi
if [[ ${VENDOR_KARG} == "unset" ]]; then
    echo "Failed to get CPU vendor, exiting..."
    exit 1
else
    rpm-ostree kargs \
    --append-if-missing="kvm.ignore_msrs=1" \
    --append-if-missing="kvm.report_ignored_msrs=0" \
    --append-if-missing="${VENDOR_KARG}" \
    --append-if-missing="iommu=pt" \
    --append-if-missing="rd.driver.pre=vfio_pci" \
    --append-if-missing="vfio_pci.disable_vga=1"
fi