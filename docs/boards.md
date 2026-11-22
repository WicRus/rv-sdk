 # Buildroot external: boards

 ## Proccessor folders 11XX (1106/1126/1126b)
 * **busybox.fragment**\
 Busybox config "patch"
 * **genimage_sdcard.cfg**\
 [genimage](https://github.com/pengutronix/genimage) config to create a raw sdmmc image
 * **kernel_11XX_defconfig**\
 Linux kernel config
 * **kernel_11XX.its**\
 [mkimage](https://www.google.com/search?q=mkimage) config for a kernel [FIT](https://docs.u-boot-project.org/en/latest/usage/fit/)
 * **dts/*.dts**\
 A directory with device tree config for linux kernel
 * **post-image_11XX_(sdmmc,spi-nand).sh**\
 Post build scripts for create final images
 * **sqfs_exl.lst**\
 Exlude list for spi-nand squashfs
 * **u-boot_11XX.config**\
 Uboot config
 * **u-boot_11XX.dts**\
 Uboot device tree config
 * **u-boot_11XX.its**\
 [mkimage](https://www.google.com/search?q=mkimage) config for uboot [FIT](https://docs.u-boot-project.org/en/latest/usage/fit/) with TEE
 * **u-boot_11XX_atf-multi-file.its.m4**\
 [m4](https://www.gnu.org/software/m4/) template for [mkimage](https://www.google.com/search?q=mkimage) config for uboot [FIT](https://docs.u-boot-project.org/en/latest/usage/fit/) with ATF

 ## unused
 * **genimage_nor.cfg**\
 A base for [genimage](https://github.com/pengutronix/genimage) config to create a raw spi-nand image

 ## rockchip_tools\
 Some rockchip tools from [here](https://github.com/ArmSoM/tools), should be merged into [rockchip_bin](https://github.com/rockchip-linux/rkbin)
 * **pack_firmware**\
 _afptool_ and _rkImageMaker_ tools for creation update image
 * **upgrade_tool**\
 _upgrade\_tool_ tool for flash update image via maskrom mode

