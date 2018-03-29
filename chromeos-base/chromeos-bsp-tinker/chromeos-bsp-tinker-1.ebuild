EAPI=4

DESCRIPTION="Asus Tinkerboad BSP package (meta package to pull in driver/tool dependencies)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="arm"

IUSE="bluetooth"

RDEPEND="
	x11-drivers/mali-rules
	chromeos-base/auto-expand-partition
	bluetooth? ( net-wireless/rtl8723bs_bt )
	sys-boot/tinker-uboot
"
DEPEND="${RDEPEND}"
