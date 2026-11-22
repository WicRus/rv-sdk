 # Buildroot external: configs

* **CPU, architecture and extensions**
  ```bash
    BR2_arm=y
    BR2_cortex_a7=y
    BR2_ARM_EABIHF=y
  ```

* **Toolchain external**\
  Use already compiled toolchain
  Specify ther kernel header version, gcc version and supported features here
  ```bash
  BR2_TOOLCHAIN_EXTERNAL=y
  BR2_TOOLCHAIN_EXTERNAL_CUSTOM=y
  BR2_TOOLCHAIN_EXTERNAL_PATH="$(BR2_EXTERNAL_RV_SDK_PATH)/prebuilts/gcc/linux-x86/arm/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf"
  BR2_TOOLCHAIN_EXTERNAL_CUSTOM_PREFIX="arm-linux-gnueabihf"
  BR2_TOOLCHAIN_EXTERNAL_GCC_8=y
  BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_19=y
  BR2_TOOLCHAIN_EXTERNAL_CUSTOM_GLIBC=y
  BR2_TOOLCHAIN_EXTERNAL_CXX=y
  BR2_TOOLCHAIN_EXTERNAL_FORTRAN=y
  BR2_TOOLCHAIN_EXTERNAL_OPENMP=y
  ```

* **Toolchain internal**\
  Compile a toolchain on build
  Specify the libc implementation (glibc uclibc musl) and supported features\
  Additional, specify the kernel version
  ```bash
  BR2_TOOLCHAIN_BUILDROOT_GLIBC=y
  BR2_TOOLCHAIN_BUILDROOT_CXX=y
  BR2_LINUX_KERNEL_CUSTOM_VERSION=y
  BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="6.1.141"
  BR2_KERNEL_HEADERS_AS_KERNEL=y
  BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_6_1=y
  ```

* **Build configuration**\
  Optimization, exlude strip, enable debug
  ```bash
  BR2_CCACHE=y
  # BR2_ENABLE_DEBUG is not set
  # BR2_ENABLE_RUNTIME_DEBUG is not set
  # BR2_STRIP_strip=y
  # BR2_STRIP_EXCLUDE_FILES=""
  # BR2_STRIP_EXCLUDE_DIRS=""
  # BR2_OPTIMIZE_0 is not set
  # BR2_OPTIMIZE_1 is not set
  # BR2_OPTIMIZE_2=y
  ```

* **Source override config**
  ```bash
  BR2_PACKAGE_OVERRIDE_FILE="$(BR2_EXTERNAL_RV_SDK_PATH)/overrides/1126b.mk"
  # Patches not applying for overrided packages!
  ```

* **Linux kernel**\
  Enable linux, specify compression, config, device tree
  ```bash
  BR2_LINUX_KERNEL=y
  BR2_LINUX_KERNEL_XZ=y
  BR2_LINUX_KERNEL_IMAGEGZ=y
  BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
  BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="$(BR2_EXTERNAL_RV_SDK_PATH)/boards/1126b/kernel_1126b_defconfig"
  BR2_LINUX_KERNEL_DTS_SUPPORT=y
  BR2_LINUX_KERNEL_CUSTOM_DTS_DIR="$(BR2_EXTERNAL_RV_SDK_PATH)/boards/1126b/dts"
  BR2_LINUX_KERNEL_INTREE_DTS_NAME="br-ext_1126b_sdmmc_minimal"
  BR2_LINUX_KERNEL_APPENDED_DTB=y
  ```

* **Uboot**\
  Enable uboot, specify config, device tree, change name
  ```bash
  BR2_TARGET_UBOOT=y
  BR2_TARGET_UBOOT_BUILD_SYSTEM_KCONFIG=y
  BR2_TARGET_UBOOT_USE_CUSTOM_CONFIG=y
  BR2_TARGET_UBOOT_CUSTOM_CONFIG_FILE="$(BR2_EXTERNAL_RV_SDK_PATH)/boards/1126b/u-boot_1126b.config"
  BR2_TARGET_UBOOT_FORMAT_DTB=y
  BR2_TARGET_UBOOT_FORMAT_CUSTOM=y
  BR2_TARGET_UBOOT_FORMAT_CUSTOM_NAME="u-boot-nodtb.bin"
  BR2_TARGET_UBOOT_SPL=y
  BR2_TARGET_UBOOT_NEEDS_DTC=y
  BR2_TARGET_UBOOT_CUSTOM_DTS_PATH="$(BR2_EXTERNAL_RV_SDK_PATH)/boards/1126b/u-boot_1126b.dts"
  BR2_TARGET_UBOOT_CUSTOM_MAKEOPTS="DEVICE_TREE=u-boot_1126b"
  ```

* **Busybox**\
  Specify full config or change default via fragment
  ```bash
  BR2_PACKAGE_BUSYBOX_SHOW_OTHERS=y
  BR2_PACKAGE_BUSYBOX_CONFIG_FRAGMENT_FILES="$(BR2_EXTERNAL_RV_SDK_PATH)/boards/1126b/busybox.fragment"
  ```

* **Blobs for boot**\
  Rockchip binaries for a loader
  ```bash
  BR2_PACKAGE_ROCKCHIP_RKBIN_EXT=y
  BR2_PACKAGE_ROCKCHIP_RKBIN_EXT_TEE_FILENAME="bin/rv11/rv1126b_bl31_v1.13.elf"
  BR2_PACKAGE_ROCKCHIP_RKBIN_EXT_TPL_FILENAME="bin/rv11/rv1126bp_ddr_1056MHz_v1.10.bin"
  BR2_PACKAGE_ROCKCHIP_RKBIN_EXT_BL31_FILENAME="bin/rv11/rv1126b_usbplug_v1.03.bin"
  ```

* **Build scripts**\
  And scripts arguments
  ```bash
  # BR2_ROOTFS_PRE_BUILD_SCRIPT
  # string "Custom scripts to run before commencing the build"
  # BR2_ROOTFS_PRE_BUILD_SCRIPT_ARGS

  # BR2_ROOTFS_POST_BUILD_SCRIPT
  # string "Custom scripts to run before creating filesystem images"
  # BR2_ROOTFS_POST_BUILD_SCRIPT_ARGS

  # BR2_ROOTFS_POST_FAKEROOT_SCRIPT
  # string "Custom scripts to run inside the fakeroot environment"
  # BR2_ROOTFS_POST_FAKEROOT_SCRIPT_ARGS

  BR2_ROOTFS_POST_IMAGE_SCRIPT="$(BR2_EXTERNAL_RV_SDK_PATH)/boards/1126b/post-image_1126b_sdmmc.sh"
  # string "Custom scripts to run after creating filesystem images"
  # BR2_ROOTFS_POST_IMAGE_SCRIPT_ARGS
  ```

* **Build scripts dependencies**\
  Host packages required by build scripts
  ```bash
  BR2_PACKAGE_HOST_DTC=y
  BR2_PACKAGE_HOST_GENIMAGE=y
  BR2_PACKAGE_HOST_UBOOT_TOOLS=y
  BR2_PACKAGE_HOST_UBOOT_TOOLS_FIT_SUPPORT=y
  BR2_PACKAGE_HOST_UBOOT_TOOLS_FIT_SIGNATURE_SUPPORT=y
  ```

* **Filesystems**\
  Enable/disable filesystems support, those parameters and support packages
  ```bash
  BR2_TARGET_ROOTFS_EXT2=y
  BR2_TARGET_ROOTFS_EXT2_4=y
  BR2_TARGET_ROOTFS_EXT2_SIZE="80M"
  # BR2_TARGET_ROOTFS_TAR is not set
  BR2_PACKAGE_MTD=y
  ```

* **System configuration**\
  Timezones, locales, console params, etc
  ```bash
  BR2_ENABLE_LOCALE_WHITELIST="C en_US"
  BR2_GENERATE_LOCALE="en_US"

  BR2_TARGET_TZ_INFO=y
  BR2_TARGET_LOCALTIME="Etc/GMT+12"

  BR2_TARGET_GENERIC_GETTY=y
  BR2_TARGET_GENERIC_GETTY_PORT="ttyFIQ0"
  BR2_TARGET_GENERIC_GETTY_BAUDRATE_KEEP=y
  BR2_TARGET_GENERIC_HOSTNAME="xos"
  BR2_TARGET_GENERIC_ISSUE="Welcome to xos"
  BR2_TARGET_GENERIC_ROOT_PASSWD="123"
  BR2_SYSTEM_DHCP="eth0"
  ```

* **Other**
  ```bash
  # use bash
  BR2_SYSTEM_BIN_SH_BASH=y

  # set patch dir
  BR2_GLOBAL_PATCH_DIR="$(BR2_EXTERNAL_RV_SDK_PATH)/patches_11XX"

  # set rootfs overlay folder
  BR2_ROOTFS_OVERLAY="$(BR2_EXTERNAL_RV_SDK_PATH)/boards/overlays/11XX"
  ```
