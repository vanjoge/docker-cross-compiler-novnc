FROM dorowu/ubuntu-desktop-lxde-vnc:focal

# ENV http_proxy http://192.168.1.1:1082
# ENV https_proxy http://192.168.1.1:1082

# 合并所有包管理操作到一个RUN层
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    apt-get update -qq && \
    apt-get purge -y -qq google-chrome-stable && \
    apt-get upgrade -y -qq && \
    # Set Area and Timezone
    echo 'tzdata tzdata/Areas select Asia' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/Asia select Chongqing' | debconf-set-selections && \
    DEBIAN_FRONTEND="noninteractive" apt install -y tzdata && \
    # Install required packages for FriendlyElec's boards
    apt-get -y install texinfo git python-is-python3 && \
    # Clone and run build environment setup
    git clone https://github.com/friendlyarm/build-env-on-ubuntu-bionic && \
    chmod 755 build-env-on-ubuntu-bionic/install.sh && \
    build-env-on-ubuntu-bionic/install.sh && \
    rm -rf build-env-on-ubuntu-bionic && \
    # Clone and install repo tool
    git clone https://github.com/friendlyarm/repo && \
    cp repo/repo /usr/bin/ && \
    rm -rf repo && \
    # Install other required packages
    apt-get install -y --no-install-recommends -qq \
        software-properties-common locales \
        nano bash-completion lxtask openssh-server xdotool filezilla putty dnsutils \
        papirus-icon-theme fonts-noto-cjk fonts-noto-cjk-extra obconf lxappearance-obconf vim terminator tree rsync \
        poppler-utils shared-mime-info mime-support gitg && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # SSHD run bugfix
    mkdir -p /run/sshd && \
    # Fixing the issue: Communication error with Jack server (35) when building AOSP (Android8.1)
    sed 's/^\(jdk.tls.disabledAlgorithms=.*\)\(TLSv1, TLSv1.1, \)/\1/g' /etc/java-8-openjdk/security/java.security -i

# Customizations : remove unused, change settings, copy conf files
COPY files /