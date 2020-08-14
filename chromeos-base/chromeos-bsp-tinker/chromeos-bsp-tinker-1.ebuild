EAPI=5

inherit udev

DESCRIPTION="Asus Tinkerboad BSP package (meta package to pull in driver/tool dependencies)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="arm"

IUSE="bluetooth"

RDEPEND="
	x11-drivers/mali-rules
	chromeos-base/auto-expand-partition
	bluetooth? ( net-wireless/rtl8723bs_bt )
	sys-boot/tinker-uboot-bin
  x11-drivers/mali-rules
"
DEPEND="${RDEPEND}
  !media-libs/media-rules
"

S=$WORKDIR

src_install() {
  insinto /lib/firmware
  doins -r ${FILESDIR}/rtlwifi
  insinto "/etc"                                                                                                                                                                 │·
  doins "${FILESDIR}/cpufreq-419/cpufreq.conf"
  insinto "/etc/init"
  doins "${FILESDIR}/cpufreq-419/platform-cpusets.conf"
  doins "${FILESDIR}/udev/udev-trigger-codec.conf"
  udev_dorules "${FILESDIR}/udev/50-media.rules"
  udev_dorules "${FILESDIR}/udev/99-rk3288-ehci-persist.rules"
}
