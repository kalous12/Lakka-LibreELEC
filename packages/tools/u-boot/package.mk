# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="u-boot"
PKG_VERSION="4fd1307a000478e40da027fbd145d636a417e099"
PKG_SHA256="38c50381d8835d5bede2f1273f5b46ffab2a8ffec57a63474f08f5e2604a5ad3"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://www.denx.de/wiki/U-Boot"
PKG_URL="https://github.com/kalous12/u-boot-rockchip/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl:host pkg-config:host Python3:host swig:host rkbin"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems."

PKG_STAMP="${UBOOT_SYSTEM} ${UBOOT_TARGET}"
PKG_PATCH_DIRS="rk35xx"

[ -n "${KERNEL_TOOLCHAIN}" ] && PKG_DEPENDS_TARGET+=" gcc-${KERNEL_TOOLCHAIN}:host"

if [ -n "${UBOOT_FIRMWARE}" ]; then
  PKG_DEPENDS_TARGET+=" ${UBOOT_FIRMWARE}"
  PKG_DEPENDS_UNPACK+=" ${UBOOT_FIRMWARE}"
fi

PKG_NEED_UNPACK="${PROJECT_DIR}/${PROJECT}/bootloader"
[ -n "${DEVICE}" ] && PKG_NEED_UNPACK+=" ${PROJECT_DIR}/${PROJECT}/devices/${DEVICE}/bootloader"

post_patch() {
  if [ -n "${UBOOT_SYSTEM}" ] && find_file_path bootloader/config; then
    PKG_CONFIG_FILE="${PKG_BUILD}/configs/$(${ROOT}/${SCRIPTS}/uboot_helper ${PROJECT} ${DEVICE} ${UBOOT_SYSTEM} config)"
    if [ -f "${PKG_CONFIG_FILE}" ]; then
      cat ${FOUND_PATH} >> "${PKG_CONFIG_FILE}"
    fi
  fi
}

make_target() {
  # U-Boot needs host openssl for tools - make sure it finds right one
  # setup_pkg_config_host is required
  setup_pkg_config_host

  if [ -z "${UBOOT_SYSTEM}" ]; then
    echo "UBOOT_SYSTEM must be set to build an image"
    echo "see './scripts/uboot_helper' for more information"
  else
    [ "${BUILD_WITH_DEBUG}" = "yes" ] && PKG_DEBUG=1 || PKG_DEBUG=0
    DEBUG=${PKG_DEBUG} CROSS_COMPILE="${TARGET_KERNEL_PREFIX}" LDFLAGS="" ARCH=arm make mrproper
    [ -n "${UBOOT_FIRMWARE}" ] && find_file_path bootloader/firmware && . ${FOUND_PATH}

    if [ "${DEVICE}" = "RK3568" ]; then
      PKG_RKBIN="$(get_build_dir rkbin)"
      cp ${PKG_RKBIN}/bin/rk35/rk3568_ddr_1560MHz_v1.18.bin ddr.bin
      cp ${PKG_RKBIN}/bin/rk35/rk3568_bl31_v1.43.elf bl31.elf
      cp ${PKG_RKBIN}/bin/rk35/rk3568_bl32_v2.10.bin tee.bin
      UBOOT_MAKE_FLAGS="BL31=bl31.elf"
    fi 

    if [ "${DEVICE}" = "RK3588" ]; then
      PKG_RKBIN="$(get_build_dir rkbin)"
      cp ${PKG_RKBIN}/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.12.bin ddr.bin
      cp ${PKG_RKBIN}/bin/rk35/rk3588_bl31_v1.40.elf bl31.elf
      cp ${PKG_RKBIN}/bin/rk35/rk3588_bl32_v1.13.bin tee.bin
      UBOOT_MAKE_FLAGS="BL31=bl31.elf"
    fi 

    DEBUG=${PKG_DEBUG} CROSS_COMPILE="${TARGET_KERNEL_PREFIX}" LDFLAGS="" ARCH=arm make HOSTCC="${HOST_CC}" HOSTCFLAGS="-I${TOOLCHAIN}/include" HOSTLDFLAGS="${HOST_LDFLAGS}" $(${ROOT}/${SCRIPTS}/uboot_helper ${PROJECT} ${DEVICE} ${UBOOT_SYSTEM} config)
    CROSS_COMPILE="${TARGET_KERNEL_PREFIX}" LDFLAGS="" ARCH=arm  make ${UBOOT_TARGET} ${UBOOT_MAKE_FLAGS} spl/u-boot-spl.bin u-boot.dtb u-boot.itb
    
    if [ "${DEVICE}" = "RK3568" ]; then
    tools/mkimage -n rk3568 -T rksd -d ddr.bin:spl/u-boot-spl.bin idbloader.img
    fi

    if [ "${DEVICE}" = "RK3588" ]; then
    ./tools/mkimage -n rk3588 -T rksd -d ddr.bin:spl/u-boot-spl.bin idbloader.img
    fi
  fi
}

#_python_sysroot="${TOOLCHAIN}" _python_prefix=/ _python_exec_prefix=/ HOSTSTRIP="true"  CONFIG_MKIMAGE_DTC_PATH="scripts/dtc/dtc"
makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/bootloader

    # Only install u-boot.img et al when building a board specific image
    if [ -n "${UBOOT_SYSTEM}" ]; then
      find_file_path bootloader/install && . ${FOUND_PATH}
    fi

    # Always install the update script
    find_file_path bootloader/update.sh && cp -av ${FOUND_PATH} ${INSTALL}/usr/share/bootloader

    # Always install the canupdate script
    if find_file_path bootloader/canupdate.sh; then
      cp -av ${FOUND_PATH} ${INSTALL}/usr/share/bootloader
      sed -e "s/@PROJECT@/${DEVICE:-${PROJECT}}/g" \
          -i ${INSTALL}/usr/share/bootloader/canupdate.sh
    fi
}
