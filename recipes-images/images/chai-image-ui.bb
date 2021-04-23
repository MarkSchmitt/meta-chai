inherit chai-image

IMAGE_INSTALL_append = " \
    alsa-utils \
    htop \
"

IMAGE_FEATURES += " \
    splash \
    x11-base \
"

KERNEL_EXTRA_INSTALL += "\
    kernel-modules \
    sunxi-mali \
"
