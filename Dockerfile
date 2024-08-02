FROM rootfs-base-debian-i386
RUN dpkg --add-architecture amd64
RUN apt update
RUN apt install -y wget curl vim sudo systemd ifupdown rsyslog logrotate less bash-completion ca-certificates netbase lsb-release apt-utils gnupg2 apt-transport-https debian-keyring debian-archive-keyring
RUN wget https://github.com/PikaOS-Linux/pika-base-debian-container/raw/i386/setup.sh
RUN chmod +x ./setup.sh
RUN ./setup.sh
RUN apt update
RUN wget http://ftp.us.debian.org/debian/pool/main/d/debhelper/debhelper_13.16_all.deb -O ./debhelper.deb
RUN apt install -y libc6:amd64 ./debhelper.deb
RUN apt full-upgrade -y
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN wget https://ppa.pika-os.com/pool/main/p/pika-pbuilder/pika-pbuilder_0.2.34-101pika1_all.deb -O ./pika-pbuilder.deb
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata software-properties-common sudo devscripts git eatmydata bc cowbuilder gpg gpg-agent bison build-essential ccache cmake cpio fakeroot flex git kmod libelf-dev libncurses5-dev libssl-dev lz4 qtbase5-dev rsync schedtool wget zstd tar aptly devscripts dh-make rpm2cpio ./pika-pbuilder.deb -o Dpkg::Options::="--force-confnew"
# GTK4 Build workaround
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libdrm-dev gir1.2-gudev-1.0 libgudev-1.0-0 libgudev-1.0-dev libgbm-dev libgbm1 systemd-dev libgps-dev kirigami-addons-dev -o Dpkg::Options::="--force-confnew"
RUN apt install nodejs:amd64 -y
RUN mkdir -p /__e/node16/bin/
RUN ln -sfv /usr/bin/node /__e/node16/bin/
RUN rm -rfv ./*.deb
