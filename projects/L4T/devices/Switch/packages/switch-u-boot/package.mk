PKG_NAME="switch-u-boot"
PKG_VERSION="6cdb578a09d6a55a45b01ca9f333e0d13314cd48"
PKG_GIT_CLONE_BRANCH="linux-norebase"
PKG_DEPENDS_TARGET="toolchain gcc-linaro-aarch64-linux-gnu:host gcc-linaro-arm-linux-gnueabi:host Python3 Python3:host swig:host"
PKG_SITE="https://gitlab.com/switchroot/switch-uboot"
PKG_URL="${PKG_SITE}.git"
PKG_CLEAN="switch-coreboot"
PKG_TOOLCHAIN="make"

make_target() {
  export PATH=${TOOLCHAIN}/lib/gcc-linaro-aarch64-linux-gnu/bin/:${PATH}
  export PATH=${TOOLCHAIN}/lib/gcc-linaro-arm-linux-gnueabi/bin/:${PATH}
  OLD_CROSS_COMPILE=${CROSS_COMPILE}
  export CROSS_COMPILE=aarch64-linux-gnu-
  
  make nintendo-switch_defconfig
  make tools-only
  
  export CROSS_COMPILE=${OLD_CROSS_COMPILE}
}

makeinstall_target() {
  #mkdir -p ${BUILD}/switch-boot
    #cp -v ${PKG_BUILD}/u-boot.elf ${BUILD}/switch-boot
  
  mkdir -p ${TOOLCHAIN}/bin
    cp -v tools/mkimage ${TOOLCHAIN}/bin
}