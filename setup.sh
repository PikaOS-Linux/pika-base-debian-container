#! /bin/bash

mkdir -p /etc/apt/sources.list.d
rm -rf /etc/apt/sources.list.d/*

# Clear /etc/apt/sources.list in favor of deb822 formats
tee /etc/apt/sources.list <<'EOF'
## This file is deprecated in PikaOS.
## See /etc/apt/sources.list.d/system.sources.
EOF

# Add Debian Repo
touch /etc/apt/sources.list.d/debian.sources
tee /etc/apt/sources.list.d/debian.sources <<'EOF'
X-Repolib-Name: Debian Sources
Enabled: yes
Types: deb deb-src
URIs: http://deb.debian.org/debian
Suites: sid experimental
Components: main contrib non-free non-free-firmware
X-Repolib-Default-Mirror: http://deb.debian.org/debian
Signed-by: /usr/share/keyrings/debian-archive-keyring.gpg
EOF

# Add Pika Repos
tee /etc/apt/sources.list.d/system.sources <<'EOF'
X-Repolib-Name: PikaOS System Sources
Enabled: yes
Types: deb
URIs: https://ppa.pika-os.com/
Suites: pika
Components: canary
X-Repolib-ID: system
X-Repolib-Default-Mirror: https://ppa.pika-os.com/
Signed-By: /etc/apt/keyrings/pika-keyring.gpg.key
EOF

# Add DMO Repos
tee /etc/apt/sources.list.d/dmo.sources <<'EOF'
X-Repolib-Name: Multimedia Sources
Enabled: yes
Types: deb deb-src
URIs: https://www.deb-multimedia.org
Suites: sid
Components: main non-free
X-Repolib-Default-Mirror: https://www.deb-multimedia.org/
Signed-By: /etc/apt/keyrings/deb-multimedia-keyring.gpg
EOF

# Get keyrings
mkdir -p /etc/apt/keyrings/
wget https://github.com/PikaOS-Linux/pika-base-debian-container/raw/main/pika-keyring.gpg.key -O /etc/apt/keyrings/pika-keyring.gpg.key
wget https://github.com/PikaOS-Linux/pika-base-debian-container/raw/main/deb-multimedia-keyring.gpg -O /etc/apt/keyrings/deb-multimedia-keyring.gpg

# Setup apt configration
mkdir -p /etc/apt/preferences.d/
tee /etc/apt/preferences.d/0-pika-debian-settings <<'EOF'
# Blacklist Packages from being pulled from debian experimental
Package: *libwebrtc-audio-processing* *selinux*
Pin: release a=experimental
Pin-Priority: -1

Package: *
Pin: release o=Unofficial Multimedia Packages
Pin-Priority: 550

# Give pika lowest priority because we don't want it sources overwriting
Package: *
Pin: release a=pika,c=canary
Pin-Priority: 380

Package: pika-abi-bridge* *exiv2* akonadi-mime-data libkf5akonadimime-dev libkf5akonadimime5
Pin: release a=pika,c=canary
Pin-Priority: 600
EOF

wget https://github.com/PikaOS-Linux/pika-base-debian-container/raw/main/0-debian-exp-overrides -O /etc/apt/preferences.d/0-debian-exp-overrides
