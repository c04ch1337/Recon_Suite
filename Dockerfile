FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    python3 \
    python3-pip \
    nmap \
    masscan \
    jq \
    xsltproc \
    nikto \
    dirb \
    smbclient \
    snmp \
    git \
    curl \
    wget \
    pandoc \
    whatweb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify and fix pip if broken or missing
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3

# Install enum4linux manually
RUN git clone https://github.com/CiscoCXSecurity/enum4linux.git /opt/enum4linux && \
    ln -s /opt/enum4linux/enum4linux.pl /usr/local/bin/enum4linux && \
    chmod +x /usr/local/bin/enum4linux

# Copy in the Recon script
COPY Recon_Suite.sh /usr/local/bin/Recon_Suite.sh
RUN chmod +x /usr/local/bin/Recon_Suite.sh

ENTRYPOINT ["/usr/local/bin/Recon_Suite.sh"]
