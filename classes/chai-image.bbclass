DESCRIPTION = "A striped console image for Lichee Pi Zero, Zero-Dock Boards"
LICENSE = "MIT"

#Always add cmake to sdk
TOOLCHAIN_HOST_TASK_append = " nativesdk-cmake"

DESCRIPTION = "A console image for Lichee Pi Zero, Zero-Dock Boards"
LICENSE = "MIT"

NETWORK_APP = " \
    openssh openssh-keygen \
"

IMAGE_LINGUAS = ""

inherit core-image

KERNEL_EXTRA_INSTALL = " \
    kernel-devicetree \
 "

UTILITIES_INSTALL = " \
    coreutils \
    mtd-utils \
    ldd \
"

IMAGE_INSTALL += " \
  ${UTILITIES_INSTALL} \
  ${NETWORK_APP} \
  ${KERNEL_EXTRA_INSTALL} \
"

# no root password
EXTRA_IMAGE_FEATURES = "debug-tweaks"

USER_CLASSES = "buildstats image-mklibs image-prelink"

#Always add cmake to sdk
TOOLCHAIN_HOST_TASK_append = " nativesdk-cmake"

VIRTUAL-RUNTIME_dev_manager = "busybox-mdev"
TCLIBC = "musl"

DISTRO_FEATURES = " ext2 rtc serial usbgadget"

IMAGE_ROOTFS_EXTRA_SPACE = "0"

PACKAGE_EXCLUDE = "busybox-syslog busybox-udhcpc ncurses-terminfo-base thin-provisioning-tool"