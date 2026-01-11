#! /bin/bash
set -e
DIST=sid ARCH=amd64 debootstrap --arch=amd64 sid base_chroot || true
rm -rf base_chroot/debootstrap
chroot ./base_chroot /bin/bash -c "apt-get update -y"
chroot ./base_chroot /bin/bash -c "apt-get install -y wget"
cd  ./base_chroot
tar -czvf ../base_chroot.tgz ./*
