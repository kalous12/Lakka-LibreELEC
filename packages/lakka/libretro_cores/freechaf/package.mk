PKG_NAME="freechaf"
PKG_VERSION="1da54f014fd590313b0ad5871cf8b9eaa87ecf9f"
PKG_LICENSE="GPL3"
PKG_SITE="https://github.com/libretro/FreeChaF"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Fairchild ChannelF Libretro core"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
    cp -v freechaf_libretro.so ${INSTALL}/usr/lib/libretro/
}