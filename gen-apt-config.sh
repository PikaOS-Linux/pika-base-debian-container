#! /bin/bash
echo -e "Package: *\nPin: release a=experimental\nPin-Priority: 600" > /etc/apt/preferences.d/0-pika-debian-settings
chmod +x ./get-bin-name-from-src.sh
chmod +x ./gen-apt-config.py
apt-get update -y
./gen-apt-config.py