#! /bin/bash
set -e
DIST=sid ARCH=i386 debootstrap --arch=i386 sid base_chroot || true
rm -rf base_chroot/debootstrap
#chroot ./base_chroot /bin/dash -c "DEBIAN_FRONTEND=noninteractive apt-get -y update"
cd  ./base_chroot
tar -czvf ../base_chroot.tgz ./*
