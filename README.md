 # Buildroot external SDK for RV1126 RV1106 RV1126B

 Alternative view for creating SDK based on [Buildroot](https://buildroot.org)

 ## Express guide

 ### Preparation
 * [Install docker](https://docs.docker.com/engine/install/)
 * Clone this repository and run terminal inside
 * Create docker container:
    ```bash
    ./docker_create.sh
    ```

 ### Download kernels and uboots
 * Get [Repo](https://gerrit.googlesource.com/git-repo) and init SDK
    ```bash
    ./sdk_repo.sh init
    ```

 ### Run docker container
 * Easy
    ```bash
    ./sdk_bash.sh
    ```

 #### Select config
 * 1126  use externel precompile toolchain
 * 1126b compile internal toolchain on build
 * 1106  compile external toolchain first
    ```bash
    source setup 1106_sdk
    make sdk
    ```
 * use **setup** script:
    ```bash
    source setup
    available:
      0. 1106_sdk
      1. 1106_sdmmc
      2. 1106_spi_nand
      3. 1126b_sdmmc
      4. 1126b_spi_nand
      5. 1126_sdmmc
      6. 1126_spi_nand
    please select index:
    ```

 #### Build it
 * So easy
    ```bash
    make
    ```

 #### Burn ROMS
 * For spi-nand use *upgrade_tool*
    ```bash
    ./sdk/board/rockchip_tools/upgrade_tool/upgrade_tool UF sdk/br.out/11XX/images/rv11XX_update.img
    ```
  * For sdmmc /dev/sdX
    ```bash
    dd if=sdk/br.out/11XX/images/sdcard.img of=/dev/sdX bs=1M && sync && sgdisk -e /dev/sdX
    ```

 ## [Read docs](docs/docs.md)
 ## [Edit configs](/sdk/configs/)
 ## [Repeat](#Express-guide)
