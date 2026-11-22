#!/usr/bin/env bash
set -e

SELF_PATH="$(dirname "$(realpath $0)")"
TOOLS="$SELF_PATH"/../rockchip_tools
RKBIN_TOOLS=$(ls -d "$BUILD_DIR"/* | grep rockchip-rkbin)

KERNEL_DTS="$(sed -n 's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\(.*\)"$/\1/p' "${BR2_CONFIG}")"
TEE_FULL="$(sed -n 's/^BR2_PACKAGE_ROCKCHIP_RKBIN_TEE_FILENAME="\(.*\)"$/\1/p' "${BR2_CONFIG}")"
TPL_FULL="$(sed -n 's/^BR2_PACKAGE_ROCKCHIP_RKBIN_TPL_FILENAME="\(.*\)"$/\1/p' "${BR2_CONFIG}")"
USB_FULL="$(sed -n 's/^BR2_PACKAGE_ROCKCHIP_RKBIN_BL31_FILENAME="\(.*\)"$/\1/p' "${BR2_CONFIG}")"
TEE=${TEE_FULL##*/}
TPL=${TPL_FULL##*/}
USB=${USB_FULL##*/}

pushd "$BINARIES_DIR"
ln -sfr "$KERNEL_DTS".dtb kernel.dtb
ln -sfr "$SELF_PATH"/u-boot_1106.its uboot.its
ln -sfr "$SELF_PATH"/kernel_1106.its kernel.its

gzip -kf9 -c "$TEE" > tee.bin.gz
gzip -kf9 u-boot-nodtb.bin
openssl dgst -sha256 -binary -out u-boot-nodtb.digest u-boot-nodtb.bin
openssl dgst -sha256 -binary -out tee.digest "$TEE"
mkimage -E -p 0xE00 -f uboot.its uboot.img
mkimage -E -p 0x800 -f kernel.its kernel.img

cat > ubi.cfg  << EOF
[ubifs]
mode=ubi
vol_id=0
vol_type=static
vol_name=rootfs
vol_alignment=1
vol_flags=autoresize
image=$BINARIES_DIR/rootfs.squashfs
EOF

cat << EOF > 1106.ini
[CHIP_NAME]
NAME=RV1106
[VERSION]
MAJOR=1
MINOR=0
[CODE471_OPTION]
NUM=1
Path1=$TPL
Sleep=1
[CODE472_OPTION]
NUM=1
Path1=$USB
[LOADER_OPTION]
NUM=2
LOADER1=FlashData
LOADER2=FlashBoot
FlashData=$TPL
FlashBoot=u-boot-spl.bin
[OUTPUT]
PATH=1106_loader.bin
[SYSTEM]
NEWIDB=true
[FLAG]
471_RC4_OFF=true
RC4_OFF=true
EOF

cat << EOF > package-file
package-file package-file
bootloader   1106_loader.bin
parameter    param.txt
uboot        uboot.img
boot         kernel.img
rootfs       rootfs.squashfsubi
backup       RESERVED
EOF

cat << EOF > param.txt
FIRMWARE_VER: 1.0
MACHINE_MODEL: RV1106
MACHINE_ID: 007
MANUFACTURER: RV1106
MAGIC: 0x5041524B
ATAG: 0x00200800
MACHINE: 0xffffffff
CHECK_MASK: 0x80
PWR_HLD: 0,0,A,0,1
TYPE: GPT
CMDLINE: mtdparts=rk29xxnand:0x00000100@0x0000700(vnvm),0x00002000@0x00000800(uboot),0x00004000@0x00002800(boot),0x0002A000@0x00006800(rootfs),0x00000400@0x00032800(misc),-@0x00038C00(userdata:grow)
uuid:rootfs=614e0000-0000-4b53-8000-1d28000054a9
EOF

"$RKBIN_TOOLS"/tools/boot_merger 1106.ini
ubinize -o rootfs.squashfsubi -m 2048 -p 0x20000 -v ubi.cfg
"$TOOLS"/pack_firmware/afptool -pack ./ tmp.img
"$TOOLS"/pack_firmware/rkImageMaker -RV1106 1106_loader.bin tmp.img 1106_update.img -os_type:androidos

popd
