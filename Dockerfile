FROM dorowu/ubuntu-desktop-lxde-vnc:focal

# ENV http_proxy http://192.168.1.1:1082
# ENV https_proxy http://192.168.1.1:1082

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN apt-get update -qq \
	&&  apt-get purge -y -qq google-chrome-stable \
	&&  apt-get upgrade -y -qq

# Set Area and Timezone
RUN echo 'tzdata tzdata/Areas select Asia' | debconf-set-selections
RUN echo 'tzdata tzdata/Zones/Asia select Chongqing' | debconf-set-selections
RUN DEBIAN_FRONTEND="noninteractive" apt install -y tzdata

# Install required packages for FriendlyElec's boards
RUN apt-get -y install texinfo git
RUN git clone https://github.com/friendlyarm/build-env-on-ubuntu-bionic
RUN chmod 755 build-env-on-ubuntu-bionic/install.sh
RUN build-env-on-ubuntu-bionic/install.sh
RUN rm -rf build-env-on-ubuntu-bionic
RUN apt-get -y install python-is-python3
RUN git clone https://github.com/friendlyarm/repo
RUN cp repo/repo /usr/bin/

# Install other required packages
RUN 	apt-get install -y --no-install-recommends -qq \
	software-properties-common locales \
	nano bash-completion lxtask openssh-server xdotool filezilla putty dnsutils \
	papirus-icon-theme fonts-noto-cjk fonts-noto-cjk-extra obconf lxappearance-obconf vim terminator tree rsync \
    poppler-utils shared-mime-info mime-support gitg
RUN		apt-get clean

# Customizations : remove unused, change settings, copy conf files
COPY files /

# SSHD run bugfix
RUN mkdir -p /run/sshd

# Fixing the issue: Communication error with Jack server (35) when building AOSP (Android8.1)
RUN sed 's/^\(jdk.tls.disabledAlgorithms=.*\)\(TLSv1, TLSv1.1, \)/\1/g' /etc/java-8-openjdk/security/java.security -i
