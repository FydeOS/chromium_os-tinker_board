# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="5"

DESCRIPTION="empty project"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_install() {
  # Install boot loader image
  insinto "/boot"
  doins ${FILESDIR}/tinker-uboot.img

  # Install configuration file
  insinto "/boot/extlinux"
  doins ${FILESDIR}/extlinux.conf
}
