FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Install base tools
RUN apt-get update && apt-get install -y \
    software-properties-common \
    python3 \
    python3-distutils \
    curl \
    wget \
    git \
    nmap \
    masscan \
    jq \
    xsltproc \
    nikto \
    dirb \
    smbclient \
    snmp \
    pandoc \
    whatweb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install pip manually (fixes missing pip in some images)
RUN curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && rm get-pip.py

# Manually install enum4linux and symlink
RUN git clone https://github.com/CiscoCXSecurity/enum4linux.git /opt/enum4linux && \
    ln -s /opt/enum4linux/enum4linux.pl /usr/local/bin/enum4linux && \
    chmod +x /usr/local/bin/enum4linux

# Install nmap-to-json converter (npm or pip based if needed)
RUN pip install xmltodict

# Copy recon script
COPY Recon_Suite.sh /usr/local/bin/Recon_Suite.sh
RUN chmod +x /usr/local/bin/Recon_Suite.sh

# Run it interactively with prompt
ENTRYPOINT ["/usr/local/bin/Recon_Suite.sh"]
