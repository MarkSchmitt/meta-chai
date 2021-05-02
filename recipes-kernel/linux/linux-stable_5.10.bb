require linux-stable.inc

DESCRIPTION = "Mainline LTS Linux kernel"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

LINUX_VERSION = "5.10"
LINUX_VERSION_EXTENSION = "-chai"

PV = "5.10.34"
SRCREV = "dcee53f60bf35376343e5ede00c7466d02888ccc"
SRCREV_meta = "219eb2a3662ee00aa048a9b496e0e6c9a80ce50a"
KMETA = "kernel-meta"

SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-${LINUX_VERSION}.y \
    git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=yocto-${LINUX_VERSION};destsuffix=${KMETA} \
"

KERNEL_FEATURES_append = " \
    features/spi/spi.scc \
    features/pwm/pwm.scc \
"