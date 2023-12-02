# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libwebp"
PKG_VERSION="v1.3.2"
PKG_SHA256="c2c2f521fa468e3c5949ab698c2da410f5dce1c5e99f5ad9e70e0e8446b86505"
PKG_LICENSE="GPL"
PKG_SITE="https://libjpeg-turbo.org/"
PKG_URL="https://github.com/webmproject/libwebp/archive/refs/tags/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="toolchain:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A high-speed version of libjpeg for x86 and x86-64 processors which uses SIMD."
PKG_TOOLCHAIN="configure"

pre_configure_target() {
  echo $(pwd) > /home/dev/Lakka-LibreELEC/123.log
  echo $(ls) >> /home/dev/Lakka-LibreELEC/123.log
  cd ..
  ./autogen.sh
  cd -
}
post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/bin
}
