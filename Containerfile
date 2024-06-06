FROM ghcr.io/ublue-os/bazzite:stable AS quantix

COPY system_files/shared /

# Proton
RUN curl -o /tmp/ProtonMail-desktop-beta.rpm https://proton.me/download/mail/linux/ProtonMail-desktop-beta.rpm && \
    rpm-ostree install /tmp/ProtonMail-desktop-beta.rpm && \
    ostree container commit

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
        ninja-build \
        nasm \
        iasl \
        libuuid-devel \
        glib2-devel \
        pixman-devel \
        spice-protocol \
        spice-server-devel && \
    ostree container commit

# Finalise
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