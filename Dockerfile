# Debian Sid with expermintal, pika and dmo repos
# Bump for rebuild on 07/01/2024 18:18 UTC +3
FROM rootfs-base-debian
RUN apt update
RUN apt install -y wget curl vim sudo systemd ifupdown rsyslog logrotate less bash-completion ca-certificates netbase lsb-release apt-utils gnupg2 apt-transport-https debian-keyring debian-archive-keyring
RUN wget https://github.com/PikaOS-Linux/pika-base-debian-container/raw/main/setup.sh
RUN chmod +x ./setup.sh
RUN ./setup.sh
RUN apt update
RUN apt full-upgrade -y
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN wget https://ppa.pika-os.com/pool/cockatiel/p/pika-pbuilder/pika-pbuilder_0.2.37-101pika1_all.deb -O ./pika-pbuilder.deb
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata software-properties-common sudo nodejs npm devscripts git eatmydata bc cowbuilder gpg gpg-agent bison build-essential ccache cmake cpio fakeroot flex git kmod libelf-dev libncurses5-dev libssl-dev lz4 qtbase5-dev rsync schedtool wget zstd tar aptly devscripts dh-make rpm2cpio ./pika-pbuilder.deb -o Dpkg::Options::="--force-confnew"
# Debian missing Build workaround
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libdrm-dev gir1.2-gudev-1.0 libgudev-1.0-0 libgudev-1.0-dev libgbm-dev libgbm1 libsystemd-dev systemd-dev libgps-dev kirigami-addons-dev kirigami2-dev libkirigami-dev qttools5-dev libqt5core5t64 -o Dpkg::Options::="--force-confnew"
