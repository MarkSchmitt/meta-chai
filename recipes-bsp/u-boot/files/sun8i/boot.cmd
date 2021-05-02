setenv load_fdt_mmc 'load mmc ${mmc_num}:${mmc_partition} ${fdt_addr_r} ${fdtfile} || load mmc ${mmc_num}:${mmc_partition} ${fdt_addr_r} boot/${fdtfile}'
setenv load_kernel_mmc 'load mmc ${mmc_num}:${mmc_partition} ${kernel_addr_r} zImage || load mmc ${mmc_num}:${mmc_partition} ${kernel_addr_r} boot/zImage'
setenv boot_flash 'echo booting from SPI flash to RAM... && sf probe && sf read ${fdt_addr_r} 0x0e0000 0x010000 && sf read ${kernel_addr_r} 0x100000 0x4e2000'

sf probe
itest.b *0x28 == 0x00 && mmc_num=0; mmc_partition=1; sf probe; run load_fdt_mmc; run load_kernel_mmc; rootdev="root=/dev/mmcblk${mmc_num}p2"
itest.b *0x28 == 0x02 && mmc_num=1; mmc_partition=1; sf probe; run load_fdt_mmc; run load_kernel_mmc; rootdev="root=/dev/mmcblk${mmc_num}p2"
# itest.b *0x28 == 0x03 && run boot_flash && rootdev="rootfstype=ubifs root=ubi0:rootfs rw"
itest.b *0x28 == 0x03 && run boot_flash && rootdev="rootfstype=jffs2 root=/dev/mtd5 rw"

setenv bootargs console="${console}" "${rootdev}" rootwait panic=10
bootz ${kernel_addr_r} - ${fdt_addr_r} || bootm ${kernel_addr_r} - ${fdt_addr_r}
