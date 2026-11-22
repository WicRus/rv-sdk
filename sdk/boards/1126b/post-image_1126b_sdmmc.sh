#!/usr/bin/env bash
set -e

SELF_PATH="$(dirname "$(realpath $0)")"
RKBIN_TOOLS=$(ls -d "$BUILD_DIR"/* | grep rockchip-rkbin)

TEE_FULL="$(sed -n 's/^BR2_PACKAGE_ROCKCHIP_RKBIN_EXT_TEE_FILENAME="\(.*\)"$/\1/p' "${BR2_CONFIG}")"
TPL_FULL="$(sed -n 's/^BR2_PACKAGE_ROCKCHIP_RKBIN_EXT_TPL_FILENAME="\(.*\)"$/\1/p' "${BR2_CONFIG}")"
USB_FULL="$(sed -n 's/^BR2_PACKAGE_ROCKCHIP_RKBIN_EXT_BL31_FILENAME="\(.*\)"$/\1/p' "${BR2_CONFIG}")"
KERNEL_DTS="$(sed -n 's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\(.*\)"$/\1/p' "${BR2_CONFIG}")"
TEE=${TEE_FULL##*/}
TPL=${TPL_FULL##*/}
USB=${USB_FULL##*/}

pushd "$BINARIES_DIR"
ln -sfr "$KERNEL_DTS".dtb kernel.dtb
ln -sfr "$SELF_PATH"/kernel_1126b.its kernel.its

openssl dgst -sha256 -binary -out u-boot-nodtb.bin.digest u-boot-nodtb.bin
gzip -fk9 u-boot-nodtb.bin

DUMP=$(aarch64-linux-readelf -l "$TEE")
EP_STR=$(grep Entry <<< "$DUMP")
EP=${EP_STR##* }

IFS=$'\n'
SEGMETS_STR=($(grep LOAD <<< "$DUMP"))
SECTIONS_STR=($(grep "^   0" <<< "$DUMP" | grep -F "."))
for s in "${SEGMETS_STR[@]}";  do SEGMETS+=("0x${s##* 0x}"); done
for s in "${SECTIONS_STR[@]}"; do SECTIONS+=(".${s#*.}"); done
IFS=' '

[ ${#SEGMETS[@]} != ${#SECTIONS[@]} ] && echo "Error segment[${#SEGMETS[@]}] != sections[${#SECTIONS[@]}] for $TEE" && echo "$DUMP" && exit 1

for i in "${!SEGMETS[@]}"; do
  aarch64-linux-objcopy -O binary `sed 's/\./-j./g' <<< "${SECTIONS[i]}"` "$TEE" "${SEGMETS[i]}".bin
  if (( ${SEGMETS[i]} == $EP )); then
    openssl dgst -sha256 -binary -out "${SEGMETS[i]}".bin.digest "${SEGMETS[i]}".bin
    gzip -fk9 "${SEGMETS[i]}".bin
    ITS+="
    atf {
       description = \"ARM Trusted Firmware\";
       data = /incbin/(\"./"${SEGMETS[i]}".bin.gz\");
       type = \"firmware\";
       arch = \"arm64\";
       os = \"arm-trusted-firmware\";
       compression = \"gzip\";
       load = <"${SEGMETS[i]}">;
       hash {
         algo = \"sha256\";
       };
       digest {
         value = /incbin/(\"./"${SEGMETS[i]}".bin.digest\");
         algo = \"sha256\";
       };
     };"
  else
    ITS_L+=", \"atf$i\""
    ITS+="
    atf$i {
       description = \"ARM Trusted Firmware\";
       data = /incbin/(\"./"${SEGMETS[i]}".bin\");
       type = \"firmwar\";
       arch = \"arm64\";
       os = \"arm-trusted-firmware\";
       compression = \"none\";
       load = <"${SEGMETS[i]}">;
       hash {
         algo = \"sha256\";
       };
     };"
  fi
done

m4 -DITS="$ITS" -DLTS="$ITS_L" "$SELF_PATH"/u-boot_1126b_atf-multi-file.its.m4 > u.its

# aarch64-linux-objcopy -O binary "$TEE" "atf.bin"
# openssl dgst -sha256 -binary -out "atf.bin.digest" "atf.bin"
# gzip -fk9 "atf.bin"
# m4 -DLOAD_ATF="${SEGMETS[0]}" -DENTR_ATF="$EP" "$SELF_PATH"/u-boot_1126b_atf-single-file.its.m4 > u.its

mkimage -E -p 0x1200 -f u.its uboot.img
mkimage -E -p 0x800  -f kernel.its kernel.img

# $RKBIN_TOOLS/tools/boot_merger \
#         pack \
#         -v 1.0 \
#         -c -RV110F \
#         -1 $TPL \
#         -2 $USB \
#         -3 $TPL \
#         -3 rv1126b_spl_v1.06.bin \
#         -d 1 \
#         -s 1 \
#         -r 3 \
#         -n \
#         -q b1.txt \
#         -o 1126b_loader.bin
# $RKBIN_TOOLS/tools/boot_merger \
#         idb \
#         -n \
#         -l 1126b_loader.bin \
#         -o idblock.bin

# using ini file instead cli befor find how set loader2 params

cat << EOF > 1126b.ini
[CHIP_NAME]
NAME=RV110F
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
[LOADER2_PARAM]
LOAD_ADDR=0x4fe00000
FLAG=0x0
[OUTPUT]
PATH=1126b_loader.bin
IDB_PATH=idblock.bin
[SYSTEM]
NEWIDB=true
[FLAG]
471_RC4_OFF=true
RC4_OFF=true
CREATE_IDB=true
EOF

"$RKBIN_TOOLS"/tools/boot_merger 1126b.ini

"$BR_DIR"/support/scripts/genimage.sh -c "$SELF_PATH/genimage_sdcard.cfg"

popd
