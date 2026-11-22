#!/usr/bin/env bash
set -e

SELF_PATH="$(dirname "$(realpath $0)")"

TEE_FULL="$(sed -n 's/^BR2_PACKAGE_ROCKCHIP_RKBIN_TEE_FILENAME="\(.*\)"$/\1/p' "${BR2_CONFIG}")"
TPL_FULL="$(sed -n 's/^BR2_PACKAGE_ROCKCHIP_RKBIN_TPL_FILENAME="\(.*\)"$/\1/p' "${BR2_CONFIG}")"
KERNEL_DTS="$(sed -n 's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\(.*\)"$/\1/p' "${BR2_CONFIG}")"
TEE=${TEE_FULL##*/}
TPL=${TPL_FULL##*/}

pushd "$BINARIES_DIR"
ln -sfr "$KERNEL_DTS.dtb" kernel.dtb
ln -sfr "$SELF_PATH/u-boot_1126.its" uboot.its
ln -sfr "$SELF_PATH/kernel_1126.its" kernel.its

gzip -fk9 -c "$TEE" > tee.bin.gz
gzip -fk9 u-boot-nodtb.bin
openssl dgst -sha256 -binary -out u-boot-nodtb.digest u-boot-nodtb.bin
openssl dgst -sha256 -binary -out tee.digest "$TEE"
mkimage -E -p 0xE00 -f uboot.its uboot.img

mkimage -n rv1126 -T rksd -d "$TPL":u-boot-spl.bin idblock.bin
mkimage -E -p 0x800 -f kernel.its kernel.img

"$BR_DIR"/support/scripts/genimage.sh -c "$SELF_PATH"/genimage_sdcard.cfg

popd
