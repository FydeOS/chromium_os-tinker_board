EAPI=4

EGIT_BRANCH="4.4-cros_r59"
EGIT_REPO_URI="https://github.com/FydeOS/kernel-tinkerboard.git"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit git-2 cros-workon cros-kernel2

DESCRIPTION="Chrome OS Kernel 4.4 For Asus Tinker Board"
KEYWORDS="arm"

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	# Call git-2_src_unpack directly because cros-workon_src_unpack
	# would override EGIT_REPO_URI as CROS_GIT_HOST_URL, that is
	# https://chromium.googlesource.com
	git-2_src_unpack
}

src_configure() {
	CHROMEOS_KERNEL_CONFIG="${FILESDIR}/tinker_kernel_config"

	# Required for building uImage
	export LOADADDR=0x2000000

	cros-kernel2_src_configure
}

src_install() {
	cros-kernel2_src_install

	# Install dtb file
	BD=$(cros-workon_get_build_dir)
	insinto "/boot/dts"
	doins ${BD}/arch/arm/boot/dts/rk3288-miniarm.dtb
	doins ${BD}/arch/arm/boot/dts/rk3288-miniarm-hdmi-ddc.dtb
	doins ${BD}/arch/arm/boot/dts/rk3288-miniarm-i2c5-ddc.dtb
}
