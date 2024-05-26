FROM ghcr.io/ublue-os/bazzite:stable AS quantix

ARG BASE_IMAGE_NAME="bazzite"
ARG IMAGE_NAME="${IMAGE_NAME:-quantix}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-epicofficer}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
ARG IMAGE_BRANCH="${IMAGE_BRANCH:-stable}"
ARG FEDORA_MAJOR_VERSION=40

COPY system_files/shared /

# Download Protonmail RPM
RUN curl -o /tmp/ProtonMail-desktop-beta.rpm https://proton.me/download/mail/linux/ProtonMail-desktop-beta.rpm

# Install new packages
RUN rpm-ostree install \
        adobe-source-code-pro-fonts \
        cascadia-code-fonts \
        jetbrains-mono-fonts-all \
        ibm-plex-mono-fonts \
        virt-manager \
        virt-viewer \
        edk2-ovmf \
        libvirt \
        qemu \
        qemu-char-spice \
        qemu-device-display-virtio-gpu \
        qemu-device-display-virtio-vga \
        qemu-device-usb-redirect \
        qemu-img \
        qemu-system-x86-core \
        qemu-user-binfmt \
        qemu-user-static \
        code \
        docker-ce \
        docker-ce-cli \
        docker-buildx-plugin \
        docker-compose-plugin \
        podman-compose \
        podman-tui \
        podmansh \
        papirus-icon-theme \
        libXpresent \
        /tmp/ProtonMail-desktop-beta.rpm && \
    ostree container commit

RUN systemctl unmask quantix-flatpak-manager.service && \
    systemctl enable quantix-flatpak-manager.service && \
    systemctl enable quantix-system-setup.service && \
    systemctl enable docker.socket && \
    systemctl enable libvirtd && \
    systemctl enable swtpm-workaround && \
    systemctl --global enable quantix-user-setup.service && \
    systemctl --global enable podman.socket && \
    sed -i '/^PRETTY_NAME/s/Bazzite/Quantix/' /usr/lib/os-release && \
    sed -i 's/plasma.svgz/quantix_logo.svgz/g' /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/Splash.qml && \
    /usr/libexec/containerbuild/qtx-image-info && \
    ostree container commit