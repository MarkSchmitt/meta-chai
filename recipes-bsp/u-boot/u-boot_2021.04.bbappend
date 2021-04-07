FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_sun8i = " \
    file://boot.cmd \
"

UBOOT_ENV = "boot"
UBOOT_ENV_SUFFIX = "scr"

do_compile_append() {
    ${B}/tools/mkimage -C none -A arm -T script -d ${WORKDIR}/boot.cmd ${WORKDIR}/${UBOOT_ENV_BINARY}
}