# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="rkmpp"
PKG_VERSION="93b1cd14f2ffed3ab2e520aa4aaa557061f3d5a3"
PKG_SHA256="70a067049551fb2a5edff503cb23bafde4eaa8f5e35e77a4cbf75276fe023d67"
PKG_ARCH="arm aarch64"
PKG_LICENSE="APL"
PKG_SITE="https://github.com/rockchip-linux/mpp"
PKG_URL="https://github.com/rockchip-linux/mpp/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libdrm"
PKG_LONGDESC="rkmpp: Rockchip Media Process Platform (MPP) module"

# if [ "$DEVICE" = "RK3328" -o "$DEVICE" = "RK3399" -o "$DEVICE" = "RK3568" ]; then
#   PKG_ENABLE_VP9D="ON"
# else
#   PKG_ENABLE_VP9D="OFF"
# fi

PKG_CMAKE_OPTS_TARGET="-DRKPLATFORM=ON\
                       -DHAVE_DRM=ON"
