FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
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
    python3 \
    python3-pip \
    whatweb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the recon script into the container
COPY Recon_Suite.sh /usr/local/bin/Recon_Suite.sh

# Make the script executable
RUN chmod +x /usr/local/bin/Recon_Suite.sh

# Set the script to run by default
ENTRYPOINT ["/usr/local/bin/Recon_Suite.sh"]
