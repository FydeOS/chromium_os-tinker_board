# Copyright (c) 2017 Flint Innovations Limited. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Auto expand stateful partition on first boot"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/gptfdisk[-ncurses]
"

S=${WORKDIR}

src_install() {
	# Install upstart service
	insinto "/etc/init"
	doins ${FILESDIR}/auto-expand-partition.conf
}
