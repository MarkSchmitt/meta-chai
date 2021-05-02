HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
DESCRIPTION="Upstream's U-boot"
AUTHOR = "Andreas Rehn <rehn.andreas86@gmail.com>"

UBOOT_VERSION = "2021.04"

require u-boot-common.inc
require u-boot.inc

DEPENDS += "bc-native dtc-native python3-setuptools-native"

PV = "v${UBOOT_VERSION}+git${SRCPV}"
