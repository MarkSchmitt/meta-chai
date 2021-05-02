inherit chai-image

IMAGE_INSTALL_append = " \
    alsa-utils \
    htop \
    rectangles \
"

IMAGE_FEATURES += " \
    splash \
    x11-base \
"

KERNEL_EXTRA_INSTALL += "\
    kernel-modules \
"

# VIRTUAL-RUNTIME_dev_manager = ""
# VIRTUAL-RUNTIME_login_manager = ""
# VIRTUAL-RUNTIME_init_manager = "tiny-init"
# VIRTUAL-RUNTIME_keymaps = ""