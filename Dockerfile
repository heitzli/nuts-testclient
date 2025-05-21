FROM ubuntu
ARG S6_OVERLAY_VERSION=3.1.5.0

RUN useradd -m -d /home/admin -s /bin/bash admin
RUN mkdir -p /run/sshd && \
    apt-get update && \
    apt-get install -y sudo && \
    usermod -aG sudo admin && \
    mkdir -p /etc/sudoers.d && \
    echo "admin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/admin && \
    chmod 0440 /etc/sudoers.d/admin
ENV ADMIN_PASSWORD="admin"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    xz-utils \
    python3 \
    python3-pip \
    telnet \
    tcpdump \
    htop \
    nmap \
    net-tools \
    curl \
    wget \
    vim \
    iperf3 \
    dnsutils \
    tshark \
    iproute2 \
    iputils-ping \
    isc-dhcp-client \
    apache2 \
    traceroute \
    git \
    netcat-openbsd \
    openssh-server \
    snmp \
    snmpd \
    wpasupplicant \
    dhcping \
    jc \
    dsniff \
    ethtool \
    fping 

RUN curl -sSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz | tar -Jxpf - -C /  && \
    curl -sSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-i686.tar.xz | tar -Jxpf - -C /
ADD s6-rc.d /etc/s6-overlay/s6-rc.d
ADD setup_sshd.sh setup_sshd.sh

ENTRYPOINT ["/init"]


# see all original env vars in all processes
ENV S6_KEEP_ENV=1

EXPOSE 22 

# USER admin

CMD [ "/bin/bash" ]