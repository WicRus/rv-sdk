#!/usr/bin/env bash
set -e

SELF_PATH="$(dirname "$(realpath $0)")"
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

"$RKBIN_TOOLS"/tools/boot_merger \
        pack \
        -v 1.0 \
        -c -RV1106 \
        -1 "$TPL" \
        -2 "$USB" \
        -3 "$TPL" \
        -3 u-boot-spl.bin \
        -d 1 \
        -r 3 \
        -n \
        -o 1106_loader.bin
"$RKBIN_TOOLS"/tools/boot_merger \
        idb \
        -l 1106_loader.bin \
        -o idblock.bin

"$BR_DIR"/support/scripts/genimage.sh -c "$SELF_PATH"/genimage_sdcard.cfg

popd
