#! /bin/bash
set -e
DIST=sid ARCH=amd64 debootstrap --arch=amd64 sid base_chroot || true
rm -rf base_chroot/debootstrap
chroot ./base_chroot /bin/bash -c "DEBIAN_FRONTEND=noninteractive apt update -y"
chroot ./base_chroot /bin/bash -c "DEBIAN_FRONTEND=noninteractive apt install -y wget curl vim sudo systemd ifupdown rsyslog logrotate less bash-completion ca-certificates netbase lsb-release apt-utils gnupg2 apt-transport-https debian-keyring debian-archive-keyring"
chroot ./base_chroot /bin/bash -c "DEBIAN_FRONTEND=noninteractive wget https://ppa.pika-os.com/pool/cockatiel/p/pika-pbuilder/pika-pbuilder_0.2.37-101pika1_all.deb -O ./pika-pbuilder.deb"
chroot ./base_chroot /bin/bash -c "DEBIAN_FRONTEND=noninteractive DEBIAN_FRONTEND=noninteractive apt-get install -y ./pika-pbuilder.deb "
chroot ./base_chroot /bin/bash -c "DEBIAN_FRONTEND=noninteractive pika-pbuilder-amd64-v3-lto-init"
cd  ./base_chroot
tar -czvf ../base_chroot.tgz ./*
