EAPI=4

EGIT_BRANCH="release"
EGIT_REPO_URI="https://github.com/TinkerBoard/debian_u-boot"
EGIT_COMMIT="135bc937d6e0d5d2b4878219c46f895c172867bd"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit git-2 cros-workon toolchain-funcs flag-o-matic

DESCRIPTION="U-Boot boot laoder For Asus Tinker Board"
KEYWORDS="-* arm"
SLOT="0"
LICENSE="GPL-2"

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	# Call git-2_src_unpack directly because cros-workon_src_unpack
	# would override EGIT_REPO_URI as CROS_GIT_HOST_URL, that is
	# https://chromium.googlesource.com
	git-2_src_unpack
}

umake() {
  # Add `ARCH=` to reset ARCH env and let U-Boot choose it.
  ARCH= emake "${COMMON_MAKE_FLAGS[@]}" "$@"
}

src_configure() {
  export LDFLAGS=$(raw-ldflags)
  tc-export BUILD_CC
  CROSS_PREFIX="${CHOST}-"
  COMMON_MAKE_FLAGS=(
      "CROSS_COMPILE=${CROSS_PREFIX}"
      HOSTSTRIP=true
      -k
      )
  umake distclean
	umake tinker-rk3288_defconfig
}

src_compile() {
	umake all
	./tools/mkimage -n rk3288 -T rksd -d spl/u-boot-spl-dtb.bin tinker-uboot.img
	cat u-boot-dtb.bin >> tinker-uboot.img
}

src_install() {
	# Install boot loader image
	insinto "/boot"
	doins ${S}/tinker-uboot.img

	# Install configuration file
	insinto "/boot/extlinux"
	doins ${FILESDIR}/extlinux.conf
}
