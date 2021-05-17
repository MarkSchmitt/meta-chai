# meta-chai

yocto layer for lichee-pi zero (Allwinner V3s) based on mainline u-boot 2021.xx and kernel 5.x

for easy start
```bash
repo init -u git@github.com:DAMEK86/lichee-manifests.git
repo sync
```

## How to use

For instance if you like to build variant `licheepizero-dock`, you can start with the following bash script:

```bash
export TEMPLATECONF=$PWD/sources/meta-chai/conf/variant/licheepizero-dock
source sources/poky/oe-init-build-env build

bitbake chai-image
``` 

## Preparations on gentoo:

```
sudo emerge -a chrpath diffstat
```

## how to use zero-dock mic

First of all, the v3s audio coded has no MIC1 bias. Instead, it looks to me like an differential input. I was able to get the mic working by changing the MIC setting from single ended to Left/Right within `alsamixer`.

![ALSA settings](./docu/assets/alsa-settings.png)

For easy verification, use the _chai-image-audio_ with the alsa-tools. Just plugin your headphone, setup ALSA like the picture above and run `alsaloop` and verify the microphone 😎️

## enable/disable kernel features

depending on the enabled machine features, kernel features are added.  
- alsa - sound and codec are baked in
- screen - FB are backed in
- touchscreen - PWM and Touchscreen for NS2009 (onboard) is backed in

you can add machine features by edit `conf/local.conf`  
just use `MACHINE_FEATURES_append` or `MACHINE_FEATURES_remove`
## shutdown / reboot

The Zero and Zero-Dock uses an __EA3036__ PMIC with routed __enable__ pins to 5V. As a result, the power consumption will not drop to _zero_ on a `shutdown`. A possible workaround could be using a pin to drive a _self-holding circuit_.  
`reboot` instead works as expected.

## u-boot / network boot

### tftp

on startup you can download kernel and corresponding device-tree over tftp

```bash
setenv ipaddr <licheeip>
tftp 0x42000000 <serverip>:zImage; tftp 0x43000000 <serverip>:sun8i-v3s-licheepi-zero-dock.dtb; bootz 0x42000000 - 0x43000000"
```

HINT: u-boot reads unique mac from chip

as a starting point, you can use this simple script to host a local tftp server in docker

```bash
docker run --rm -it -p 69:69/udp \
    -v ${PWD}/zImage:/tftpboot/zImage:ro \
    -v ${PWD}/sun8i-v3s-licheepi-zero-dock.dtb:/tftpboot/sun8i-v3s-licheepi-zero-dock.dtb:ro \
    darkautism/k8s-tftp
```

this image is based on a tiny golang implementation and works very well for my purposes, see https://github.com/darkautism/k8s-tftp

### network boot manually

to enable network boot, you need to enable kernel features by adding `KERNEL_ENABLE_NFS = "1"` to your ____local.conf__.  
after this, your kernel shall be able to mount a nfs as rootfs

use the kernel cmdline to tell the kernel we want to use a network rootfs. I used the following script in u-boot cmd for my testing:

```bash
setenv bootargs "console=ttyS0,115200 root=/dev/nfs ip=192.168.5.78:192.168.5.80:192.168.5.80:255.255.255.0:licheepizero-dock:eth0 nfsroot=192.168.5.80:/export rootwait panic=2 debug"
setenv origbootcmd "$bootcmd"
setenv ipaddr 192.168.5.78
setenv bootcmd "tftp 0x42000000 192.168.5.80:zImage; tftp 0x43000000 192.168.5.80:sun8i-v3s-licheepi-zero-dock.dtb; bootz 0x42000000 - 0x43000000"
run bootcmd
```

### automatic network boot with pxe

To boot using the u-boot PXE implementation, modify the boot.cmd (or enter manually):
```
dhcp
pxe boot
```

And place this file into the tftp servers directory `/pxelinux.cfg/default` (this is the most default file used, you can also use a more specific one - just start it up and see what files u-boot tries to load before).
```
LABEL stable
        KERNEL zImage
        FDT sun8i-v3s-licheepi-zero-dock.dtb
        APPEND console=ttyS0,115200 root=/dev/nfs ip=dhcp nfsroot=192.168.0.2:/srv/lichee_export_rootfs,tcp,v3 rootwait panic=2 debug 
```
Place the zImage and dtb file into the `/pxelinux.cfg` directory - they're searched for always relative to the config file. I think you can also use absolute paths in the config file.

If your tftp server is not served on the same ip-address as your dhcp server,  you'll also need to configure your dhcp server to add it to the dhcp response.
TODO: describe this for several usual dhcp servers. ('server-next' parameter, opnsense network boot). Most dhcp servers can be configured to serve invidual responses per client,
this way, you can serve different default files and use this as another way to boot another pxe config file.

### nfs

for a detailed description of nfsroot parameters see https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt

as a starting point, you can use the following docker image or *nfs-kernel-server*

```bash
docker run --rm -it \
  -v ${PWD}/export:/export \
  -v ${PWD}/exports.txt:/etc/exports:ro \
  --privileged \
  -p 2049:2049 \
  erichough/nfs-server
```

the image is based on alpine and nfs-utils, see https://github.com/ehough/docker-nfs-server

as a reference have a look into https://community.arm.com/developer/tools-software/oss-platforms/w/docs/542/nfs-remote-network-userspace-using-u-boot or  
http://linux-sunxi.org/How_to_boot_the_A10_or_A20_over_the_network#TFTP_booting

both, docker image and native installation had the same result - `VFS: Unable to mount root fs via NFS.` - MRs are welcome :)

```bash
[    1.259677] dwmac-sun8i 1c30000.ethernet eth0: PHY [0.1:01] driver [Generic PHY] (irq=POLL)
[    1.269426] dwmac-sun8i 1c30000.ethernet eth0: No Safety Features support found
[    1.276821] dwmac-sun8i 1c30000.ethernet eth0: No MAC Management Counters available
[    1.284520] dwmac-sun8i 1c30000.ethernet eth0: PTP not supported by HW
[    1.291567] dwmac-sun8i 1c30000.ethernet eth0: configuring for phy/mii link mode
[    3.364972] dwmac-sun8i 1c30000.ethernet eth0: Link is Up - 100Mbps/Half - flow control off
[    3.424470] IP-Config: Complete:
[    3.427730]      device=eth0, hwaddr=d2:67:bd:63:57:03, ipaddr=192.168.5.78, mask=255.255.255.0, gw=192.168.5.80
[    3.437919]      host=licheepizero-dock, domain=, nis-domain=(none)
[    3.444182]      bootserver=192.168.5.80, rootserver=192.168.5.80, rootpath=
[    4.596375] random: fast init done
[   33.764479] vcc3v3: disabling
[   33.767481] vcc5v0: disabling
[   99.686785] VFS: Unable to mount root fs via NFS.
[   99.691635] devtmpfs: mounted
[   99.696554] Freeing unused kernel memory: 1024K
[   99.714820] Run /sbin/init as init process
[   99.718933]   with arguments:
[   99.721898]     /sbin/init
[   99.724664]     nfsrootdebug
[   99.727545]   with environment:
[   99.730683]     HOME=/
[   99.733041]     TERM=linux
[   99.736102] Run /etc/init as init process
[   99.740129]   with arguments:
[   99.743095]     /etc/init
[   99.745809]     nfsrootdebug
[   99.748692]   with environment:
[   99.751829]     HOME=/
[   99.754186]     TERM=linux
[   99.757168] Run /bin/init as init process
[   99.761187]   with arguments:
[   99.764151]     /bin/init
[   99.766855]     nfsrootdebug
[   99.769736]   with environment:
[   99.772875]     HOME=/
[   99.775259]     TERM=linux
[   99.778499] Run /bin/sh as init process
[   99.782352]   with arguments:
[   99.785403]     /bin/sh
[   99.787853]     nfsrootdebug
[   99.790746]   with environment:
[   99.793885]     HOME=/
[   99.796275]     TERM=linux
[   99.799327] Kernel panic - not syncing: No working init found.  Try passing init= option to kernel. See Linux Documentation/admin-guide/init.rst for guidance.
```

## sunxi-tools / flash boot

sunxi-tools from github can be used for u-boot / kernel developing and nor-flash programming  
__HINT:__ official prebuilt packages for ubuntu/debian seems to not working on ubuntu 20.x
### how to build sunxi-tools

```bash
sudo apt install libfdt-dev libusb-1.0-0-dev
git clone git@github.com:linux-sunxi/sunxi-tools.git
cd sunxi-tools
make
```

### fel boot

```bash
sudo sunxi-tools/sunxi-fel -v uboot u-boot-sunxi-with-spl.bin \
    write 0x42000000 zImage \
    write 0x43000000 sun8i-v3s-licheepi-zero-dock.dtb \
    write 0x43100000 boot.scr
```

### program flash and boot from fel / flash

write kernel, dtb to flash and start uboot from fel cli
```bash
sudo ./sunxi-tools/sunxi-fel \
    spiflash-write 0x0e0000 sun8i-v3s-licheepi-zero-dock-licheepizero-dock.dtb \
    spiflash-write 0x100000 zImage-licheepizero-dock.bin
sudo ./sunxi-tools/sunxi-fel uboot u-boot-sunxi-with-spl.bin
```
for booting from flash
```bash
sudo ./sunxi-tools/sunxi-fel spiflash-write 0x0 u-boot-sunxi-with-spl.bin
```
