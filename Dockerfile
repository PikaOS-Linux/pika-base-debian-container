# Debian Sid with expermintal, pika and dmo repos
# Bump for rebuild on 07/01/2024 18:18 UTC +3
FROM debian:sid
RUN apt update
RUN apt install -y wget curl vim sudo systemd ifupdown rsyslog logrotate less bash-completion ca-certificates netbase lsb-release apt-utils gnupg2 apt-transport-https debian-keyring debian-archive-keyring
RUN wget https://github.com/PikaOS-Linux/pika-base-debian-container/raw/main/setup.sh
RUN chmod +x ./setup.sh
RUN ./setup.sh
RUN apt update
RUN apt full-upgrade -y
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN wget https://ppa.pika-os.com/pool/main/p/pika-pbuilder/pika-pbuilder_0.2.11-101pika1_all.deb
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata software-properties-common sudo git bc cowbuilder gpg gpg-agent bison build-essential ccache cmake cpio fakeroot flex git kmod libelf-dev libncurses5-dev libssl-dev lz4 qtbase5-dev rsync schedtool wget zstd tar aptly devscripts dh-make rpm2cpio ./pika-pbuilder_0.2.11-101pika1_all.deb -o Dpkg::Options::="--force-confnew"
