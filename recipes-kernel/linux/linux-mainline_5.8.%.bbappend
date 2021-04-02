LINUX_VERSION = "5.8"
FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-${LINUX_VERSION}:"
SRC_URI += " \
    file://defconfig \
"

COMPATIBLE_MACHINE = "(licheepizero|licheepizero-dock)"
LINUX_VERSION_EXTENSION = "-chai"

PR_append = ".chai"