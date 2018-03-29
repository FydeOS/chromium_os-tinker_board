EAPI=4

EGIT_BRANCH="master"
EGIT_REPO_URI="git://git.denx.de/u-boot.git"
EGIT_COMMIT="4f58002013ba1e89eb8fda015ff495bd37cd4016"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit git-2 cros-workon

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

src_configure() {
	emake tinker-rk3288_defconfig
}

src_compile() {
	export ARCH=arm
	export CROSS_COMPILE=armv7a-cros-linux-gnueabi-
	emake
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
