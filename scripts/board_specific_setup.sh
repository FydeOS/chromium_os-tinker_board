#!/bin/bash

image=""
loop_dev=""
mnt_dir=$(mktemp -d)
esp_mnt_dir=${mnt_dir}/tmp
uboot_tmp=/tmp/tinker-uboot.img

mount_tinker_image() {
  image=$1
  # Loop load image
  loop_dev=$(sudo /sbin/losetup -f -P -v --show ${image})
  # Mount rootfs-A
  sudo mount ${loop_dev}p3 ${mnt_dir}
  # Mount ESP
  sudo mount ${loop_dev}p12 ${esp_mnt_dir}
}

umount_tinker_image() {
  # Unload image
  sudo umount ${esp_mnt_dir}
  sudo umount ${mnt_dir}
  sudo /sbin/losetup -d ${loop_dev}

  # Clean up
  rmdir "${mnt_dir}"
}

install_tinker_kernel() {
  local uboot=${mnt_dir}/boot/tinker-uboot.img
  local uboot_conf=${mnt_dir}/boot/extlinux
  local kernel=${mnt_dir}/boot/zImage
  local dts=${mnt_dir}/boot/dts

  # Install kernel
  sudo cp -fL ${kernel} ${esp_mnt_dir}
  sudo cp -rf ${dts} ${esp_mnt_dir}
  sudo cp -rf ${uboot_conf} ${esp_mnt_dir}

  # Copy uboot image out before unload for bootloader install
  cp -fL ${uboot} ${uboot_tmp}
}

install_tinker_bootloader() {
  # Install u-boot on to disk image
  sudo dd if=${uboot_tmp} of=${image} seek=64 conv=notrunc

  # Clean up
  rm -f "${uboot_tmp}"
}

modify_console_login_art() {
  sudo sh -c "cat << EOF > ${mnt_dir}/etc/issue
Developer Console

To return to the browser, press:

  [ Ctrl ] and [ Alt ] and [ <- ]  (F1)

 ███████╗██╗   ██╗██████╗ ███████╗ ██████╗ ███████╗
 ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔═══██╗██╔════╝
 █████╗   ╚████╔╝ ██║  ██║█████╗  ██║   ██║███████╗
 ██╔══╝    ╚██╔╝  ██║  ██║██╔══╝  ██║   ██║╚════██║
 ██║        ██║   ██████╔╝███████╗╚██████╔╝███████║
 ╚═╝        ╚═╝   ╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝

EOF"
}

board_setup() {
  echo "Post-procesing disk image for Tinker specific bits"
  mount_tinker_image "$1"
  install_tinker_kernel
  modify_console_login_art
  umount_tinker_image
  install_tinker_bootloader
}

skip_blacklist_check=1
skip_test_image_content=1
