#! /bin/bash
set -e
DIST=sid ARCH=amd64 debootstrap --arch=amd64 sid base_chroot || true
rm -rf base_chroot/debootstrap
chroot ./base_chroot /bin/bash -c "apt-get update -y"
chroot ./base_chroot /bin/bash -c "apt-get install -y wget"
chroot ./base_chroot /bin/bash -c "wget https://ppa.pika-os.com/pool/cockatiel/p/pika-pbuilder/pika-pbuilder_0.2.37-101pika1_all.deb -O ./pika-pbuilder.deb"
chroot ./base_chroot /bin/bash -c "apt-get install -y ./pika-pbuilder.deb "
chroot ./base_chroot /bin/bash -c "pika-pbuilder-amd64-v3-lto-init"
cd  ./base_chroot
tar -czvf ../base_chroot.tgz ./*
