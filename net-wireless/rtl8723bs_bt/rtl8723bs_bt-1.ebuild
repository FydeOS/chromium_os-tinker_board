EAPI=4
EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/FydeOS/rtl8723bs_bt.git"
CROS_WORKON_BLACKLIST="1"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit git-2 cros-workon

DESCRIPTION="Necessary tools and firmware for RTL8723bs bluetooth"
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

src_compile() {
	emake
}

src_install() {
	# Install bin
	dobin rtk_hciattach

	# Install firmware
	insinto "/lib/firmware/rtl_bt"
	doins ${S}/rtlbt_config
	doins ${S}/rtlbt_fw

	# Install upstart service
	insinto "/etc/init"
	doins ${FILESDIR}/rtk_hciattach.conf
}
