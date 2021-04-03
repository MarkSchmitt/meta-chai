FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable:"
SRC_URI += " \
    file://001-modify-sun8i-v3s.dtsi.patch \
    file://002-add-original-lichee-pi-zero-lcd-display.dtsi.patch \
    file://003-add-original-lichee-pi-zero-lcd-touchscreen.dtsi.patch \
    file://004-modify-sun8i-v3s-licheepi-zero.dts.patch \
    file://005-modify-sun8i-v3s-licheepi-zero-dock.dts.patch  \
"

COMPATIBLE_MACHINE = "(licheepizero|licheepizero-dock)"
