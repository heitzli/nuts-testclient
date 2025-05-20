FROM ubuntu
ARG S6_OVERLAY_VERSION=3.1.5.0

RUN useradd -m -d /home/user -s /bin/bash user
RUN mkdir -p /run/sshd && \
    usermod -aG sudo user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d && \
    chmod 0440 /etc/sudoers.d 
ENV ADMIN_PASSWORD="user"

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
    #netcat \
    openssh-server \
    snmp \
    snmpd \
    wpasupplicant \
    dhcping \
    jc \
    dsniff \
    ethtool \
    fping 

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN git clone https://github.com/heitzli/arp-spoofing.git /home/user/arp-spoofing
#RUN cp /home/user/arp-spoofing/spoofer.py /home/user
#RUN rm -rf arp-spoofing
WORKDIR /home/user/arp-spoofing
RUN uv sync
WORKDIR /

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