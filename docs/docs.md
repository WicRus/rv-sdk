 # Advanced information for going deeper
 Read about Buildroot External [here](https://buildroot.org/downloads/manual/manual.html#outside-br-custom)

 ## SDK parts
 ### App
 * Contains local source files for non-mainline Buildroot packages and kernel modules
 * Contains linux kernel and uboot under developing

 ### Configs
 * [Read this](configs.md)

 ### Boards
 * [Read that](boards.md)

 ### Overrides
 * Files with overrides source paths for linux kernel and uboot
    ```bash
    # exclude/include params for rsync
    LINUX_OVERRIDE_SRCDIR_RSYNC_EXCLUSIONS= --exclude .svn --include .git
    ```
 * [Buildroot thoughts](https://buildroot.org/downloads/manual/manual.html#_using_buildroot_during_development)

 ### Packages
 * Contains config files for non-mainline Buildroot packages and kernel modules
 * For examples check Buildroot packages
 * [Buildroot thoughts](https://buildroot.org/downloads/manual/manual.html#adding-packages)

 ### Patches
 * Adding a new and inexplicable functional to Builroot packages
 * Can be patched such as both main-line and external packages
 * [Buildroot thoughts I](https://buildroot.org/downloads/manual/manual.html#_adding_project_specific_patches_and_hashes)
 * [Buildroot thoughts II](https://buildroot.org/downloads/manual/manual.html#patch-policy)

 ## Scripts
 * **sdk_cfg**\
 Base config to determine environment
 * **sdk_repo.sh**\
 Initial download repo and sdk packages\
 Manage sdk packages
 * **docker_create.sh**\
 Create docker container
 * **sdk_run.sh**\
 Run docker container with SDK
 * **sdk/setup**\
 Config selector and buildroot external initialization\
 Use inside docker container only

